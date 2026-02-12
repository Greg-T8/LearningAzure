// -------------------------------------------------------------------------
// Program: app-service.bicep
// Description: App Service Plan, Web App, and deployment slot for republication testing
// Context: AZ-104 Lab - Prepare App Service for web app republication
// Author: Greg Tate
// Date: 2026-02-12
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('App Service Plan SKU')
param planSku string

@description('Name of the deployment slot')
param slotName string

@description('Common tags for all resources')
param commonTags object

// -------------------------------------------------------------------------
// Generate unique suffix for globally unique App Service name
// -------------------------------------------------------------------------
var uniqueSuffix = uniqueString(resourceGroup().id)
var appServicePlanName = 'asp-republication'
var webAppName = 'app-republication-${uniqueSuffix}'

// -------------------------------------------------------------------------
// App Service Plan (Standard S1 - required for deployment slots)
// -------------------------------------------------------------------------
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: planSku
    tier: 'Standard'
    capacity: 1
  }
  tags: commonTags
}

// -------------------------------------------------------------------------
// Web App
// -------------------------------------------------------------------------
resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }
  tags: commonTags
}

// -------------------------------------------------------------------------
// Deployment slot for test user review before production swap
// -------------------------------------------------------------------------
resource deploymentSlot 'Microsoft.Web/sites/slots@2023-12-01' = {
  parent: webApp
  name: slotName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }
  tags: union(commonTags, {
    Purpose: 'Staging Slot for Test User Review'
  })
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
@description('App Service Plan name')
output appServicePlanName string = appServicePlan.name

@description('Web App name')
output webAppName string = webApp.name

@description('Web App default hostname')
output webAppHostname string = webApp.properties.defaultHostName

@description('Deployment slot name')
output slotName string = deploymentSlot.name

@description('Deployment slot hostname')
output slotHostname string = deploymentSlot.properties.defaultHostName
