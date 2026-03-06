// -------------------------------------------------------------------------
// Program: messaging.bicep
// Description: Deploy Service Bus namespace and queue for KEDA trigger source
// Context: AZ-104 Lab - Configure KEDA Scaling Rule for Azure Container Apps
// Author: Greg Tate
// Date: 2026-03-05
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Common resource tags')
param commonTags object

@description('Service Bus namespace name')
param serviceBusNamespaceName string

@description('Service Bus queue name')
param queueName string

// -------------------------------------------------------------------------
// Service Bus namespace
// -------------------------------------------------------------------------

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  tags: commonTags
  properties: {
    publicNetworkAccess: 'Enabled'
    minimumTlsVersion: '1.2'
  }
}

// -------------------------------------------------------------------------
// Service Bus queue
// -------------------------------------------------------------------------

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  name: queueName
  parent: serviceBusNamespace
  properties: {
    maxSizeInMegabytes: 1024
    defaultMessageTimeToLive: 'P14D'
    deadLetteringOnMessageExpiration: true
    enableBatchedOperations: true
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Service Bus namespace name')
output serviceBusNamespaceName string = serviceBusNamespace.name

@description('Service Bus queue name')
output queueName string = queueName

@description('Service Bus connection string for KEDA scaler authentication')
output serviceBusConnectionString string = listKeys(
  '${serviceBusNamespace.id}/AuthorizationRules/RootManageSharedAccessKey',
  serviceBusNamespace.apiVersion
).primaryConnectionString
