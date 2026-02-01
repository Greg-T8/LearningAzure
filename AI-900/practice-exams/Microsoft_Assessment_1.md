<img src='.img/2026-01-31-05-38-37.png' width=700>


---

## Wrong Answers

<img src='.img/2026-01-31-04-54-58.png' width=700>

<details>
<summary>Click to expand</summary>

## Why You Missed This Question

You selected **Key Phrase Extraction**, but the correct answer is **Named Entity Recognition (NER)**. Here's a clearer breakdown of why:

### The Key Difference

| Feature | What It Does | Example Output |
|---------|--------------|----------------|
| **Key Phrase Extraction** | Identifies the *main topics or concepts* in text | "machine learning", "cloud computing", "data analysis" |
| **Named Entity Recognition** | Identifies and *classifies specific entities* into categories like **people, places, organizations** | "John Smith" → Person, "Seattle" → Location, "Microsoft" → Organization |

### Why NER is Correct for This Scenario

The question specifically asks about extracting **"information and concepts, such as people and locations, for classification purposes."**

The critical phrase here is **"such as people and locations"** — these are **named entities**, not key phrases.

- **NER** categorizes text into predefined entity types (Person, Location, Organization, Date, Quantity, etc.)
- **Key Phrase Extraction** just pulls out important topics/themes without categorizing them

### For an Article Recommendation System

NER is ideal because:

- You can recommend articles about the **same person** mentioned
- You can recommend articles about the **same location**
- You can group articles by **organization** or **company**

Key phrase extraction would only tell you "this article is about technology" — it wouldn't distinguish between *who* or *where*.

### Quick Memory Trick

- **Key Phrase** = "What is this about?" (topics)
- **NER** = "Who/What/Where specifically?" (classified entities)

</details>

---

<img src='.img/2026-01-31-05-01-55.png' width=700>

<details>
<summary>Click to expand</summary>

## Why You Missed This Question

You selected **Text Translation** as part of Azure Speech service, but it actually belongs to a different Azure service. You got 2 out of 3 correct!

### The Key Distinction: Speech vs. Translator Services

| Azure Service | Features |
|---------------|----------|
| **Azure Speech** | Language identification, Speaker recognition, Voice assistants, Speech-to-text, Text-to-speech |
| **Azure Translator** | Text translation, Document translation |

### Why Text Translation is NOT Part of Speech Service

This is a common mix-up because both services deal with language. Here's the conceptual difference:

- **Azure Speech** = Deals with **audio/voice** processing
  - Converting speech ↔ text
  - Identifying *who* is speaking
  - Identifying *what language* is being spoken
  - Building voice-enabled assistants

- **Azure Translator** = Deals with **text/document** conversion between languages
  - Translating written text from one language to another
  - Translating entire documents

### The Correct Three Answers

| ✅ Correct | Why It's Part of Speech |
|-----------|------------------------|
| **Language Identification** | Detects which language is being *spoken* in audio |
| **Speaker Recognition** | Identifies or verifies *who* is speaking based on voice |
| **Voice Assistants** | Builds conversational voice-driven experiences |

### Quick Memory Trick

Ask yourself: **"Does this feature involve audio/voice?"**

- **Yes** → Azure Speech
- **No, just text** → Azure Translator

Text translation works on written text without any audio component, so it belongs to Translator, not Speech.

</details>

---

<img src='.img/2026-01-31-05-03-17.png' width=700>

<details>
<summary>Click to expand</summary>

## Why You Missed This Question

You selected **CSV** instead of **DOC** as one of the supported file types for generating a knowledge base with Azure AI Bot Service. You got 1 out of 2 correct!

### The Key Concept: What File Types Can Build a Knowledge Base?

Azure AI Bot Service (used with Microsoft Foundry Agent) can import files to automatically generate **question-and-answer pairs** for a knowledge base. The service needs to extract structured Q&A content from documents.

### Supported vs. Unsupported File Types

| File Type | Supported? | Why |
|-----------|------------|-----|
| ✅ **DOC/DOCX** | Yes | Word documents contain structured/unstructured text that can be parsed for Q&A pairs |
| ✅ **PDF** | Yes | PDFs contain readable text content that can be extracted and processed |
| ❌ **CSV** | No | CSV is structured data (rows/columns), not natural language Q&A content |
| ❌ **MP4** | No | Video files — Bot Service can't process multimedia |
| ❌ **ZIP** | No | Archive files must be extracted first before contents can be imported |

### Why CSV Seems Like It Should Work (But Doesn't)

This is a reasonable assumption! CSV files are:

- Structured and organized
- Often used for data import/export
- Easy to parse programmatically

**However**, the knowledge base import is designed for **natural language documents** — files where Q&A pairs can be extracted from flowing text, FAQs, or documentation. CSV files are meant for tabular data, not conversational Q&A content.

### Quick Memory Trick

Think: **"What would a human read to learn from?"**

- 📄 **DOC/PDF** → Documents humans read → ✅ Supported
- 📊 **CSV** → Data tables for spreadsheets → ❌ Not supported
- 🎥 **MP4** → Video content → ❌ Not supported
- 📦 **ZIP** → Container, not content → ❌ Must extract first

</details>

---

<img src='.img/2026-01-31-05-05-27.png' width=700>

<details>
<summary>Click to expand</summary>

## Why You Missed This Question

You selected **Extracting handwritten text from online images** as an NLP workload, but it's actually a **Computer Vision** workload, not NLP. You got 1 out of 2 correct!

### The Key Distinction: NLP vs. Computer Vision

| AI Workload Type | What It Processes | Examples |
|------------------|-------------------|----------|
| **Natural Language Processing (NLP)** | **Text/Language** — understanding, analyzing, or transforming written or spoken words | Sentiment analysis, Translation, Text summarization, Named entity recognition |
| **Computer Vision** | **Images/Video** — extracting information from visual content | OCR (text extraction from images), Image tagging, Object detection, Facial recognition |

### Why Your Answers Were Scored This Way

| Your Selection | Correct? | Why |
|----------------|----------|-----|
| ✅ Performing sentiment analysis on social media data | Correct | Analyzes **text** to determine emotional tone (positive/negative/neutral) — pure NLP |
| ❌ Extracting handwritten text from online images | Incorrect | Uses **OCR (Optical Character Recognition)** which is a **Computer Vision** task |
| ⬜ Translating text between languages from product reviews | Should have selected | Converts **text** from one language to another — pure NLP (Azure Translator) |

### The Tricky Part Explained

"Extracting handwritten text from images" involves text, which is why it seems like NLP. However:

- **The INPUT is an image** → Computer Vision analyzes the visual pixels
- **The OUTPUT is text** → But the AI workload itself is image processing (OCR)

Think of it this way:

- **NLP starts with text** → processes text
- **Computer Vision starts with images** → even if it outputs text

### Quick Memory Trick

Ask: **"What is the AI analyzing as input?"**

- **Text/Language** → NLP
- **Images/Video** → Computer Vision

Even though OCR *produces* text, it *analyzes* images — so it's Computer Vision! 🖼️

</details>

---

<img src='.img/2026-01-31-05-18-29.png' width=700>




---

<img src='.img/2026-01-31-05-23-10.png' width=700>

<details>
<summary>Click to expand</summary>

## Why You Missed This Question

You selected **Metaprompt and Grounding**, but the correct answer is **Safety System**. This question tests your understanding of the different layers in responsible AI architecture.

### The Four Layers of Responsible AI Architecture

| Layer | Purpose | Examples |
|-------|---------|----------|
| **Model** | The underlying AI model itself | GPT-4, GPT-3.5-turbo |
| **Safety System** | Platform-level protections that filter/monitor content | **Content filters**, abuse monitoring, rate limiting |
| **Metaprompt & Grounding** | Instructions and context to guide model behavior | System prompts, RAG data, few-shot examples |
| **User Experience** | How users interact with the system | UI design, input validation, user controls |

### Why Safety System is Correct

**Content filters** are applied at the **Safety System layer** because they are:

- **Platform-level configurations** (not prompt-based instructions)
- **Automated screening mechanisms** that evaluate content before and after the model processes it
- **Policy enforcement tools** that classify content into severity levels:
  - **Categories**: Hate, Sexual, Violence, Self-harm
  - **Severity**: Safe, Low, Medium, High
- **Hard stops** that can block requests/responses regardless of what the model wants to generate

### Why Metaprompt & Grounding is NOT Correct

**Metaprompts and grounding** work differently:

| Metaprompt & Grounding | Safety System (Content Filters) |
|------------------------|--------------------------------|
| "Please don't generate harmful content" (instruction) | Automatically scans and blocks harmful content (enforcement) |
| Model *interprets* and *follows* guidance | Filter *intercepts* and *prevents* output |
| Can be bypassed through clever prompting (jailbreaks) | Cannot be bypassed — runs outside the model |
| Shapes behavior through context | Enforces policy through detection |

### The Key Distinction

Think of it like this:

- **Metaprompt/Grounding** = Asking someone politely to behave ☝️
- **Safety System** = Installing a security checkpoint that physically blocks entry 🚧

Content filters are **technical safeguards**, not **behavioral guidance**.

### Quick Memory Trick

**"Filters" = Safety System**

- Content **filters** filter at the **safety system** layer
- It's a platform feature, not a prompt technique
- Think: **System-level protection** = Safety System

</details>


---

<img src='.img/2026-01-31-05-25-11.png' width=700>

---

<img src='.img/2026-01-31-05-31-17.png' width=700>

---

<img src='.img/2026-01-31-05-34-17.png' width=700>

---




## Correct Answers

<img src='.img/2026-01-31-04-52-51.png' width=700>

---

<img src='.img/2026-01-31-04-54-11.png' width=700>

---


<img src='.img/2026-01-31-04-55-43.png' width=700>

---

<img src='.img/2026-01-31-04-57-10.png' width=700>

---

<img src='.img/2026-01-31-04-58-23.png' width=700>

---

<img src='.img/2026-01-31-04-59-33.png' width=700>

---

<img src='.img/2026-01-31-05-04-01.png' width=700>

---

<img src='.img/2026-01-31-05-04-23.png' width=700>

---

<img src='.img/2026-01-31-05-04-44.png' width=700>

---

<img src='.img/2026-01-31-05-06-43.png' width=700>

---

<img src='.img/2026-01-31-05-07-23.png' width=700>

---

<img src='.img/2026-01-31-05-08-28.png' width=700>

---

<img src='.img/2026-01-31-05-08-58.png' width=700>

---

<img src='.img/2026-01-31-05-09-43.png' width=700>

---

<img src='.img/2026-01-31-05-10-11.png' width=700>

---

<img src='.img/2026-01-31-05-10-39.png' width=700>

---

<img src='.img/2026-01-31-05-14-45.png' width=700>

---

<img src='.img/2026-01-31-05-16-11.png' width=700>

---

<img src='.img/2026-01-31-05-16-40.png' width=700>

---


<img src='.img/2026-01-31-05-19-07.png' width=700>

---

<img src='.img/2026-01-31-05-19-31.png' width=700>

---

<img src='.img/2026-01-31-05-20-14.png' width=700>

---

<img src='.img/2026-01-31-05-21-00.png' width=700>

---

<img src='.img/2026-01-31-05-21-29.png' width=700>

---

<img src='.img/2026-01-31-05-22-07.png' width=700>

---


<img src='.img/2026-01-31-05-24-33.png' width=700>


---

<img src='.img/2026-01-31-05-25-47.png' width=700>

---

<img src='.img/2026-01-31-05-26-09.png' width=700>

---

<img src='.img/2026-01-31-05-27-52.png' width=700>

---

<img src='.img/2026-01-31-05-29-05.png' width=700>

---

<img src='.img/2026-01-31-05-29-38.png' width=700>

---

<img src='.img/2026-01-31-05-30-14.png' width=700>

---


<img src='.img/2026-01-31-05-31-47.png' width=700>

---

<img src='.img/2026-01-31-05-32-44.png' width=700>

---

<img src='.img/2026-01-31-05-33-10.png' width=700>

---

<img src='.img/2026-01-31-05-33-49.png' width=700>

---


<img src='.img/2026-01-31-05-34-56.png' width=700>

---

<img src='.img/2026-01-31-05-35-57.png' width=700>

---

<img src='.img/2026-01-31-05-36-35.png' width=700>

---

<img src='.img/2026-01-31-05-37-14.png' width=700>

---

<img src='.img/2026-01-31-05-38-02.png' width=700>
