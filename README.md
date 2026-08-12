# LLM Wiki 知識庫

本專案是一個基於 [Karpathy 的 LLM Wiki 理念](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 構建的 Obsidian 知識庫。

## 核心理念

將碎片化的資訊編譯成**結構化、高度相互連結**的知識網路，便於 AI 輔助學習和研究。

## 目錄結構

```

🏛️ 你的知識庫資料夾 (LLM-Wiki-Vault)
├── 🖼️ assets/                   ← 統一媒體資源層：存放圖片、PDF、附件（Obsidian設定附件路徑至此）
│
├── 📥 raw/                      ← 原始資料收件箱（唯讀事實層，檔案處理後移動至 archive）
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
├── 🤖 CLAUDE.md                 ← 全域心智規範：定義語言協議、讀寫權限與 Wiki Schema
│
└── ⚙️ .claude/                  ← Claude Code 官方配置目錄
    └── 🛠️ skills/               ← Agent Skill中心
        ├── ⚙️ ingest/           ← 自訂：編譯收件箱 raw 檔案到 wiki，並執行 09-archive 歸檔
        ├── 🔎 query/            ← 自訂：檢索 wiki/index 並讀取相關頁面，生成帶雙鏈引用的回答
        ├── 🩺 lint/             ← 自訂：知識體檢，修復死鏈、補充 index、發現認知衝突
        ├── 🔌 obsidian-cli/     ← Obsidian官方：呼叫 Obsidian 原生 API 進行檢索、開啟頁面
        └── 🪄 defuddle/         ← Obsidian官方：將網頁 URL 自動清理並轉化為 Markdown 存入 raw/
```


## 使用方式

在 Obsidian 中開啟本 vault，使用Claude Code或者Claudian外掛執行操作。

### 常用命令

- `/query <問題>` — 在知識庫中搜索相關內容
- `/ingest` — 將新的原始資料編譯到知識庫
- `/lint` — 檢查知識庫健康度（死鏈、孤兒頁面）

## 知識來源

- Google Gemini API 官方文件
- Anthropic Claude 最佳實踐
- 各機構釋出的 Prompt Engineering 白皮書
- 學術論文（如 5C Prompt Contracts）
