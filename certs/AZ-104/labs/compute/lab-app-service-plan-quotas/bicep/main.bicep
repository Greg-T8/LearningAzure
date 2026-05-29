// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Deploy App Service Plan on Free tier to demonstrate CPU quota limits
// Context: AZ-104 Lab - App Service Plan CPU quotas (Free/Shared tiers)
// Author: Greg Tate
// Date: 2026-02-13
// -------------------------------------------------------------------------

targetScope = 'subscription'

// -------------------------------------------------------------------------
// Parameters
// -------------------------------------------------------------------------

@description('AZ-104 exam domain')
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string = 'compute'

@description('Lab topic in kebab-case')
param topic string = 'app-service-plan-quotas'

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner for tagging')
param owner string = 'Greg Tate'

@description('Date created for tagging (static value, YYYY-MM-DD)')
param dateCreated string

// -------------------------------------------------------------------------
// Local variables for naming and tagging
// -------------------------------------------------------------------------

var resourceGroupName = 'az104-${domain}-${topic}-bicep'
var appServicePlanName = 'asp-quota-lab'
var webAppName = 'app-quota-lab-${uniqueString(subscription().id, resourceGroupName)}'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: 'Compute'
  Purpose: 'App Service Plan Quotas'
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
// Deploy App Service resources into resource group
// -------------------------------------------------------------------------

module appService 'app-service.bicep' = {
  name: 'app-service-deployment'
  scope: rg
  params: {
    location: location
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    commonTags: commonTags
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Resource group name')
output resourceGroupName string = rg.name

@description('App Service Plan name')
output appServicePlanName string = appService.outputs.appServicePlanName

@description('Web App name')
output webAppName string = appService.outputs.webAppName

@description('Web App URL')
output webAppUrl string = appService.outputs.webAppUrl

@description('Web App default hostname')
output webAppHostname string = appService.outputs.webAppHostname
