# AGENTS.md — Codex 入口

**開始工作前，先完整閱讀 [`CONTEXT.md`](CONTEXT.md)。**

`CONTEXT.md` 是本知識庫的唯一規範來源，包含：語言規範、目錄權限邊界、
Wiki Schema（index/log/分類/雙鏈/矛盾處理）、frontmatter 規範與工作流定義。
本檔只補充 Codex 專屬的部分。

## 重點提醒

- **語言**：一律使用繁體中文（台灣），專業術語保留英文。
- **`raw/` 內容永遠不可修改**；唯一例外是 `/ingest` 完成後將原始檔移至
  `raw/09-archive/` 歸檔。
- **`wiki/` 是你的工作區**，可自由讀寫。
- 每次寫入 wiki 後，必須同步更新 `wiki/index.md` 與 `wiki/log.md`。

## Codex 專屬

Codex 沒有 Agent Skills 機制，因此 `CONTEXT.md`「工作流指令」一節描述的
`/ingest`、`/query`、`/lint` 對 Codex 而言是**行為約定**而非可呼叫的指令：
使用者提出對應請求時，依 `CONTEXT.md` 的定義自行完成該流程。

若需要更細的操作步驟，`.claude/skills/*/SKILL.md` 是同一套流程的詳細版本，
可作為參考讀取（純 Markdown，不依賴 Claude Code 執行環境）。若其內容與
`CONTEXT.md` 衝突，以 `CONTEXT.md` 為準，並回報該衝突。
