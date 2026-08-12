# LLM Wiki 知識庫

本專案是一個基於 [Karpathy 的 LLM Wiki 理念](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 構建的 Obsidian 知識庫。

## 核心理念

將碎片化的資訊編譯成**結構化、高度相互連結**的知識網路，便於 AI 輔助學習和研究。

## 目錄結構

```

🏛️ 你的知識庫資料夾 (LLM-Wiki-Vault)
├── 🖼️ assets/                   ← 統一媒體資源層：存放圖片、PDF、附件（Obsidian設定附件路徑至此）
│
├── 📥 raw/                      ← 原始資料收件箱（事實層：內容不可改，處理後可移至 archive）
│   ├── 📄 01-articles/          ← 網頁剪藏、技術文章 (.md)
│   ├── 🎓 02-papers/            ← 論文、深度研報、PDF文件
│   ├── 🎙️ 03-transcripts/       ← 影片/播客轉錄文本、會議記錄
│   ├── 💡 04-meeting_notes/     ← 頭腦風暴或會議紀要等
│   └── 🗃️ 09-archive/           ← 已歸檔區：`/ingest` 執行成功後，原始檔自動移動至此
│
├── 🧠 wiki/                     ← 知識編譯輸出層（LLM 擁有完全寫權限，人類閱讀層）
│   ├── 📑 index.md              ← 全域內容字典：記錄所有 wiki 頁面及其一句話索引
│   ├── 📜 log.md                ← 行為流水線：以 Grep-friendly 格式記錄 ingest/query 歷史
│   ├── 🏗️ concepts/             ← 抽象層：方法論、架構模式、第一性原理 
│   ├── 👥 entities/             ← 實體層：人名、公司、工具軟體、專案 
│   ├── 🔍 sources/              ← 摘要層：針對 raw 檔案的一對一核心觀點提煉 
│   └── 💎 syntheses/            ← 綜合層：針對複雜提問生成的深度研究報告 
│
├── 📐 CONTEXT.md                ← 唯一規範來源：語言協議、讀寫權限、Wiki Schema
├── 🤖 CLAUDE.md                 ← Claude Code 入口（轉引 CONTEXT.md）
├── 🧩 AGENTS.md                 ← Codex 入口（轉引 CONTEXT.md）
│
├── 🔧 scripts/                  ← 維護工具
│   ├── to-traditional.sh        ← 簡→繁（台灣正體）轉換與驗證
│   ├── detect-simplified.py     ← 逐字元偵測簡體殘留
│   ├── tw-fixups.tsv            ← OpenCC 誤轉修正表
│   └── tw-ambiguous.txt         ← 繁簡共用歧義字清單
│
└── ⚙️ .claude/                  ← Claude Code 官方配置目錄
    └── 🛠️ skills/               ← Agent Skill中心
        ├── ⚙️ ingest/           ← 自訂：編譯收件箱 raw 檔案到 wiki，並執行 09-archive 歸檔
        ├── 🔎 query/            ← 自訂：檢索 wiki/index 並讀取相關頁面，生成帶雙鏈引用的回答
        └── 🩺 lint/             ← 自訂：知識體檢，回報死鏈、孤兒頁面、未同步索引與認知衝突
```


## 使用方式

在 Obsidian 中開啟本 vault，使用 Claude Code、Codex 或 Claudian 外掛執行操作。

### 常用命令

- `/query <問題>` — 在知識庫中搜尋相關內容
- `/ingest` — 將新的原始資料編譯到知識庫
- `/lint` — 檢查知識庫健康度（死鏈、孤兒頁面）

### Agent 規範

規範採單一來源：實質規則全部寫在 **`CONTEXT.md`**，`CLAUDE.md`（Claude Code）
與 `AGENTS.md`（Codex）只是入口，各自轉引並補充該工具專屬的部分。

修改規範時**只改 `CONTEXT.md`** —— 兩份入口各自維護一套規則，正是規範互相
打架的來源。

## 維護：簡體 → 繁體轉換

本庫 fork 自簡體上游，內容已全數轉為台灣正體。從 upstream 拉進新內容後，
執行轉換腳本即可，不必手動解 merge 衝突：

```bash
brew install opencc                  # 首次需安裝相依（另需 python3）
./scripts/to-traditional.sh          # 轉換 + 修正 + 驗證
./scripts/to-traditional.sh --check  # 只檢查不修改（可用於 CI）
```

腳本是冪等的 —— 對已是繁體的內容重跑不會造成任何變更。

> ⚠ **不要直接對全庫跑 `opencc -c s2twp`**。s2twp 對已經是繁體的內容並不冪等：
> 它會把 `tw-fixups.tsv` 已修正的詞改回誤譯，也會把正確的「文件(document)」
> 誤轉成「檔案(file)」。腳本因此先用 `detect-simplified.py` 逐字元判斷，
> **只轉真的含簡體字的檔案**，再套用 `tw-fixups.tsv` 修正 s2twp 本身的誤轉。

遇到誤判時的維護方式：

- 轉出來的詞不符台灣用語 → 加一行到 `tw-fixups.tsv`
- 明明是正確繁體卻被當成簡體 → 把該字加進 `tw-ambiguous.txt`

## 知識來源

- Google Gemini API 官方文件
- Anthropic Claude 最佳實踐
- 各機構發布的 Prompt Engineering 白皮書
- 學術論文（如 5C Prompt Contracts）
