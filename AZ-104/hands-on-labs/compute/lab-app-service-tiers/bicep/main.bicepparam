// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameter values for App Service Pricing Tiers lab
// Context: AZ-104 hands-on lab - App Service Plans (Microsoft Azure Administrator)
// Author: Greg Tate
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and lab configuration
param domain = 'compute'
param topic = 'app-service-tiers'
param location = 'eastus'
param owner = 'Greg Tate'

// App Service configuration
param appServicePlanName = 'MyPlan'
param appName = 'MyApp'

// SKU to deploy (change this to test different tiers)
param skuName = 'F1'  // Options: F1 (Free), D1 (Shared), B1 (Basic)
