# Azure AI Fundamentals Certification 2024 (AI-900) - Full Course to PASS the Exam - Exam Notes

**Channel:** freeCodeCamp.org
**Duration:** 4:23:51
**URL:** https://www.youtube.com/watch?v=hHjmr_YOqnU

---

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Contents](#contents)
  * [Introduction to AI-900](#introduction-to-ai-900)
  * [Exam Guide Breakdown](#exam-guide-breakdown)
* [ML Introduction](#ml-introduction)
  * [Layers of Machine Learning](#layers-of-machine-learning)
  * [Key Elements of AI](#key-elements-of-ai)
  * [DataSets](#datasets)
  * [Labeling](#labeling)
  * [Supervised and Unsupervised Reinforcement](#supervised-and-unsupervised-reinforcement)
  * [Netural Networks and Deep Learning](#netural-networks-and-deep-learning)
  * [GPU](#gpu)
  * [CUDA](#cuda)
  * [Simple ML Pipeline](#simple-ml-pipeline)
  * [Forecast vs Prediction](#forecast-vs-prediction)
  * [Metrics](#metrics)
  * [Juypter Notebooks](#juypter-notebooks)
  * [Regression](#regression)
  * [Classification](#classification)
  * [Clustering](#clustering)
  * [Confusion Matrix](#confusion-matrix)
* [Common AI Workloads](#common-ai-workloads)
  * [Anomaly Detection AI](#anomaly-detection-ai)
  * [Computer Vision AI](#computer-vision-ai)
  * [Natural Language Processing AI](#natural-language-processing-ai)
  * [Conversational AI](#conversational-ai)
* [Responsible AI](#responsible-ai)
  * [Responsible AI](#responsible-ai-1)
  * [Fairness](#fairness)
  * [Reliability and safety](#reliability-and-safety)
  * [Privacy and security](#privacy-and-security)
  * [Inclusiveness](#inclusiveness)
  * [Transparency](#transparency)
  * [Accountability](#accountability)
  * [Guidelines for Human AI Interaction](#guidelines-for-human-ai-interaction)
  * [Follow Along Guidelines for Human AI Interaction](#follow-along-guidelines-for-human-ai-interaction)
* [Congitive Services](#congitive-services)
  * [Azure Cognitive Services](#azure-cognitive-services)
  * [Congitive API Key and Endpoint](#congitive-api-key-and-endpoint)
  * [Knowledge Mining](#knowledge-mining)
  * [Face Service](#face-service)
  * [Speech and Translate Service](#speech-and-translate-service)
  * [Text Analytics](#text-analytics)
  * [OCR Computer Vision](#ocr-computer-vision)
  * [Form Recognizer](#form-recognizer)
  * [Form Recognizer Custom Models](#form-recognizer-custom-models)
  * [Form Recognizer Prebuilt Models](#form-recognizer-prebuilt-models)
  * [LUIS](#luis)
  * [QnA Maker](#qna-maker)
  * [Azure Bot Service](#azure-bot-service)
* [ML Studio](#ml-studio)
  * [Azure Machine Learning Service](#azure-machine-learning-service)
  * [Studio Overview](#studio-overview)
  * [Studio Compute](#studio-compute)
  * [Studio Data Labeling](#studio-data-labeling)
  * [Data Stores](#data-stores)
  * [Datasets](#datasets-1)
  * [Experiments](#experiments)
  * [Pipelines](#pipelines)
  * [ML Designer](#ml-designer)
  * [Model Registry](#model-registry)
  * [Endpoints](#endpoints)
  * [Notebooks](#notebooks)
* [AutoML](#automl)
  * [Introduction to AutoML](#introduction-to-automl)
  * [Data Guard Rails](#data-guard-rails)
  * [Automatic Featurization](#automatic-featurization)
  * [Model Selection](#model-selection)
  * [Explanation](#explanation)
  * [Primary Metrics](#primary-metrics)
  * [Validation Type](#validation-type)
* [Custom Vision](#custom-vision)
  * [Introduction to Custom Vision](#introduction-to-custom-vision)
  * [Project Types and Domains](#project-types-and-domains)
  * [Custom Vision Features](#custom-vision-features)
* [Features of generative AI solutions](#features-of-generative-ai-solutions)
  * [AI vs Generative AI](#ai-vs-generative-ai)
  * [What is a LLM Large Language Model](#what-is-a-llm-large-language-model)
  * [Transformer models](#transformer-models)
  * [Tokenization](#tokenization)
  * [Embeddings](#embeddings)
  * [Positional encoding](#positional-encoding)
  * [Attention](#attention)
* [Capabilities of Azure OpenAI Service](#capabilities-of-azure-openai-service)
  * [Introduction to Azure OpenAI Service](#introduction-to-azure-openai-service)
  * [Azure OpenAI Studio](#azure-openai-studio)
  * [Azure OpenAI service pricing](#azure-openai-service-pricing)
  * [What are Copilots](#what-are-copilots)
  * [Prompt engineering](#prompt-engineering)
  * [Grounding](#grounding)
  * [Copilot demo](#copilot-demo)
* [Follow Alongs](#follow-alongs)
  * [Setup](#setup)
  * [Computer Vision](#computer-vision)
  * [Custom Vision Classification](#custom-vision-classification)
  * [Custom Vision Object Detection](#custom-vision-object-detection)
  * [Face Service](#face-service-1)
  * [Form Recognizer](#form-recognizer-1)
  * [OCR](#ocr)
  * [Text Analysis](#text-analysis)
  * [QnAMaker](#qnamaker)
  * [LUIS](#luis-1)
  * [AutoML](#automl-1)
  * [Designer](#designer)
  * [MNIST](#mnist)
  * [Data Labeling](#data-labeling)
  * [Clean up](#clean-up)

## Contents

### Introduction to AI-900

**Timestamp**: 00:00:00 – 00:08:18

**Key Concepts**  
- AI-900 is the Azure AI Fundamentals certification exam.  
- Designed for those pursuing roles like AI Engineer or Data Scientist.  
- Covers understanding and defining Azure AI services: Cognitive Services, Azure Applied AI Services.  
- Includes AI concepts, knowledge mining, responsible AI, basics of ML pipelines, classical ML models, AutoML, generative AI workloads, and Azure AI Studio.  
- AI-900 is considered an entry-level, foundational exam, often a stepping stone to Azure AI Engineer or Data Scientist certifications.  
- Suggested learning paths:  
  - Ideally take AZ-900 (Azure Fundamentals) first for foundational Azure knowledge.  
  - DP-900 (Azure Data Fundamentals) is optional but commonly paired with AI-900 for data foundation.  
- AI-900 exam domains include AI workloads, machine learning principles, computer vision, natural language processing, and generative AI workloads.  
- Exam is descriptive in nature, focusing on understanding rather than deep technical implementation.  

**Definitions**  
- **AI-900**: The Microsoft Azure AI Fundamentals certification exam code.  
- **Cognitive Services**: Pre-built AI services in Azure for vision, speech, language, and decision-making.  
- **Azure Applied AI Services**: Azure services that apply AI capabilities to solve business problems.  
- **Responsible AI**: Ethical and responsible use of AI technologies.  
- **AutoML**: Automated Machine Learning to simplify model creation.  
- **Generative AI Workloads**: AI tasks that generate new content, recently added to the AI-900 syllabus.  
- **Proctored Exam**: An exam monitored by a supervisor either in-person or online to ensure exam integrity.  
- **Seat Time**: Total time allocated for the exam session including instructions, NDA, exam, and feedback.  

**Key Facts**  
- AI-900 exam duration: 60 minutes actual exam time; 90 minutes seat time total.  
- Passing score: Approximately 700 out of 1000 (around 70%), but scaled scoring means 70% does not guarantee a pass.  
- Number of questions: 37 to 47 questions.  
- Question types: Multiple choice, multiple answer, drag and drop, hot area. No case studies.  
- No penalty for wrong answers.  
- Study time recommendations:  
  - Beginners (new to AI/ML and Azure): 15-30 hours.  
  - Intermediate (have AZ-900 or DP-900): 8-10 hours.  
  - Experienced (1+ year Azure or other cloud experience): ~5 hours or less.  
- Recommended study schedule: 30 minutes to 1 hour daily for 14 days.  
- Exam domains and their weightings:  
  - Describe AI workloads and considerations: 15-20%  
  - Describe fundamental principles of machine learning on Azure: 20-25%  
  - Describe features of computer vision workloads on Azure: 15-20%  
  - Describe features of natural language processing workloads on Azure: 15-20%  
  - Describe features of generative AI workloads on Azure: 15-20%  
- Certification validity: Does not expire as long as technology remains relevant.  
- Exam can be taken online (proctored) or in-person at test centers (Certiport, Pearson VUE, or local centers).  
- Practice exams strongly recommended; Azure exams are harder than some other cloud providers’ foundational exams.  

**Examples**  
- None specifically mentioned in this section.  

**Key Takeaways 🎯**  
- AI-900 is a foundational exam, good for beginners and those new to AI/ML on Azure.  
- Prior knowledge of Azure fundamentals (AZ-900) is highly recommended but not mandatory.  
- Combining AI-900 with DP-900 is a common and effective learning path.  
- Focus on understanding and describing AI concepts rather than deep technical skills.  
- Use a balanced study approach: watch lectures, do labs (if possible), and take practice exams.  
- Be mindful of potential small costs when running Azure AI Studio or ML instances during labs.  
- Practice exams are important to simulate real exam conditions and improve passing chances.  
- The exam is relatively short (60 minutes) with a moderate number of questions; time management is key.  
- Certification does not expire, so it’s a good long-term credential.  
- Choose exam delivery method (online vs in-person) based on personal preference and environment control.

---

### Exam Guide Breakdown

**Timestamp**: 00:08:18 – 00:12:51

**Key Concepts**  
- Overview of the official AI-900 exam outline and where to find it on Microsoft’s website  
- Frequent minor updates to Azure courses that do not significantly affect exam content  
- Major revisions lead to new exam codes (e.g., AI-100 → AI-102)  
- AI workloads and considerations: content moderation, personalization, computer vision, natural language processing, knowledge mining, document intelligence, generative AI  
- Responsible AI principles: Microsoft’s six key principles embedded across AI services  
- Fundamental machine learning principles on Azure: regression, classification, clustering, deep learning  
- Core ML concepts: features and labels, training and validation datasets  
- Automated machine learning (AutoML) capabilities and Azure ML services for model management and deployment  
- Computer Vision workloads and related Azure services (Image Classification, Object Detection, OCR, Facial Detection/Analysis, Video Indexer)  
- Natural Language Processing (NLP) workloads and Azure AI services (Language Service, Speech Service, Translator Service)  
- Generative AI workloads: features, scenarios, responsible AI considerations, Azure OpenAI Service capabilities (natural language, code, image generation)

**Definitions**  
- **Seat Time**: Total allocated time for the exam including instructions, NDA acceptance, exam completion, and feedback (90 minutes)  
- **AI Workloads**: Different categories of AI tasks such as content moderation, personalization, computer vision, NLP, etc.  
- **Responsible AI**: Microsoft’s framework of six principles to ensure ethical AI use  
- **AutoML (Automated Machine Learning)**: Tools that simplify model building and selection, leveraging Azure’s compute and data services  
- **Features and Labels**: Elements of datasets used in machine learning where features are input variables and labels are the output or target variables  

**Key Facts**  
- Exam duration: 60 minutes for 40-60 questions (approx. 1 minute per question)  
- Seat time: 90 minutes total including pre- and post-exam activities  
- No penalty for wrong answers  
- Microsoft fundamental certifications (like AI-900) do not expire as long as the technology remains relevant  
- Azure updates courses about 5 times a year, mostly minor changes  
- Major exam updates result in new exam codes (e.g., AI-901, AI-902)  
- Recent update added generative AI workloads and made minor name changes/removals  

**Examples**  
- Content moderation: filtering harmful user-generated content  
- Personalization: tailoring content based on user behavior  
- Computer vision tasks: image/video pattern recognition, facial detection  
- NLP tasks: key phrase extraction, entity recognition, sentiment analysis, speech recognition, translation  
- Azure AI services evolution: from separate services (e.g., Text Analytics, LUIS) to umbrella Azure AI services  

**Key Takeaways 🎯**  
- Always refer to the official Microsoft AI-900 exam outline for the most current skills measured  
- Minor Azure updates do not require new study materials; major exam revisions do  
- Understand broad AI workload categories and their purposes rather than deep service-level details  
- Know Microsoft’s six Responsible AI principles as they apply across AI services  
- Be familiar with fundamental ML concepts and how Azure supports ML lifecycle (AutoML, datasets, model deployment)  
- Recognize key Azure AI services and their roles in computer vision, NLP, and generative AI workloads  
- Focus on concepts and definitions rather than hands-on service usage for the exam  
- Remember no penalty for guessing; manage time to allow about one minute per question

## ML Introduction

---

### Layers of Machine Learning

**Timestamp**: 00:12:51 – 00:13:59

**Key Concepts**  
- AI is the broad concept of machines performing tasks that mimic human behavior.  
- Machine Learning (ML) is a subset of AI where machines improve at tasks without explicit programming.  
- Deep Learning is a further subset of ML using artificial neural networks inspired by the human brain to solve complex problems.  
- Data scientists build ML and deep learning models using multidisciplinary skills.

**Definitions**  
- **Artificial Intelligence (AI)**: Machines performing jobs that mimic human behavior, without specifying how.  
- **Machine Learning (ML)**: Machines that get better at a task without explicit programming.  
- **Deep Learning**: Machines using artificial neural networks inspired by the human brain to solve complex problems.  
- **Data Scientist**: A professional with skills in math, statistics, predictive modeling, and machine learning who builds ML and deep learning models.

**Key Facts**  
- AI is the outcome or goal; it can be achieved using ML, deep learning, a combination of both, or even simple if-else logic.  
- Deep learning models are inspired by the structure and function of the human brain.

**Examples**  
- None specifically mentioned in this section.

**Key Takeaways 🎯**  
- Understand the hierarchical relationship: AI > Machine Learning > Deep Learning.  
- AI describes the goal (machines mimicking humans), ML and deep learning describe methods to achieve that.  
- Data scientists are the key professionals who develop ML and deep learning models.  
- AI does not necessarily require ML or deep learning; simpler approaches can also be AI.

---

### Key Elements of AI

**Timestamp**: 00:13:59 – 00:14:57

**Key Concepts**  
- AI is software that imitates human behaviors and capabilities.  
- AI systems are composed of several key elements that enable human-like functions.  
- Machine learning is the foundational element of AI, enabling systems to learn and predict like humans.  
- Other key AI elements include anomaly detection, computer vision, natural language processing (NLP), and conversational AI.

**Definitions**  
- **Artificial Intelligence (AI)**: Software that imitates human behaviors and capabilities.  
- **Machine Learning (ML)**: The foundation of AI systems that can learn from data and make predictions similar to humans.  
- **Anomaly Detection**: The ability to detect outliers or unusual data points, mimicking human recognition of things out of place.  
- **Computer Vision**: The capability of AI to "see" and interpret visual information like a human.  
- **Natural Language Processing (NLP)**: The ability to process and understand human language and context.  
- **Conversational AI**: AI systems that can hold conversations with humans.

**Key Facts**  
- The list of AI key elements referenced is based on Microsoft Azure’s definition, which may differ from other global definitions.  
- This Azure-based definition is important for exam purposes as it has been noted as a likely exam question topic.

**Examples**  
- None specifically mentioned in this section.

**Key Takeaways 🎯**  
- Remember the key elements of AI as defined by Microsoft Azure for exam questions: machine learning, anomaly detection, computer vision, NLP, and conversational AI.  
- Understand that AI is the outcome or software that imitates human capabilities, often built on machine learning or deep learning techniques.  
- Be aware that definitions can vary globally, but for the exam, Azure’s definitions should be prioritized.

---

### DataSets

**Timestamp**: 00:14:57 – 00:16:37

**Key Concepts**  
- A data set is a logical grouping of closely related data units sharing the same data structure.  
- Publicly available data sets are commonly used in statistics, data analytics, and machine learning.  
- Data labeling is essential for supervised machine learning to create meaningful training data.  
- Azure Machine Learning Studio supports data labeling and can export labels in COCO format.  
- Azure ML pipelines provide access to common open data sets like MNIST and COCO.

**Definitions**  
- **Data Set**: A logical grouping of units of data that are closely related or share the same data structure.  
- **COCO Dataset**: A dataset containing common images with JSON files in COCO format, used for object segmentation and recognition tasks.  
- **MNIST Database**: A dataset of handwritten digit images used to test and train image processing and computer vision ML models.  
- **Data Labeling**: The process of identifying raw data (images, text, videos) and adding meaningful labels to provide context for machine learning models.  

**Key Facts**  
- MNIST is widely used for handwriting recognition tasks in computer vision.  
- COCO dataset includes object segmentations, recognition in context, and superpixel segmentation with many images and objects.  
- Azure ML Studio’s data labeling service can export labeled data in COCO format.  
- Azure ML pipelines include open datasets such as MNIST and COCO for easy use in model training.

**Examples**  
- MNIST: Handwritten digits dataset for classifying and clustering image data.  
- COCO: Common Objects in Context dataset with images and JSON annotations for object detection and segmentation.

**Key Takeaways 🎯**  
- Know the definitions and purposes of MNIST and COCO datasets as common examples in ML.  
- Understand that Azure ML Studio supports data labeling and exports in COCO format—this is a potential exam point.  
- Remember that data labeling is crucial for supervised learning and typically done by humans, but Azure offers ML-assisted labeling.  
- Be aware that Azure provides open datasets within its ML pipelines, simplifying access to standard datasets.

---

### Labeling

**Timestamp**: 00:16:37 – 00:17:43

**Key Concepts**  
- Data labeling is the process of identifying raw data and adding meaningful labels to provide context for machine learning models.  
- Labeling is essential for supervised machine learning as it produces the training data.  
- Labels are generally applied by humans but can be assisted or generated by machine learning in some cases.  
- The concept of "ground truth" refers to a properly labeled dataset used as an objective standard to train and evaluate models.  

**Definitions**  
- **Data Labeling**: The process of assigning one or more informative labels to raw data (images, text, videos) to enable machine learning models to learn from it.  
- **Ground Truth**: A correctly labeled dataset that serves as the objective standard for training and assessing machine learning models.  

**Key Facts**  
- Azure Machine Learning Studio includes a data labeling service that can export labeled data in COCO format.  
- Azure’s data labeling service supports ML-assisted labeling, reducing the need for fully manual labeling.  
- Ground truth accuracy directly impacts the accuracy of the trained model.  
- The term "ground truth" is more commonly used in AWS documentation than in Azure’s.  

**Examples**  
- Azure’s data labeling service exporting data in COCO format.  
- ML-assisted labeling in Azure’s data labeling service.  

**Key Takeaways 🎯**  
- Understand that labeling is a prerequisite for supervised learning and typically involves human input, but can be assisted by ML tools.  
- Know the importance of ground truth datasets as the benchmark for model training and evaluation.  
- Be familiar with COCO format as a common export format for labeled data in Azure ML workflows.  
- Remember that Azure ML labeling tools may not explicitly use the term "ground truth," but the concept is critical.

---

### Supervised and Unsupervised Reinforcement

**Timestamp**: 00:17:43 – 00:19:09

**Key Concepts**  
- Comparison of supervised, unsupervised, and reinforcement learning  
- Supervised learning: labeled data, task-driven, prediction-focused  
- Unsupervised learning: unlabeled data, data-driven, pattern recognition  
- Reinforcement learning: no initial data, environment-driven, decision-making through trial and error  
- Classical machine learning mainly refers to supervised and unsupervised learning relying on statistics and math  

**Definitions**  
- **Supervised Learning**: Machine learning where the training data is labeled, and the goal is to predict specific outcomes such as classification or regression.  
- **Unsupervised Learning**: Machine learning where the data is unlabeled; the model identifies patterns or structures such as clusters or associations without precise outcome requirements.  
- **Reinforcement Learning**: Learning method where an agent interacts with an environment, generating data through attempts to achieve a goal, used in decision-driven tasks like game AI or robot navigation.  

**Key Facts**  
- Supervised learning is task-driven and used when labels are known and precise outcomes are needed.  
- Unsupervised learning is data-driven, used when labels are unknown and the goal is to understand data structure (e.g., clustering, dimensionality reduction, association).  
- Reinforcement learning involves no initial data; the model learns by making decisions and receiving feedback from the environment.  
- Supervised and unsupervised learning are considered classical machine learning due to their reliance on statistics and math.  

**Examples**  
- Reinforcement learning example: AI in video games that can play itself.  
- Unsupervised learning techniques include clustering and dimensionality reduction (reducing data dimensions to simplify analysis).  

**Key Takeaways 🎯**  
- Understand the fundamental differences between supervised, unsupervised, and reinforcement learning in terms of data labeling, goals, and application.  
- Remember supervised learning requires labeled data and precise predictions; unsupervised learning works with unlabeled data to find patterns; reinforcement learning learns through interaction without pre-existing data.  
- Reinforcement learning is decision-driven and commonly applied in game AI and robotics.  
- Classical machine learning mainly refers to supervised and unsupervised learning methods.

---

### Netural Networks and Deep Learning

**Timestamp**: 00:19:09 – 00:21:25

**Key Concepts**  
- Neural networks mimic the brain using interconnected neurons (nodes) organized in layers.  
- Connections between neurons are weighted, influencing data flow and learning.  
- Neural networks have an input layer, one or more hidden layers, and an output layer.  
- Deep learning refers to neural networks with three or more hidden layers, making internal processes difficult to interpret.  
- Forward feed (or forward pass) describes data moving through the network without cycles.  
- Backpropagation is the process of moving backward through the network to adjust weights based on error.  
- Loss function calculates the error by comparing predicted output to ground truth.  
- Activation functions are algorithms applied to nodes in hidden layers that influence output and learning behavior.  
- Dense layers increase the number of nodes; sparse layers decrease nodes, often used for dimensionality reduction.

**Definitions**  
- **Neural Network (NN)**: A computational model inspired by the brain, consisting of neurons (nodes) connected by weighted links, organized in layers.  
- **Deep Learning**: Neural networks with three or more hidden layers, enabling complex pattern recognition but reducing interpretability.  
- **Forward Feed Neural Network (FNN)**: A neural network where connections move forward without cycles, processing input to output in one direction.  
- **Backpropagation**: A learning algorithm that adjusts weights by propagating error backward through the network to improve accuracy.  
- **Loss Function**: A function that measures the difference between the predicted output and the actual output (ground truth), guiding learning.  
- **Activation Function**: An algorithm applied to nodes in hidden layers that affects the output and learning process.  
- **Dense Layer**: A layer with an increased number of nodes compared to the previous layer.  
- **Sparse Layer**: A layer with fewer nodes than the previous layer, often used for dimensionality reduction.

**Key Facts**  
- Neural network connections are weighted, which is crucial for learning and output determination.  
- Deep learning networks are not human-readable internally due to complexity.  
- Forward feed networks do not have cycles; data flows in one direction.  
- Backpropagation relies on the loss function to calculate error and adjust weights accordingly.  
- Dimensionality reduction occurs when moving from a dense layer to a sparse layer, reducing the number of nodes/dimensions.

**Examples**  
- None explicitly mentioned for neural networks or deep learning in this segment.

**Key Takeaways 🎯**  
- Remember that neural networks are structured in layers with weighted connections—this weighting is fundamental.  
- Deep learning means having 3+ hidden layers, making the network’s internal workings complex and less interpretable.  
- Understand forward feed as the data moving forward through the network and backpropagation as the learning step moving backward to adjust weights.  
- The loss function is essential for measuring performance and guiding learning via backpropagation.  
- Activation functions influence how nodes process inputs and contribute to learning.  
- Recognize the significance of dense vs. sparse layers and their role in dimensionality reduction.  
- Be familiar with abbreviations: NN = Neural Network, FNN = Forward Feed Neural Network.

---

### GPU

**Timestamp**: 00:21:25 – 00:22:21

**Key Concepts**  
- GPUs are specialized processors designed for fast, concurrent rendering of high-resolution images and videos.  
- GPUs perform parallel operations on multiple data sets simultaneously.  
- GPUs are widely used beyond graphics, including machine learning and scientific computation.  
- GPUs have thousands of cores compared to CPUs which have fewer (4 to 16 cores).  
- The parallel and repetitive nature of neural network computations makes GPUs ideal for deep learning tasks.

**Definitions**  
- **GPU (Graphics Processing Unit)**: A processor designed to quickly render images and videos concurrently by performing parallel operations on multiple data sets.  
- **CPU (Central Processing Unit)**: A processor with fewer cores (typically 4 to 16) designed for general-purpose computing.  

**Key Facts**  
- CPUs typically have 4 to 16 cores.  
- GPUs can have thousands of cores; for example, 48 GPUs combined could have around 40,000 cores.  
- The high number of cores allows GPUs to efficiently handle repetitive and highly parallel tasks.  

**Examples**  
- Neural networks benefit from GPUs because they involve many repetitive tasks spread across many nodes.  
- Other tasks suited for GPUs include rendering graphics, cryptocurrency mining, deep learning, and machine learning.

**Key Takeaways 🎯**  
- Remember that GPUs excel at parallel processing due to their thousands of cores, making them essential for machine learning and neural networks.  
- Understand the difference in core count and purpose between CPUs and GPUs.  
- Recognize that GPUs are not just for graphics but are critical in scientific and AI computations due to their architecture.  
- The repetitive and parallel nature of neural network computations aligns well with GPU capabilities, improving training speed and efficiency.

---

### CUDA

**Timestamp**: 00:22:21 – 00:23:29

**Key Concepts**  
- CUDA is a parallel computing platform and API developed by NVIDIA.  
- It enables developers to use CUDA-enabled GPUs for general-purpose computing (GPGPU).  
- NVIDIA Deep Learning SDK integrates with major deep learning frameworks and includes CUDA libraries.  
- CUDA Deep Neural Network Library (cuDNN) provides optimized implementations for deep learning routines.  

**Definitions**  
- **NVIDIA**: A company that manufactures GPUs for gaming and professional markets.  
- **CUDA (Compute Unified Device Architecture)**: A parallel computing platform and API by NVIDIA for leveraging GPUs beyond graphics tasks.  
- **GPGPU (General-Purpose computing on Graphics Processing Units)**: Using GPUs to perform computation traditionally handled by CPUs.  
- **cuDNN (CUDA Deep Neural Network Library)**: A library offering highly tuned implementations of standard deep learning operations like convolution, pooling, normalization, and activation layers.  

**Key Facts**  
- GPUs can have thousands of cores (e.g., 48 GPUs could total ~40,000 cores).  
- GPUs excel at repetitive, highly parallel tasks such as rendering graphics, cryptocurrency mining, deep learning, and machine learning.  
- cuDNN supports key deep learning operations such as forward and backward convolution, which are essential for computer vision tasks.  
- Although CUDA is important for understanding GPU acceleration in AI, the Azure AI-900 certification does not focus on CUDA specifics.  

**Examples**  
- Neural networks benefit from CUDA because they involve many repetitive tasks spread across many nodes, which can be parallelized across thousands of GPU cores.  
- cuDNN’s optimized routines are used for convolutional neural networks in computer vision.  

**Key Takeaways 🎯**  
- Understand that CUDA enables GPUs to be used for general-purpose parallel computing, which is critical for accelerating AI and machine learning workloads.  
- Remember that NVIDIA is the key company behind CUDA and GPU hardware widely used in AI.  
- Know that cuDNN is a specialized CUDA library that optimizes deep learning operations, especially convolutional layers.  
- For the AI-900 exam, focus on the role of GPUs and CUDA in accelerating AI rather than the technical details of CUDA itself.

---

### Simple ML Pipeline

**Timestamp**: 00:23:29 – 00:25:39

**Key Concepts**  
- Machine learning pipeline stages include data labeling, feature engineering, training, hyperparameter tuning, serving/deployment, and inference.  
- Data labeling and feature engineering are part of pre-processing to prepare data for training.  
- ML models require numerical data inputs, so feature engineering transforms raw data into numerical features.  
- Training involves multiple iterations where the model learns and improves.  
- Hyperparameter tuning optimizes model parameters automatically, especially important in deep learning where manual tuning is impractical.  
- Serving (or deploying) makes the ML model accessible, often via hosting on virtual machines or containers.  
- Inference is the process of making predictions by sending data to the deployed model and receiving results.  
- Inference can be done in real-time (single item prediction) or batch mode (multiple data points at once).  

**Definitions**  
- **Data Labeling**: Assigning labels to data to enable supervised learning by providing examples for the model to learn from.  
- **Feature Engineering**: The process of converting raw data into numerical features that ML models can understand and use.  
- **Training**: The iterative process where the ML model learns patterns from labeled data.  
- **Hyperparameter Tuning**: Automated process to find the best model parameters to improve performance, critical in deep learning.  
- **Serving/Deployment**: Making the trained ML model accessible for use, typically by hosting it on cloud services like Azure Kubernetes Service or Azure Container Instance.  
- **Inference**: The act of using the deployed model to make predictions on new data inputs.  

**Key Facts**  
- ML models only work with numerical data, necessitating feature engineering.  
- Hyperparameter tuning is essential in deep learning because manual tuning is not feasible.  
- Azure ML deployment options include Azure Kubernetes Service (AKS) and Azure Container Instance (ACI).  
- Inference can be real-time (fast, single prediction) or batch (slower, multiple predictions).  

**Examples**  
- None explicitly mentioned; general references to hosting models on Azure Kubernetes Service or Azure Container Instance for serving.  

**Key Takeaways 🎯**  
- Understand the stages of a simple ML pipeline and their purposes, especially pre-processing (labeling and feature engineering), training, tuning, serving, and inference.  
- Remember that ML models require numerical input, so feature engineering is critical.  
- Know that hyperparameter tuning automates optimization and is indispensable for deep learning models.  
- Be aware of deployment concepts: serving the model means making it accessible, not just the training step.  
- Differentiate between real-time and batch inference in terms of prediction speed and volume.  
- Familiarize yourself with Azure ML deployment options (AKS and ACI) as common cloud hosting solutions.

---

### Forecast vs Prediction

**Timestamp**: 00:25:39 – 00:26:24

**Key Concepts**  
- Forecasting involves making predictions using relevant data and is useful for analyzing trends.  
- Prediction (in this context) refers to making predictions without relevant data, often relying on statistics and decision theory.  
- Forecasting is not guessing; prediction in this sense involves more uncertainty and guessing.  
- Forecasting infers outcomes based on existing data; prediction may involve inventing or assuming data to estimate outcomes.  
- These terms are broad and used to provide a high-level understanding of different approaches to estimating future events.

**Definitions**  
- **Forecasting**: Making a prediction with relevant data, primarily used for trend analysis; it is data-driven and not guesswork.  
- **Prediction**: Making a prediction without relevant data, often involving guessing and using decision theory/statistics to estimate future outcomes.

**Key Facts**  
- Forecasting uses relevant data to infer outcomes (e.g., trend analysis).  
- Prediction may involve limited or no relevant data, requiring assumptions or invented data.  
- Forecasting is more data-driven; prediction is more speculative.  
- Decision theory is associated with prediction when data is scarce.

**Examples**  
- None explicitly mentioned.

**Key Takeaways 🎯**  
- Understand the distinction between forecasting (data-driven, trend analysis) and prediction (less data, more guessing).  
- Remember forecasting is not guessing; it relies on relevant data.  
- Prediction in this context is broader and involves decision theory when data is limited.  
- These are broad terms to help conceptualize different approaches to estimating future outcomes in machine learning and analytics.

---

### Metrics

**Timestamp**: 00:26:24 – 00:27:58

**Key Concepts**  
- Performance or evaluation metrics are used to assess how well machine learning (ML) algorithms perform.  
- Different problem types require different evaluation metrics.  
- Metrics help determine if an ML model is working as intended.  
- There are two categories of evaluation metrics: internal and external.

**Definitions**  
- **Performance/Evaluation Metrics**: Measures used to evaluate the effectiveness of ML models’ predictions.  
- **Internal Evaluation Metrics**: Metrics used to evaluate the internals of an ML model (e.g., accuracy, precision, recall, F1 score).  
- **External Evaluation Metrics**: Metrics used to evaluate the final prediction output of an ML model.

**Key Facts**  
- Classification metrics include: accuracy, precision, recall, F1 score, ROC, and AUC.  
- Regression metrics include: MSC (likely meant MSE - Mean Squared Error), RMSCE (likely RMSE - Root Mean Squared Error), MAE (Mean Absolute Error).  
- Ranking metrics include: MMR, DCG, NDCG.  
- Statistical metrics include: correlation.  
- Computer vision metrics include: PSNR, SSIM, IOU.  
- NLP metrics include: perplexity, BLEU, METEOR, ROUGE.  
- Deep learning metrics include: inception score, inception distance.  
- The “famous 4” internal metrics often used across models are accuracy, precision, recall, and F1 score.

**Examples**  
- None specifically detailed; only metric names and categories were listed.

**Key Takeaways 🎯**  
- Focus on knowing classification metrics well (accuracy, precision, recall, F1 score, ROC, AUC).  
- Understand that different ML problems require different metrics; no one-size-fits-all metric.  
- Remember the distinction between internal and external evaluation metrics.  
- Don’t worry about memorizing all metrics now; exposure is key, and important metrics will be revisited.

---

### Juypter Notebooks

**Timestamp**: 00:27:58 – 00:29:13

**Key Concepts**  
- Jupyter Notebooks are web-based applications for authoring documents that combine live code, narrative text, equations, and visualizations.  
- Jupyter Notebooks originated from IPython, which is now the Python kernel used to execute code within the notebooks.  
- Jupyter Notebooks have evolved into JupyterLabs, a next-generation web-based user interface with more flexible and powerful features.  
- JupyterLabs includes notebooks, terminal, text editor, file browser, and rich outputs.  
- Classic Jupyter Notebooks (also called Jupyter Classic) are legacy interfaces still accessible but largely replaced by JupyterLabs.  
- Jupyter Notebooks are integral tools in data science and machine learning workflows and are commonly integrated into cloud ML platforms.

**Definitions**  
- **Jupyter Notebooks**: Web-based interactive computing environments that allow users to create and share documents containing live code, equations, visualizations, and narrative text.  
- **IPython**: The original interactive Python shell that became the kernel powering Jupyter Notebooks.  
- **JupyterLabs**: The next-generation web-based user interface for Jupyter, offering a more flexible and powerful environment than classic notebooks.

**Key Facts**  
- Jupyter Notebooks were extracted from IPython and now use IPython as their Python execution kernel.  
- JupyterLabs is intended to eventually replace the classic Jupyter Notebook interface.  
- Jupyter Notebooks are always integrated into cloud service providers’ machine learning tools.

**Examples**  
- None mentioned explicitly.

**Key Takeaways 🎯**  
- Understand that Jupyter Notebooks combine code, text, and visualizations in one document, making them essential for data science and ML projects.  
- Remember the evolution: IPython → Jupyter Notebooks → JupyterLabs (current standard).  
- Know the components of JupyterLabs (notebooks, terminal, text editor, file browser, rich outputs).  
- Be aware that while classic notebooks still exist, JupyterLabs is the preferred and future-proof interface.  
- Recognize the importance of Jupyter Notebooks in cloud-based ML environments.

---

### Regression

**Timestamp**: 00:29:13 – 00:30:50

**Key Concepts**  
- Regression is the process of finding a function to model a labeled data set.  
- It is a supervised learning technique used for predicting continuous variables.  
- The goal is to predict the value of a continuous variable in the future (not necessarily time-based).  
- Data points (vectors) can be plotted in multiple dimensions, not limited to just X and Y axes.  
- A regression line is fitted through the data points to help predict values.  
- The error is the distance between a data point and the regression line.  
- Different regression algorithms use this error to improve predictions.  
- Common error metrics include Mean Squared Error (MSE), Root Mean Squared Error (RMSE), and Mean Absolute Error (MAE).

**Definitions**  
- **Regression**: The process of finding a function to model a labeled data set for supervised learning aimed at predicting continuous variables.  
- **Error**: The distance of a data point (vector) from the regression line, used to evaluate prediction accuracy.  
- **Mean Squared Error (MSE)**: A metric measuring the average squared difference between predicted and actual values.  
- **Root Mean Squared Error (RMSE)**: The square root of MSE, representing error in the same units as the predicted variable.  
- **Mean Absolute Error (MAE)**: The average of absolute differences between predicted and actual values.

**Key Facts**  
- Regression deals with labeled data sets and continuous output variables.  
- The regression line represents the best fit through the data points to minimize prediction error.  
- Error metrics (MSE, RMSE, MAE) are essential for evaluating regression model performance.

**Examples**  
- Predicting next week’s temperature (e.g., will it be 20°C?).  
- Visualizing data points as vectors in multiple dimensions with a regression line fitted through them.

**Key Takeaways 🎯**  
- Remember regression is for continuous variable prediction, unlike classification which is for categories.  
- Understand the concept of error as the distance from data points to the regression line.  
- Be familiar with common error metrics (MSE, RMSE, MAE) used to assess regression models.  
- Regression lines help in making future predictions by minimizing errors across all data points.

---

### Classification

**Timestamp**: 00:30:50 – 00:31:44

**Key Concepts**  
- Classification is a supervised learning process that divides a labeled data set into classes or categories.  
- The goal is to predict the category (class) for new input data based on learned boundaries.  
- Classification involves drawing a decision boundary (line) that separates different classes in the data.  
- The position of a data point relative to this boundary determines its predicted class.

**Definitions**  
- **Classification**: The process of finding a function to divide a labeled data set into distinct classes or categories.  
- **Supervised Learning**: A type of machine learning where the model is trained on labeled data (input-output pairs).

**Key Facts**  
- Classification predicts discrete categories (e.g., sunny vs. rainy).  
- The classification boundary can be visualized as a line; points on one side belong to one class, points on the other side belong to another.  
- Common classification algorithms include:  
  - Logistic Regression  
  - Decision Trees  
  - Random Forests  
  - Neural Networks  
  - Naive Bayes  
  - K-Nearest Neighbor (KNN)  
  - Support Vector Machines (SVMs)

**Examples**  
- Predicting weather conditions: Will it be sunny or rainy next Saturday?  
- Data points on one side of the classification line represent "sunny," and on the other side represent "rainy."

**Key Takeaways 🎯**  
- Remember classification is about categorizing labeled data, unlike regression which predicts continuous values.  
- The decision boundary is critical: it separates classes and determines classification outcomes.  
- Be familiar with the main classification algorithms and their use cases.  
- Understand that classification outputs discrete labels, making it suitable for problems like weather prediction or image recognition.

---

### Clustering

**Timestamp**: 00:31:44 – 00:32:29

**Key Concepts**  
- Clustering is an unsupervised learning process that groups unlabeled data based on similarities and differences.  
- The goal is to identify groups or clusters within data without pre-existing labels.  
- Clustering infers labels by grouping similar data points together.

**Definitions**  
- **Clustering**: The process of grouping unlabeled data into clusters based on similarity or difference, used in unsupervised learning.  
- **Unlabeled Data**: Data that does not have predefined categories or labels.  

**Key Facts**  
- Clustering algorithms include K-means, K-medoids, density-based, and hierarchical clustering.  
- Clustering can be visualized as drawing boundaries around similar groups in a graph.  

**Examples**  
- Recommending purchases to Windows users versus Mac users by grouping similar user data.  

**Key Takeaways 🎯**  
- Remember clustering is unsupervised learning—no labeled data is provided upfront.  
- The output of clustering is inferred groups, not explicit categories.  
- Know common clustering algorithms: K-means, K-medoids, density-based, hierarchical.  
- Clustering is useful for segmenting data where labels are unknown or unavailable.

---

### Confusion Matrix

**Timestamp**: 00:32:29 – 00:34:06

**Key Concepts**  
- Confusion matrix is a table used to visualize model predictions against actual (ground truth) labels.  
- Also known as an error matrix.  
- Primarily used for classification problems to evaluate how well the classification is working.  
- Compares predicted labels versus actual labels to identify true positives, false negatives, etc.  
- Size of the confusion matrix depends on the number of classes (binary classification has a 2x2 matrix; multiclass will have larger matrices).  

**Definitions**  
- **Confusion Matrix**: A table that displays the predicted classifications versus the actual classifications to evaluate the performance of a classification model.  
- **True Positive (TP)**: When the model correctly predicts the positive class (e.g., predicted 1 and actual 1).  
- **False Negative (FN)**: When the model incorrectly predicts the negative class for a positive instance (e.g., predicted 0 but actual 1).  

**Key Facts**  
- For binary classification, the confusion matrix is typically 2x2 (two labels, e.g., 0 and 1).  
- For multiclass classification (e.g., classes 1, 2, and 3), the confusion matrix expands accordingly (e.g., 3x3 matrix).  
- The total number of cells in a confusion matrix for *n* classes is *n²* (e.g., 3 classes → 9 cells).  
- Exam questions may present confusion matrices with numeric labels (0 and 1) instead of "yes" or "no."  
- You may be asked to identify true positives, false negatives, or calculate the size of the confusion matrix.  

**Examples**  
- Example scenario: Counting how many bananas a person ate, with predicted vs actual counts shown in a confusion matrix format.  
- True positive example: predicted = 1 and actual = 1.  
- False negative example: predicted = 0 and actual = 0 (note: transcript states 0 and 0 as false negative, but typically 0 and 0 is true negative; follow transcript as is).  

**Key Takeaways 🎯**  
- Understand how to read and interpret a confusion matrix (predicted vs actual).  
- Be able to identify true positives, false negatives, and other confusion matrix components from numeric labels.  
- Know how to determine the size of a confusion matrix based on the number of classes.  
- Expect exam questions to use numeric labels (0,1,2, etc.) rather than descriptive labels.  
- Remember confusion matrix is a fundamental tool for evaluating classification model performance.

## Common AI Workloads

---

### Anomaly Detection AI

**Timestamp**: 00:34:06 – 00:34:59

**Key Concepts**  
- Anomaly detection is the process of identifying outliers or abnormal data points that deviate from the norm.  
- Anomalies can indicate suspicious or malicious activity in data or access patterns.  
- Manual anomaly detection is tedious; machine learning improves efficiency and accuracy.  
- Azure provides an Anomaly Detector service to automatically detect anomalies and help troubleshoot issues quickly.

**Definitions**  
- **Anomaly**: An abnormal data point or event marked by deviation from the norm or standard.  
- **Anomaly Detection**: The process of finding outliers or anomalies within a dataset.

**Key Facts**  
- Use cases for anomaly detection include:  
  - Data cleaning  
  - Intrusion detection  
  - Fraud detection  
  - System health monitoring  
  - Event detection  
  - Sensor networks and ecosystem disturbance detection  
  - Detection of critical and cascading flaws  
- Azure’s Anomaly Detector is a machine learning service designed to detect anomalies in data efficiently.

**Examples**  
- None specifically detailed in this segment, but use cases imply examples such as detecting fraud or system faults.

**Key Takeaways 🎯**  
- Understand what constitutes an anomaly and why detecting it is important.  
- Remember the broad range of practical applications for anomaly detection.  
- Know that ML-based anomaly detection is more efficient than manual methods.  
- Be aware of Azure’s Anomaly Detector as a key cloud service for anomaly detection tasks.

---

### Computer Vision AI

**Timestamp**: 00:34:59 – 00:37:05  

**Key Concepts**  
- Computer vision uses machine learning neural networks to understand digital images and videos at a high level.  
- Deep learning algorithms for computer vision include convolutional neural networks (CNNs) and recurrent neural networks (RNNs).  
- Types of computer vision tasks: image classification, object detection, semantic segmentation, image analysis, optical character recognition (OCR), and facial detection.  
- Azure offers several computer vision-related services to analyze images/videos, build custom models, detect faces/emotions, and extract data from documents.  

**Definitions**  
- **Computer Vision**: The use of machine learning neural networks to gain high-level understanding of digital images or videos.  
- **Convolutional Neural Networks (CNNs)**: Deep learning algorithms inspired by the human eye’s processing, primarily used for image and video recognition.  
- **Recurrent Neural Networks (RNNs)**: Neural networks commonly used for handwriting and speech recognition, with other applications as well.  
- **Image Classification**: Categorizing an image or video into a predefined class or category.  
- **Object Detection**: Identifying and labeling objects within an image or video along with their location boundaries.  
- **Semantic Segmentation**: Drawing pixel-level masks around objects or segments in an image, useful for detecting objects and movement.  
- **Image Analysis**: Applying descriptive context labels to images or videos (e.g., identifying an employee sitting at a desk in Tokyo).  
- **Optical Character Recognition (OCR)**: Extracting text from images or videos into editable digital text.  
- **Facial Detection**: Detecting faces in images or videos, drawing location boundaries, and labeling expressions.  

**Key Facts**  
- CNNs are inspired by the human eye’s information processing.  
- RNNs are typically used for handwriting and speech recognition.  
- Microsoft’s Seeing AI app (iOS only) uses computer vision to audibly describe people and objects for visually impaired users.  
- Azure Computer Vision Service offerings include:  
  - **Computer Vision**: Analyze images/videos, extract descriptions, tags, objects, and text.  
  - **Custom Vision**: Build custom image classification and object detection models using your own images.  
  - **Face**: Detect and identify people and emotions in images.  
  - **Form Recognizer**: Scan documents and convert them into editable key-value or tabular data.  

**Examples**  
- Seeing AI app: Uses device camera to identify people and objects and audibly describe them for visually impaired users (iOS only).  
- Image analysis example: Describing a scene such as “an employee sitting at a desk in Tokyo.”  

**Key Takeaways 🎯**  
- Understand the main types of computer vision tasks and their purposes (classification, detection, segmentation, OCR, facial detection).  
- Remember CNNs are the primary deep learning model for image/video recognition; RNNs are more for sequential data like handwriting and speech.  
- Be familiar with Azure’s computer vision services and their specific capabilities (Computer Vision, Custom Vision, Face, Form Recognizer).  
- Seeing AI is a practical Microsoft app example demonstrating computer vision’s accessibility use case.  
- OCR is important for converting image-based text into editable digital formats—commonly tested in exams.  
- Semantic segmentation involves pixel-level object identification, which is more detailed than object detection.

---

### Natural Language Processing AI

**Timestamp**: 00:37:05 – 00:38:42

**Key Concepts**  
- Natural Language Processing (NLP) enables machines to understand and interpret human language contextually.  
- NLP applies to analyzing text in documents and emails, as well as interpreting spoken language.  
- Sentiment analysis determines customer emotions (e.g., happy or sad).  
- Speech synthesis allows voice assistants to talk to users.  
- Automatic translation of spoken or written language between languages.  
- Interpretation of spoken or written commands to trigger appropriate actions.  
- Text analytics services include sentiment analysis, key phrase extraction, language detection, and named entity recognition.  
- Real-time text translation and multi-language support are available via translator services.  
- Speech services transcribe audible speech into searchable text.  
- Language Understanding Intelligent Service (LUIS) is an NLP service for understanding human language in apps, websites, chatbots, IoT devices, etc.  

**Definitions**  
- **Natural Language Processing (NLP)**: Machine learning technology that understands the context of a body of related text (corpus) and interprets text and speech.  
- **Corpus**: A body of related text used for NLP analysis.  
- **Sentiment Analysis**: Technique to determine the emotional tone behind a body of text.  
- **Key Phrase Extraction**: Identifying important phrases relevant to the topic within text.  
- **Named Entity Recognition**: Detecting and categorizing entities (like names, places) in text.  
- **LUIS (Language Understanding Intelligent Service)**: An NLP service that enables applications to understand human language inputs.  

**Key Facts**  
- Microsoft’s Cortana is a well-known voice assistant example using NLP and Bing search integration.  
- Azure’s machine learning platform offers text analytics capabilities such as sentiment analysis, key phrase extraction, language detection, and entity recognition.  
- Translator service supports real-time text translation and multiple languages.  
- Speech service converts spoken language into readable, searchable text.  

**Examples**  
- Customer sentiment analysis to gauge if customers are happy or sad.  
- Cortana performing tasks like setting reminders and answering questions using Bing search.  
- Using LUIS to enable chatbots, websites, or IoT devices to understand human language.  

**Key Takeaways 🎯**  
- Understand that NLP is about machines interpreting and contextualizing human language, both written and spoken.  
- Remember key Azure NLP services: Text Analytics, Translator, Speech Service, and LUIS.  
- Know practical NLP applications: sentiment analysis, speech synthesis, translation, command interpretation.  
- Cortana is a prime example of NLP in action within Microsoft’s ecosystem.  
- LUIS is critical for building conversational AI that understands user intent.  
- Exam questions may focus on differentiating NLP capabilities and identifying appropriate Azure services for language tasks.

---

### Conversational AI

**Timestamp**: 00:38:42 – 00:40:16

**Key Concepts**  
- Conversational AI enables technology to participate in human-like conversations.  
- It commonly uses Natural Language Processing (NLP) to understand and respond to human language.  
- Conversational AI includes chatbots, voice assistants, and interactive voice recognition systems.  
- Interactive voice recognition systems differ from traditional interactive voice response (IVR) systems by understanding spoken language rather than just keypad inputs.  
- Use cases span customer support, accessibility, HR processes, healthcare, IoT devices, and computer software.  
- Azure provides two main services for conversational AI: Q&A Maker and Azure Bot Service.

**Definitions**  
- **Conversational AI**: Technology that can engage in conversations with humans, often leveraging NLP.  
- **Interactive Voice Recognition System**: A system that can interpret and act on human speech, unlike traditional IVR systems that rely on keypad inputs.  
- **Q&A Maker**: An Azure service to create conversational question-and-answer bots from existing content (knowledge bases).  
- **Azure Bot Service**: An intelligent, serverless bot service that scales on demand for creating, publishing, and managing bots.

**Key Facts**  
- Conversational AI typically uses NLP (e.g., LUIS in Azure).  
- Interactive voice recognition systems represent an evolution from IVR systems by processing spoken language.  
- Azure Q&A Maker builds bots from existing content, facilitating quick deployment of FAQ bots.  
- Azure Bot Service supports scalable, serverless bot deployment and management.

**Examples**  
- Chatbots for online customer support answering FAQs like shipping questions.  
- Voice-operated user interfaces for accessibility, especially for visually impaired users.  
- HR applications such as employee training, onboarding, and updating employee info (not commonly seen but noted).  
- Healthcare claim processing (hypothetical example, more relevant in privatized healthcare systems).  
- IoT devices like Amazon Alexa, Apple Siri, Google Home.  
- Computer software autocomplete features (e.g., Cortana).

**Key Takeaways 🎯**  
- Understand the difference between IVR and interactive voice recognition systems.  
- Remember the main Azure services for conversational AI: Q&A Maker (knowledge base bots) and Azure Bot Service (bot lifecycle management).  
- Recognize the broad applicability of conversational AI across industries and devices.  
- Conversational AI relies heavily on NLP technologies to interpret and respond to human language.

## Responsible AI

---

### Responsible AI

**Timestamp**: 00:40:16 – 00:41:09

**Key Concepts**  
- Responsible AI focuses on ethical, transparent, and accountable use of AI technology.  
- Microsoft’s approach to Responsible AI is based on six AI principles.  
- These principles guide the development and deployment of AI systems to ensure fairness, safety, privacy, inclusiveness, transparency, and accountability.

**Definitions**  
- **Responsible AI**: The practice of designing and using AI systems in ways that are ethical, transparent, and accountable.  
- **Fairness**: AI systems should treat all people fairly without bias.  
- **Reliability and Safety**: AI systems should perform consistently and safely.  
- **Privacy and Security**: AI systems should protect user privacy and be secure.  
- **Inclusiveness**: AI should empower and engage all people.  
- **Transparency**: AI systems should be understandable to users.  
- **Accountability**: People must be responsible for the outcomes of AI systems.

**Key Facts**  
- Microsoft invented and promotes these six AI principles, though they are not an industry standard.  
- AI systems can unintentionally reinforce societal biases if not carefully designed.  
- Bias can affect critical domains such as criminal justice, hiring, finance, and credit.  

**Examples**  
- An ML model used in hiring should avoid bias based on gender or ethnicity to prevent unfair advantages or discrimination.

**Key Takeaways 🎯**  
- Remember Microsoft’s six Responsible AI principles as a framework for ethical AI development.  
- Understand that fairness means actively preventing bias in AI systems, especially in sensitive areas like hiring and justice.  
- Accountability means that humans remain responsible for AI decisions and impacts.  
- Transparency and inclusiveness are essential to build trust and ensure AI benefits everyone.  
- Responsible AI is not just theoretical—it requires practical implementation to avoid harm.

---

### Fairness

**Timestamp**: 00:41:09 – 00:42:08

**Key Concepts**  
- AI systems should treat all people fairly.  
- Fairness involves avoiding reinforcement of existing societal biases and stereotypes.  
- Bias can be introduced during AI development pipelines.  
- Fairness is critical in domains like criminal justice, employment/hiring, finance, and credit.  
- Tools exist to help measure and improve fairness in AI models.

**Definitions**  
- **Fairness**: The principle that AI systems should treat all individuals without bias or unfair advantage based on gender, ethnicity, or other protected characteristics.

**Key Facts**  
- AI systems can unintentionally reinforce societal stereotypical biases if not carefully designed.  
- Azure ML provides insights into how each feature influences a model’s prediction, which can help identify bias.  
- Fairlearn is an open-source Python project designed to help data scientists improve fairness in AI systems.  
- At the time of the course, Fairlearn’s fairness features were still in preview and not fully mature.

**Examples**  
- An ML model selecting a final applicant in a hiring pipeline should avoid bias based on gender or ethnicity to prevent unfair advantage.

**Key Takeaways 🎯**  
- Understand that fairness means preventing AI from perpetuating existing social biases.  
- Be aware of tools like Azure ML and Fairlearn that assist in detecting and mitigating bias.  
- Recognize the importance of fairness especially in sensitive domains such as hiring and criminal justice.  
- For the exam, remember that fairness requires AI systems to treat all people equitably without bias.

---

### Reliability and safety

**Timestamp**: 00:42:08 – 00:43:00

**Key Concepts**  
- AI systems must perform reliably and safely.  
- Rigorous testing of AI software is essential before release to ensure expected performance.  
- Transparency about AI mistakes is important: quantified reports on risks and harms should be shared with end users.  
- Reliability and safety are critically important in high-stakes AI applications.

**Definitions**  
- **Reliable AI**: AI systems that consistently perform as intended without unexpected failures.  
- **Safe AI**: AI systems that do not cause harm to users or society and operate within acceptable risk levels.

**Key Facts**  
- AI software must be rigorously tested before deployment.  
- When AI makes mistakes, a report quantifying risks and harms must be released to inform users.  
- Reliability and safety are especially critical in domains such as autonomous vehicles, health diagnosis, prescriptions, and autonomous weapon systems.

**Examples**  
- Autonomous vehicles  
- Health diagnosis and medical prescriptions  
- Autonomous weapon systems (not officially mentioned by Microsoft but highlighted as ethically sensitive)

**Key Takeaways 🎯**  
- Remember for the exam: AI systems must be tested thoroughly to ensure reliability and safety before release.  
- If AI systems have known failure scenarios, a quantified risk report must be provided to end users.  
- High-risk AI applications (e.g., autonomous vehicles, healthcare, weapons) demand the highest standards of reliability and safety.  
- Ethical considerations around AI mistakes are critical, especially in autonomous weapons.

---

### Privacy and security

**Timestamp**: 00:43:00 – 00:43:45

**Key Concepts**  
- AI systems must be secure and respect user privacy.  
- AI often requires large amounts of data, including personally identifiable information (PII), for training machine learning models.  
- Protecting user data from leaks or unauthorized disclosure is critical.  
- Running ML models locally on user devices (edge computing) helps keep PII on-device and reduces vulnerability.  
- AI security involves checking for malicious actors through data origin and lineage verification, controlling internal vs external data use, monitoring for data corruption, and anomaly detection.

**Definitions**  
- **Personally Identifiable Information (PII)**: Data that can identify an individual, which may be required for training ML models.  
- **Edge Computing**: Running machine learning models locally on a user’s device to keep data private and reduce exposure to external threats.

**Key Facts**  
- AI systems require vast amounts of data, often including PII.  
- Local model execution (edge computing) is a privacy-preserving technique.  
- Security measures include verifying data origin, lineage, and monitoring for anomalies.

**Examples**  
- ML models running locally on user devices to keep PII secure (edge computing).  

**Key Takeaways 🎯**  
- Remember that AI must be designed to be secure and respect privacy, especially when handling PII.  
- Edge computing is an important concept for privacy protection in AI.  
- AI security includes protecting data from leaks, malicious actors, and corruption through various checks.  
- This principle is a core Microsoft AI principle and likely to be tested on the exam.

---

### Inclusiveness

**Timestamp**: 00:43:45 – 00:44:24

**Key Concepts**  
- AI systems should empower everyone and engage people inclusively.  
- Designing AI solutions for minority groups can lead to solutions that work for the majority.  
- Minority groups include those defined by physical ability, gender, sexual orientation, ethnicity, and other factors.  
- Specialized solutions may be needed for certain groups (e.g., deaf and blind), but the general principle is designing for the minority benefits all.

**Definitions**  
- **Inclusiveness (in AI)**: The principle that AI systems should be designed to empower and engage all users, including minority groups, ensuring equitable access and usability.

**Key Facts**  
- The 4th Microsoft AI principle focuses on inclusiveness.  
- Designing for minority users can effectively cover the needs of the majority users.

**Examples**  
- Developing technology for deaf and blind groups often requires specialized solutions, illustrating that while the principle is to design for minorities, practical exceptions exist.

**Key Takeaways 🎯**  
- Remember the 4th Microsoft AI principle: AI should empower everyone by being inclusive.  
- Designing AI for minority groups is a strategic approach to inclusiveness.  
- Be aware that some groups may require specialized solutions despite the general principle.  
- Inclusiveness covers diverse factors such as physical ability, gender, sexual orientation, and ethnicity.

---

### Transparency

**Timestamp**: 00:44:24 – 00:45:00

**Key Concepts**  
- AI systems should be understandable to users.  
- Transparency involves interpretability and intelligibility of AI behavior/UI.  
- Transparency helps mitigate unfairness in AI systems.  
- Transparency aids developers in debugging AI systems.  
- Transparency builds trust with users.  
- Openness about AI usage and limitations is essential.  
- Open source AI frameworks can enhance technical transparency.

**Definitions**  
- **Transparency**: The quality of AI systems being understandable and interpretable by end users, allowing insight into how and why AI behaves in certain ways.

**Key Facts**  
- Transparency can reduce unfairness in AI outcomes.  
- Being open about AI system limitations is a key part of transparency.  
- Open source frameworks provide transparency from a technical perspective.

**Examples**  
- None mentioned explicitly in this segment.

**Key Takeaways 🎯**  
- Remember that transparency is about making AI behavior clear and understandable to users.  
- Transparency is crucial for fairness, debugging, and trust.  
- Developers and organizations must openly communicate why AI is used and its limitations.  
- Using open source AI tools can help achieve transparency by exposing internal workings.

---

### Accountability

**Timestamp**: 00:45:00 – 00:45:45

**Key Concepts**  
- Accountability in AI means that people should be responsible for AI systems.  
- Structures must be in place to consistently apply AI principles.  
- AI systems should operate within clearly defined frameworks including governmental, organizational, ethical, and legal standards.  
- Accountability guides how AI is developed, sold, and advocated, especially when working with third parties.  
- There is a push towards regulation and adoption of principled AI frameworks, with Microsoft advocating its model.

**Definitions**  
- **Accountability**: The responsibility of individuals and organizations to ensure AI systems adhere to established principles and standards, and to be answerable for their outcomes.

**Key Facts**  
- Microsoft’s AI principles include accountability as a core component.  
- AI systems must comply with frameworks that are clearly defined by governments and organizations.  
- Microsoft encourages adoption of their accountability model, though it is acknowledged that it may need further development.

**Examples**  
- None explicitly mentioned in this time range; practical examples are introduced immediately after this section.

**Key Takeaways 🎯**  
- Remember that accountability involves both ethical and legal responsibility for AI systems.  
- AI systems should not operate in isolation but within established frameworks and standards.  
- Microsoft is actively promoting accountability through its AI principles and encourages others to adopt similar models.  
- Understanding accountability is crucial for applying AI principles in real-world scenarios and for compliance with regulations.

---

### Guidelines for Human AI Interaction

**Timestamp**: 00:45:45 – 00:46:04

**Key Concepts**  
- Practical application of Microsoft AI principles through human-AI interaction guidelines  
- Use of scenario-based tools (cards) to understand and implement principles  
- Emphasis on clarity about AI system capabilities for users  

**Definitions**  
- **Microsoft AI Principles**: A set of guidelines Microsoft uses to develop, sell, and advocate AI technologies responsibly, encouraging adoption by others.  
- **Human-AI Interaction Guidelines**: Practical instructions to help users and developers understand and apply AI principles in real-world scenarios.  

**Key Facts**  
- Microsoft provides a free web app with 18 color-coded scenario cards to illustrate AI principles in practice.  
- These cards help users understand how to communicate AI capabilities clearly.  

**Examples**  
- PowerPoint Quick Start: Builds an online outline to assist users in researching a subject by suggesting topics, demonstrating system capabilities.  
- Bing app: Shows example queries to help users understand what they can search for.  

**Key Takeaways 🎯**  
- Remember that Microsoft’s AI principles are supported by practical tools to help users and developers apply them effectively.  
- Focus on making AI system capabilities transparent to users to improve trust and usability.  
- Familiarize yourself with scenario-based examples like those in PowerPoint Quick Start and Bing app to illustrate clear communication of AI functions.

---

### Follow Along Guidelines for Human AI Interaction

**Timestamp**: 00:46:04 – 00:57:33

**Key Concepts**  
- Microsoft AI principles are operationalized through practical human-AI interaction guidelines.  
- Guidelines are presented as 18 color-coded cards, each addressing a specific design principle for AI systems.  
- Focus on transparency, user control, contextual relevance, social norms, bias mitigation, and user feedback.  
- Emphasis on making AI capabilities, limitations, and behaviors clear to users.  
- Importance of supporting efficient invocation, dismissal, and correction of AI services.  
- Encouraging personalization and learning from user behavior while minimizing disruptive changes.  
- Providing explanations for AI decisions and enabling global customization and notifications about AI updates.

**Definitions**  
- **Efficient Invocation**: Making it easy for users to request AI services when needed.  
- **Efficient Dismissal**: Allowing users to easily ignore or dismiss unwanted AI suggestions or services.  
- **Efficient Correction**: Enabling users to easily edit or correct AI outputs when they are wrong.  
- **Disambiguation**: Engaging users to clarify their intent when the AI system is uncertain.  
- **Global Controls**: Settings that allow users to customize AI system behavior on a broad scale.  
- **Granular Feedback**: Allowing users to provide specific feedback on AI suggestions or behaviors during normal use.

**Key Facts**  
- 18 cards represent different guidelines for human-AI interaction.  
- Cards are color-coded (e.g., red cards for time/context-based actions, yellow cards for invocation/dismissal/correction, green cards for memory and learning).  
- Examples span Microsoft products (PowerPoint, Office, Outlook, Bing), Apple products (Apple Watch, Apple Music, Siri), and other platforms (Amazon, Google, Instagram).  
- AI systems should communicate uncertainty and set user expectations clearly.  
- AI should respect social and cultural norms and mitigate biases (e.g., gender-neutral icons, diverse image results).  
- AI updates should be cautious to avoid disrupting user experience.  
- Users should be notified of AI system changes and new capabilities.

**Examples**  
- PowerPoint Quick Start suggests topics to help users understand AI capabilities.  
- Bing app shows example queries to clarify system abilities.  
- Apple Watch displays tracked metrics and explanations.  
- Office Ideas pane offers grammar, design, and data insights with labels to set expectations.  
- Apple Music uses polite language and feedback buttons (like/dislike).  
- Outlook sends "time to leave" notifications based on real-time traffic and location.  
- Apple Maps remembers parked car location and suggests routing.  
- Walmart.com recommends accessories related to viewed products.  
- Google Photos recognizes pets and uses culturally sensitive language.  
- Cortana uses polite, semi-formal tone when apologizing for missing contacts.  
- Bing search shows diverse images for CEO or doctor queries.  
- Excel Flash Fill can be invoked easily to save time.  
- Instagram allows easy hiding or reporting of AI-suggested ads.  
- Siri can be dismissed by saying "Never mind."  
- Alt Text in Office can be edited after automatic generation.  
- Word auto-replacement offers multiple correction options when uncertain.  
- Office Online explains why documents are recommended based on user history.  
- Outlook remembers recent files and contacts for quick access.  
- Amazon.com personalizes product recommendations based on purchase history.  
- PowerPoint Designer updates slide suggestions without disrupting workflow.  
- Instagram solicits feedback on ad relevance.  
- Excel geographic data types show immediate visual feedback upon conversion.  
- Word Editor allows customization of spelling and grammar checks.  
- Bing search offers safe search settings.  
- Google Photos allows toggling location history.  
- Office "What's New" dialog informs users about AI feature updates.

**Key Takeaways 🎯**  
- Understand the 18 human-AI interaction guidelines as practical applications of responsible AI principles.  
- Be able to identify examples of transparency: making AI capabilities and limitations clear to users.  
- Know the importance of supporting user control: easy invocation, dismissal, and correction of AI outputs.  
- Recognize the need for AI systems to respect social norms and mitigate biases in language and behavior.  
- Remember that AI should learn from user behavior but update cautiously to avoid disrupting user experience.  
- Be aware that providing explanations for AI decisions and allowing global customization are critical for trust.  
- Users must be notified about AI system changes and new features to maintain transparency.  
- Practical examples from Microsoft and other tech companies illustrate these principles in real-world applications.  
- For exam focus, link these guidelines to responsible AI concepts and how they improve user experience and trust.

## Congitive Services

---

### Azure Cognitive Services

**Timestamp**: 00:57:33 – 00:59:41

**Key Concepts**  
- Azure Cognitive Services is a comprehensive family of AI services and cognitive APIs designed to help build intelligent applications.  
- Services include customizable pre-trained models that can be deployed from cloud to edge using containers.  
- No machine learning expertise is strictly required to get started, but some background knowledge is beneficial.  
- Microsoft emphasizes responsible AI with strict ethical standards and industry-leading tools and guidelines.  
- Cognitive Services are grouped into categories: Decision, Language, Speech, and Vision.  
- Access to these services is managed via an AI key and API endpoint generated when creating a Cognitive Service resource.

**Definitions**  
- **Azure Cognitive Services**: A suite of AI services and APIs that enable developers to add intelligent features to their apps without deep AI or ML expertise.  
- **Decision Services**: AI tools that help make decisions, e.g., anomaly detection, content moderation, and personalization.  
- **Language Services**: APIs for natural language understanding, sentiment analysis, translation, and Q&A layers.  
- **Speech Services**: Convert speech to text, text to speech, real-time speech translation, and speaker recognition.  
- **Vision Services**: Analyze images and videos, customize image recognition, detect faces and emotions.  
- **AI Key and Endpoint**: Credentials generated when creating a Cognitive Service resource, used for authenticating API calls.

**Key Facts**  
- Cognitive Services can be deployed anywhere from cloud to edge using containers.  
- Language services support over 90 languages for translation.  
- Speech services include speech-to-text, text-to-speech, speech translation, and speaker recognition.  
- Vision services include computer vision, custom vision, and face detection with emotion recognition.  
- Creating a Cognitive Service resource generates two keys and an endpoint for authentication.  
- Knowledge mining is an AI discipline that uses multiple intelligent services to extract insights from large data sets.

**Examples**  
- Decision: Anomaly Detector (detect potential problems early), Content Moderator (detect offensive content), Personalizer (create personalized experiences).  
- Language: LUIS (Language Understanding Intelligent Service), Q&A Maker, Text Analytics (sentiment detection).  
- Speech: Speech-to-text transcription, Text-to-speech conversion, Real-time speech translation, Speaker recognition.  
- Vision: Computer Vision (analyze images/videos), Custom Vision (custom image recognition), Face detection and emotion recognition.

**Key Takeaways 🎯**  
- Know the four main categories of Azure Cognitive Services: Decision, Language, Speech, Vision.  
- Understand that Cognitive Services provide pre-built AI models accessible via API with minimal ML expertise required.  
- Remember that authentication uses keys and endpoints generated per Cognitive Service resource.  
- Be aware of the ethical and responsible AI emphasis by Microsoft in these services.  
- Recognize common use cases like anomaly detection, content moderation, sentiment analysis, translation, speech transcription, and image analysis.  
- Knowledge mining leverages these services collectively to extract insights from large datasets—important for exam scenarios involving AI data exploration.

---

### Congitive API Key and Endpoint

**Timestamp**: 00:59:41 – 01:00:08

**Key Concepts**  
- Azure Cognitive Services acts as an umbrella AI service providing access to multiple AI capabilities.  
- Authentication to these AI services is done using an API key and an endpoint.  
- When you create a new Cognitive Service resource, two keys and one endpoint are generated automatically.  
- These keys and endpoint are essential for programmatic access and authentication to the AI services.

**Definitions**  
- **Azure Cognitive Services**: A collection of AI services accessible via a single API key and endpoint that enable various AI functionalities such as vision, speech, language, and decision-making.  
- **API Key**: A security token used to authenticate requests to Azure Cognitive Services.  
- **Endpoint**: The URL or address where the Cognitive Service API can be accessed.

**Key Facts**  
- Creating a new Cognitive Service resource generates:  
  - Two API keys  
  - One API endpoint  
- These credentials are required for authenticating and using the AI services programmatically.

**Examples**  
- None mentioned explicitly in this segment.

**Key Takeaways 🎯**  
- Always remember that to use Azure Cognitive Services, you must create a Cognitive Service resource first.  
- The resource creation process provides you with two keys and an endpoint—these are mandatory for authentication.  
- Keep your API keys secure as they grant access to the AI services.  
- Understanding the role of the API key and endpoint is critical for integrating AI capabilities into applications.

---

### Knowledge Mining

**Timestamp**: 01:00:08 – 01:04:42

**Key Concepts**  
- Knowledge mining is an AI discipline that combines intelligent services to quickly learn from vast amounts of information.  
- It enables organizations to deeply understand, explore, and uncover hidden insights, relationships, and patterns at scale.  
- The knowledge mining process involves three main steps:  
  1. **Ingest** – Collect content from a variety of sources (structured, semi-structured, unstructured).  
  2. **Enrich** – Use AI capabilities (cognitive services) to extract information, find patterns, and deepen understanding.  
  3. **Explore** – Access and analyze the enriched data via search indexes, bots, applications, and visualizations.  

**Definitions**  
- **Knowledge Mining**: The process of using AI and cognitive services to ingest, enrich, and explore large volumes of data to extract meaningful insights and patterns.  
- **Cognitive Services**: Prebuilt AI services in Azure that provide vision, language, speech, decision, and search capabilities to enrich data.  
- **Search Index**: A structured repository of enriched data that enables fast and relevant search queries and exploration.  

**Key Facts**  
- Azure Cognitive Services provides two keys and an endpoint for authentication to access AI services programmatically.  
- Data sources for ingestion include:  
  - Structured data (e.g., databases, CSV files)  
  - Unstructured data (e.g., PDFs, videos, images, audio)  
- Enrichment can include AI tasks such as printed text recognition, key phrase extraction, clause extraction, language detection, and automated translation.  
- Enriched data can be integrated into business applications, CRM systems, Power BI dashboards, or Word plug-ins for further use.  

**Examples**  
- **Content Research**: Employees use knowledge mining to quickly review dense technical documents by extracting key phrases and technical keywords, making research more efficient.  
- **Audit, Risk, and Compliance Management**: Attorneys use knowledge mining to identify important entities and clauses in discovery documents, flagging GDPR risks and other compliance issues.  
- **Business Process Management**: Companies use knowledge mining to process drilling and completion reports with AI document processors and custom models, enabling intelligent automation and analytics.  
- **Customer Support and Feedback Analysis**: Customer support teams leverage knowledge mining to find answers quickly and assess customer sentiment at scale using enriched documents and search indexes.  
- **Digital Asset Management**: Organizations tag and extract metadata from images (e.g., geo points, biographical data, object detection) to create searchable art explorers.  
- **Contract Management**: Knowledge mining helps companies analyze thousands of pages of RFPs and contracts by extracting risk, key phrases, organizational data, and engineering standards to create accurate bids.  

**Key Takeaways 🎯**  
- Remember the three core steps of knowledge mining: ingest, enrich, and explore.  
- Know that Azure Cognitive Services provide the AI capabilities needed for enrichment, including vision, language, speech, decision, and search.  
- Understand that knowledge mining is used across multiple industries and scenarios such as research, compliance, business processes, customer support, digital asset management, and contract management.  
- Be familiar with the types of data ingested (structured, semi-structured, unstructured) and common enrichment techniques (text recognition, key phrase extraction, clause classification).  
- Search indexes are critical for enabling fast, scalable exploration and integration into business tools and analytics platforms.  
- Practical use cases often combine prebuilt cognitive skills with custom AI models and human validation for accuracy and automation.

---

### Face Service

**Timestamp**: 01:04:42 – 01:06:30

**Key Concepts**  
- Azure Face Service uses AI algorithms to detect, recognize, and analyze human faces in images.  
- It can identify faces, face landmarks, attributes, and match faces across a gallery.  
- Provides detailed facial analysis including emotions, accessories, and image quality factors.  

**Definitions**  
- **Face Service**: An Azure AI service that detects and analyzes human faces in images, providing identification, attributes, and landmark data.  
- **Face Landmarks**: Specific predefined points on a face (up to 27) used to identify facial components like eyes, nose, mouth, etc.  
- **Face Attributes**: Characteristics detected on a face such as age, gender, facial hair, accessories, emotions, and image quality indicators (blur, noise, occlusion).  

**Key Facts**  
- Each detected face in an image is assigned a unique identifier string.  
- Up to 27 predefined face landmarks can be detected per face.  
- Attributes detected include:  
  - Accessories (earrings, lip rings)  
  - Age estimation  
  - Blurriness of the image  
  - Emotion detection  
  - Exposure and contrast of the image  
  - Facial hair presence  
  - Gender  
  - Glasses  
  - Hair details  
  - Head pose  
  - Makeup (limited to eye and lip makeup)  
  - Mask wearing detection  
  - Noise/artifacts and occlusion (objects blocking parts of the face)  
  - Boolean smiling detection (smiling or not)  

**Examples**  
- An image processed by Face Service shows bounding boxes around detected faces with unique IDs.  
- Face landmarks highlight specific facial points for detailed analysis.  
- Attribute detection can identify if a person is smiling, wearing glasses, or has makeup.  

**Key Takeaways 🎯**  
- Remember that Face Service provides unique IDs for faces to track them across images or galleries.  
- Up to 27 face landmarks can be used for detailed facial feature analysis.  
- Face attributes cover a wide range of characteristics including emotions and image quality factors—important for nuanced face recognition tasks.  
- Smiling detection is a simple Boolean attribute but commonly used.  
- Makeup detection is limited, mainly to eye and lip makeup.  
- Occlusion and noise detection help assess image quality and reliability of face recognition.  
- Useful for applications requiring detailed face analysis beyond simple detection, such as security, marketing, or user experience personalization.

---

### Speech and Translate Service

**Timestamp**: 01:06:30 – 01:08:04

**Key Concepts**  
- Azure Translate Service: translates text between languages and dialects  
- Neural Machine Translation (NMT) vs Statistical Machine Translation (SMT)  
- Custom Translator: extend translation service for domain-specific language  
- Azure Speech Service: includes speech-to-text, text-to-speech, and speech translation  
- Speech synthesis markup language used for text-to-speech customization  
- Voice assistant integration with Bot Framework SDK  
- Speaker verification and identification features  

**Definitions**  
- **Neural Machine Translation (NMT)**: A modern translation approach using neural networks for higher accuracy, replacing older statistical methods.  
- **Statistical Machine Translation (SMT)**: Legacy translation method based on classical machine learning and statistical models.  
- **Custom Translator**: A feature allowing customization of translation models to better handle specific business domain terminology or phrases.  
- **Speech Synthesis Markup Language (SSML)**: A markup language used to format text input for speech synthesis, enabling voice customization.  

**Key Facts**  
- Azure Translate supports translation of 90 languages and dialects, including Klingon.  
- NMT replaced SMT for improved translation accuracy.  
- Azure Speech Service supports:  
  - Real-time speech-to-text  
  - Batch transcription  
  - Multi-device conversation transcription  
  - Custom speech models  
  - Text-to-speech with custom voices  
  - Voice assistant integration with Bot Framework SDK  
  - Speaker verification and identification  

**Examples**  
- Translation into Klingon highlighted as an interesting fact.  
- Speech-to-text can be used for real-time transcription and multi-device conversations.  
- Text-to-speech uses SSML for voice customization.  

**Key Takeaways 🎯**  
- Remember Azure Translate uses Neural Machine Translation (NMT) for better accuracy over older SMT.  
- Azure Translate supports a wide range of languages (90+), including niche ones like Klingon.  
- Custom Translator is important for adapting translations to specific business domains or technical language.  
- Azure Speech Service is comprehensive: supports speech-to-text, text-to-speech, and speech translation with customization options.  
- SSML is key for customizing text-to-speech output.  
- Integration with Bot Framework SDK enables voice assistants with speaker verification and identification features.  
- Focus on understanding the capabilities and customization options of both Translate and Speech services for exam scenarios.

---

### Text Analytics

**Timestamp**: 01:08:04 – 01:11:02

**Key Concepts**  
- Text Analytics is an NLP (Natural Language Processing) service for text mining and analysis.  
- Performs sentiment analysis to determine opinions about brands or topics.  
- Opinion mining provides aspect-based sentiment analysis for granular opinion details.  
- Key phrase extraction identifies main concepts within larger text.  
- Language detection identifies the language of input text.  
- Named Entity Recognition (NER) detects and categorizes entities such as people, places, objects, quantities.  
- Personally Identifiable Information (PII) detection is a subset of NER.  

**Definitions**  
- **Sentiment Analysis**: Assigns sentiment labels (negative, neutral, positive) and confidence scores to text at sentence and document levels.  
- **Opinion Mining**: Aspect-based sentiment analysis that breaks down opinions by subject and sentiment, providing more detailed insights than general sentiment analysis.  
- **Key Phrase Extraction**: Extracts main concepts or important phrases from larger bodies of text.  
- **Named Entity Recognition (NER)**: Identifies and categorizes entities in unstructured text into semantic types like person, location, diagnosis, medication, etc.  
- **Personally Identifiable Information (PII)**: Sensitive information that can identify an individual, detected as part of NER.  

**Key Facts**  
- Key phrase extraction works best on larger text inputs (up to 5,000 characters per document).  
- Sentiment analysis performs better on smaller text inputs.  
- You can process up to 1,000 items per collection for key phrase extraction.  
- Sentiment labels include: negative, positive, neutral, mixed.  
- Confidence scores for sentiment range from 0 to 1.  
- NER semantic types vary by domain, with generic and health-specific types available.  

**Examples**  
- Key phrase extraction example: From a movie review, phrases like "Borg ship," "enterprise," "surface," "travels" were extracted.  
- NER example: Medical text where words/phrases are tagged as diagnosis, medication class, age, location, person, etc.  
- Sentiment vs. Opinion Mining example: A review where overall sentiment is negative, but opinion mining shows "room was great" (positive) and "staff was unfriendly" (negative), illustrating granular sentiment breakdown.  

**Key Takeaways 🎯**  
- Remember the difference between sentiment analysis (broad, document/sentence level) and opinion mining (granular, aspect-based).  
- Use key phrase extraction for larger documents to identify main concepts quickly.  
- NER is useful for extracting structured data from unstructured text, especially for domain-specific entities.  
- Confidence scores are important to gauge the reliability of sentiment labels.  
- Opinion mining can reveal mixed sentiments within the same text, which basic sentiment analysis might miss.

---

### OCR Computer Vision

**Timestamp**: 01:11:02 – 01:12:22

**Key Concepts**  
- Optical Character Recognition (OCR) is the process of extracting printed or handwritten text into a digital, editable format.  
- OCR can be applied to various sources such as photos of street signs, products, documents, invoices, bills, financial reports, and articles.  
- Azure provides two main OCR-related APIs: the OCR API and the Read API.  

**Definitions**  
- **OCR (Optical Character Recognition)**: Technology that converts different types of text images (printed or handwritten) into machine-encoded text.  
- **OCR API**: An older Azure OCR model that supports only images, executes synchronously, and is easier to implement.  
- **Read API**: A newer Azure OCR model that supports images and PDFs, executes asynchronously, processes text line-by-line for faster results, and is suited for large amounts of text.  

**Key Facts**  
- OCR API:  
  - Uses an older recognition model  
  - Supports images only  
  - Executes synchronously (returns immediately)  
  - Suited for less text  
  - Supports more languages  
  - Easier to implement  
- Read API:  
  - Updated recognition model  
  - Supports images and PDFs  
  - Executes asynchronously  
  - Processes tasks in parallel per line for speed  
  - Suited for large volumes of text  
  - Supports fewer languages  
  - More complex to implement  
- Both APIs are accessed via the Computer Vision SDK.  

**Examples**  
- Extracting nutritional data (nutritional facts) from the back of a food product label.  

**Key Takeaways 🎯**  
- Know the difference between the OCR API and the Read API in Azure Computer Vision, especially their capabilities, execution style (sync vs async), and use cases (small vs large text).  
- Remember that OCR converts images of text into editable digital text, useful for automating data extraction from various document types.  
- The Read API is preferred for larger documents and PDFs due to asynchronous and parallel processing.  
- Implementation complexity and language support differ between the two APIs—OCR API is simpler and supports more languages; Read API is more advanced but supports fewer languages.  
- Use the Computer Vision SDK to interact with these OCR services.

---

### Form Recognizer

**Timestamp**: 01:12:22 – 01:14:48

**Key Concepts**  
- Form Recognizer is a specialized OCR service designed to translate printed text into digital, editable content while preserving the structure and relationships of form-like data.  
- It automates data entry and enhances document search capabilities by identifying key-value pairs, selection marks, and table structures.  
- Outputs include original file relationships, bounding boxes, and confidence scores.  
- Composed of custom document processing models and pre-built models for common document types (invoices, receipts, IDs, business cards).  
- The layout model extracts text, selection marks, and table structures with row and column information using high-definition optical character enhancement.  
- Custom models can be trained with as few as 5 sample forms to tailor extraction to specific form types.  

**Definitions**  
- **Form Recognizer**: A specialized OCR service that converts printed text into editable digital content while preserving the structure and relationships inherent in form-like documents.  
- **Custom Document Processing Models**: Models trained on your own sample forms to extract text, key-value pairs, selection marks, and tabular data specific to your documents.  
- **Pre-built Models**: Ready-to-use models designed for common document types such as invoices, receipts, IDs, and business cards.  
- **Layout Model**: Extracts text, selection marks, and table structures along with bounding box coordinates and row/column data from documents.  

**Key Facts**  
- Form Recognizer supports extraction of:  
  - Key-value pairs  
  - Selection marks  
  - Table structures (with row and column numbers)  
- Outputs include bounding boxes and confidence scores for extracted data.  
- Custom models require only 5 sample input forms to start training.  
- After training, models can be tested, retrained, and used reliably for automated data extraction.  

**Examples**  
- None explicitly mentioned beyond general document types (invoices, receipts, IDs, business cards).  

**Key Takeaways 🎯**  
- Remember that Form Recognizer preserves the structure and relationships in forms, unlike basic OCR.  
- It is ideal for automating data entry and enriching document search by extracting structured data.  
- Custom models allow tailored extraction with minimal training data (5 samples).  
- Outputs include detailed metadata such as bounding boxes and confidence scores, useful for validation.  
- Know the difference between pre-built and custom models and when to use each.  
- The layout model is foundational for extracting text and table structures with spatial context.

---

### Form Recognizer Custom Models

**Timestamp**: 01:14:48 – 01:15:34

**Key Concepts**  
- Custom models in Form Recognizer enable extraction of text, key-value pairs, selection marks, and tabular data from forms.  
- These models are trained specifically with your own data, making them tailored to your form types.  
- Training requires only a small number of sample forms (minimum 5).  
- The output includes structured data preserving relationships from the original document.  
- After training, models can be tested, retrained, and used reliably for automated data extraction.  
- Two learning approaches are available:  
  - Unsupervised learning: Understands layout and relationships between fields without labeled data.  
  - Supervised learning: Uses labeled forms to extract specific values of interest.

**Definitions**  
- **Custom Models**: User-trained Form Recognizer models designed to extract structured data from specific form types using sample input forms.  
- **Unsupervised Learning**: A training method where the model learns layout and field relationships without labeled data.  
- **Supervised Learning**: A training method where the model learns to extract specific data points using labeled examples.

**Key Facts**  
- Minimum of 5 sample forms needed to train a custom model.  
- Custom models output structured data including original document relationships.  
- Two learning options: unsupervised and supervised learning.

**Examples**  
- None specifically mentioned within this time range for custom models.

**Key Takeaways 🎯**  
- Remember that custom models require minimal training data (only 5 samples) to get started.  
- Understand the difference between unsupervised (layout-focused) and supervised (value extraction) learning approaches.  
- Custom models are essential when pre-built models do not fit your specific form types or data extraction needs.  
- After training, always test and retrain your model to improve accuracy before deployment.

---

### Form Recognizer Prebuilt Models

**Timestamp**: 01:15:34 – 01:17:33

**Key Concepts**  
- Form Recognizer offers multiple prebuilt models designed to extract structured data from common document types.  
- These models automatically extract key fields without needing custom training.  
- Prebuilt models cover receipts, business cards, invoices, line items, and IDs.  
- Each model extracts specific fields relevant to the document type.  
- Custom models are used when additional or missing fields need to be extracted beyond what prebuilt models provide.

**Definitions**  
- **Prebuilt Models**: Ready-to-use models in Form Recognizer that extract structured data from common document types without requiring training.  
- **Receipts Model**: Extracts sales receipt data including merchant info, transaction details, and itemized purchases.  
- **Business Cards Model**: Extracts contact information from English business cards.  
- **Invoices Model**: Extracts invoice-related fields such as customer/vendor info, dates, amounts, and addresses.  
- **Line Items Model**: Extracts detailed item-level data like description, quantity, price, and tax.  
- **IDs Model**: Extracts identity document fields such as name, nationality, dates, and document type.

**Key Facts**  
- Receipts model supports receipts from Australia, Canada, Great Britain, India, and the United States.  
- Business cards model supports only English language cards.  
- Minimum of 5 sample forms needed to train a custom model (mentioned just before this section).  
- Important fields extracted by each model include:  
  - **Receipts**: receipt type, merchant name/phone/address, transaction date/time, total, subtotal, tax, tip, items (name, quantity, price, total price).  
  - **Business Cards**: contact names, company, department, job title, emails, websites, multiple phone types, addresses.  
  - **Invoices**: customer/vendor names and addresses, purchase order, invoice ID/date, due date, subtotal, tax, total, amount due, service and remittance addresses, previous unpaid balance.  
  - **Line Items**: item description, quantity, unit price, product code, tax, date.  
  - **IDs**: country, region, date of birth, expiration date, document name, first/last name, nationality, sex, machine readable zone, document type, address, region.

**Examples**  
- Receipts from multiple countries (Australia, Canada, Great Britain, India, US).  
- English business cards extraction.  
- Various invoice formats with detailed billing and shipping info.  
- Identity documents including passports and US driver licenses.

**Key Takeaways 🎯**  
- Know the types of prebuilt models available in Form Recognizer and their primary use cases.  
- Remember the key fields each prebuilt model extracts by default.  
- Prebuilt models save time by eliminating the need for custom training on common document types.  
- Custom models are necessary when you need to extract fields not covered by prebuilt models.  
- Business cards model is limited to English only.  
- Receipts model supports multiple countries, important for exam scenarios involving international data.  
- Minimum 5 sample forms needed to train custom models (context from just before this section).  
- Understanding these models helps in choosing the right approach for document data extraction tasks in Azure Form Recognizer.

---

### LUIS

**Timestamp**: 01:17:33 – 01:19:58

**Key Concepts**  
- LUIS (Language Understanding Intelligent Service) is a no-code machine learning service to build natural language understanding into apps, bots, and IoT devices.  
- It enables quick creation of enterprise-ready custom models that continuously improve.  
- LUIS focuses on understanding user intentions and extracting relevant information from user input.  
- The service is accessed via its own isolated domain at **luis.ai**.  
- LUIS applications are composed of a schema that defines intents, entities, and utterances.  
- Intents represent what the user wants (classification of user input).  
- Entities extract specific data from the user input related to the intent.  
- Utterances are example user inputs labeled with intents and entities used to train the ML model.  
- Every LUIS app contains a special **none** intent to explicitly train the model to ignore irrelevant or out-of-scope utterances.  

**Definitions**  
- **Intent**: The goal or purpose behind a user’s utterance; what the user is asking for.  
- **Entity**: Specific pieces of information extracted from the utterance that help fulfill the intent.  
- **Utterance**: An example phrase or sentence from a user that is labeled with an intent and entities for training the model.  
- **None Intent**: A built-in intent used to classify utterances that do not match any defined intent, effectively telling the model to ignore them.  

**Key Facts**  
- Recommended number of example utterances per intent: **15 to 30** for effective training.  
- The schema for a LUIS app is auto-generated via the LUIS AI web interface; manual schema writing is not typical.  
- LUIS uses NLP (Natural Language Processing) and NLU (Natural Language Understanding) to transform linguistic statements into machine-understandable representations.  

**Examples**  
- Example utterance: "These would be the identities. So we have two in Toronto."  
  - Intent: Classification of what the user wants (not explicitly named in transcript).  
  - Entities: Identified keywords or phrases within the utterance that help determine the answer.  

**Key Takeaways 🎯**  
- Understand the difference between intents (what the user wants) and entities (data extracted from the utterance).  
- Always include a **none** intent in your LUIS app to handle irrelevant or out-of-scope inputs.  
- Provide sufficient example utterances (15-30) per intent to train the model effectively.  
- LUIS is designed to be used via its web interface, which auto-generates the schema, making it accessible even without deep programming skills.  
- Focus on the classification nature of intents and the extraction role of entities for the AI-900 exam.  
- No need to dive deeply into advanced features beyond intents, entities, and utterances for the exam.

---

### QnA Maker

**Timestamp**: 01:19:58 – 01:24:19

**Key Concepts**  
- QnA Maker is a cloud-based NLP service that creates a natural conversational layer over custom data.  
- It helps find the most appropriate answer from a custom knowledge base.  
- Commonly used for building conversational clients like chatbots, social apps, and speech-enabled desktop apps.  
- Customer data is stored only in the region where dependent services are deployed; QnA Maker itself does not store customer data.  
- Knowledge bases are built from documents (PDF, DOCX), URLs, or manuals containing question-answer pairs.  
- Metadata tags (e.g., chit chat, content type, format, freshness) help filter and refine answers.  
- Supports multi-turn conversations with follow-up prompts to manage dialog flow.  
- Uses layered ranking: Azure Search provides initial ranking, followed by QnA Maker’s NLP re-ranking for final results and confidence scores.  
- Active learning helps improve the knowledge base by suggesting edits based on user queries.  
- Chit chat feature provides pre-populated conversational responses for casual or off-topic user inputs.

**Definitions**  
- **QnA Maker**: A cloud-hosted service (at QnAMaker.ai) that builds a conversational question-answer layer over custom data using NLP and machine learning.  
- **Knowledge Base (KB)**: A collection of question and answer pairs created from documents, URLs, or manuals to serve as the source of answers.  
- **Multi-turn Conversation**: A dialog feature where the bot manages follow-up questions and context to handle complex interactions beyond a single question-answer exchange.  
- **Chit Chat**: Pre-built conversational content that handles casual or small talk queries with canned responses.  
- **Layered Ranking**: A two-step ranking process where Azure Search first ranks results, then QnA Maker’s NLP model re-ranks to produce final answers with confidence scores.  
- **Active Learning**: A process where the system learns from user interactions to suggest improvements to the knowledge base.

**Key Facts**  
- QnA Maker is hosted on its own isolated domain: QnAMaker.ai.  
- Knowledge bases can be built from DOCX files with headings and text, PDFs, URLs, or manuals.  
- Metadata tags include chit chat, content type, format, content purpose, and content freshness.  
- The chit chat dataset includes about 100 scenarios with multiple personas’ voices.  
- Azure Search is used as the first ranking layer in the answer retrieval process.  
- Multi-turn conversations enable follow-up prompts to refine answers when a single-turn answer is insufficient.

**Examples**  
- Importing a DOCX document with headings and text to automatically extract question-answer pairs.  
- Multi-turn conversation example: A user asks a generic question, then follows up with “Are you talking about AWS or Azure?” to clarify intent.  
- Chit chat responses to casual questions like “How are you doing?” or “What’s the weather today?” with canned answers.

**Key Takeaways 🎯**  
- Understand that QnA Maker builds a custom knowledge base from various document types to answer user questions conversationally.  
- Remember the layered ranking approach: Azure Search + NLP re-ranking for accurate results.  
- Know the importance of metadata tags for filtering and enhancing answer relevance.  
- Multi-turn conversations are essential for handling complex dialogs with follow-up prompts.  
- Chit chat is useful for handling casual or off-topic user inputs with pre-built responses.  
- Active learning improves the knowledge base over time by analyzing user queries and suggesting edits.  
- QnA Maker does not store customer data outside the deployed region, ensuring data residency compliance.  
- The QnA Maker chat box or integration with Azure Bot Service allows testing and interacting with the knowledge base.

---

### Azure Bot Service

**Timestamp**: 01:24:19 – 01:26:45

**Key Concepts**  
- Azure Bot Service is an intelligent, serverless bot service that scales on-demand.  
- It is used for creating, publishing, and managing bots via the Azure portal.  
- Bots can be integrated with multiple channels including Azure, Microsoft, and third-party services.  
- The Bot Framework SDK (version 4) is an open-source SDK for building sophisticated conversational bots.  
- Bot Framework Composer is an open-source IDE built on top of the Bot Framework SDK for authoring, testing, provisioning, and managing bots.  

**Definitions**  
- **Azure Bot Service**: A scalable, serverless platform in Azure for creating, publishing, and managing bots.  
- **Bot Framework SDK**: An open-source software development kit (currently version 4) that enables developers to build complex conversational bots with natural language understanding and speech capabilities.  
- **Bot Framework Composer**: An open-source integrated development environment (IDE) for building conversational experiences, supporting bot authoring, testing, and deployment.  

**Key Facts**  
- Azure Bot Service supports integration with channels such as Direct Line, Alexa, Office 365, Facebook, Keek, Line, Microsoft Teams, Skype, Twilio, and more.  
- Bot Framework SDK version 4 is the current version used for bot development.  
- Bot Framework Composer is available on Windows, macOS, and Linux.  
- Bots can be developed using C# or Node.js.  
- Deployment options include Azure Web Apps and Azure Functions.  
- Composer provides templates for various bot types: QnA Maker Bot, Enterprise or Personal Assistant Bot, Language Bot, Calendar Bot, People Bot.  
- Testing and debugging can be done using the Bot Framework Emulator.  
- Composer includes a built-in package manager.  

**Examples**  
- Examples of bots include Azure Health Bot, Azure Bot, and Web App Bot (a generic bot).  
- Integration examples: connecting bots to Microsoft Teams, Facebook, Alexa, and Twilio channels.  

**Key Takeaways 🎯**  
- Understand that Azure Bot Service is a scalable, serverless platform for bot management and deployment.  
- Know the role of the Bot Framework SDK (v4) as the core development kit for building bots.  
- Remember Bot Framework Composer as the visual IDE tool that simplifies bot creation and management.  
- Be familiar with supported programming languages (C# and Node.js) and deployment targets (Azure Web Apps, Azure Functions).  
- Recognize the importance of channel integration to connect bots with various communication platforms.  
- For the AI-900 exam, focus on the high-level concepts of Azure Bot Service, Bot Framework SDK, and Bot Framework Composer without needing deep technical details.

## ML Studio

---

### Azure Machine Learning Service

**Timestamp**: 01:26:45 – 01:28:10

**Key Concepts**  
- Azure Machine Learning Service is the modern, preferred service for running AI/ML workloads on Azure.  
- There is a classic version of the service, but it has severe limitations and is not transferable to the new service; it should be avoided for exam purposes.  
- Azure Machine Learning Studio refers to the new service’s interface for building and managing ML workflows.  
- Supports building flexible automated ML pipelines using Python or R.  
- Supports deep learning workloads, including TensorFlow.  
- Allows creation and use of Jupyter Notebooks for building and documenting ML models.  
- Azure Machine Learning SDK for Python enables interaction with the service and supports ML Ops (end-to-end automation of ML pipelines including CI/CD, training, and inference).  
- Azure Machine Learning Designer provides a drag-and-drop interface to visually build, test, and deploy ML models/pipelines.  
- Includes a data labeling service to assemble human teams for labeling training data.  
- Responsible machine learning features include model fairness metrics and mitigation of unfairness, though these features are still developing.  

**Definitions**  
- **Azure Machine Learning Service**: A cloud service that simplifies running AI and ML workloads, enabling automated ML pipelines, deep learning, and collaboration.  
- **Azure Machine Learning Studio**: The web-based interface for the new Azure Machine Learning Service used to create and manage ML experiments and pipelines.  
- **Azure Machine Learning SDK for Python**: A software development kit designed to interact programmatically with Azure Machine Learning Service, supporting ML Ops.  
- **Azure Machine Learning Designer**: A drag-and-drop visual tool to build, test, and deploy ML pipelines without extensive coding.  
- **Responsible Machine Learning**: Practices and tools aimed at ensuring model fairness and reducing bias through disparity metrics and mitigation techniques.  

**Key Facts**  
- The classic Azure Machine Learning Service is still accessible but has severe limitations and no migration path to the new service.  
- Automated ML pipelines can be built using Python or R.  
- Deep learning frameworks like TensorFlow are supported.  
- Jupyter Notebooks can be created and used within the service for model development and documentation.  
- ML Ops capabilities include automation of training, inference, and CI/CD pipelines.  
- The data labeling service allows human-in-the-loop labeling for training data.  
- Responsible AI features are integrated but still in early stages at the time of recording.  

**Examples**  
- None specifically mentioned in this section.  

**Key Takeaways 🎯**  
- Focus on the new Azure Machine Learning Service and avoid the classic version for exam relevance.  
- Understand the components: Studio (UI), SDK for Python (programmatic access), Designer (visual pipeline building), and data labeling service.  
- Know that the service supports automated ML pipelines, deep learning, and ML Ops for end-to-end model lifecycle management.  
- Be aware of responsible machine learning concepts as part of Microsoft’s AI ethics initiatives, even if still evolving.

---

### Studio Overview

**Timestamp**: 01:28:10 – 01:29:39

**Key Concepts**  
- Azure Machine Learning Studio provides a drag-and-drop interface to build, test, and deploy machine learning models and pipelines.  
- Studio integrates tools for responsible machine learning, including fairness metrics and mitigation of bias.  
- The Studio interface includes a left-hand navigation bar with multiple components for authoring, managing, and deploying ML workflows.  
- Authoring tools include notebooks (Jupyter), AutoML, and a visual designer for ML pipelines.  
- Data management includes datasets, data labeling (human + ML-assisted), and data stores.  
- Model management includes a model registry and deployment endpoints accessible via REST API or SDK.  
- Compute resources are categorized into compute instances, compute clusters, deployment targets, and attached compute resources.  

**Definitions**  
- **Notebooks**: Jupyter notebooks or IDEs used to write Python code for building ML models within the Studio.  
- **AutoML**: Automated machine learning process that builds and trains ML models with minimal user input; limited to three model types.  
- **Designer**: Visual drag-and-drop tool to create end-to-end ML pipelines.  
- **Datasets**: Uploaded data used for training and experiments.  
- **Pipelines**: ML workflows created or used in the designer.  
- **Model Registry**: Repository of trained models ready for deployment.  
- **Endpoints**: Hosted deployment of models accessible via REST API or SDK for inference.  
- **Compute Instances**: Development workstations for data scientists to work on data and models.  
- **Compute Clusters**: Scalable clusters of VMs for on-demand processing and experimentation.  
- **Attached Compute**: Links to existing Azure compute resources like VMs or Databricks clusters.  
- **Data Labeling**: Human-in-the-loop ML-assisted labeling service for supervised learning datasets.  

**Key Facts**  
- AutoML currently supports only three types of models.  
- Compute instances can be accessed directly within the Studio using Jupyter Labs, VS Code, RStudio, or Terminal.  
- Model endpoints enable access to deployed models via REST API or SDK.  
- Data labeling combines human effort with ML assistance to improve training data quality.  
- Studio integrates with external services such as Azure Synapse Analytics.  

**Examples**  
- Using notebooks to write Python code for ML model development.  
- Using the visual designer to drag-and-drop components to build ML pipelines.  
- Deploying models to endpoints for real-time inference.  
- Managing compute resources for development, training, and deployment within the Studio.  

**Key Takeaways 🎯**  
- Understand the main components of Azure ML Studio: authoring (notebooks, AutoML, designer), data management, model registry, endpoints, and compute resources.  
- Remember that AutoML is automated but limited in model types.  
- Know that compute instances and clusters support development and scalable processing, accessible directly in Studio.  
- Data labeling is a hybrid human + ML process critical for supervised learning.  
- Model deployment creates endpoints accessible via REST API or SDK for inference tasks.  
- Familiarize yourself with the Studio’s left-hand navigation bar structure as it organizes these components.

---

### Studio Compute

**Timestamp**: 01:29:39 – 01:30:48

**Key Concepts**  
- Types of compute available in Azure Machine Learning Studio  
- Compute instances as development workstations for data scientists  
- Compute clusters as scalable VM clusters for on-demand processing  
- Deployment targets for predictive services using trained models  
- Attaching existing Azure compute resources (e.g., Azure VMs, Azure Databricks clusters)  
- Integration with development environments like Jupyter Labs, VS Code, RStudio, and Terminal  

**Definitions**  
- **Compute Instances**: Development workstations in Azure ML Studio used by data scientists to work with data and models interactively.  
- **Compute Clusters**: Scalable clusters of virtual machines (VMs) used for running experiments and processing workloads on demand.  
- **Attach Compute**: Linking existing Azure compute resources (such as Azure VMs or Azure Databricks clusters) to the Azure ML workspace for use in experiments and deployments.  

**Key Facts**  
- Four main compute categories in Azure ML Studio:  
  1. Compute Instances  
  2. Compute Clusters  
  3. Deployment Targets (for predictive services)  
  4. Attached Compute (existing Azure resources)  
- Compute instances can be accessed directly within Azure ML Studio using Jupyter Labs, Jupyter Notebooks, VS Code, RStudio, or Terminal.  
- For inference (making predictions), Azure Kubernetes Service (AKS) or Azure Container Instances (ACI) are typically used, though their exact location in the studio interface was uncertain.  

**Examples**  
- Using compute instances as development workstations directly in Azure ML Studio with Jupyter or VS Code.  
- Attaching Azure Databricks clusters as compute resources for experimentation or deployment.  

**Key Takeaways 🎯**  
- Understand the four types of compute in Azure ML Studio and their purposes.  
- Remember that compute instances serve as interactive development environments for data scientists.  
- Compute clusters provide scalable resources for running experiments and training.  
- Deployment targets are used to host predictive services based on trained models.  
- Attached compute allows leveraging existing Azure compute resources within the ML workspace.  
- Familiarize yourself with the integration of compute instances with common IDEs and notebooks inside the studio.  
- Know that inference workloads typically use AKS or ACI, even if not explicitly shown in the compute list.

---

### Studio Data Labeling

**Timestamp**: 01:30:48 – 01:31:45

**Key Concepts**  
- Data labeling in Azure Machine Learning Studio is used to prepare ground truth for supervised learning.  
- Two main data labeling options:  
  - Human-in-the-loop labeling (manual human annotation)  
  - Machine learning assisted data labeling (automated labeling with ML assistance)  
- Labeled data can be exported anytime for machine learning experimentation.  
- Common export format for image labels is COCO format, which integrates well with Azure ML datasets.  
- Labeling tasks are performed via a UI where users click buttons to apply labels.

**Definitions**  
- **Human-in-the-loop labeling**: A process where human annotators manually label data to create ground truth.  
- **Machine learning assisted data labeling**: Using ML models to assist or automate the labeling process, speeding up annotation.  
- **COCO format**: A standardized dataset format for image labeling that is compatible with Azure ML training workflows.

**Key Facts**  
- Users often export labeled data multiple times to train different models without waiting for the entire dataset to be labeled.  
- COCO format is preferred for image label exports in Azure ML Studio.  

**Examples**  
- None specifically mentioned beyond the general use of UI buttons for labeling tasks.

**Key Takeaways 🎯**  
- Understand the two labeling approaches and when to use each (human vs ML-assisted).  
- Remember that labeled data can be exported repeatedly during model development.  
- Know that COCO format is the standard for image label exports in Azure ML Studio.  
- Familiarize yourself with the labeling UI concept for practical application.

---

### Data Stores

**Timestamp**: 01:31:45 – 01:32:34

**Key Concepts**  
- Azure ML Data Store securely connects Azure Machine Learning to various Azure storage services without exposing authentication credentials or risking data integrity.  
- Multiple types of data stores are available in Azure ML Studio to support different data storage needs.  
- Azure ML datasets facilitate easy registration, versioning, and integration of datasets for ML workloads.

**Definitions**  
- **Azure ML Data Store**: A secure connection interface in Azure Machine Learning that links to Azure storage services while protecting authentication credentials and data integrity.  
- **Azure Blob Storage**: Object storage distributed across many machines, suitable for unstructured data.  
- **Azure File Share**: A mountable file share accessible via SMB and NFS protocols.  
- **Azure Data Lake Storage Gen2**: Blob storage optimized for large-scale big data analytics.  
- **Azure SQL**: Fully managed relational SQL database service.  
- **Azure Postgres Database**: Open source relational database, often considered object-relational, favored by developers.  
- **Azure MySQL**: Popular open source relational database, considered a pure relational database.

**Key Facts**  
- Azure ML Data Store protects authentication credentials and maintains the integrity of the original data source.  
- Azure ML datasets support metadata association and dataset versioning (current and latest versions).  
- Sample code is available via the Azure ML SDK to import datasets into Jupyter Notebooks, facilitating quick startup.

**Examples**  
- Azure Blob Storage, Azure File Share, Azure Data Lake Storage Gen2, Azure SQL, Azure Postgres, and Azure MySQL are all examples of data stores accessible through Azure ML Data Store.

**Key Takeaways 🎯**  
- Remember that Azure ML Data Store acts as a secure gateway to Azure storage services without exposing credentials.  
- Know the different types of Azure data stores and their typical use cases (object storage, file shares, big data analytics, relational databases).  
- Azure ML datasets enable easy dataset registration, metadata management, and version control, which is critical for reproducible ML workflows.  
- Utilize provided sample code in Azure ML SDK to streamline dataset loading into notebooks for experimentation and training.

---

### Datasets

**Timestamp**: 01:32:34 – 01:33:44

**Key Concepts**  
- Azure ML datasets simplify registering and managing datasets for machine learning workloads.  
- Datasets can have metadata and support multiple versions (current and latest).  
- Sample code is available in the Azure ML SDK for easy integration into Jupyter Notebooks.  
- Dataset profiling generates summary statistics and data distributions, requiring a compute instance.  
- Open datasets are publicly hosted, curated datasets useful for learning and quick experimentation.  

**Definitions**  
- **Azure ML Dataset**: A registered dataset in Azure Machine Learning that includes metadata and versioning to facilitate ML workflows.  
- **Dataset Profile**: A generated summary report of a dataset’s statistics and distributions, stored typically in Blob Storage.  
- **Open Datasets**: Publicly available datasets curated by Azure, designed for learning and experimenting with ML models.  

**Key Facts**  
- Multiple versions of datasets can be maintained (e.g., current version vs. latest version).  
- Dataset profiles require a compute instance to generate.  
- Open datasets are integrated into Azure ML for easy addition to data stores.  
- Common open datasets mentioned include MNIST and COCO, widely used for ML learning.  

**Examples**  
- MNIST and COCO datasets are cited as common open datasets used for learning ML.  

**Key Takeaways 🎯**  
- Know how Azure ML datasets support versioning and metadata to manage data effectively.  
- Remember that dataset profiling is a useful feature for understanding data but requires compute resources.  
- Open datasets provide a quick way to start ML projects without needing to source your own data.  
- Familiarity with common datasets like MNIST and COCO can be beneficial for exam scenarios involving dataset examples.

---

### Experiments

**Timestamp**: 01:33:44 – 01:34:16

**Key Concepts**  
- Azure ML Experiments are logical groupings of runs.  
- A run represents executing an ML task on a virtual machine or container.  
- Runs can include various ML tasks such as scripts for preprocessing, AutoML, or training pipelines.  
- Inference (model predictions after deployment) is not tracked as part of experiments/runs.

**Definitions**  
- **Azure ML Experiment**: A container or logical grouping that organizes multiple runs of machine learning tasks.  
- **Run**: The execution instance of an ML task on compute resources like VMs or containers.

**Key Facts**  
- Experiments track runs related to training and preprocessing but exclude inference calls after deployment.  
- Runs can be of different types but are unified under the experiment for organization.

**Examples**  
- None mentioned specifically in this time range.

**Key Takeaways 🎯**  
- Remember that Azure ML Experiments group runs, which are executions of ML tasks.  
- Runs include preprocessing, AutoML, and training, but not inference requests after deployment.  
- Understanding the distinction between runs (training/preprocessing) and inference (post-deployment predictions) is important for exam scenarios.

---

### Pipelines

**Timestamp**: 01:34:16 – 01:35:23

**Key Concepts**  
- Azure ML Pipelines represent an executable workflow for a complete machine learning task.  
- Pipelines consist of a series of independent steps, allowing parallel work and efficient resource use.  
- Steps can be run on different compute types/sizes tailored to their needs.  
- When rerunning pipelines, only updated or changed steps are executed; unchanged steps are skipped.  
- Published pipelines can be triggered via REST endpoints from any platform or stack.  
- Pipelines can be built either visually using Azure ML Designer or programmatically via the Azure ML Python SDK.  

**Definitions**  
- **Azure ML Pipelines**: Executable workflows that encapsulate a complete machine learning task as a series of steps.  
- **Step**: An independent subtask within a pipeline that can be run separately and on different compute resources.  
- **Azure ML Designer**: A visual drag-and-drop interface to build ML pipelines without coding.  

**Key Facts**  
- Azure ML Pipelines are distinct from Azure DevOps Pipelines and Data Factory Pipelines.  
- Independent steps enable multiple data scientists to collaborate without overloading compute resources.  
- REST endpoints allow rerunning pipelines remotely after publishing.  
- Two main ways to build pipelines:  
  1. Azure ML Designer (no code, visual)  
  2. Azure ML Python SDK (programmatic)  

**Examples**  
- Code example mentioned (not detailed) showing creation of steps and assembling them into a pipeline using Python SDK.  
- Azure ML Designer interface shows a visual pipeline with drag-and-drop pre-built assets.  

**Key Takeaways 🎯**  
- Understand the difference between Azure ML Pipelines and other Azure pipeline services (Azure DevOps, Data Factory).  
- Remember that pipelines are modular workflows made of independent steps that optimize compute usage and collaboration.  
- Know that rerunning pipelines only executes changed steps, saving time and resources.  
- Be familiar with the two pipeline building approaches: visual (Designer) and code-based (Python SDK).  
- After publishing, pipelines can be triggered via REST endpoints, enabling integration with other platforms.  
- Azure ML Designer requires a solid understanding of ML pipelines to use effectively despite its no-code approach.

---

### ML Designer

**Timestamp**: 01:35:23 – 01:36:07

**Key Concepts**  
- Azure Machine Learning Designer enables building ML pipelines visually without coding.  
- The Designer provides a drag-and-drop interface with pre-built assets for pipeline creation.  
- It requires a good understanding of ML pipelines to use effectively.  
- After training, you can create inference pipelines and choose between real-time or batch inference, with the option to toggle later.

**Definitions**  
- **Azure ML Designer**: A visual tool in Azure Machine Learning for quickly building ML pipelines without writing code.  
- **Inference Pipeline**: A pipeline created after training that is used for deploying models for real-time or batch predictions.

**Key Facts**  
- The Designer interface shows a visual pipeline and a left-hand pane with pre-built assets to drag into the pipeline.  
- You can toggle inference pipeline modes between real-time and batch after creation.  
- For the AI-900 exam, deep technical details of Azure ML Designer are not required.

**Examples**  
- None mentioned specifically for ML Designer beyond the description of the drag-and-drop interface.

**Key Takeaways 🎯**  
- Know that Azure ML Designer is a no-code, visual pipeline builder in Azure ML.  
- Understand that it supports building both training and inference pipelines.  
- Remember the ability to toggle inference pipeline modes (real-time vs batch).  
- Focus on conceptual understanding rather than deep technical details for the AI-900 exam.

---

### Model Registry

**Timestamp**: 01:36:07 – 01:36:34

**Key Concepts**  
- Azure Machine Learning Model Registry is used to create, manage, and track registered models.  
- Models can be registered under the same name with incremental versioning.  
- Metadata tags can be added to models to facilitate searching.  
- The registry simplifies sharing, deploying, and downloading models.

**Definitions**  
- **Model Registry**: A service in Azure ML that allows version control and management of machine learning models by registering them with names and versions, along with metadata tagging.

**Key Facts**  
- Registering a model with an existing name automatically creates a new version.  
- Tags can be used to organize and search models efficiently.  

**Examples**  
- None mentioned specifically for Model Registry in this segment.

**Key Takeaways 🎯**  
- Understand that the Model Registry supports versioning by name, which is critical for managing model lifecycle.  
- Remember to use metadata tags for easier model discovery.  
- The Model Registry is essential for sharing and deploying models in Azure ML workflows.

---

### Endpoints

**Timestamp**: 01:36:34 – 01:37:50

**Key Concepts**  
- Azure ML endpoints enable deployment of machine learning models as web services.  
- Two main types of endpoints:  
  - Real-time endpoints for invoking ML models remotely.  
  - Pipeline endpoints for invoking ML pipelines remotely with parameterization for batch scoring and retraining.  
- Real-time endpoints run on Azure Kubernetes Service (AKS) or Azure Container Instance (ACI).  
- Pipeline endpoints support managed repeatability in batch and retraining scenarios.  
- Deployed endpoints appear under AKS or ACI in the Azure portal, not consolidated in Azure ML Studio.  
- Testing real-time endpoints can be done by sending single or batch requests (e.g., CSV format).  

**Definitions**  
- **Azure ML Endpoint**: A web service interface that allows remote access to deployed machine learning models or pipelines.  
- **Real-time Endpoint**: An endpoint providing immediate, remote access to invoke a machine learning model hosted on AKS or ACI.  
- **Pipeline Endpoint**: An endpoint that allows remote invocation of an ML pipeline, supporting parameterization for batch processing and retraining workflows.  
- **Azure Kubernetes Service (AKS)**: A managed container orchestration service used to host real-time ML endpoints.  
- **Azure Container Instance (ACI)**: A lightweight container hosting service used for deploying real-time ML endpoints.  

**Key Facts**  
- Workflow for deploying models includes: registering the model, preparing an entry script, preparing inference configuration, deploying locally, choosing compute target, deploying to cloud, and testing the web service.  
- Real-time endpoints can be tested with single or batch requests via a form interface in Azure.  
- Endpoints deployed to AKS or ACI are visible under those services in the Azure portal, not directly under Azure ML Studio.  

**Examples**  
- Testing a real-time endpoint by sending a single request or a batch request in CSV format through a built-in form.  

**Key Takeaways 🎯**  
- Understand the difference between real-time and pipeline endpoints and their use cases.  
- Remember that real-time endpoints run on AKS or ACI and are managed outside of Azure ML Studio in the Azure portal.  
- Know the deployment workflow steps for ML models before creating endpoints.  
- Be familiar with testing endpoints using single or batch requests to validate deployment.

---

### Notebooks

**Timestamp**: 01:37:50 – 01:38:41

**Key Concepts**  
- Azure provides a built-in Jupyter-like notebook editor within Azure Machine Learning Studio.  
- Compute instances are chosen to run notebooks in Azure ML.  
- Users select a kernel, which includes preloaded programming languages and libraries tailored for different use cases (Jupyter kernel concept).  
- Notebooks can be opened and edited in more familiar environments such as VS Code, Jupyter Notebook Classic, or Jupyter.  
- The VS Code experience is identical to the Azure ML Studio notebook editor.  

**Definitions**  
- **Kernel**: A preloaded programming language environment with libraries that supports running code in notebooks (Jupyter kernel concept).  

**Key Facts**  
- Azure ML Studio’s notebook editor is built-in but may not be preferred by all users.  
- Alternative notebook environments (VS Code, Jupyter Classic) can be used seamlessly with Azure ML notebooks.  

**Examples**  
- None specifically mentioned beyond the general use of notebooks and opening them in VS Code or Jupyter.  

**Key Takeaways 🎯**  
- Understand that Azure ML Studio includes a built-in Jupyter-like notebook editor but you are not limited to it.  
- Know how to select compute instances and kernels to run notebooks in Azure ML.  
- Be aware that you can open Azure ML notebooks in familiar IDEs like VS Code or Jupyter for a better user experience.  
- The VS Code notebook experience mirrors the Azure ML Studio notebook editor exactly.  
- For exams, focus on the flexibility of notebook environments and the kernel concept within Azure ML.

## AutoML

---

### Introduction to AutoML

**Timestamp**: 01:38:41 – 01:41:15

**Key Concepts**  
- Azure Automated Machine Learning (AutoML) automates the process of creating ML models.  
- AutoML workflow: supply a dataset → choose a task type → AutoML trains and tunes the model automatically.  
- Main task types supported by AutoML:  
  - Classification (binary and multi-class)  
  - Regression  
  - Time series forecasting  
- Classification and regression are types of supervised learning.  
- Time series forecasting is treated as a multivariate regression problem with additional contextual variables.  
- AutoML includes built-in data guardrails to ensure high-quality input data during automatic featurization.

**Definitions**  
- **AutoML**: A system that automates the training and tuning of machine learning models based on user-provided data and task type.  
- **Classification**: Supervised learning task where the model predicts discrete categories/classes for new data based on training data.  
- **Binary Classification**: Classification with two possible labels (e.g., true/false, 0/1).  
- **Multi-class Classification**: Classification with more than two possible labels (e.g., happy, sad, mad, rad).  
- **Regression**: Supervised learning task where the model predicts continuous numerical values.  
- **Time Series Forecasting**: Predicting future values based on past time-dependent data, treated as a multivariate regression problem incorporating multiple contextual variables.  
- **Data Guardrails**: Automated checks run by AutoML during featurization to ensure data quality, such as validation split handling, missing value imputation, and high cardinality feature detection.  
- **High Cardinality Feature**: A feature with many unique values/dimensions, which can make data processing difficult.

**Key Facts**  
- Deep learning can be enabled in classification tasks; recommended to use GPU compute instances for deep learning workloads.  
- Time series forecasting supports advanced configurations like holiday detection, deep learning neural networks, auto ARIMA, profit forecast TCN, grouping, rolling origin cross-validation, and configurable lags.  
- AutoML automatically handles missing feature values and detects high cardinality features to maintain data quality.  
- Validation split handling is applied automatically to improve model performance.

**Examples**  
- Binary classification example: label is either true/false or 0/1.  
- Multi-class classification example: labels like happy, sad, mad, rad (noting a spelling correction from "mad" to "mad" was mentioned).  
- Time series forecasting use cases: forecasting revenue, inventory, sales, or customer demand.

**Key Takeaways 🎯**  
- Understand the three main AutoML task types and their differences: classification, regression, and time series forecasting.  
- Remember that classification and regression are supervised learning tasks, with classification predicting categories and regression predicting continuous values.  
- Time series forecasting is a specialized regression problem that incorporates multiple contextual variables and advanced modeling techniques.  
- AutoML automates many data preparation steps, including validation splitting, missing value imputation, and detecting problematic features like high cardinality.  
- Enabling deep learning requires appropriate compute resources (GPU).  
- Be familiar with the concept of data guardrails as a quality control mechanism within AutoML.

---

### Data Guard Rails

**Timestamp**: 01:41:15 – 01:42:01

**Key Concepts**  
- Data Guard Rails are a sequence of automated checks run by AutoML during training when automatic featurization is enabled.  
- Their purpose is to ensure high-quality input data is used for model training.  
- These checks include validation split handling, missing feature value imputation, and high cardinality feature detection.

**Definitions**  
- **Data Guard Rails**: Automated validation steps within AutoML that verify the quality and suitability of input data before and during model training.  
- **High Cardinality Feature**: A feature with a very large number of unique values or dimensions, which can make data processing difficult or inefficient.

**Key Facts**  
- Validation split handling ensures input data is properly split for validation to improve model performance.  
- Missing feature value imputation detects and handles any missing values in training data; in the example, no missing values were found.  
- High cardinality feature detection analyzes inputs to identify features that may be too complex or dense; no high cardinality features were detected in the example.

**Examples**  
- None specifically mentioned beyond the checks themselves (e.g., no missing values found, no high cardinality features detected).

**Key Takeaways 🎯**  
- Remember that Data Guard Rails are integral to AutoML’s automatic featurization process and help maintain data quality.  
- Be familiar with the types of checks performed: validation splits, missing value imputation, and high cardinality detection.  
- Understanding what high cardinality means and why it matters is important for exam questions related to data preprocessing and feature engineering.  
- These guardrails help prevent common data issues that could degrade model performance or cause training failures.

---

### Automatic Featurization

**Timestamp**: 01:42:01 – 01:43:53

**Key Concepts**  
- Automatic featurization in AutoML involves applying various scaling, normalization, and dimensionality reduction techniques automatically during model training.  
- Dimension reduction helps manage complex data with many features or categories by reducing the number of dimensions to avoid overwhelming the model.  
- Different scalers and transformers are used depending on the data characteristics, including standard scaling, min/max scaling, max absolute scaling, robust scaling, PCA, truncated SVD, and sparse normalization.

**Definitions**  
- **StandardScaler**: Standardizes features by removing the mean and scaling to unit variance.  
- **MinMaxScaler**: Scales features by transforming each feature to a given range based on the column’s minimum and maximum values.  
- **MaxAbsScaler**: Scales each feature by its maximum absolute value.  
- **RobustScaler**: Scales features using statistics that are robust to outliers, based on quantile ranges.  
- **PCA (Principal Component Analysis)**: A linear dimensionality reduction technique using singular value decomposition to project data into a lower-dimensional space.  
- **Truncated SVD (Singular Value Decomposition)**: Performs linear dimensionality reduction without centering data, allowing efficient processing of sparse matrices.  
- **Sparse Normalization**: Normalizes each sample (row) independently, using norms like L1 or L2.

**Key Facts**  
- PCA is useful when data has many labels or categories (e.g., 20, 30, 40 labels) to reduce complexity.  
- Truncated SVD differs from PCA by not centering the data before decomposition, making it suitable for sparse data.  
- AutoML automates all these preprocessing steps, saving users from manual feature scaling and dimensionality reduction.  
- Although detailed knowledge of each scaler or transformer might not be tested, understanding that AutoML handles these processes is important.

**Examples**  
- None specifically mentioned beyond general references to data with many labels/categories requiring dimension reduction.

**Key Takeaways 🎯**  
- Remember that Azure AutoML automatically applies appropriate feature scaling and dimensionality reduction techniques during training.  
- Know the purpose of common scalers (StandardScaler, MinMaxScaler, MaxAbsScaler, RobustScaler) and dimension reduction methods (PCA, Truncated SVD).  
- Understand that dimension reduction is critical when dealing with datasets having many categories or features to prevent model overwhelm.  
- Exam questions may not focus on the detailed mechanics of each scaler but expect awareness of AutoML’s automatic preprocessing capabilities.

---

### Model Selection

**Timestamp**: 01:43:53 – 01:44:57

**Key Concepts**  
- Model Selection is the process of choosing the best statistical model from a set of candidate models.  
- Azure AutoML automates model selection by testing many different machine learning algorithms and recommending the best performing model(s).  
- Ensemble models, such as Voting Ensemble, combine multiple weaker models to create a stronger predictive model.  
- Model explainability (Machine Learning Explainability - MXL) helps interpret and understand model behavior and performance.

**Definitions**  
- **Model Selection**: The task of selecting a statistical model from a set of candidate models based on performance.  
- **Voting Ensemble**: An ensemble algorithm that combines two or more weak ML models to form a stronger model.  
- **Machine Learning Explainability (MXL)**: The process of explaining and interpreting machine learning or deep learning models to better understand their behavior and decisions.

**Key Facts**  
- Azure AutoML can evaluate a large number of models (example given: 53 models across 3 pages).  
- The primary metric shown in Azure AutoML results indicates model performance; the highest value usually points to the best model to use.  
- After selecting the top candidate model, Azure AutoML provides explanations such as aggregate and individual feature importance, model performance, and dataset exploration.

**Examples**  
- The top candidate model chosen by Azure AutoML in the example was a Voting Ensemble model.

**Key Takeaways 🎯**  
- On the exam, understand that Model Selection involves choosing the best model from many candidates based on performance metrics.  
- Azure AutoML simplifies this by automating model testing and selection.  
- Ensemble models like Voting Ensemble are important to know as they combine weaker models to improve accuracy.  
- Use the primary metric to identify the best model.  
- Machine Learning Explainability (MXL) is crucial for interpreting model results and understanding feature importance.  
- If unsure, go with the top recommended model from AutoML rather than manually tweaking models unless you have expertise.

---

### Explanation

**Timestamp**: 01:44:57 – 01:45:51

**Key Concepts**  
- Explainability (also called Machine Learning Explainability or MLX) is the process of interpreting and understanding ML or deep learning models.  
- MLX helps developers understand model behavior and the factors influencing model outcomes.  
- After selecting a top candidate model (e.g., via Azure AutoML), explanations can be generated to explore model internals such as feature importance and model performance.  
- Aggregate feature importance shows which features most influence the model’s predictions.

**Definitions**  
- **Explainability (MLX)**: The process of explaining and interpreting machine learning or deep learning models to better understand their behavior and decision-making.  
- **Aggregate Feature Importance**: A summary measure indicating which features have the greatest overall impact on the model’s predictions.

**Key Facts**  
- Explainability is available after selecting the top candidate model in Azure AutoML.  
- Explanation tools can show dataset exploration, model performance, aggregate and individual feature importance.  
- Example dataset referenced: Diabetes dataset, where BMI is a highly influential feature.  
- The primary metric is the parameter used during model training to optimize and select the best model.

**Examples**  
- Diabetes dataset: BMI identified as a major factor influencing the model outcome.

**Key Takeaways 🎯**  
- Understand that explainability (MLX) is crucial for interpreting why a model makes certain predictions.  
- Use explanation features in Azure AutoML to validate and trust your model by reviewing feature importance and model internals.  
- Remember that the primary metric guides model optimization and selection.  
- Practical exam scenarios may involve interpreting feature importance or explaining model behavior using MLX tools.

---

### Primary Metrics

**Timestamp**: 01:45:51 – 01:47:43

**Key Concepts**  
- Primary metric is the parameter used during model training to optimize model performance.  
- Different primary metrics are suited for different ML task types: classification, regression, and time series.  
- Primary metric can be auto-detected by Azure AutoML or manually overridden.  
- Choice of primary metric depends on dataset characteristics such as size and balance.  

**Definitions**  
- **Primary Metric**: The metric selected to guide model training optimization, influencing how the model evaluates performance during training.  
- **Well-balanced dataset**: A dataset where class labels are evenly distributed (e.g., 100 samples of class A and 100 of class B).  
- **Imbalanced dataset**: A dataset where one class label significantly outnumbers another (e.g., 10 samples of class A and 500 of class B).  

**Key Facts**  
- For classification tasks with well-balanced datasets, metrics like Accuracy, Average Precision Score Weighted, and Norm Macro Recall are suitable.  
- For classification tasks with imbalanced datasets, metrics like AUC Weighted are preferred.  
- Regression metrics vary by range of target values:  
  - Wide range: Spearman correlation, R2 score (used in airline delay, salary estimation, bug resolution).  
  - Smaller range: Normalized Root Mean Square Error (RMSE), Normalized Mean Absolute Error (MAE) (used in price predictions, review tip score predictions).  
- Time series forecasting uses similar metrics adapted to the time series context.  

**Examples**  
- Classification with well-balanced data: Image classification, sentiment analysis, churn prediction.  
- Classification with imbalanced data: Fraud detection, anomaly detection, spam detection.  
- Regression with wide range targets: Airline delay prediction, salary estimation.  
- Regression with smaller range targets: Price prediction, review tip score prediction.  

**Key Takeaways 🎯**  
- Understand the importance of selecting the correct primary metric based on task type and dataset balance.  
- Know that Azure AutoML can auto-detect the primary metric but manual override is possible and sometimes necessary.  
- Recognize common primary metrics used for classification (accuracy, AUC), regression (R2, RMSE), and time series forecasting.  
- Be able to identify when to use metrics suited for balanced vs. imbalanced datasets.  
- Remember practical examples linked to metric choices to help contextualize exam questions.

---

### Validation Type

**Timestamp**: 01:47:43 – 01:48:14

**Key Concepts**  
- Model validation compares training dataset results to test dataset results.  
- Validation occurs after the model has been trained.  
- Different validation types can be selected when setting up an ML model.

**Definitions**  
- **Model Validation**: The process of evaluating a trained model by comparing its performance on training data versus test data to assess generalization.  
- **Validation Types**: Methods used to split and evaluate data during model validation, including options like auto, K-fold cross-validation, Monte Carlo cross-validation, and train-validation split.

**Key Facts**  
- Common validation options include:  
  - Auto  
  - K-fold cross-validation  
  - Monte Carlo cross-validation  
  - Train-validation split  
- The speaker notes that detailed understanding of these validation types is likely not required for the AI-900 exam, but awareness of their existence is important.

**Examples**  
- None mentioned specifically for validation types.

**Key Takeaways 🎯**  
- Understand that model validation is a post-training evaluation step comparing training and test results.  
- Be aware of common validation methods (K-fold, Monte Carlo, train-validation split), even if deep details are not required.  
- For AI-900 exam, focus on the concept of validation rather than the intricate mechanics of each validation type.

## Custom Vision

---

### Introduction to Custom Vision

**Timestamp**: 01:48:14 – 01:48:58

**Key Concepts**  
- Custom Vision is a fully managed, no-code service for building custom image classification and object detection ML models quickly.  
- It allows users to upload labeled images or add tags to unlabeled images to train the model.  
- Training involves teaching Custom Vision the concepts you care about using labeled images.  
- The service provides a simple REST API to tag images with the trained custom model for evaluation.

**Definitions**  
- **Custom Vision**: A Microsoft Azure service that enables users to create custom image classification and object detection models without writing code.  
- **Training**: The process of using labeled images to teach the Custom Vision model to recognize specific concepts.  
- **REST API**: An interface provided by Custom Vision to interact programmatically with the trained model for tagging and evaluating images.

**Key Facts**  
- Custom Vision is hosted on its own isolated domain: www.customvision.ai.  
- It supports both bringing your own labeled images and quickly adding tags to unlabeled images.  
- The service is designed for quick model building without requiring coding skills.

**Examples**  
- None explicitly mentioned in this time range.

**Key Takeaways 🎯**  
- Remember that Custom Vision is a no-code, fully managed Azure service for custom image classification and object detection.  
- Know that you can upload labeled images or tag unlabeled images to train your model.  
- Be aware that Custom Vision provides a REST API to use the trained model for image tagging and evaluation.  
- The service is accessible via www.customvision.ai, separate from other Azure services.

---

### Project Types and Domains

**Timestamp**: 01:48:58 – 01:51:54

**Key Concepts**  
- Custom Vision requires creating a project and selecting a project type.  
- Two main project types: **Classification** and **Object Detection**.  
- Classification can be **multi-label** (multiple tags per image) or **multi-class** (only one tag per image).  
- Object Detection involves tagging specific objects within an image using bounding boxes.  
- Choosing a **domain** is essential; domains are Microsoft-managed datasets optimized for different use cases and affect training and inference.  

**Definitions**  
- **Classification (Multi-label)**: Assigning multiple tags to a single image (e.g., image contains both cat and dog).  
- **Classification (Multi-class)**: Assigning only one tag per image (e.g., apple OR banana OR orange).  
- **Object Detection**: Identifying and tagging multiple objects within an image, each with bounding boxes.  
- **Domain**: A Microsoft-managed dataset used to optimize training and inference for specific use cases or data types.  

**Key Facts**  
- Classification domains include:  
  - **General**: Broad range, default if unsure.  
  - **A1**: Better accuracy, longer training time, suited for larger or complex datasets.  
  - **A2**: Good accuracy with faster inference than A1, less training time, recommended for most datasets.  
  - **Food**: Optimized for photographs of dishes or individual fruits/vegetables.  
  - **Landmark**: Optimized for natural/artificial landmarks, works even if slightly obstructed.  
  - **Retail**: Optimized for shopping cart or website images, high precision for apparel categories.  
  - **Compact**: Optimized for real-time classification on edge devices.  

- Object Detection domains include:  
  - **General**: Broad range, default if unsure.  
  - **A1**: Better accuracy and comparable inference time, recommended for larger datasets and difficult scenarios; results may vary ±1% mean average precision.  
  - **Logo**: Optimized for detecting brands and logos.  
  - **Products**: Optimized for detecting and classifying products on shelves.  

- For object detection labeling, Custom Vision can suggest bounding boxes using ML, but manual drawing is also possible.  
- Minimum of **50 images per tag** is required for training.  

**Examples**  
- Multi-label classification example: Image containing both a cat and a dog tagged with both labels.  
- Multi-class classification example: Image tagged as either apple, banana, or orange, but only one tag per image.  
- Object detection example: Drawing bounding boxes around objects in an image, either suggested by ML or manually drawn.  

**Key Takeaways 🎯**  
- Always select the correct project type (classification vs object detection) based on your use case.  
- Understand the difference between multi-label and multi-class classification.  
- Choose the domain that best fits your data and scenario to optimize accuracy and training time.  
- Remember the minimum of 50 images per tag for effective training.  
- Use the ML-assisted bounding box suggestions in object detection to speed up labeling but verify manually.  
- Domains like A1 and A2 balance accuracy and inference time differently—choose based on dataset size and complexity.  
- Retail and food domains provide specialized optimizations for those specific image types.  
- For object detection, expect some variability in results with A1 domain (±1% mean average precision).

---

### Custom Vision Features

**Timestamp**: 01:51:54 – 01:54:32

**Key Concepts**  
- Custom Vision supports image classification and object detection with tagging at image or object level.  
- Minimum of 50 images per tag is required for training.  
- Two training modes: Quick Training (faster, less accurate) and Advanced Training (longer compute time, better accuracy).  
- Evaluation metrics include precision, recall, and mean average precision (mAP).  
- Probability threshold controls when training stops based on evaluation metrics.  
- Smart Labeler (ML-assisted labeling) helps speed up tagging by suggesting labels after some initial training data is loaded.  
- After training, models can be quickly tested with sample images before publishing.  
- Publishing provides a prediction URL for invoking the model.

**Definitions**  
- **Precision**: The accuracy of the model in selecting relevant items (exactness).  
- **Recall**: The sensitivity or true positive rate; how many relevant items are returned.  
- **Mean Average Precision (mAP)**: A combined metric used especially in object detection to evaluate overall model performance.  
- **Smart Labeler (ML-assisted labeling)**: A feature that suggests bounding boxes and labels for unlabeled objects based on learned patterns to accelerate dataset labeling.

**Key Facts**  
- At least 50 images per tag are required to train the model.  
- Quick training is faster but less accurate; advanced training improves accuracy by increasing compute time.  
- Precision and recall metrics vary with each training iteration and guide model improvement.  
- Smart Labeler suggestions are not 100% guaranteed but useful for large datasets.  
- After publishing, a prediction endpoint URL is provided for invoking the model.

**Examples**  
- Upload multiple images and apply single or multiple labels for image classification.  
- For object detection, tags are applied to objects within images using bounding boxes.  
- You can manually draw bounding boxes if automatic detection misses objects.  
- Quick test feature allows uploading an image to see prediction results before publishing.

**Key Takeaways 🎯**  
- Remember the minimum 50 images per tag requirement for training.  
- Understand the difference between quick and advanced training modes and their impact on accuracy and compute time.  
- Know the evaluation metrics: precision, recall, and mean average precision (mAP) — these are likely exam topics.  
- Be familiar with the Smart Labeler feature as an example of ML-assisted labeling to speed up dataset preparation.  
- Know the workflow: upload/tag images → train (quick or advanced) → test → publish → get prediction URL.

## Features of generative AI solutions

---

### AI vs Generative AI

**Timestamp**: 01:54:32 – 01:57:17

**Key Concepts**  
- AI (Artificial Intelligence) involves creating computer systems that perform tasks requiring human intelligence such as problem-solving, decision-making, natural language understanding, speech and image recognition.  
- Traditional AI focuses on interpreting, analyzing, and responding to data or human actions efficiently and accurately.  
- Generative AI is a subset of AI that generates new, original content or data rather than just analyzing existing data.  
- Generative AI uses advanced machine learning techniques, especially deep learning models like GANs (Generative Adversarial Networks), variational autoencoders, and transformer models (e.g., GPT).  
- Applications of generative AI include text generation, image creation, music composition, virtual environment creation, and drug discovery.  
- Differences between regular AI and generative AI can be summarized by their focus (understanding vs creating), data handling (analyzing existing data vs generating new data), and applications (automation and analysis vs creative content generation).

**Definitions**  
- **Artificial Intelligence (AI)**: Development of computer systems capable of performing tasks that normally require human intelligence, such as decision-making and natural language processing.  
- **Generative AI**: A subset of AI focused on creating new, realistic, and novel content or data, including text, images, music, and more.  
- **Generative Adversarial Networks (GANs)**: A type of deep learning model used in generative AI to create realistic data by pitting two neural networks against each other.  
- **Transformer Models (e.g., GPT)**: Deep learning architectures designed to handle sequential data and generate human-like text by understanding context.

**Key Facts**  
- Traditional AI applications include expert systems, natural language processing, speech recognition, robotics, customer service chatbots, recommendation systems, autonomous vehicles, and medical diagnosis.  
- Generative AI applications include tools like GPT (text generation), DALL-E (image creation), and models that compose music.  
- Regular AI analyzes and bases decisions on existing data; generative AI uses data to produce new, previously unseen outputs.  
- Generative AI is increasingly recognized beyond tech circles due to its ability to produce human-like content.  
- Generative AI relies heavily on advanced mathematical techniques from statistics, data science, and machine learning.

**Examples**  
- GPT for text generation  
- DALL-E for image creation  
- Deep learning models for music composition  

**Key Takeaways 🎯**  
- Understand the fundamental difference: Regular AI interprets and analyzes data; generative AI creates new content.  
- Remember key generative AI models: GANs, variational autoencoders, and transformers like GPT.  
- Be able to identify applications typical for each: traditional AI for automation and analysis; generative AI for creative content and synthetic data.  
- Recognize generative AI’s growing impact and its basis in advanced machine learning techniques.  
- For exam purposes, focus on the three comparison areas: functionality, data handling, and applications between AI and generative AI.

---

### What is a LLM Large Language Model

**Timestamp**: 01:57:17 – 01:58:58

**Key Concepts**  
- Large Language Models (LLMs) are complex automatic systems that recognize patterns and make predictions based on language data.  
- LLMs are trained on massive datasets consisting of diverse text sources such as books, articles, and websites.  
- The model learns language patterns including grammar, word usage, sentence structure, style, and tone.  
- Context understanding is crucial: LLMs consider words in relation to surrounding words and sentences, not in isolation.  
- Text generation is done by predicting the next most likely word repeatedly to form coherent and relevant text.  
- The length of generated text can be controlled by instructions or model limitations.  
- LLMs can be refined and improved over time through feedback and exposure to more data.

**Definitions**  
- **Large Language Model (LLM)**: A machine learning model trained on vast amounts of text data to understand and generate human-like language by recognizing patterns and predicting subsequent words in context.  
- **Prompt**: The initial piece of text given to the model to start the text generation process.

**Key Facts**  
- Training data includes a wide variety of written materials: books, articles, websites, etc.  
- The model learns not just individual words but also grammar, style, tone, and sentence structure.  
- Text generation involves iterative prediction of the next word based on the extended sequence of previous words.  
- Refinement through feedback helps improve the model’s understanding and generation capabilities.

**Examples**  
- None mentioned explicitly in this section.

**Key Takeaways 🎯**  
- Understand that LLMs function by learning language patterns from huge text datasets and use this to predict and generate text.  
- Remember the importance of context in LLMs: they analyze words in relation to surrounding text to maintain coherence.  
- The generation process is sequential, predicting one word at a time to build meaningful text.  
- LLMs are not static; they improve with ongoing feedback and additional data exposure.  
- Be clear on the difference between the training phase (learning patterns) and the generation phase (predicting next words).

---

### Transformer models

**Timestamp**: 01:58:58 – 02:00:14

**Key Concepts**  
- Transformer models are a type of machine learning model designed for natural language processing (NLP) tasks.  
- They use a transformer architecture that is effective for understanding and generating language.  
- The architecture consists of two main components: the encoder and the decoder.  
- Different transformer models specialize in different tasks, such as language understanding or text generation.  
- Tokenization is a crucial preprocessing step that breaks text into smaller units (tokens) for the model to process.

**Definitions**  
- **Transformer model**: A machine learning model architecture particularly suited for NLP tasks, built with encoder and decoder blocks.  
- **Encoder**: The part of the transformer that reads and understands input text by analyzing word meanings and context.  
- **Decoder**: The part that generates new text based on the encoder’s understanding, producing coherent and contextually appropriate sentences.  
- **Tokenization**: The process of splitting text into smaller pieces called tokens (words or parts of words) and assigning each a numerical ID to help the model understand the input.

**Key Facts**  
- Encoder “reads” and comprehends large amounts of text to capture word meanings and context.  
- Decoder “writes” or generates text that flows well and makes sense based on the encoder’s output.  
- BERT is a transformer model specialized in language understanding (used by Google Search).  
- GPT is a transformer model specialized in text generation (writing stories, articles, conversations).  
- Tokenization converts sentences into tokens, each represented by a number (e.g., “I” = 1, “heard” = 2, “a” = 3, etc.).

**Examples**  
- BERT is likened to a librarian who knows where every book is and what’s inside (good at understanding language).  
- GPT is compared to a skilled author who can write stories or conversations (good at creating text).  
- Tokenization example: The sentence “I heard a dog bark loudly at a cat” is split into tokens, each assigned a number for model processing.

**Key Takeaways 🎯**  
- Understand the dual structure of transformer models: encoder (understanding) and decoder (generation).  
- Remember the distinction between BERT (understanding) and GPT (generation) as key examples of transformer models.  
- Tokenization is essential for converting raw text into a format the model can process—breaking sentences into tokens and assigning numerical IDs.  
- Focus on how transformers handle context to produce coherent and contextually relevant text.  
- Be able to explain the role of each component and the practical use cases of different transformer models.

---

### Tokenization

**Timestamp**: 02:00:14 – 02:01:26

**Key Concepts**  
- Tokenization is the process of breaking down sentences into smaller pieces called tokens.  
- Tokens can be whole words or parts of words.  
- Each token is assigned a unique numeric code to help the computer process language.  
- The computer builds a large token dictionary by assigning new numbers to new words it encounters.  
- Tokenization is a foundational step before creating embeddings, which capture the meaning of tokens.

**Definitions**  
- **Tokenization**: The process of chopping a sentence into smaller pieces (tokens), each represented by a unique number, enabling computers to understand and process language.  
- **Token**: A piece of text (word or part of a word) assigned a unique numeric code during tokenization.

**Key Facts**  
- Repeated words use the same token number (e.g., "a" is token 3 every time it appears).  
- New words get new token numbers as the model reads more text (e.g., "meow" might be token 9, "skateboard" token 10).  
- Tokenization results in a sequence of numbers representing the original sentence.  
- This sequence acts like a dictionary mapping words to unique numbers.

**Examples**  
- Sentence: "I heard a dog bark loudly at a cat."  
  - Tokens assigned: I=1, heard=2, a=3, dog=4, bark=5, loudly=6, at=7, cat=8 (example token numbers, cat’s number inferred as 8).  
  - The sentence becomes a series of numbers: 1, 2, 3, 4, 5, 6, 7, 3, 8.  
- New words example: "meow" = 9, "skateboard" = 10 (assigned as new tokens when encountered).

**Key Takeaways 🎯**  
- Understand that tokenization converts text into numeric tokens for computer processing.  
- Remember that tokens can be words or subwords and that repeated words reuse the same token number.  
- The token dictionary grows dynamically as new words are encountered.  
- Tokenization is essential before embeddings, which further encode token meaning.  
- Be able to explain tokenization with the example sentence and token numbering.

---

### Embeddings

**Timestamp**: 02:01:26 – 02:02:46

**Key Concepts**  
- Words are first converted into tokens, each assigned a unique numeric code.  
- Embeddings are numeric vectors assigned to tokens that capture semantic meaning.  
- Similar words have embeddings that are close or similar in vector space.  
- Embeddings can be visualized as points on a multi-dimensional map where related words cluster together.  
- Real language models use embeddings with many dimensions (more than the simple 3D example).  
- Tools like Word2Vec or transformer encoding layers generate these embeddings.

**Definitions**  
- **Token**: A unique numeric code assigned to each word or subword unit in text.  
- **Embedding**: A numeric vector representing a token that encodes semantic information about the word.  
- **Embedding Vector**: A list of numbers (elements) that represent the token in a continuous vector space.

**Key Facts**  
- Example embeddings given are vectors with 3 or 4 elements (e.g., dog = [10, 3, 2], bark = [10, 2, 2], cat = [10, 3, 1], skateboard = [3, 3, 1]).  
- Words with related meanings (dog, bark) have similar embeddings; unrelated words (skateboard) have distinct embeddings.  
- Embeddings help the model understand word similarity by proximity in vector space.

**Examples**  
- Dog token (4) embedding: [10, 3, 2]  
- Bark token (5) embedding: [10, 2, 2]  
- Cat token (8) embedding: [10, 3, 1]  
- Meow token (9) embedding: [10, 2, 1]  
- Skateboard token (10) embedding: [3, 3, 1] (distinct from others)

**Key Takeaways 🎯**  
- Remember that embeddings convert discrete tokens into continuous vectors that capture meaning.  
- Similarity in embeddings reflects semantic or contextual similarity between words.  
- Embeddings form the foundation for how transformers and other language models understand language.  
- Real embeddings have many more dimensions than the simple examples shown.  
- Tools like Word2Vec and transformer encoders are used to generate these embeddings automatically.

---

### Positional encoding

**Timestamp**: 02:02:46 – 02:04:27

**Key Concepts**  
- Positional encoding is used in transformer models to preserve the order of words in a sentence.  
- Without positional encoding, word embeddings lose sequence information, making it impossible to distinguish word order.  
- Positional encoding adds unique positional vectors to each word embedding to represent their position in the sentence.  
- This ensures that the model’s representation of a sentence reflects both the words and their order.  

**Definitions**  
- **Positional encoding**: A technique that adds position-specific vectors to word embeddings so that the model retains information about the order of words in a sequence.  

**Key Facts**  
- Each word embedding is modified by adding a positional vector corresponding to its position in the sentence (e.g., the embedding for the first word "I" is combined with the positional vector for position 1).  
- The same word appearing multiple times (e.g., "a") receives the same positional vector each time it appears in that position.  
- The positional encoding differentiates sentences with the same words but in different orders by producing different overall vector sequences.  

**Examples**  
- Sentence: "I heard a dog bark loudly at a cat"  
  - "I" gets embedding + positional vector for position 1 (i,1)  
  - "heard" gets embedding + positional vector for position 2 (heard,2)  
  - "a" at position 3 gets embedding + positional vector (a,3)  
  - "dog" at position 4, "bark" at 5, "loudly" at 6, "at" at 7, and "cat" at 8 all receive their respective positional vectors.  
- This process ensures the model distinguishes this sentence from any other with the same words in a different order.  

**Key Takeaways 🎯**  
- Always remember that positional encoding is essential for transformers to understand word order, which affects sentence meaning.  
- Positional encoding vectors are added to word embeddings, not replacing them, to maintain both semantic and positional information.  
- Identical words in different positions have different combined embeddings due to positional encoding.  
- Without positional encoding, transformers treat sentences as bags of words, losing sequence context.  
- Understanding positional encoding is critical before moving on to concepts like attention mechanisms in transformers.

---

### Attention

**Timestamp**: 02:04:27 – 02:08:01

**Key Concepts**  
- Attention in transformer models determines the importance of each word/token relative to others in a sentence.  
- Self-attention allows each word to "focus" on other words to understand context.  
- Encoder attention helps represent words as vectors influenced by their context.  
- Decoder attention helps decide which previously generated words are important for predicting the next word.  
- Multi-head attention uses multiple "attention heads" (like multiple flashlights) to capture different aspects of word relationships simultaneously.  
- Attention scores are calculated to assign weights to words, influencing the prediction of the next token.  
- The process is iterative: each predicted word influences the next prediction.  

**Definitions**  
- **Attention**: A mechanism in transformer models that assigns importance weights to words/tokens in relation to others to better understand and generate language.  
- **Self-attention**: A form of attention where each word in a sentence attends to all other words to capture contextual relationships.  
- **Multi-head attention**: Using multiple attention mechanisms in parallel to focus on different features or relationships within the input.  
- **Token embedding**: Numerical vector representation of a word/token capturing its meaning and context.  

**Key Facts**  
- Attention helps differentiate meanings of the same word based on context (e.g., "bark" as a dog sound vs. tree bark).  
- In decoding, attention guides the model to focus on relevant previously generated words to predict the next word.  
- Multi-head attention enriches understanding by examining multiple perspectives (e.g., meaning, grammatical role).  
- Attention scores are calculated multiple times (multi-head) and combined to select the most likely next word.  
- Transformer models like GPT-4 use attention to generate human-like text by learning word sequences and relationships during training.  
- The model does not "understand" or possess intelligence but generates text based on learned statistical patterns.  

**Examples**  
- Sentence: "I heard a dog bark loudly at a cat"  
  - For the word "bark," attention shines brightest on "dog" because they are closely related.  
  - When predicting the next word after "I heard a dog," attention focuses on "heard" and "dog" to predict "bark."  
- Multi-head attention is likened to multiple flashlights each highlighting different aspects of the words (meaning, grammatical role, etc.).  
- GPT-4 uses attention to predict the next word by comparing its guess to the actual word during training, improving accuracy over time.  

**Key Takeaways 🎯**  
- Understand that attention is central to how transformers process and generate language by weighting word importance contextually.  
- Remember self-attention allows each word to consider all others in the sentence for richer context.  
- Multi-head attention provides multiple simultaneous views of word relationships, improving model performance.  
- Attention scores guide the selection of the next word in sequence generation.  
- Transformers do not "know" or "understand" language like humans but excel at pattern recognition through attention mechanisms.  
- Be able to explain the role of attention in both the encoder (contextual word representation) and decoder (predicting next word) stages.  
- Use the example sentence to illustrate how attention focuses on related words to determine meaning and next word prediction.

## Capabilities of Azure OpenAI Service

---

### Introduction to Azure OpenAI Service

**Timestamp**: 02:08:01 – 02:10:29

**Key Concepts**  
- Azure OpenAI Service is a cloud-based platform for deploying and managing OpenAI’s advanced language models.  
- Combines OpenAI’s latest language models with Azure’s security and scalability.  
- Supports multiple model types tailored for different tasks: GPT-4, GPT-3.5, GPT-3.5 Turbo, embedding models, DALL-E, Whisper.  
- Core concepts include prompts and completions, tokens, resources, deployments, prompt engineering, and model selection.  
- Users interact with the service via prompts (text commands) and receive completions (model-generated responses).  
- Tokens are units of text (words or chunks) used to process requests; token count impacts latency and throughput.  
- Deployments require creating resources in an Azure subscription and selecting specific models via deployment APIs.  
- Prompt engineering is critical for guiding model output and requires skillful prompt construction.  
- Azure OpenAI Studio is a web-based environment for deploying, testing, and managing models, supporting generative AI app development.  
- Access to Azure OpenAI Service is currently limited due to high demand and responsible AI commitments, prioritizing existing Microsoft partners and low-risk use cases.

**Definitions**  
- **Azure OpenAI Service**: A cloud platform integrating OpenAI’s language models with Azure’s infrastructure for secure, scalable AI deployments.  
- **Prompt**: A text input provided by the user to the model to generate a response.  
- **Completion**: The text output generated by the model in response to a prompt.  
- **Token**: A unit of text (word or character chunk) used internally by the model to process language.  
- **Deployment**: The process of setting up a specific model instance within Azure OpenAI Service to handle requests.  
- **Prompt Engineering**: The practice of designing and refining prompts to elicit desired responses from AI models.  
- **Azure OpenAI Studio**: A web-based interface for managing, deploying, and testing OpenAI models on Azure.

**Key Facts**  
- GPT-4 and GPT-3.5 models generate text and code from natural language prompts.  
- GPT-3.5 Turbo is optimized for conversational AI and chat applications.  
- Embedding models convert text into numeric sequences for similarity analysis.  
- DALL-E models generate images from textual descriptions and are currently in testing within Azure OpenAI Studio.  
- Token costs vary by task; image generation token cost depends on image size and detail level.  
- Users must create an Azure resource and deploy models via APIs to use the service.  
- Access is restricted and prioritized for partners with low-risk use cases and responsible AI safeguards.

**Examples**  
- Prompt example: Asking the model to count to 5 in a loop results in generated code that performs the task.  
- DALL-E models generate images from word descriptions without manual setup.

**Key Takeaways 🎯**  
- Understand the different model types and their primary use cases (text/code generation, conversation, embeddings, image generation).  
- Know the importance of tokens and how they affect performance and cost.  
- Be familiar with the deployment process: creating Azure resources and deploying models via APIs.  
- Recognize the critical role of prompt engineering in influencing model outputs.  
- Remember that Azure OpenAI Studio is the main interface for working with these models on Azure.  
- Be aware of current access limitations and Microsoft’s responsible AI approach when using Azure OpenAI Service.

---

### Azure OpenAI Studio

**Timestamp**: 02:10:29 – 02:11:44

**Key Concepts**  
- Azure OpenAI Studio is a web-based environment for developers and AI professionals.  
- It enables deployment, testing, and management of large language models (LLMs) on Azure.  
- Supports generative AI app development through interactive tools like the Chat Playground.  
- Access to Azure OpenAI Studio is currently limited due to high demand and responsible AI considerations.  
- Collaborations prioritize existing Microsoft partners, low-risk use cases, and inclusion of safeguards.  
- The Chat Playground interface allows users to input queries, test AI responses, and adjust parameters to fine-tune behavior.  

**Definitions**  
- **Azure OpenAI Studio**: A web-based platform for deploying, testing, and managing Azure OpenAI large language models, facilitating generative AI application development.  
- **Chat Playground**: An interactive interface within Azure OpenAI Studio where users can test AI chatbots by typing messages and receiving responses, with adjustable parameters to control AI behavior.  

**Key Facts**  
- The Chat Playground interface includes:  
  - A central chat area for user input and AI replies.  
  - A left-side menu for navigation and assistant setup (with reminders to save changes).  
  - A right-side panel with adjustable parameters controlling response length, randomness, and repetition.  
- Access is limited and prioritized for partners engaged in lower-risk AI use cases with safeguards.  

**Examples**  
- Using the Chat Playground to provide few-shot examples and test large language models interactively.  

**Key Takeaways 🎯**  
- Understand that Azure OpenAI Studio is the primary environment for working with Azure OpenAI models in a controlled, web-based setting.  
- Remember the Chat Playground as a key tool for testing and fine-tuning AI chatbot responses.  
- Be aware of current access restrictions and the focus on responsible AI use and partnerships.  
- Know the interface layout: chat area (center), navigation and setup (left), and response parameter controls (right).  
- Recognize the importance of saving changes when configuring the assistant.

---

### Azure OpenAI service pricing

**Timestamp**: 02:11:44 – 02:13:14

**Key Concepts**  
- Azure OpenAI Service pricing is primarily pay-per-use based.  
- Pricing varies depending on the model type, context size, and usage (prompt vs completion tokens).  
- Higher quality and larger context models cost more.  
- Pricing can be per 1,000 tokens or per hour depending on the model and usage.  

**Definitions**  
- **Prompt tokens**: Tokens sent as input to the model.  
- **Completion tokens**: Tokens generated by the model as output.  
- **Context size**: The maximum number of tokens the model can consider at once (e.g., 4K, 8K, 16K, 32K, 128K tokens).  

**Key Facts**  
- GPT-3.5 Turbo (4K context):  
  - $0.0015 per 1,000 prompt tokens  
  - $0.002 per 1,000 completion tokens  
- GPT-3.5 Turbo (16K context):  
  - $0.003 per 1,000 prompt tokens  
  - $0.004 per 1,000 completion tokens  
- GPT-3.5 Turbo1106 (16K context): Pricing not available  
- GPT-4 (8K context):  
  - $0.03 per 1,000 prompt tokens  
  - $0.06 per 1,000 completion tokens  
- GPT-4 (32K context):  
  - $0.06 per 1,000 prompt tokens  
  - $0.12 per 1,000 completion tokens  
- GPT-4 Turbo and GPT-4 Turbo Vision (128K context): Pricing not listed  
- Other models (base, fine-tuning, image, embedding, speech) also use pay-per-use pricing but details were not specified.  

**Examples**  
- None specifically mentioned beyond pricing examples for GPT models.  

**Key Takeaways 🎯**  
- Remember that prompt and completion tokens are priced separately.  
- Larger context windows increase pricing due to higher resource usage.  
- GPT-4 models are significantly more expensive than GPT-3.5 Turbo models.  
- Pricing details for some newer or specialized models (e.g., GPT-4 Turbo Vision) may not be publicly available.  
- Understand the pay-per-use model as a core pricing approach in Azure OpenAI Service.  
- Be aware that costs can vary widely depending on the model and token usage, which is critical for budgeting and cost management in exam scenarios.

---

### What are Copilots

**Timestamp**: 02:13:14 – 02:15:43

**Key Concepts**  
- Copilots are AI-powered computing tools integrated into applications to assist users with common tasks.  
- They use generative AI models to generate content, synthesize information, and support strategic planning.  
- Copilots follow a standard architecture enabling developers to create custom versions tailored to specific business needs.  
- Creation involves training or fine-tuning large language models, deploying them, and building prompts to generate useful outputs.  
- Copilots enhance productivity and creativity by providing AI-generated assistance within familiar software environments.

**Definitions**  
- **Copilot**: A generative AI assistant embedded in applications that helps users perform tasks by leveraging the content within those applications to generate relevant and contextual outputs.

**Key Facts**  
- Copilots can appear as chat features alongside documents or files.  
- They utilize pre-trained models from services like Azure OpenAI, which can be used as-is or fine-tuned with custom data.  
- Microsoft Copilot is integrated across Microsoft products (Word, Excel, PowerPoint, etc.) to assist with document creation, summarization, and planning.  
- Microsoft Bing includes a Copilot that provides natural language answers by understanding search context.  
- Microsoft 365 Copilot supports workflow tasks in tools like PowerPoint and Outlook.  
- GitHub Copilot aids software developers by suggesting code snippets, documenting code, and supporting testing to reduce errors.

**Examples**  
- Microsoft Copilot: Assists in creating documents, spreadsheets, presentations, and strategic planning.  
- Microsoft Bing Copilot: Enhances search by generating contextual natural language answers.  
- Microsoft 365 Copilot: Helps with emails, presentations, spreadsheets, and other productivity tasks.  
- GitHub Copilot: Provides real-time coding assistance, documentation, and testing support for developers.

**Key Takeaways 🎯**  
- Understand that Copilots are AI assistants embedded within applications to improve user productivity through generative AI.  
- Remember that Copilots leverage both pre-trained and fine-tuned large language models.  
- Be able to identify examples of Copilots in Microsoft products and their specific roles.  
- Recognize the importance of prompt engineering and deployment in making Copilots effective.  
- Focus on how Copilots transform workflows by automating first drafts, summarization, coding help, and strategic planning.

---

### Prompt engineering

**Timestamp**: 02:15:43 – 02:18:51

**Key Concepts**  
- Prompt engineering improves interaction between humans and generative AI by refining prompts/instructions.  
- It benefits both developers building AI applications and end users interacting with them.  
- System messages set context, expectations, and constraints for AI responses.  
- Writing precise and explicit prompts maximizes AI response quality.  
- One-shot learning: AI performs tasks correctly from a single example without prior training.  
- Prompt engineering workflow involves multiple iterative steps from understanding the task to refining output.

**Definitions**  
- **Prompt engineering**: The process of refining prompts or instructions given to an AI to generate higher quality responses.  
- **System message**: A prompt component that defines the AI’s role, style, and constraints (e.g., “You are a helpful assistant responding cheerfully”).  
- **One-shot learning**: AI’s ability to perform a task correctly after seeing only one example or instance.  

**Key Facts**  
- A well-structured prompt example: “Create a list of 10 things to do in Edinburgh during August.”  
- Prompt engineering workflow steps:  
  1. Task understanding – know what you want the AI to do  
  2. Crafting prompts – write instructions for the AI  
  3. Prompt alignment – ensure instructions match AI capabilities  
  4. Optimizing prompt – improve instructions for better responses  
  5. AI model processing – AI processes instructions  
  6. Generating output – AI produces answer/result  
  7. Output refinement – tweak AI’s answer  
  8. Iterative improvement – continuously improve instructions and answers  

**Examples**  
- User query: “Can my camera handle the rainy season if I go to the Amazon rainforest next week?”  
- Prompt engineering components used: weather resistance feature check, user’s equipment database, rainforest climate data, product specs, travel tips for photographers.  
- AI integrates user question with climate data and product info to respond:  
  “Your current camera model, the ProShot Mark V, is weather-sealed for high humidity and rain, suitable for the Amazon rainy season. Consider a rain cover for heavy rains.”  

**Key Takeaways 🎯**  
- Always be precise and explicit in prompts to get targeted, relevant AI outputs.  
- Use system messages to control AI tone, style, and constraints.  
- Understand and align prompts with what the AI model can do.  
- Follow the prompt engineering workflow for effective AI interaction and continuous improvement.  
- One-shot learning enables AI to perform new tasks from minimal examples—leverage this in prompt design.  
- Incorporate relevant context and data sources in prompts to improve response accuracy.

---

### Grounding

**Timestamp**: 02:18:51 – 02:20:36

**Key Concepts**  
- Grounding is a prompt engineering technique that involves providing specific, relevant context within a prompt to improve AI responses.  
- Grounding helps large language models (LLMs) produce more accurate and contextually relevant outputs.  
- It differs from general prompt engineering by focusing on enriching prompts with context rather than just crafting instructions or format.  
- Grounding ensures the AI has sufficient information to understand and process the prompt correctly.  
- Prompt engineering is broader and includes techniques like style, format, examples, and question framing.  
- Grounding supports responsible AI by helping ensure outputs are accurate and aligned with ethical standards.  
- Grounding fits within a framework of prompt engineering, fine-tuning, and training, with prompt engineering at the top (broadest), fine-tuning in the middle, and training at the base (most resource-intensive).  
- LLM operations (LLM ops) and responsible AI principles are foundational across all stages of LLM application development.

**Definitions**  
- **Grounding**: A technique in prompt engineering where relevant and specific context is included in the prompt to help the AI model generate more accurate and relevant responses.  
- **Prompt Engineering**: The broader art of designing prompts to elicit desired outputs from AI models, including format, style, and strategic use of examples or questions.

**Key Facts**  
- Grounding allows leveraging LLMs for tasks they were not explicitly trained on without retraining the model.  
- The grounding framework is visualized as a triangle with prompt engineering at the top, fine-tuning below, and training at the base, indicating increasing complexity and resource requirements.  
- Responsible AI and operational efficiency are emphasized as foundational across all LLM development stages.

**Examples**  
- To summarize an email using an LLM, include the actual email text in the prompt along with a command to summarize it. This is an example of grounding by providing relevant context.

**Key Takeaways 🎯**  
- Remember that grounding is about enriching prompts with context to improve AI understanding and output quality.  
- Grounding differs from prompt engineering, which is broader and includes other prompt design techniques.  
- Use grounding to enable LLMs to perform tasks without retraining by supplying relevant data within the prompt.  
- Understand the grounding framework’s place relative to fine-tuning and training in terms of complexity and resource use.  
- Keep responsible AI principles and operational efficiency in mind when applying grounding techniques.  
- Practical application: Always include necessary context in prompts for best results, e.g., full text when asking for summaries.

---

### Copilot demo

**Timestamp**: 02:20:36 – 02:24:04

**Key Concepts**  
- Copilot with GPT-4 on Microsoft Bing enables interactive AI-powered assistance including text generation, coding help, and image creation.  
- Conversation styles can be adjusted: creative (imaginative), balanced (middle ground), or precise (factual).  
- Copilot integrates with DALL-E 3 for AI image generation and modification.  
- Copilot can generate and modify code in multiple programming languages such as Python and JavaScript.  
- Responses include sourced information with clickable links for verification and further reading.  
- Follow-up question suggestions are provided to deepen understanding or continue the conversation.

**Definitions**  
- **Copilot**: An AI assistant powered by GPT-4 integrated into Microsoft Bing that supports text generation, coding, and image creation.  
- **DALL-E 3**: An AI image generation service integrated with Copilot that creates and edits images based on user prompts.

**Key Facts**  
- Popular prompt examples include:  
  - Creating images (e.g., concept kitchen)  
  - Generating product ideas  
  - Explaining AI to a 6th grader  
  - Writing Python code for flavor combinations  
- Example prompt style used in demo: “Summarize the main differences between supervised and unsupervised learning for the AI-900 exam.”  
- Copilot provides internet-sourced answers with direct links to original sources.  
- Image generation example: “Create an image of a cute dog running through a green field on a sunny day.”  
- Image modification options include adding a rainbow, changing the animal (dog to cat), or altering the sky colors.  
- Code generation examples:  
  - Python function to check if a number is prime  
  - JavaScript function to reverse a string

**Examples**  
- Summarizing supervised vs unsupervised learning:  
  - Supervised learning uses labeled data with correct outputs.  
  - Unsupervised learning uses unlabeled data to find patterns.  
- Image generation and modification:  
  - Generated a dog running in a field, then changed it to a cat.  
- Code generation:  
  - Python prime number checker function.  
  - JavaScript string reversal function.

**Key Takeaways 🎯**  
- Remember that Copilot can be used for a variety of tasks: text explanation, coding, and image generation.  
- Adjusting conversation style affects the creativity vs factual precision of responses.  
- Copilot’s integration with DALL-E 3 allows seamless image creation and editing from text prompts.  
- Generated answers come with source links—use these for verifying information and further study.  
- Copilot supports multiple programming languages, useful for coding exam questions or practice.  
- Using follow-up suggestions can help deepen understanding or explore related topics efficiently.

## Follow Alongs

---

### Setup

**Timestamp**: 02:24:04 – 02:35:02

**Key Concepts**  
- Setting up Azure Machine Learning Studio as a workspace for ML projects  
- Creating and managing compute resources in Azure ML (compute instances, clusters, inference clusters, attached compute)  
- Using notebooks within Azure ML Studio backed by compute instances  
- Uploading project files and assets to Azure ML Studio notebooks  
- Setting up Azure Cognitive Services as a unified API endpoint for multiple AI services  
- Managing keys and endpoints for Cognitive Services integration  
- Importance of selecting appropriate compute type (CPU vs GPU) based on cost and workload  
- Launching Jupyter Lab from Azure ML Studio for notebook editing and development  

**Definitions**  
- **Azure Machine Learning Studio**: A cloud-based environment for building, training, and deploying machine learning models.  
- **Compute Instance**: A virtual machine used primarily for running notebooks and lightweight development tasks.  
- **Compute Cluster**: A scalable set of compute resources used for training ML models.  
- **Inference Cluster**: Compute resources dedicated to running inference pipelines.  
- **Attached Compute**: External compute resources like HDInsight or Databricks connected to Azure ML.  
- **Cognitive Services**: A collection of AI services and APIs that provide capabilities like vision, speech, language, and decision-making through a unified key and endpoint.  

**Key Facts**  
- GPU compute instances cost approximately $0.90 per hour and are more expensive than CPU instances.  
- Notebooks in Azure ML Studio require a compute instance to run; no compute means notebooks cannot execute.  
- Azure Cognitive Services can be accessed via a single unified key and API endpoint, simplifying integration.  
- Cognitive Services pricing is usage-based, with free tiers allowing up to 1000 transactions before billing.  
- Azure ML Studio supports multiple notebook editors: Jupyter Lab, Jupyter, VS Code, RStudio, and terminal.  
- Python kernels available include versions 3.6 and 3.8 (version choice is not critical for setup).  

**Examples**  
- Creating a new Azure ML Studio workspace named "my studio" and a workspace named "ML workplace."  
- Creating a new compute instance named "my notebook instance" using CPU for cost efficiency.  
- Uploading project files (e.g., AI 900 repo zipped files) and organizing them into folders like "cognitive services" within the notebook file system.  
- Creating a Cognitive Services resource named "my cog services" in the Azure portal, selecting region (e.g., US East), and standard SKU.  
- Copying Cognitive Services keys and endpoints into notebooks to enable API calls.  

**Key Takeaways 🎯**  
- Always create and attach a compute instance before running notebooks in Azure ML Studio.  
- Choose CPU compute instances for notebook development to save costs unless GPU is specifically needed.  
- Use the unified Cognitive Services key and endpoint to access multiple AI services efficiently.  
- Keep your Cognitive Services keys secure; avoid embedding them directly in notebooks for production.  
- Familiarize yourself with launching and using Jupyter Lab from Azure ML Studio for consistent development experience.  
- Understand the different compute types and their purposes to optimize resource usage and cost.  
- Upload all necessary project files and assets into the Azure ML Studio environment before starting labs or experiments.

---

### Computer Vision

**Timestamp**: 02:35:02 – 02:38:44

**Key Concepts**  
- Computer Vision is an umbrella service in Azure Cognitive Services covering multiple image-related operations.  
- The specific operation discussed is **"describe image in stream"**, which generates human-readable descriptions of images.  
- Descriptions are based on a collection of content tags returned by the operation.  
- The service returns captions with confidence scores indicating the likelihood of accuracy.  
- Images must be loaded and passed as streams to the API.  
- The Azure Cognitive Services Vision Computer Vision SDK is not pre-installed by default and must be installed via pip.  
- Common supporting libraries include `os` (for OS-level operations), `matplotlib` (for image display and drawing), and optionally `numpy`.  
- Credentials (key and endpoint) are required to authenticate and instantiate the Computer Vision client.  

**Definitions**  
- **Describe Image in Stream**: An API operation that analyzes an image stream and returns a human-readable description with complete sentences and associated content tags.  
- **Confidence Score**: A numerical value representing the likelihood that the returned caption or tag accurately describes the image content.  

**Key Facts**  
- The Computer Vision SDK for Python is not included in the Azure Machine Learning SDK by default and must be installed separately (`pip install azure-cognitiveservices-vision-computervision`).  
- Captions returned include a confidence score (e.g., 57.45%) indicating the model’s certainty.  
- The service can identify celebrities if they are in its database but may not recognize contextual or pop culture references (e.g., identifying Brent Spiner as a person but not necessarily as a Star Trek character).  
- Images must be loaded as streams before being sent to the API.  

**Examples**  
- An image (`assets/data.jpg`) was loaded as a stream and passed to the describe image API.  
- The returned caption was: "Brent Spiner looking at a camera" with a confidence score of 57.45%.  
- The system identified people and objects such as "person," "wall," "indoor," "man," and "pointing" as tags.  

**Key Takeaways 🎯**  
- Remember to install the Azure Cognitive Services Vision Computer Vision SDK separately before use.  
- Always load images as streams when calling the describe image API.  
- The describe image operation returns captions with confidence scores and content tags that help interpret the image.  
- Confidence scores provide insight into the reliability of the description but may not reflect perfect accuracy, especially for niche or cultural references.  
- Use supporting libraries like `matplotlib` to visualize images and results inline.  
- Credentials (endpoint and key) are essential to authenticate and create the Computer Vision client.  
- This operation is a foundational step before exploring more advanced services like Custom Vision.

---

### Custom Vision Classification

**Timestamp**: 02:38:44 – 02:45:22

**Key Concepts**  
- Custom Vision service allows for image classification and object detection.  
- Classification identifies what an image contains, either as a single class (one label per image) or multi-label (multiple labels per image).  
- Custom Vision projects can be created via the Azure Marketplace or directly through the customvision.ai website.  
- Projects require creating or linking to an Azure Custom Vision resource (part of Cognitive Services).  
- Domains optimize the model for specific use cases; General A2 domain is optimized for speed and suitable for demos.  
- Tagging images with labels is essential for training the model.  
- Training options include quick training (faster, less accurate) and advanced training (longer, potentially more accurate).  
- Probability threshold sets the minimum confidence score for predictions to be considered valid during evaluation.  
- After training, evaluation metrics such as precision, recall, and average precision indicate model performance.  
- Quick test feature allows uploading local images to test the trained model’s predictions.  
- Models can be published to generate a public endpoint for programmatic access.

**Definitions**  
- **Custom Vision**: An Azure Cognitive Service that enables building, deploying, and improving image classifiers and object detectors.  
- **Classification**: Assigning one or more labels to an entire image to identify what it contains.  
- **Multiclass Classification**: Each image is assigned exactly one label from multiple possible categories.  
- **Multilabel Classification**: Each image can have multiple labels (e.g., dog and cat in the same image).  
- **Domain**: A preset model configuration optimized for specific scenarios (e.g., General A2 for speed).  
- **Probability Threshold**: The minimum confidence score a prediction must meet to be considered valid during precision and recall calculations.  
- **Precision and Recall**: Metrics used to evaluate the accuracy and completeness of the model’s predictions.

**Key Facts**  
- Custom Vision can be accessed via Azure Marketplace or directly at customvision.ai.  
- When creating a resource, options include Free (FO) and Standard (SO) tiers; FO may be blocked or unavailable.  
- General A2 domain is optimized for faster training and inference, suitable for demos.  
- Quick training is faster but less customizable; advanced training allows longer training for potentially better accuracy.  
- Training time can vary but generally takes around 5 to 10 minutes.  
- Evaluation metrics after training include precision, recall, and average precision.  
- Quick test can achieve high confidence scores (e.g., 98.7% match for an image labeled “WARF”).  
- After publishing, a public URL endpoint is available for programmatic predictions.

**Examples**  
- Project named “Star Trek crew” created to classify images of Star Trek characters.  
- Tags created: WARF, data, crusher (Beverly Crusher).  
- Uploaded images tagged accordingly and trained the model.  
- Quick test matched an image of Worf with 98.7% confidence.  
- Additional tests:  
  - Hugh (a Borg) matched mostly to Data.  
  - Martok (a Klingon) matched strongly to Worf.  
  - Pulaski (doctor) matched to Beverly Crusher.  

**Key Takeaways 🎯**  
- Know the difference between classification and object detection in Custom Vision.  
- Understand the difference between multiclass (single label) and multilabel (multiple labels) classification modes.  
- Be familiar with how to create a Custom Vision project, including resource creation and domain selection.  
- Remember that tagging images correctly is crucial for effective training.  
- Quick training is suitable for demos and quick iterations; advanced training can improve accuracy but takes longer.  
- Understand the role of probability threshold in filtering predictions during evaluation.  
- Be able to interpret evaluation metrics like precision and recall to assess model quality.  
- Use the quick test feature to validate model predictions before publishing.  
- Publishing the model creates an endpoint for integration with applications or services.  
- Practical knowledge of uploading images, tagging, training, testing, and publishing is essential for exam scenarios involving Custom Vision.

---

### Custom Vision Object Detection

**Timestamp**: 02:45:22 – 02:51:18

**Key Concepts**  
- Custom Vision Object Detection allows identification and localization of specific objects within images (detecting particular items in a scene).  
- Creating a project involves selecting a domain (e.g., General v1.0) and adding tagged images for training.  
- Tagging involves drawing bounding boxes around objects of interest in images.  
- Training can be done via quick or advanced training options.  
- Model evaluation metrics include precision, recall, and mean average precision (mAP).  
- Threshold settings affect prediction confidence and overlap criteria for bounding boxes.

**Definitions**  
- **Object Detection**: The process of identifying and locating objects within an image by drawing bounding boxes around them.  
- **Precision**: The likelihood that a predicted tag by the model is correct (how many predicted positives are true positives).  
- **Recall**: The percentage of actual tags correctly identified by the model (how many true positives are found out of all actual positives).  
- **Mean Average Precision (mAP)**: A summary metric that measures overall object detector performance across all tags.  
- **Overlap Threshold**: The minimum percentage of overlap between predicted bounding boxes and ground truth boxes required to count as a correct prediction.

**Key Facts**  
- Minimum of 15 images used for training in the example.  
- Tag created was "combat" to detect combat badges.  
- Bounding boxes are manually drawn if automatic detection does not work well.  
- Higher contrast images improve detection accuracy.  
- After training, example model achieved 75% precision and 100% recall.  
- Thresholds can be adjusted to improve detection results (e.g., lowering threshold increases detections but may reduce precision).  
- Overlap threshold helps define how closely predicted bounding boxes must match ground truth to be considered correct.

**Examples**  
- Project created to detect "combat" badges in images.  
- 15 images uploaded and tagged with bounding boxes around combat badges.  
- Some images with low contrast or cluttered backgrounds were harder to detect.  
- Model tested on new images, successfully detecting most badges except some false positives or missed detections.  
- Adjusting the probability threshold affected detection sensitivity.

**Key Takeaways 🎯**  
- Understand the difference between classification and object detection in Custom Vision.  
- Know the importance of tagging images with bounding boxes for object detection training.  
- Remember key evaluation metrics: precision, recall, and mean average precision (mAP).  
- Be aware that image quality (contrast, clarity) impacts detection performance.  
- Threshold settings are crucial for balancing detection sensitivity and accuracy.  
- Manual bounding box annotation may be necessary if automatic detection misses objects.  
- Custom Vision provides an easy-to-use interface for training and testing object detection models.

---

### Face Service

**Timestamp**: 02:51:18 – 02:54:30

**Key Concepts**  
- Face Service is part of the Azure Computer Vision API.  
- Requires installation of the Computer Vision package and use of the Face Client.  
- Authentication is done using Cognitive Service credentials and keys.  
- Detects faces in images and returns face IDs and bounding boxes (face rectangles).  
- Can also return detailed face attributes such as age, emotion, makeup, and gender if the image resolution is sufficient.  
- Attributes are returned as a dictionary and can be iterated over for display or processing.  

**Definitions**  
- **Face Client**: A client object used to interact with the Face Service API for face detection and analysis.  
- **Face ID**: A unique identifier assigned to each detected face in an image.  
- **Face Rectangle**: The bounding box coordinates (top, left, width, height) around a detected face.  
- **Face Attributes**: Additional information about detected faces such as age, emotion, gender, and makeup.  

**Key Facts**  
- The Face Service requires a sufficiently large image to detect detailed attributes; low-resolution images may not process attributes.  
- The bounding box is drawn on the image with a magenta line (line thickness can be adjusted, e.g., to 3).  
- Example detected age was approximately 44 years old.  
- Gender detection is based on presentation; e.g., an android character was detected as male presenting.  
- Makeup detection focuses on lips and eyes; some makeup types (like eyeshadow) may not be detected.  
- Emotion detection can show percentages for emotions such as sadness or neutrality.  

**Examples**  
- Used the same image as in the Computer Vision example to detect one face and draw a bounding box with the face ID annotated.  
- Switched to a higher resolution image to successfully detect face attributes including age, gender, and makeup.  
- Example showed an android character with approximate age 44, male presenting, no detected makeup on lips/eyes, and mostly neutral emotion.  

**Key Takeaways 🎯**  
- Always ensure the image resolution is high enough to detect detailed face attributes; otherwise, only face detection (IDs and rectangles) will work.  
- The Face Service API returns face rectangles and unique face IDs that can be used for annotation and further processing.  
- Face attributes are optional parameters in the detection call and must be explicitly requested.  
- Understanding the structure of returned data (face objects, attributes dictionary) is important for extracting and displaying information.  
- Adjust visualization parameters (like bounding box color and thickness) for clarity when displaying results.

---

### Form Recognizer

**Timestamp**: 02:54:30 – 02:58:01

**Key Concepts**  
- Azure AI Form Recognizer is a cognitive service designed to identify and extract structured data from forms, such as receipts.  
- It converts form content into readable, structured data fields.  
- The service has predefined fields for certain form types (e.g., receipts) like merchant name, phone number, total price, etc.  
- Uses a client with Azure key credential (not the cognitive service credential used by other services).  
- The process involves calling `begin_recognize_receipt` to analyze receipt data.  
- Extracted fields include labels and values, which can be accessed programmatically.  

**Definitions**  
- **Azure AI Form Recognizer**: A specialized Azure cognitive service that extracts key-value pairs and structured data from forms such as receipts, business cards, and invoices.  
- **Predefined fields**: Specific data points that Form Recognizer is trained to extract automatically from certain form types (e.g., merchant name, phone number, total price on receipts).  

**Key Facts**  
- Form Recognizer requires the use of `AzureKeyCredential` for authentication, unlike other cognitive services that use `CognitiveServiceCredential`.  
- The receipt recognition method is `begin_recognize_receipt`.  
- Predefined receipt fields include: receipt type, merchant name, merchant phone number, total price, etc.  
- Some field names may contain spaces (e.g., "total price"), which can cause issues when accessing them programmatically.  
- The service may not always extract every field perfectly; some trial and error may be needed to find the correct field keys.  

**Examples**  
- Extracting merchant name from a receipt: The field "Merchant Name" returned "Alamo Draft Out Cinema".  
- Attempting to extract total price using different keys like "total price", "price", and "total" to find the correct field key. "total" worked in the example.  
- Extracting merchant phone number successfully using the predefined field.  

**Key Takeaways 🎯**  
- Remember that Form Recognizer uses `AzureKeyCredential` for authentication, which differs from other Azure Cognitive Services.  
- Use `begin_recognize_receipt` to analyze receipt images and extract structured data.  
- Predefined fields exist for common form types; familiarize yourself with these to access data correctly.  
- Field names may have spaces or unexpected formatting—test different keys if a field returns `None`.  
- The service is useful but may require some experimentation to get the desired data fields.  
- Always check the returned fields dictionary to understand what data is available and how it is labeled.

---

### OCR

**Timestamp**: 02:58:01 – 03:02:54

**Key Concepts**  
- OCR (Optical Character Recognition) capabilities are part of Azure Computer Vision services.  
- Two main OCR approaches in Azure Computer Vision:  
  - **Recognize Printed Text in Stream**: suitable for simple, smaller amounts of printed text, synchronous processing.  
  - **Read API**: designed for larger amounts of text, asynchronous processing, more efficient and accurate for complex documents.  
- OCR can process both printed and handwritten text, though handwritten text recognition is more challenging and less accurate.  
- Image quality (resolution, font style, artifacts) significantly affects OCR accuracy.

**Definitions**  
- **OCR (Optical Character Recognition)**: Technology that extracts text from images.  
- **Recognize Printed Text in Stream**: A synchronous OCR method for extracting printed text from images.  
- **Read API**: An asynchronous OCR method designed for processing larger or more complex text documents, providing better accuracy and efficiency.

**Key Facts**  
- Poor image quality or unusual fonts (e.g., Star Trek font) reduce OCR accuracy.  
- The Read API processes text line-by-line asynchronously, improving performance on large texts.  
- Handwritten text recognition is possible but often produces imperfect results due to handwriting variability.  
- Example handwritten note by William Shatner was difficult to read manually but OCR provided a better transcription, though still imperfect.

**Examples**  
- Extracting text from images related to Star Trek titles:  
  - First image with low resolution and artifacts returned poor results.  
  - Second image with better quality extracted more text (e.g., "Deep Space Nine," "Nana Visitor," "Tells All").  
- Handwritten note from William Shatner to a fan: OCR was able to transcribe better than human reading despite poor handwriting.

**Key Takeaways 🎯**  
- Understand the difference between the synchronous Recognize Printed Text method and the asynchronous Read API for OCR tasks.  
- Use the Read API for larger documents or when asynchronous processing is needed for better efficiency and accuracy.  
- Image quality and font style are critical factors influencing OCR success—high resolution and clear fonts improve results.  
- Handwritten text recognition is supported but expect lower accuracy; OCR can still outperform manual reading in difficult cases.  
- Be familiar with loading credentials, creating clients, and calling OCR functions in Azure Computer Vision for practical implementation.

---

### Text Analysis

**Timestamp**: 03:02:54 – 03:06:37

**Key Concepts**  
- Using Azure Cognitive Services Language Text Analytics to analyze text data.  
- Sentiment analysis to determine if reviews are positive or negative.  
- Extracting key phrases from text to identify important topics or themes.  
- Loading and processing multiple text files (movie reviews) for analysis.  
- Correlating sentiment scores with actual review content for validation.

**Definitions**  
- **Text Analytics**: A cognitive service that processes natural language text to extract insights such as sentiment, key phrases, and other language features.  
- **Sentiment Analysis**: The process of determining the emotional tone behind a body of text, typically classified as positive, negative, or neutral.  
- **Key Phrases**: Significant words or phrases extracted from text that highlight important topics or concepts within the content.

**Key Facts**  
- Sentiment scores above 5 are considered positive; below 5 are negative.  
- Example sentiment scores mentioned: 9 (very positive), 1 (very negative), 4 (neutral/low).  
- Key phrases extracted included terms like "Borg ship," "Enterprise," "Neutral zone," "Sophisticated Science Fiction," "Wealth of Unrealized Potential."  
- Text Analytics requires setting up credentials and clients similar to other Azure Cognitive Services.  
- Blank or missing text files can cause empty results in analysis.

**Examples**  
- Movie reviews of *Star Trek: First Contact* were analyzed.  
- Key phrases such as "Borg ship," "Enterprise," and "Neutral zone" frequently appeared, indicating important themes.  
- Sentiment analysis was run on multiple reviews, with scores reflecting the reviewers’ opinions (e.g., 9 for very positive, 1 for very negative).  
- Some reviews were synopses rather than opinionated, showing limitations of sentiment analysis without explicit sentiment language.

**Key Takeaways 🎯**  
- Understand how to use Azure Text Analytics to extract sentiment and key phrases from text data.  
- Remember the sentiment scoring threshold: >5 positive, <5 negative.  
- Be aware that not all text inputs will contain sentiment (e.g., synopses or blank files).  
- Key phrase extraction helps identify recurring themes or important concepts in text.  
- Practical use case: analyzing movie reviews to gauge audience sentiment and highlight key discussion points.  
- Always validate sentiment results by reviewing the original text when possible.

---

### QnAMaker

**Timestamp**: 03:06:37 – 03:25:11

**Key Concepts**  
- QnAMaker is a no-code/low-code Azure Cognitive Service to build question-and-answer bots.  
- It uses knowledge bases created from documents or FAQs to provide answers to user queries.  
- QnAMaker service must be created in Azure before building a knowledge base.  
- Knowledge bases can be populated with various document formats following specific formatting guidelines (headings and answers).  
- Supports chit-chat and multi-turn conversational flows using follow-up prompts to link Q&A pairs.  
- Once published, the QnAMaker knowledge base can be integrated with Azure Bot Service for multi-channel deployment.  
- Azure Bot Service allows connecting the QnAMaker bot to multiple channels like Teams, Slack, Web Chat, Facebook, Telegram, and more.  
- Bot source code can be downloaded (Node.js example shown) for further customization or integration.  
- Simple integration can be done via embed code (iframe) with a secret key for authentication.

**Definitions**  
- **QnAMaker**: An Azure Cognitive Service that enables creation of a question-and-answer bot by building a knowledge base from documents or FAQs without heavy coding.  
- **Knowledge Base (KB)**: A collection of question-and-answer pairs that QnAMaker uses to respond to user queries.  
- **Chit-chat**: Predefined casual conversation pairs included in QnAMaker to handle small talk or irrelevant questions.  
- **Follow-up Prompts**: Links between Q&A pairs that enable multi-turn conversations, guiding users through related questions.  
- **Azure Bot Service**: A platform to host, manage, and connect bots to multiple communication channels.

**Key Facts**  
- QnAMaker service creation can take up to 10 minutes to provision and be ready.  
- Free tier available for QnAMaker service and Azure Bot Service (F0 tier).  
- QnAMaker can ingest multiple file types and uses headings to identify questions and answers.  
- Example knowledge base included AWS and Azure certification questions (e.g., number of AWS certifications: 11; Azure fundamental certifications: 4).  
- Multi-turn conversation requires context-aware prompts ("context only" setting).  
- Bot channels supported include Teams, Slack, Skype, Telegram, Facebook, Web Chat, Alexa, Twilio, and more.  
- Bot source code can be downloaded as a zip file, typically in Node.js if selected.  
- Embed code requires replacing a secret key to authenticate the bot in external apps or notebooks.

**Examples**  
- Created a knowledge base with certification-related Q&A:  
  - "How many AWS certifications are there?" → 11  
  - "How many Azure fundamental certifications are there?" → 4 (DP-900, AI-900, AZ-900, SC-900)  
  - "Which is the hardest Azure Associate certification?" → AZ-104 (Azure Administrator)  
  - Comparison question: "Which is harder, AWS or Azure certifications?" → Opinion: Azure certifications are harder due to exact implementation steps.  
- Demonstrated adding follow-up prompts for multi-turn Q&A (e.g., after asking about certifications, user can select AWS or Azure to get specific answers).  
- Tested QnAMaker bot via web chat channel and embedded it in a Jupyter notebook using iframe and secret key.

**Key Takeaways 🎯**  
- Understand that QnAMaker is designed for quick, low-code creation of Q&A bots using knowledge bases.  
- Know the process: create QnAMaker service in Azure → build knowledge base (upload docs or enter Q&A pairs) → train and publish → connect to Azure Bot Service → deploy on channels.  
- Remember the importance of formatting knowledge base documents correctly (headings as questions, text as answers).  
- Multi-turn conversations require follow-up prompts and context-aware settings to guide users through related questions.  
- Azure Bot Service integration expands bot usability across many platforms and supports downloading source code for customization.  
- Free tiers exist for both QnAMaker and Azure Bot Service, useful for learning and small projects.  
- Embedding the bot via iframe is a simple way to integrate QnAMaker into web apps or notebooks, but requires managing secret keys securely.  
- Be aware of some limitations: QnAMaker may infer answers when questions are ambiguous; careful Q&A design improves accuracy.  
- For more advanced natural language understanding beyond QnAMaker, consider using LUIS (Language Understanding Intelligent Service).

---

### LUIS

**Timestamp**: 03:25:11 – 03:30:56

**Key Concepts**  
- LUIS stands for Language Understanding Intelligent Service, a cognitive service for building language understanding into bots.  
- LUIS is accessed via the external domain luis.ai, though it is part of Azure services.  
- LUIS uses intents and entities to interpret user input and extract meaningful data.  
- Intents represent the purpose or goal of a user’s utterance (e.g., booking a flight).  
- Entities represent specific data points within an utterance (e.g., location, date).  
- LUIS models require training with example utterances to improve accuracy.  
- After training, models can be tested and published to production endpoints for integration.  
- LUIS supports different entity types: machine-learned entities and list entities (static lists).  
- Region selection for authoring and cognitive services resource is important to avoid creating duplicate resources.  

**Definitions**  
- **LUIS (Language Understanding Intelligent Service)**: A Microsoft Azure cognitive service that enables developers to build natural language understanding into applications, bots, and IoT devices.  
- **Intent**: The goal or action the user wants to perform, identified from their input.  
- **Entity**: A specific piece of information extracted from the user’s input that provides details related to the intent.  
- **Machine-learned Entity**: An entity type that is identified by the model through training on example utterances.  
- **List Entity**: A predefined list of possible values for an entity that remains static (e.g., list of airports).  

**Key Facts**  
- LUIS requires an Azure Cognitive Services resource for authoring and runtime.  
- The authoring resource must be in a supported region (e.g., West US) to appear in the LUIS portal.  
- Example intent used: "book flight" or "flight booking."  
- Example utterance: "book me a flight to Toronto" or "book me a flight to Seattle."  
- After creating intents and entities, the model must be trained before testing.  
- The LUIS portal provides confidence scores (top scoring intent) when testing utterances.  
- Once satisfied, the model is published to a production slot and an endpoint URL is provided for integration.  

**Examples**  
- Creating an intent named "book flight" with example utterance: "book me a flight to Toronto."  
- Creating an entity named "location" to capture destination information.  
- Using a list entity to represent airports or fixed values.  
- Testing the model with the utterance: "book me a flight to Seattle," which returns the intent "book flight" with a confidence score.  

**Key Takeaways 🎯**  
- Understand the difference between intents and entities and their roles in LUIS.  
- Know how to create and train a simple LUIS model with intents and entities.  
- Remember to select the correct Azure region for your cognitive services resource to avoid duplication.  
- Be able to interpret the confidence score from LUIS testing to evaluate intent recognition.  
- Know the workflow: create intents/entities → train model → test → publish → use endpoint.  
- LUIS is essential for building robust conversational bots that understand natural language inputs.  
- For exam purposes, focus on the basic setup and usage of LUIS rather than complex configurations.

---

### AutoML

**Timestamp**: 03:30:56 – 03:48:13

**Key Concepts**  
- Automated Machine Learning (AutoML) automates the process of building ML pipelines, requiring minimal manual intervention.  
- AutoML selects the appropriate model type (e.g., regression, classification) based on the target variable.  
- AutoML performs automatic featurization, including feature selection and data preprocessing (handling missing data, high cardinality, dimensionality reduction).  
- Training time and primary evaluation metrics can be configured in AutoML experiments.  
- AutoML runs multiple models/algorithms and selects the best performing candidate (e.g., ensemble models).  
- Models created by AutoML can be deployed as endpoints using Azure Kubernetes Service (AKS) or Azure Container Instances (ACI).  
- Compute clusters (dedicated or low priority) are required to run AutoML experiments; GPU compute may speed up deep learning models but is not always necessary.  
- Feature importance and model performance metrics are available post-run to interpret model behavior.  

**Definitions**  
- **AutoML (Automated Machine Learning)**: A process/tool that automatically builds and tunes machine learning models and pipelines with minimal user input.  
- **Compute Cluster**: A set of virtual machines provisioned to run machine learning training jobs in Azure ML.  
- **Primary Metric**: The main evaluation metric AutoML uses to select the best model (e.g., normalized root mean squared error for regression).  
- **Ensemble Model**: A model that combines predictions from multiple weaker models to improve accuracy.  
- **Featurization**: Automatic feature engineering steps including selection, scaling, and handling missing or high cardinality data.  
- **Azure Kubernetes Service (AKS)**: A managed Kubernetes container orchestration service used for deploying scalable ML model endpoints.  
- **Azure Container Instance (ACI)**: A simpler container hosting service for deploying ML models without managing Kubernetes.  

**Key Facts**  
- The diabetes dataset used contains 422 samples with 10 features, commonly used for ML practice.  
- AutoML can automatically detect problem type: regression (continuous numeric target) or classification (binary/multi-class).  
- Training timeout can be set (default example: 3 hours), but actual runs may take about 1 hour on CPU-based compute.  
- Primary metric for regression in this example: normalized root mean squared error (RMSE).  
- AutoML ran about 42 different models in the example.  
- Ensemble models were selected as the best performing candidate in this run.  
- Dedicated compute clusters preferred over low priority for reliability (low priority nodes can be preempted).  
- GPU compute may speed up deep learning models but not necessarily statistical models.  
- Deployment to AKS requires meeting minimum resource quotas (e.g., total cores ≥ 12).  
- Deployment to ACI is simpler and does not require complex quota considerations.  

**Examples**  
- Using the diabetes dataset to predict a numeric outcome (likelihood of diabetes) with AutoML.  
- AutoML automatically choosing regression based on the continuous target variable.  
- Running AutoML on a dedicated CPU cluster, taking about 1 hour to complete.  
- AutoML testing 42 different models and selecting a voting ensemble as the best model.  
- Deploying the best AutoML model to Azure Container Instance (ACI) for inference.  
- Testing the deployed model by inputting sample feature values (e.g., age, BMI, BP, S1-S5) and receiving a prediction result (e.g., 168).  

**Key Takeaways 🎯**  
- Understand that AutoML automates the entire ML pipeline, including model selection, feature engineering, and training.  
- Know the difference between regression and classification and how AutoML detects this automatically.  
- Remember the primary metric used for regression problems in AutoML is often normalized root mean squared error (RMSE).  
- Be aware that AutoML runs multiple models and selects the best performing one, often an ensemble model.  
- Know the difference between compute cluster types (dedicated vs low priority) and their impact on job reliability.  
- Deployment options include AKS (more complex, scalable) and ACI (simpler, easier to deploy).  
- Quotas and resource requirements can affect deployment; ACI is easier for quick deployments without quota issues.  
- Feature importance and model performance insights are available post-training to help interpret models.  
- For exam purposes, focus on the concepts of AutoML automation, model selection, metrics, and deployment options rather than deep ML algorithm details.

---

### Designer

**Timestamp**: 03:48:13 – 03:58:31

**Key Concepts**  
- Azure Machine Learning Designer provides a visual, drag-and-drop interface to build ML pipelines without extensive coding.  
- Designer is useful for users who want more customization than AutoML but prefer a simpler approach than full coding.  
- Pre-built sample pipelines are available for various tasks: binary classification, multi-class classification, text classification, etc.  
- Pipelines typically include data preprocessing (e.g., column selection, cleaning missing data), data splitting (train/test), model training, hyperparameter tuning, scoring, and evaluation.  
- Compute targets must be selected or created to run Designer pipelines.  
- After training, models can be deployed via inference pipelines for real-time or batch scoring.  
- Deployment options include Azure Kubernetes Service (AKS) and Azure Container Instances (ACI), with ACI being simpler and faster to deploy.  
- Endpoints created from deployed models can be tested with sample data to verify scoring outputs.  

**Definitions**  
- **Designer**: A visual drag-and-drop tool in Azure ML for building, training, and deploying machine learning pipelines with minimal coding.  
- **Inference Pipeline**: A pipeline specifically designed for deploying a trained model to perform real-time or batch predictions (scoring).  
- **Compute Target**: The cloud resource (VM or cluster) where training or inference jobs run.  
- **Binary Classification**: A classification task where the output is one of two classes.  
- **SMOTE**: Synthetic Minority Over-sampling Technique, used to handle imbalanced datasets (mentioned as part of sample pipelines).  

**Key Facts**  
- Sample Designer pipeline run took approximately 14 minutes and 22 seconds.  
- Designer pipelines include steps such as:  
  - Select columns (exclude irrelevant features)  
  - Clean missing data (custom substitution values may be used)  
  - Split data into training and testing sets with randomization  
  - Hyperparameter tuning automatically searches for best model parameters  
  - Model training (e.g., two-class decision tree)  
  - Model scoring and evaluation  
- Deployment options:  
  - Azure Kubernetes Service (AKS) – more complex, longer startup time  
  - Azure Container Instance (ACI) – simpler, faster deployment  
- After deployment, endpoints can be tested with pre-loaded sample data, returning scored labels and probabilities.  

**Examples**  
- Using a binary classification sample pipeline that includes feature selection, data cleaning, splitting, model tuning, and evaluation.  
- Creating a new compute target named "binary pipeline" for running the Designer experiment.  
- Deploying the trained model as a real-time inference pipeline using Azure Container Instance.  
- Testing the deployed endpoint with sample input data and receiving scored labels and probabilities as output.  

**Key Takeaways 🎯**  
- Know the purpose and workflow of Azure ML Designer: build, train, tune, evaluate, and deploy ML models visually.  
- Understand the typical pipeline steps: data selection, cleaning, splitting, training, tuning, scoring, and evaluation.  
- Be familiar with deployment options (AKS vs. ACI) and when to use each.  
- Remember that Designer supports both training pipelines and separate inference pipelines for deployment.  
- Recognize that Designer is suitable for users who want more control than AutoML but less complexity than full coding.  
- For the exam, focus on the Designer’s role in the ML lifecycle, pipeline components, and deployment basics rather than deep technical details.  
- Testing endpoints with sample data is a key step to verify deployed models.

---

### MNIST

**Timestamp**: 03:58:31 – 04:18:10

**Key Concepts**  
- MNIST dataset is a popular computer vision dataset for handwritten digit recognition.  
- Training an ML model programmatically using Azure Machine Learning SDK in a Jupyter notebook.  
- Workflow involves connecting to an Azure ML workspace, creating experiments, and provisioning compute clusters.  
- Dataset registration and management in Azure ML workspace for easy retrieval during training.  
- Preparing training scripts, configuring environments, and submitting training jobs to remote compute clusters.  
- Monitoring training jobs via logs and Jupyter widgets.  
- Saving and registering trained models for collaboration and deployment.  
- Deployment involves creating scoring scripts and deploying models to Azure Container Instances (ACI).  
- Confusion matrix as an evaluation tool for classification models (mentioned as exam-relevant).  

**Definitions**  
- **MNIST Dataset**: A dataset of 70,000 grayscale images of handwritten digits (0-9), each image sized 28x28 pixels, used for multi-class classification tasks.  
- **Workspace**: An Azure ML resource that contains experiments, datasets, compute targets, and models.  
- **Experiment**: A logical grouping of runs (training jobs) in Azure ML to track and compare results.  
- **Compute Cluster**: Managed Azure ML compute resource (e.g., CPU cluster with Standard_D2_v2 VMs) used to run training jobs remotely.  
- **ScriptRunConfig**: Configuration object specifying the training script, compute target, environment, and parameters for a training job.  
- **Docker Image**: Container image built to match the Python environment for running training jobs in Azure ML.  
- **Model Registration**: Process of saving a trained model in the Azure ML workspace for versioning and sharing.  
- **Confusion Matrix**: A table used to evaluate the performance of a classification model by showing true vs predicted labels.  

**Key Facts**  
- MNIST dataset contains 70,000 images, each 28x28 pixels, grayscale, digits 0-9.  
- Azure ML SDK version used: 1.28.0 (Python 3.6 environment mentioned).  
- Compute cluster creation takes about 5 minutes; Standard_D2_v2 VM size is commonly used for CPU clusters.  
- Training script uses scikit-learn with logistic regression for multi-class classification.  
- Accuracy metric is used to evaluate model performance (example accuracy ~0.9 reported).  
- Training jobs run inside Docker containers; images are cached for faster subsequent runs.  
- Outputs (e.g., model files) are saved in the run’s outputs directory and accessible via workspace.  
- Model files saved as .pkl (pickle) files when using scikit-learn.  
- Monitoring can be done via Jupyter widgets or Azure ML portal logs.  
- Deployment steps include creating scoring scripts and deploying to Azure Container Instances (ACI).  
- Confusion matrix is an important evaluation tool and may appear on exams.  

**Examples**  
- Running the MNIST training notebook in JupyterLab using Azure ML SDK.  
- Creating a CPU cluster with 0-4 nodes using Standard_D2_v2 VM size.  
- Loading MNIST data from compressed ubyte.gz files, splitting into train/test sets.  
- Training a logistic regression model on MNIST using scikit-learn.  
- Submitting the training job to the remote compute cluster and monitoring progress.  
- Registering the trained model in Azure ML workspace for collaboration.  
- Brief mention of deploying the model to ACI and testing it with a scoring script.  

**Key Takeaways 🎯**  
- Understand the MNIST dataset characteristics and its use case in multi-class image classification.  
- Know the Azure ML workflow: workspace connection → experiment creation → compute provisioning → dataset registration → training script preparation → job submission → monitoring → model registration → deployment.  
- Be familiar with key Azure ML components: workspace, experiment, compute cluster, ScriptRunConfig, environment, and model registry.  
- Remember that training jobs run inside Docker containers, and image creation happens once per environment.  
- Know how to monitor training jobs via logs and Jupyter widgets.  
- Recognize the importance of saving and registering models for reuse and collaboration.  
- Confusion matrix is a critical evaluation metric for classification models and may be tested on exams.  
- Deployment to Azure Container Instances (ACI) involves creating scoring scripts and testing the deployed model.  
- Practical familiarity with scikit-learn logistic regression on MNIST is useful for exam scenarios involving Azure ML SDK.

---

### Data Labeling

**Timestamp**: 04:18:10 – 04:22:38

**Key Concepts**  
- Creating a data labeling project in Azure Machine Learning Studio  
- Choosing the type of labeling task: multi-class, multi-label, bounding box, segmentation  
- Uploading datasets (images or text) for labeling  
- Defining labels/classes for the dataset  
- Manual labeling of data points (images) within the project  
- Exporting labeled datasets in various formats (CSV, COCO, Azure ML dataset)  
- Collaboration by granting access to others for labeling tasks  

**Definitions**  
- **Data Labeling**: The process of annotating data (e.g., images or text) with labels or tags that identify the content, used for supervised machine learning.  
- **Multi-class labeling**: Assigning one label from multiple possible classes to each data point.  
- **Auto-enabled assistant labeler**: An optional feature that can automatically label data points (disabled in the example).  

**Key Facts**  
- Dataset example: 17 image files from a Star Trek-themed dataset  
- Labels used: TNG, DS-9, Voyager, Toss (Star Trek series names)  
- The dataset is periodically checked for new data points which are added as labeling tasks  
- Labeling interface allows adjustments like changing contrast or rotating images for better visibility  
- Export options include CSV, COCO format, and Azure ML dataset format for easy reuse  
- Labeled data appears as a new labeled dataset in Azure ML Studio after export  

**Examples**  
- Created a labeling project named "my labeling project"  
- Selected multi-class classification for labeling Star Trek series images  
- Uploaded 17 image files from a folder named "objects"  
- Manually labeled each image with the appropriate Star Trek series label (e.g., Voyager, TNG, DS9, Toss)  
- Exported the labeled dataset back into Azure ML for further use  

**Key Takeaways 🎯**  
- Understand how to create and configure a data labeling project in Azure ML Studio  
- Know the difference between multi-class and multi-label classification in labeling tasks  
- Be familiar with the process of uploading datasets and defining labels  
- Remember that manual labeling can be supplemented by an auto-labeling assistant (optional)  
- Know how to export labeled data in different formats for downstream ML workflows  
- Recognize that labeled datasets can be reused and shared within Azure ML Studio  
- Practical familiarity with the labeling UI features (contrast, rotate) can improve labeling accuracy  
- Exam may test knowledge of data labeling workflow and export options in Azure ML

---

### Clean up

**Timestamp**: 04:22:38 – unknown

**Key Concepts**  
- Proper resource cleanup after completing Azure Machine Learning projects  
- Manual deletion of compute resources and resource groups to avoid unnecessary charges  
- Verification of all running resources to ensure complete cleanup  

**Definitions**  
- **Compute**: The cloud-based virtual machines or clusters used to run machine learning experiments and jobs.  
- **Resource Group**: A container in Azure that holds related resources for an Azure solution, allowing for easier management and deletion.  
- **Container Registry**: A service in Azure used to store and manage container images, which may be created during ML workflows.  

**Key Facts**  
- After finishing with Azure Machine Learning, compute resources can be manually deleted to free up costs.  
- Deleting the resource group will remove all resources contained within it, including compute and container registries.  
- It is recommended to double-check "All Resources" in the Azure portal to ensure no active resources remain.  

**Examples**  
- Manually deleting compute services before deleting the resource group as a cautious approach.  
- Checking the container registry within the resource group to confirm it is included in the deletion process.  

**Key Takeaways 🎯**  
- Always clean up compute resources and resource groups after completing ML projects to avoid unnecessary charges.  
- Use the Azure portal’s resource group deletion feature to remove all related resources at once.  
- Double-check the "All Resources" view in Azure portal to confirm no resources are left running.  
- Being "paranoid" and manually deleting resources before deleting the resource group is a good practice for thorough cleanup.
