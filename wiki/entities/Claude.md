---
title: "Claude"
type: entity
tags: [模型, Anthropic, LLM, 實體]
sources: 
  - raw/01-articles/Prompting best practices-Anthropic.md
  - raw/01-articles/The Complete Guide to AI Prompt Engineering in 2025-2026.md
last_updated: 2026-04-12
---

## 定義

Claude 是由 **Anthropic** 開發的大型語言模型家族，以其強大的長上下文處理能力和細緻推理而聞名。Claude 系列模型強調有用性、無害性和誠實性（Helpful, Harmless, Honest - HHH 原則）。

## 主要版本

### Claude 4.6 系列（當前最新）
- **Claude Opus 4.6**：最強大的模型，擅長深度分析、研究和複雜編碼
- **Claude Sonnet 4.6**：平衡效能和速度，預設 effort=high
- **Claude Haiku 4.6**：輕量級，適合簡單任務

**關鍵特性**：
- **Adaptive Thinking（自適應思考）**：動態決定何時以及思考多少
- **Extended Context**：200K+ tokens
- **Native Subagent Orchestration**：原生子代理編排能力

### Claude 4.5 系列
- **Claude Opus 4.5**：前一版本旗艦模型
- **Claude Sonnet 4.5**：前一版本平衡模型

### 早期版本
- Claude 3.x 系列（Sonnet, Opus, Haiku）

## 核心特點

### 1. 視角："聰明但缺乏上下文的新員工"
Anthropic 對 Claude 的定位：
- 極其聰明但缺乏你團隊的規範和流程知識
- **越精確地解釋你想要什麼，結果越好**
- 不會主動推斷模糊的"超越預期"行為

### 2. 指令遵循：字面理解
Claude 4.x 模型**按字面理解指令**：
- 早期版本會推斷意圖並擴充套件模糊請求
- 現在必須**明確表達**期望的行為
- 不會有過度假設

### 3. 思考模式演進

| 版本 | 思考模式 | 配置方式 |
|------|----------|----------|
| Claude 4.5 | Extended Thinking | `budget_tokens` |
| Claude 4.6 | Adaptive Thinking | `effort` 引數 |

**Adaptive Thinking**：
```python
# 老方式（4.5 及之前）
thinking={"type": "enabled", "budget_tokens": 32000}

# 新方式（4.6）
thinking={"type": "adaptive"}
output_config={"effort": "high"}  # low/medium/high
```

- Claude 根據任務複雜度自動決定思考深度
- 簡單查詢直接響應，複雜任務深度思考
- 比固定預算的 Extended Thinking 更高效

### 4. 上下文視窗
- **標準上下文**：200K+ tokens
- **Context Awareness**：模型能跟蹤剩餘 token 預算

**Context Awareness 的實踐意義**：
```
你的上下文視窗在接近限制時會自動壓縮，允許你無限期繼續工作。
因此，不要因為 token 預算擔憂而提前停止任務。
在接近 token 預算時，將進度和狀態儲存到記憶體。
```

### 5. Agentic Capabilities（智慧體能力）

Claude 4.6 在長期推理和狀態跟蹤方面表現卓越：

**多上下文視窗工作流**：
- 第一個視窗：設定框架（測試、指令碼）
- 後續視窗：在待辦事項列表上迭代
- 能在新視窗中從檔案系統恢復狀態

**子代理編排**：
- 識別何時需要將任務委託給子代理
- 無需顯式指令即可主動編排
- 可能過度使用（Opus 4.6 對子代理有強烈偏好）

### 6. 過度熱誠傾向
Claude 4.5 和 4.6 存在過度工程化傾向：
- 建立額外檔案
- 新增不必要的抽象
- 為假設的未來需求構建靈活性

**緩解措施**：
```
避免過度工程。只進行直接請求或明顯必要的更改。
- 範圍：不新增功能或重構
- 文件：只在你更改的程式碼上添加註釋
- 防禦性編碼：只在系統邊界驗證
```

## 提示工程最佳實踐

### 核心原則
1. **Clear and Direct**：清晰明確的指令
2. **Use Examples**：3-5 個示例是最可靠的控制方式
3. **XML Structuring**：使用 XML 標籤分隔不同元件
4. **Role Assignment**：通過系統提示設定角色

### 長上下文策略
```
提示結構：
[長文件放在頂部]
[查詢、指令和示例放在底部]

益處：查詢放在末尾可提升高達 30% 的效能，
尤其在複雜多文件場景中。
```

### 避免對 Claude 4.6 過度提示
與早期模型不同，Claude 4.6：
- **不要太激進**：之前需要 "CRITICAL: You MUST..." 現在只需 "Use this tool when..."
- **移除"過度提示"**：早期模型的"如果在猶豫，使用工具"會導致 4.6 過度觸發工具

### 詞敏感性問題
**Claude Opus 4.5 對"think"及其變體特別敏感**（當 extended thinking 停用時）：
- 避免："think", "thinking", "thought"
- 改用："consider", "evaluate", "reason through", "analyze"

### 工具使用
Claude 4.6 對工具使用更積極：
```
# 增加主動性
<default_to_action>
預設實施更改而非僅提供建議。如果使用者意圖不明確，
推斷最有用的可能行動並使用工具發現缺失資訊。
</default_to_action>

# 減少主動性
<do_not_act_before_instructions>
除非明確指示進行更改，否則不跳入實施。
當使用者意圖模糊時，預設提供資訊和推薦。
</do_not_act_before_instructions>
```

## 安全設計

### Constitutional AI
Claude 使用 Constitutional AI 技術進行訓練：
- 從人類反饋強化學習（RLHF）的改良版本
- 通過原則（Constitution）而非僅人類標籤指導行為
- 目標是更有幫助、更無害、更誠實

### 自主性與安全的平衡
```
考慮你行為的可逆性和潛在影響。
鼓勵採取本地、可逆的行動（如編輯檔案、執行測試），
但對於難以逆轉、影響共享系統或具有破壞性的行動，先詢問使用者。
```

## 關聯連線
- [[Prompt_Engineering]] — 提示工程總覽
- [[Anthropic]] — Anthropic 公司
- [[Adaptive_Thinking]] — 自適應思考機制
- [[Agentic_Systems]] — 智慧體系統
- [[摘要-anthropic-prompting-best-practices]] — Anthropic 最佳實踐
- [[摘要-ai-prompt-engineering-2025-2026-espo]] — 2025-2026 指南
