---
title: "摘要-Google Prompt Engineering 白皮書"
type: source
tags: [來源, Google, Gemini, 白皮書, 提示工程]
sources: [raw/02-papers/Goolge-Prompt-Engineering-whitepaper.pdf]
last_updated: 2026-04-12
---

## 核心摘要

Google 官方於 2024 年 9 月釋出的 Prompt Engineering 白皮書，作者 Lee Boonstra。系統介紹了提示工程的技術原理、配置引數和高階技巧。

**核心內容：**

**1. LLM 輸出配置**
- **Temperature**：控制隨機性，0 為確定性，高值產生多樣結果
- **Top-K**：選擇機率最高的 K 個 token
- **Top-P (Nucleus Sampling)**：選擇累積機率不超過 P 的 token
- 推薦起點：Temperature=0.2, Top-P=0.95, Top-K=30

**2. 提示技術**
- **Zero-shot**：無示例直接提問，適用於簡單明確定義的任務
- **Few-shot**：3-5 個示例引導模型學習模式
- **System Prompting**：設定整體上下文和目的
- **Role Prompting**：分配特定角色（旅行嚮導、編輯等）
- **Contextual Prompting**：提供具體背景資訊

**3. 高階技術**
- **Step-back Prompting**：先問一般性問題再解決具體任務，啟用背景知識
- **Chain of Thought (CoT)**：生成中間推理步驟，顯著提升數學和邏輯任務
- **Self-consistency**：多次取樣取最一致答案
- **Tree of Thoughts (ToT)**：同時探索多條推理路徑
- **ReAct (Reason & Act)**：結合推理與外部工具呼叫的代理範式
- **Automatic Prompt Engineering (APE)**：自動化提示生成和最佳化

**4. 程式碼提示**
- 程式碼生成：明確程式語言和版本
- 程式碼解釋：要求模型逐行解釋
- 程式碼翻譯：跨語言程式碼轉換
- 程式碼除錯：識別並修復錯誤

**最佳實踐：**
- 提供高品質、多樣化的示例
- 簡潔設計優於複雜模板
- 明確指定輸出格式
- 使用指令而非約束（"做 X"而非"不要做 Y"）
- 控制最大 token 長度以管理成本

## 關聯連線
- [[Prompt_Engineering]] — 提示工程總覽
- [[Gemini]] — Google Gemini 模型
- [[Chain_of_Thought]] — 思維鏈
- [[Tree_of_Thoughts]] — 思維樹
- [[ReAct]] — 推理與行動
