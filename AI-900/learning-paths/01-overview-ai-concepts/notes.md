# Module 1: Overview of AI concepts

**Link:** [Overview of AI concepts](https://learn.microsoft.com/en-us/training/modules/get-started-ai-fundamentals/)

* [Generative AI Fundamentals](#generative-ai-fundamentals)
* [Natural language processing fundamentals](#natural-language-processing-fundamentals)

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

## Natural language processing fundamentals

[Module Reference](https://learn.microsoft.com/en-us/training/modules/get-started-ai-fundamentals/5-natural-language-processing?pivots=text)

**What Natural Language Processing (NLP) is**

* A branch of AI that enables computers to **understand, interpret, and generate human language**.
* Works with both **text and speech** inputs.

**Common NLP tasks**

* **Tokenization**: breaking text into words, subwords, or characters.
* **Part-of-speech tagging**: identifying grammatical roles (noun, verb, adjective).
* **Named Entity Recognition (NER)**: detecting entities such as people, organizations, locations, and dates.
* **Sentiment analysis**: determining emotional tone (positive, negative, neutral).
* **Language detection**: identifying the language of input text.
* **Text classification**: categorizing text (spam detection, topic labeling).
* **Summarization and translation**: condensing or converting text between languages.
* **Speech-to-text / text-to-speech**: converting between spoken and written language.

**How NLP systems work (high level)**

* Text is converted into a **numeric representation** (tokens, embeddings).
* Models learn patterns and relationships between words based on **context**.
* Modern NLP commonly uses **deep learning models** (e.g., transformer-based architectures).

**Natural language understanding vs. generation**

* **NLU (Understanding)**: extracting meaning, intent, and entities from text.
* **NLG (Generation)**: producing human-like language from structured or unstructured data.
* Many systems combine both (for example, chatbots).

**Use cases**

* Chatbots and virtual assistants.
* Search and information retrieval.
* Customer feedback analysis.
* Document processing and summarization.
* Voice-enabled applications.

**Limitations and challenges**

* Ambiguity in language (sarcasm, idioms, context).
* Bias inherited from training data.
* Accuracy varies with domain-specific language.
* Requires quality data and evaluation for real-world reliability.

**Responsible AI considerations**

* Validate outputs, especially for sentiment or intent classification.
* Be cautious with sensitive or personal data.
* Monitor for bias and misinterpretation.

**Exam-relevant takeaways**

* NLP focuses on **understanding and generating human language**.
* Tokenization and embeddings are foundational concepts.
* NER and sentiment analysis are core, commonly tested NLP tasks.
* NLP supports both text-based and speech-based scenarios.

*Last updated: 2026-01-16*
