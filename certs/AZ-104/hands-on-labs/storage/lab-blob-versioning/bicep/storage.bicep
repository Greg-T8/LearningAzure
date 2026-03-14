// -------------------------------------------------------------------------
// Program: storage.bicep
// Description: Storage account module with blob versioning enabled
// Context: AZ-104 lab - blob versioning and write operations
// Author: Greg Tate
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Base name for the storage account')
@minLength(3)
@maxLength(11)
param baseName string

@description('Environment suffix')
param environment string

@description('Resource tags')
param tags object

@description('Enable blob versioning')
param enableVersioning bool = true

// Generate unique storage account name
var storageAccountName = toLower('${baseName}${environment}${uniqueString(resourceGroup().id)}')
var containerName = 'test-container'

// Deploy storage account
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
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// Enable blob service properties including versioning
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    isVersioningEnabled: enableVersioning
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    changeFeed: {
      enabled: false
    }
  }
}

// Create test container
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: blobService
  name: containerName
  properties: {
    publicAccess: 'None'
  }
}

// Outputs
@description('Storage account name')
output storageAccountName string = storageAccount.name

@description('Storage account ID')
output storageAccountId string = storageAccount.id

@description('Test container name')
output containerName string = container.name

@description('Blob versioning enabled status')
output versioningEnabled bool = blobService.properties.isVersioningEnabled
