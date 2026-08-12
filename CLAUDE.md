# 語言設定與核心角色 (Global Rules)
- **語言指令**：無論輸入何種語言，你必須始終使用**簡體中文**進行思考、回覆和知識庫的編寫。
- **角色定義**：你正在維護一個 **LLM Wiki**（根據 [Karpathy 的規範](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f))，你的任務是將碎片化的資訊編譯成結構化、高度相互連結的 Obsidian 知識庫。

# 核心目錄與權限邊界 (Immutability & Architecture)
你必須嚴格遵守以下檔案操作權限，這是不可逾越的底線：

- `/raw/` (不可變層 - Immutable)：
  - **絕對唯讀**。這裡存放我的原始素材、網頁剪藏和自媒體文案。
  - **禁止修改或刪除此目錄下的任何檔案**。它是事實的唯一真相來源。
- `/assets/` (媒體資產層)：
  - 存放圖片、PDF和媒體。引用時使用 Obsidian 標準語法 `![[檔案名稱.png]]`。
- `/wiki/` (編譯輸出層 - You Own This)：
  - 這是你的專屬工作區。你需要在此處建立、更新、提煉知識並解決矛盾。

# Wiki 核心檔案契約 (The Wiki Schema)
當你在 `/wiki/` 中工作時（尤其是執行寫入操作後），必須維護以下基石：

1. **`wiki/index.md` (總目錄)**：
   每次向 wiki 新增知識頁後，必須同步更新此檔案，將其按分類加入目錄中。
   格式要求： [[頁面名稱]] — 一句話描述。
    - Entities/Concepts: 使用 TitleCase 命名。
    - Sources/Syntheses: 使用 kebab-case 命名。
    範例：
    ```markdown
    # Wiki Index

    ## Sources
    - [[摘要-source-slug]] — 該資料的核心主旨摘要。

    ## Entities
    - [[EntityName]] — 該實體的身份定義或核心功能。

    ## Concepts
    - [[ConceptName]] — 該概念或框架的核心定義。

    ## Syntheses
    - [[synthesis-slug]] — 該頁面回答的複雜問題。
    ```
2. **`wiki/log.md` (操作日誌)**：
    只能追加寫入（Append-only）。每次操作後記錄：`## [YYYY-MM-DD] <動作> | <操作簡述>`。
    操作型別： ingest, query, lint, sync
    範例：
    ```markdown
    ## [2026-04-11] ingest | 引入專案 Claude Code 核心概念
    - **變更**: 新增 [[ClaudeCode]], [[摘要-claude-code-docs]]; 更新 [[index.md]]
    - **衝突**: 無 (或: 衝突 [[RAG架構]], 已標註)

    ## [2026-04-11] query | 解析 Karpathy LLM-Wiki 理念
    - **輸出**: 已儲存至 [[分析-karpathy-wiki-philosophy]]

    ## [2026-04-11] lint | 周度健康檢查
    - **結果**: 修復 2 處死鏈，發現 1 個孤兒頁面 [[UnlinkedPage]]
    ```
3. **內容分類**：
   - `/wiki/concepts/`：存放概念、框架、方法論（如 `Agent_Skill.md`）。
   - `/wiki/entities/`：存放人物、公司、工具、產品（如 `Claude_Code.md`）。
   - `/wiki/sources/`：存放從 `raw/` 提煉出的原始素材摘要。
4. **強制雙向連結**：
   每一個 wiki 頁面必須包含 `## 關聯連線` 區域，使用 Obsidian 雙鏈 `[[頁面名稱]]` 連結到其他相關概念。絕不能產生孤島頁面。
5. **矛盾處理原則**：
   如果新攝入的知識與舊知識衝突，不要靜默覆蓋。在頁面中新建 `## 知識衝突` 區塊，將兩種說法都保留並做對比。

# 工作流指令說明 (Workflows / Skills)
當被要求執行以下操作時，請遵循核心邏輯（未來可能由專用 Agent Skills 接管）：

- `/ingest <路徑>`：讀取指定的 `raw/` 檔案，將其核心價值提煉並整合到 `wiki/` 目錄的相關概念/實體中。必須更新 index 和 log。
- `/query <問題>`：通過讀取 `wiki/index.md` 尋找相關檔案，進行深度閱讀後綜合回答，並在回答中必須使用 `[[wikilink]]` 標註引用來源。
- `/lint`：全域掃描 `wiki/` 目錄，找出孤島頁面（沒有雙鏈）、死鏈（連結不存在的頁面）以及存在邏輯衝突的地方，並向我報告。

# 頁面 Frontmatter (YAML) 規範
所有生成的 wiki 頁面必須包含以下 YAML 頭部：
---
title: "頁面標題"
type: concept | entity | source | synthesis
tags: [知識標籤]
sources:[關聯的raw檔案相對路徑]
last_updated: YYYY-MM-DD
---