# AI-900: Microsoft Azure AI Fundamentals — Study Guide

**Objective:** Achieve the **AI-900: Microsoft Azure AI Fundamentals** certification through a structured, multi-resource study approach.

- **Certification Page:** [AI-900: Microsoft Azure AI Fundamentals](https://learn.microsoft.com/en-us/credentials/certifications/azure-ai-fundamentals/?practice-assessment-type=certification)
- **Official Study Guide:** [AI-900 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-900)

---

## 📚 Learning Resource Progress Tracker

| Priority | Modality         | My Notes                                            | Status | Started | Completed | Days |
| :------- | :--------------- | :-------------------------------------------------- | :----- | :------ | :-------- | :--- |
| 1        | Microsoft Learn  | [Microsoft Learning Paths](./learning-paths/README.md) | ✅     | 1/14/26 | 1/21/26   | 7    |
| 2        | Video            | [John Savill's Training](./video-courses/savill/README.md)          | ✅     |  1/29/26       | 1/31/26   | 3    |
| 3        | Practice Exams   | [Practice Exams](./practice-exams/README.md)        | 🕒     |         |           |      |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

---

## 📊 Exam Domains

| Domain                           | Weight |
| :------------------------------- | :----- |
| 1. AI Workloads & Considerations | 15-20% |
| 2. Machine Learning on Azure     | 15-20% |
| 3. Computer Vision Workloads     | 15-20% |
| 4. NLP Workloads                 | 15-20% |
| 5. Generative AI Workloads       | 20-25% |

---

## 📘 Domain Quick Reference

### Domain 1: AI Workloads and Considerations (15–20%)

**Key Topics**

- Common AI workloads: computer vision, NLP, document processing, generative AI
- Responsible AI principles: fairness, reliability, privacy, inclusiveness, transparency, accountability

**Common Pitfalls**

- Confusing computer vision vs. NLP scenarios
- Classification (categorize whole image) vs. object detection (locate + identify multiple objects)
- Missing the six responsible AI principles — heavily tested
- Transparency means making AI decisions understandable to users

---

### Domain 2: Machine Learning on Azure (15–20%)

**Key Topics**

- Regression: Predict numeric value (price, temperature)
- Classification: Predict category (spam/not spam)
- Clustering: Group similar items without labels (unsupervised)
- Features (inputs), labels (targets), training/validation/test datasets
- Azure ML: Automated ML, designer, compute, model registry

**Common Pitfalls**

- Regression (numeric) vs. classification (categorical)
- Clustering is unsupervised (no labels)
- Training vs. validation vs. test dataset purposes
- Automated ML (no-code) vs. custom training (code-first)

---

### Domain 3: Computer Vision Workloads (15–20%)

**Key Topics**

- Image classification: Categorize entire image
- Object detection: Locate and identify multiple objects (bounding boxes)
- OCR: Extract text from images/documents
- Face detection vs. facial analysis vs. face recognition
- Azure AI Vision, Azure AI Face, Custom Vision

**Common Pitfalls**

- Image classification (one label) vs. object detection (multiple objects with locations)
- When to use Azure AI Vision vs. Azure AI Face
- Custom Vision is for training custom models, not general-purpose
- Face detection (find) vs. face recognition (identify specific people)

---

### Domain 4: NLP Workloads (15–20%)

**Key Topics**

- Key phrase extraction, entity recognition, sentiment analysis
- Speech recognition (speech-to-text), speech synthesis (text-to-speech)
- Language translation
- Conversational language understanding (CLU)
- Azure AI Language, Azure AI Speech

**Common Pitfalls**

- Key phrase extraction (topics) vs. entity recognition (specific names/dates)
- Azure AI Language (text analysis) vs. Azure AI Speech (audio)
- Sentiment analysis returns positive/negative/neutral scores
- CLU is for building chatbots/voice assistants

---

### Domain 5: Generative AI Workloads (20–25%)

**Key Topics**

- Generative AI: Models that create new content (text, images, code)
- Azure OpenAI Service: GPT-4, GPT-3.5, DALL-E, Whisper
- Microsoft Foundry: Build, test, deploy generative AI solutions
- Model catalog: Access to models from Microsoft, OpenAI, Meta, Hugging Face
- Responsible AI: Content filters, grounding, bias mitigation

**Common Pitfalls**

- Azure OpenAI Service (API) vs. Microsoft Foundry (platform for building)
- Importance of content filters and grounding
- Prompt engineering is critical for good results
- GPT-4 (most capable) vs. GPT-3.5 (faster, cheaper)
- Microsoft Foundry model catalog provides access to non-OpenAI models

---

## 🧾 Final Review Checklist

- [ ] Memorize the **six responsible AI principles**
- [ ] Understand **regression vs. classification vs. clustering**
- [ ] Know when to use **Azure AI Vision vs. Azure AI Face**
- [ ] Understand **Azure AI Language** capabilities (sentiment, entities, key phrases)
- [ ] Know **Azure AI Speech** (speech-to-text, text-to-speech) vs. **Azure AI Language** (text)
- [ ] Understand **Azure OpenAI Service** capabilities (GPT, DALL-E, Whisper)
- [ ] Know what **Microsoft Foundry** is used for
- [ ] Understand **responsible AI for generative AI**
- [ ] Practice identifying **use cases** for each AI service
