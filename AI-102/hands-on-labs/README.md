# AI-102 Hands-On Labs

This page catalogs hands-on labs built from practice exam questions. Each lab uses Terraform or Azure Bicep to create dedicated environments for testing specific AI-102 concepts.

---

## 📈 Lab Statistics

- **Total Labs**: 4
- **Generative AI**: 1
- **Agentic**: 1
- **AI Services**: 1
- **Computer Vision**: 0
- **Natural Language Processing**: 0
- **Knowledge Mining**: 1

---

## 🧪 Labs

### Generative AI

- **[DALL-E Image Generation with Azure OpenAI](generative-ai/lab-dalle-image-gen/README.md)** - Test DALL-E 3 image generation capabilities, model parameters, and Azure AI Foundry portal features

### Agentic

- **[Azure AI Agent Service File Upload Configuration](agentic/lab-agent-file-upload-config/README.md)** - Configure standard agent setup with correct RBAC roles for BYO storage, Cosmos DB, and AI Search resources

### AI Services

- **[Azure AI Content Safety - Text and Image Moderation](ai-services/lab-content-safety/README.md)** - AI-powered text and image content moderation for sexual content, violence, hate, and self-harm detection

### Knowledge Mining

- **[Azure AI Search — Improve Query Performance with Partitions](knowledge-mining/lab-search-query-perf/README.md)** - Deploy Azure AI Search with multiple partitions to optimize query performance and understand the difference between partitions and replicas

---

## 📋 Governance & Standards

All labs in this repository are built following the comprehensive governance policy documented in [Governance-Lab.md](../../Governance-Lab.md). This ensures:

- **Consistent naming conventions** for resource groups and resources
- **Standardized tagging** across all deployments for tracking and cleanup
- **Cost management practices** including resource limits and auto-shutdown policies
- **Code quality standards** with proper header comments and structured code
- **Best practices** for infrastructure-as-code patterns in Terraform and Bicep

---
