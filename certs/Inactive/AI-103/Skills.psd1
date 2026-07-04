# -------------------------------------------------------------------------
# Data: Skills.psd1
# Description: Domain, skill, and task hierarchy for the AI-103 exam
# Context: AI-103 — Develop AI Apps and Agents on Azure
# Author: Greg Tate
# -------------------------------------------------------------------------
# Source: Official Microsoft Learn study guide (Skills measured as of
# April 16, 2026): https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-103
# -------------------------------------------------------------------------

@{
    Domains = @(
        @{
            Name   = 'Plan and manage an Azure AI solution'
            Skills = @(
                @{
                    Name  = 'Choose the appropriate Foundry services for generative AI and agents'
                    Tasks = @(
                        'Choose an appropriate model for each task, including large language models (LLMs), small language models, multimodal models, and Foundry Tools'
                        'Choose the appropriate Foundry services for generative tasks, grounding, vector search, agent workflows, or multimodal processing'
                        'Choose an appropriate method for retrieval and indexing'
                        'Choose appropriate memory, tool, and knowledge integration services for agent solutions'
                    )
                }
                @{
                    Name  = 'Set up AI solutions in Foundry'
                    Tasks = @(
                        'Design Azure infrastructure for AI apps and agent-based solutions'
                        'Choose appropriate deployment options'
                        'Configure model and agent deployments'
                        'Integrate Foundry projects with continuous integration and continuous deployment (CI/CD) pipelines'
                    )
                }
                @{
                    Name  = 'Manage, monitor, and secure AI systems'
                    Tasks = @(
                        'Manage quotas, scaling, rate limits, and cost footprints for model and agent workloads'
                        'Monitor model performance, drift, safety events, and grounding quality'
                        'Monitor data ingestion quality, search index health, and relevance performance'
                        'Configure security, including managed identity, private networking, keyless credentials, and role policies'
                    )
                }
                @{
                    Name  = 'Implement responsible AI across generative AI and agentic systems'
                    Tasks = @(
                        'Configure safety filters, guardrails, risk detection, and content moderation'
                        'Apply responsible AI instrumentation, including evaluators, safety evaluations, and explanation tooling'
                        'Implement auditing through trace logging, provenance metadata, and approval workflows'
                        'Govern agent behavior with oversight modes, constraints, and tool-access controls'
                    )
                }
            )
        }
        @{
            Name   = 'Implement generative AI and agentic solutions'
            Skills = @(
                @{
                    Name  = 'Build generative applications by using Foundry'
                    Tasks = @(
                        'Deploy and consume LLMs, small models, code models, and multimodal models'
                        'Implement retrieval-augmented generation (RAG) in an application'
                        'Design workflows, tool-augmented flows, and multistep reasoning pipelines'
                        'Evaluate models and apps, including detecting fabrications, relevance, quality, and safety'
                        'Integrate generative workflows into applications by using Foundry SDKs and connectors'
                        'Configure an application to connect to a Foundry project'
                    )
                }
                @{
                    Name  = 'Build agents by using Foundry'
                    Tasks = @(
                        'Define agent roles, goals, conversation-tracking approach, and tool schemas'
                        'Build agents that integrate retrieval, function-calling, and conversation memory'
                        'Integrate agent tools, including APIs, knowledge stores, search, content understanding, and custom functions'
                        'Implement orchestrated multi-agent solutions'
                        'Build autonomous or semiautonomous workflows with safeguards and approval flow controls'
                        'Integrate monitoring into deployed agents, evaluate agent behavior, and perform error analysis'
                    )
                }
                @{
                    Name  = 'Optimize and operationalize generative AI systems'
                    Tasks = @(
                        'Tune generation behavior, such as prompt engineering and adjusting model parameters'
                        'Implement model reflection, chain-of-thought evaluations, and self-critique loops'
                        'Set up observability by implementing tracing, token analytics, safety signals, and latency breakdowns'
                        'Orchestrate multiple models, flows, or hybrid LLM and rules engines'
                    )
                }
            )
        }
        @{
            Name   = 'Implement computer vision solutions'
            Skills = @(
                @{
                    Name  = 'Design and implement image- and video-generation solutions'
                    Tasks = @(
                        'Implement a solution that generates images from text prompts and reference media'
                        'Implement a solution that generates videos from text prompts and reference media'
                        'Configure image-editing workflows, including inpainting, mask-based edits, and prompt-driven modifications'
                        'Implement workflows to edit generated videos'
                        'Select and apply appropriate generation and editing controls provided by the platform'
                    )
                }
                @{
                    Name  = 'Design and implement multimodal understanding workflows'
                    Tasks = @(
                        'Build a solution that analyzes visual context by using multimodal models'
                        'Configure apps to produce concise or detailed captions for single or multiple images'
                        'Implement a solution that enables question-answering grounded in visual evidence'
                        'Configure generation of alt-text and extended image descriptions aligned to accessibility guidelines'
                        'Implement visual understanding by configuring Azure Content Understanding in Foundry Tools to extract visual characteristics'
                        'Implement video analysis workflows to process and interpret video segments'
                        'Configure single-task and pro-mode Content Understanding pipelines'
                        'Implement solutions that identify objects, components, or regions within images or video'
                    )
                }
                @{
                    Name  = 'Implement responsible AI for multimodal content'
                    Tasks = @(
                        'Implement filters to classify unsafe or disallowed visual content'
                        'Detect and mitigate indirect prompt injection by using embedded text in images'
                        'Enforce visual policy rules, such as applying watermarks, flagging prohibited symbols, upholding brand usage requirements, and detecting potentially inappropriate content'
                    )
                }
            )
        }
        @{
            Name   = 'Implement text analysis solutions'
            Skills = @(
                @{
                    Name  = 'Apply language model text analysis'
                    Tasks = @(
                        'Implement solutions to extract entities, topics, summaries, and structured JSON outputs by using generative prompting and Foundry Tools'
                        'Configure detection of sentiment, tone, safety issues, and sensitive content'
                        'Build solutions that translate text by using Azure Translator in Foundry Tools or LLM-powered translation flows'
                        'Customize language model outputs for domain tasks, such as compliance summarization and domain extraction'
                    )
                }
                @{
                    Name  = 'Implement speech solutions'
                    Tasks = @(
                        'Implement workflows to convert speech to text and text to speech for agentic interactions'
                        'Integrate speech as an agent modality, including custom speech models'
                        'Enable multimodal reasoning from audio inputs'
                        'Translate speech into other languages by using language models and Foundry Tools'
                    )
                }
            )
        }
        @{
            Name   = 'Implement information extraction solutions'
            Skills = @(
                @{
                    Name  = 'Build retrieval and grounding pipelines'
                    Tasks = @(
                        'Ingest and index content, such as documents, images, audio, and video'
                        'Configure semantic search, hybrid search, and vector search for grounding'
                        'Implement enrichment by using custom or built-in skills for text, images, and layout'
                        'Configure RAG ingestion flow, including documents and using optical character recognition (OCR)'
                        'Connect retrieval pipelines directly to workflows and agent tools'
                    )
                }
                @{
                    Name  = 'Extract content from documents'
                    Tasks = @(
                        'Extract information by using multimodal pipelines that combine OCR, layout analysis, and field extraction'
                        'Produce clean, grounded representations to use with agents and RAG by using Content Understanding'
                        'Implement analyzers for generating structured or markdown outputs for downstream reasoning by using Content Understanding'
                    )
                }
            )
        }
    )
}
