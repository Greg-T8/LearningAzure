// -------------------------------------------------------------------------
// Program: capability-host.bicep
// Description: Configure capability hosts for AI Agent Service standard setup
// Context: AI-102 Lab - Agent file upload storage configuration
// Author: Greg Tate
// Date: 2026-02-13
// -------------------------------------------------------------------------
//
// KEY EXAM CONCEPT: The project capability host's storageConnections property
// must reference the correct storage connection name. If this connection
// points to the wrong storage account or has an incorrect connection string,
// user file uploads to the agent service will fail.
//

@description('AI Services account name')
param aiAccountName string

@description('AI Foundry project name')
param projectName string

@description('Storage connection name for file uploads')
param storageConnectionName string

@description('Cosmos DB connection name for thread storage')
param cosmosDBConnectionName string

@description('AI Search connection name for vector store')
param aiSearchConnectionName string

// -------------------------------------------------------------------------
// Reference existing AI account and project
// -------------------------------------------------------------------------

resource aiAccount 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: aiAccountName
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' existing = {
  name: projectName
  parent: aiAccount
}

// -------------------------------------------------------------------------
// Account-level capability host
// Enables Agent Service at the account level. Must be created before
// the project capability host.
// -------------------------------------------------------------------------
resource accountCapabilityHost 'Microsoft.CognitiveServices/accounts/capabilityHosts@2025-04-01-preview' = {
  name: 'caphost-account'
  parent: aiAccount
  properties: {
    capabilityHostKind: 'Agents'
  }
}

// -------------------------------------------------------------------------
// Project-level capability host
// KEY EXAM CONCEPT: storageConnections must reference the correct storage
// connection. An incorrect connection string here causes file upload failures.
//
// Required connections:
//   - storageConnections: Azure Storage for file uploads (EXAM FOCUS)
//   - threadStorageConnections: Cosmos DB for conversation history
//   - vectorStoreConnections: AI Search for embeddings/retrieval
// -------------------------------------------------------------------------
resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-04-01-preview' = {
  name: 'caphost-project'
  parent: project
  properties: {
    storageConnections: [storageConnectionName]
    threadStorageConnections: [cosmosDBConnectionName]
    vectorStoreConnections: [aiSearchConnectionName]
  }
  dependsOn: [
    accountCapabilityHost
  ]
}
