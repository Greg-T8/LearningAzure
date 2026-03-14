// -------------------------------------------------------------------------
// Program: container-apps.bicep
// Description: Deploy Log Analytics, Container Apps environment, and container app with KEDA scaling
// Context: AZ-104 Lab - Configure KEDA Scaling Rule for Azure Container Apps
// Author: Greg Tate
// Date: 2026-03-05
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Common resource tags')
param commonTags object

@description('Container Apps environment name')
param containerAppEnvironmentName string

@description('Container app name')
param containerAppName string

@description('Log Analytics workspace name')
param logAnalyticsWorkspaceName string

@description('Service Bus namespace name used in scale rule metadata')
param serviceBusNamespaceName string

@description('Service Bus queue name used in scale rule metadata')
param queueName string

@description('Service Bus connection string used by the scaler authentication')
@secure()
param serviceBusConnectionString string

// -------------------------------------------------------------------------
// Log Analytics workspace
// -------------------------------------------------------------------------

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: commonTags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// -------------------------------------------------------------------------
// Container Apps environment
// -------------------------------------------------------------------------

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: containerAppEnvironmentName
  location: location
  tags: commonTags
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

// -------------------------------------------------------------------------
// Container app with custom KEDA scale rule
// -------------------------------------------------------------------------

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: containerAppName
  location: location
  tags: commonTags
  properties: {
    managedEnvironmentId: containerAppsEnvironment.id
    configuration: {
      ingress: {
        external: false
        targetPort: 80
      }
      secrets: [
        {
          name: 'service-bus-connection'
          value: serviceBusConnectionString
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'keda-worker'
          image: 'mcr.microsoft.com/k8se/quickstart:latest'
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 32
        rules: [
          {
            name: 'azure-servicebus-queue-rule'
            custom: {
              type: 'azure-servicebus'
              metadata: {
                queueName: queueName
                namespace: serviceBusNamespaceName
                messageCount: '15'
              }
              auth: [
                {
                  secretRef: 'service-bus-connection'
                  triggerParameter: 'connection'
                }
              ]
            }
          }
        ]
      }
    }
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Container Apps environment name')
output containerAppEnvironmentName string = containerAppsEnvironment.name

@description('Container app name')
output containerAppName string = containerApp.name

@description('Log Analytics workspace name')
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
