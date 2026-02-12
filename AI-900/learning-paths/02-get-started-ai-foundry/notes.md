# Module 2: Get started with AI in Microsoft Foundry

**Link:** [Getting started with AI in Microsoft Foundry](https://learn.microsoft.com/en-us/training/modules/get-started-ai-in-foundry/)

* [What is an AI application?](#what-is-an-ai-application)
* [Components of an AI application](#components-of-an-ai-application)
* [Microsoft Foundry for AI](#microsoft-foundry-for-ai)
* [Get started with Foundry](#get-started-with-foundry)
* [Understand Azure](#understand-azure)

---

## What is an AI application?

[Module Reference](URL)

**Artificial Intelligence (AI)**

* Systems designed to perform tasks that typically require human intelligence, including **reasoning**, **problem-solving**, **perception**, and **language understanding**
* **Responsible AI** emphasizes **fairness**, **transparency**, and **ethical use** of AI technologies

**Key AI Workloads**

* **Generative AI**
* **Agents and automation**
* **Speech**
* **Text analysis**
* **Computer Vision**
* **Information Extraction**
* All AI workloads are built on the foundation of **machine learning (ML)**

<img src='.img/2026-01-17-06-14-22.png' width=800>

**AI vs. Machine Learning**

* **AI** is the broader goal of creating systems that mimic human intelligence
* **Machine Learning (ML)** is the primary method used to achieve AI

  * Uses **data-driven algorithms**
  * Enables systems to **learn patterns from data** and **improve without explicit programming**

**Types of Machine Learning**

* **Supervised Learning**

  * Examples: **Regression** (predicting prices), **Classification** (spam detection)
* **Unsupervised Learning**

  * Example: **Clustering** (customer segmentation)
* **Deep Learning**

  * Specialized branch of ML using **neural networks with multiple layers**
  * Used for tasks like **image recognition** and **speech synthesis**
  * Learns complex patterns from **massive datasets**
* **Generative AI**

  * Uses deep learning to **create new content**
  * Content types include **text**, **images**, **audio**, and **code**
  * Focuses on creation rather than prediction or classification

**AI Applications**

* Software solutions that use AI techniques such as:

  * **Computer vision**
  * **Speech**
  * **Information extraction**
* Perform tasks requiring **human-like intelligence**
* Capable of **understanding**, **reasoning**, **learning**, and **responding** adaptively

**Characteristics of AI Applications**

* **Model-powered**

  * Use trained models to process inputs and generate outputs (text, images, decisions)
* **Dynamic**

  * Can improve over time through **retraining** or **fine-tuning**

**Common Interaction Models**

* **Conversational Interfaces**

  * Chatbots and voice assistants for questions and recommendations
* **Embedded Features**

  * AI integrated into applications (autocomplete, image recognition, fraud detection)
* **Decision Support**

  * Provides insights or predictions for informed decision-making
  * Examples: personalized shopping, medical diagnostics
* **Automation**

  * Handles repetitive tasks such as document processing and customer service

**Industry Examples of AI Applications**

* **Healthcare**

  * Diagnostic tools analyzing medical images (X-rays, MRIs)
* **Finance**

  * Real-time fraud detection systems monitoring transactions
* **Retail**

  * Personalized recommendation engines based on customer behavior
* **Manufacturing**

  * Predictive maintenance to forecast equipment failures
* **Education**

  * Intelligent tutoring systems adapting to student learning styles and pace

**Key Facts to Remember**

* **All AI workloads rely on machine learning**
* **Generative AI creates new content**, not just predictions
* **Deep learning uses multi-layer neural networks**
* **AI applications are model-powered and adaptive**
* **Responsible AI focuses on fairness, transparency, and ethics**

---

## Components of an AI application

[Module Reference](https://learn.microsoft.com/training/modules/introduction-to-ai-in-azure/)

**Overview**

* Microsoft supports four layers of an AI application:

  * **Data layer**
  * **Model layer**
  * **Compute layer**
  * **Integration and orchestration layer**

**Data Layer**

* Foundation of any AI application
* Includes **collection, storage, and management of data** used for:

  * Training
  * Inference
  * Decision-making
* Common data sources:

  * **Structured data** (for example, Azure SQL, PostgreSQL)
  * **Unstructured data** (documents, images)
  * **Real-time data streams**
* Azure services commonly used:

  * **Azure Cosmos DB**
  * **Azure Data Lake**
* Microsoft provides databases as **Platform-as-a-Service (PaaS)**

  * Managed cloud services
  * No need to manage underlying infrastructure
  * **PaaS sits between IaaS and SaaS** in the cloud service model

**Model Layer**

* Focuses on **selection, training, and deployment** of AI or machine learning models
* Model types:

  * **Pretrained models** (for example, Azure OpenAI in Foundry Models)
  * **Custom-built models** using Azure Machine Learning
* Includes capabilities for:

  * **Fine-tuning**
  * **Evaluation**
  * **Versioning**
* **Microsoft Foundry**:

  * Unified Azure PaaS for enterprise AI operations
  * Provides a **comprehensive model catalog** for developers

**Compute Layer**

* Provides resources required to **train and run AI models**
* Microsoft compute options:

  * **Azure App Service** – hosting web apps and APIs
  * **Azure Functions** – serverless, event-driven execution
  * **Containers** – scalable, portable deployments

    * **Azure Container Instances (ACI)** – lightweight, serverless containers for rapid deployment and simple scaling
    * **Azure Kubernetes Service (AKS)** – fully managed Kubernetes for enterprise-level orchestration
* **APIs**:

  * Define required information for component interaction
  * Enable **secure communication** between software components

**Integration and Orchestration Layer**

* Connects **models and data** with:

  * Business logic
  * User interfaces
* Foundry capabilities:

  * **Agent Service** for building intelligent agents that can reason and act
  * **AI tools** such as speech, vision, and language APIs
  * **SDKs and APIs** for application integration
  * **Portal tools** for managing models, agents, and workflows
* Foundry enables embedding intelligence **directly within the data layer** for more responsive applications

**Key Facts to Remember**

* An AI application has **four layers**: data, model, compute, and integration/orchestration
* **PaaS** databases are managed services and sit **between IaaS and SaaS**
* **Foundry** is a unified Azure PaaS for enterprise AI with a model catalog and orchestration tools
* **ACI** is optimized for rapid, lightweight container execution
* **AKS** provides enterprise-grade Kubernetes orchestration

---

## Microsoft Foundry for AI

[Module Reference](https://learn.microsoft.com/training/modules/get-started-ai-microsoft-foundry/)

**Overview**

* **Microsoft Foundry** is a **unified, enterprise-grade platform** for building, deploying, and managing **AI applications and agents**
* Consolidates **models, agent orchestration, monitoring, and governance** into a single platform
* Provides **production-grade infrastructure and security**
* Enables developers to **design, customize, and scale generative AI applications** via:

  * A rich **portal experience**
  * **Integrated SDKs**
* Abstracts underlying infrastructure complexities

**Foundry Portal Capabilities**

* **Foundry Models**

  * Access to **foundation and partner models**
  * Includes **Azure OpenAI in Foundry Models**, **Anthropic**, **Cohere**, and others
* **Agent Service**

  * Build and orchestrate **multi-step AI workflows**
* **Foundry Tools**

  * Prebuilt Azure AI services such as **Vision**, **Language**, **Search**, and **Document Intelligence**
* **Governance & Observability**

  * Centralized **identity**, **policy**, and **monitoring** for AI workloads

**Foundry Models**

* Supports **thousands of models** from:

  * First-party providers
  * Third-party providers
  * Open-source models (e.g., **Meta Llama**, **Mistral**)
* Includes **gpt-4**, **gpt-5 series**, and **multimodal variants**
* Capabilities include:

  * Testing and customization in a **playground**
  * Deploying models as **agents**
  * **Lifecycle management**
  * **Region-specific deployments**
  * **Model version control**

**Agent Service**

* Core service for building **production-ready AI agents**
* Agents can:

  * **Autonomously make decisions**
  * **Call external tools**
  * **Automate workflows**
* Abstracts:

  * Orchestration
  * Thread management
  * Tool invocation
* Embeds governance features:

  * **Content safety**
  * **Observability**
* Supports:

  * **Low-code** and **code-first** multi-agent systems
  * Integration with **documents**, **databases**, and services
  * Built-in integrations such as **Azure Functions** and **Microsoft Fabric**

**Foundry Tools**

* Suite of Azure AI services available via:

  * Portal
  * APIs
  * SDKs
* Includes:

  * Speech
  * Vision
  * Language
  * Document Intelligence
  * Content Safety
  * Embeddings
* **Over a dozen services** usable individually or together
* Example use cases:

  * Image analysis with **Vision**
  * Text summarization, classification, and key phrase extraction with **Language**
  * Speech-to-text and text-to-speech with **Speech**

**Governance and Observability**

* **Governance**

  * Ensures **responsible AI development**
  * Focuses on **compliance**, **identity management**, and **risk mitigation**
* **Observability**

  * Provides **end-to-end visibility** into:

    * Performance
    * Safety
    * Operational efficiency
* Embedded throughout the **AI development lifecycle**
* Provides:

  * Unified dashboard for **performance, quality, and safety metrics**
  * **Lifecycle monitoring**
  * **Continuous feedback loops**

**Key Facts to Remember**

* **Microsoft Foundry** unifies models, agents, tools, governance, and monitoring in one platform
* **Agent Service** is central to building autonomous, production-ready AI agents
* **Foundry Models** support thousands of first-party, third-party, and open-source models
* **Governance and observability** are embedded by default across the AI lifecycle
* Foundry supports **portal-based and SDK-based** development

---

## Get started with Foundry

[Module Reference](https://learn.microsoft.com/training/modules/get-started-ai-foundry/)

**Foundry Project Basics**

* A **project** is the primary workspace for building AI applications and agents.
* A project is created after signing in with an **Azure subscription**.
* Creating a project results in:

  * A **resource group** in the Azure subscription
  * A **Microsoft Foundry resource** deployed in a specified region

**What You Get with a Foundry Project**

* **Model catalog**

  * Foundation models
  * Partner models
* **Playgrounds** for testing models
* **Tools** for:

  * Deploying models
  * Running evaluations
  * Creating agents
* **Management Center** for:

  * User roles
  * Quotas
  * Resource connections

**Development Capabilities**

* Developers can:

  * Experiment in playgrounds
  * Deploy models
  * Integrate models via **SDKs or APIs**
  * Build and test **agentic workflows**
* Includes **observability** and **Responsible AI** features

**When to Choose a Foundry Project**

* Use a Foundry project when you need:

  * The **latest agents**
  * **Evaluations**
  * The **model catalog**
  * **Minimal Azure setup**
* To access additional services (for example, Azure Language, Speech, Vision), create a **Hub** in addition to a project

**Characteristics of Foundry Offerings**

* **Prebuilt and ready to use or customize**
* **Accessed through APIs**
* **Available on Azure**

**Prebuilt and Ready to Use**

* Foundry uses **pretrained machine learning models** to deliver AI as a service.
* Removes traditional barriers to AI adoption:

  * Large training datasets
  * Massive compute requirements
  * Specialized programming expertise
* Uses **high-performance Azure computing** to deploy advanced AI models.
* Makes decades of AI research accessible to developers of all skill levels.

**Accessed Through APIs**

* Foundry models and tools integrate into applications using **APIs**.
* API access requires **authentication** to verify:

  * Identity
  * Authorization
* Authentication uses:

  * **Resource key** – secret used to prove identity
  * **Endpoint** – identifies how to reach the AI service resource
* Requests to Foundry resources must be authenticated.
* Keys and endpoints must be included in the **authentication header**.
* Resource keys can be **rotated periodically** to maintain security.

**Key Facts to Remember**

* A **project** is the core workspace in Foundry.
* Creating a project creates both a **resource group** and a **Foundry resource**.
* Foundry provides **models, tools, playgrounds, and management** in one place.
* Foundry AI services are **prebuilt**, **API-driven**, and **Azure-based**.
* API access requires both a **resource key** and an **endpoint**.
* Create a **Hub** to access additional Azure AI services.

---

## Understand Azure

[Module Reference](https://learn.microsoft.com/training/modules/get-started-with-ai-in-microsoft-foundry/)

**What is Microsoft Azure**

* **Microsoft Azure** is a cloud computing platform for building, deploying, and managing applications through Microsoft-managed data centers.
* Provides **flexibility**, **scalability**, and **global reach**.
* Supports **multiple programming languages, frameworks, and operating systems**, allowing developers to use preferred tools.

**Core Cloud Capabilities**

Azure delivers cloud services across **four main areas**:

* **Compute**

  * Virtual machines
  * Containers
  * Serverless functions
* **Storage**

  * Scalable and secure data storage
  * Examples include **Blob Storage** and **Azure Files**
* **Networking**

  * Secure and reliable connectivity between resources
  * Examples include **Azure Virtual Network** and **Load Balancer**
* **Application Services**

  * Services to build and host web apps, APIs, and mobile backends

**Azure Resource Organization Hierarchy**

Azure organizes access and management using a structured hierarchy:

* **Tenant**

  * A dedicated instance of **Azure Active Directory**
  * Manages identity and access
* **Subscription**

  * Defines **billing boundaries**
  * Provides access to Azure services
* **Resource Group**

  * Logical container for related resources
* **Resources**

  * Individual services such as virtual machines, databases, or storage accounts

**Benefits of the Azure Hierarchy**

* Enables **clear separation of concerns** across teams or projects
* Improves **security and governance**
* Simplifies **policy application**, **monitoring**, and **automation**
* Supports effective **cost control**

**Foundry Runs on Azure**

* **Foundry runs on Azure** and uses Azure resource types.
* Foundry is an **AI development layer within Azure**.
* Designed to accelerate building and managing **generative AI applications and agents**.
* Foundry **projects and hubs** are Azure resources.
* Integrates with Azure **networking, storage, and security**.

**Foundry Tools and Models**

* Foundry Tools and models are **cloud-based**.
* Accessed through a **Foundry resource**.
* Managed like other Azure services, including:

  * Platform as a Service (PaaS)
  * Infrastructure as a Service (IaaS)
  * Managed database services
* **Azure Resource Manager** provides consistent handling for:

  * Resource creation and deletion
  * Availability
  * Billing

**Typical Workflow**

* Start with an **Azure subscription**
* Create a **Foundry project**
* Develop and manage an **AI application**

**Key Facts to Remember**

* Azure organizes resources as **Tenant → Subscription → Resource Group → Resource**
* Azure core service areas: **Compute, Storage, Networking, Application Services**
* Foundry is **built on Azure**, not separate from it
* Foundry resources follow the **same management, billing, and governance model** as other Azure services
* An **Azure subscription is required** to create and use a Foundry project

---

*Last updated: 2026-01-16*
