// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Deploy storage accounts to demonstrate AzCopy authorization methods
// Context: AZ-104 Lab - Storage account authorization methods for AzCopy
// Author: Greg Tate
// Date: 2026-02-07
// -------------------------------------------------------------------------

targetScope = 'subscription'

// Parameters
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
@description('AZ-104 exam domain')
param domain string

@description('Lab topic in kebab-case')
param topic string

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner')
param owner string = 'Greg Tate'

@description('Resource creation date')
param dateCreated string = utcNow('yyyy-MM-dd')

@description('Microsoft Entra ID Object ID for role assignments (current user)')
param userObjectId string

// Variables
var resourceGroupName = 'az104-${domain}-${topic}-bicep'

// Common tags for all resources
var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: '${toUpper(substring(domain, 0, 1))}${substring(domain, 1)}'
  Purpose: replace(topic, '-', ' ')
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

// Storage account names (globally unique, no hyphens, max 24 chars)
var sourceStorageName = 'staz104azcopyauthsrc'
var targetStorageName = 'staz104azcopyauthtgt'

// Container and share names
var blobContainerName = 'data'
var fileShareName = 'files'

// Built-in Azure role definition IDs
var storageBlobDataContributorRoleId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
var storageFileDataSmbShareContributorRoleId = '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb'

// Resource Group
resource labResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: commonTags
}

// Source Storage Account
module sourceStorage 'modules/storage-account.bicep' = {
  scope: labResourceGroup
  name: 'source-storage-deployment'
  params: {
    storageAccountName: sourceStorageName
    location: location
    tags: union(commonTags, { Purpose: 'Source storage account for AzCopy testing' })
    createBlobContainer: true
    blobContainerName: blobContainerName
    createFileShare: true
    fileShareName: fileShareName
  }
}

// Target Storage Account (DevStore equivalent)
module targetStorage 'modules/storage-account.bicep' = {
  scope: labResourceGroup
  name: 'target-storage-deployment'
  params: {
    storageAccountName: targetStorageName
    location: location
    tags: union(commonTags, { Purpose: 'Target storage account (DevStore) for AzCopy testing' })
    createBlobContainer: true
    blobContainerName: blobContainerName
    createFileShare: true
    fileShareName: fileShareName
  }
}

// Role Assignment: Storage Blob Data Contributor (applies to all storage accounts in RG)
module blobRoleAssignment 'modules/role-assignment.bicep' = {
  scope: labResourceGroup
  name: 'blob-role-assignment'
  params: {
    principalId: userObjectId
    roleDefinitionId: storageBlobDataContributorRoleId
    resourceName: resourceGroupName
  }
  dependsOn: [
    sourceStorage
    targetStorage
  ]
}

// Role Assignment: Storage File Data SMB Share Contributor (applies to all storage accounts in RG)
module fileRoleAssignment 'modules/role-assignment.bicep' = {
  scope: labResourceGroup
  name: 'file-role-assignment'
  params: {
    principalId: userObjectId
    roleDefinitionId: storageFileDataSmbShareContributorRoleId
    resourceName: resourceGroupName
  }
  dependsOn: [
    sourceStorage
    targetStorage
  ]
}

// Outputs
@description('Resource group name')
output resourceGroupName string = labResourceGroup.name

@description('Source storage account name')
output sourceStorageAccountName string = sourceStorage.outputs.storageAccountName

@description('Target storage account name (DevStore)')
output targetStorageAccountName string = targetStorage.outputs.storageAccountName

@description('Blob container name')
output blobContainerName string = blobContainerName

@description('File share name')
output fileShareName string = fileShareName

@description('Source storage account primary key')
@secure()
output sourceStorageKey string = sourceStorage.outputs.storageAccountKey

@description('Target storage account primary key')
@secure()
output targetStorageKey string = targetStorage.outputs.storageAccountKey

@description('Next steps')
output nextSteps string = 'Use the validation scripts to test AzCopy with different authorization methods'
