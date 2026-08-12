---
title: "摘要-Gemini API 提示設計策略"
type: source
tags: [來源, Gemini, Google, 提示工程]
sources: [raw/01-articles/提示設計策略  _  Gemini API.md]
last_updated: 2026-04-12
---

## 核心摘要

Google Gemini API 官方中文文件，系統介紹了提示工程的核心策略和最佳實踐。文件強調**簡潔直接的指令**最有效，建議使用 XML 標籤或 Markdown 標題作為分隔符，並提供了從基礎到高階的完整提示設計指南。

**關鍵要點：**
- **輸入型別**：問題輸入、任務輸入、實體輸入、補全輸入
- **少樣本提示**：始終包含 3-5 個示例，確保格式一致性
- **Gemini 3 策略**：用詞精確直接、使用一致結構、定義引數、控制輸出詳細程度
- **智慧體工作流**：邏輯分解、問題診斷、風險評估、執行與恢復

**最佳實踐**：
1. 長上下文結構：先提供所有上下文，具體說明放在最後
2. 使用 XML 風格標籤（`<context>`, `<task>`）分隔內容
3. 溫度設為 1.0，降低會導致推理任務效能下降和迴圈
4. 現代推理模型自動生成"思考"文本，無需強制 Chain-of-Thought

## 關聯連線
- [[Prompt_Engineering]] — 提示工程總覽
- [[Gemini]] — Google 大語言模型家族
- [[Few_Shot_Prompting]] — 少樣本提示技術
- [[Zero_Shot_Prompting]] — 零樣本提示技術
