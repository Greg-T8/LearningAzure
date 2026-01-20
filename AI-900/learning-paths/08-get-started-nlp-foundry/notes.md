# Module 8: Get started with natural language processing in Microsoft Foundry

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/get-started-language-azure/)

* [Understand natural language processing on Azure](#understand-natural-language-processing-on-azure)
* [Understand Azure Language's text analysis capabilities](#understand-azure-languages-text-analysis-capabilities)
* [Azure Language's conversational AI capabilities](#azure-languages-conversational-ai-capabilities)
* [Azure Translator capabilities](#azure-translator-capabilities)
* [Get started in Microsoft Foundry](#get-started-in-microsoft-foundry)
* [Introduction to AI Speech Concepts](#introduction-to-ai-speech-concepts)
* [Speech-enabled solutions](#speech-enabled-solutions)
* [Introduction to AI speech concepts – Speech recognition](#introduction-to-ai-speech-concepts--speech-recognition)
* [Speech synthesis](#speech-synthesis)

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

## Azure Language's conversational AI capabilities

[Module Reference](https://learn.microsoft.com/training/modules/get-started-text-analysis-microsoft-foundry/)

**Overview**

* **Conversational AI** enables dialog between an AI system and a human.
* Azure Language includes features that support conversational AI solutions.

**Question Answering**

* **Question answering** enables building conversational AI solutions with an automated dialog component.
* Commonly used for **bot applications** that respond to customer queries.
* Capabilities include:

  * Immediate responses
  * Accurate answers
  * Natural, **multi-turn interactions**
* Bots can be implemented across multiple platforms:

  * Web sites
  * Social media platforms
* Azure Language provides **custom question answering**:

  * Create a **knowledge base** of question-and-answer pairs
  * Query the knowledge base using **natural language input**

**Conversational Language Understanding (CLU)**

* **Conversational Language Understanding (CLU)** interprets the meaning of phrases in a conversational context.
* Used to build **end-to-end conversational applications**.
* Enables customization of natural language understanding models to:

  * Predict the **intent** of an incoming phrase
  * Extract **important information** from user input
* Example use case:

  * Interpreting commands such as “Turn the light off” and identifying the required action
* Applicable scenarios include:

  * Command and control tasks
  * End-to-end conversations
  * Enterprise support solutions

<img src='.img/2026-01-20-04-29-19.png' width=700>

**Relationship to Generative AI**

* Modern AI solutions often combine multiple AI capabilities.
* Conversational AI builds on **natural language processing (NLP)**.
* **Generative AI** uses NLP as a foundation but extends it by **creating new content**.

**Key Facts to Remember**

* **Question answering** is optimized for conversational bots using knowledge bases.
* **Custom question answering** uses question-and-answer pairs queried via natural language.
* **CLU** focuses on intent prediction and information extraction.
* Conversational AI and generative AI are related but **not the same**—generative AI creates new content.

---

## Azure Translator capabilities

[Module Reference](https://learn.microsoft.com/en-us/training/modules/get-started-language-azure/5-azure-translator)

**Overview**

* Early machine translation relied on **literal translation** (word-for-word), which caused issues:

  * No equivalent word in the target language
  * Changed meaning or loss of context
* AI-based translation focuses on **semantic context**, not just individual words
* Accurate translation must consider:

  * **Context**
  * **Grammar rules**
  * **Formal vs. informal language**
  * **Colloquialisms**

**Language Support**

* Supports **text-to-text translation** between **more than 130 languages**
* Allows specifying:

  * **One source (“from”) language**
  * **Multiple target (“to”) languages** simultaneously

**Azure Translator Capabilities**

* **Text translation**

  * Real-time translation across all supported languages
* **Document translation**

  * Translates multiple documents
  * Preserves **original document structure**
* **Custom translation**

  * Enables enterprises, app developers, and language service providers
  * Used to build **customized neural machine translation (NMT)** systems

**Integration and Availability**

* Available in **Microsoft Foundry**

  * Unified platform for enterprise AI operations, model builders, and application development
* Also available in **Microsoft Translator Pro**

  * Mobile application for enterprises
  * Supports **real-time speech-to-speech translation**

**Key Facts to Remember**

* **Literal translation** is insufficient due to context and meaning loss
* Azure Translator supports **130+ languages**
* One source language can be translated into **multiple target languages at once**
* **Document translation** preserves structure
* **Custom translation** uses **neural machine translation (NMT)**
* Service is accessible through **Microsoft Foundry** and **Microsoft Translator Pro**

---

## Get started in Microsoft Foundry

[Module Reference](https://learn.microsoft.com/training/modules/get-started-text-analysis-microsoft-foundry/)

**Overview**

* **Azure Language** and **Azure Translator** provide the core language capabilities for applications.
* Both services are available as **Foundry Tools** and can be integrated into applications using:

  * **Microsoft Foundry portal**
  * **SDKs or REST APIs**

**Resource Provisioning Options**

To use Azure Language or Azure Translator, you must provision a resource in an Azure subscription. Available options:

* **Language resource**

  * Use when only Azure Language services are required
  * Allows separate access control and billing
* **Translator resource**

  * Use when managing access and billing for translation independently
* **Foundry Tools resource**

  * Use when combining Azure Language with other Foundry Tools
  * Centralized access and billing across services

**Resource Creation Methods**

* Resources can be created using:

  * A **user interface**
  * A **script**
* Both the **Azure portal** and **Microsoft Foundry portal** support UI-based creation.
* Choose the **Microsoft Foundry portal** when you want to view and test Foundry Tools examples.

**Microsoft Foundry Portal**

![Image](https://learn.microsoft.com/en-us/azure/ai-services/language-service/media/overview/conversation-pii.png)

![Image](https://learn.microsoft.com/en-us/azure/ai-services/language-service/sentiment-opinion-mining/media/quickstarts/azure-ai-foundry/foundry-playground-navigation.png)

![Image](https://learn.microsoft.com/en-us/azure/ai-foundry/media/concept-playgrounds/playground-landing-page.png?view=foundry-classic)

* **Microsoft Foundry** is a unified platform for:

  * Enterprise AI operations
  * Model building
  * Application development
* The portal is organized around **hubs** and **projects**.
* Creating a **project**:

  * Is required to use Foundry Tools
  * Automatically creates a **Foundry Tools resource**
* **Projects** act as containers for:

  * Datasets
  * Models
  * Other AI-related resources
* Projects support organization, management, and collaboration.

**Playground Capabilities**

* The Foundry portal includes playgrounds to test services without writing code:

  * **Language playground** (for example, sentiment analysis)
  * **Translator playground** (for example, text translation)

**Key Facts to Remember**

* **Azure Language** and **Azure Translator** are Foundry Tools used for language capabilities.
* A **resource must be provisioned** before using either service.
* **Foundry Tools resources** support combined billing and access management.
* A **project in Microsoft Foundry** is required to use Foundry Tools.
* The Foundry portal includes **language and translator playgrounds** for experimentation.

---

---

## Introduction to AI Speech Concepts

[Module Reference](https://learn.microsoft.com/training/modules/introduction-ai-speech-concepts/)

**Overview**

* **Speech** is a natural human communication method that enables more intuitive, accessible, and engaging AI applications.
* Adding speech capabilities improves user experiences in:

  * Voice assistants
  * Accessible applications
  * Conversational AI agents
* Understanding speech technologies is essential for modern AI solutions.

**Fundamental Speech Capabilities**

* **Speech recognition**

  * Converts **spoken words into text**
* **Speech synthesis**

  * Converts **text into natural-sounding speech**
* These two capabilities work together to enable **seamless voice interactions**.

**Learning Focus of the Module**

* How speech recognition and speech synthesis function
* How both technologies combine to power **voice-enabled applications**
* Real-world scenarios where speech technologies enhance user interaction

**Key Facts to Remember**

* **Speech recognition** = spoken language → text
* **Speech synthesis** = text → spoken language
* Speech technologies enable **intuitive, accessible, and engaging** AI experiences

---

## Speech-enabled solutions

[Module Reference](URL)

**Overview**

- **Speech recognition** converts spoken language into text.
- **Speech synthesis** converts text into natural-sounding audio.
- Together, they enable hands-free interaction, improve accessibility, and support natural conversational experiences.

**Benefits of Integrating Speech**

- **Expand accessibility**: Supports users with visual impairments or mobility challenges.
- **Increase productivity**: Enables multitasking without keyboards or screens.
- **Enhance user experience**: Creates natural, human-like conversations.
- **Reach global audiences**: Supports multiple languages and regional dialects.

**Common Speech Recognition Scenarios (Speech-to-Text)**

- **Customer service and support**

  - Real-time call transcription
  - Intelligent call routing
  - Sentiment analysis and issue detection
  - Searchable call records
  - **Business value**: Reduces manual notes, improves accuracy, captures service insights.

- **Voice-activated assistants and agents**

  - Voice commands for hands-free control
  - Natural language question answering
  - Task execution (reminders, messages, searches)
  - Device and system control
  - **Business value**: Increases engagement and simplifies workflows.

- **Meeting and interview transcription**

  - Searchable meeting notes
  - Real-time captions
  - Summaries and key point extraction
  - **Business value**: Saves time, ensures accurate and accessible records.

- **Healthcare documentation**

  - Dictation into electronic health records
  - Real-time updates to treatment plans
  - Reduced administrative burden
  - **Business value**: Improves care focus and documentation accuracy.

**Common Speech Synthesis Scenarios (Text-to-Speech)**

- **Conversational AI and chatbots**

  - Spoken responses instead of text
  - Adjustable tone, pace, and style
  - Voice-based customer interactions
  - **Business value**: Improves approachability and availability.

- **Accessibility and content consumption**

  - Read-aloud web and document content
  - Support for dyslexia and visual impairments
  - Hands-free content consumption
  - **Business value**: Expands audience reach and inclusion.

- **Notifications and alerts**

  - Spoken alerts and reminders
  - Navigation and GPS instructions
  - Safety and system status updates
  - **Business value**: Improves responsiveness and safety.

- **E-learning and training**

  - Narrated lessons without recording studios
  - Pronunciation guidance
  - Multilingual audio content
  - **Business value**: Reduces costs and accelerates content creation.

- **Entertainment and media**

  - Character voices and voiceovers
  - Podcast and audiobook prototypes
  - Personalized audio experiences
  - **Business value**: Enables rapid prototyping and scalability.

**Combining Speech Recognition and Synthesis**

- **Voice-driven customer service**
- **Interactive voice response (IVR) systems**
- **Language learning applications**
- **Voice-controlled vehicles**

*Combined use enables fluid, two-way conversational experiences that reduce user friction.*

**Key Considerations Before Implementation**

- **Audio quality**: Noise, microphones, and bandwidth affect accuracy.
- **Language and dialect support**: Verify coverage for target audiences.
- **Privacy and compliance**: Understand audio data handling and protection.
- **Latency**: Real-time conversations require low latency.
- **Accessibility standards**: Must align with WCAG guidelines.
- **Alternative interfaces**: Always provide text-based input and output options.

**Key Facts to Remember**

- **Speech recognition** = speech-to-text.
- **Speech synthesis** = text-to-speech.
- Combining both enables conversational AI.
- Accessibility and alternative interfaces are mandatory considerations.

---

## Introduction to AI speech concepts – Speech recognition

[Module Reference](https://learn.microsoft.com/en-us/training/modules/introduction-ai-speech/3-speech-recognition?pivots=text)

**Speech Recognition Overview**

- **Speech recognition (speech-to-text)** converts spoken language into written text.
- The pipeline consists of **six coordinated stages**:

  - Audio capture
  - Pre-processing
  - Acoustic modeling
  - Language modeling
  - Decoding
  - Post-processing

**Audio Capture**

- Converts **analog sound waves to digital signals** using a microphone.
- Typical sampling rate for speech:

  - **16,000 samples per second (16 kHz)**
- Sampling rate considerations:

  - Higher rates (e.g., **44.1 kHz**) capture more detail but increase processing cost.
  - Speech systems balance clarity and efficiency at **8–16 kHz**.
- Accuracy is affected by:

  - Background noise
  - Microphone quality
  - Distance from the speaker
- Basic filters may remove hums, clicks, and background noise before further processing.

**Pre-Processing**

- Transforms raw audio into compact, meaningful representations.
- Discards irrelevant details such as absolute volume.

**Mel-Frequency Cepstral Coefficients (MFCCs)**

- **Most common feature extraction technique** in speech recognition.
- Mimics human hearing by emphasizing speech-relevant frequencies.
- **MFCC process**:

  1. Divide audio into overlapping **20–30 ms frames**
  2. Apply **Fourier transform** to convert time domain to frequency domain
  3. Map frequencies to the **Mel scale**
  4. Extract a small set of coefficients (commonly **13 coefficients**)
- Output is a **sequence of feature vectors**, one per frame.
- Each vector contains **13 MFCC values** representing spectral shape.

<img src='.img/2026-01-20-04-41-23.png' width=700>


**Acoustic Modeling**

- Learns the relationship between audio features and **phonemes**.
- **Phonemes** are the smallest sound units distinguishing words.

  - English uses approximately **44 phonemes**
  - Example: *cat* → /k/, /æ/, /t/
- Modern systems use **transformer architectures**.
- Transformer characteristics:

  - **Attention mechanisms** use surrounding frames for context
  - **Parallel processing** improves speed and accuracy
  - **Contextualized predictions** learn common phoneme sequences
- Output is a **probability distribution over phonemes** for each frame.
- Phonemes are **language-specific** and require retraining for other languages.

**Language Modeling**

- Resolves ambiguity where phonemes alone are insufficient.
- Applies knowledge of:

  - Vocabulary
  - Grammar
  - Common word patterns
- Language model guidance includes:

  - **Statistical patterns** from training data
  - **Context awareness** based on prior words
  - **Domain adaptation** for specialized terminology

**Decoding**

- Searches for the word sequence that best matches acoustic and language models.
- Balances:

  - Fidelity to the audio signal
  - Readability and grammatical correctness
- **Beam search decoding**:

  - Maintains a shortlist of top-scoring hypotheses
  - Extends, scores, and prunes candidates at each step
- Evaluates **thousands of hypotheses** for short utterances.
- Decoding is **computationally intensive**.

  - Real-time systems limit beam width and hypothesis depth to reduce latency.

**Post-Processing**

- Refines raw decoded text for presentation.
- Common tasks:

  - **Capitalization**
  - **Punctuation restoration**
  - **Number formatting**
  - **Profanity filtering**
  - **Inverse text normalization**
  - **Confidence scoring**
- Azure Speech returns:

  - Final transcription
  - **Word-level timestamps**
  - **Confidence scores**

**End-to-End Pipeline Flow**

- Audio capture → raw signal
- Pre-processing → MFCC features
- Acoustic modeling → phoneme probabilities
- Language modeling → vocabulary and grammar context
- Decoding → best word sequence
- Post-processing → readable, formatted text

**Key Facts to Remember**

- **Six stages** make up the speech recognition pipeline
- Typical speech sampling rate: **16 kHz**
- MFCCs commonly extract **13 coefficients**
- Audio frames are **20–30 ms**
- English has approximately **44 phonemes**
- Transformers are used for modern acoustic modeling
- Beam search is the most common decoding technique
- Post-processing improves readability and usability

---

## Speech synthesis

[Module Reference](https://learn.microsoft.com/training/modules/introduction-to-ai-speech-concepts/)

**Overview**

- **Speech synthesis** (text-to-speech, TTS) converts written text into spoken audio.
- Used by virtual assistants, navigation apps, and accessibility tools.
- Systems transform text through **four distinct stages**, producing a natural audio waveform.

**Stage 1: Text normalization**

- Prepares raw text for pronunciation by converting it into spoken forms.
- Prevents pronunciation of raw symbols or digits.

*Common normalization tasks*

- Expanding abbreviations (for example, **“Dr.” → “Doctor”**, **“Inc.” → “Incorporated”**)

- Converting numbers to words (**“3” → “three”**, **“25.50” → “twenty-five dollars and fifty cents”**)

- Handling dates and times (**“12/15/2023” → “December fifteenth, two thousand twenty-three”**)

- Processing symbols and special characters (**“$” → “dollars”**, **“@” → “at”**)

- Resolving homographs based on context (**“read” present vs. past tense**)

- Domain-specific rules apply (for example, medical vs. financial text).

**Stage 2: Linguistic analysis**

- Maps normalized text to **phonemes** (smallest units of sound).
- Determines correct pronunciation based on context.

*Linguistic analysis tasks*

- Segmenting text into words and syllables
- Looking up pronunciations in lexicons
- Applying **grapheme-to-phoneme (G2P)** rules or neural models for unknown words
- Marking syllable boundaries and stressed syllables
- Determining phonetic context of adjacent sounds

**Grapheme-to-phoneme (G2P) conversion**

- Maps written letters to phonemes.
- Handles inconsistent spelling-to-sound mappings in languages like English.

*Examples*

- **though** → /θoʊ/

- **through** → /θruː/

- **cough** → /kɔːf/

- Modern G2P uses neural networks trained on pronunciation dictionaries.

- Context-aware models (often transformers) disambiguate pronunciation (for example, **“read”** in present vs. past tense).

**Stage 3: Prosody generation**

- Determines **how** words are spoken, not just which sounds are produced.
- Prosody affects naturalness and meaning.

*Elements of prosody*

- Pitch contours (rising/falling pitch)
- Duration (sound length and rhythm)
- Intensity (loudness)
- Pauses (phrase and sentence breaks)
- Stress patterns (syllable and word emphasis)

*Prosody impact*

- Emphasis placement can change sentence meaning.
- Flat prosody results in robotic-sounding speech.

**Transformer-based prosody prediction**

- Uses transformer neural networks to model sentence-level context.

*Prosody generation process*

1. **Input encoding**: Phoneme sequence plus linguistic features
2. **Contextual analysis**: Self-attention identifies relationships across the sentence
3. **Prosody prediction**: Pitch, duration, and energy per phoneme
4. **Style factors**: Speaking style and speaker characteristics

*Factors influencing prosody*

- Syntax

- Semantics

- Discourse context

- Speaker identity

- Emotional tone

- Output is a detailed target specification (pitch, duration, intensity, pauses).

**Stage 4: Speech synthesis (audio generation)**

- Generates the final audio waveform from phonemes and prosody.

*Waveform generation approaches*

- Uses **neural vocoders**.

*Common vocoder architectures*

- **WaveNet**
- **WaveGlow**
- **HiFi-GAN**

*Synthesis process*

1. **Acoustic feature generation**: Converts phonemes and prosody into mel-spectrograms
2. **Vocoding**: Converts mel-spectrograms into raw audio waveforms (16,000–48,000 samples/second)
3. **Post-processing**: Filtering, normalization, and audio effects

*Why neural vocoders are effective*

- High fidelity audio
- Natural-sounding speech
- Real-time generation
- Flexibility across speakers, languages, and styles

**Complete pipeline example**

- Input: **“Dr. Chen’s appointment is at 3:00 PM”**
- Text normalization: “Doctor Chen’s appointment is at three o’clock P M”
- Linguistic analysis: Converted to phoneme sequence
- Prosody generation: Emphasis and pauses predicted
- Speech synthesis: Audio waveform generated
- End-to-end process typically completes in **under one second** on modern hardware.

**Key Facts to Remember**

- **Speech synthesis has four stages**: text normalization, linguistic analysis, prosody generation, speech synthesis.
- **G2P conversion** handles inconsistent spelling-to-sound mappings.
- **Prosody** (pitch, stress, rhythm) is critical for natural-sounding speech.
- **Transformers** are used for both pronunciation context and prosody prediction.
- **Neural vocoders** generate high-quality, real-time audio waveforms.

---
