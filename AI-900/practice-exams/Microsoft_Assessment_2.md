# Microsoft Assessment AI-900: Azure AI Fundamentals (Attempt 2)

## Overview

Second attempt at the Microsoft practice assessment for AI-900.

## Assessment Results


---

## Wrong Answers

<img src='.img/2026-02-02-05-04-04.png' width=700>

<details>
<summary>Click to expand explanation</summary>

**Why your answer (classification) is wrong:**  
Classification is a *supervised* learning technique that requires **labeled training data**—meaning you already know the categories (e.g., "will buy" vs. "won't buy") and train a model to predict which category new data belongs to. The question doesn't mention any predefined labels or categories to predict; it's asking about grouping customers based on similarities, not predicting a known outcome.

**Why the correct answer (clustering) is right:**  
Clustering is an *unsupervised* learning technique that works with **unlabeled data**. It discovers natural groupings based on similarities in the data (like demographics and shopping behaviors) without needing predefined categories. The key phrase in the question is "group together online shoppers that have similar attributes"—this describes exactly what clustering does. The model finds patterns and segments customers into clusters, which the marketing team can then use for targeted campaigns.

**How to distinguish these on the exam:**

| Scenario | ML Type |
|----------|---------|
| Predict a **known category** (yes/no, spam/not spam) | Classification |
| Predict a **numeric value** (price, temperature) | Regression |
| **Group data by similarity** without predefined labels | Clustering |

**Key takeaway:**  
When a question describes grouping or segmenting data based on shared characteristics *without* mentioning predefined labels or predictions, the answer is clustering. Classification requires you to already know what categories exist.

**References**

- [What is clustering? - Azure Machine Learning](https://learn.microsoft.com/en-us/azure/machine-learning/component-reference/k-means-clustering)
- [Machine learning algorithm types - Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/fundamentals-machine-learning/2-what-is-machine-learning)
- [Clustering models in Azure Machine Learning designer](https://learn.microsoft.com/en-us/azure/machine-learning/component-reference/train-clustering-model)

</details>

---

<img src='.img/2026-02-02-05-14-34.png' width=700>

<details open>
<summary>Click to expand explanation</summary>

**Why your selected answer (entity recognition) is wrong:**  
Entity recognition is a **Natural Language Processing (NLP)** feature, not a computer vision feature. It identifies and categorizes entities like names, dates, locations, and organizations from *text*. This capability belongs to the Azure AI Language service, not Azure Vision. The question specifically asks about *Vision* workloads, which deal with analyzing images and video—not text.

**Why the correct answers (OCR and spatial analysis) are right:**  
Both are core **computer vision** capabilities within Azure Vision in Foundry Tools:

- **Optical Character Recognition (OCR):** Extracts printed and handwritten text *from images*. Even though it outputs text, it's a vision workload because it analyzes image data.
- **Spatial Analysis:** Analyzes video streams to detect and track people's movements in physical spaces (e.g., counting people, detecting social distancing). This is a real-time video analytics feature.

**The trap in this question:**  
It's easy to confuse *entity recognition* with vision because OCR and entity recognition both deal with "extracting information." However:

- OCR extracts text *from images* → **Vision**
- Entity recognition extracts entities *from text* → **Language/NLP**

**Quick reference for AI-900:**

| Feature | Azure Service Category |
|---------|------------------------|
| OCR | Vision |
| Spatial Analysis | Vision |
| Image Classification | Vision |
| Entity Recognition | Language (NLP) |
| Key Phrase Extraction | Language (NLP) |
| Sentiment Analysis | Language (NLP) |

**Key takeaway:**  
When a question asks about Azure Vision, focus on features that analyze *images or video*. NLP features like entity recognition, key phrase extraction, and sentiment analysis all operate on text and belong to Azure AI Language.

**References**

- [What is Azure AI Vision?](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview)
- [OCR - Azure AI Vision](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview-ocr)
- [Azure AI services Computer Vision Spatial Analysis](https://mcr.microsoft.com/artifact/mar/azure-cognitive-services/vision/spatial-analysis/about)
- [What is Azure AI Language?](https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview)

</details>


## Unsure but Correctly Answered
