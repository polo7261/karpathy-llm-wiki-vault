---
title: "Context Engineering（上下文工程）"
type: concept
tags: [提示工程, 上下文工程, 高階概念, 範式轉變]
sources: [raw/01-articles/The Complete Guide to AI Prompt Engineering in 2025-2026.md]
last_updated: 2026-04-12
---

## 定義

Context Engineering（上下文工程）是 Prompt Engineering 的演進形態，由 Anthropic 於 2024-2025 年提出。它不再侷限於最佳化單個提示，而是將提示視為更大系統中的上下文組成部分，包括系統提示、工具定義、外部資料和對話歷史的綜合策劃。

核心原則：
> "找到能夠最大化期望結果機率的最小高訊號 token 集合。"

## 從 Prompt 到 Context 的轉變

### Prompt Engineering（舊範式）
- 關注單個提示的詞句最佳化
- 重點是"如何問問題"
- 相對孤立的提示設計

### Context Engineering（新範式）
- 關注整個上下文環境的策劃
- 重點是"提供什麼資訊和工具"
- 系統化的上下文管理
- 版本控制和測試如程式碼一般

## 核心元件

Context Engineering 包含以下上下文的綜合策劃：

### 1. 系統提示 (System Prompt)
定義模型的整體行為和身份。

```
你是 Claude，一個由 Anthropic 建立的 AI 助手。
你擅長長文件分析和細緻推理。
預設提供事實性的進展報告，而非自我慶祝式更新。
```

### 2. 工具定義 (Tool Definitions)
描述可用工具及其用途。

```
可用工具:
- search: 搜尋網際網路獲取最新資訊
- calculator: 執行數學計算
- code_interpreter: 執行 Python 程式碼
```

### 3. 外部資料 (External Data)
從 RAG、資料庫或 API 獲取的資料。

```
以下是關於你查詢主題的相關文件片段：
[文件內容...]

基於上述資訊，回答使用者的問題。
```

### 4. 對話歷史 (Conversation History)
之前互動的摘要或完整記錄。

```
之前的對話摘要：
- 使用者詢問產品定價
- 你提供了標準定價表
- 使用者表示是教育機構，詢問折扣
```

### 5. 當前使用者輸入 (Current User Input)
使用者的即時請求。

## 最佳實踐

### 1. 高訊號密度
優先選擇最相關資訊，而非包含所有可用資訊。

> "一個結構良好的 16K token RAG 提示優於 128K token 的完整上下文。" —— 研究報告

### 2. 戰略性放置
- **關鍵指令**：放在提示末尾（利用 recency bias）
- **長文件**：放在提示開頭
- **錨定短語**："基於上述所有資訊..." 重新聚焦注意力

### 3. 結構化分隔
使用清晰的結構標記不同上下文元件：

```
<system>
[系統提示]
</system>

<tools>
[工具定義]
</tools>

<context>
[外部資料]
</context>

<conversation>
[對話歷史]
</conversation>

<user_input>
[使用者輸入]
</user_input>
```

### 4. 版本控制與測試
將上下文配置視為程式碼：
- 使用 git 進行版本控制
- 維護測試集（20-50 個真實輸入）
- 迴歸測試防止效能退化
- 監控 token 成本和延遲

## 上下文視窗最佳化

### 挑戰
- **Recency Bias**：Transformer 對最近的 token 加權更高
- **訊號稀釋**：無關資訊會干擾關鍵訊號
- **幻覺增加**：長上下文中幻覺率上升
- **延遲**：每 500 tokens 增加約 25ms 響應時間

### 最佳化策略

| 策略 | 說明 |
|------|------|
| **優先順序排序** | 最關鍵資訊放在開頭和結尾 |
| **摘要壓縮** | 長文件預摘要處理 |
| **分塊檢索** | 只檢索最相關的片段 |
| **漸進載入** | 複雜任務分解為多個上下文視窗 |

## 應用場景

### 適用於 Context Engineering
- AI 代理（Agents）和自動化工作流
- 長文件分析和問答
- 多輪對話系統
- 工具使用型應用
- 需要持續學習的應用

### 示例工作流

```
Context Engineering 工作流示例：

1. 系統設定（一次）
   - 定義系統角色
   - 配置可用工具
   - 設定環境變數

2. 對話初始化
   - 載入相關知識庫摘要
   - 設定會話狀態

3. 每輪互動
   - 更新對話歷史
   - 如有需要，執行 RAG 檢索
   - 構建完整上下文
   - 傳送給模型
   - 處理響應，更新狀態

4. 持續最佳化
   - 基於評估結果調整上下文元件
   - A/B 測試不同配置
```

## 與 Prompt Engineering 的關係

Context Engineering **包含並超越** Prompt Engineering：

- **底層技術**：提示編寫技巧仍然重要
- **上層架構**：增加了系統性視角
- **工程實踐**：加入了版本控制、測試、監控

## 未來趨勢

1. **自適應上下文**：模型自動決定需要載入哪些上下文
2. **上下文快取**：重用穩定的上下文部分
3. **多模態上下文**：整合文本、影像、音訊、影片
4. **個性化上下文**：基於使用者歷史和行為定製

## 關聯連線
- [[Prompt_Engineering]] — 提示工程基礎
- [[RAG]] — 檢索增強生成（Context Engineering 的關鍵元件）
- [[摘要-ai-prompt-engineering-2025-2026-espo]] — 來源文件
- [[Agentic_Systems]] — 智慧體系統（重度依賴 Context Engineering）
