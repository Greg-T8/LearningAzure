[Microsoft Learn - Build reusable Bicep files by using parameters](https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-files-parameters/)

<!-- omit in toc -->
# Learning Module 2: Build reusable Bicep files by using parameters
- [Understand parameters](#understand-parameters)
  - [Declare a parameter](#declare-a-parameter)
  - [Add a default value](#add-a-default-value)
  - [Understand parameter types](#understand-parameter-types)
    - [Objects](#objects)
    - [Arrays](#arrays)
  - [Specify a list of allowed values](#specify-a-list-of-allowed-values)
  - [Restrict parameter length and values](#restrict-parameter-length-and-values)
  - [Add descriptions to parameters](#add-descriptions-to-parameters)
- [Exercise - Add parameters and decorators](#exercise---add-parameters-and-decorators)
  - [Add parameter descriptions](#add-parameter-descriptions)
  - [Limit input values](#limit-input-values)
  - [Limit input lengths](#limit-input-lengths)
  - [Limit numeric values](#limit-numeric-values)
  - [Run the deployment](#run-the-deployment)
- [Provide values using parameter files](#provide-values-using-parameter-files)
  - [Create parameter files](#create-parameter-files)
  - [Use parameter files at deployment time](#use-parameter-files-at-deployment-time)
  - [Override parameter values](#override-parameter-values)
- [Secure your parameters](#secure-your-parameters)
  - [Define secure parameters](#define-secure-parameters)
  - [Avoid using parameter files for secrets](#avoid-using-parameter-files-for-secrets)
  - [Integrate with Azure Key Vault](#integrate-with-azure-key-vault)
  - [Use Key Vault with modules](#use-key-vault-with-modules)
- [Exercise - Add a parameter file and secure parameters](#exercise---add-a-parameter-file-and-secure-parameters)
  - [Remove the default value for the App Service plan SKU](#remove-the-default-value-for-the-app-service-plan-sku)
  - [Add new parameters](#add-new-parameters)
  - [Add new variables](#add-new-variables)
  - [Add SQL Server and database resources](#add-sql-server-and-database-resources)
  - [Create a parameters file](#create-a-parameters-file)
  - [Deploy the Bicep template with the parameters file](#deploy-the-bicep-template-with-the-parameters-file)
  - [Create a Key Vault and add secrets](#create-a-key-vault-and-add-secrets)


## Understand parameters

You can use parameters to pass information into a Bicep template when you deploy it. This makes your template more flexible and reusable, since it can work with different values each time it's used.

Decorators let you add rules and extra details to parameters—like limits or helpful descriptions—so that anyone using the template knows exactly what kind of input is expected.

### Declare a parameter

Use the `param` keyword to declare a parameter:

```bicep
param environmentName string
```

Parts:
- `param` is the keyword to declare a parameter.
- `environmentName` is the name of the parameter. Parameter names must be unique; they can't have the same name as a variable or resource in the same Bicep file.
- `string` is the type of the parameter. Other types include `int`, `bool`, `array`, and `object`.

### Add a default value

You can provide a default value for a parameter, which is used if no value is provided during deployment:

```bicep
param environmentName string = 'dev'
```

You can also use expressions to set a default value:

```bicep
param location string = resourceGroup().location
```

### Understand parameter types

Bicep supports several parameter types, including:
- `string`: A sequence of characters, like text.
- `int`: An integer number, like 42.
- `bool`: A boolean value, which can be either `true` or `false`.
- `object` and `array`: Represent structured data and lists.

#### Objects

An `object` is a collection of key-value pairs, similar to a dictionary or JSON object. You can define an object parameter like this:

```bicep
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
  capacity: 1
}
```

When you reference this parameter in a template, you can access its properties using dot notation:

```bicep
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name                // Reference the name property of the appServicePlanSku object
    tier: appServicePlanSku.tier
    capacity: appServicePlanSku.capacity
  }
}
```

You  also use parameters to specify resource tags:

```bicep
param resourceTags object = {
  EnvironmentName: 'Test'
  CostCenter: '1000100'
  Team: 'Human Resources'
}
```

Then you can reuse it whereever you defin the `tags` property:

```bicep
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags            // Use the resourceTags parameter
  sku: {
    name: 'S1'
  }
}

resource appServiceApp 'Microsoft.Web/sites@' = {
  name: appServiceAppName
  location: location
  tags: resourceTags
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
  }
}
```

#### Arrays

An array is a list of items. In Bicep, you can't specify the type of individual items in an array. 

You can create an array parameter like this:

```bicep
param cosmosDBAccountLocations array = [
  {
    locationName: 'australiaeast'
  }
  {
    locationName: 'southcentralus'
  }
  {
    locationName: 'westeurope'
  }
]
```

You can then use this array parameter to define resources in your Bicep file:

```bicep
resource account 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' = {
  name: accountName
  location: location
  properties: {
    locations: cosmosDBAccountLocations             // Use the cosmosDBAccountLocations array parameter
  }
}
```

### Specify a list of allowed values

You can use the `@allowed` decorator to specify a list of allowed values for a parameter. This helps ensure that only valid values are used when deploying the Bicep file.

```bicep
@allowed([
  'P1v3'
  'P2v3'
  'P3v3'
])
param appServicePlanSkuName string
```

### Restrict parameter length and values

You can use the `@minLength` and `@maxLength` decorators to restrict the length of a string parameter:

```bicep
@minLength(5)
@maxLength(24)
param storageAccountName string
```

You can also use the `@minValue` and `@maxValue` decorators to restrict the range of an integer parameter:

```bicep
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int
```

### Add descriptions to parameters

You can add descriptions to parameters to provide more context for users:

```bicep
@description('The locations into which this Cosmos DB account should be configured. This parameter needs to be a list of objects, each of which has a locationName property.')
param cosmosDBAccountLocations array
```

## Exercise - Add parameters and decorators

Create a new Bicep file called `main.bicep` with the following content:

[main.bicep](LP1%20-%20Fundamentals/LM2/main.bicep)
```bicep
param environmentName string = 'dev'
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'      // Use uniqueString to create globally unique resource names
param appServicePlanInstanceCount int = 1
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
}
param location string = 'eastus'

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'
```

Then introduce the following code to the file:

[main.bicep](LP1%20-%20Fundamentals/LM2/main.bicep)
```bicep
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location                                    // Note use of the location parameter
  sku: {
    name: appServicePlanSku.name                        // Reference the appServicePlanSku object parameter
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
```

### Add parameter descriptions

Add descriptions to the parameters to provide more context for users:

[main.bicep](LP1%20-%20Fundamentals/LM2/main.bicep)
```bicep
@description('The name of the environment. This must be dev, test, or prod.')
param environmentName string = 'dev'

@description('The unique name of the solution. This is used to ensure that resource names are unique.')
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The number of App Service plan instances.')
param appServicePlanInstanceCount int = 1

@description('The name and tier of the App Service plan SKU.')
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
}

@description('The Azure region into which the resources should be deployed.')
param location string = 'eastus'
```

### Limit input values

You can use the `@allowed` decorator to limit the values that can be used for a parameter:

[main.bicep](LP1%20-%20Fundamentals/LM2/main.bicep)
```bicep
@description('The name of the environment. This must be dev, test, or prod.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'
```

### Limit input lengths

You can use the `@minLength` and `@maxLength` decorators to limit the length of a string parameter:

[main.bicep](LP1%20-%20Fundamentals/LM2/main.bicep)
```bicep
@description('The unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'
```

### Limit numeric values

You can use the `@minValue` and `@maxValue` decorators to limit the range of an integer parameter:

[main.bicep](LP1%20-%20Fundamentals/LM2/main.bicep)
```bicep
@description('The number of App Service plan instances.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1
```

### Run the deployment

```pwsh
New-AzResourceGroup -Name BicepDeployment -Location eastu
Set-AzDefault -ResourceGroupName BicepDeployment

New-AzResourceGroupDeployment -Name main -TemplateFile main.bicep

DeploymentName          : main
ResourceGroupName       : BicepDeployment
ProvisioningState       : Succeeded
Timestamp               : 8/1/2025 9:36:45 AM
Mode                    : Incremental
TemplateLink            : 
Parameters              : 
                          Name                           Type                       Value
                          =============================  =========================  ==========
                          environmentName                String                     "dev"
                          solutionName                   String                     "toyhrfce5rpzidzts4"
                          appServicePlanInstanceCount    Int                        1
                          appServicePlanSku              Object                     {"name":"F1","tier":"Free"}
                          location                       String                     "eastus"

Outputs                 : 
DeploymentDebugLogLevel : 
```

## Provide values using parameter files

### Create parameter files

Parameter files let you group and define values for your Bicep template's parameters. 

These files can use the `.bicepparam` extension or be in JSON format. 

Example JSON parameter file:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServicePlanInstanceCount": {
      "value": 3
    },
    "appServicePlanSku": {
      "value": {
        "name": "P1v3",
        "tier": "PremiumV3"
      }
    },
    "cosmosDBAccountLocations": {
      "value": [
        {
          "locationName": "australiaeast"
        },
        {
          "locationName": "southcentralus"
        },
        {
          "locationName": "westeurope"
        }
      ]
    }
  }
}
```
Here's a breakdown of the key parts of a parameters file:

* `$schema` tells Azure Resource Manager that the file is a parameters file.
* `contentVersion` helps track changes to the file. It's optional and usually set to "1.0.0.0".
* `parameters` lists each parameter and its value. Each parameter is defined as an object with a **value** property that holds the actual value to use.

It's common to create a separate parameters file for each environment. A good practice is to include the environment name in the file name. For example:

* `main.parameters.dev.json` for development
* `main.parameters.production.json` for production

### Use parameter files at deployment time

When using the `New-AzResourceGroupDeployment` cmdlet to start a new deployment, you can specify the parameters file with the `-TemplateParameterFile` argument.

```pwsh
New-AzResourceGroupDeployment -Name main -TemplateFile main.bicep -TemplateParameterFile main.parameters.json
```

### Override parameter values

There are three ways to set parameter values: default values, command-line input, and parameters files. It's common to use more than one method for the same parameter. 

If you define a default value but provide a different one through the command line, the command-line value overrides the default. 

Parameters files also follow this order of precedence:

<img src="../../images/1754041692186.png" width="450">

The following Bicep file defines three parameters with default values:

```bicep
param location string = resourceGroup().location
param appServicePlanInstanceCount int = 1
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
}
```

The following parameters file overrides the value of two of the parameters but doesn't specify a value for the `location` parameter:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServicePlanInstanceCount": {                // Override the default value of appServicePlanInstanceCount
      "value": 3
    },
    "appServicePlanSku": {                          // Override the default value of appServicePlanSku
      "value": {
        "name": "P1v3",
        "tier": "PremiumV3"
      }
    }
  }
}
```

When you create the deployment, you override one of the parameter values:

```pwsh
New-AzResourceGroupDeployment `
  -Name main ` 
  -TemplateFile main.bicep `
  -TemplateParameterFile main.parameters.json `
  -appServicePlanInstanceCount 5                    # Override the appServicePlanInstanceCount parameter
```

## Secure your parameters

Sometimes deployments require sensitive values, like passwords or API keys. These need to be protected. 

In some cases, the person running the deployment shouldn't see the secrets. In others, they may enter the values, but those values must not be logged. 

### Define secure parameters

The `@secure` decorator is used for string and object parameters that may contain secrets. When a parameter is marked as `@secure`, its value won't appear in deployment logs. If you're entering the value interactively through Azure CLI or PowerShell, it also won't be shown on the screen.

```bicep
@secure()
param sqlServerAdministratorLogin string

@secure()
param sqlServerAdministratorPassword string
```
Neither parameter has a default value, which is intentional. It's best not to set defaults for usernames, passwords, or other secrets. 

### Avoid using parameter files for secrets

As covered earlier, parameter files are useful for setting values for different environments. However, you should avoid using them to store secrets. These files are often checked into version control systems like Git, which may be accessible to many people. Version control isn't meant for storing sensitive information, so keeping secrets out of these files is important for security.

### Integrate with Azure Key Vault

Azure Key Vault is built to store and manage secrets securely. You can connect your Bicep templates to Key Vault by referencing secrets in a parameters file.

Instead of storing the actual value, you reference the Key Vault and the secret name. This keeps the secret hidden. During deployment, Azure Resource Manager retrieves the secret directly from Key Vault.

<img src="../../images/1754042755156.png" width=450>

Here's an example of a parameters file that uses Key Vault references to retrieve the SQL logical server admin login and password:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlServerAdministratorLogin": {
      "reference": {                        // Uses reference object instead of value
        "keyVault": {
          "id": "/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/PlatformResources/providers/Microsoft.KeyVault/vaults/toysecrets"
        },
        "secretName": "sqlAdminLogin"
      }
    },
    "sqlServerAdministratorPassword": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/PlatformResources/providers/Microsoft.KeyVault/vaults/toysecrets"
        },
        "secretName": "sqlAdminLoginPassword"
      }
    }
  }
}
```

### Use Key Vault with modules

Modules let you reuse Bicep files to deploy specific parts of your solution. They can take parameters, including secrets. To pass secret values securely, you can use Key Vault integration.

```bicep
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {       // Use of existing keyword to tell Bicep this Key Vault already exists and not to redeploy it
  name: keyVaultName
}

module applicationModule 'application.bicep' = {
  name: 'application-module'
  params: {
    apiKey: keyVault.getSecret('ApiKey')                                    // Use the getSecret() function to retrieve the secret value from Key Vault
  }
}
```

## Exercise - Add a parameter file and secure parameters

In this exercise, you’ll create a parameters file to supply values for the Bicep template you built earlier. In the same file, you’ll also add Azure Key Vault references to securely handle sensitive data.

**Steps:**

* Define secure parameters
* Create the parameters file
* Test the deployment to confirm the file is valid
* Create a key vault and add secrets
* Update the parameters file to reference those secrets
* Test the deployment again to ensure validity

### Remove the default value for the App Service plan SKU

To make the template environment-agnostic, move the App Service plan SKU details into a parameters file instead of setting a default.

In **main.bicep**, remove the default value from the `appServicePlanSku` parameter:

```bicep
// Before
@description('The name and tier of the App Service plan SKU.')
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
}

// After
@description('The name and tier of the App Service plan SKU.')
param appServicePlanSku object
```

### Add new parameters

Add parameters for the SQL server and database under the existing ones in **main.bicep**. Do not assign default values to secure parameters or to the database SKU.

```bicep
@description('The name of the environment. This must be dev, test, or prod.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('The unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The number of App Service plan instances.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('The name and tier of the App Service plan SKU.')
param appServicePlanSku object

@description('The Azure region into which the resources should be deployed.')
param location string = 'eastus'

// New parameters for SQL server and database

// The @secure() decorator tells Azure that this parameter should be treated as a secret, meaning it won't be logged or displayed in plain text.
@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object
```

This way, sensitive information like the login and password will be provided securely through a parameters file or Key Vault reference.

### Add new variables

Add the SQL-related variables beneath the existing ones in **main.bicep**:

```bicep
var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName  = '${environmentName}-${solutionName}-app'
// New variables for SQL server and database
var sqlServerName      = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName    = 'Employees'
```

This defines consistent names for the SQL server and database alongside your other resources.


### Add SQL Server and database resources

At the bottom of **main.bicep**, add the SQL server and database resources:

```bicep
resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
}
```
Save the file after adding these resources.

### Create a parameters file

In the same folder as **main.bicep**, create **main.parameters.dev.json** and add:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServicePlanSku": {
      "value": {
        "name": "F1",
        "tier": "Free"
      }
    },
    "sqlDatabaseSku": {
      "value": {
        "name": "Standard",
        "tier": "Standard"
      }
    }
  }
}
```

Save the file after adding this code.

### Deploy the Bicep template with the parameters file

Run the deployment with the parameters file using Azure PowerShell:

```powershell
New-AzResourceGroupDeployment `
  -Name main `
  -TemplateFile main.bicep `
  -TemplateParameterFile main.parameters.dev.json
```

You’ll be prompted for `sqlServerAdministratorLogin` and `sqlServerAdministratorPassword`.

Rules:

* The login must start with a letter, contain only letters and numbers, and cannot be obvious names like `admin` or `root`.
* The password must be at least 8 characters long and include lowercase, uppercase, numbers, and symbols.

If the values don’t meet these rules, the SQL server deployment will fail.

Keep a note of the login and password you use — they’ll be needed later. The deployment may take a few minutes.


```pwsh
> New-AzResourceGroupDeployment -Name main -TemplateFile .\main.bicep -TemplateParameterFile .\main.parameters.dev.json

cmdlet New-AzResourceGroupDeployment at command pipeline position 1
Supply values for the following parameters:
(Type !? for Help.)
sqlServerAdministratorLogin: ********
sqlServerAdministratorPassword: ***********

DeploymentName          : main
ResourceGroupName       : BicepDeployment
ProvisioningState       : Succeeded
Timestamp               : 8/21/2025 9:44:38 AM
Mode                    : Incremental
TemplateLink            : 
Parameters              : 
                          Name                              Type                       Value
                          ================================  =========================  ==========
                          environmentName                   String                     "dev"
                          solutionName                      String                     "toyhrfce5rpzidzts4"
                          appServicePlanInstanceCount       Int                        1
                          appServicePlanSku                 Object                     {"name":"F1","tier":"Free"}
                          location                          String                     "centralus"
                          sqlServerAdministratorLogin       SecureString               null
                          sqlServerAdministratorPassword    SecureString               null
                          sqlDatabaseSku                    Object                     {"name":"Standard","tier":"Standard"}

Outputs                 : 
DeploymentDebugLogLevel : 
```

### Create a Key Vault and add secrets

Define variables for the key vault, login, and password, then create the key vault and add secrets. Run each step in the terminal:

```powershell
$keyVaultName = 'YOUR-KEY-VAULT-NAME'
$login        = Read-Host "Enter the login name" -AsSecureString
$password     = Read-Host "Enter the password" -AsSecureString
```

Then create the key vault and store the secrets:

```powershell
# The -EnabledForTemplateDeployment flag allows Azure Resource Manager to access the secrets during deployments.
New-AzKeyVault -VaultName $keyVaultName -Location centralus -EnabledForTemplateDeployment
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $login
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $password
```

**Notes:**

* Use the same login and password you entered during the earlier deployment step. Otherwise, the next deployment will fail.
* Key vault names must be globally unique, 3–24 characters long, and can include letters, numbers, and hyphens.
* The `-EnabledForTemplateDeployment` flag ensures deployments can access secrets.
* As the creator of the vault, you already have access permissions. In real scenarios, permissions must be granted explicitly.

```pwsh
> $keyVaultName = 'labkeyvault20250821'

> $login        = Read-Host "Enter the login name" -AsSecureString
Enter the login name: ********

> $password     = Read-Host "Enter the password" -AsSecureString
Enter the password: ***********

> New-AzKeyVault -VaultName $keyVaultName -Location centralus -EnabledForTemplateDeployment

Vault Name                          : labkeyvault20250821
Resource Group Name                 : BicepDeployment                                                                                                                                          
Location                            : centralus                                                                                                                                                
Resource ID                         : /subscriptions/e091f6e7-031a-4924-97bb-8c983ca5d21a/resourceGroups/BicepDeployment/providers/Microsoft.KeyVault/vaults/labkeyvault20250821               
Vault URI                           : https://labkeyvault20250821.vault.azure.net/                                                                                                             
Tenant ID                           : 547b168b-bd3f-4cfc-ae2b-665f52672fae                                                                                                                     
SKU                                 : Standard                                                                                                                                                 
Enabled For Deployment?             : False                                                                                                                                                    
Enabled For Template Deployment?    : True                                                                                                                                                     
Enabled For Disk Encryption?        : 
Enabled For RBAC Authorization?     : True
Soft Delete Enabled?                : True
Soft Delete Retention Period (days) : 90
Purge Protection Enabled?           : 
Public Network Access               : Enabled
Access Policies                     : 
                                      Tenant ID                                  : 547b168b-bd3f-4cfc-ae2b-665f52672fae
                                      Object ID                                  : 1441d598-b3c1-461e-8bdb-12ec864891e5
                                      Application ID                             :
                                      Display Name                               : Tenant Admin (tenantadmin@637djb.onmicrosoft.com)
                                      Permissions to Keys                        : all
                                      Permissions to Secrets                     : all
                                      Permissions to Certificates                : all
                                      Permissions to (Key Vault Managed) Storage : all


Network Rule Set                    : 
                                      Default Action                             : Allow
                                      Bypass                                     : AzureServices
                                      IP Rules                                   :
                                      Virtual Network Rules                      :

Tags                                : 


# Note: I had to add my account to the Key Vault Administrator RBAC role to be able to add secrets.
> Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $login

Vault Name   : labkeyvault20250821
Name         : sqlServerAdministratorLogin
Version      : 8ab6375963db420188d8e24567c3adac
Id           : https://labkeyvault20250821.vault.azure.net:443/secrets/sqlServerAdministratorLogin/8ab6375963db420188d8e24567c3adac
Enabled      : True
Expires      : 
Not Before   : 
Created      : 8/21/2025 10:04:26 AM
Updated      : 8/21/2025 10:04:26 AM
Content Type : 
Tags         : 

> Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $password

Vault Name   : labkeyvault20250821
Name         : sqlServerAdministratorPassword                                                                                                                                                  
Version      : 448aaa5da81246f8ac4e354f1f8df585                                                                                                                                                
Id           : https://labkeyvault20250821.vault.azure.net:443/secrets/sqlServerAdministratorPassword/448aaa5da81246f8ac4e354f1f8df585                                                         
Enabled      : True                                                                                                                                                                            
Expires      :                                                                                                                                                                                 
Not Before   :                                                                                                                                                                                 
Created      : 8/21/2025 10:05:15 AM                                                                                                                                                           
Updated      : 8/21/2025 10:05:15 AM                                                                                                                                                           
Content Type : 
Tags         : 
```

#### Get the key vault's resource ID