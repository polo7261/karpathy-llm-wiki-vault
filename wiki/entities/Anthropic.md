---
title: "Anthropic"
type: entity
tags: [公司, AI, 實體, Anthropic]
sources: [raw/01-articles/Prompting best practices-Anthropic.md]
last_updated: 2026-04-12
---

## 定義

Anthropic 是一家專注於 AI 安全研究的美國人工智慧公司，成立於 2021 年，由前 OpenAI 研究副總裁 Dario Amodei 及其妹妹 Daniela Amodei 等人創立。公司使命是開發可靠、可解釋和可操控的 AI 系統。

## 核心產品與產品

### Claude 系列模型
Anthropic 的旗艦大型語言模型家族：
- **Claude 3/4 系列**：Haiku, Sonnet, Opus
- 以強大的長上下文處理和細緻推理能力著稱
- 強調 HHH 原則（Helpful, Harmless, Honest）

### Claude API 與平臺
- **Claude API**：面向開發者的模型訪問介面
- **Claude Code**：智慧程式設計助手
- **Claude Enterprise**：企業級解決方案

## 核心理念

### Constitutional AI
Anthropic 開發的 AI 訓練方法：
- 不僅依賴人類反饋，還使用一套原則（Constitution）指導模型行為
- 目標是使 AI 更安全、更可控
- 減少對人類標註者的依賴

### AI Safety Research
Anthropic 將 AI 安全作為核心研究方向：
- **Mechanistic Interpretability**：理解神經網路內部工作機制
- **Scaling Laws**：研究模型能力隨規模變化的規律
- **Alignment**：確保 AI 系統按照人類意圖行動

## 關鍵技術創新

### Adaptive Thinking
Claude 4.6 引入的自適應思考機制：
- 模型動態決定何時以及思考多少
- 基於任務複雜度和 `effort` 引數
- 比固定預算的 Extended Thinking 更高效

### Context Awareness
Claude Sonnet 4.6 和 4.5 支援上下文感知：
- 模型能跟蹤剩餘上下文視窗
- 最佳化長任務執行
- 支援多上下文視窗工作流

## 關聯連線
- [[Claude]] — Anthropic 的 LLM 產品
- [[Prompt_Engineering]] — 提示工程（Anthropic 是重要貢獻者）
- [[Constitutional_AI]] — 憲法 AI 訓練方法
- [[摘要-anthropic-prompting-best-practices]] — 官方最佳實踐指南
