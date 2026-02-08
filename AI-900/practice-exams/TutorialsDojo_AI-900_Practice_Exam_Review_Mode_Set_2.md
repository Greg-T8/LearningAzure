# Tutorials Dojo AI-900 Practice Exam - Review Mode Set 2

## Overview

Practice exam from TutorialsDojo for AI-900: Azure AI Fundamentals.

## Assessment Results

<img src='.img/' width=700>

---

## Wrong or Unsure Answers

---

### Distinguish Clustering from Other ML Techniques

Category: AI-900 – Describe Features of Natural Language Processing (NLP) Workloads on Azure

For each of the following items, choose Yes if the statement is true or choose No if the statement is false. Take note that each correct item is worth one point.

| Questions | Yes | No |
|-----------|-----|-----|
| Grouping online shoppers into segments such as frequent buyers, occasional shoppers, and first-time buyers based on their purchasing behavior is an example of clustering. | ☐ | ☑ |
| Organizing documents into topics such as technology, politics, and sports based on the content is an example of clustering. | ☑ | ☐ |
| Predicting whether a student will receive an A, B, C, or D grade in a course based on their attendance, assignments, and exam scores is an example of clustering. | ☐ | ☑ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-08-05-59-26.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong**

The statement *“Grouping online shoppers into segments such as frequent buyers, occasional shoppers, and first-time buyers based on their purchasing behavior is an example of clustering”* is **true**, but it was marked **No**.

This scenario describes grouping customers based on similarities in behavior **without predefined labels assigned ahead of time**. The segments emerge from patterns in the data (purchase frequency, recency, volume), which is the defining characteristic of **clustering**.

Marking this as **No** incorrectly treats it as classification. Classification would require predefined labels applied during training, which is not implied here.

**Why the correct answer is correct**

Clustering groups data points based on shared characteristics to discover natural groupings. Customer segmentation based on behavior is a classic clustering use case, commonly performed using algorithms such as K-means.

Because the groups are derived from similarity rather than predicted from labeled outcomes, **Yes** is the correct choice.

**Why the other options are correct or incorrect**

* **Organizing documents into topics such as technology, politics, and sports based on the content**
  **Correct (Yes).** Documents are grouped by similarity in language and themes, which is clustering.

* **Predicting whether a student will receive an A, B, C, or D grade based on performance**
  **Correct (No).** This is **classification**, because the model predicts one of several predefined labels.

**Key takeaway**

* **Clustering** → discovers groups based on similarity, no predefined labels
* **Classification** → predicts predefined categories using labeled data

Customer segmentation and topic grouping are clustering; grade prediction is classification.

**References**

* [https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/natural-language-processing](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/natural-language-processing)
* [https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview](https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview)
* [https://learn.microsoft.com/en-us/azure/machine-learning/component-reference/k-means-clustering?view=azureml-api-2#understand-k-means-clustering](https://learn.microsoft.com/en-us/azure/machine-learning/component-reference/k-means-clustering?view=azureml-api-2#understand-k-means-clustering)

</details>

---

### Azure Machine Learning Designer Capabilities

Category: AI-900 – Describe Fundamental Principles of Machine Learning on Azure

For each of the following items, choose Yes if the statement is true or choose No if the statement is false. Take note that each correct item is worth one point.

| Questions | Yes | No |
|-----------|-----|-----|
| Azure Machine Learning designer enables you to create and customize web-based user interfaces for your machine learning models. | ☑ | ☐ |
| Azure Machine Learning designer enables you to execute custom Python or R code | ☑ | ☐ |
| Azure Machine Learning designer includes pre-built modules for training deep neural networks. | ☑ | ☐ |
| Azure Machine Learning designer supports integration with external cloud storage providers. | ☑ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-08-06-10-04.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is incorrect**

You marked **Yes** for the statement *“Azure Machine Learning designer enables you to create and customize web-based user interfaces for your machine learning models.”*
This is incorrect. Azure Machine Learning designer is **not** a UI-building tool. It does not create or customize web-based user interfaces for end users. Its purpose is to visually design, train, and evaluate machine learning pipelines, not to build application front ends or dashboards.

**Why the correct answer is No**

Azure Machine Learning designer is a **drag-and-drop pipeline authoring tool** inside Azure Machine Learning. It focuses on data preparation, model training, evaluation, and deployment workflows. Web-based user interfaces for models are typically created using services like Azure App Service, Azure Static Web Apps, or frameworks such as Flask, FastAPI, or Streamlit—outside of the designer.

**Why the other answers are correct**

* **Execute custom Python or R code** — Correct. Designer supports custom code execution through components that run Python or R scripts as part of a pipeline.
* **Includes pre-built modules for training deep neural networks** — Correct. Designer provides built-in components for deep learning scenarios, including neural network training modules.
* **Supports integration with external cloud storage providers** — Correct. Designer can work with data stored in cloud storage services that are connected to the Azure Machine Learning workspace.

**Key takeaway**

Azure Machine Learning designer is for **building machine learning pipelines**, not for **building user interfaces**. UI creation happens after deployment and uses separate Azure services.

**References**

* [https://learn.microsoft.com/en-us/azure/machine-learning/concept-designer?view=azureml-api-2](https://learn.microsoft.com/en-us/azure/machine-learning/concept-designer?view=azureml-api-2)
* [https://learn.microsoft.com/en-us/azure/machine-learning/concept-automated-ml?view=azureml-api-2](https://learn.microsoft.com/en-us/azure/machine-learning/concept-automated-ml?view=azureml-api-2)
* [https://learn.microsoft.com/en-us/azure/machine-learning/how-to-select-algorithms?view=azureml-api-1](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-select-algorithms?view=azureml-api-1)

</details>

---

### Speech Recognition in Natural Language Processing

While conducting an online workshop, the spoken content is converted into text subtitles for participants to follow along in near-real-time. The process of transcribing the speech into subtitles in the same language for the audience is an example of _______.

A. Speech Recognition  
B. Translation  
C. Sentiment Analysis  
D. Named Entity Recognition  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-08-06-29-45.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong (Translation)**
Translation converts content from one language to another. In this scenario, the spoken content is converted into text **in the same language**. No language change occurs, so translation does not apply.

**Why the correct answer is correct (Speech Recognition)**
Speech recognition (speech-to-text) converts spoken language into written text. Generating near-real-time subtitles from live speech is a direct example of speech recognition. This is the exact capability used for live captioning and transcription scenarios.

**Why the other options are incorrect**

* **Sentiment analysis** focuses on identifying emotional tone or opinion in text, not converting speech to text.
* **Speech synthesis** converts text into spoken audio, which is the reverse of what the scenario describes.

**Key takeaway**
If audio is being converted into text without changing languages, the workload is **speech recognition**, not translation or text analytics.

**References**

* [https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/natural-language-processing](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/natural-language-processing)
* [https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview](https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview)
* [https://learn.microsoft.com/en-us/azure/ai-services/language-service/key-phrase-extraction/overview](https://learn.microsoft.com/en-us/azure/ai-services/language-service/key-phrase-extraction/overview)

</details>

---

### Computer Vision Tagging for Automatic Image Classification

Category: AI-900 – Describe Features of Computer Vision Workloads on Azure

You're working on a project that involves automatically tagging images with relevant keywords based on their content. You want to identify objects, scenes, and activities present in the images to create accurate tags. What should you use to analyze the images?

A. Image Classification model  
B. Optical Character Recognition (OCR) tool  
C. Image Segmentation model  
D. Spatial Analysis  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-08-06-32-42.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the selected answer is wrong (Spatial Analysis)**
Spatial Analysis is about understanding how people move through a physical space over time (for example, counting people entering/exiting a zone, dwell time, or triggering events based on movement patterns). It is not designed to generate descriptive content tags like “beach,” “dog,” or “playing soccer” from an image.

**Why the correct answer is correct (Image classification model)**
Image classification is specifically used to assign one or more labels to an image based on what’s in it. For “automatically tagging images with relevant keywords” (objects, scenes, activities), classification is the exam-aligned fit because it outputs categories/tags that you can use directly as keywords.

**Why the other options are incorrect or less appropriate**

* **Optical Character Recognition (OCR) tool**: Extracts text that appears in an image (signs, documents). It doesn’t identify visual objects/scenes/activities unless those are literally written in the image.
* **Image Segmentation model**: Splits an image into pixel-level regions (what pixels belong to which object). That’s useful when you need precise boundaries or per-pixel labeling, not when your goal is primarily “generate tags/keywords for the whole image.”

**Key takeaway**
For keyword tagging based on visual content, choose **image classification**. Use **segmentation** only when you need pixel-level regions, **OCR** for extracting text, and **spatial analysis** for movement/occupancy patterns over time.

**References**

* [https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview-image-analysis?tabs=4-0](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview-image-analysis?tabs=4-0)
* [https://learn.microsoft.com/en-us/azure/cognitive-services/computer-vision/overview-identity](https://learn.microsoft.com/en-us/azure/cognitive-services/computer-vision/overview-identity)
* [https://learn.microsoft.com/en-us/training/modules/analyze-images-computer-vision/](https://learn.microsoft.com/en-us/training/modules/analyze-images-computer-vision/)

</details>

---

### Azure AI Speech Service for Speech-to-Text and Translation

For each of the following items, choose Yes if the statement is true or choose No if the statement is false. Take note that each correct item is worth one point.

| Questions | Yes | No |
|-----------|-----|-----|
| You can apply the Azure AI Language service to a legal deposition transcript, automatically identifying and extracting relevant names, dates, and legal terms for more efficient document analysis. | ☑ | ☐ |
| You can use the Azure AI Speech service to convert a customer order call in one language into text, then translate it to another language for processing and fulfillment by an international team. | ☑ | ☐ |
| You can utilize the Azure AI Speech service to convert an interview with a non-English-speaking participant into written text, making it easier for researchers to analyze and reference the conversation. | ☐ | ☑ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-08-06-56-27.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why your selected answer is wrong**

You marked **No** for the statement about using Azure AI Speech to convert an interview with a non-English-speaking participant into written text. That is incorrect because Azure AI Speech explicitly supports **speech-to-text for multiple languages**. The service can transcribe spoken audio regardless of whether the speaker is using English, as long as the language is supported.

**Why the statement is correct**

Azure AI Speech is designed to convert spoken language into text. This includes interviews conducted in non-English languages. The resulting transcription can then be analyzed, searched, quoted, or archived, which directly matches the scenario described. No additional service is required just to produce written text from spoken language.

**Why the other statements are correct**

* Using **Azure AI Language** to analyze a legal deposition transcript is valid. The Language service performs entity recognition and information extraction on text, such as identifying names, dates, and domain-specific terms.
* Using **Azure AI Speech** to transcribe a customer call and translate it into another language is also valid. The Speech service supports both speech-to-text and speech translation, which fits an international processing workflow.

**Key takeaway**

If the task involves **converting spoken audio into text**, even for non-English speakers, **Azure AI Speech** is the correct service. Marking that scenario as “No” is a common exam trap that incorrectly assumes language limitations.

**References**

* [https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/natural-language-processing](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/natural-language-processing)
* [https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview](https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview)
* [https://medium.com/@hitesh.hinduja/navigating-azure-ai-an-extensive-guide-to-language-vision-speech-decision-and-azure-open-ai-3da656668591](https://medium.com/@hitesh.hinduja/navigating-azure-ai-an-extensive-guide-to-language-vision-speech-decision-and-azure-open-ai-3da656668591)

Yes. In this context, **Azure AI Speech translation is a separate capability from the Azure AI Translator service**, even though they are closely related and often confused on exams.

**How they are different**

* **Azure AI Speech (Speech Translation)**

  * Starts with **audio** as input
  * Performs **speech-to-text** and can **translate spoken language directly into another language**
  * Designed for real-time or near–real-time scenarios such as calls, meetings, interviews, and live conversations
  * Exam keyword: *spoken audio → translated output*

* **Azure AI Translator (Text Translation)**

  * Starts with **text** as input
  * Translates text from one language to another
  * Used after transcription, or when the source is already written (documents, chat logs, UI strings)
  * Exam keyword: *text → translated text*

**Why this matters for the exam**

In your question scenario, the workflow is:

Spoken interview (non-English) → written text

That requirement is fully satisfied by **Azure AI Speech alone**. Translation is optional and only needed if the output must be in a different language. You do **not** need Azure Translator unless you are explicitly given **text-only input** or a **separate translation step** is called out.

**Exam rule of thumb**

* Audio involved → **Azure AI Speech**
* Text only → **Azure AI Translator**
* Audio + translation in one step → **Azure AI Speech (speech translation)**

**References**

* No stable Microsoft Learn link can be guaranteed for this specific exam concept.

</details>

---
