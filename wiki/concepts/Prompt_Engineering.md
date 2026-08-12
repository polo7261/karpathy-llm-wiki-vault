---
title: "Prompt Engineering（提示工程）"
type: concept
tags: [提示工程, LLM, AI, 核心概念]
sources: 
  - raw/01-articles/提示設計策略  _  Gemini API.md
  - raw/01-articles/Prompting best practices-Anthropic.md
  - raw/02-papers/Goolge-Prompt-Engineering-whitepaper.pdf
last_updated: 2026-04-12
---

## 定義

提示工程（Prompt Engineering）是設計和最佳化輸入給大型語言模型（LLM）的文本提示，以引導模型生成準確、有用、符合預期輸出的技術學科。它是人機互動與 NLP 的交叉領域，涉及清晰表達意圖、提供上下文、設定約束和示例選擇。

> "Prompt 工程是迭代過程。不充分的提示可能導致模糊、不準確的響應，阻礙模型提供有意義的輸出。" —— Google 白皮書

## 核心要素

根據 Anthropic、OpenAI 和 Google 的共識，有效提示包含七個核心元件：

| 元件 | 作用 | 示例 |
|------|------|------|
| **Role/Persona** | 啟用領域知識 | "你是財富 500 強公司的高階資料科學家" |
| **Task Context** | 背景和受眾資訊 | "結果將呈現給董事會" |
| **Clear Instructions** | 核心請求 | "用 3 個要點總結" |
| **Sequential Steps** | 確保執行順序 | 編號步驟列表 |
| **Few-shot Examples** | 演示期望格式 | 3-5 個相關多樣化示例 |
| **Output Format** | 響應結構 | "返回 JSON，欄位包括..." |
| **Constraints** | 限制輸出空間 | "200字以內，不使用術語" |

## 主要技術

### 基礎技術
- **Zero-Shot**：無示例直接提問，適用於簡單任務
- **Few-Shot**：提供 3-5 個示例引導模型學習模式
- **Role Prompting**：分配角色以啟用特定知識域
- **Contextual Prompting**：提供任務特定背景資訊

### 高階技術
- **Chain-of-Thought (CoT)**：要求模型展示推理步驟，顯著提升數學和邏輯任務表現
  - 注意：現代推理模型（GPT-5、Claude 4、Gemini 3）內部自動思考，顯式 CoT 可能反而有害
- **Self-consistency**：多次取樣取最一致的答案
- **Tree of Thoughts (ToT)**：同時探索多條推理路徑
- **ReAct**：結合推理（Reasoning）與行動（Acting）的代理範式
- **Step-back Prompting**：先問一般性問題再解決具體任務

## 範式演變

### Prompt Engineering → Context Engineering

2024-2025 年領域的重要轉變：

- **過去**：專注於單個提示的詞句最佳化
- **現在**：理解為"上下文工程"——策劃系統提示、工具、外部資料和訊息歷史的最優 token 集合

> "最佳提示不是最複雜的，而是用最少的必要上下文達成目標的。" —— Anthropic

## 最佳實踐

1. **具體明確**：每個詞都應幫助 AI 準確理解需求
2. **簡潔優先**：研究表明 **150-300 詞**是最佳長度，超過 3,000 tokens 效能顯著下降
3. **使用分隔符**：XML 標籤（`<context>`, `<task>`）或 Markdown 標題
4. **示例品質勝過數量**：3-5 個高品質、多樣化示例優於大量雷同示例
5. **指令優於約束**：說"做 X"比"不要做 Y"更有效
6. **迭代最佳化**：基於輸出反饋持續改進

## 模型特定注意事項

| 模型 | 特點 | 建議 |
|------|------|------|
| **Claude 4.x** | 字面理解指令 | 明確表達期望行為，使用 XML 標籤 |
| **GPT-4.1/5** | 對沖突指令敏感 | 避免矛盾指令，注意推理模型不要 CoT |
| **Gemini 3** | 內建思考機制 | 簡化提示，`thinking_level: "high"` |

## 關聯連線
- [[5C_Framework]] — 5C 提示契約框架
- [[Chain_of_Thought]] — 思維鏈詳解
- [[Few_Shot_Prompting]] — 少樣本提示
- [[Context_Engineering]] — 上下文工程
- [[Zero_Shot_Prompting]] — 零樣本提示
- [[摘要-gemini-api-prompting-strategies]] — Gemini 策略來源
- [[摘要-anthropic-prompting-best-practices]] — Claude 最佳實踐來源
- [[摘要-google-prompt-engineering-whitepaper]] — Google 白皮書來源
