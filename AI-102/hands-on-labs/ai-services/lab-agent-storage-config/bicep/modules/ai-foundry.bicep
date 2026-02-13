// -------------------------------------------------------------------------
// Program: ai-foundry.bicep
// Description: Deploy AI Services Account, model, project, and connections
// Context: AI-102 Lab - Agent file upload storage configuration
// Author: Greg Tate
// Date: 2026-02-13
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('AI Services account name')
param aiAccountName string

@description('AI Foundry project name')
param projectName string

@description('Model name to deploy')
param modelName string

@description('Model format (provider)')
param modelFormat string

@description('Model version')
param modelVersion string

@description('Model deployment SKU')
param modelSkuName string

@description('Model TPM capacity')
param modelCapacity int

@description('Storage account name for connection')
param storageName string

@description('Cosmos DB account name for connection')
param cosmosDBName string

@description('AI Search service name for connection')
param aiSearchName string

@description('Common tags for all resources')
param commonTags object

// -------------------------------------------------------------------------
// Reference existing dependent resources (created by agent-dependencies)
// -------------------------------------------------------------------------

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageName
}

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: cosmosDBName
}

resource searchService 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: aiSearchName
}

// -------------------------------------------------------------------------
// AI Services Account (Foundry account with project management)
// -------------------------------------------------------------------------
resource aiAccount 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: aiAccountName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    allowProjectManagement: true
    customSubDomainName: aiAccountName
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
  }
  tags: union(commonTags, {
    Purpose: 'AI Agent Service Account'
  })
}

// -------------------------------------------------------------------------
// Model deployment (GPT-4.1 for agent conversations)
// -------------------------------------------------------------------------
resource modelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2025-04-01-preview' = {
  parent: aiAccount
  name: modelName
  sku: {
    capacity: modelCapacity
    name: modelSkuName
  }
  properties: {
    model: {
      name: modelName
      format: modelFormat
      version: modelVersion
    }
  }
}

// -------------------------------------------------------------------------
// AI Foundry Project (sub-resource of account)
// The project's system-assigned managed identity is used for RBAC.
// KEY EXAM CONCEPT: This identity needs Storage Blob Data Owner role.
// -------------------------------------------------------------------------
resource project 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' = {
  parent: aiAccount
  name: projectName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: 'AI Agent Service lab project for storage configuration testing'
    displayName: 'Agent Storage Config Lab'
  }

  // Storage connection - KEY EXAM CONCEPT
  // The capability host references this connection name. If the connection
  // string (target endpoint) is incorrect, file uploads will fail.
  resource storageConnection 'connections@2025-04-01-preview' = {
    name: storageName
    properties: {
      category: 'AzureStorageAccount'
      target: storageAccount.properties.primaryEndpoints.blob
      authType: 'AAD'
      metadata: {
        ApiType: 'Azure'
        ResourceId: storageAccount.id
        location: storageAccount.location
      }
    }
  }

  // Cosmos DB connection (thread/conversation storage)
  resource cosmosConnection 'connections@2025-04-01-preview' = {
    name: cosmosDBName
    properties: {
      category: 'CosmosDB'
      target: cosmosDBAccount.properties.documentEndpoint
      authType: 'AAD'
      metadata: {
        ApiType: 'Azure'
        ResourceId: cosmosDBAccount.id
        location: cosmosDBAccount.location
      }
    }
  }

  // AI Search connection (vector store)
  resource searchConnection 'connections@2025-04-01-preview' = {
    name: aiSearchName
    properties: {
      category: 'CognitiveSearch'
      target: 'https://${aiSearchName}.search.windows.net'
      authType: 'AAD'
      metadata: {
        ApiType: 'Azure'
        ResourceId: searchService.id
        location: searchService.location
      }
    }
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('AI Services account name')
output aiAccountName string = aiAccount.name

@description('AI Foundry project name')
output projectName string = project.name

@description('Project managed identity principal ID (used for RBAC)')
output projectPrincipalId string = project.identity.principalId

@description('Project workspace ID (used for container name conditions)')
#disable-next-line BCP053
output projectWorkspaceId string = project.properties.internalId

@description('Storage connection name (referenced by capability host)')
output storageConnectionName string = storageName

@description('Cosmos DB connection name (referenced by capability host)')
output cosmosDBConnectionName string = cosmosDBName

@description('AI Search connection name (referenced by capability host)')
output aiSearchConnectionName string = aiSearchName

@description('AI Services endpoint URL')
output aiServicesEndpoint string = aiAccount.properties.endpoint
