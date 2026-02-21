---
name: lab-question-metadata
description: "Determine structured metadata from an exam question: exam, domain, topic, correct answer, and key Azure services. Used by Lab-Intake for Phase 1 metadata extraction."
user-invokable: false
---

# Exam Question Metadata

Analyzes an exam question (text or transcription from screenshot) and produces structured metadata used by the lab pipeline. This skill contains **no formatting rules** — question formatting is owned by the `exam-question-extractor` skill.

---

## R-100: Metadata Fields

Extract **all** of the following from the exam question:

| Field            | Type     | Description                                                        |
| ---------------- | -------- | ------------------------------------------------------------------ |
| `exam`           | string   | Certification code: `AI-102`, `AZ-104`, or `AI-900`               |
| `domain`         | string   | Azure domain (e.g., Networking, Storage, Generative AI)            |
| `topic`          | string   | Kebab-case slug for naming (e.g., `vnet-peering`, `blob-versioning`) |
| `correct_answer` | string   | Correct option letter/selection (e.g., `B`, `Yes/No/Yes`)         |
| `key_services`   | string[] | Azure services the lab must deploy (e.g., `[VNet, NSG, Route Table]`) |

---

## R-101: Field Derivation Rules

### exam

Determine the exam from contextual clues in the question:

| Clue                                                        | Exam     |
| ----------------------------------------------------------- | -------- |
| Networking, VMs, storage accounts, load balancers, RBAC, DNS, subscriptions, monitoring | `AZ-104` |
| AI services, Cognitive Services, OpenAI, AI Search, Language, Vision, Speech, Document Intelligence | `AI-102` |
| Foundational AI concepts, responsible AI, machine learning basics, Azure AI Foundry overview | `AI-900` |

If the user explicitly states the exam, use their value.

### domain

Map the question's subject to one of these domains:

**AZ-104 domains:**

| Domain                                | Example Topics                                       |
| ------------------------------------- | ---------------------------------------------------- |
| Identity                              | Entra ID, RBAC, users, groups, service principals    |
| Governance                            | Policies, locks, blueprints, management groups, tags |
| Storage                               | Blob, files, queues, tables, access tiers, SAS       |
| Compute                               | VMs, scale sets, App Service, containers, ACI, AKS   |
| Networking                            | VNets, peering, NSGs, load balancers, DNS, VPN, ExpressRoute |
| Monitoring                            | Monitor, alerts, Log Analytics, diagnostics           |

**AI-102 domains:**

| Domain                                | Example Topics                                       |
| ------------------------------------- | ---------------------------------------------------- |
| AI Services                           | Multi-service accounts, keys, endpoints, regions     |
| Generative AI                         | OpenAI, prompt engineering, embeddings, RAG          |
| NLP                                   | Language Understanding, text analytics, translation, QnA |
| Computer Vision                       | Image analysis, OCR, Custom Vision, Face, Video Indexer |
| Knowledge Mining                      | AI Search, indexers, skillsets, knowledge stores      |
| Agentic                               | AI agents, orchestration, Semantic Kernel            |

**AI-900 domains:**

| Domain                                | Example Topics                                       |
| ------------------------------------- | ---------------------------------------------------- |
| AI Concepts                           | Responsible AI, AI workloads, ML fundamentals        |
| Machine Learning                      | Automated ML, regression, classification, clustering |
| Computer Vision                       | Image classification, object detection, OCR          |
| NLP                                   | Text analytics, speech, translation, conversational AI |
| Generative AI                         | Azure OpenAI, prompt engineering, copilots           |

### topic

Generate a kebab-case slug (2–4 words) that concisely identifies the scenario:

- Derived from the core concept being tested
- Must be unique enough to distinguish from other labs in the same domain
- Examples: `vnet-peering`, `blob-versioning`, `content-safety`, `custom-skill-indexer`

### correct_answer

Identify the correct answer based on Azure documentation and best practices:

- **Multiple Choice**: Letter (e.g., `B`) or letters if multi-select (e.g., `A, C`)
- **Yes / No**: Pipe-separated values matching statement order (e.g., `Yes | No | Yes`)
- **Drop-Down**: Numbered selections (e.g., `Select 1: Option B | Select 2: Option A`)

> **Important:** The correct answer is metadata for lab creation only. It must **not** appear in the lab README.

### key_services

List the Azure services that the question and correct answer require:

- Include only services that would need to be **deployed or configured** in a lab
- Use official Azure service short names (e.g., `VNet`, `NSG`, `Azure OpenAI`, `AI Search`)
- Order by deployment dependency (foundational resources first)

---

## R-102: Validation Checklist

Before returning metadata, verify:

- [ ] All five fields are populated
- [ ] `exam` matches one of: `AI-102`, `AZ-104`, `AI-900`
- [ ] `domain` matches a domain from R-101 tables
- [ ] `topic` is kebab-case, 2–4 words, no special characters
- [ ] `correct_answer` is defensible against official Azure documentation
- [ ] `key_services` contains at least one service
- [ ] `key_services` entries use official Azure naming

If any field cannot be confidently determined, flag it and ask the user for clarification.

---

## Output Format

Return metadata as a structured block:

```
### Metadata
- Exam: [AI-102 | AZ-104 | AI-900]
- Domain: [domain name]
- Topic: [topic-slug]
- Correct Answer: [answer]
- Key Services: [comma-separated list]
```
