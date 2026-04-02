# -------------------------------------------------------------------------
# Data: Skills.psd1
# Description: Interim domain/skill hierarchy for the AI-103 exam
# Context: AI-103 — Develop AI Apps and Agents on Azure
# Author: Greg Tate
# -------------------------------------------------------------------------
# NOTE: This is an INTERIM hierarchy derived from the official Microsoft
# Learn learning paths and modules for AI-103T00. It exists solely to
# enable Invoke-AzStudySession.ps1 session logging while the official
# study guide (with domains, skills, and tasks) has not yet been released.
#
# When the study guide is published, replace this file with the official
# domain → skill → task hierarchy using the new-exam-scaffold workflow.
# -------------------------------------------------------------------------

@{
    Domains = @(
        @{
            Name   = 'Develop generative AI apps in Azure'
            Skills = @(
                @{
                    Name  = 'Plan and prepare to develop AI solutions on Azure'
                    Tasks = @()
                }
                @{
                    Name  = 'Select, deploy, and evaluate Microsoft Foundry models'
                    Tasks = @()
                }
                @{
                    Name  = 'Develop a generative AI chat app with Microsoft Foundry'
                    Tasks = @()
                }
                @{
                    Name  = 'Develop generative AI apps that use tools'
                    Tasks = @()
                }
                @{
                    Name  = 'Optimize generative AI model performance with Microsoft Foundry'
                    Tasks = @()
                }
                @{
                    Name  = 'Implement a responsible generative AI solution in Microsoft Foundry'
                    Tasks = @()
                }
            )
        }
        @{
            Name   = 'Develop AI agents on Azure'
            Skills = @(
                @{
                    Name  = 'Develop AI agents with Microsoft Foundry and Visual Studio Code'
                    Tasks = @()
                }
                @{
                    Name  = 'Integrate custom tools into your agent'
                    Tasks = @()
                }
                @{
                    Name  = 'Integrate MCP Tools with Azure AI Agents'
                    Tasks = @()
                }
                @{
                    Name  = 'Build knowledge-enhanced AI agents with Foundry IQ'
                    Tasks = @()
                }
                @{
                    Name  = 'Integrate your agent with Microsoft 365'
                    Tasks = @()
                }
                @{
                    Name  = 'Build agent-driven workflows using Microsoft Foundry'
                    Tasks = @()
                }
                @{
                    Name  = 'Develop an AI agent with Microsoft Agent Framework'
                    Tasks = @()
                }
                @{
                    Name  = 'Orchestrate a multi-agent solution using the Microsoft Agent Framework'
                    Tasks = @()
                }
                @{
                    Name  = 'Discover Azure AI Agents with A2A'
                    Tasks = @()
                }
            )
        }
        @{
            Name   = 'Develop natural language solutions in Azure'
            Skills = @(
                @{
                    Name  = 'Analyze text with Azure Language in Foundry Tools'
                    Tasks = @()
                }
                @{
                    Name  = 'Develop a text analysis agent with the Azure Language MCP server'
                    Tasks = @()
                }
                @{
                    Name  = 'Develop a speech-capable generative AI application'
                    Tasks = @()
                }
                @{
                    Name  = 'Create speech-enabled apps with Azure Speech in Microsoft Foundry Tools'
                    Tasks = @()
                }
                @{
                    Name  = 'Develop a speech agent with the Azure Speech MCP server'
                    Tasks = @()
                }
                @{
                    Name  = 'Develop an Azure Speech Voice Live Agent in Microsoft Foundry'
                    Tasks = @()
                }
                @{
                    Name  = 'Translate text and speech with Microsoft Foundry Tools'
                    Tasks = @()
                }
            )
        }
        @{
            Name   = 'Extract insights from visual data on Azure'
            Skills = @(
                @{
                    Name  = 'Develop a vision-enabled generative AI application'
                    Tasks = @()
                }
                @{
                    Name  = 'Generate images with AI'
                    Tasks = @()
                }
                @{
                    Name  = 'Generate videos with Microsoft Foundry'
                    Tasks = @()
                }
                @{
                    Name  = 'Analyze images with Content Understanding'
                    Tasks = @()
                }
                @{
                    Name  = 'Create a multimodal analysis solution with Azure Content Understanding'
                    Tasks = @()
                }
                @{
                    Name  = 'Create an Azure Content Understanding client application'
                    Tasks = @()
                }
                @{
                    Name  = 'Extract data with Azure Document Intelligence'
                    Tasks = @()
                }
                @{
                    Name  = 'Create a knowledge mining solution with Azure AI Search'
                    Tasks = @()
                }
            )
        }
    )
}
