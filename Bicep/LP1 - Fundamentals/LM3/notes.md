[Build flexible Bicep files by using conditions and loops](https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-files-conditions-loops/)

<!-- omit in toc -->
# Learning Module 3: Build flexible Bicep files by using conditions and loops
- [Introduction](#introduction)
  - [Example scenario](#example-scenario)
  - [What we will learn?](#what-we-will-learn)
  - [What is the main goal?](#what-is-the-main-goal)
- [Deploy resources conditionally](#deploy-resources-conditionally)
  - [Use basic conditions](#use-basic-conditions)
  - [Use expressions as conditions](#use-expressions-as-conditions)
  - [Depend on condtionally deployed resources](#depend-on-condtionally-deployed-resources)


## Introduction

When working with Bicep files, you can use conditions and loops to make deployments more flexible. Conditions let you deploy resources only when certain requirements are met. Loops allow you to deploy multiple resources that share similar settings.

### Example scenario

You’re responsible for deploying and configuring Azure infrastructure for a toy company. The company is launching a new smart teddy bear, which relies on back-end server components and SQL databases hosted in Azure.

For production environments, you must ensure auditing is enabled on all Azure SQL logical servers to meet security requirements.

Because the toy will launch in multiple countries/regions, each location needs its own database server and virtual network. Resources must be deployed in specific regions to comply with local laws. You’ve been tasked with deploying these logical servers and virtual networks and making the process scalable, so new ones can be added easily as the product expands to more countries/regions.

<img src='images/2025-08-24-05-34-55.png' width=500> 

### What we will learn?

In this module, you'll extend a Bicep file by using conditions and loops. You'll:

- Use conditions to deploy Azure resources only when they're required.
- Use loops to deploy multiple instances of Azure resources.
- Learn how to control loop parallelism.
- Learn how to create nested loops.
- Combine loops with variables and outputs.

### What is the main goal?

By the end of this module, you'll be able to create Bicep files by using conditions and loops, and write Bicep code that configures how loops are executed. You'll also be able to create variable loops and output loops to make your files even more flexible.

## Deploy resources conditionally

You can use conditions in Bicep to deploy resources only when certain requirements are met.

For example, your toy company needs to deploy resources to multiple environments. In production, auditing must be enabled for Azure SQL logical servers. In development, auditing should remain disabled. Instead of using separate files, you can handle both cases with a single Bicep file.

This unit shows you how to deploy resources conditionally.

### Use basic conditions

In Bicep, you can use the `if` keyword with a condition when deploying a resource. The condition must evaluate to either true or false. If true, the resource is deployed; if false, it isn’t.

Conditions are often based on parameter values. For example, this code deploys a storage account only if the `deployStorageAccount` parameter is set to true:

```bicep
param deployStorageAccount bool

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = if (deployStorageAccount) {
  name: 'teddybearstorage'
  location: resourceGroup().location
  kind: 'StorageV2'
  // ...
}
```

The `if` keyword must be placed on the same line as the resource definition.

### Use expressions as conditions

The earlier example used a Boolean parameter, making the condition straightforward. But in Bicep, conditions can also use expressions.

For example, this code deploys a SQL auditing resource only when the `environmentName` parameter is set to `Production`:

```bicep
@allowed([
  'Development'
  'Production'
])
param environmentName string

resource auditingSettings 'Microsoft.Sql/servers/auditingSettings@2024-05-01-preview' = if (environmentName == 'Production') {
  parent: server
  name: 'default'
  properties: {
  }
}
```

To make your Bicep file easier to read, it’s often better to assign the expression to a variable and use that in the condition:

```bicep
@allowed([
  'Development'
  'Production'
])
param environmentName string

var auditingEnabled = environmentName == 'Production'           // Using an expression to set a variable

resource auditingSettings 'Microsoft.Sql/servers/auditingSettings@2024-05-01-preview' = if (auditingEnabled) {
  parent: server
  name: 'default'
  properties: {
  }
}
```

### Depend on condtionally deployed resources

When deploying conditionally, be mindful of how Bicep/ARM evaluate dependencies.

Here’s a SQL auditing setup that also declares a storage account, both gated by the same condition:

```bicep
@allowed([
  'Development'
  'Production'
])
param environmentName string
param location string = resourceGroup().location
param auditStorageAccountName string = 'bearaudit${uniqueString(resourceGroup().id)}'

var auditingEnabled = environmentName == 'Production'
var storageAccountSkuName = 'Standard_LRS'

resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = if (auditingEnabled) {
  name: auditStorageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
}

resource auditingSettings 'Microsoft.Sql/servers/auditingSettings@2024-05-01-preview' = if (auditingEnabled) {
  parent: server
  name: 'default'
  properties: {
  }
}
```

You can then reference the storage account safely using conditional expressions:

```bicep
resource auditingSettings 'Microsoft.Sql/servers/auditingSettings@2024-05-01-preview' = if (auditingEnabled) {
  parent: server
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: environmentName == 'Production' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey: environmentName == 'Production' ? listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0].value : ''
  }
}
```

ARM evaluates property expressions before it evaluates resource `if` conditions. Without the ternaries, references to `auditStorageAccount` would be resolved even in non‑production, causing `ResourceNotFound`.

You can’t define two resources with the same name in one Bicep file and conditionally pick one; that’s a conflict. If many resources share the same condition, put them in a module and apply the condition to the module in the main file.
