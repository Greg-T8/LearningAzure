// -------------------------------------------------------------------------
// Program: role-assignments.bicep
// Description: RBAC assignments for AI Agent Service storage access
// Context: AI-102 Lab - Agent file upload storage configuration
// Author: Greg Tate
// Date: 2026-02-13
// -------------------------------------------------------------------------
//
// KEY EXAM CONCEPT: The project-managed identity requires the Storage Blob
// Data Owner role on the <workspaceId>-agents-blobstore container. Without
// this role, file uploads to the agent service will fail.
//

@description('Storage account name')
param storageName string

@description('AI Search service name')
param aiSearchName string

@description('Cosmos DB account name')
param cosmosDBName string

@description('Project managed identity principal ID')
param projectPrincipalId string

@description('Project workspace ID (GUID for container name conditions)')
param workspaceId string

// -------------------------------------------------------------------------
// Reference existing resources
// -------------------------------------------------------------------------

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageName
}

resource searchService 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: aiSearchName
}

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: cosmosDBName
}

// -------------------------------------------------------------------------
// Built-in role definitions
// -------------------------------------------------------------------------

// Storage Blob Data Contributor (account-level access)
resource storageBlobDataContributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  scope: resourceGroup()
}

// Storage Blob Data Owner (container-level with condition - KEY EXAM CONCEPT)
resource storageBlobDataOwnerRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
  scope: resourceGroup()
}

// Search Index Data Contributor
resource searchIndexDataContributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
  scope: resourceGroup()
}

// Search Service Contributor
resource searchServiceContributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
  scope: resourceGroup()
}

// -------------------------------------------------------------------------
// Storage Blob Data Contributor (account-level)
// Grants the project MI read/write access to blobs in the storage account.
// -------------------------------------------------------------------------
resource storageBlobDataContributorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, projectPrincipalId, storageBlobDataContributorRole.id)
  properties: {
    principalId: projectPrincipalId
    roleDefinitionId: storageBlobDataContributorRole.id
    principalType: 'ServicePrincipal'
  }
}

// -------------------------------------------------------------------------
// Storage Blob Data Owner (with ABAC condition on container names)
// KEY EXAM CONCEPT: This is the critical role assignment that enables
// file uploads. Without this role on the <workspaceId>-agents-blobstore
// container, uploads will fail.
//
// The condition restricts the role to containers whose names start with
// the project workspace ID and end with '-azureml-agent'. This matches
// the auto-provisioned agent containers.
// -------------------------------------------------------------------------

// ABAC condition restricting access to agent-specific containers
var containerCondition = '((!(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/read\'}) AND !(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/filter/action\'}) AND !(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/write\'}) ) OR (@Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringStartsWithIgnoreCase \'${workspaceId}\' AND @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringLikeIgnoreCase \'*-azureml-agent\'))'

resource storageBlobDataOwnerAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, projectPrincipalId, storageBlobDataOwnerRole.id, workspaceId)
  properties: {
    principalId: projectPrincipalId
    roleDefinitionId: storageBlobDataOwnerRole.id
    principalType: 'ServicePrincipal'
    conditionVersion: '2.0'
    condition: containerCondition
  }
}

// -------------------------------------------------------------------------
// AI Search: Search Index Data Contributor
// Allows the project MI to create and manage search indexes for agents.
// -------------------------------------------------------------------------
resource searchIndexDataContributorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: searchService
  name: guid(searchService.id, projectPrincipalId, searchIndexDataContributorRole.id)
  properties: {
    principalId: projectPrincipalId
    roleDefinitionId: searchIndexDataContributorRole.id
    principalType: 'ServicePrincipal'
  }
}

// -------------------------------------------------------------------------
// AI Search: Search Service Contributor
// Allows the project MI to manage the search service configuration.
// -------------------------------------------------------------------------
resource searchServiceContributorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: searchService
  name: guid(searchService.id, projectPrincipalId, searchServiceContributorRole.id)
  properties: {
    principalId: projectPrincipalId
    roleDefinitionId: searchServiceContributorRole.id
    principalType: 'ServicePrincipal'
  }
}

// -------------------------------------------------------------------------
// Cosmos DB: Built-in Data Contributor (data plane)
// Allows the project MI to read/write data in Cosmos DB containers
// where agent conversations and state are stored.
// -------------------------------------------------------------------------
resource cosmosDataContributorAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-11-15' = {
  parent: cosmosDBAccount
  name: guid(cosmosDBAccount.id, projectPrincipalId, 'cosmos-builtin-data-contributor')
  properties: {
    principalId: projectPrincipalId
    roleDefinitionId: '${cosmosDBAccount.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    scope: cosmosDBAccount.id
  }
}

// -------------------------------------------------------------------------
// Cosmos DB Operator (control plane)
// Allows the project MI to read Cosmos DB account metadata, databases,
// and containers via the ARM control plane. Required by the capability
// host to create the enterprise_memory database during agent setup.
// -------------------------------------------------------------------------
resource cosmosDBOperatorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '230815da-be43-4aae-9cb4-875f7bd000aa'
  scope: resourceGroup()
}

resource cosmosDBOperatorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: cosmosDBAccount
  name: guid(cosmosDBAccount.id, projectPrincipalId, cosmosDBOperatorRole.id)
  properties: {
    principalId: projectPrincipalId
    roleDefinitionId: cosmosDBOperatorRole.id
    principalType: 'ServicePrincipal'
  }
}
