// -------------------------------------------------------------------------
// Program: agent-dependencies.bicep
// Description: Deploy agent dependent resources (Storage, Cosmos DB, AI Search)
// Context: AI-102 Lab - Agent file upload storage configuration
// Author: Greg Tate
// Date: 2026-02-13
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Name of the storage account')
param storageName string

@description('Name of the Cosmos DB account')
param cosmosDBName string

@description('Name of the AI Search service')
param aiSearchName string

@description('Common tags for all resources')
param commonTags object

// -------------------------------------------------------------------------
// Azure Storage Account (BYOS for agent file uploads)
// This is the resource at the center of the exam question - file uploads
// from the AI Agent Service are stored here.
// -------------------------------------------------------------------------
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    allowSharedKeyAccess: false
  }
  tags: union(commonTags, {
    Purpose: 'Agent File Storage (BYOS)'
  })
}

// -------------------------------------------------------------------------
// Azure Cosmos DB for NoSQL (serverless - thread/conversation storage)
// Stores agent definitions, conversation history, and chat threads.
// -------------------------------------------------------------------------
resource cosmosDB 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' = {
  name: cosmosDBName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    disableLocalAuth: true
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    enableFreeTier: false
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
  tags: union(commonTags, {
    Purpose: 'Agent Thread Storage'
  })
}

// -------------------------------------------------------------------------
// Azure AI Search (vector store for retrieval and search)
// Handles embeddings and vector search for agent retrieval.
// -------------------------------------------------------------------------
resource aiSearch 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: aiSearchName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    disableLocalAuth: false
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    hostingMode: 'default'
    partitionCount: 1
    publicNetworkAccess: 'enabled'
    replicaCount: 1
    semanticSearch: 'disabled'
  }
  sku: {
    name: 'basic'
  }
  tags: union(commonTags, {
    Purpose: 'Agent Vector Store'
  })
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Storage account name')
output storageName string = storageAccount.name

@description('Storage account ID')
output storageId string = storageAccount.id

@description('Cosmos DB account name')
output cosmosDBName string = cosmosDB.name

@description('Cosmos DB account ID')
output cosmosDBId string = cosmosDB.id

@description('AI Search service name')
output aiSearchName string = aiSearch.name

@description('AI Search service ID')
output aiSearchId string = aiSearch.id
