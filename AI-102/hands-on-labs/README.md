# AI-102 Hands-On Labs

This page catalogs hands-on labs built from practice exam questions. Each lab uses Terraform or Azure Bicep to create dedicated environments for testing specific AI-102 concepts.


---

## 📊 Lab Statistics

- **Total Labs**: 7
- **Generative AI**: 2
- **Agentic**: 2
- **AI Services**: 2
- **Computer Vision**: 0
- **Natural Language Processing**: 0
- **Knowledge Mining**: 1

---

## 🧪 Labs

### Generative AI

- **[DALL-E Image Generation with Azure OpenAI](generative-ai/lab-dalle-image-gen/README.md)** - This lab deploys:
- **[Select an Azure AI Deployment Strategy](generative-ai/lab-ai-deployment-strategy/README.md)** - This lab deploys an Azure OpenAI account with three model deployments — Standard (pay-per-token), Provisioned Managed...

### Agentic

- **[Azure AI Agent Service — BYO Storage Configuration and RBAC](agentic/lab-agent-byo-storage/README.md)** - This lab deploys the infrastructure required for an Azure AI Agent Service **standard agent setup** with bring-your-o...
- **[Azure AI Agent Service — Essentials: Threads, Files, and Vector Stores](agentic/lab-agent-essentials/README.md)** - This lab deploys a **basic agent setup** using Azure AI Foundry to teach core agent service concepts hands-on.

### AI Services

- **[Azure AI Content Safety - Text and Image Moderation](ai-services/lab-content-safety/README.md)** - This lab deploys an Azure AI Content Safety resource so you can explore both **text moderation** and **image moderati...
- **[Document Intelligence Invoice Model Capabilities](ai-services/lab-doc-intelligence-invoice/README.md)** - This lab deploys an Azure AI Document Intelligence (Form Recognizer) resource to test the prebuilt invoice model.

### Computer Vision

- No labs available.

### Natural Language Processing

- No labs available.

### Knowledge Mining

- **[Azure AI Search — Improve Query Performance with Partitions](knowledge-mining/lab-search-query-perf/README.md)** - This lab deploys an Azure AI Search service with the **Basic** SKU configured with multiple partitions to demonstrate...

---

## 📋 Governance & Standards

All labs in this repository are built following the comprehensive governance policy documented in [Governance-Lab.md](../../.assets/shared/Governance-Lab.md). This ensures:

- **Consistent naming conventions** for resource groups and resources
- **Standardized tagging** across all deployments for tracking and cleanup
- **Cost management practices** including resource limits and auto-shutdown policies
- **Code quality standards** with proper header comments and structured code
- **Best practices** for infrastructure-as-code patterns in Terraform and Bicep

---
