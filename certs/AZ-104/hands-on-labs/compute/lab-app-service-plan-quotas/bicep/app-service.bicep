// -------------------------------------------------------------------------
// Program: app-service.bicep
// Description: App Service Plan and Web App for CPU quota demonstration
// Context: AZ-104 Lab - App Service Plan CPU quotas (Free/Shared tiers)
// Author: Greg Tate
// Date: 2026-02-13
// -------------------------------------------------------------------------

// -------------------------------------------------------------------------
// Parameters
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('App Service Plan name')
param appServicePlanName string

@description('Web App name (must be globally unique)')
param webAppName string

@description('Common tags to apply to all resources')
param commonTags object

// -------------------------------------------------------------------------
// App Service Plan - Free F1 tier (60 CPU minutes/day quota)
// -------------------------------------------------------------------------

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  tags: commonTags
}

// -------------------------------------------------------------------------
// Web App - simple .NET app on Free tier plan
// -------------------------------------------------------------------------

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      netFrameworkVersion: 'v8.0'
    }
  }
  tags: commonTags
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('App Service Plan name')
output appServicePlanName string = appServicePlan.name

@description('Web App name')
output webAppName string = webApp.name

@description('Web App URL')
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'

@description('Web App default hostname')
output webAppHostname string = webApp.properties.defaultHostName
