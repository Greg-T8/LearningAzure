---
name: question-extraction
description: Procedure for extracting structured metadata from exam questions (screenshot or text).
---

# Question Extraction

Procedure for extracting structured metadata from Azure certification exam questions. Used by the Lab-Intake agent (Phase 1).

## When to Use

- Ingesting an exam question for lab creation
- Extracting metadata from a screenshot or text passage
- Identifying Azure services from exam scenarios

---

## R-100: Screenshot Extraction Procedure

When input is a screenshot image:

1. Use vision capabilities to read all text from the image.
2. Capture the complete question prompt verbatim.
3. Capture all answer options exactly as shown.
4. Note any diagrams or visual elements described in the image.
5. If text is partially occluded or unclear, flag it and ask for clarification.

---

## R-101: Text Parsing Procedure

When input is pasted text:

1. Identify the question prompt (usually starts with a scenario description).
2. Identify answer options (typically labeled A, B, C, D or Yes/No statements).
3. Separate the scenario narrative from the actual question being asked.
4. Preserve exact wording — do not paraphrase or edit the question.

---

## R-102: Metadata Output Format

Extract and return these fields:

| Field          | How to Determine                                                                          |
| -------------- | ----------------------------------------------------------------------------------------- |
| exam           | From surrounding context, or infer: Azure admin topics → AZ-104, AI/ML topics → AI-102   |
| domain         | Map primary topic to Azure domain: Networking, Storage, Compute, Identity & Governance, Monitoring, Generative AI, Computer Vision, NLP, Knowledge Mining, Agentic |
| topic          | Create a hyphenated lowercase slug from the specific skill tested (e.g., `vnet-peering`, `blob-versioning`, `dalle-image-gen`) |
| correct_answer | Identify the correct option using Azure technical knowledge                               |
| key_services   | List all Azure services that must be deployed to demonstrate the concept                  |

---

## R-103: When-to-Use Criteria

Use this skill when:

- An exam question is provided (image or text) and metadata needs extraction
- This is the first step in the lab creation pipeline
- The deployment method has not yet been determined
