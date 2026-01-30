# AI-900 Study Cram v2 (the non-Generative AI bits) - Exam Notes

**Video:** [https://www.youtube.com/watch?v=bTkUTkXrqOQ](https://www.youtube.com/watch?v=bTkUTkXrqOQ)  
**Published:** 2024-07-01  
**Duration:** 1:16:59  

*Generated on 2026-01-28 05:22*

---

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Introduction](#introduction)
* [Preparation materials](#preparation-materials)
* [What is AI](#what-is-ai)
* [Machine learning](#machine-learning)
* [Training process](#training-process)
* [Training data types](#training-data-types)
* [Azure Machine Learning Studio](#azure-machine-learning-studio)
* [Deep learning](#deep-learning)
* [Type summary](#type-summary)
* [Provided solutions](#provided-solutions)
* [Endpoints and keys](#endpoints-and-keys)
* [Responsible AI](#responsible-ai)
* [Computer vision](#computer-vision)
* [Vision services](#vision-services)
* [Face](#face)
* [Natural Language](#natural-language)
* [Speech](#speech)
* [Translation](#translation)
* [Document intelligence](#document-intelligence)
* [Knowledge mining](#knowledge-mining)
* [Review](#review)
* [Exam tips](#exam-tips)
* [Close](#close)

## Introduction

**Timestamp**: 00:00:00 – 00:00:44

**Key Concepts**  

- Updating study materials with the latest information on Azure AI Fundamentals  
- Separation of content between generative AI and general Azure AI topics  
- Importance of using official Microsoft Learn resources for exam preparation  

**Definitions**  

- **Generative AI**: Not covered in this session; addressed in a separate study cram video  

**Key Facts**  

- The presenter has created a separate study cram specifically for generative AI  
- Microsoft Learn provides updated information on exam preparation, skills measured, and practice resources  
- The Microsoft Azure AI Fundamentals course is regularly updated and includes practice assessments and a sandbox environment  

**Examples**  

- None mentioned  

**Key Takeaways 🎯**  

- Watch this session for general Azure AI information excluding generative AI  
- Follow up with the generative AI study cram for a complete understanding  
- Start exam preparation with the Microsoft Learn page to access up-to-date content and practice tools  
- Utilize the sandbox environment on Microsoft Learn to familiarize yourself with the exam interface and reduce anxiety during the actual exam  

---

## Preparation materials

**Timestamp**: 00:00:44 – 00:02:28

**Key Concepts**  

- Start exam preparation with the Microsoft Learn page for the Azure AI Fundamentals exam.  
- Microsoft Learn provides updated information, exam preparation guidance, skills measured, and the official Azure AI Fundamentals course.  
- The Azure AI Fundamentals course is comprehensive, regularly updated, and includes practice assessments.  
- The sandbox environment simulates the exam interface to familiarize candidates with the exam format and controls.  
- The exam duration is 45 minutes and is a fundamental-level exam.  
- No coding or deployment is required; focus is on understanding which technologies to use.  
- The exam skills are broken down into key areas with specific skills to master.  
- Use the skills measured list as a checklist to confirm readiness before taking the exam.  
- Study crams serve as quick refreshers just before the exam to reinforce learned material.

**Definitions**  

- **Sandbox**: A practice environment that mimics the actual exam interface, helping candidates become comfortable with the exam format and controls.  
- **Skills Measured**: The specific knowledge areas and competencies that the exam tests, broken down into main topics and detailed skills.

**Key Facts**  

- Exam length: 45 minutes.  
- Exam level: Fundamental (basic understanding, no coding or deployment required).  
- Microsoft Learn is the primary official resource for preparation.  
- Practice assessments and sandbox environment are available on Microsoft Learn.

**Examples**  

- Sandbox environment example: Allows candidates to experience the exam interface and understand what buttons and question types to expect.

**Key Takeaways 🎯**  

- Begin preparation with Microsoft Learn’s Azure AI Fundamentals course and resources.  
- Use the skills measured documentation as a checklist to ensure all topics are understood.  
- Take advantage of practice assessments and the sandbox to reduce exam-day anxiety.  
- The exam focuses on conceptual understanding rather than technical implementation.  
- Use study crams as a final review tool shortly before the exam to boost confidence.  

---

## What is AI

**Timestamp**: 00:02:28 – 00:04:38

**Key Concepts**  

- Intelligence involves various human capabilities such as seeing, recognizing objects, reading text, speaking, hearing and transcribing, translating, making decisions, and predicting based on historical data.  
- Artificial Intelligence (AI) is about computers imitating some aspects of human intelligence and behavior.  
- AI is software designed to replicate human capabilities.  
- AI can be implemented by explicitly coding all logic or by enabling computers to learn from data.  
- Machine Learning is a subset of AI where computers train themselves using past data to make future predictions.

**Definitions**  

- **Artificial Intelligence (AI)**: The ability of a computer to imitate human capabilities and behaviors through software.  
- **Machine Learning**: A subset of AI where a computer uses training data to learn and make predictions without being explicitly programmed for every scenario.

**Key Facts**  

- Human intelligence includes abilities such as object recognition, captioning images, reading text aloud, speech-to-text transcription, translation, decision making, and prediction.  
- Writing explicit code for complex tasks like number recognition (e.g., identifying all variations of the digit "1") is impractical due to the vast number of possibilities.  
- Machine learning allows computers to avoid manual logic coding by learning from historical data.

**Examples**  

- Human capabilities:  
  - Seeing and identifying objects in a picture.  
  - Giving detailed captions for images.  
  - Reading text aloud.  
  - Transcribing spoken words into text.  
  - Translating languages (limited personal example given: asking for train times in German).  
  - Making decisions and predictions based on facts and historical information.  
- AI example: Instead of coding every possible variation of the number "1" for recognition, a machine learning model can be trained on past data to recognize numbers.

**Key Takeaways 🎯**  

- AI fundamentally means software imitating human intelligence and behavior.  
- Explicitly coding all logic for complex tasks is inefficient and often impossible.  
- Machine learning enables computers to learn from data and improve predictions without exhaustive manual programming.  
- Understanding AI starts with recognizing it as a broad field encompassing many capabilities, with machine learning as a key approach within it.

---

## Machine learning

**Timestamp**: 00:04:38 – 00:05:22

**Key Concepts**  

- Machine learning is a subset of artificial intelligence.  
- Instead of manually writing all the logic for tasks (e.g., number recognition), the computer can train itself using past data.  
- The training process involves using historical data to build a model that can make future predictions.

**Definitions**  

- **Machine learning**: A branch of AI focused on enabling computers to learn from past data and improve their performance on tasks without explicit programming of every rule.

**Key Facts**  

- Machine learning relies on having training data.  
- Training data consists of many examples with associated correct answers (labels).  
- Features are the individual pieces of data or attributes used to train the model.

**Examples**  

- Number recognition: Instead of coding every possible variation of the number "1," the computer learns from many examples of handwritten or printed "1"s.  
- Other example contexts mentioned include pictures of numbers, pictures of oranges, or historical temperature data from engines.

**Key Takeaways 🎯**  

- Writing explicit logic for complex recognition tasks is impractical due to the vast variability.  
- Machine learning automates this by learning patterns from data.  
- The quality and quantity of training data are crucial for building effective machine learning models.  
- Understanding features and labeled data is fundamental to the training process.  

---

## Training process

**Timestamp**: 00:05:22 – 00:09:33

**Key Concepts**  

- Machine learning uses training data consisting of features and labels to train models.  
- Training data includes input features (data points) and corresponding correct answers (labels).  
- Algorithms analyze training data to find relationships between features and labels.  
- The goal is to generalize from training data to predict labels for new, unseen data.  
- Different types of algorithms exist, each suited for different data types and problems.  
- The output of training is a model that can predict labels for new inputs.  
- Model training is iterative, involving training data and separate testing data to validate performance.  
- Based on testing results, models may be released or further trained/tweaked.  
- There are different types of training, including supervised learning where data is labeled.

<img src='.img/2026-01-29-04-38-21.png' width=500> 

<img src='.img/2026-01-29-04-40-33.png' width=700> 

**Definitions**  

- **Features**: The input data values or attributes used to describe aspects of the data (e.g., pictures of numbers, temperature readings).  
- **Label**: The correct answer or category associated with each feature in the training data (e.g., "orange," "#1").  
- **Model**: The output of the training process; a system that can predict labels for new data based on learned relationships.  
- **Supervised Learning**: A type of machine learning where the training data includes both features and their correct labels.

**Key Facts**  

- Training data must be labeled to be useful for supervised learning.  
- Algorithms mentioned include decision trees, linear regression, and support vector machines.  
- Decision trees split data based on feature values until reaching leaf nodes that represent outcomes.  
- Linear regression fits a straight line through data points to predict continuous values (e.g., house price based on square footage).  
- Support vector machines find a line that maximizes the margin between clusters of data points for classification.  
- Model evaluation uses testing data with known labels to compare predicted vs. actual labels.  
- Model tuning involves tweaking parameters until performance is satisfactory for real-world use.

**Examples**  

- Pictures of numbers (#1, #2, #3, #4) as features with labels indicating the number shown.  
- Pictures of oranges and apples with labels identifying the fruit.  
- Historical temperature data from engines with labels indicating conditions.  
- House price prediction using square footage as a feature with linear regression.  
- Clusters of data separated by a line in support vector machines.

**Key Takeaways 🎯**  

- Machine learning relies on labeled training data to build predictive models.  
- Choosing the right algorithm depends on the data type and problem context.  
- Training is iterative and requires validation with testing data to ensure accuracy.  
- Models must be tuned and tested before deployment in real-world scenarios.  
- Understanding features, labels, and the training/testing split is fundamental to machine learning.

---

## Training data types

**Timestamp**: 00:09:33 – 00:13:40

**Key Concepts**  

- Different types of training data exist beyond just "training data" itself.  
- Supervised learning involves labeled data.  
- Supervised learning can be subdivided into regression and classification.  
- Classification can be binary (two classes) or multiclass (multiple classes).  
- Unsupervised learning involves unlabeled data and focuses on clustering or grouping based on similarities.  
- Azure Machine Learning Studio supports creating custom models, importing and labeling datasets, training, testing, and deploying models.

<img src='.img/2026-01-29-04-43-37.png' width=700> 

**Definitions**  

- **Supervised learning**: Training with data that has known labels.  
- **Regression**: A type of supervised learning where the output is numeric (e.g., predicting house prices).  
- **Classification**: A type of supervised learning where the output is a category or class.  
- **Binary classification**: Classification with two mutually exclusive classes (e.g., will a viewer like a video or not).  
- **Multiclass classification**: Classification with multiple possible classes (e.g., video genres like horror, fiction, learning).  
- **Unsupervised learning**: Training with data that has no labels, focusing on finding clusters or groups within the data.

**Key Facts**  

- Supervised learning requires labeled data.  
- Regression is used for numeric prediction tasks.  
- Classification tasks can be binary or multiclass.  
- Unsupervised learning looks for natural groupings in unlabeled data.  
- Azure Machine Learning Studio (ml.azure.com) allows importing data, labeling, training, testing, and deploying models.  
- Models can be deployed in containers on-premises or in Azure cloud services like Kubernetes or container instances.

**Examples**  

- Regression example: Predicting house prices.  
- Binary classification example: Predicting if a viewer will like a video or not.  
- Multiclass classification example: Categorizing videos into genres such as horror, fiction, or learning.

**Key Takeaways 🎯**  

- Understanding the type of training data (supervised vs unsupervised) is crucial for selecting the right machine learning approach.  
- Supervised learning requires labeled data and can be tailored to numeric or categorical outputs.  
- Unsupervised learning is useful when labels are not available and the goal is to find inherent patterns.  
- Azure Machine Learning Studio is a comprehensive tool for managing the entire lifecycle of custom model training and deployment.  
- Deployment flexibility allows running models in various environments, not limited to the cloud.

---

## Azure Machine Learning Studio

**Timestamp**: 00:13:40 – 00:14:37

**Key Concepts**  

- Azure Machine Learning Studio is a cloud service designed to help users perform custom machine learning training.  
- Models trained in Azure ML Studio can be deployed in various environments, including containers.  
- Deployment options include on-premises containers, Azure Kubernetes Service (AKS), and Azure Container Instances (ACI).  
- Azure ML Studio supports both custom model training and access to pre-built models.

<img src='.img/2026-01-29-04-43-57.png' width=700> 

<img src='.img/2026-01-29-04-44-37.png' width=200>

**Definitions**  

- **Azure Machine Learning Studio**: An Azure cloud service that facilitates custom training, testing, and deployment of machine learning models.  
- **Container**: A lightweight, standalone, executable package that includes everything needed to run a piece of software, such as a trained ML model, in different environments.

**Key Facts**  

- Models trained in Azure ML Studio are not limited to cloud hosting; they can be deployed in containers on-premises or in Azure services like AKS and ACI.  
- Azure ML Studio provides flexibility in how and where models are run after training.  
- While many pre-built models exist, Azure ML Studio is specifically useful when custom training is required.

**Examples**  

- Deploying a trained model to a container that runs on-premises or in Azure Kubernetes Service.  
- Using Azure Container Instances to host a custom-trained model.

**Key Takeaways 🎯**  

- Azure Machine Learning Studio is a versatile platform for custom ML model training and deployment.  
- Deployment flexibility allows models to run in cloud or on-premises environments using containers.  
- Pre-built models are available, but Azure ML Studio is essential when custom training is needed.  
- Understanding deployment options (containers, AKS, ACI) is important for operationalizing ML models effectively.  

---

## Deep learning

**Timestamp**: 00:14:37 – 00:22:32

**Key Concepts**  

- Deep learning is a subset of machine learning designed to handle complex relationships that basic algorithms cannot express.  
- Deep learning uses neural networks composed of multiple layers of neurons (nodes) connected to each other.  
- Each neuron applies an **activation function** to decide whether to pass a value forward or output zero.  
- Neural networks have an input layer (receives data), multiple hidden layers (process data), and an output layer (produces results).  
- Connections between neurons have weights and biases that adjust the strength and threshold of activations.  
- Training deep learning models involves adjusting weights and biases to model complex patterns.  
- Large language models (LLMs) like GPT are deep neural networks with tens of hidden layers and trillions of parameters.  
- The softmax function is commonly used at the output layer to convert raw values into a probability distribution.  
- Training large models requires massive computational resources (e.g., 10,000+ GPUs over months).  
- For most users, retraining large models is impractical; instead, techniques like prompt engineering and retrieval-augmented generation (RAG) are used.  
- Smaller neural networks can be trained effectively with less data and computational power for specific tasks.  

<img src='.img/2026-01-29-04-48-10.png' width=600> 

**Definitions**  

- **Deep learning**: A subset of machine learning using multi-layered neural networks to model complex data relationships.  
- **Neuron (Activation function)**: A computational unit in a neural network that processes input values and decides whether to activate (pass a value) or output zero.  
- **Weights**: Parameters on connections between neurons that scale input values.  
- **Bias**: A parameter added to a neuron's input to shift the activation threshold.  
- **ReLU (Rectified Linear Unit)**: An activation function that activates only when input exceeds a certain threshold.  
- **Softmax**: A function that converts a vector of values into a probability distribution summing to one.  

**Key Facts**  

- Neural networks consist of multiple layers: input, hidden, and output layers.  
- Each neuron connects to every neuron in the next layer (fully connected layers).  
- Activation functions include ReLU, sigmoid, Gaussian error linear unit, among others.  
- Large models have trillions of parameters (weights and biases).  
- Training large language models requires months and thousands of powerful GPUs.  
- Softmax is used to pick the most probable next token in language models.  

**Examples**  

- Large language models like GPT use deep learning with many hidden layers and trillions of parameters.  
- Deep learning can be used for classification, prediction, anomaly detection (e.g., detecting if someone is wearing a mask, predicting equipment failure).  
- Smaller neural networks can be trained for specific tasks without the need for massive resources.  

**Key Takeaways 🎯**  

- Deep learning enables modeling of highly complex data patterns beyond traditional machine learning algorithms.  
- Neural networks rely on weighted connections and activation functions to process and propagate information.  
- Training large deep learning models is resource-intensive and often impractical for individual users.  
- Instead of retraining large models, users typically leverage prompt engineering or smaller custom-trained models.  
- Understanding activation functions and the role of weights and biases is crucial to grasp how neural networks learn.  
- Deep learning powers many advanced AI capabilities, including generative AI and large language models.

---

## Type summary

**Timestamp**: 00:22:32 – 00:23:07

**Key Concepts**  

- Different types of machine learning approaches  
- Artificial Intelligence (AI) as rule-based or explicitly programmed behavior  
- Machine Learning (ML) using labeled data for prediction, labeling, and classification  
- Deep Learning leveraging neural networks for advanced tasks 

**Definitions**  

- **Artificial Intelligence (AI)**: Systems where behavior is explicitly programmed or rules are written to perform tasks (e.g., early chess computers).  
- **Machine Learning (ML)**: Algorithms trained on labeled data to predict or classify new data.  
- **Deep Learning**: Use of neural networks to model complex patterns and perform sophisticated tasks.  

**Key Facts**  

- Early chess computers operated similarly to AI with explicit rules rather than learning.  
- Machine learning requires labeled data to train models for prediction and classification.  
- Deep learning uses neural networks and is often applied in advanced AI solutions.  

**Examples**  

- Early chess computers as an example of AI with explicit programming.  

**Key Takeaways 🎯**  

- AI, ML, and deep learning represent a spectrum from rule-based systems to data-driven neural networks.  
- Understanding these distinctions helps in selecting appropriate approaches for different problems.  
- Deep learning enables leveraging powerful neural networks for complex tasks beyond traditional ML.

---

## Provided solutions

**Timestamp**: 00:23:07 – 00:30:47

**Key Concepts**  

- Provided AI solutions are pre-trained models designed for specific tasks.  
- Vision capabilities include OCR, image tagging, object detection, face detection, and live face verification.  
- Natural language capabilities include chatbots, summarization, question answering, speech-to-text, text-to-speech, and translation.  
- Document intelligence can extract structured data from forms, invoices, and large text documents.  
- Knowledge mining extracts and indexes information from structured, semi-structured, and unstructured data to make it searchable and enrichable.  
- Custom AI solutions can be built by combining or extending these pre-trained models.  
- Azure AI services offer a wide range of single-purpose and multi-service AI resources.  
- Single service resources often have free tiers for experimentation.  
- Multi-service resources combine many AI capabilities under one endpoint but lack free tiers and granular cost tracking.  
- Azure OpenAI and AI Search are special service types with different availability and pricing models.  
- AI services expose REST endpoints for applications to interact with, typically using HTTP and JSON.

<img src='.img/2026-01-29-04-54-45.png' width=500> 

<img src='.img/2026-01-29-04-55-14.png' width=700>

<img src='.img/2026-01-29-04-56-08.png' width=200>

<img src='.img/2026-01-29-04-56-55.png' width=700> 

<img src='.img/2026-01-29-04-58-26.png' width=400>


**Definitions**  

- **Optical Character Recognition (OCR)**: Technology to read and extract text from images.  
- **Document Intelligence**: AI capability to understand and extract data from documents such as forms and invoices.  
- **Knowledge Mining**: Process of extracting, indexing, and enriching information from various data types to make it searchable and usable by other applications.  
- **Single Service Resource**: An Azure AI resource dedicated to one specific AI capability (e.g., computer vision, face API).  
- **Multi-Service Resource**: An Azure AI resource that provides access to multiple AI capabilities through a single endpoint, excluding OpenAI and AI Search.  
- **Endpoint**: A RESTful URL where an AI service is accessed by applications, communicating via HTTP and exchanging JSON data.

**Key Facts**  

- Many Azure AI single service resources have free tiers allowing a certain number of free calls for learning and experimentation.  
- Azure OpenAI service does not have a free tier.  
- AI Search has a limited free tier but lacks some advanced features like semantic re-ranking.  
- Single service resources provide granular cost tracking and role-based access control per resource.  
- Multi-service resources do not offer free tiers and have a shared endpoint, making cost attribution less granular.  
- Applications interact with AI services via REST endpoints using HTTP requests and JSON responses.

**Examples**  

- Vision capabilities: reading text from images (OCR), tagging images, detecting objects and faces, verifying if a face is live.  
- Natural language: chatbots, summarizing text, question answering, speech-to-text, text-to-speech, translation.  
- Document intelligence: extracting addresses, phone numbers, invoice items from forms.  
- Knowledge mining: extracting text from images or audio via vision or speech services to index and make searchable.

**Key Takeaways 🎯**  

- Provided AI solutions cover a broad range of specialized tasks, enabling rapid development without training models from scratch.  
- Azure AI offers flexible resource types: single service for focused use with free tiers, multi-service for convenience but without free tiers or detailed cost tracking.  
- Understanding the distinction between single service, multi-service, and OpenAI resources is important for cost management and capability planning.  
- REST endpoints are the standard interface for integrating AI services into applications, facilitating easy HTTP-based communication.  
- Experimenting with free tiers of single service resources is recommended for hands-on learning and prototyping.

---

## Endpoints and keys

**Timestamp**: 00:30:47 – 00:33:32

**Key Concepts**  

- AI services expose endpoints (URLs) that applications communicate with.  
- Communication with endpoints is typically via REST (HTTP-based) and returns JSON responses.  
- SDKs often provide language-friendly libraries that handle REST calls internally.  
- Authentication to endpoints requires keys or integrated identity solutions.  
- Secure storage of keys is critical (e.g., Azure Key Vault).  
- Role-based access control (RBAC) and Azure Entra ID integrated authentication can eliminate the need to store keys.  
- Managed identities in Azure provide automatic identities for resources to access services securely without keys.  

<img src='.img/2026-01-29-04-59-56.png' width=400>

<img src='.img/2026-01-29-05-00-42.png' width=700> 

**Definitions**  

- **Endpoint**: A URL address exposed by an AI service that an application connects to for interaction.  
- **REST Endpoint**: An HTTP-based interface that accepts requests and returns JSON responses.  
- **SDK (Software Development Kit)**: A set of libraries that simplify interacting with REST endpoints in a programming language.  
- **Key**: A secret token used to authenticate and authorize access to an AI service endpoint.  
- **Azure Key Vault**: A secure service to store keys and secrets, preventing them from being exposed in code or repositories.  
- **Entra ID Integrated Authentication**: An authentication method using Azure Active Directory identities and RBAC instead of keys.  
- **Managed Identity**: An automatically managed identity assigned to Azure resources to authenticate to services without storing credentials.  

**Key Facts**  

- Endpoints are REST-based and return JSON responses.  
- Each endpoint has associated keys (usually two) for authentication.  
- Keys should not be stored in config files or Git repositories.  
- Azure services support RBAC with Entra ID to avoid key management.  
- Managed identities simplify permission management and key rotation concerns.  

**Examples**  

- Viewing a vision AI resource in Azure shows the endpoint URL and two keys.  
- An application can fetch keys securely from Azure Key Vault or use Entra ID integrated auth with assigned roles.  

**Key Takeaways 🎯**  

- Always secure your keys; do not hardcode or expose them publicly.  
- Prefer using Azure Entra ID integrated authentication and managed identities for better security and easier management.  
- Use SDKs to simplify interaction with REST endpoints.  
- Understand that endpoints are the main access points for AI services and require proper authentication.  
- Role-based access control helps assign precise permissions without sharing keys.

---

## Responsible AI

**Timestamp**: 00:33:32 – 00:39:04

**Key Concepts**  

- Responsible AI involves ensuring AI systems are trustworthy, safe, fair, reliable, inclusive, transparent, and accountable.  
- AI introduces risks such as bias, errors, privacy concerns, and lack of inclusiveness.  
- The shift from human decision-making to AI-driven decisions requires careful consideration of these risks.  
- Six key principles guide responsible AI: fairness, reliability & safety, privacy & security, inclusiveness, transparency, and responsibility/accountability.

<img src='.img/2026-01-30-04-10-54.png' width=500>

**Definitions**  

- **Fairness**: Ensuring AI treats all people equally without bias introduced from training data.  
- **Reliability and Safety**: AI systems must be rigorously tested and dependable, especially in critical applications.  
- **Privacy and Security**: Data used for training must be legitimate, scrubbed, and protected to maintain privacy.  
- **Inclusiveness**: AI should work for everyone regardless of race, gender, or other societal factors.  
- **Transparency**: Clear understanding of how AI works, its limitations, and its purpose.  
- **Responsibility/Accountability**: Developers, companies, and leadership must be held accountable for ethical and legal standards in AI deployment.

**Key Facts**  

- Bias in training data leads to biased AI models ("garbage in, garbage out").  
- Errors in AI can have severe consequences (e.g., self-driving cars causing accidents).  
- Data exposure risks arise if inappropriate data is used for training or predictions reveal sensitive information.  
- AI systems may not work equally well for all populations if inclusiveness is not considered.  
- Accountability is critical to prevent misuse or abuse of AI technologies such as facial recognition.

**Examples**  

- Self-driving cars: illustrate risks of errors and the need for reliability and safety.  
- AI in surgery or monitoring reactors: examples where reliability and safety are paramount.  
- Facial recognition: example of technology that can be abused if accountability is lacking.

**Key Takeaways 🎯**  

- Responsible AI requires proactive identification and mitigation of risks related to bias, errors, privacy, inclusiveness, transparency, and accountability.  
- Comprehensive testing and ethical considerations must be embedded throughout AI development and deployment.  
- Accountability lies with developers, companies, and leadership to ensure AI meets ethical and legal standards.  
- Without responsible AI practices, there is a risk of harm, discrimination, privacy violations, and loss of trust.  
- Understanding and applying the six key principles is essential for trustworthy AI systems.  

---

## Computer vision

**Timestamp**: 00:39:04 – 00:41:55

**Key Concepts**  

- Computer vision deals with processing and understanding images.  
- Images are fundamentally composed of pixels, each having a value.  
- Multimodal models support multiple input types/modalities such as images, language, video, and audio.  
- Foundational models are broad in capability and can be fine-tuned for specific use cases.  
- Vision services include tasks like image analysis and captioning.

<img src='.img/2026-01-30-04-13-15.png' width=400>

**Definitions**  

- **Image**: A collection of pixels, where each pixel has a value (e.g., grayscale values from 0 to 255 or multiple values for color).  
- **Multimodal**: Refers to models that can understand and interact with multiple types of data/modalities (e.g., images, text, video, audio).  
- **Foundational model**: A broad, general-purpose AI model that can be adapted or fine-tuned for specific tasks or domains.

**Key Facts**  

- Grayscale pixel values typically range from 0 to 255.  
- Color images have multiple values per pixel (e.g., RGB channels).  
- JPEG images use compression to store images more efficiently than raw pixel data.  
- Examples of multimodal models include GPT-4O and Microsoft’s Florence model.  
- Foundational models serve as a base for building more specialized solutions.

**Examples**  

- An image of a number “7” represented by pixels with values (e.g., 255 for white pixels forming the shape, zeros elsewhere).  
- Vision services can analyze an image (e.g., a cow under a tree) and generate captions describing the content.

**Key Takeaways 🎯**  

- Understanding the pixel-based nature of images is fundamental to computer vision.  
- Multimodal AI models enhance interaction by supporting various data types beyond just images.  
- Foundational models provide a versatile starting point for developing tailored computer vision applications.  
- Vision services like image analysis and captioning are practical applications of computer vision technology.

---

## Vision services

**Timestamp**: 00:41:55 – 00:47:08

**Key Concepts**  

- Vision services focus on analyzing images using AI to extract meaningful information.  
- Image analysis can generate captions, tags, detect objects with bounding boxes, remove backgrounds, and perform smart cropping.  
- Optical Character Recognition (OCR) is used to extract text from images; different services apply depending on text volume.  
- Document Intelligence is distinct from image analysis and is used for large text documents, supporting document formats and returning structured data like pages, lines, and words.  
- Vision Studio provides an interactive environment to test and customize vision models and see outputs like bounding boxes and JSON data.  
- Face services detect faces, identify characteristics, and perform liveness checks, with controlled access due to potential for misuse.

<img src='.img/2026-01-30-04-14-44.png' width=500>

<img src='.img/2026-01-30-04-15-53.png' width=500>

<img src='.img/2026-01-30-04-16-32.png' width=700> 

<img src='.img/2026-01-30-04-16-55.png' width=700>

<img src='.img/2026-01-30-04-17-18.png' width=700>

**Definitions**  

- **Multimodal**: The ability of a model to work across different input types or modalities (e.g., images, text).  
- **Image Analysis**: AI service that processes images to generate captions, tags, detect objects, remove backgrounds, crop images, and extract text via OCR.  
- **Object Detection**: Identifying objects within an image and providing their locations using bounding boxes.  
- **Optical Character Recognition (OCR)**: Technology to extract text from images.  
- **Document Intelligence**: AI service designed to process large text documents, returning structured data such as pages, lines, and words, supporting document formats.  
- **Face Service**: AI service to detect faces, identify facial characteristics, and perform liveness checks, requiring onboarding due to ethical considerations.

**Key Facts**  

- Image analysis version 4.0 is the latest at the time of recording, offering advanced features like background removal and smart cropping.  
- Object detection returns bounding boxes with coordinates (e.g., cow at 10x20 to 15x25).  
- OCR in image analysis is suitable for small amounts of text; for large documents, Document Intelligence is recommended.  
- Vision Studio allows users to create free resources to experiment with vision capabilities and view JSON outputs for detected objects and extracted text.  
- Face services require onboarding and form submission before use due to potential for abuse.

**Examples**  

- Caption generated for an image: "This is a very poor picture of a cow under a tree drawn by a two-year-old."  
- Tags identified: "cow" and "tree."  
- Object detection providing bounding boxes around a cow and a tree.  
- Removing backgrounds and creating smart cropped thumbnails focusing on key objects.  
- Extracting text from an identification card image with bounding boxes for each text element.  
- Vision Studio demo showing detection of products on shelves, adding dense captions, removing backgrounds, detecting faces, and extracting text.

**Key Takeaways 🎯**  

- Use image analysis for general image understanding tasks like tagging, captioning, object detection, and small-scale OCR.  
- For large text extraction from documents, use Document Intelligence instead of image analysis.  
- Vision Studio is a practical tool to experiment with and customize vision AI models.  
- Face detection services are sensitive and require proper onboarding to prevent misuse.  
- Image analysis 4.0 provides a comprehensive set of features to handle various image processing needs efficiently.

---

## Face

**Timestamp**: 00:47:08 – 00:52:04

**Key Concepts**  

- Face service in computer vision focuses on detecting and analyzing human faces in images.  
- Includes face detection, liveness check, identification, and verification.  
- Detection includes facial landmarks and attributes like head pose, mask presence, glasses, blur, exposure, and occlusion.  
- **Emotional state, gender, and emotions detection are no longer supported due to concerns about abuse.**  
- Supports multiple image formats and size constraints.  
- Custom vision training can be done using Image Analysis v4.0 transformer-based model or older convolutional neural network (CNN) model.  
- Transformer models require fewer images but take longer to train and cost more.  

<img src='.img/2026-01-30-04-19-30.png' width=400>

<img src='.img/2026-01-30-04-20-51.png' width=700>

**Definitions**  

- **Face Detection**: The process of finding faces in an image and analyzing features such as facial landmarks (eyes, nose, ears, lips), head pose, and presence of masks or glasses.  
- **Liveness Check**: A verification step to ensure the face is from a live person and not a 3D print or photo.  
- **Identification**: Matching a detected face against a database of known faces to find a match.  
- **Verification**: Confirming that a detected face matches a specific identity from the database.  
- **Transformer Model**: A newer neural network architecture used in Image Analysis v4.0 that requires fewer training images but longer training time compared to CNN.  
- **Convolutional Neural Network (CNN)**: An older neural network architecture used in the traditional Custom Vision service that requires more images for training.  

**Key Facts**  

- Face detection works on JPEG, PNG, first frame of GIF, bitmap formats.  
- Maximum image size: 6 megabytes.  
- Detectable face size range: minimum 36x36 pixels up to 4096x4096 pixels.  
- Emotional state, gender, and emotion detection are deprecated due to potential abuse.  
- Older Custom Vision CNN model requires ~15 images per category for training.  
- Transformer-based Image Analysis v4.0 can work with as few as 2-5 images per category, though 50-60 images are recommended for best quality.  
- Accuracy example: with 3 training images, CNN model achieved ~56% accuracy, transformer model ~75%.  
- Transformer models provide higher accuracy with less data but take longer and cost more to train.  

**Examples**  

- Creating a database of people’s faces to perform identification and verification.  
- Detecting if a person is wearing a mask or glasses.  
- Checking if a face image is blurred or occluded.  

**Key Takeaways 🎯**  

- Face services are powerful but require onboarding and form submission to access.  
- Liveness checks help prevent spoofing attacks using photos or 3D prints.  
- Privacy and ethical concerns have led to removal of emotional and gender detection features.  
- Image size and face size constraints must be respected for successful detection.  
- Transformer-based models represent the future of custom vision training with better accuracy and less data, but at the cost of longer training times and higher expense.  
- For best results in custom vision, use diverse, high-quality images from multiple angles and conditions.  
- Understanding the trade-offs between CNN and transformer models is important when designing face recognition solutions.  

---

## Natural Language

**Timestamp**: 00:52:04 – 00:59:33

**Key Concepts**  

- Natural language processing (NLP) involves computers interacting with human language by converting text into tokens.  
- Tokens can represent whole words, parts of words, punctuation, emojis, and vary by language.  
- Language models (e.g., GPT-3.5, GPT-4) process tokens as input and output tokens based on probability distributions.  
- Core NLP capabilities include language detection, sentiment analysis, key phrase extraction, entity recognition, summarization, and question answering.  
- Question and answer systems rely on defined knowledge bases and can be integrated with bot services for multi-channel interaction.  
- Language Understanding (LUIS) detects user intent and entities from utterances, useful in automation scenarios.  
- Entities can be detected via machine learning or defined patterns such as regex (e.g., phone numbers).  
- Azure Language Studio offers various NLP features like summarization, transcription, PII extraction, and entity/key phrase extraction.  
- Speech capabilities complement NLP by converting text to speech and speech to text, supporting synthesis and transcription.

<img src='.img/2026-01-30-04-22-42.png' width=300>

<img src='.img/2026-01-30-04-23-17.png' width=700>

<img src='.img/2026-01-30-04-25-45.png' width=500>

<img src='.img/2026-01-30-04-26-46.png' width=400>

<img src='.img/2026-01-30-04-31-14.png' width=700>

<img src='.img/2026-01-30-04-31-25.png' width=700>

<img src='.img/2026-01-30-04-31-34.png' width=700> 

**Definitions**  

- **Token**: A unit of text used by language models, which can be a whole word, part of a word, punctuation, or emoji.  
- **Language Model**: A deep neural network that takes tokens as input and predicts the next most probable token as output.  
- **Knowledge Base**: A collection of questions and answers used to power Q&A systems and bots.  
- **Azure Bot Service**: A framework to develop, publish, and manage bots that interact with knowledge bases across multiple channels (e.g., Teams, web chat, email).  
- **LUIS (Language Understanding Intelligent Service)**: A service that detects the intent and entities from user utterances to enable natural language understanding.  
- **Entity**: A specific piece of information extracted from text, such as a phone number or object referenced in an utterance.

**Key Facts**  

- Tokens for the phrase "AI-900 study cram" were broken down into 8 tokens by OpenAI’s tokenizer (e.g., "AI", "900", "study", "-").  
- Language models handle tens of thousands of possible tokens with probability distributions to generate output.  
- Azure Bot Service supports multiple channels including Teams, web chat, custom web apps, and email.  
- LUIS can be used as both an authoring and prediction resource with an endpoint and key for consumption.  
- Azure Language Studio features include summarization, post-call transcription, PII extraction, key phrase extraction, and linked entity detection.

**Examples**  

- Tokenization example: "AI-900 study cram" split into 8 tokens by OpenAI’s tokenizer.  
- Q&A knowledge base can be created from existing FAQs or chit-chat sources and consumed via Azure Bot Service.  
- LUIS example: Utterance "turn on the lights" is analyzed to detect intent ("turn on") and entity ("lights").  
- Entity detection can use regex patterns, e.g., to identify phone numbers in text.

**Key Takeaways 🎯**  

- Natural language processing relies heavily on tokenization to convert text into a format understandable by models.  
- Language models predict the next token based on probability distributions over a large token set.  
- NLP capabilities are broad and include language detection, sentiment analysis, summarization, entity extraction, and Q&A.  
- Integrating Q&A knowledge bases with bot services enables multi-channel conversational AI applications.  
- LUIS is a powerful tool for intent and entity recognition, critical for automation and conversational interfaces.  
- Azure provides comprehensive NLP and speech services that can be combined depending on application needs.  
- Understanding tokenization and the role of intents/entities is fundamental to building effective natural language solutions.

---

## Speech

**Timestamp**: 00:59:33 – 01:01:13

**Key Concepts**  

- Interaction between text and speech in both directions (text-to-speech and speech-to-text)  
- Speech synthesis with multiple voice options  
- Speech transcription to convert spoken words into text  
- Language recognition within speech input  
- Speech translation supporting multiple languages  
- Translation can output either text or synthesized speech in a target language  
- Translation service also supports text, documents, and custom language models  

<img src='.img/2026-01-30-04-33-00.png' width=400>

**Definitions**  

- **Speech Synthesis**: The process of converting text into spoken voice output using various voices.  
- **Speech Transcription**: Converting spoken language into written text.  
- **Speech Translation**: Translating spoken language from one language to another, either as text or synthesized speech.  
- **Translation Service**: A service that translates text or documents, including support for custom languages or industry-specific terminology.  

**Key Facts**  

- Supports about 60 different languages for speech translation (as of the time of recording).  
- Translation service works with small amounts of text, documents, and custom language models.  

**Examples**  

- Translating spoken language from one language and outputting the translated text in another language.  
- Translating spoken language and outputting the translated speech in a different language.  

**Key Takeaways 🎯**  

- Speech capabilities enable flexible interaction between text and speech in both directions.  
- Multiple voices and language recognition enhance the naturalness and usability of speech synthesis.  
- Speech translation supports a wide range of languages and can output either text or speech.  
- Translation services can be customized for specific industries or specialized vocabularies.

---

## Translation

**Timestamp**: 01:01:13 – 01:02:31

**Key Concepts**  

- Translation service works primarily with text, documents, and custom language sets.  
- Customization allows defining domain- or industry-specific language for more accurate translations.  
- Translation can include filters such as profanity filters or selective translation filters to exclude certain words from being translated.  
- The service supports both text translation and speech translation (speech-to-speech).  
- Useful for handling larger amounts of text requiring translation across languages.



**Definitions**  

- **Translation Service**: A service that translates text or documents from one language to another, with support for custom language dictionaries and filters.  
- **Custom Language Dictionary**: A user-defined set of domain- or industry-specific terms that the translation service uses to improve accuracy.  
- **Profanity Filter**: A filter that removes or censors offensive language during translation.  
- **Selective Translation**: A feature that allows certain words (e.g., brand names like "Azure") to remain untranslated.

**Key Facts**  

- Translation service can handle small amounts of text, documents, and custom language sets.  
- Custom dictionaries can be created for specific industries or domains.  
- Filters can be applied to control translation behavior, including profanity filtering and selective word exclusion.

**Examples**  

- Example of selective translation: The word "Azure" can be set to not translate, even if it might have different meanings in other languages.

**Key Takeaways 🎯**  

- Translation services are flexible and customizable to fit specific industry needs.  
- Filters enhance translation quality and appropriateness by controlling what gets translated.  
- Translation supports both text and speech output, enabling speech-to-speech translation.  
- Custom dictionaries are valuable for maintaining accuracy in specialized vocabularies.

---

## Document intelligence

**Timestamp**: 01:02:31 – 01:06:05

**Key Concepts**  

- Document intelligence involves analyzing various types of documents (text bodies, forms, receipts, invoices) to extract structured data.  
- It evolved from the former "Forms Recognizer" service to emphasize AI capabilities.  
- Uses pre-built AI models to understand semantic meaning in documents, not just OCR text extraction.  
- Supports extraction of key-value pairs and outputs results in JSON format.  
- Works with PDFs and images as input formats.  
- Allows creation of custom models with as few as 5 sample forms using a no-code interface (Document Intelligence Studio).  
- Custom models can be trained to recognize specific form structures and output customized data.  

<img src='.img/2026-01-30-04-36-08.png' width=400>

<img src='.img/2026-01-30-04-36-46.png' width=700>

<img src='.img/2026-01-30-04-36-55.png' width=400>

**Definitions**  

- **Document Intelligence**: An AI-powered service that analyzes documents to extract structured, meaningful data beyond simple text recognition.  
- **Pre-built Models**: Ready-to-use AI models designed to handle common document types like receipts, invoices, identity cards, health insurance cards, and tax forms.  
- **Custom Models**: User-trained AI models created by providing sample documents to tailor extraction to specific form layouts or data needs.  

**Key Facts**  

- Only 5 example forms are needed to create a custom model.  
- Outputs extracted data as JSON.  
- Supports multiple document types including PDFs and images.  
- Document Intelligence Studio provides a no-code environment for model creation.  
- Pre-built models cover a wide range of document types (invoices, receipts, identity cards, health insurance cards, tax forms).  

**Examples**  

- Recognizing and extracting addresses and phone numbers from documents.  
- Using pre-built models to analyze receipts and invoices.  
- Creating a custom model by uploading 5 sample forms to extract specific form fields.  

**Key Takeaways 🎯**  

- Document Intelligence is more than OCR; it understands the semantic meaning of document content.  
- Pre-built models enable quick deployment for common document types without training.  
- Custom models allow flexibility for unique or proprietary form layouts with minimal training data.  
- The no-code Document Intelligence Studio simplifies model creation and deployment.  
- Supports diverse input formats (PDFs, images) making it versatile for many document processing scenarios.  

---

## Knowledge mining

**Timestamp**: 01:06:05 – 01:09:39

**Key Concepts**  

- Knowledge mining is the process of extracting insights and relevant information from large volumes of data.  
- Azure AI Search (formerly Azure Cognitive Search) is the primary service used for knowledge mining in Azure.  
- Data sources can include BLOB storage, data lakes, databases, and table storage.  
- Skill sets define how data is processed, including chunking large documents into smaller parts for analysis.  
- Embedding models convert chunks of data into high-dimensional vector representations capturing semantic meaning.  
- Enrichment processes can include calling vision services to extract text from images within documents.  
- Knowledge mining creates both traditional text indexes and vector indexes to support hybrid search capabilities.  
- Hybrid search combines exact phrase matching and semantic vector search to improve query relevance.  

<img src='.img/2026-01-30-04-39-56.png' width=500>

**Definitions**  

- **Knowledge mining**: The process of extracting meaningful insights from large, unstructured or structured data sets using AI-powered search and enrichment techniques.  
- **Azure AI Search**: An Azure resource/service designed to index and search data using both traditional text and semantic vector methods.  
- **Skill sets**: Configurations that define how data is processed and enriched during indexing, such as chunking and calling AI services.  
- **Chunking**: Breaking large documents into smaller overlapping pieces to enable detailed semantic analysis.  
- **Embedding model**: A model that transforms text chunks into vector representations that capture the semantic meaning of the content.  
- **Hybrid search**: A search approach that combines traditional keyword-based search with vector-based semantic search and re-ranks results accordingly.  

**Key Facts**  

- Azure AI Search is a standalone resource, not part of the multi-service Azure AI accounts.  
- Data can come from various sources including BLOB storage, data lakes, databases, and table storage.  
- Chunking involves breaking data into smaller parts with some overlap to preserve context.  
- The service can enrich data by integrating with other AI services, such as vision for OCR on images in PDFs.  
- Both exact text indexes and vector indexes are created to support hybrid search functionality.  
- Hybrid search improves natural language query results by combining phrase matching and semantic understanding.  

**Examples**  

- A large document about "a dog going to the park" is chunked and embedded into vectors representing its semantic content.  
- A query like "information about puppies going to public green areas" can successfully retrieve the document about a dog going to the park due to semantic vector search.  

**Key Takeaways 🎯**  

- Knowledge mining enables extracting actionable insights from large and complex data sets by combining AI enrichment and advanced search techniques.  
- Azure AI Search is the core Azure service for knowledge mining, supporting both traditional and semantic search indexes.  
- Chunking and embedding are crucial steps to handle large documents and capture their semantic meaning effectively.  
- Hybrid search leverages both exact phrase matching and vector similarity to improve search relevance, especially for natural language queries.  
- Integrating vision and other AI services enriches the searchable content beyond plain text.  
- This approach is foundational for advanced AI scenarios like retrieved augmented generation with generative AI models.

---

## Review

**Timestamp**: 01:09:39 – 01:15:26

**Key Concepts**  

- Artificial Intelligence (AI) mimics human capabilities such as vision, speech, natural language, document intelligence, and knowledge.  
- Machine Learning (ML) is a subset of AI where models are trained on labeled data to perform tasks without explicit programming.  
- Types of ML include supervised learning (regression, classification - binary and multiclass) and unsupervised learning (finding groupings without labels).  
- Deep Learning uses neural networks with layers of neurons, activation functions, weights, and biases to power advanced AI capabilities.  
- Azure AI services include single-purpose services (vision, text, translation) and multi-service endpoints (no free SKU).  
- Authentication for Azure AI endpoints can be done via keys or Entra ID integrated authentication, accessible via REST or SDKs.  
- Responsible AI emphasizes fairness, bias mitigation, reliability, safety, privacy, security, inclusivity, transparency, and accountability.  
- Azure AI Vision services offer image analysis (captions, tags, object detection, background removal, thumbnails, text extraction) and face detection (face recognition, direction, liveness detection).  
- Natural Language services analyze text for language, sentiment, key phrases, entities, summarization, and knowledge base creation.  
- Language Understanding extracts intent and entities from utterances.  
- Speech services provide text-to-speech synthesis, speech-to-text recognition, and translation (including custom domain adaptation).  
- Document Intelligence handles large-scale document analysis with prebuilt and custom form models.  
- Knowledge Mining (Azure AI Search) supports multiple data sources, enriches data via skills, and creates text and vector indexes for querying.  

**Definitions**  

- **Artificial Intelligence (AI)**: Technology that mimics human cognitive functions such as vision, speech, and natural language understanding.  
- **Machine Learning (ML)**: A subset of AI where algorithms learn patterns from labeled data to make predictions or decisions.  
- **Deep Learning**: A type of ML using neural networks with multiple layers to model complex patterns.  
- **Activation Function**: A function in a neural network neuron that determines whether the neuron should activate and pass information forward.  
- **Azure AI Services**: Cloud-based AI capabilities offered by Microsoft, including vision, language, speech, and search services.  
- **Responsible AI**: Principles and practices ensuring AI systems are fair, unbiased, reliable, secure, inclusive, transparent, and accountable.  
- **Knowledge Mining**: The process of extracting useful information from large datasets using AI-powered search and enrichment techniques.  

**Key Facts**  

- Training custom document models can be done with as few as five examples.  
- Azure AI multi-service endpoints do not have a free SKU; single-service endpoints may have free options.  
- Authentication methods include API keys and Entra ID integrated authentication.  
- Azure AI Search was formerly known as Azure Cognitive Search.  
- Responsible AI covers fairness, bias, reliability, safety, privacy, security, inclusivity, transparency, and accountability.  

**Examples**  

- Querying a vector-based hybrid search to find documents about dogs going to parks using natural language variations.  
- Vision service capabilities: generating captions, deep captions, tags, object detection, background removal, smart cropping thumbnails, and text extraction from images.  
- Face detection can identify face direction, ears, verify identity, and detect liveness to prevent spoofing.  
- Natural language processing can detect sentiment, key phrases, entities, summarize text, and build Q&A knowledge bases for bots.  
- Speech services can synthesize speech from text, transcribe speech to text, and translate spoken or written language, including custom domain adaptation.  
- Document Intelligence can analyze receipts and invoices and be trained on custom forms with minimal examples.  
- Knowledge Mining chunks data into smaller pieces, enriches it, and creates text and vector indexes for efficient querying.  

**Key Takeaways 🎯**  

- Understand the broad scope of AI and its subsets: ML and deep learning.  
- Familiarize yourself with Azure AI service types, their capabilities, and authentication methods.  
- Responsible AI is critical—ensure fairness, privacy, transparency, and accountability in AI solutions.  
- Explore and experiment with free SKUs of Azure AI services to gain practical experience.  
- Use Microsoft Learn and sandbox environments to prepare for exams and understand the practical application of AI services.  
- Manage exam time wisely: do not spend too long on any one question, eliminate obviously wrong answers, and revisit difficult questions later.

---

## Exam tips

**Timestamp**: 01:15:26 – 01:16:36

**Key Concepts**  

- Familiarize yourself with the exam format and experience beforehand  
- Manage your time effectively during the exam  
- Use process of elimination on questions you find difficult  
- Make educated guesses when unsure of answers  
- Review your performance by section if you don’t pass and focus on weak areas  

**Definitions**  

- **Educated guess**: Choosing the most logical answer based on your knowledge when you are unsure  

**Key Facts**  

- Pay attention to the number of questions and total time available on the exam  
- You can skip questions and return to them later  
- The exam interface will show your performance by section after completion  
- It is common not to pass on the first attempt  

**Examples**  

- Avoid obviously wrong answers (e.g., “cheese” is humorously noted as never being a correct answer)  
- Use free Microsoft Learn sandboxes to familiarize yourself with the exam environment  

**Key Takeaways 🎯**  

- Practice with Microsoft Learn and sandbox environments to avoid surprises on exam day  
- Don’t spend too long on any one question; move on and come back if needed  
- Eliminate clearly wrong answers to improve chances when guessing  
- The exam is designed to be intuitive, so trust your reasoning for educated guesses  
- If you fail, analyze your weak areas and prepare to retake with improved focus  
- Follow up by watching additional study materials like the generative AI study cram video for further preparation  

---

## Close

**Timestamp**: 01:16:36 – unknown

**Key Concepts**  

- Approach exam questions with educated guesses when unsure  
- The exam services are designed to be intuitive, not confusing  
- Review your results after the exam to identify weak areas  
- Use feedback to improve and retake the exam if necessary  
- Follow-up study resources are recommended (generative AI study cram video)  

**Definitions**  

- None mentioned  

**Key Facts**  

- If you don’t pass the exam on the first try, it’s normal and expected  
- The exam results will show performance by section to guide further study  

**Examples**  

- None mentioned  

**Key Takeaways 🎯**  

- Avoid overthinking or expecting trick answers (e.g., “cheese” is not a valid answer)  
- Make the most logical choice when uncertain  
- Use exam feedback constructively to focus on weaker topics  
- Persistence and targeted study increase chances of success on retakes  
- Watch the recommended generative AI study cram video for additional preparation  
