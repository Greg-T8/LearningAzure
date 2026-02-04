# -------------------------------------------------------------------------
# Program: main.bicep
# Description: Deploy App Service with configurable pricing tier
# Context: AZ-104 hands-on lab - App Service Plans (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------

@description('Azure subscription ID for lab deployments (prevents wrong-subscription mistakes)')
param labSubscriptionId string

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

// -------------------------------------------------------------------------
// Local variables for naming and tagging
// -------------------------------------------------------------------------
var resourceGroupName = 'az104-${domain}-${topic}-bicep'
var uniqueAppName = '${toLower(appName)}-${uniqueString(resourceGroup().id)}'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: toUpper(substring(domain, 0, 1)) + substring(domain, 1)
  Purpose: 'App Service Pricing Tiers'
  Owner: owner
  DeploymentMethod: 'Bicep'
}

var tierMapping = {
  F1: 'Free'
  D1: 'Shared'
  B1: 'Basic'
  B2: 'Basic'
  B3: 'Basic'
  S1: 'Standard'
  S2: 'Standard'
  S3: 'Standard'
}

var alwaysOnAllowed = (skuName != 'F1' && skuName != 'D1')

// -------------------------------------------------------------------------
// App Service Plan with configurable SKU
// -------------------------------------------------------------------------
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  tags: commonTags
  sku: {
    name: skuName
    tier: tierMapping[skuName]
  }
  kind: 'windows'
  properties: {}
}

// -------------------------------------------------------------------------
// Web App
// -------------------------------------------------------------------------
resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: uniqueAppName
  location: location
  tags: commonTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: false
    siteConfig: {
      alwaysOn: alwaysOnAllowed
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '0'
        }
      ]
    }
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
output resourceGroupName string = resourceGroupName
output appServicePlanName string = appServicePlan.name
output appServicePlanSku string = skuName
output appName string = webApp.name
output appUrl string = 'https://${webApp.properties.defaultHostName}'
output tierInfo object = {
  sku: skuName
  dailyLimit: (skuName == 'F1') ? '60 CPU minutes' : (skuName == 'D1') ? '240 CPU minutes' : 'Unlimited'
  computeType: (skuName == 'F1' || skuName == 'D1') ? 'Shared' : 'Dedicated'
}
output portalUrl string = 'https://portal.azure.com/#@/resource${appServicePlan.id}/scaleUp'
