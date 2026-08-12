---
title: "摘要-Anthropic Claude 提示最佳實踐"
type: source
tags: [來源, Claude, Anthropic, 提示工程, 最佳實踐]
sources: [raw/01-articles/Prompting best practices-Anthropic.md]
last_updated: 2026-04-12
---

## 核心摘要

Anthropic 官方 Claude 4.6 系列模型的提示工程指南，涵蓋基礎技巧到智慧體系統設計。核心原則：**清晰直接** — 像對待聰明但缺乏上下文的新員工一樣對待 Claude。

**關鍵要點：**
- **Claude 4.6 特性**：更簡潔自然的溝通風格，更少冗長總結，並行工具呼叫能力
- **XML 結構化**：使用 `<instructions>`, `<context>`, `<input>` 等標籤減少誤解
- **長上下文策略**：將長文件放在提示頂部，查詢放最後（可提升 30% 效能）

**思考模式：**
- Claude Opus 4.6 預設使用**自適應思考**（adaptive thinking），而非固定預算
- 通過 `effort` 引數控制思考深度：low/medium/high
- 複雜任務不需要顯式"逐步思考"提示，模型會自動推理

**智慧體系統：**
- Claude 4.6 擅長長期推理和狀態跟蹤
- 支援多上下文視窗工作流，可儲存/恢復進度
- 原生支援子代理編排（subagent orchestration）

**工具使用：**
- 4.6 模型對工具使用更積極，可能需要調低激進提示
- 支援並行工具呼叫最佳化效率
- 可通過系統提示調整行動傾向（主動實施 vs 僅提供建議）

**最佳實踐：**
- 3-5 個示例效果最佳，用 `<example>` 標籤包裹
- 始終指定輸出格式而非"不要使用某種格式"
- Claude Opus 4.5 對"think"這個詞特別敏感，可改用"consider"或"evaluate"

## 關聯連線
- [[Prompt_Engineering]] — 提示工程總覽
- [[Claude]] — Anthropic Claude 模型
- [[Agentic_Systems]] — 智慧體系統設計
- [[Adaptive_Thinking]] — 自適應思考
