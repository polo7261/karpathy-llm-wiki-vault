#!/usr/bin/env python3
"""偵測檔案是否含簡體字，逐「字元」判斷。

用法：detect-simplified.py <file>...
輸出：每行 `<路徑>\t<偵測到的簡體字>`；都乾淨則無輸出。
退出碼：0 = 都乾淨，1 = 有檔案含簡體，2 = 執行錯誤。

為什麼不能只用「opencc 轉一次看有沒有變」
──────────────────────────────────────
兩個坑，這支程式都繞開了：

1. s2t 是「一簡對多繁」時會挑錯的表，對**已經正確的繁體**也會想動手：
       台灣正體 → 臺灣正體      太陽系 → 太陽繫      干擾 → 幹擾
   若把「有改動」直接當成「含簡體」，正確的繁體檔案會被誤判，
   上層腳本就會對它做破壞性重轉（腳本→指令碼、文件→檔案）。
   → 解法：只看**被改動的字元**，並扣掉 tw-ambiguous.txt 列出的歧義字。

2. 整份文字餵給 opencc 時，詞組表(STPhrases)會做長度不等的替換，
   而且 opencc 從 stdin 讀取時會吃掉結尾換行，導致無法逐字對齊。
   → 解法：不整份餵。把文中**不重複的漢字**每字一行餵進去，
     詞組表無從跨行作用，回來的每一行就是該字的純字元級轉換結果。
"""

import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
AMBIGUOUS_FILE = SCRIPT_DIR / "tw-ambiguous.txt"

# 漢字範圍：基本區 + 擴充 A + 相容表意文字。
# 只探測漢字，避免把 emoji、標點、變體選擇符捲進來。
def is_han(c: str) -> bool:
    return (
        "一" <= c <= "鿿"
        or "㐀" <= c <= "䶿"
        or "豈" <= c <= "﫿"
    )


def load_ambiguous() -> set[str]:
    """讀取歧義字清單；每行 # 之後為註解，空白忽略。"""
    if not AMBIGUOUS_FILE.exists():
        sys.exit(f"錯誤：找不到 {AMBIGUOUS_FILE}")
    chars: set[str] = set()
    for line in AMBIGUOUS_FILE.read_text(encoding="utf-8").splitlines():
        chars.update(c for c in line.split("#", 1)[0] if not c.isspace())
    return chars


def probe(chars: list[str]) -> list[str]:
    """每字一行餵給 opencc s2t，取得純字元級的轉換結果。"""
    try:
        r = subprocess.run(
            ["opencc", "-c", "s2t.json"],
            input="\n".join(chars),
            capture_output=True, text=True, check=True,
        )
    except FileNotFoundError:
        sys.exit("錯誤：找不到 opencc，請先安裝（brew install opencc）")
    except subprocess.CalledProcessError as e:
        sys.exit(f"錯誤：opencc 執行失敗：{e.stderr.strip()}")
    return r.stdout.split("\n")


def main() -> int:
    paths = sys.argv[1:]
    if not paths:
        sys.exit("用法：detect-simplified.py <file>...")

    ambiguous = load_ambiguous()

    # 一次收集所有檔案的漢字，只呼叫 opencc 一次。
    texts: dict[str, str] = {}
    for p in paths:
        try:
            texts[p] = Path(p).read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError) as e:
            print(f"跳過 {p}：{e}", file=sys.stderr)

    all_chars = sorted({c for t in texts.values() for c in t if is_han(c)})
    if not all_chars:
        return 0

    converted = probe(all_chars)
    if len(converted) != len(all_chars):
        sys.exit(f"錯誤：opencc 回傳 {len(converted)} 行，預期 {len(all_chars)} 行")

    # 簡體字 = 純字元轉換下會被改動、且不在歧義字清單內者
    simplified = {a for a, b in zip(all_chars, converted) if a != b} - ambiguous

    found = False
    for p, t in texts.items():
        hits = {c for c in t if c in simplified}
        if hits:
            found = True
            print(f"{p}\t{''.join(sorted(hits))}")
    return 1 if found else 0


if __name__ == "__main__":
    sys.exit(main())
