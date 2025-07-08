# Exploring Azure

The following notes are based on the Azure documentation and personal exploration of Azure services.

## Azure Bicep

- [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Bicep GitHub Page](https://github.com/Azure/bicep) - Interesting read

### Bicep Command Reference

```pwsh
New-AzResourceGroupDeployment -ResourceGroupName BicepDeployment -TemplateFile .\main.bicep
```
### Install the Bicep CLI

Use the following command to install the self-contained version of the Bicep CLI from `az`:

```powershell
az bicep install
Installing Bicep CLI v0.36.1...
The configuration value of bicep.use_binary_from_path has been set to 'false'.
Successfully installed Bicep CLI to "C:\Users\gregt\.azure\bin\bicep.exe".
```

Check version:

```powershell
az bicep version
Bicep CLI version 0.36.1 (a727ed087a)
```

Note the self-contained instance isn't available with PowerShell commnands, so Azure deployments will fail if you haven't manually installed the Bicep CLI.

To manually install the Bicep CLI:

```powershell
winget install bicep
Found Bicep CLI [Microsoft.Bicep] Version 0.36.1
This application is licensed to you by its owner.
Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Downloading https://github.com/Azure/bicep/releases/download/v0.36.1/bicep-setup-win-x64.exe
  ██████████████████████████████  38.5 MB / 38.5 MB
Successfully verified installer hash
Starting package install...
Successfully installed
```

Check version:

```powershell
bicep --version
Bicep CLI version 0.36.1 (a727ed087a)
```

### Bicep Quickstart
- [Create Bicep files - VS Code](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code?tabs=azure-cli)
- [Bicep Playground](https://azure.github.io/bicep/) - lets you view Bicep and JSON side by side

### Learning Module - Build your first Bicep file

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-file/

#### Defining a Resource

When you submit a Bicep file, it is transpiled to an ARM template. The Bicep file is then validated and deployed to Azure.

<img src="images/1751967045419.png" alt="Bicep Deployment Flow" width="400">

Example of a Bicep file:

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'toylaunchstorage'
  location: 'westus3'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
```
Things to note:
- The `resource` keyword is used to define a resource.
- The *symbolic name* is `storageAccount`. Symbolic names are used within Bicep but do not show up in the ARM template.
- `'Microsoft.Storage/storageAccounts@2023-05-01'` is the *resource type* and *API version*.
- You have to declare a *resource name*, which is the name of the storage account to be assigned in Azure.

#### Resource Dependencies

Often, you need a resource to depend on another resource, e.g. to deploy an App Service, you need and App Service Plan.

Declaring the app service plan:

```bicep
resource appServicePlan 'Microsoft.Web/serverFarms@2023-12-01' = {
  name: 'toy-product-launch-plan'
  location: 'westus3'
  sku: {
    name: 'F1'
  }
}
```
Declaring the app:  
```bicep
resource appServiceApp 'Microsoft.Web/sites@2023-12-01' = {
  name: 'toy-product-launch-1'
  location: 'westus3'
  properties: {
    serverFarmId: appServicePlan.id             // Reference the app service plan; implicit dependency
    httpsOnly: true
  }
}
```

#### Exercise: Define resources in a Bicep file

Create the following `main.bicep` file:

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: '20250708toylaunchstorage'
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
```

Deploy the Bicep file to Azure:

```pwsh
Set-AzDefault -ResourceGroupName 'BicepDeployment'

New-AzResourceGroupDeployment -Name main -TemplateFile main.bicep

DeploymentName          : main
ResourceGroupName       : BicepDeployment
ProvisioningState       : Succeeded
Timestamp               : 7/8/2025 9:49:16 AM
Mode                    : Incremental
TemplateLink            : 
Parameters              : 
Outputs                 : 
DeploymentDebugLogLevel : 


Get-AzResourceGroupDeployment -ResourceGroupName BicepDeployment

DeploymentName          : main
ResourceGroupName       : BicepDeployment
ProvisioningState       : Succeeded
Timestamp               : 7/8/2025 9:49:16 AM
Mode                    : Incremental
TemplateLink            : 
Parameters              : 
Outputs                 : 
DeploymentDebugLogLevel : 
```
<img src="images/1751968314823.png" alt="Bicep Deployment Output" width="800">


**Add an App Service Plan**

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: '20250708toylaunchstorage'
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: '20250708toy-product-launch-plan-starter'
  location: 'eastus'
  sku: {
    name: 'F1'
  }
}

resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: '20250708toy-product-launch-1'
  location: 'eastus'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
```
Deployment results:

<img src="images/1751968819100.png" alt="Bicep Deployment Output" width="600">

#### Using Parameters and Variables

Parameters allow you to bring in values from outside the Bicep file. When deploying, you can provide the parameter values in the command line.

You can also create a *parameter file*, which lists all teh parameters and values you want to use for the deployment.

A variable is defined and set within the Bicep file.

Use parameters for things that will change between each deployment:
- Resource names that need to be unique
- Locations into which resources are deployed
- Settings that affect the pricing of resources, like SKUs, pricing tiers, and instance counts
- Credentials and information needed to access other systems that aren't defined in the Bicep file

Use variables when (1) you want to make a value resusable in the file or (2) you want to use expressions to create a complex value.

##### Add a parameter

Parameters are defined like this:

```bicep
param appServiceAppName string
```

How this works:
- `param` is the keyword to define a parameter.
- `appServiceAppName` is the symbolic name of the parameter.
- `string` is the type of the parameter. Other types include `int`, `bool`, `array`, and `object`.

###### Provide default values

You can provide a default value for a parameter, which is used if no value is provided during deployment:

```bicep
param appServiceAppName string = '20250708toy-product-launch-1'
```


