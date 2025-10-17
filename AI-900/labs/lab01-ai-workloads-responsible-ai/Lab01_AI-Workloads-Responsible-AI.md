# Lab 01: AI Workloads and Responsible AI

**Duration:** 45–60 minutes  
**Difficulty:** Beginner

---

## 🎯 Objectives

By the end of this lab, you will be able to:

- Identify common AI workload scenarios (computer vision, NLP, document processing, generative AI)
- Understand and apply the six responsible AI principles
- Analyze real-world case studies demonstrating responsible AI implementation
- Recognize ethical considerations when designing AI solutions

---

## 📋 Prerequisites

- Azure subscription (free trial is sufficient)
- Basic understanding of cloud computing concepts
- Access to the Azure Portal

---

## 🧪 Lab Exercises

### Exercise 1: Explore AI Workload Types

**Objective:** Understand the four main categories of AI workloads.

1. **Computer Vision Workloads:**
   - Navigate to Azure AI Vision service in the portal
   - Review sample scenarios: image classification, object detection, OCR, facial analysis
   - Identify use cases (e.g., retail inventory, security cameras, document processing)

        [Azure AI Vision Studio](https://portal.vision.cognitive.azure.com/gallery/featured)

        <img src='images/2025-10-17-05-21-06.png' width=700>

    **Features:**

    - **Image Analysis**

        - Object detection and classification
        - Tag generation for images
        - Image captioning and descriptions
        - Scene and activity detection
        - Brand and logo detection
        - Adult/racy/gory content detection

    - **Optical Character Recognition (OCR)**

        - Text extraction from images
        - Read API for printed and handwritten text
        - Support for multiple languages
        - Document intelligence capabilities

    - **Face Detection**

        - Face detection and attributes
        - Face verification and identification
        - Face grouping and similarity detection

    - **Spatial Analysis**

        - People counting and tracking
        - Social distancing monitoring
        - Zone occupancy detection

    - **Custom Vision**

        - Custom image classification models
        - Custom object detection models
        - Model training and deployment

    - **Video Analysis**

        - Video indexing
        - Scene and shot detection
        - Motion detection

    **References:**  

    - [What is Azure AI Vision?](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview)
    - [Vision Studio](https://portal.vision.cognitive.azure.com/gallery/featured)
    - [What is Image Analysis?](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview-image-analysis?tabs=4-0)

2. **Natural Language Processing (NLP) Workloads:**

    - Explore Azure AI Language service capabilities
    - Review scenarios: sentiment analysis, entity recognition, key phrase extraction
    - Identify use cases (e.g., customer feedback analysis, chatbots, content moderation)

    **Features:**

    - *Named Entity Recognition (NER)* — Identifies and categorizes named entities in text (people, organizations, locations, dates, quantities).
    - *Key Phrase Extraction* — Extracts main concepts and topics from unstructured text to summarize subject matter.
    - *Sentiment Analysis* — Determines overall sentiment of text (positive, negative, neutral, mixed) and returns confidence scores.
    - *Language Detection* — Automatically detects the language of input text from supported languages.
    - *Entity Linking* — Disambiguates entities by linking them to entries in knowledge bases (provides contextual references).
    - *Personally Identifiable Information (PII) Detection* — Identifies and redacts sensitive data (credit cards, SSNs, emails, phone numbers).
    - *Text Analytics for Health* — Extracts clinical and medical entities (medications, diagnoses, symptoms, treatments) from health documents.
    - *Conversational Language Understanding (CLU)* — Builds custom NLU models to extract intents and entities for chatbots and voice assistants.
    - *Question Answering* — Creates knowledge bases from documents/FAQs to answer user questions (QA and retrieval-augmented scenarios).
    - *Custom Named Entity Recognition (Custom NER)* — Trains domain-specific entity extractors for business- or industry-specific entities.
    - *Custom Text Classification* — Builds models to categorize text into user-defined labels for routing or organization.
    - *Text Summarization* — Generates concise summaries from long documents (extractive or abstractive approaches).
    - *Opinion Mining* — Analyzes sentiment at a granular level by identifying aspects (targets) and opinions expressed about them.

    **References:**  

    - [What is Azure AI Language?](https://learn.microsoft.com/en-us/azure/ai-services/language-service/overview)
    - [AI Language Feautures](https://learn.microsoft.com/en-us/azure/ai-services/language-service/concepts/developer-guide?tabs=language-studio)

3. **Document Processing Workloads:**

- Review Azure AI Document Intelligence (formerly Form Recognizer)
- Explore prebuilt models for invoices, receipts, business cards
- Identify use cases (e.g., invoice automation, receipt scanning)

4. **Generative AI Workloads:**
   - Explore Azure OpenAI Service overview
   - Review capabilities: text generation, code generation, image generation
   - Identify use cases (e.g., content creation, code assistance, virtual assistants)

**Deliverables:**

- Document at least 2 use cases for each workload type
- Create a comparison table showing differences between workload types

**References:**  

- [Microsoft Learn Module: Introduction to AI concepts](https://learn.microsoft.com/en-us/training/modules/get-started-ai-fundamentals/)
- [AI Foundry](https://ai.azure.com/)
  
---

### Exercise 2: Understand Responsible AI Principles

**Objective:** Learn the six core principles of responsible AI.

**The Six Principles:**

1. **Fairness**
   - AI systems should treat all people fairly
   - Avoid reinforcing unfair bias
   - Example: A hiring AI should not discriminate based on gender or race

2. **Reliability and Safety**
   - AI should perform reliably and safely
   - Handle unexpected situations gracefully
   - Example: An autonomous vehicle must safely handle edge cases

3. **Privacy and Security**
   - AI should secure data and respect privacy
   - Implement data protection and access controls
   - Example: A health AI must comply with HIPAA regulations

4. **Inclusiveness**
   - AI should empower everyone and engage people
   - Consider diverse user needs (accessibility, cultural sensitivity)
   - Example: Voice assistants should understand diverse accents

5. **Transparency**
   - AI should be understandable (explainable AI)
   - Users should understand how decisions are made
   - Example: A loan approval AI should explain rejection reasons

6. **Accountability**
   - People should be accountable for AI systems
   - Clear governance and oversight
   - Example: Designate responsible parties for AI system outcomes

**Activity:**

- For each principle, identify a real-world AI scenario where it applies
- Discuss potential consequences of violating each principle

---

### Exercise 3: Case Study Analysis

**Objective:** Apply responsible AI principles to real-world scenarios.

**Case Study 1: Healthcare Diagnosis AI**

A hospital wants to deploy an AI system to assist doctors in diagnosing diseases from medical images.

**Questions:**

1. Which responsible AI principles are most critical for this scenario?
2. What could go wrong if the AI is biased or unreliable?
3. How can transparency be achieved in this context?
4. Who should be accountable if the AI makes an incorrect diagnosis?

**Case Study 2: Hiring Recommendation System**

A company builds an AI to screen job applications and recommend candidates for interviews.

**Questions:**

1. What fairness concerns exist in this scenario?
2. How can the company ensure the AI doesn't discriminate?
3. What data privacy considerations apply?
4. Should candidates be informed that AI is used in screening?

**Case Study 3: Content Moderation AI**

A social media platform uses AI to detect and remove harmful content.

**Questions:**

1. How can the AI balance safety with freedom of expression?
2. What inclusiveness considerations exist (cultural differences, languages)?
3. How should the platform handle false positives (legitimate content flagged as harmful)?
4. Who is accountable for moderation decisions?

**Deliverables:**

- Written analysis for each case study
- Proposed mitigation strategies for identified risks
- Recommended governance framework

---

## 🧠 Knowledge Check

Test your understanding:

1. What are the six responsible AI principles?
2. Which AI workload type would you use to extract text from scanned documents?
3. What is the difference between computer vision and NLP?
4. Why is transparency important in AI systems?
5. What does "fairness" mean in the context of AI?
6. Name three examples of generative AI capabilities.

---

## 📚 Additional Resources

- [Microsoft Responsible AI Principles](https://learn.microsoft.com/en-us/azure/machine-learning/concept-responsible-ai)
- [Azure AI Services Overview](https://learn.microsoft.com/en-us/azure/ai-services/)
- [Responsible AI Transparency Note Examples](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/transparency-note)

---

## ✅ Lab Completion

You have successfully completed Lab 01. You should now understand:

- The four main types of AI workloads
- The six responsible AI principles
- How to apply responsible AI thinking to real-world scenarios
- Ethical considerations when designing AI solutions

**Next Steps:** Proceed to [Lab 02: Machine Learning Fundamentals](../lab02-machine-learning-fundamentals/)

---

**Last updated:** 2025-10-16
