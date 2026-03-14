// -------------------------------------------------------------------------
// Program: storage-account.bicep
// Description: Module to create a storage account with blob container and file share
// Context: AZ-104 Lab - Storage account module for AzCopy authorization testing
// Author: Greg Tate
// Date: 2026-02-07
// -------------------------------------------------------------------------

// Parameters
@description('Name of the storage account')
param storageAccountName string

@description('Azure region for the storage account')
param location string

@description('Tags to apply to resources')
param tags object

@description('Whether to create a blob container')
param createBlobContainer bool = false

@description('Blob container name')
param blobContainerName string = ''

@description('Whether to create a file share')
param createFileShare bool = false

@description('File share name')
param fileShareName string = ''

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

// Blob Container
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = if (createBlobContainer) {
  name: '${storageAccount.name}/default/${blobContainerName}'
  properties: {
    publicAccess: 'Blob'
  }
}

// File Share
resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-05-01' = if (createFileShare) {
  name: '${storageAccount.name}/default/${fileShareName}'
  properties: {
    shareQuota: 5120
  }
}

// Outputs
@description('Storage account name')
output storageAccountName string = storageAccount.name

@description('Storage account resource ID')
output storageAccountId string = storageAccount.id

@description('Storage account primary key')
@secure()
output storageAccountKey string = storageAccount.listKeys().keys[0].value

@description('Blob endpoint')
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob

@description('File endpoint')
output fileEndpoint string = storageAccount.properties.primaryEndpoints.file
