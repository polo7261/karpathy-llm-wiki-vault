# Wiki 操作日誌

---

## [2026-04-12] ingest | 批次攝入提示工程核心資料

### 處理檔案清單

**Articles（5 篇）：**
- `raw/01-articles/提示設計策略  _  Gemini API.md` — Google Gemini 中文指南
- `raw/01-articles/Prompt Engineering in 2025_ Complete Guide for ChatGPT, Claude, and Gemini.md` — PromptBuilder 指南
- `raw/01-articles/The Complete Guide to AI Prompt Engineering in 2025-2026.md` — Espo.ai 指南
- `raw/01-articles/The Complete Prompt Engineering Guide (2025).md` — BrilliantPrompts 指南
- `raw/01-articles/Prompting best practices-Anthropic.md` — Anthropic 官方最佳實踐

**Papers（2 篇）：**
- `raw/02-papers/Goolge-Prompt-Engineering-whitepaper.pdf` — Google 官方白皮書（65 頁）
- `raw/02-papers/5C Prompt Contracts .pdf` — 5C 提示契約研究論文

### 建立的來源摘要（7 個）

| 檔案 | 描述 |
|------|------|
| [[摘要-gemini-api-prompting-strategies]] | Gemini API 提示設計策略 |
| [[摘要-prompt-engineering-2025-guide-promptbuilder]] | Prompt Engineering 2025 完整指南 |
| [[摘要-ai-prompt-engineering-2025-2026-espo]] | AI 提示工程 2025-2026 指南 |
| [[摘要-complete-prompt-engineering-guide-2025]] | 完整提示工程指南 2025 |
| [[摘要-anthropic-prompting-best-practices]] | Anthropic 提示最佳實踐 |
| [[摘要-google-prompt-engineering-whitepaper]] | Google 提示工程白皮書 |
| [[摘要-5c-prompt-contracts-paper]] | 5C Prompt Contracts 論文 |

### 建立的概念頁面（5 個）

| 頁面 | 型別 | 核心內容 |
|------|------|----------|
| [[Prompt_Engineering]] | 核心概念 | 提示工程總覽、七大要素、技術分類 |
| [[5C_Framework]] | 框架 | 5C 提示契約框架詳解 |
| [[Chain_of_Thought]] | 技術 | 思維鏈技術、Zero-shot/Few-shot CoT |
| [[Few_Shot_Prompting]] | 技術 | 少樣本提示最佳實踐 |
| [[Context_Engineering]] | 範式 | 從提示工程到上下文工程的轉變 |

### 建立的實體頁面（4 個）

| 頁面 | 描述 |
|------|------|
| [[Google]] | Google 公司及其 AI 產品 |
| [[Anthropic]] | Anthropic 公司及其安全研究 |
| [[Gemini]] | Google Gemini 模型家族特性 |
| [[Claude]] | Anthropic Claude 模型家族特性 |

### 衝突與發現

**知識衝突（已標註）：**
- 在 [[5C_Framework]] 頁面中記錄了「5C vs 複雜 DSL 之爭」的知識衝突

**重要發現：**
1. **提示長度悖論**：研究表明 150-300 詞是最佳長度，超過 3,000 tokens 效能顯著下降
2. **CoT 悖論**：現代推理模型（GPT-5, Claude 4, Gemini 3）內部自動推理，顯式 CoT 反而可能有害
3. **5C 效率優勢**：平均僅需 54 tokens 輸入，比 DSL 節省 6 倍以上
4. **Gemini 簡化趨勢**：Gemini 3 不再需要複雜提示工程，建議使用簡化提示
5. **Context Engineering 範式**：行業正在從單個提示最佳化轉向系統上下文管理

### 更新檔案
- [[index.md]] — 重新組織了總目錄結構
- [[log.md]] — 記錄本次操作（本條目）

### 歸檔操作
所有 7 個原始檔已移動至 `raw/09-archive/` 目錄。

---

## [2026-04-12] query | 基於 5C Framework 設計 Markdown 筆記提示詞

- **查詢**: 根據 5C Framework 設計撰寫 Markdown 格式知識筆記的提示詞
- **引用**: [[5C_Framework]]
- **輸出**: 已建立 synthesis 檔案 [[5c-prompt-markdown-note-taking]]
- **更新**: [[index.md]] 已註冊新 synthesis

### 提示詞特色
- 遵循 5C 框架：Character/Cause/Constraint/Contingency/Calibration
- Token 高效（約 150 tokens）
- 包含完整的使用示例和變體建議
- 內建品質自檢機制（Calibration）

---

## [2026-04-12] lint | 知識庫健康檢查

### ✅ 綠燈項
- 所有來源頁面均有雙向連結引用
- 所有概念頁面均有雙向連結引用
- 所有實體頁面均有雙向連結引用
- 新知識衝突已正確標註

### ⚠️ 黃燈項
- **8 個未同步索引（檔案不存在但 index.md 已註冊）**：
  - [[Zero_Shot_Prompting]] — 計劃中，待建立
  - [[APE_Framework]] — 計劃中，待建立
  - [[CO-STAR_Framework]] — 計劃中，待建立
  - [[RISEN_Framework]] — 計劃中，待建立
  - [[CRAFT_Framework]] — 計劃中，待建立
  - [[POWER_Framework]] — 計劃中，待建立
  - [[ReAct]] — 計劃中，待建立
  - [[Tree_of_Thoughts]] — 計劃中，待建立
  - [[RAG]] — 計劃中，待建立

- **10 個死鏈（頁面引用不存在的檔案）**：
  - [[Constitutional_AI]]（被 Anthropic.md 引用）
  - [[Adaptive_Thinking]]（被 Anthropic.md、Claude.md 引用）
  - [[Agentic_Systems]]（被 Anthropic.md、Context_Engineering.md 引用）
  - [[Token_Efficiency]]（被 5C_Framework.md、摘要-5c-prompt-contracts-paper.md 引用）
  - [[Prompt_Design]]（被 5C_Framework.md、摘要-5c-prompt-contracts-paper.md 引用）
  - [[DSL_Prompting]]（被 5C_Framework.md 引用）
  - [[ChatGPT]]（被 摘要-complete-prompt-engineering-guide-2025.md 引用）
  - [[DeepMind]]（被 Google.md 引用）

### ❌ 紅燈項
- **1 個待解決的知識衝突**：
  - [[5C_Framework]] 頁面中記錄的「5C vs 複雜 DSL 之爭」（概念性標註，待補充具體衝突內容）

### 🛠️ 下一步行動
1. **高優先順序**：建立核心概念頁面（Zero_Shot_Prompting、ReAct、RAG）
2. **中優先順序**：建立框架頁面（APE、CO-STAR、RISEN、CRAFT、POWER）
3. **低優先順序**：補充輔助概念（Constitutional_AI、DeepMind、Token_Efficiency 等）
4. **可選**：完善 5C_Framework 的知識衝突區塊，補充具體爭議點

### 統計
- 總檔案數：19 個（不含 index/log）
- 存在頁面：19 個
- 孤兒頁面：0 個
- 未同步索引：8 個（計劃中的框架/技術）
- 死鏈：10 個（輔助/補充概念）
- 知識衝突：1 個（概念性標註）

---
