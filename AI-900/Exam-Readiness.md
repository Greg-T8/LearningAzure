# AI-900 Exam Readiness Guide

**Purpose:**  
Help you consolidate key concepts, study strategies, and quick-reference visuals for the **Microsoft Certified: Azure AI Fundamentals (AI-900)** exam.

---

## 🧭 Structure

This guide complements the hands-on labs in the [AI-900 Lab Series](./README.md).  
Use it to reinforce concepts, review domain summaries, and quickly recall high-value exam facts.

---

## 🧠 Domain 1: Describe AI Workloads and Considerations (15–20%)

**Key Topics**

- **Identify features of common AI workloads:**
  - **Computer vision workloads:** image classification, object detection, facial recognition, OCR
  - **Natural language processing (NLP):** text analysis, sentiment analysis, entity recognition, translation
  - **Document processing:** forms, receipts, invoices (Azure AI Document Intelligence)
  - **Generative AI workloads:** content generation, conversational AI, code generation
- **Responsible AI principles:**
  - **Fairness:** AI systems should treat all people fairly and avoid bias
  - **Reliability and Safety:** AI should operate reliably and safely under expected conditions
  - **Privacy and Security:** AI should protect data and respect user privacy
  - **Inclusiveness:** AI should empower everyone and engage people
  - **Transparency:** AI should be understandable (explainable AI)
  - **Accountability:** People should be accountable for AI systems

**Common Pitfalls**

- Confusing **computer vision** vs. **NLP** scenarios
- Not understanding the difference between **classification** (categorize) vs. **object detection** (locate + identify)
- Missing the **six responsible AI principles** — these are heavily tested
- Forgetting that **transparency** means making AI decisions understandable to users

**References**

- [Responsible AI Principles](https://learn.microsoft.com/en-us/azure/machine-learning/concept-responsible-ai)
- [AI Workloads Overview](https://learn.microsoft.com/en-us/training/modules/get-started-ai-fundamentals/)

---

## 🤖 Domain 2: Describe Fundamental Principles of Machine Learning on Azure (15–20%)

**Key Topics**

- **Identify common machine learning techniques:**
  - **Regression:** Predict a numeric value (e.g., price, temperature)
  - **Classification:** Predict a category (e.g., spam/not spam, cat/dog)
  - **Clustering:** Group similar items without predefined labels (unsupervised learning)
  - **Deep learning:** Neural networks with multiple layers (CNNs, RNNs)
  - **Transformer architecture:** Foundation for modern NLP models (BERT, GPT)
- **Core machine learning concepts:**
  - **Features:** Input variables used to make predictions
  - **Labels:** Target variable you want to predict (supervised learning)
  - **Training dataset:** Data used to train the model
  - **Validation dataset:** Data used to evaluate model performance during training
  - **Test dataset:** Held-out data to evaluate final model performance
- **Azure Machine Learning capabilities:**
  - **Automated ML (AutoML):** Automatically select algorithms and hyperparameters
  - **Data and compute services:** Datastores, datasets, compute clusters
  - **Model management and deployment:** Model registry, endpoints, real-time/batch inference

**Common Pitfalls**

- Confusing **regression** (numeric output) vs. **classification** (categorical output)
- Forgetting that **clustering** is **unsupervised** (no labels)
- Not understanding the purpose of **training vs. validation vs. test** datasets
- Missing the difference between **automated ML** (no-code) vs. **custom training** (code-first)

**References**

- [Machine Learning Fundamentals](https://learn.microsoft.com/en-us/training/modules/fundamentals-machine-learning/)
- [Azure Machine Learning Overview](https://learn.microsoft.com/en-us/azure/machine-learning/overview-what-is-azure-machine-learning)

---

## 👁️ Domain 3: Describe Features of Computer Vision Workloads on Azure (15–20%)

**Key Topics**

- **Identify common types of computer vision solution:**
  - **Image classification:** Categorize entire image (e.g., cat, dog, car)
  - **Object detection:** Locate and identify multiple objects in an image (bounding boxes)
  - **Optical character recognition (OCR):** Extract text from images or documents
  - **Facial detection:** Detect faces in images
  - **Facial analysis:** Identify attributes (age, emotion, glasses) and recognize individuals
- **Azure tools and services for computer vision:**
  - **Azure AI Vision service:**
    - Image analysis (tags, captions, objects, brands)
    - OCR (Read API)
    - Spatial analysis
    - Custom Vision (train custom image classification and object detection models)
  - **Azure AI Face service:**
    - Face detection and verification
    - Face identification and grouping
    - Emotion and attribute detection

**Common Pitfalls**

- Confusing **image classification** (one label per image) vs. **object detection** (multiple objects with locations)
- Not understanding when to use **Azure AI Vision** vs. **Azure AI Face**
- Forgetting that **Custom Vision** is for training custom models, not general-purpose vision
- Missing the difference between **face detection** (find faces) vs. **face recognition** (identify specific people)

**References**

- [Azure AI Vision Documentation](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/)
- [Azure AI Face Documentation](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview-identity)

---

## 💬 Domain 4: Describe Features of NLP Workloads on Azure (15–20%)

**Key Topics**

- **Identify features of common NLP workload scenarios:**
  - **Key phrase extraction:** Identify main concepts/topics in text
  - **Entity recognition:** Extract named entities (people, places, organizations, dates)
  - **Sentiment analysis:** Determine positive, negative, or neutral sentiment
  - **Language modeling:** Predict next word or understand context (foundation for chatbots)
  - **Speech recognition:** Convert speech to text (speech-to-text)
  - **Speech synthesis:** Convert text to speech (text-to-speech)
  - **Translation:** Translate text or speech between languages
- **Azure tools and services for NLP:**
  - **Azure AI Language service:**
    - Named entity recognition (NER)
    - Key phrase extraction
    - Sentiment analysis
    - Language detection
    - Conversational language understanding (CLU)
    - Question answering
  - **Azure AI Speech service:**
    - Speech-to-text (recognition)
    - Text-to-speech (synthesis)
    - Speech translation
    - Speaker recognition

**Common Pitfalls**

- Confusing **key phrase extraction** (topics) vs. **entity recognition** (specific names/dates)
- Not understanding the difference between **Azure AI Language** vs. **Azure AI Speech**
- Forgetting that **sentiment analysis** returns positive/negative/neutral scores
- Missing that **conversational language understanding (CLU)** is for building chatbots/voice assistants

**References**

- [Azure AI Language Documentation](https://learn.microsoft.com/en-us/azure/ai-services/language-service/)
- [Azure AI Speech Documentation](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/)

---

## 🤖 Domain 5: Describe Features of Generative AI Workloads on Azure (20–25%)

**Key Topics**

- **Identify features of generative AI solutions:**
  - **Generative AI models:** Models that create new content (text, images, code, audio)
  - **Large language models (LLMs):** GPT-4, GPT-3.5, etc.
  - **Multimodal models:** Models that work with multiple types of data (text, images, audio)
  - **Common scenarios:**
    - Content generation (articles, marketing copy, code)
    - Conversational AI (chatbots, virtual assistants)
    - Code completion and generation
    - Image generation (DALL-E)
    - Data summarization and extraction
- **Responsible AI considerations for generative AI:**
  - **Bias and fairness:** LLMs can amplify biases in training data
  - **Harmful content:** Models may generate offensive or inappropriate content
  - **Misinformation:** Models can generate false or misleading information
  - **Security:** Prompt injection attacks, data leakage
  - **Mitigation strategies:** Content filters, grounding with data, human review
- **Generative AI services and capabilities in Azure:**
  - **Azure OpenAI Service:**
    - GPT-4, GPT-4 Turbo, GPT-3.5 (text generation, chat)
    - DALL-E (image generation)
    - Whisper (speech-to-text)
    - Embeddings (semantic search, recommendations)
    - Content filters and responsible AI controls
  - **Azure AI Foundry (formerly Azure AI Studio):**
    - Build, test, and deploy generative AI solutions
    - Prompt engineering and testing (prompt flow)
    - Model evaluation and monitoring
    - Integration with Azure OpenAI, Azure AI Search, and other services
  - **Azure AI Foundry model catalog:**
    - Access to foundation models from Microsoft, OpenAI, Meta, Hugging Face, etc.
    - Deploy models as managed endpoints
    - Fine-tune models with custom data

**Common Pitfalls**

- Confusing **Azure OpenAI Service** (API access to models) vs. **Azure AI Foundry** (platform for building solutions)
- Not understanding the importance of **content filters** and **grounding** for responsible AI
- Forgetting that **prompt engineering** is critical for getting good results from LLMs
- Missing the difference between **GPT-4** (most capable, expensive) vs. **GPT-3.5** (faster, cheaper)
- Not knowing that **Azure AI Foundry model catalog** provides access to non-OpenAI models

**References**

- [Azure OpenAI Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
- [Azure AI Foundry Documentation](https://learn.microsoft.com/en-us/azure/ai-studio/)
- [Responsible AI for Generative AI](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/system-message)

---

## 🧩 Study Strategy

| Phase | Focus | Key Tools |
|-------|--------|-----------|
| **1** | Understand AI workloads and responsible AI principles | Conceptual learning, case studies |
| **2** | Master machine learning fundamentals | Azure ML automated ML, datasets |
| **3** | Deep dive into computer vision | Azure AI Vision, Azure AI Face |
| **4** | Explore NLP and speech | Azure AI Language, Azure AI Speech |
| **5** | Build generative AI solutions | Azure OpenAI, Azure AI Foundry |

> 💡 **Tip:** Focus on **understanding use cases** and **when to use which service** rather than memorizing API details.

---

## 📸 Visual Aids

Use diagrams and screenshots to reinforce key concepts:

- AI workload types (computer vision, NLP, generative AI)
- Responsible AI principles wheel
- Machine learning process flow (data → train → evaluate → deploy)
- Azure AI services architecture
- Azure OpenAI Service capabilities

*(Add screenshots from labs to the `images/` folder)*

---

## 🧾 Checklist: Final Review Before Exam

✅ Memorize the **six responsible AI principles** (fairness, reliability, privacy, inclusiveness, transparency, accountability)  
✅ Understand **regression vs. classification vs. clustering**  
✅ Know when to use **Azure AI Vision vs. Azure AI Face**  
✅ Understand **Azure AI Language** capabilities (sentiment, entities, key phrases)  
✅ Know the difference between **Azure AI Speech** (speech-to-text, text-to-speech) vs. **Azure AI Language** (text analysis)  
✅ Understand **Azure OpenAI Service** capabilities (GPT, DALL-E, Whisper)  
✅ Know what **Azure AI Foundry** is used for (building and deploying generative AI solutions)  
✅ Understand **responsible AI for generative AI** (content filters, grounding, bias mitigation)  
✅ Practice identifying **use cases** for each AI service  
✅ Complete all hands-on labs to reinforce practical knowledge  

---

## 📚 Recommended Resources

- **[AI-900 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-900)** — Official exam objectives
- **[AI-900 Learning Path](https://learn.microsoft.com/en-us/training/paths/get-started-with-artificial-intelligence-on-azure/)** — Microsoft Learn modules
- **[Official Practice Assessment](https://learn.microsoft.com/en-us/credentials/certifications/exams/ai-900/practice/assessment?assessment-type=practice&assessmentId=26)** — Free practice questions
- **[The AI Show](https://learn.microsoft.com/en-us/shows/ai-show/)** — Video series on Azure AI
- **[Azure AI Documentation](https://learn.microsoft.com/en-us/azure/ai-services/)** — Service-specific docs
- **[John Savill's AI-900 Study Cram (YouTube)](https://www.youtube.com/watch?v=OwZHNH8EfSU)** — Comprehensive video review

---

## 💡 Exam Tips

✅ **Read questions carefully** — some questions test subtle differences between services  
✅ **Eliminate obviously wrong answers** — narrow down to 2 options, then choose the best fit  
✅ **Watch for keywords** like "unsupervised" (clustering), "numeric prediction" (regression), "categorize" (classification)  
✅ **Responsible AI questions are common** — know all six principles cold  
✅ **Use cases are key** — understand when to use which service, not just what each service does  
✅ **Azure AI Foundry is new** — expect questions on its capabilities and model catalog  
✅ **Generative AI has the highest weight (20–25%)** — spend extra time on Azure OpenAI and AI Foundry  
✅ **Take the practice assessment multiple times** — it's free and closely mirrors the real exam  

---

**Last updated:** 2025-10-16
