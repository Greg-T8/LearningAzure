// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Entry point - creates resource group and deploys App Service with deployment slot
// Context: AZ-104 Lab - Prepare App Service for web app republication
// Author: Greg Tate
// Date: 2026-02-12
// -------------------------------------------------------------------------

targetScope = 'subscription'

@description('AZ-104 exam domain')
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string = 'compute'

@description('Lab topic in kebab-case')
param topic string = 'app-service-republication'

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner for tagging')
param owner string = 'Greg Tate'

@description('Date created for tagging (auto-generated)')
param dateCreated string = utcNow('yyyy-MM-dd')

@description('App Service Plan SKU (Standard S1 required for deployment slots)')
param planSku string = 'S1'

@description('Name of the deployment slot for test user review')
param slotName string = 'staging'

// -------------------------------------------------------------------------
// Local variables for naming and tagging
// -------------------------------------------------------------------------
var resourceGroupName = 'az104-${domain}-${topic}-bicep'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: '${toUpper(substring(domain, 0, 1))}${substring(domain, 1)}'
  Purpose: 'App Service Republication with Deployment Slots'
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
// Deploy App Service resources into resource group via module
// -------------------------------------------------------------------------
module appService 'modules/app-service.bicep' = {
  scope: rg
  params: {
    location: location
    planSku: planSku
    slotName: slotName
    commonTags: commonTags
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

@description('App Service Plan name')
output appServicePlanName string = appService.outputs.appServicePlanName

@description('Web App name')
output webAppName string = appService.outputs.webAppName

@description('Web App default hostname')
output webAppHostname string = appService.outputs.webAppHostname

@description('Deployment slot name')
output slotName string = appService.outputs.slotName

@description('Deployment slot hostname')
output slotHostname string = appService.outputs.slotHostname
