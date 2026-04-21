# AI-103: Develop AI Apps and Agents on Azure — Study Guide

**Objective:** Achieve the **Azure AI Engineer Associate** certification using Microsoft Learn, practice exams, and video courses.

- **Certification Page:** [Azure AI Engineer Associate](https://learn.microsoft.com/en-us/credentials/certifications/azure-ai-engineer/)
- **Official Study Guide:** [AI-103 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-103)
- **Study Log:** [Session-by-session study time tracker](./StudyLog.md)

<!-- STUDY_SUMMARY -->
**Hours Committed:** 11.2h · **Days Studied:** 11
<!-- /STUDY_SUMMARY -->


> **Study workflow (two phases).** Phase 1 — work through every Microsoft Learn module in the [Learning Paths](#-learning-paths) table. Phase 2 — tackle each exam skill one-by-one.

---

## 📚 Learning Paths

Phase 1 — finish all MSLearn modules before per-skill deep dives.

| # | Learning Path | Modules | Est. Time | Status | Completed |
|:--|:------------- |--------:|----------:|:-------|:----------|
| 1 | [Develop generative AI apps in Azure](https://learn.microsoft.com/en-us/training/paths/develop-generative-ai-apps/) | 6 | 6h 52m | Completed | 4/21/26 |
| 2 | [Develop AI agents on Azure](https://learn.microsoft.com/en-us/training/paths/develop-ai-agents-azure/) | 9 | 9h 52m | Not Started | |
| 3 | [Develop natural language solutions in Azure](https://learn.microsoft.com/en-us/training/paths/develop-language-solutions-azure-ai/) | 7 | 5h 53m | Not Started | |
| 4 | [Extract insights from visual data on Azure](https://learn.microsoft.com/en-us/training/paths/insight-visual-data/) | 8 | 7h 6m | Not Started | |
| | **Totals** | **30** | **~29h 43m** | | |

---

## 📊 Exam Coverage

Skill-level coverage based on [Per-Skill Progress](#per-skill-progress) completion.

<!-- BEGIN COVERAGE DASHBOARD -->

| Domain | Weight | Skills | Skills Covered | Status |
| :----- | :----- | -----: | :------------- | :----: |
| [1. Plan & Manage AI Solutions](#domain-1) | 25–30% | 4 | 0 / 4 (0%) | 🔴 |
| [2. Generative AI & Agentic Solutions](#domain-2) | 30–35% | 3 | 0 / 3 (0%) | 🔴 |
| [3. Computer Vision Solutions](#domain-3) | 10–15% | 3 | 0 / 3 (0%) | 🔴 |
| [4. Text Analysis Solutions](#domain-4) | 10–15% | 2 | 0 / 2 (0%) | 🔴 |
| [5. Information Extraction Solutions](#domain-5) | 10–15% | 2 | 0 / 2 (0%) | 🔴 |

**Totals:** 0 / 0 skills completed

**Legend:** 🟢 Strong (≥66%) · 🟡 Partial (33–65%) · 🔴 Low (<33%) — "Covered" = skill completed in Per-Skill Progress

<!-- END COVERAGE DASHBOARD -->

<!-- BEGIN COVERAGE TABLE -->

<a id="domain-1"></a>
<details>
<summary><b>Domain 1: Plan and manage an Azure AI solution (25–30%)</b> — 18 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Choose the appropriate Foundry services for generative AI and agents | Choose an appropriate model for each task, including large language models (LLMs), small language models, multimodal models, and Foundry Tools |
|  | Choose the appropriate Foundry services for generative tasks, grounding, vector search, agent workflows, or multimodal processing |
|  | Choose an appropriate method for retrieval and indexing |
|  | Choose appropriate memory, tool, and knowledge integration services for agent solutions |
| Set up AI solutions in Foundry | Design Azure infrastructure for AI apps and agent-based solutions |
|  | Choose appropriate deployment options |
|  | Configure model and agent deployments |
|  | Integrate Foundry projects with continuous integration and continuous deployment (CI/CD) pipelines |
| Manage, monitor, and secure AI systems | Manage quotas, scaling, rate limits, and cost footprints for model and agent workloads |
|  | Monitor model performance, drift, safety events, and grounding quality |
|  | Monitor data ingestion quality, search index health, and relevance performance |
|  | Configure security, including managed identity, private networking, keyless credentials, and role policies |
| Implement responsible AI across generative AI and agentic systems | Configure safety filters, guardrails, risk detection, and content moderation |
|  | Apply responsible AI instrumentation, including evaluators, safety evaluations, and explanation tooling |
|  | Implement auditing through trace logging, provenance metadata, and approval workflows |
|  | Govern agent behavior with oversight modes, constraints, and tool-access controls |

</details>

<a id="domain-2"></a>
<details>
<summary><b>Domain 2: Implement generative AI and agentic solutions (30–35%)</b> — 18 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Build generative applications by using Foundry | Deploy and consume LLMs, small models, code models, and multimodal models |
|  | Implement retrieval-augmented generation (RAG) in an application |
|  | Design workflows, tool-augmented flows, and multistep reasoning pipelines |
|  | Evaluate models and apps, including detecting fabrications, relevance, quality, and safety |
|  | Integrate generative workflows into applications by using Foundry SDKs and connectors |
|  | Configure an application to connect to a Foundry project |
| Build agents by using Foundry | Define agent roles, goals, conversation-tracking approach, and tool schemas |
|  | Build agents that integrate retrieval, function-calling, and conversation memory |
|  | Integrate agent tools, including APIs, knowledge stores, search, content understanding, and custom functions |
|  | Implement orchestrated multi-agent solutions |
|  | Build autonomous or semiautonomous workflows with safeguards and approval flow controls |
|  | Integrate monitoring into deployed agents, evaluate agent behavior, and perform error analysis |
| Optimize and operationalize generative AI systems | Tune generation behavior, such as prompt engineering and adjusting model parameters |
|  | Implement model reflection, chain-of-thought evaluations, and self-critique loops |
|  | Set up observability by implementing tracing, token analytics, safety signals, and latency breakdowns |
|  | Orchestrate multiple models, flows, or hybrid LLM and rules engines |

</details>

<a id="domain-3"></a>
<details>
<summary><b>Domain 3: Implement computer vision solutions (10–15%)</b> — 18 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Design and implement image- and video-generation solutions | Implement a solution that generates images from text prompts and reference media |
|  | Implement a solution that generates videos from text prompts and reference media |
|  | Configure image-editing workflows, including inpainting, mask-based edits, and prompt-driven modifications |
|  | Implement workflows to edit generated videos |
|  | Select and apply appropriate generation and editing controls provided by the platform |
| Design and implement multimodal understanding workflows | Build a solution that analyzes visual context by using multimodal models |
|  | Configure apps to produce concise or detailed captions for single or multiple images |
|  | Implement a solution that enables question-answering grounded in visual evidence |
|  | Configure generation of alt-text and extended image descriptions aligned to accessibility guidelines |
|  | Implement visual understanding by configuring Azure Content Understanding in Foundry Tools to extract visual characteristics |
|  | Implement video analysis workflows to process and interpret video segments |
|  | Configure single-task and pro-mode Content Understanding pipelines |
|  | Implement solutions that identify objects, components, or regions within images or video |
| Implement responsible AI for multimodal content | Implement filters to classify unsafe or disallowed visual content |
|  | Detect and mitigate indirect prompt injection by using embedded text in images |
|  | Enforce visual policy rules, such as applying watermarks, flagging prohibited symbols, upholding brand usage requirements, and detecting potentially inappropriate content |

</details>

<a id="domain-4"></a>
<details>
<summary><b>Domain 4: Implement text analysis solutions (10–15%)</b> — 10 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Apply language model text analysis | Implement solutions to extract entities, topics, summaries, and structured JSON outputs by using generative prompting and Foundry Tools |
|  | Configure detection of sentiment, tone, safety issues, and sensitive content |
|  | Build solutions that translate text by using Azure Translator in Foundry Tools or LLM-powered translation flows |
|  | Customize language model outputs for domain tasks, such as compliance summarization and domain extraction |
| Implement speech solutions | Implement workflows to convert speech to text and text to speech for agentic interactions |
|  | Integrate speech as an agent modality, including custom speech models |
|  | Enable multimodal reasoning from audio inputs |
|  | Translate speech into other languages by using language models and Foundry Tools |

</details>

<a id="domain-5"></a>
<details>
<summary><b>Domain 5: Implement information extraction solutions (10–15%)</b> — 10 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Build retrieval and grounding pipelines | Ingest and index content, such as documents, images, audio, and video |
|  | Configure semantic search, hybrid search, and vector search for grounding |
|  | Implement enrichment by using custom or built-in skills for text, images, and layout |
|  | Configure RAG ingestion flow, including documents and using optical character recognition (OCR) |
|  | Connect retrieval pipelines directly to workflows and agent tools |
| Extract content from documents | Extract information by using multimodal pipelines that combine OCR, layout analysis, and field extraction |
|  | Produce clean, grounded representations to use with agents and RAG by using Content Understanding |
|  | Implement analyzers for generating structured or markdown outputs for downstream reasoning by using Content Understanding |

</details>

<!-- END COVERAGE TABLE -->

---

## 📚 Progress Tracker

**Goal:** Pass AI-103 by ~Sep 1, 2026

### Per-Skill Progress

| # | Domain | Skill | Tasks | ML | MD | NB | Lab | PQ | Hours | Progress |
| -: | :----- | :---- | ----: | :-: | :-: | :-: | :-: | :-: | ----: | :------- |
| 1 | Plan & Manage | Choose the appropriate Foundry services for generative AI and agents | 4 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 2 | Plan & Manage | Set up AI solutions in Foundry | 4 | ⏳ 3.0h | 🔲 | 🔲 | 🔲 | 🔲 | 3.0h | ⏳ 4/2/26 → _ · 19d |
| 3 | Plan & Manage | Manage, monitor, and secure AI systems | 4 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 4 | Plan & Manage | Implement responsible AI across generative AI and agentic systems | 4 | ⏳ 0.9h | 🔲 | 🔲 | 🔲 | 🔲 | 0.9h | ⏳ 4/21/26 → _ · 0d |
| 5 | Generative AI & Agentic | Build generative applications by using Foundry | 6 | ⏳ 5.5h | 🔲 | 🔲 | 🔲 | 🔲 | 5.5h | ⏳ 4/8/26 → _ · 13d |
| 6 | Generative AI & Agentic | Build agents by using Foundry | 6 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 7 | Generative AI & Agentic | Optimize and operationalize generative AI systems | 4 | ⏳ 1.9h | 🔲 | 🔲 | 🔲 | 🔲 | 1.9h | ⏳ 4/17/26 → _ · 4d |
| 8 | Computer Vision | Design and implement image- and video-generation solutions | 5 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 9 | Computer Vision | Design and implement multimodal understanding workflows | 8 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 10 | Computer Vision | Implement responsible AI for multimodal content | 3 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 11 | Text Analysis | Apply language model text analysis | 4 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 12 | Text Analysis | Implement speech solutions | 4 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 13 | Information Extraction | Build retrieval and grounding pipelines | 5 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |
| 14 | Information Extraction | Extract content from documents | 3 | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | 0.0h | 🔲 |

**Modalities:**

- **ML** (MSLearn) — Microsoft Learning Paths/Modules
- **MD** (MSDocs) — Reading through Microsoft Documentation
- **NB** (NotebookLM) — Generated practice quizzes based on Microsoft Documentation sources
- **Lab** (Lab) — Generated hands-on labs from curated topics
- **PQ** (PracticeQuestion) — Practice questions from MeasureUp or Microsoft assessment

---