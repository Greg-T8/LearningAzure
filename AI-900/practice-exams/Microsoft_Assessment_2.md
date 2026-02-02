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

<details>
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

---

<img src='.img/2026-02-02-05-21-11.png' width=700>

<details>
<summary>Click to expand explanation</summary>

**Why your selected answer (fairness) is wrong:**  
Fairness focuses on ensuring AI systems treat all users equitably and do not produce biased outcomes across different groups. While fairness is always important, this question specifically asks about managing *healthcare data*—the scenario emphasizes data handling and compliance, not equitable treatment of users. Fairness doesn't directly address the protection of sensitive medical information or regulatory compliance.

**Why the correct answers (accountability and privacy and security) are right:**  

- **Privacy and Security:** Healthcare data (PHI/PII) is highly sensitive and regulated (HIPAA, GDPR, etc.). This principle ensures data is protected, anonymized where applicable, and accessed only by authorized parties. It's the most directly relevant principle when the question mentions "manage healthcare data."
- **Accountability:** This principle ensures AI systems meet ethical and *legal* standards. Healthcare AI must comply with strict regulations, and organizations must be accountable for how the system handles patient data, makes decisions, and can be audited.

**The trap in this question:**  
The word "healthcare" might make you think about treating patients fairly, which pulls you toward "fairness." However, the question emphasizes *managing healthcare data*—this is about data governance, not equitable outcomes. Read the scenario carefully for whether it's about data handling vs. user treatment.

**Microsoft's Six Responsible AI Principles (quick reference):**

| Principle | Focus |
|-----------|-------|
| Fairness | Avoid bias; treat users equitably |
| Reliability & Safety | Operate safely and as intended |
| Privacy & Security | Protect data; ensure secure access |
| Inclusiveness | Empower all users; accessible design |
| Transparency | Explainable and understandable AI |
| Accountability | Meet ethical/legal standards; auditability |

**Key takeaway:**  
When a question mentions sensitive data (healthcare, financial, personal), prioritize **privacy and security**. When it mentions legal/regulatory compliance or organizational responsibility, prioritize **accountability**. Fairness is about equitable treatment of people, not data protection.

**References**

- [Understand Responsible AI - Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/get-started-ai-fundamentals/8-understand-responsible-ai)
- [Microsoft Responsible AI principles](https://learn.microsoft.com/en-us/azure/machine-learning/concept-responsible-ai)
- [Responsible AI overview - Azure AI Services](https://learn.microsoft.com/en-us/azure/ai-services/responsible-use-of-ai-overview)

</details>

---

<img src='.img/2026-02-02-05-27-53.png' width=700>

<details open>
<summary>Click to expand explanation</summary>

**Why your selected answer (business card model) is wrong:**  
The business card model is specifically designed to extract contact information from business cards—names, phone numbers, email addresses, job titles, and company names. It has no capability to process passports or sales account documents. The question asks about two distinct document types: international passports and sales accounts. You need to match each document type to its appropriate prebuilt model.

**Why the correct answers (ID document model and invoice model) are right:**  

- **ID document model:** Optimized to extract key information from identity documents, specifically US driver's licenses and *international passport biographical pages*. This directly addresses the "international passports" requirement in the question.
- **Invoice model:** Designed to extract structured data from sales invoices and billing documents—vendor info, line items, totals, dates, etc. "Sales accounts" refers to sales/billing documentation, which maps to the invoice model.

**The trap in this question:**  
The question pairs two unrelated document types (passports + sales accounts), requiring you to identify the correct model for each. It's easy to overthink or pick a model that sounds plausible but doesn't match either document type. Business cards and receipts are common prebuilt models, but they don't apply here.

**Azure Document Intelligence prebuilt models (quick reference):**

| Model | Extracts From |
|-------|---------------|
| Invoice | Invoices, billing documents |
| Receipt | Retail receipts |
| ID Document | Passports, driver's licenses |
| Business Card | Contact cards |
| W-2 | US tax forms |
| Health Insurance Card | US health insurance cards |

**Key takeaway:**  
Map each document type in the question to a specific prebuilt model. "Passports" = ID document model. "Sales accounts/invoices" = Invoice model. Don't select models based on partial matches or assumptions.

**References**

- [Prebuilt models - Azure AI Document Intelligence](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-model-overview)
- [ID document model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-id-document)
- [Invoice model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-invoice)

</details>



## Unsure but Correctly Answered

<img src='.img/2026-02-02-05-20-18.png' width=700> 

---

<img src='.img/2026-02-02-05-24-08.png' width=700>

---
