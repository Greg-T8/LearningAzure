// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Deploy Container Apps and Service Bus resources for KEDA scaling rule validation
// Context: AZ-104 Lab - Configure KEDA Scaling Rule for Azure Container Apps
// Author: Greg Tate
// Date: 2026-03-05
// -------------------------------------------------------------------------

targetScope = 'subscription'

// -------------------------------------------------------------------------
// Parameters
// -------------------------------------------------------------------------

@description('AZ-104 exam domain')
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string = 'compute'

@description('Lab topic in kebab-case')
param topic string = 'keda-scaling-rule'

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner for tagging')
param owner string = 'Greg Tate'

@description('Date created for tagging (static value, YYYY-MM-DD)')
param dateCreated string

@description('Service Bus connection string used by the KEDA scaler')
@secure()
param serviceBusConnectionString string

// -------------------------------------------------------------------------
// Local variables for naming and tagging
// -------------------------------------------------------------------------

var resourceGroupName = 'az104-${domain}-${topic}-bicep'
var containerAppEnvironmentName = 'cae-lab'
var containerAppName = 'ca-order-processor'
var logAnalyticsWorkspaceName = 'law-monitoring'
var serviceBusNamespaceName = 'sbns-orders'
var serviceBusQueueName = 'my-sample-queue'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: 'Compute'
  Purpose: 'KEDA Scaling Rule'
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

// -------------------------------------------------------------------------
// Resource group
// -------------------------------------------------------------------------

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: commonTags
}

// -------------------------------------------------------------------------
// Module: Messaging resources
// -------------------------------------------------------------------------

module messaging 'modules/messaging.bicep' = {
  name: 'messaging-deployment'
  scope: rg
  params: {
    location: location
    commonTags: commonTags
    serviceBusNamespaceName: serviceBusNamespaceName
    queueName: serviceBusQueueName
  }
}

// -------------------------------------------------------------------------
// Module: Container Apps resources
// -------------------------------------------------------------------------

module containerApps 'modules/container-apps.bicep' = {
  name: 'container-apps-deployment'
  scope: rg
  params: {
    location: location
    commonTags: commonTags
    containerAppEnvironmentName: containerAppEnvironmentName
    containerAppName: containerAppName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    serviceBusNamespaceName: messaging.outputs.serviceBusNamespaceName
    queueName: messaging.outputs.queueName
    serviceBusConnectionString: serviceBusConnectionString
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Resource group name')
output resourceGroupName string = rg.name

@description('Container Apps environment name')
output containerAppEnvironmentName string = containerApps.outputs.containerAppEnvironmentName

@description('Container app name')
output containerAppName string = containerApps.outputs.containerAppName

@description('Service Bus namespace name')
output serviceBusNamespaceName string = messaging.outputs.serviceBusNamespaceName

@description('Service Bus queue name')
output queueName string = messaging.outputs.queueName

@description('Log Analytics workspace name')
output logAnalyticsWorkspaceName string = containerApps.outputs.logAnalyticsWorkspaceName
