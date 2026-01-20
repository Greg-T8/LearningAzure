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
