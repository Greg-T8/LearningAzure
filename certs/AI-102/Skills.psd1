# -------------------------------------------------------------------------
# Data: Skills.psd1
# Description: Domain, skill, and task hierarchy for the AI-102 exam
# Context: AI-102 — Designing and Implementing a Microsoft Azure AI Solution
# Author: Greg Tate
# -------------------------------------------------------------------------

@{
    Domains = @(
        @{
            Name   = 'Plan and Manage an Azure AI Solution'
            Skills = @(
                @{
                    Name  = 'Select the appropriate Microsoft Foundry Services'
                    Tasks = @(
                        'Select the appropriate service for a generative AI solution'
                        'Select the appropriate service for a computer vision solution'
                        'Select the appropriate service for a natural language processing solution'
                        'Select the appropriate service for a speech solution'
                        'Select the appropriate service for an information extraction solution'
                        'Select the appropriate service for a knowledge mining solution'
                    )
                }
                @{
                    Name  = 'Plan, create and deploy a Microsoft Foundry Service'
                    Tasks = @(
                        'Plan for a solution that meets Responsible AI principles'
                        'Create an Azure AI resource'
                        'Choose the appropriate AI models for your solution'
                        'Deploy AI models using the appropriate deployment options'
                        'Install and utilize the appropriate SDKs and APIs'
                        'Determine a default endpoint for a service'
                        'Integrate Microsoft Foundry Services into a continuous integration and continuous delivery (CI/CD) pipeline'
                        'Plan and implement a container deployment'
                    )
                }
                @{
                    Name  = 'Manage, monitor, and secure a Microsoft Foundry Service'
                    Tasks = @(
                        'Monitor an Azure AI resource'
                        'Manage costs for Microsoft Foundry Services'
                        'Manage and protect account keys'
                        'Manage authentication for a Microsoft Foundry Service resource'
                    )
                }
                @{
                    Name  = 'Implement AI solutions responsibly'
                    Tasks = @(
                        'Implement content moderation solutions'
                        'Configure responsible AI insights, including content safety'
                        'Implement responsible AI, including content filters and blocklists'
                        'Prevent harmful behavior, including prompt shields and harm detection'
                        'Design a responsible AI governance framework'
                    )
                }
            )
        }
        @{
            Name   = 'Implement Generative AI Solutions'
            Skills = @(
                @{
                    Name  = 'Build generative AI solutions with Microsoft Foundry'
                    Tasks = @(
                        'Plan and prepare for a generative AI solution'
                        'Deploy a hub, project, and necessary resources with Microsoft Foundry'
                        'Deploy the appropriate generative AI model for your use case'
                        'Implement a prompt flow solution'
                        'Implement a RAG pattern by grounding a model in your data'
                        'Evaluate models and flows'
                        'Integrate your project into an application with Microsoft Foundry SDK'
                        'Utilize prompt templates in your generative AI solution'
                    )
                }
                @{
                    Name  = 'Use Azure OpenAI in Foundry Models to generate content'
                    Tasks = @(
                        'Provision an Azure OpenAI in Foundry Models resource'
                        'Select and deploy an Azure OpenAI model'
                        'Submit prompts to generate code and natural language responses'
                        'Use the DALL-E model to generate images'
                        'Integrate Azure OpenAI into your own application'
                        'Use large multimodal models in Azure OpenAI'
                    )
                }
                @{
                    Name  = 'Optimize and operationalize a generative AI solution'
                    Tasks = @(
                        'Configure parameters to control generative behavior'
                        'Configure model monitoring and diagnostic settings, including performance and resource consumption'
                        'Optimize and manage resources for deployment, including scalability and foundational model updates'
                        'Enable tracing and collect feedback'
                        'Implement model reflection'
                        'Deploy containers for use on local and edge devices'
                        'Implement orchestration of multiple generative AI models'
                        'Apply prompt engineering techniques to improve responses'
                        'Fine-tune a generative model'
                    )
                }
            )
        }
        @{
            Name   = 'Implement an Agentic Solution'
            Skills = @(
                @{
                    Name  = 'Create custom agents'
                    Tasks = @(
                        'Understand the role and use cases of an agent'
                        'Configure the necessary resources to build an agent'
                        'Create an agent with the Microsoft Foundry Agent Service'
                        'Implement complex agents with Microsoft Agent Framework'
                        'Implement complex workflows including orchestration for a multi-agent solution, multiple users, and autonomous capabilities'
                        'Test, optimize and deploy an agent'
                    )
                }
            )
        }
        @{
            Name   = 'Implement Computer Vision Solutions'
            Skills = @(
                @{
                    Name  = 'Analyze images'
                    Tasks = @(
                        'Select visual features to meet image processing requirements'
                        'Detect objects in images and generate image tags'
                        'Include image analysis features in an image processing request'
                        'Interpret image processing responses'
                        'Extract text from images using Azure Vision in Foundry Tools'
                        'Convert handwritten text using Azure Vision in Foundry Tools'
                    )
                }
                @{
                    Name  = 'Implement custom vision models'
                    Tasks = @(
                        'Choose between image classification and object detection models'
                        'Label images'
                        'Train a custom image model, including image classification and object detection'
                        'Evaluate custom vision model metrics'
                        'Publish a custom vision model'
                        'Consume a custom vision model'
                        'Build a custom vision model code first'
                    )
                }
                @{
                    Name  = 'Analyze videos'
                    Tasks = @(
                        'Use Azure AI Video Indexer to extract insights from a video or live stream'
                        'Use Azure Vision in Foundry Tools Spatial Analysis to detect presence and movement of people in video'
                    )
                }
            )
        }
        @{
            Name   = 'Implement Natural Language Processing Solutions'
            Skills = @(
                @{
                    Name  = 'Analyze and translate text'
                    Tasks = @(
                        'Extract key phrases and entities'
                        'Determine sentiment of text'
                        'Detect the language used in text'
                        'Detect personally identifiable information (PII) in text'
                        'Translate text and documents by using the Azure Translator in Foundry Tools service'
                    )
                }
                @{
                    Name  = 'Process and translate speech'
                    Tasks = @(
                        'Integrate generative AI speaking capabilities in an application'
                        'Implement text-to-speech and speech-to-text using Azure Speech in Foundry Tools'
                        'Improve text-to-speech by using Speech Synthesis Markup Language (SSML)'
                        'Implement custom speech solutions with Azure Speech in Foundry Tools'
                        'Implement intent and keyword recognition with Azure Speech in Foundry Tools'
                        'Translate speech-to-speech and speech-to-text by using the Azure Speech in Foundry Tools service'
                    )
                }
                @{
                    Name  = 'Implement custom language models'
                    Tasks = @(
                        'Create intents, entities, and add utterances'
                        'Train, evaluate, deploy, and test a language understanding model'
                        'Optimize, backup, and recover language understanding model'
                        'Consume a language model from a client application'
                        'Create a custom question answering project'
                        'Add question-and-answer pairs and import sources for question answering'
                        'Train, test, and publish a knowledge base'
                        'Create a multi-turn conversation'
                        'Add alternate phrasing and chit-chat to a knowledge base'
                        'Export a knowledge base'
                        'Create a multi-language question answering solution'
                        'Implement custom translation, including training, improving, and publishing a custom model'
                    )
                }
            )
        }
        @{
            Name   = 'Implement Knowledge Mining and Information Extraction Solutions'
            Skills = @(
                @{
                    Name  = 'Implement an Azure AI Search solution'
                    Tasks = @(
                        'Provision an Azure AI Search resource, create an index, and define a skillset'
                        'Create data sources and indexers'
                        'Implement custom skills and include them in a skillset'
                        'Create and run an indexer'
                        'Query an index, including syntax, sorting, filtering, and wildcards'
                        'Manage Knowledge Store projections, including file, object, and table projections'
                        'Implement semantic and vector store solutions'
                    )
                }
                @{
                    Name  = 'Implement an Azure Document Intelligence in Foundry Tools solution'
                    Tasks = @(
                        'Provision a Document Intelligence resource'
                        'Use prebuilt models to extract data from documents'
                        'Implement a custom document intelligence model'
                        'Train, test, and publish a custom document intelligence model'
                        'Create a composed document intelligence model'
                    )
                }
                @{
                    Name  = 'Extract information with Azure Content Understanding in Foundry Tools'
                    Tasks = @(
                        'Create an OCR pipeline to extract text from images and documents'
                        'Summarize, classify, and detect attributes of documents'
                        'Extract entities, tables, and images from documents'
                        'Process and ingest documents, images, videos, and audio with Azure Content Understanding in Foundry Tools'
                    )
                }
            )
        }
    )
}
