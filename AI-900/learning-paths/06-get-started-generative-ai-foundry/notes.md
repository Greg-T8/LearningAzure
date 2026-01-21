# Module 6: Get started with generative AI in Microsoft Foundry

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/get-started-generative-ai-azure/)
* [Understand generative AI applications](#understand-generative-ai-applications)
* [Understand generative AI development in Foundry](#understand-generative-ai-development-in-foundry)
* [Understand Foundry's model catalog](#understand-foundrys-model-catalog)
* [Understand Foundry capabilities](#understand-foundry-capabilities)
* [Understand observability](#understand-observability)

---

## Understand generative AI applications

[Module Reference](https://learn.microsoft.com/en-us/training/modules/get-started-generative-ai-azure/2-generative-ai)

**Generative AI applications**

* Built with **language models**
* Language models power the **app logic** that manages interactions between users and generative AI

**Assistants**

* Common form of generative AI presented as **chat-based assistants**
* Integrated into applications to help users **find information** and **perform tasks efficiently**
* **Microsoft Copilot**

  * A generative AI–based assistant integrated across Microsoft applications and experiences
  * **Business users** use it to improve productivity and creativity with AI-generated content and task automation
  * **Developers** can extend it by:

    * Creating plug-ins
    * Integrating Copilot with business processes and data
    * Building copilot-like agents for apps and services

**Agents**

* Generative AI systems that can **execute tasks autonomously**
* Can respond to user input or **assess situations and take actions**
* Designed to support **multi-step task execution**
* Example use case:

  * An executive assistant agent that:

    * Retrieves meeting location
    * Attaches a map
    * Automates taxi or rideshare booking

**Core components of agents**

* **Language model** – Powers reasoning and language understanding
* **Instructions** – Define goals, behavior, and constraints
* **Tools (functions)** – Enable task execution

**Orchestration**

* Modern AI solutions often combine:

  * Assistant capabilities
  * Agentic behaviors
  * Other AI components
* **Orchestration** is the coordination and management of:

  * Models
  * Data sources
  * Tools
  * Workflows
* Ensures multiple AI components work together in a unified solution

**Framework for generative AI applications**

* Generative AI applications can be grouped into **three categories**, increasing in customization:

| Category                                   | Description                                                                                        |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------- |
| **Ready-to-use**                           | No programming required; users interact by asking questions                                        |
| **Extendable**                             | Ready-to-use applications that can be customized with user data to support business-specific tasks |
| **Applications built from the foundation** | Custom assistants and agents built directly from a language model                                  |

* **Microsoft Copilot** is both **ready-to-use** and **extendable**
* Common services used for extending or building applications:

  * **Copilot Studio** – Extends Microsoft 365 Copilot
  * **Microsoft Foundry** – Builds AI solutions using different models

**Key Facts to Remember**

* Generative AI applications are powered by **language models**
* **Assistants** focus on user interaction and task support
* **Agents** can act autonomously and complete multi-step tasks
* Agents require **models, instructions, and tools**
* **Orchestration** coordinates multiple AI components
* Generative AI applications fall into **three categories** based on customization level

---

## Understand generative AI development in Foundry

[Module Reference](https://learn.microsoft.com/en-us/training/modules/get-started-generative-ai-azure/3-tools-to-develop-solutions)

**Overview**

* Microsoft provides an ecosystem of tools and services for building **generative AI solutions** across the AI lifecycle.
* This module focuses on **Microsoft Foundry**, a unified platform for **enterprise AI operations**, **model builders**, and **application development**.
* Microsoft Foundry is a **platform as a service (PaaS)** offering control over **customization of language models** used in applications.
* Models built in Foundry can be **deployed in the cloud** and **consumed by custom-developed apps and services**.
* Microsoft Foundry provides a **user interface** for building, customizing, and managing **AI applications and agents**, especially those using generative AI.

**Components of Microsoft Foundry**

* **Microsoft Foundry model catalog**

  * Centralized hub to **discover, compare, and deploy models** for generative AI development.
* **Playgrounds**

  * Ready-to-use environments for **testing ideas**, **trying models**, and **exploring Foundry Models**.
* **Foundry Tools**

  * Used to **build, test, view demos, and deploy** tools within Microsoft Foundry.
* **Solutions**

  * Supports **building agents** and **customizing models**.
* **Observability**

  * Enables **monitoring usage and performance** of application models.

**Related Microsoft Generative AI Tool**

* **Microsoft Copilot Studio**

  * Designed for **low-code development** of conversational AI.
  * Enables business users and developers to create AI experiences with minimal infrastructure management.
  * Produces a **fully managed SaaS agent** hosted in the **Microsoft 365 environment**.
  * Delivered through chat channels such as **Microsoft Teams**.
  * Infrastructure and model deployment are handled automatically, allowing focus on solution design.

**Key Facts to Remember**

* **Microsoft Foundry** is a **PaaS** for enterprise generative AI development.
* Foundry supports **model customization, deployment, and consumption** by applications.
* Core components include **model catalog, playgrounds, tools, solutions, and observability**.
* **Copilot Studio** targets **low-code**, fully managed conversational AI scenarios.

---

## Understand Foundry's model catalog

[Module Reference](https://learn.microsoft.com/training/modules/get-started-generative-ai-microsoft-foundry/)

**Microsoft Foundry Model Catalog**

* Provides a **comprehensive marketplace** of models
* Includes:

  * **Microsoft first-party models**
  * **Partner and community models**
* Models are available for **direct deployment** from the catalog

**Azure OpenAI in Foundry Models**

* Represent Microsoft’s **first-party model family**
* Classified as **foundation models**
* **Foundation models** are:

  * Pretrained on **large text datasets**
  * Capable of being **fine-tuned with relatively small datasets**
* Can be:

  * **Deployed immediately** without extra training
  * **Customized** for improved performance on:

    * Specific tasks
    * Domain-specific knowledge

**Model Selection and Evaluation**

* Models can be tested using **playgrounds**
* **Model leaderboards (preview)** are available to:

  * Compare model performance
  * Evaluate models across criteria such as:

    * **Quality**
    * **Cost**
    * **Throughput**
* Leaderboards include **graphical comparisons** based on specific metrics

**Key Facts to Remember**

* **Model catalog** includes Microsoft, partner, and community models
* **Azure OpenAI models** are foundation models
* **No training required** to deploy a model
* **Customization is optional** for task or domain specialization
* **Playgrounds and leaderboards** help compare and select models

---

## Understand Foundry capabilities

[Module Reference](https://learn.microsoft.com/training/modules/get-started-generative-ai-microsoft-foundry/understand-foundry-capabilities)

**Foundry Structure**

* Microsoft Foundry uses a **hub-and-project** model.
* **Hubs**

  * Provide broader access to **Azure AI** and **Azure Machine Learning**.
  * Serve as a container for multiple projects.
* **Projects**

  * Created within a hub.
  * Provide focused access to **models** and **agent development**.
  * Managed from the **Microsoft Foundry overview page**.

**Azure AI Hub Resource Creation**

* Creating an **Azure AI Hub** automatically creates supporting resources.
* Includes a **Foundry Tools resource** created in tandem.

**Foundry Tools**

* Tools available for testing directly in Microsoft Foundry include:

  * **Azure Speech**
  * **Azure Language**
  * **Azure Vision**
  * **Microsoft Foundry Content Safety**
* Tools can be explored through:

  * **Demos**
  * **Playgrounds**

**Playgrounds**

* Playgrounds allow testing of:

  * **Foundry Tools**
  * **Models from the model catalog**
* Includes specialized environments such as:

  * **Chat playground**

**Model Customization Methods**

* **Using grounding data**

  * Aligns model outputs with **factual, contextual, or reliable data sources**
  * Can use databases, search engines, or domain-specific knowledge bases
  * Improves **trustworthiness** and **applicability**
* **Implementing Retrieval-Augmented Generation (RAG)**

  * Connects models to **organization-owned proprietary data**
  * Retrieves relevant information to generate accurate responses
  * Useful for **real-time, dynamic data** scenarios (e.g., customer support)
* **Fine-tuning**

  * Further trains a pretrained model on a **task-specific dataset**
  * Improves **domain specialization**, **accuracy**, and relevance
* **Managing security and governance controls**

  * Controls **access**, **authentication**, and **data usage**
  * Helps prevent **unauthorized or incorrect information publication**

**Key Facts to Remember**

* **Hubs** provide broad AI/ML access; **projects** provide focused development scope.
* Creating an **Azure AI Hub** automatically provisions **Foundry Tools**.
* **Playgrounds** are used to test tools and models without deployment.
* Four main customization approaches: **grounding**, **RAG**, **fine-tuning**, and **security/governance**.
* **RAG** is best suited for applications requiring **up-to-date or proprietary data**.

---

## Understand observability

[Module Reference](https://learn.microsoft.com/)

**Dimensions for Evaluating Generative AI**

* **Performance and quality evaluators** – Assess **accuracy**, **groundedness**, and **relevance** of generated content.
* **Risk and safety evaluators** – Assess potential risks to safeguard against **harmful or inappropriate content**, including an AI system’s predisposition to generate such content.
* **Custom evaluators** – **Industry-specific metrics** designed to meet particular needs and goals.

**Microsoft Foundry Observability**

* Microsoft Foundry provides **observability features** to improve the **performance** and **trustworthiness** of generative AI responses.
* **Evaluators** are specialized tools in Microsoft Foundry that measure **quality**, **safety**, and **reliability** of AI responses.

**Types of Evaluators**

* **Groundedness** – Measures how consistent the response is with the **retrieved context**.
* **Relevance** – Measures how relevant the response is to the **query**.
* **Fluency** – Measures **natural language quality** and **readability**.
* **Coherence** – Measures **logical consistency** and **flow** of responses.
* **Content safety** – Provides a **comprehensive assessment** of safety concerns.

**Key Facts to Remember**

* Observability in Microsoft Foundry focuses on **quality**, **safety**, and **reliability** of generative AI.
* Evaluators fall into **performance/quality**, **risk/safety**, and **custom** categories.
* **Groundedness** and **relevance** rely on alignment with context and query, not just fluency.

---
