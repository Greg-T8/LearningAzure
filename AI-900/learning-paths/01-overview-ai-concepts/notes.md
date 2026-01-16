# Module 1: Overview of AI concepts

**Link:** [Overview of AI concepts](https://learn.microsoft.com/en-us/training/modules/get-started-ai-fundamentals/)

* [Generative AI Fundamentals](#generative-ai-fundamentals)
* [Natural Language Processing (NLP)](#natural-language-processing-nlp)

---

## Generative AI Fundamentals

[Module Reference](https://learn.microsoft.com/en-us/training/modules/get-started-ai-fundamentals/2-generative-ai?pivots=text)

<img src='.img/2026-01-16-04-23-41.png' width=400>

**What generative AI is**

* A class of AI systems designed to **create new content** (text, images, audio, code) rather than only analyze or classify existing data.
* Outputs are **probabilistic** and based on patterns learned from large datasets.

**Core capabilities**

* **Text generation**: drafting, summarization, translation, question answering.
* **Image generation**: creating images from text prompts.
* **Code generation**: producing code snippets or entire functions from natural language.
* **Multimodal support**: some models accept and generate across multiple content types.

**How generative AI works (high level)**

* Trained on **large datasets** to learn statistical relationships between tokens (words, pixels, etc.).
* Uses **neural networks** (commonly transformer-based for text) to predict the **next most likely token** given context.
* Generation quality depends on model size, training data, and prompt clarity.

**Prompts**

* A **prompt** is the input that guides the model’s output.
* Clear, specific prompts improve relevance and accuracy.
* Prompts can include instructions, constraints, examples, or formatting requirements.

**Use cases**

* Content creation (emails, reports, marketing copy).
* Knowledge assistance and summarization.
* Software development acceleration.
* Creative tasks (stories, images, brainstorming).

**Limitations and considerations**

* Can produce **hallucinations** (confident but incorrect outputs).
* May reflect **biases** present in training data.
* Outputs are not guaranteed to be factual or up to date without grounding.
* Requires **human review** for accuracy, ethics, and compliance.

**Responsible AI concepts**

* Validate outputs before use.
* Avoid sharing sensitive or confidential data in prompts.
* Apply governance, monitoring, and usage policies.

**Exam-relevant takeaways**

* Generative AI **creates** new content; it is not limited to prediction or classification.
* Prompts directly influence output quality.
* Outputs are probabilistic and require validation.
* Common modalities: text, images, code, and audio.

---

## Natural Language Processing (NLP)

[Module Reference](https://learn.microsoft.com/en-us/training/modules/get-started-ai-fundamentals/5-natural-language-processing?pivots=text)

**Definition**

* Natural Language Processing (NLP) is a branch of artificial intelligence that enables computers to process, analyze, understand, and generate human language.

**Why NLP is difficult**

* Human language is ambiguous and context-dependent.
* The same word can have different meanings depending on usage.
* Language includes slang, idioms, sarcasm, and grammatical variation.

**Common NLP workloads**

* **Text classification**: Assigning categories to text (for example, spam detection).
* **Sentiment analysis**: Identifying whether text expresses positive, negative, or neutral sentiment.
* **Key phrase extraction**: Identifying important terms in text.
* **Named entity recognition (NER)**: Detecting entities such as people, organizations, locations, dates, or quantities.
* **Language detection**: Identifying the language of a text sample.
* **Machine translation**: Translating text between languages.
* **Speech-related tasks**: Speech-to-text and text-to-speech.
* **Question answering / conversational AI**: Understanding user input and generating relevant responses.

**How NLP systems work**

* Text is converted into numerical representations that models can process.
* Machine learning models learn language patterns from large datasets.
* Pre-trained language models can be reused and adapted for specific NLP tasks.

**Modern NLP approaches**

* Deep learning models are commonly used for NLP.
* Transformer-based models analyze relationships between words across entire sentences or documents, improving context awareness.

**Exam-relevant points**

* NLP focuses on enabling computers to work with natural (human) language.
* Ambiguity and context are core challenges in NLP.
* Many NLP solutions rely on pre-trained models rather than training from scratch.


*Last updated: 2026-01-16*
