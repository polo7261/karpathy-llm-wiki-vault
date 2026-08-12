---
title: "提示設計策略  |  Gemini API"
source: "https://ai.google.dev/gemini-api/docs/prompting-strategies?hl=zh-cn"
author:
published:
created: 2026-04-12
description:
tags:
  - "clippings"
---
不妨試用全新高速且經濟實惠的 [Veo 3.1 Lite](https://ai.google.dev/gemini-api/docs/models/veo-3.1-lite-generate-preview?hl=zh-cn) 模型，大規模生成影片。

提示設計是指建立提示（即自然語言請求）的過程，這些提示將用來從語言模型獲得準確、高畫質的回答。

本頁面介紹了一些基本概念、策略和最佳實踐，可幫助您開始設計提示，以便充分利用 Gemini AI 模型。

## 針對特定主題的提示指南

想要了解更具體的提示策略？不妨檢視我們的其他提示指南：

- [使用媒體檔案進行提示](https://ai.google.dev/gemini-api/docs/files?hl=zh-cn#prompt-guide)
- 使用 [Imagen](https://ai.google.dev/gemini-api/docs/imagen?hl=zh-cn#imagen-prompt-guide) 和 [Gemini 原生圖片生成](https://ai.google.dev/gemini-api/docs/image-generation?hl=zh-cn#prompt-guide) 功能生成圖片的提示
- [影片生成提示](https://ai.google.dev/gemini-api/docs/video?hl=zh-cn#prompt-guide)

您可以在 [提示庫](https://ai.google.dev/gemini-api/prompts?hl=zh-cn) 中找到其他示例提示，這些提示旨在以互動方式展示本指南中分享的許多概念。

## 清晰具體的說明

自訂模型行為的一種有效且高效的方法是向模型提供清晰具體的指令。指令可以採用問題、分步任務的形式，也可以很複雜，例如反映使用者的體驗和思維模式。

### 輸入

輸入是提示中您希望模型為其提供回答的必需文本。輸入可以是模型回答的問題（問題輸入）、模型執行的任務（任務輸入）、模型操作的實體（實體輸入），或模型完成或繼續的部分輸入（補全輸入）。

| **輸入型別** | **提示** | **生成的輸出** |
| --- | --- | --- |
| Question | ``` What's a good name for a flower shop that specializes in selling bouquets of dried flowers? Create a list of 5 options with just the names. ``` | ``` Here are 5 names for a flower shop specializing in dried flowers:  1. Everlasting Blooms 2. Dried & Delightful 3. The Petal Preserve 4. Whispers of Wildflowers 5. Forever Blooms ``` |
| 任務 | ``` Give me a simple list of just the things that I must bring on a camping trip. The list should have 5 items. ``` | ``` 1. **Tent:** Your shelter from the elements. 2. **Sleeping Bag:** Stay warm and comfortable. 3. **Sleeping Pad:** Insulation and cushioning for a good night's sleep. 4. **Headlamp or Flashlight:** Light for nighttime activities. 5. **First Aid Kit:** Be prepared for minor injuries. ``` |
| 實體 | ``` Classify the following items as [large, small]: Elephant Mouse Snail ``` | ``` Here's the classification:  * **Elephant:** Large * **Mouse:** Small * **Snail:** Small ``` |

#### 部分輸入內容補全

生成式語言模型的工作方式類似於高階自動補全工具。當您提供部分內容時，模型可以提供剩餘的內容或者它認為是該內容的延續內容來作為回答。如果您添加了任何示例或上下文，模型可以參考這些示例或上下文。

以下示例提供了包含指令和實體輸入的提示：

```
For the given order, return a JSON object that has the fields cheeseburger, hamburger, fries, or
drink, with the value being the quantity.

Order: A burger and a drink.
```
```
{
  "cheeseburger": 0,
  "hamburger": 1,
  "fries": 0,
  "drink": 1
}
```

雖然模型按照提示提供了回答，但以自然語言編寫指令有時可能並不容易，並且模型需要解釋許多內容。例如，餐館選單可能包含許多菜品。為了減小 JSON 回答的大小，建議您省略沒有點的菜品。在這種情況下，您可以提供一個示例和回答字首，讓模型來補全它：

```
Valid fields are cheeseburger, hamburger, fries, and drink.
Order: Give me a cheeseburger and fries
Output:
\`\`\`
{
  "cheeseburger": 1,
  "fries": 1
}
\`\`\`
Order: I want two burgers, a drink, and fries.
Output:
```
```
\`\`\`
{
  "hamburger": 2,
  "drink": 1,
  "fries": 1
}
\`\`\`
```

可以看到，輸出中排除了“芝士漢堡”，因為點餐中沒有芝士漢堡。

雖然您可以使用提示指定簡單 JSON 響應物件的格式，但我們建議您在為響應指定更復雜的 JSON 架構時，使用 Gemini API 的 [結構化輸出](https://ai.google.dev/gemini-api/docs/structured-output?hl=zh-cn) 功能。

### 限制條件

指定有關讀取提示或生成回答的任何限制條件。您可以告訴模型要做什麼和不應該做什麼。例如，您可以在提示中指定一個限制條件，以限制摘要長度：

```
Summarize this text in one sentence:
Text: A quantum computer exploits quantum mechanical phenomena to perform calculations exponentially
faster than any modern traditional computer. At very tiny scales, physical matter acts as both
particles and as waves, and quantum computing uses specialized hardware to leverage this behavior.
The operating principles of quantum devices is beyond the scope of classical physics. When deployed
at scale, quantum computers could be used in a wide variety of applications such as: in
cybersecurity to break existing encryption methods while helping researchers create new ones, in
meteorology to develop better weather forecasting etc. However, the current state of the art quantum
computers are still largely experimental and impractical.
```
```
Exploiting quantum mechanical phenomena, quantum computers can perform calculations exponentially faster than traditional computers for potential applications like cybersecurity and meteorology, although they are currently largely experimental and impractical.
```

### 回答格式

您可以提供指定回答格式的說明。例如，您可以要求將回答格式設定為表格、專案符號列表、電梯間推銷、關鍵字、句子或段落。以下系統指令會指示模型在回答時更具對話性：

```
All questions should be answered comprehensively with details, unless the user requests a concise response specifically.
```
```
What is a smart way to make a business that sells DVD's in 2026?
```
```
Starting a business selling DVDs in 2026 presents significant challenges due to the overwhelming dominance of digital streaming and on-demand services; a "smart" approach would therefore require a highly specialized niche, a strong value proposition beyond just the disc, and likely a focus on community or collector markets rather than mainstream consumption.

Here's a breakdown of what a smart DVD business in 2026 would likely entail:

1. Extreme Niche Specialization: You cannot compete with streaming libraries. Your business must focus on what digital doesn't offer easily or at all. This could include:

    * Out-of-Print & Rare Titles: Sourcing films or TV shows that have never been released digitally or are currently unavailable on major streaming platforms.
    ....
```

#### 使用補全策略設定回答格式

[補全策略](#completion) 也有助於設定回答的格式。 以下示例提示模型建立論文大綱：

```
Create an outline for an essay about hummingbirds.
```
```
Here is a possible outline for an essay about hummingbirds:

I. Introduction
A. Hook: Start with a captivating fact or description about hummingbirds (e.g., their speed, iridescent colors, or tiny size).
B. Background: Briefly introduce hummingbirds – where they are found (Americas), their reputation as unique birds.
C. Thesis Statement: State the main point of the essay, which could be about the remarkable adaptations, behaviors, and ecological importance of hummingbirds.

II. Appearance and Identification
.....
```

提示沒有指定大綱的格式，模型為您選擇了格式。如需使模型以特定格式返回大綱，您可以新增表示大綱開頭的文本，並讓模型根據您起頭的模式補全大綱。

```
Create an outline for an essay about hummingbirds.
I. Introduction
   *
```
```
Okay, here is an outline for an essay about hummingbirds, starting from the introduction you provided:

I. Introduction
* Hook: Start with a captivating fact or description about hummingbirds (e.g., their speed, iridescent colors, or tiny size).
* Background: Briefly introduce hummingbirds – where they are found (Americas), their reputation as unique birds, and their general characteristics.
* Thesis Statement: State the main point of the essay, focusing on the remarkable adaptations, behaviors, and ecological significance that make hummingbirds extraordinary.
.....
```

## 零樣本提示與少樣本提示

您可以在提示中新增示例，以向模型示範想要的結果。模型會嘗試識別示例中的模式和關係，並在生成回答時應用它們。包含少量示例的提示稱為少樣本提示，而不提供示例的提示稱為零樣本提示。少樣本提示通常用於規定模型回答的格式、措辭、範圍界定或一般模式。使用具體而多樣的示例來幫助模型縮小其重點並生成更準確的結果。

我們建議始終在提示中包含少樣本示例。不含少樣本示例的提示可能效果不大。事實上，如果您的示例足夠清晰地顯示當前任務，則您可以從提示中移除指令。

以下零樣本提示要求模型選擇最佳解釋。

```
Please choose the best explanation to the question:

Question: How is snow formed?
Explanation1: Snow is formed when water vapor in the air freezes into ice
crystals in the atmosphere, which can combine and grow into snowflakes as they
fall through the atmosphere and accumulate on the ground.
Explanation2: Water vapor freezes into ice crystals forming snow.
Answer:
```
```
Explanation1 is the better explanation because it provides more detail on the
process, including how ice crystals combine and grow into snowflakes as they
fall through the atmosphere.
```

如果您的用例要求模型生成簡潔的回答，您可以在提示中新增偏好簡潔回答的示例。

以下提示提供了兩個偏好較短解釋的示例。在回答中，您可以看到這些示例引導模型選擇較短的解釋 (`Explanation2`)，而不是像之前那樣較長的解釋 (`Explanation1`)。

```
Below are some examples showing a question, explanation, and answer format:

Question: Why is the sky blue?
Explanation1: The sky appears blue because of Rayleigh scattering, which causes
shorter blue wavelengths of light to be scattered more easily than longer red
wavelengths, making the sky look blue.
Explanation2: Due to Rayleigh scattering effect.
Answer: Explanation2

Question: What is the cause of earthquakes?
Explanation1: Sudden release of energy in the Earth's crust.
Explanation2: Earthquakes happen when tectonic plates suddenly slip or break
apart, causing a release of energy that creates seismic waves that can shake the
ground and cause damage.
Answer: Explanation1

Now, Answer the following question given the example formats above:

Question: How is snow formed?
Explanation1: Snow is formed when water vapor in the air freezes into ice
crystals in the atmosphere, which can combine and grow into snowflakes as they
fall through the atmosphere and accumulate on the ground.
Explanation2: Water vapor freezes into ice crystals forming snow.
Answer:
```
```
Answer: Explanation2
```

### 最佳示例數量

Gemini 等模型通常可以通過少量示例來學習模式，但您可能需要進行多次實驗，以找到可產生最佳結果的提示中提供的示例數量。但是，如果您新增太多示例，模型的回答可能會與示例 [過擬合](https://developers.google.com/machine-learning/glossary?hl=zh-cn#overfitting) 。

### 採用風格一致的內容形式

確保少樣本示例的結構和格式相同，以避免回答具有不需要的格式。在提示中新增少樣本示例的主要目標之一是向模型展示回答格式。因此，必須確保在所有示例中使用一致的格式，尤其是注意 XML 標記、空格、換行符和示例分隔符。

## 新增上下文

您可以在提示中新增模型解決問題所需的指令和資訊，而不是假設模型具備所有必要資訊。這些上下文資訊可幫助模型瞭解您要求其執行的操作的限制和詳細資訊。

以下示例要求模型提供路由器的問題排查指導：

```
What should I do to fix my disconnected wifi? The light on my Google
Wifi router is yellow and blinking slowly.
```
```
A yellow blinking light on your Google Wifi router usually indicates a problem
  with the internet connection. Here are some steps to troubleshoot and fix the
  issue:
  1. Restart your router and modem:
    - Unplug your modem from the power outlet and wait for 30 seconds.
    - Plug your modem back in and wait for it to fully boot up.
    - Unplug your Google Wifi router and wait for 30 seconds.
    - Plug your Google Wifi router back in and wait for it to fully boot up.
.....
```

這個回答看起來是通用的問題排查資訊，並非特定於路由器或 LED 指示燈的狀態。

如需針對特定路由器自訂回答，您可以在提示中新增該路由器的問題排查指南作為上下文，供模型在回答時參考。

```
Answer the question using the text below. Respond with only the text provided.
Question: What should I do to fix my disconnected wifi? The light on my Google Wifi router is yellow and blinking slowly.

Text:
Color: Slowly pulsing yellow
What it means: There is a network error.
What to do:
Check that the Ethernet cable is connected to both your router and your modem and both devices are turned on. You might need to unplug and plug in each device again.

Color: Fast blinking yellow
What it means: You are holding down the reset button and are factory resetting this device.
What to do:
If you keep holding down the reset button, after about 12 seconds, the light will turn solid yellow. Once it is solid yellow, let go of the factory reset button.

Color: Solid yellow
What it means: Router is factory resetting.
What to do:
This can take up to 10 minutes. When it's done, the device will reset itself and start pulsing white, letting you know it's ready for setup.

Color: Solid red
What it means: Something is wrong.
What to do:
Critical failure. Factory reset the router. If the light stays red, contact Wifi customer support.
```
```
Check that the Ethernet cable is connected to both your router and your modem and both devices are turned on. You might need to unplug and plug in each device again.
```

## 將提示分解為各個組成部分

對於需要複雜提示的用例，您可以將內容細分為更簡單的組成部分，以幫助模型管理這種複雜情況。

1. **細分指令** ：不要在一個提示中包含多條指令，而要為每條指令建立一個提示。您可以根據使用者的輸入選擇要處理的提示。
2. **串聯提示** ：對於涉及多個連續步驟的複雜任務，請將每個步驟設為一個提示，並將這些提示按順序串聯在一起。在這一連串的提示中，序列中一個提示的輸出將成為下一個提示的輸入。序列中最後一個提示的輸出將是最終輸出。
3. **彙總回答** ：彙總是指對資料的不同部分執行不同的並行任務，並彙總結果以生成最終輸出。例如，您可以指示模型對資料的第一部分執行一項操作，對其餘資料執行另一項操作並彙總結果。

## 對模型引數進行實驗

您向模型傳送的每次呼叫都包含控制模型如何生成回答的引數值。對於不同的引數值，模型會生成不同的結果。因此請嘗試不同的引數值，以獲得任務的最佳值。不同模型的可用引數可能有所不同。最常見的引數如下：

1. **最大輸出詞元數** ：指定回答中可生成的詞元數量上限。詞元約為 4 個字元。100 個 token 大約對應 60-80 個單詞。
2. **溫度** ：溫度可以控制 token 選擇的隨機性。溫度 (temperature) 在生成回答期間用於取樣，在應用 `topP` 和 `topK` 時會生成回答。較低的溫度有利於需要更具確定性或更少開放性回答的提示，而較高的溫度可以帶來更具多樣性或創造性的結果。溫度為 0 表示確定性，即始終選擇機率最高的回答。
3. **`topK`** ： `topK` 引數可更改模型選擇輸出 token 的方式。如果 `topK` 設為 1，表示所選 token 是模型詞彙表的所有 token 中機率最高的 token（也稱為貪心解碼）。如果 `topK` 設為 3，則表示系統將從 3 個機率最高的 token（通過溫度確定）中選擇下一個 token。在每個詞元選擇步驟中，系統都會對機率最高的 `topK` 個詞元進行取樣。然後，系統會根據 `topP` 進一步過濾詞元，並使用溫度取樣選擇最終的詞元。
4. **`topP`** ： `topP` 引數可更改模型選擇輸出 token 的方式。系統會按照機率從最高到最低的順序選擇 token，直到所選 token 的機率總和等於 `topP` 值。例如，如果詞元 A、B 和 C 的機率分別為 0.3、0.2 和 0.1，並且 `topP` 值為 0.5，則模型將選擇 A 或 B 作為下一個詞元（通過溫度確定），並會排除 C 作為候選詞元。預設 `topP` 值為 0.95。
5. **`stop_sequences`** ：設定停止序列，告知模型停止生成內容。停止序列可以是任意字元序列。儘量避免使用可能會出現在生成內容中的字元序列。

## 提示迭代策略

提示設計有時需要進行幾次迭代，然後才能穩定獲得所需的回答。本部分提供了有關在迭代提示時可以嘗試的一些做法的指導：

1. **使用不同的措辭** ：即使含義相同，在提示中使用不同的字詞或措辭通常也會使模型生成不同的回答。如果您的提示無法產生預期結果，請嘗試重新措辭。
	```
	Version 1:
	How do I bake a pie?
	Version 2:
	Suggest a recipe for a pie.
	Version 3:
	What's a good pie recipe?
	```
2. **改用類似任務** ：如果您無法讓模型遵循您的任務指令，請嘗試為其提供可實現相同結果的類似任務的指令。
	此提示指示模型使用預定義的類別對一本書進行分類：
	```
	Which category does The Odyssey belong to:
	thriller
	sci-fi
	mythology
	biography
	```
	```
	The Odyssey belongs to the category of **mythology**. 
	    Here's why:
	    * **Mythology:** The Odyssey tells the story of Odysseus, a hero from Greek mythology, and his
	    journey home after the Trojan War. It features gods, monsters, and supernatural events common to
	    Greek mythology.
	.....
	```
	回答正確，但模型超出了選項的範圍。您還希望模型僅使用其中一個選項（而不是完整的句子）來回答。在這種情況下，您可以將指令改為單選題，並要求模型選擇一個選項。
	```
	Multiple choice problem: Which of the following options describes the book The Odyssey?
	Options:
	thriller
	sci-fi
	mythology
	biography
	```
	```
	The correct answer is mythology.
	```
3. **更改提示內容的順序** ：提示中內容的順序有時會影響回答。請嘗試更改內容順序，看看對回答有何影響。
	```
	Version 1:
	[examples]
	[context]
	[input]
	Version 2:
	[input]
	[examples]
	[context]
	Version 3:
	[examples]
	[input]
	[context]
	```

## 後備響應

後備回答是當提示或回答觸發安全過濾條件時模型返回的回答。後備回答的一個示例是“我無法提供幫助，因為我只是一個語言模型”。

如果模型給出後備回答，請嘗試提高溫度。

## 接地和程式碼執行

Gemini 能夠使用工具來避免在可能生成錯誤回答的情況下出現幻覺。

[依託 Google 搜尋進行接地](https://ai.google.dev/gemini-api/docs/google-search?hl=zh-cn) 可將 Gemini 模型與即時網路內容相關聯，當模型可能需要了解冷門或最新事即時，應啟用此功能。

Gemini 的 [程式碼執行工具](https://ai.google.dev/gemini-api/docs/code-execution?hl=zh-cn) 可讓模型生成和執行 Python 程式碼，並且只要模型需要執行任何型別的算術、計數或計算，就應啟用該工具。

## Gemini 3

[Gemini 3 模型](https://ai.google.dev/gemini-api/docs/models?hl=zh-cn#gemini-3) 專為高階推理和指令遵從而設計。它們最能理解直接、結構合理且清晰定義了任務和任何限制條件的提示。建議採用以下做法，以充分發揮 Gemini 3 的效能：

### 核心提示原則

- **用詞要準確、直接** ：清晰簡潔地說明您的目標。避免使用不必要或過於具有說服力的語言。
- **使用一致的結構** ：使用清晰的分隔符分隔提示的不同部分。XML 樣式的標記（例如 `<context>` 、 `<task>` ）或 Markdown 標題都有效。選擇一種格式，並在單個提示中始終使用該格式。
- **定義引數** ：明確說明任何模稜兩可的術語或引數。
- **控制輸出詳細程度** ：預設情況下，Gemini 3 模型會提供直接而高效的回答。如果您需要更口語化或更詳細的回答，必須在指令中明確提出要求。
- **連貫地處理多模態輸入** ：使用文本、圖片、音訊或影片時，將它們視為同類輸入。確保您的說明根據需要清楚地提及每種模態。
- **優先處理關鍵指令** ：將必要的行為限制、角色定義（角色設定）和輸出格式要求放在系統指令中或使用者提示的最開頭。
- **長上下文的結構** ：提供大量上下文（例如文件、程式碼）時，請先提供所有上下文。將具體說明或問題放在提示的 *末尾* 。
- **錨定上下文** ：在提供大量資料後，使用清晰的過渡短語來連線上下文和您的查詢，例如“根據上述資訊…”

### Gemini 3 Flash 策略

- **當前日期準確性** ：在系統指令中新增以下子句，以幫助模型注意當前日期是 2026 年：
	```
	For time-sensitive user queries that require up-to-date information, you
	MUST follow the provided current time (date and year) when formulating
	search queries in tool calls. Remember it is 2026 this year.
	```
- **知識截點準確性** ：在系統指令中新增以下子句，讓模型瞭解其知識截點：
	```
	Your knowledge cutoff date is January 2025.
	```
- **事實依據效能** ：在系統指令中新增以下子句（可根據需要進行修改），以提高模型根據所提供的上下文生成回答的能力：
	```
	You are a strictly grounded assistant limited to the information provided in
	the User Context. In your answers, rely **only** on the facts that are
	directly mentioned in that context. You must **not** access or utilize your
	own knowledge or common sense to answer. Do not assume or infer from the
	provided facts; simply report them exactly as they appear. Your answer must
	be factual and fully truthful to the provided text, leaving absolutely no
	room for speculation or interpretation. Treat the provided context as the
	absolute limit of truth; any facts or details that are not directly
	mentioned in the context must be considered **completely untruthful** and
	**completely unsupported**. If the exact answer is not explicitly written in
	the context, you must state that the information is not available.
	```

### 增強推理和規劃能力

Gemini 2.5 和 3 系列模型會自動生成內部“思考”文本，以提升推理效能。因此，一般而言，無需在返回的回答中包含模型大綱、計劃或詳細推理步驟。對於需要大量推理的問題，簡單的請求（例如“在回答之前認真思考”）可以提高效能，但會消耗額外的思考 token。

如需瞭解詳情，請參閱 [Gemini 思維](https://ai.google.dev/gemini-api/docs/thinking?hl=zh-cn) 文件。

### 結構化提示示例

使用標記或 Markdown 有助於模型區分指令、上下文和任務。

**XML 示例** ：

```
<role>
You are a helpful assistant.
</role>

<constraints>
1. Be objective.
2. Cite sources.
</constraints>

<context>
[Insert User Input Here - The model knows this is data, not instructions]
</context>

<task>
[Insert the specific user request here]
</task>
```

**Markdown 示例** ：

```
# Identity
You are a senior solution architect.

# Constraints
- No external libraries allowed.
- Python 3.11+ syntax only.

# Output format
Return a single code block.
```

### 結合了最佳實踐的模板示例

此模板涵蓋了 Gemini 3 的提示核心原則。請務必根據您的具體使用場景進行迭代和修改。

**系統指令** ：

```
<role>
You are Gemini 3, a specialized assistant for [Insert Domain, e.g., Data Science].
You are precise, analytical, and persistent.
</role>

<instructions>
1. **Plan**: Analyze the task and create a step-by-step plan.
2. **Execute**: Carry out the plan.
3. **Validate**: Review your output against the user's task.
4. **Format**: Present the final answer in the requested structure.
</instructions>

<constraints>
- Verbosity: [Specify Low/Medium/High]
- Tone: [Specify Formal/Casual/Technical]
</constraints>

<output_format>
Structure your response as follows:
1. **Executive Summary**: [Short overview]
2. **Detailed Response**: [The main content]
</output_format>
```

**使用者提示** ：

```
<context>
[Insert relevant documents, code snippets, or background info here]
</context>

<task>
[Insert specific user request here]
</task>

<final_instruction>
Remember to think step-by-step before answering.
</final_instruction>
```

## 智慧體工作流

對於深度智慧體工作流，通常需要提供具體指令來控制模型如何推理、規劃和執行任務。雖然 Gemini 提供了強大的通用效能，但複雜的智慧體通常需要您配置計算成本（延遲時間和 token）與任務準確率之間的權衡。

為代理設計提示時，請考慮以下可在代理中引導的行為維度：

### 推理與策略

模型在採取行動之前進行思考和規劃的配置。

- **邏輯分解** ：定義了模型必須分析約束條件、前提條件和操作順序的詳盡程度。
- **問題診斷** ：控制在確定原因時分析的深度以及模型對溯因推理的使用。確定模型是應接受最明顯的答案，還是探索複雜且可能性較低的解釋。
- **資訊詳盡程度** ：在分析所有可用政策和文件與優先考慮效率和速度之間進行權衡。

### 執行和可靠性

有關代理如何自主執行和處理障礙的配置。

- **適應性** ：模型對新資料的反應。確定是應嚴格遵守初始計劃，還是在觀測結果與假設相矛盾時立即調整。
- **永續性和恢復性** ：模型嘗試自行糾正錯誤的程度。高永續性可提高成功率，但可能會導致令牌費用增加或出現迴圈。
- **風險評估** ：用於評估後果的邏輯。明確區分低風險的探索性操作（讀取）和高風險的狀態更改（寫入）。

### 互動和輸出

用於配置代理與使用者通訊的方式以及結果的格式。

- **模糊性與權限處理** ：定義了模型何時可以進行假設，何時必須暫停執行以向使用者尋求澄清或權限。
- **詳細程度** ：控制與工具呼叫一起生成的文本的音量。此引數用於確定模型是否向使用者說明其操作，或者在執行期間保持沉默。
- **精確度和完整性** ：輸出所需的保真度。指定模型是否必須解決所有極端情況並提供確切的數字，還是可以接受大致估計。

### 系統指令模板

以下系統指令是一個示例，研究人員已對其進行評估，以提高模型在代理基準方面的效能。在代理基準方面，模型必須遵守複雜的規則手冊並與使用者互動。它會促使智慧體充當強大的推理者和規劃者，在上述各個維度上強制執行特定行為，並要求模型在採取任何行動之前主動規劃。

您可以根據自己的具體使用情形限制條件調整此模板。

```
You are a very strong reasoner and planner. Use these critical instructions to structure your plans, thoughts, and responses.

Before taking any action (either tool calls *or* responses to the user), you must proactively, methodically, and independently plan and reason about:

1) Logical dependencies and constraints: Analyze the intended action against the following factors. Resolve conflicts in order of importance:
    1.1) Policy-based rules, mandatory prerequisites, and constraints.
    1.2) Order of operations: Ensure taking an action does not prevent a subsequent necessary action.
        1.2.1) The user may request actions in a random order, but you may need to reorder operations to maximize successful completion of the task.
    1.3) Other prerequisites (information and/or actions needed).
    1.4) Explicit user constraints or preferences.

2) Risk assessment: What are the consequences of taking the action? Will the new state cause any future issues?
    2.1) For exploratory tasks (like searches), missing *optional* parameters is a LOW risk. **Prefer calling the tool with the available information over asking the user, unless** your \`Rule 1\` (Logical Dependencies) reasoning determines that optional information is required for a later step in your plan.

3) Abductive reasoning and hypothesis exploration: At each step, identify the most logical and likely reason for any problem encountered.
    3.1) Look beyond immediate or obvious causes. The most likely reason may not be the simplest and may require deeper inference.
    3.2) Hypotheses may require additional research. Each hypothesis may take multiple steps to test.
    3.3) Prioritize hypotheses based on likelihood, but do not discard less likely ones prematurely. A low-probability event may still be the root cause.

4) Outcome evaluation and adaptability: Does the previous observation require any changes to your plan?
    4.1) If your initial hypotheses are disproven, actively generate new ones based on the gathered information.

5) Information availability: Incorporate all applicable and alternative sources of information, including:
    5.1) Using available tools and their capabilities
    5.2) All policies, rules, checklists, and constraints
    5.3) Previous observations and conversation history
    5.4) Information only available by asking the user

6) Precision and Grounding: Ensure your reasoning is extremely precise and relevant to each exact ongoing situation.
    6.1) Verify your claims by quoting the exact applicable information (including policies) when referring to them. 

7) Completeness: Ensure that all requirements, constraints, options, and preferences are exhaustively incorporated into your plan.
    7.1) Resolve conflicts using the order of importance in #1.
    7.2) Avoid premature conclusions: There may be multiple relevant options for a given situation.
        7.2.1) To check for whether an option is relevant, reason about all information sources from #5.
        7.2.2) You may need to consult the user to even know whether something is applicable. Do not assume it is not applicable without checking.
    7.3) Review applicable sources of information from #5 to confirm which are relevant to the current state.

8) Persistence and patience: Do not give up unless all the reasoning above is exhausted.
    8.1) Don't be dissuaded by time taken or user frustration.
    8.2) This persistence must be intelligent: On *transient* errors (e.g. please try again), you *must* retry **unless an explicit retry limit (e.g., max x tries) has been reached**. If such a limit is hit, you *must* stop. On *other* errors, you must change your strategy or arguments, not repeat the same failed call.

9) Inhibit your response: only take an action after all the above reasoning is completed. Once you've taken an action, you cannot take it back.
```

## 後續步驟

- 現在，您已經對提示設計有了更深入的瞭解，不妨嘗試使用 [Google AI Studio](http://aistudio.google.com/?hl=zh-cn) 編寫自己的提示。
- 如需瞭解多模態提示，請參閱 [使用媒體檔案進行提示](https://ai.google.dev/gemini-api/docs/files?hl=zh-cn#prompt-guide) 。
- 如需瞭解圖片提示，請參閱 [Nano Banana](https://ai.google.dev/gemini-api/docs/image-generation?hl=zh-cn#prompt-guide) 和 [Imagen](https://ai.google.dev/gemini-api/docs/imagen?hl=zh-cn#imagen-prompt-guide) 提示指南。
- 如需瞭解影片提示，請參閱 [Veo 提示指南](https://ai.google.dev/gemini-api/docs/video?hl=zh-cn#prompt-guide) 。