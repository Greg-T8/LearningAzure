// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameters for AI Agent Service standard setup lab
// Context: AI-102 Lab - Agent file upload storage configuration
// Author: Greg Tate
// Date: 2026-02-13
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and topic (used for stack naming and resource group naming)
param domain = 'ai-services'
param topic = 'agent-storage-config'

// Azure region (westus: confirmed capacity for AI Search basic, Cosmos DB, AI Services, GPT-4.1)
param location = 'westus'

// Lab owner
param owner = 'Greg Tate'

// Static date (governance: never use utcNow for tags)
param dateCreated = '2026-02-13'

// Model deployment parameters
param modelName = 'gpt-4.1'
param modelFormat = 'OpenAI'
param modelVersion = '2025-04-14'
param modelSkuName = 'GlobalStandard'
param modelCapacity = 40
