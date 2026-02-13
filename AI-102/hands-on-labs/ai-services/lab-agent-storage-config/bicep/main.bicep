// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Deploy Azure AI Agent Service standard setup with BYOS storage
// Context: AI-102 Lab - Agent file upload storage configuration
// Author: Greg Tate
// Date: 2026-02-13
// -------------------------------------------------------------------------

targetScope = 'subscription'

// -------------------------------------------------------------------------
// Parameters
// -------------------------------------------------------------------------

@allowed(['ai102', 'az104'])
@description('Certification exam code')
param exam string = 'ai102'

@allowed(['ai-services', 'generative-ai', 'computer-vision', 'nlp', 'knowledge-mining'])
@description('AI-102 exam domain')
param domain string = 'ai-services'

@description('Lab topic in kebab-case')
param topic string = 'agent-storage-config'

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner')
param owner string = 'Greg Tate'

@description('Resource creation date (YYYY-MM-DD, static value)')
param dateCreated string

@description('The name of the model to deploy')
param modelName string = 'gpt-4.1'

@description('The model provider format')
param modelFormat string = 'OpenAI'

@description('The model version')
param modelVersion string = '2025-04-14'

@description('The SKU name for model deployment')
param modelSkuName string = 'GlobalStandard'

@description('Tokens per minute (TPM) capacity')
param modelCapacity int = 40

// -------------------------------------------------------------------------
// Variables
// -------------------------------------------------------------------------

// Resource group name follows governance pattern
var resourceGroupName = '${exam}-${domain}-${topic}-bicep'

// Unique suffix for globally unique resource names
var uniqueSuffix = substring(uniqueString(subscription().id, resourceGroupName), 0, 6)

// Resource names following governance naming conventions
var aiAccountName = toLower('cog-agent-${uniqueSuffix}')
var projectName = toLower('mfp-agent-${uniqueSuffix}')
var storageName = toLower('stai102agent${uniqueSuffix}')
var cosmosDBName = toLower('cosmos-agent-${uniqueSuffix}')
var aiSearchName = toLower('srch-agent-${uniqueSuffix}')

// Common tags for all resources (governance-required)
var commonTags = {
  Environment: 'Lab'
  Project: toUpper(exam)
  Domain: 'AI Services'
  Purpose: 'Agent Storage Configuration'
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

// -------------------------------------------------------------------------
// Resource Group
// -------------------------------------------------------------------------
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: commonTags
}

// -------------------------------------------------------------------------
// Agent dependencies (Storage, Cosmos DB, AI Search)
// -------------------------------------------------------------------------
module agentDependencies 'modules/agent-dependencies.bicep' = {
  scope: rg
  name: 'agent-dependencies-deployment'
  params: {
    location: location
    storageName: storageName
    cosmosDBName: cosmosDBName
    aiSearchName: aiSearchName
    commonTags: commonTags
  }
}

// -------------------------------------------------------------------------
// AI Foundry Account, Model Deployment, Project, and Connections
// -------------------------------------------------------------------------
module aiFoundry 'modules/ai-foundry.bicep' = {
  scope: rg
  name: 'ai-foundry-deployment'
  params: {
    location: location
    aiAccountName: aiAccountName
    projectName: projectName
    modelName: modelName
    modelFormat: modelFormat
    modelVersion: modelVersion
    modelSkuName: modelSkuName
    modelCapacity: modelCapacity
    storageName: agentDependencies.outputs.storageName
    cosmosDBName: agentDependencies.outputs.cosmosDBName
    aiSearchName: agentDependencies.outputs.aiSearchName
    commonTags: commonTags
  }
}

// -------------------------------------------------------------------------
// Role assignments (Storage Blob Data Owner - KEY EXAM CONCEPT)
// -------------------------------------------------------------------------
module roleAssignments 'modules/role-assignments.bicep' = {
  scope: rg
  name: 'role-assignments-deployment'
  params: {
    storageName: agentDependencies.outputs.storageName
    aiSearchName: agentDependencies.outputs.aiSearchName
    cosmosDBName: agentDependencies.outputs.cosmosDBName
    projectPrincipalId: aiFoundry.outputs.projectPrincipalId
    workspaceId: aiFoundry.outputs.projectWorkspaceId
  }
}

// -------------------------------------------------------------------------
// Capability hosts (storage connection string - KEY EXAM CONCEPT)
// -------------------------------------------------------------------------
module capabilityHost 'modules/capability-host.bicep' = {
  scope: rg
  name: 'capability-host-deployment'
  params: {
    aiAccountName: aiFoundry.outputs.aiAccountName
    projectName: aiFoundry.outputs.projectName
    storageConnectionName: aiFoundry.outputs.storageConnectionName
    cosmosDBConnectionName: aiFoundry.outputs.cosmosDBConnectionName
    aiSearchConnectionName: aiFoundry.outputs.aiSearchConnectionName
  }
  dependsOn: [
    roleAssignments
  ]
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Resource group name')
output resourceGroupName string = rg.name

@description('AI Services account name')
output aiAccountName string = aiFoundry.outputs.aiAccountName

@description('AI Foundry project name')
output projectName string = aiFoundry.outputs.projectName

@description('Project managed identity principal ID')
output projectPrincipalId string = aiFoundry.outputs.projectPrincipalId

@description('Storage account name')
output storageName string = agentDependencies.outputs.storageName

@description('AI Services endpoint')
output aiServicesEndpoint string = aiFoundry.outputs.aiServicesEndpoint
