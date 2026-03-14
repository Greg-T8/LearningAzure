// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Entry point - creates resource group and deploys storage resources
// Context: AZ-104 lab - blob versioning and write operations
// Author: Greg Tate
// -------------------------------------------------------------------------

targetScope = 'subscription'

@description('AZ-104 exam domain')
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string = 'storage'

@description('Lab topic in kebab-case')
param topic string = 'blob-versioning'

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner for tagging')
param owner string = 'Greg Tate'

@description('Base name for storage resources')
@minLength(3)
@maxLength(11)
param baseName string = 'blobver'

@description('Environment suffix')
@allowed([
  'dev'
  'test'
  'prod'
])
param environment string = 'dev'

@description('Enable blob versioning')
param enableVersioning bool = true

@description('Date created for tagging (auto-generated)')
param dateCreated string = utcNow('yyyy-MM-dd')

// -------------------------------------------------------------------------
// Local variables for naming and tagging
// -------------------------------------------------------------------------
var resourceGroupName = 'az104-${domain}-${topic}-bicep'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: '${toUpper(substring(domain, 0, 1))}${substring(domain, 1)}'
  Purpose: replace(topic, '-', ' ')
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
// Deploy storage resources into resource group via module
// -------------------------------------------------------------------------
module storage 'storage.bicep' = {
  scope: rg
  params: {
    location: location
    baseName: baseName
    environment: environment
    tags: commonTags
    enableVersioning: enableVersioning
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
@description('Resource group name')
output resourceGroupName string = rg.name

@description('Resource group ID')
output resourceGroupId string = rg.id

@description('Location')
output location string = rg.location

@description('Storage account name')
output storageAccountName string = storage.outputs.storageAccountName

@description('Storage account ID')
output storageAccountId string = storage.outputs.storageAccountId

@description('Test container name')
output containerName string = storage.outputs.containerName

@description('Blob versioning status')
output versioningEnabled bool = storage.outputs.versioningEnabled
