// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Entry point - creates resource group and deploys resources
// Context: AZ-104 hands-on lab - App Service Plans (Microsoft Azure Administrator)
// Author: Greg Tate
// -------------------------------------------------------------------------

targetScope = 'subscription'

@description('AZ-104 exam domain')
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string = 'compute'

@description('Lab topic in kebab-case')
param topic string = 'app-service-tiers'

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner for tagging')
param owner string = 'Greg Tate'

@description('Name of the App Service Plan')
param appServicePlanName string = 'MyPlan'

@description('Name of the Web App')
param appName string = 'MyApp'

@description('SKU for App Service Plan: F1 (Free), D1 (Shared), B1 (Basic)')
@allowed(['F1', 'D1', 'B1', 'B2', 'B3', 'S1', 'S2', 'S3'])
param skuName string = 'F1'

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
// Deploy resources into resource group via module
// -------------------------------------------------------------------------
module resources 'resources.bicep' = {
  scope: rg
  name: 'deploy-resources'
  params: {
    domain: domain
    location: location
    owner: owner
    appServicePlanName: appServicePlanName
    appName: appName
    skuName: skuName
    dateCreated: dateCreated
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
output resourceGroupName string = rg.name
output resourceGroupId string = rg.id
output location string = rg.location
output appServicePlanName string = resources.outputs.appServicePlanName
output appServicePlanSku string = resources.outputs.appServicePlanSku
output appName string = resources.outputs.appName
output appUrl string = resources.outputs.appUrl
output tierInfo object = resources.outputs.tierInfo
output portalUrl string = resources.outputs.portalUrl
