---
title: "摘要-AI 提示工程完整指南 2025-2026"
type: source
tags: [來源, 提示工程, 上下文工程, 框架]
sources: [raw/01-articles/The Complete Guide to AI Prompt Engineering in 2025-2026.md]
last_updated: 2026-04-12
---

## 核心摘要

本文深入探討了從"提示工程"到"上下文工程"的範式轉變。核心發現：**150-300 詞是提示的最佳長度**，超過 3,000 tokens 會導致效能顯著下降。現代推理模型（GPT-5, Claude 4, Gemini 3）內部自動思考，傳統的"逐步思考"提示反而可能損害效能。

**七大核心要素：**
1. Role/Persona：啟用領域知識
2. Task Context：背景和受眾資訊
3. Clear Instructions：核心請求
4. Sequential Steps：確保執行順序
5. Few-shot Examples：3-5 個多樣化示例
6. Output Format：響應結構
7. Constraints：縮小輸出空間

**三大實驗室的收斂趨勢：**
- Claude 4.x：字面理解指令，CoT 有益但非必須
- GPT-4.1/5：衝突指令有害，避免對 o 系列使用 CoT
- Gemini 3：無需複雜提示工程，簡化提示即可

**三大框架：**
- **APE**（簡單任務）：Action + Purpose + Expectation
- **CO-STAR**（內容創作）：Context, Objective, Style, Tone, Audience, Response
- **RISEN**（複雜任務）：Role, Instructions, Steps, End Goal, Narrowing

**關鍵洞察：**
- 16K token 的 RAG 提示優於 128K token 的完整上下文
- 提示工程可提升 20-40% 基準效能
- 示例的選擇比數量更重要，多樣性是關鍵
- 現代模型預設思考，顯式請求"直接答案"反而有害

## 關聯連線
- [[Prompt_Engineering]] — 提示工程總覽
- [[Context_Engineering]] — 上下文工程
- [[APE_Framework]] — APE 框架
- [[CO-STAR_Framework]] — CO-STAR 框架
- [[RISEN_Framework]] — RISEN 框架
