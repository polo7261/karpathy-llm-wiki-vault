---
title: "Gemini"
type: entity
tags: [模型, Google, LLM, 實體]
sources: 
  - raw/01-articles/提示設計策略  _  Gemini API.md
  - raw/02-papers/Goolge-Prompt-Engineering-whitepaper.pdf
last_updated: 2026-04-12
---

## 定義

Gemini 是 Google 開發的大型語言模型家族，專為高階推理和多模態任務設計。作為 Google DeepMind 的旗艦模型系列，Gemini 代表了 Google 在生成式 AI 領域的核心產品。

## 主要版本

### Gemini 3（當前主要版本）
- **Gemini 3 Pro**: 最強大的版本，適合複雜推理任務
- **Gemini 3 Flash**: 輕量級版本，平衡效能與效率
- **特點**：
  - 專為高階推理和指令遵循設計
  - 自動生成內部"思考"文本
  - **不再需要複雜的提示工程**（如強制 CoT）
  - 支援 `thinking_level` 引數控制推理深度

### Gemini 2.5
- 前代主要版本
- 部分複雜提示工程技術（如詳細 CoT）對其仍然有效

## 核心特點

### 1. 提示簡化趨勢
與其他模型不同，Gemini 3 展現出"反提示工程"的特性：
- 複雜的提示工程技術（如 elaborate CoT）可能**降低**效能
- 建議使用簡化提示配合 `thinking_level: "high"`
- 如果之前為 Gemini 2.5 設計的複雜提示表現不佳，嘗試簡化

### 2. 分隔符偏好
- **XML 風格標籤**：`<context>`, `<task>`, `<role>`
- **Markdown 標題**：# Identity, # Constraints
- **結構一致性**：同一提示中保持統一格式

### 3. 溫度設定

**關鍵發現**：
- **推薦溫度：1.0**
- 降低溫度可能導致推理任務中**出現迴圈**和效能下降
- 這與傳統認知（高確定性任務用低溫）相反

### 4. 上下文視窗
- **標準上下文**：128K tokens
- **擴充套件上下文**：最高可達 2M tokens（適用於影片和深度文件）

### 5. 多模態能力
- 文本、影像、音訊、影片原生支援
- 程式碼執行內建
- Google 搜尋接地（Grounding）

## 提示工程建議

### Gemini 3 核心原則

```
1. 用詞精確、直接
2. 使用一致的 XML 或 Markdown 結構
3. 明確說明任何模糊術語
4. 控制輸出詳細程度（預設高效簡潔）
5. 連貫處理多模態輸入
6. 將關鍵指令放在系統提示或提示開頭
7. 長上下文：先提供所有上下文，具體說明放在最後
8. 使用錨定短語連線上下文和查詢
```

### 推薦模板結構

**XML 示例**：
```xml
<role>
你是一個有幫助的助手。
</role>

<constraints>
1. 客觀陳述
2. 引用來源
</constraints>

<context>
[使用者輸入 - 模型知道這是資料，不是指令]
</context>

<task>
[具體使用者請求]
</task>
```

### 智慧體工作流支援

Gemini 3 提供精細的智慧體行為配置：

**推理與策略**：
- 邏輯分解詳盡程度
- 問題診斷深度
- 資訊詳盡程度

**執行與可靠性**：
- 適應性：對新資料的反應方式
- 永續性和恢復性：錯誤糾正程度
- 風險評估：區分低風險探索與高風險狀態變更

**互動和輸出**：
- 模糊性處理：何時進行假設，何時尋求澄清
- 詳細程度：文本輸出量
- 精確度和完整性：輸出保真度

## Code Execution（程式碼執行）

Gemini 預設啟用 Python 程式碼執行：
- 自動檢測需要計算、計數或算術的場景
- 執行生成的 Python 程式碼
- 將執行結果整合到回答中

## 接地（Grounding）

**Google 搜尋接地**：
- 將 Gemini 與即時網路內容關聯
- 適用於冷門或最新事實查詢
- 減少幻覺

## 關聯連線
- [[Prompt_Engineering]] — 提示工程總覽
- [[Google]] — Google 公司
- [[摘要-gemini-api-prompting-strategies]] — Gemini API 策略來源
- [[摘要-google-prompt-engineering-whitepaper]] — Google 白皮書
