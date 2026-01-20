# Module 8: Get started with natural language processing in Microsoft Foundry

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/get-started-language-azure/)

* [Understand natural language processing on Azure](#understand-natural-language-processing-on-azure)
* [Understand Azure Language's text analysis capabilities](#understand-azure-languages-text-analysis-capabilities)

---

## Understand natural language processing on Azure

[Module Reference](https://learn.microsoft.com/training/modules/get-started-text-analysis-foundry/)

**Core Natural Language Processing (NLP) Tasks**

* **Language detection**: Identify the language of input text.
* **Sentiment analysis**: Determine whether text expresses positive, negative, or neutral sentiment.
* **Named entity recognition (NER)**: Identify entities such as people, places, organizations, and dates.
* **Text classification**: Categorize text based on its content.
* **Translation**: Convert text from one language to another.
* **Summarization**: Produce a concise summary of longer text.

**Foundry Tools That Support NLP**

* **Azure Language service**

  * Cloud-based service for understanding and analyzing text.
  * Supports:

    * **Sentiment analysis**
    * **Key phrase identification**
    * **Text summarization**
    * **Conversational language understanding**
* **Azure Translator service**

  * Cloud-based translation service.
  * Uses **Neural Machine Translation (NMT)**.
  * Analyzes **semantic context** to produce more accurate and complete translations.

**Key Facts to Remember**

* Core NLP tasks include **language detection, sentiment analysis, NER, text classification, translation, and summarization**.
* **Azure Language** focuses on text understanding and analysis features.
* **Azure Translator** uses **NMT** to improve translation accuracy by considering semantic context.

---

## Understand Azure Language's text analysis capabilities

[Module Reference](https://learn.microsoft.com/training/modules/get-started-text-analysis-microsoft-fabric/)

**Azure Language Overview**

* **Azure Language** is part of **Foundry Tools**
* Performs **advanced natural language processing (NLP)** on **unstructured text**
* Provides prebuilt text analysis features without requiring model training

**Text Analysis Features**

* **Named entity recognition (NER)**

  * Identifies entities such as **people, places, events**
  * Can be customized to extract **custom categories**
* **Entity linking**

  * Links recognized entities to **specific Wikipedia articles**
  * Used to **disambiguate entities**
* **Personal identifying information (PII) detection**

  * Identifies **personally sensitive information**
  * Includes **personal health information (PHI)**
* **Language detection**

  * Detects the language of the text
  * Returns a **language name**, **ISO 639-1 code**, and **confidence score**
* **Sentiment analysis and opinion mining**

  * Determines whether text is **positive, neutral, or negative**
* **Summarization**

  * Identifies and returns the **most important information**
* **Key phrase extraction**

  * Extracts the **main concepts** from unstructured text

**Entity Recognition**

* An **entity** is an item with a **type** and sometimes a **subtype**
* Supported entity types include:

| Type                  | Subtype     | Example                                                 |
| --------------------- | ----------- | ------------------------------------------------------- |
| Person                | —           | “Bill Gates”, “John”                                    |
| Location              | —           | “Paris”, “New York”                                     |
| Organization          | —           | “Microsoft”                                             |
| Quantity              | Number      | “6”, “six”                                              |
| Quantity              | Percentage  | “25%”, “fifty percent”                                  |
| Quantity              | Ordinal     | “1st”, “first”                                          |
| Quantity              | Age         | “30 years old”                                          |
| Quantity              | Currency    | “10.99”                                                 |
| Quantity              | Dimension   | “10 miles”, “40 cm”                                     |
| Quantity              | Temperature | “45 degrees”                                            |
| DateTime              | —           | “6:30PM February 4, 2012”                               |
| DateTime              | Date        | “May 2nd, 2017”                                         |
| DateTime              | Time        | “8am”                                                   |
| DateTime              | DateRange   | “May 2nd to May 5th”                                    |
| DateTime              | TimeRange   | “6pm to 7pm”                                            |
| DateTime              | Duration    | “1 minute and 45 seconds”                               |
| DateTime              | Set         | “every Tuesday”                                         |
| URL                   | —           | “[https://www.bing.com”](https://www.bing.com”)         |
| Email                 | —           | “[support@microsoft.com](mailto:support@microsoft.com)” |
| US-based Phone Number | —           | “(312) 555-0176”                                        |
| IP Address            | —           | “10.0.1.125”                                            |

**Entity Linking**

* Returns a **Wikipedia URL** for recognized entities
* Used to clarify meaning when entities are ambiguous

**Language Detection**

* For each document, Azure Language returns:

  * **Language name** (e.g., English)
  * **ISO 639-1 code** (e.g., en)
  * **Confidence score**
* Detects the **predominant language**, even in mixed-language text
* Mixed-language content may result in a **confidence score < 1**
* Ambiguous or minimal text (for example `:-)`) returns:

  * Language name: **unknown**
  * Language code: **unknown**
  * Score: **NaN**

**Sentiment Analysis and Opinion Mining**

* Uses a **prebuilt machine learning classification model**
* Returns sentiment in **three categories**:

  * **Positive**
  * **Neutral**
  * **Negative**
* Each category includes a **score from 0 to 1**
* A single **document-level sentiment** is also returned

**Key Phrase Extraction**

* Identifies **main points and concepts** from text
* Useful for summarizing large volumes of customer feedback
* Extracted phrases represent **important themes** rather than full sentences

**Key Facts to Remember**

* **Azure Language** is part of **Foundry Tools**
* **Entity linking** returns **Wikipedia URLs**
* **Language detection** returns name, ISO code, and confidence score
* **Predominant language** is returned for mixed-language text
* **Sentiment scores** range from **0 to 1** across three categories
* **Ambiguous text** can return **unknown language** and **NaN score**
* **Key phrase extraction** highlights core concepts, not summaries

---
