# Module 10: Get started with speech in Microsoft Foundry

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/recognize-synthesize-speech/)

---

## Understand speech recognition and synthesis

[Module Reference](https://learn.microsoft.com/training/modules/get-started-speech-microsoft-foundry/)

**Speech Recognition**

* Converts **spoken language into data**, typically **text**
* Input sources:

  * **Recorded audio files**
  * **Live audio** from a microphone
* Analyzes **speech patterns** to identify recognizable sounds and words
* Uses multiple models:

  * **Acoustic model**

    * Converts audio signals into **phonemes** (representations of sounds)
  * **Language model**

    * Maps phonemes to **words**
    * Uses **statistical algorithms** to predict the most probable word sequence
* Output is usually **text**, which can be used for:

  * **Closed captions** for recorded or live video
  * **Transcripts** of calls or meetings
  * **Automated note dictation**
  * Determining **user intent** for further processing

**Speech Synthesis**

* Converts **text into spoken audio**
* Requires:

  * **Text** to be spoken
  * **Voice** used to vocalize the text
* Processing steps:

  * **Tokenizes text** into individual words
  * Assigns **phonetic sounds** to each word
  * Breaks phonetic transcription into **prosodic units** (phrases, clauses, sentences)
  * Creates **phonemes** that are synthesized into audio
* Audio output can be customized with:

  * **Voice**
  * **Speaking rate**
  * **Pitch**
  * **Volume**
* Common uses:

  * **Spoken responses** to user input
  * **Voice menus** for phone systems
  * **Reading messages aloud** in hands-free scenarios
  * **Public announcements** (e.g., airports, railway stations)

**Key Facts to Remember**

* **Speech recognition** = audio → phonemes → words → text
* **Acoustic models** handle sounds; **language models** handle word prediction
* **Speech synthesis** requires both **text and a voice**
* **Phonemes** are central to both recognition and synthesis
* Prosody controls **how speech sounds**, not just what is spoken

---

## Get started with speech on Azure

[Module Reference](https://learn.microsoft.com/training/modules/get-started-speech-microsoft-foundry/)

**Azure Speech Service Overview**

* Provides **speech recognition and speech synthesis** capabilities
* Core capabilities include:

  * **Speech to text**
  * **Text to speech**
  * **Speech translation**

**Speech to Text**

* Converts **spoken audio into text**
* Supports:

  * **Real-time transcription**
  * **Batch transcription**
* Audio sources can be:

  * Live microphone input
  * Audio files
* Based on Microsoft’s **Universal Language Model**

  * Model data is **Microsoft-owned**
  * Deployed on **Azure**
* Optimized for:

  * **Conversational** scenarios
  * **Dictation** scenarios
* Supports **custom models**:

  * Acoustic models
  * Language models
  * Pronunciation models

**Real-Time Transcription**

* Transcribes **live audio streams**
* Common use cases:

  * Presentations
  * Demos
  * Live speaking scenarios
* Application requirements:

  * Listens for incoming audio
  * Streams audio to the service
  * Receives transcribed text in real time

**Batch Transcription**

* Used for **non-real-time** scenarios
* Audio files can be stored:

  * On file shares
  * On remote servers
  * In Azure storage
* Audio files are accessed using a **Shared Access Signature (SAS) URI**
* Processing behavior:

  * Runs **asynchronously**
  * Scheduled on a **best-effort basis**
  * Jobs usually start within minutes
  * No guaranteed time for when a job enters the running state

**Text to Speech**

* Converts **text input into audible speech**
* Output options:

  * Play through speakers
  * Save to an audio file
* **Speech synthesis voices**:

  * Multiple predefined voices
  * Support for multiple languages and regional pronunciations
  * Includes **neural voices** for more natural intonation
* Supports **custom voice development**

  * Custom voices can be used with the text to speech API

**Speech Translation**

* Feature of the Azure Speech service
* Enables **real-time translation** of spoken language
* Processing flow:

  1. Converts speech to text using **automatic speech recognition (ASR)**
  2. Translates text into one or more target languages using **machine translation**
* Output formats:

  * Translated text
  * Synthesized speech
* Supports a wide range of **source and target languages**
* Common use cases:

  * Multilingual meetings
  * Live event captioning
  * Global customer support
* Accessible via:

  * REST APIs
  * SDKs

**Key Facts to Remember**

* **Speech to text** supports both **real-time** and **batch** processing
* **Batch transcription** is asynchronous and best-effort with no guaranteed start time
* **Text to speech** supports neural and custom voices
* **Speech translation** combines ASR and machine translation in real time
* Audio files for batch transcription require a **SAS URI**

---

## Use Azure Speech

[Module Reference](https://learn.microsoft.com/training/modules/get-started-speech-microsoft-foundry/use-azure-speech)

**Ways to use Azure Speech**

* Available through multiple tools and programming options:

  * **Studio interfaces**
  * **Command Line Interface (CLI)**
  * **REST APIs**
  * **Software Development Kits (SDKs)**

**Using studio interfaces**

* Azure Speech projects can be created using **Speech Playground** in the **Microsoft Foundry portal**
* Speech Playground provides a browser-based interface for experimenting with speech capabilities

**Azure resources for Azure Speech**

* An Azure resource is required before using Azure Speech in an application
* You can choose between two resource types:

  * **Speech resource**

    * Use when only Azure Speech services are needed
    * Allows separate management of access and billing
  * **Foundry Tools resource**

    * Use when Azure Speech is combined with other Foundry Tools
    * Enables shared access and consolidated billing across services

**Key Facts to Remember**

* Azure Speech supports **studio tools, CLI, REST APIs, and SDKs**
* **Speech Playground** is available in the Microsoft Foundry portal
* Resource choice affects **service scope** and **billing management**
* Only **Speech** and **Foundry Tools** resources are supported for Azure Speech usage

---
