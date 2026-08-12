---
title: "摘要-5C Prompt Contracts 研究論文"
type: source
tags: [來源, 論文, 5C框架, 提示設計, 效率最佳化]
sources: [raw/02-papers/5C Prompt Contracts .pdf]
last_updated: 2026-04-12
---

## 核心摘要

由 AI 研究策略師 Ugur Ari 提出的 5C Prompt Contract 框架，是一種**極簡、創意友好、token 高效**的提示設計方法，特別適合個人和中小企業使用。

**5C 元件：**
1. **Character（角色）**：定義 AI 的身份、專業知識、語氣風格
2. **Cause（原因/目標）**：明確任務目的和預期成果
3. **Constraint（約束）**：設定邊界條件、資源限制、執行規則
4. **Contingency（應變）**：定義備用方案和錯誤處理機制
5. **Calibration（校準）**：輸出最佳化和品質控制指令

**核心發現：**
- **Token 效率**：5C 框架平均僅需 54.75 tokens 輸入，遠低於 DSL (348.75) 和非結構化 (346.25)
- **輸出品質**：在保持創意豐富度的同時，輸出一致性優於非結構化提示
- **跨模型表現**：在 OpenAI、Anthropic、DeepSeek、Gemini 上均表現優異
- **Gemini 特別優勢**：5C 提示僅需 54 tokens 輸入，而 DSL 需要 1212 tokens

**與 DSL 對比：**
| 維度 | 5C | DSL |
|------|-----|-----|
| 輸入 Token | 極低 (~55) | 高 (~350) |
| 認知負載 | 低 | 高 |
| 創意自由度 | 高 | 受限 |
| 學習曲線 | 平緩 | 陡峭 |

**實踐建議：**
- 用於token敏感場景（如 API 呼叫頻繁的應用）
- 需要平衡結構與創意的任務
- AI 工程資源有限的個人/中小企業

## 關聯連線
- [[Prompt_Engineering]] — 提示工程總覽
- [[5C_Framework]] — 5C 提示契約框架詳解
- [[Prompt_Design]] — 提示設計方法論
- [[Token_Efficiency]] — Token 效率最佳化
