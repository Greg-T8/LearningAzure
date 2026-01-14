# AI-900: Microsoft Azure AI Fundamentals — Study Guide

**Objective:** Achieve the **AI-900: Microsoft Azure AI Fundamentals** certification through a structured, multi-resource study approach.

---

## 🎯 Overview

This repository provides a **comprehensive study path** combining official Microsoft resources, video courses, hands-on labs, and practice exams.

### 📚 Learning Resource Priorities

| Priority | Resource | Purpose | Location |
|----------|----------|---------|----------|
| 1 | [Microsoft Learn Paths](./learning-paths/README.md) | Core concepts & knowledge | `learning-paths/` |
| 2 | [Microsoft GitHub Labs](./microsoft-labs/README.md) | Official hands-on practice | `microsoft-labs/` |
| 3 | [Video Courses](./video-courses/README.md) | Visual reinforcement | `video-courses/` |
| 4 | [Practice Exams](./practice-exams/README.md) | Exam readiness assessment | `practice-exams/` |

### 🔄 Study Workflow Per Domain

1. **Learn** — Complete Microsoft Learn modules
2. **Practice** — Do official Microsoft GitHub lab
3. **Reinforce** — Watch video content for gaps
4. **Assess** — Practice exam questions for domain
5. **Review** — Update weak areas, refine notes

> 📝 **Take notes at every step** — capture key concepts, services, and use cases.

---

## 📊 Exam Domains and Consolidated Progress Tracker

| Domain | Weight | MS Learn | MS Labs | Video |
|--------|--------|----------|---------|-------|
| 1. AI Workloads & Considerations | 15-20% | 🕒 | 🕒 | 🕒 |
| 2. Machine Learning on Azure | 15-20% | 🕒 | 🕒 | 🕒 |
| 3. Computer Vision Workloads | 15-20% | 🕒 | 🕒 | 🕒 |
| 4. NLP Workloads | 15-20% | 🕒 | 🕒 | 🕒 |
| 5. Generative AI Workloads | 20-25% | 🕒 | 🕒 | 🕒 |

**Legend:** 🕒 Not Started | 🚧 In Progress | ✅ Complete

> Source: [AI-900 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-900)

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

---

## 💡 Exam Tips

- Read questions carefully — some test subtle differences between services
- Watch for keywords: "unsupervised" (clustering), "numeric prediction" (regression), "categorize" (classification)
- Responsible AI questions are common — know all six principles
- Generative AI has the highest weight (20–25%) — spend extra time here
- Take the practice assessment multiple times — it's free and mirrors the real exam

---

## 🎓 Certification Path

AI-900 is a **foundational certification** that can help prepare for:

- **[Azure Data Scientist Associate (DP-100)](https://learn.microsoft.com/en-us/credentials/certifications/azure-data-scientist/)**
- **[Azure AI Engineer Associate (AI-102)](https://learn.microsoft.com/en-us/credentials/certifications/azure-ai-engineer/)**

AI-900 is **not a prerequisite** for these role-based certifications.

---

*Last updated: 2026-01-14*
