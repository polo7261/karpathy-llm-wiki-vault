#!/usr/bin/env bash
#
# 簡體 → 繁體（台灣正體）轉換與驗證
#
# 用途：本 vault fork 自簡體上游。每次從 upstream 拉進新內容後重跑此腳本，
#       就能把新內容轉成台灣正體，而不必手動解 merge 衝突。
#
# 用法：
#   ./scripts/to-traditional.sh              # 轉換 + 修正 + 驗證
#   ./scripts/to-traditional.sh --check      # 只檢查不修改（有待辦則 exit 1，可用於 CI）
#   ./scripts/to-traditional.sh wiki/ CLAUDE.md   # 只處理指定路徑
#
# 相依：opencc（brew install opencc）、python3
#
# ── 為什麼腳本要長這樣 ────────────────────────────────────────
#
# ⚠ 關鍵陷阱：OpenCC s2twp 對「已經是繁體」的內容並不冪等。
#    無條件重跑會造成兩種傷害：
#      1. 把 tw-fixups.tsv 修好的詞改回誤譯
#      2. 把正確的「文件(document)」誤轉成「檔案(file)」、「腳本」→「指令碼」
#    因此本腳本**只對偵測到含簡體字的檔案**跑 s2twp，
#    已是繁體的檔案直接跳過 —— 這讓整個流程冪等。
#    偵測是否含簡體交給 detect-simplified.py（逐字元判斷，見該檔說明）。
#
# 四個檔案各司其職：
#   to-traditional.sh      本檔：流程與驗證
#   detect-simplified.py   偵測檔案是否含簡體字（安全關鍵：誤判會導致破壞性重轉）
#   tw-fixups.tsv          s2twp 詞彙表在本庫語境下的已知誤轉，轉換後套用
#   tw-ambiguous.txt       偵測用的繁簡共用歧義字清單

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_DIR="$REPO_ROOT/scripts"
DETECTOR="$SCRIPT_DIR/detect-simplified.py"
FIXUPS="$SCRIPT_DIR/tw-fixups.tsv"
CONFIG="s2twp.json"
CHECK_ONLY=0
TARGETS=()

for arg in "$@"; do
  case "$arg" in
    --check) CHECK_ONLY=1 ;;
    -h|--help) sed -n '2,12p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) TARGETS+=("$arg") ;;
  esac
done
[ ${#TARGETS[@]} -eq 0 ] && TARGETS=("$REPO_ROOT")

command -v opencc  >/dev/null || { echo "錯誤：找不到 opencc，請先安裝（brew install opencc）"; exit 1; }
command -v python3 >/dev/null || { echo "錯誤：找不到 python3"; exit 1; }
for f in "$DETECTOR" "$FIXUPS"; do
  [ -f "$f" ] || { echo "錯誤：找不到 $f"; exit 1; }
done

collect_files() {
  find "${TARGETS[@]}" -name .git -prune -o -type f -name '*.md' -print0
}

# 回傳含簡體字的檔案清單（每行一個路徑）
list_simplified() {
  collect_files | xargs -0 python3 "$DETECTOR" 2>/dev/null | cut -f1 || true
}

# ── 1. 內容轉換（只轉含簡體的檔案）────────────────────────────
echo "→ 掃描簡體內容…"
todo="$(list_simplified)"
count=0
misdetected=0
if [ -n "$todo" ]; then
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    count=$((count + 1))
    if [ "$CHECK_ONLY" -eq 1 ]; then
      echo "  [待轉換] ${f#"$REPO_ROOT"/}"
    else
      # 安全保險：若這次轉換沒有真的消除任何簡體字，代表是偵測誤判
      # （某個正確的繁體字被當成簡體），此時 s2twp 只會造成破壞
      # —— 腳本→指令碼、文件→檔案。偵測到就還原，不留下損壞的檔案。
      before="$(python3 "$DETECTOR" "$f" 2>/dev/null | cut -f2 || true)"
      cp "$f" "$f.bak"
      opencc -c "$CONFIG" -i "$f" -o "$f.tw" || { echo "轉換失敗：$f"; rm -f "$f.tw" "$f.bak"; exit 1; }
      mv "$f.tw" "$f"
      after="$(python3 "$DETECTOR" "$f" 2>/dev/null | cut -f2 || true)"
      if [ "$before" = "$after" ]; then
        mv "$f.bak" "$f"
        echo "  ⚠ 跳過 ${f#"$REPO_ROOT"/}：偵測誤判（字元「${before}」其實是正確的繁體），已還原"
        echo "     請把該字加進 scripts/tw-ambiguous.txt"
        misdetected=$((misdetected + 1))
      else
        rm -f "$f.bak"
        echo "  轉換 ${f#"$REPO_ROOT"/}"
      fi
    fi
  done <<< "$todo"
else
  echo "  （無簡體內容，跳過）"
fi

# ── 2. 套用誤轉修正表 ─────────────────────────────────────────
echo "→ 套用誤轉修正…"
fixed=0
while IFS=$'\t' read -r wrong right _note; do
  [[ -z "${wrong// }" || "$wrong" == \#* ]] && continue
  hits="$(grep -rlF --include='*.md' "$wrong" "${TARGETS[@]}" 2>/dev/null || true)"
  [ -z "$hits" ] && continue
  n="$(printf '%s\n' "$hits" | wc -l | tr -d ' ')"
  if [ "$CHECK_ONLY" -eq 1 ]; then
    echo "  [待修] $wrong → ${right}（${n} 個檔案）"
  else
    printf '%s\n' "$hits" | while IFS= read -r f; do
      WRONG="$wrong" RIGHT="$right" perl -i -pe 's/\Q$ENV{WRONG}\E/$ENV{RIGHT}/g' "$f"
    done
    echo "  修正 $wrong → ${right}（${n} 個檔案）"
  fi
  fixed=$((fixed + n))
done < "$FIXUPS"
[ "$fixed" -eq 0 ] && echo "  （無需修正）"

# ── 3. 簡體檔名更名 ───────────────────────────────────────────
echo "→ 檢查簡體檔名…"
renamed=0
while IFS= read -r -d '' f; do
  base="$(basename "$f")"
  newbase="$(printf '%s' "$base" | opencc -c "$CONFIG")"
  [ "$base" = "$newbase" ] && continue
  renamed=$((renamed + 1))
  if [ "$CHECK_ONLY" -eq 1 ]; then
    echo "  [待更名] $base → $newbase"
  else
    new="$(dirname "$f")/$newbase"
    if git -C "$REPO_ROOT" ls-files --error-unmatch "$f" >/dev/null 2>&1; then
      git -C "$REPO_ROOT" mv "$f" "$new"
    else
      mv "$f" "$new"
    fi
    echo "  更名 $base → $newbase"
    echo "  ⚠ 請確認其他檔案對此檔名的引用（正文與 frontmatter sources:）已一併轉換"
  fi
done < <(collect_files)
[ "$renamed" -eq 0 ] && echo "  （無簡體檔名）"

# ── 4. 驗證 ───────────────────────────────────────────────────
echo "→ 驗證…"
fail=0

# 4a. 簡體殘留
remain="$(list_simplified)"
if [ -n "$remain" ]; then
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    echo "  ✗ 仍有簡體殘留：${f#"$REPO_ROOT"/}"
    fail=1
  done <<< "$remain"
  echo "     （若經人工確認是誤報，把該字加進 scripts/tw-ambiguous.txt）"
fi

# 4b. frontmatter 完整性
while IFS= read -r -d '' f; do
  head -1 "$f" | grep -q '^---$' || continue
  if [ "$(grep -c '^---$' "$f")" -lt 2 ]; then
    echo "  ✗ frontmatter 未閉合：${f#"$REPO_ROOT"/}"
    fail=1
  fi
done < <(collect_files)

# 4c. code fence 配對（警告而非失敗：上游本來就有不成對的檔案，
#     修正它不屬於本腳本職責，但轉換若弄壞了格式應該要看得見）
while IFS= read -r -d '' f; do
  n="$(grep -c '^```' "$f" || true)"
  [ $((n % 2)) -eq 0 ] || echo "  ⚠ code fence 不成對（${n} 個）：${f#"$REPO_ROOT"/}"
done < <(collect_files)

# 4d. 雙鏈斷鏈統計（參考值：轉換前後應相同，數字變動代表轉換弄斷了連結）
broken="$(grep -rhoE '\[\[[^]|#]*' --include='*.md' "${TARGETS[@]}" 2>/dev/null | sed 's/\[\[//' | sort -u | while read -r t; do
  [ -z "$t" ] && continue
  find "$REPO_ROOT" -name .git -prune -o \( -name "$t.md" -o -name "$t" \) -print 2>/dev/null | grep -q . || echo "$t"
done | wc -l | tr -d ' ')"
echo "  ℹ 雙鏈斷鏈數：${broken}（多為模板佔位符與未建頁面；轉換前後應相同）"

if [ "$fail" -ne 0 ]; then
  echo "✗ 驗證未通過"
  exit 1
fi
echo "✓ 驗證通過"

if [ "$misdetected" -gt 0 ]; then
  echo "⚠ 有 ${misdetected} 個檔案因偵測誤判被跳過，請維護 scripts/tw-ambiguous.txt"
fi

if [ "$CHECK_ONLY" -eq 1 ] && [ $((count + fixed + renamed)) -gt 0 ]; then
  echo "✗ 有待處理項目，請執行不帶 --check 的版本"
  exit 1
fi
