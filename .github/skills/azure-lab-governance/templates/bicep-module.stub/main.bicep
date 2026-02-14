// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Root module — orchestrates child modules
// Context: <EXAM> Lab - <scenario>
// Author: Greg Tate
// Date: <YYYY-MM-DD>
// -------------------------------------------------------------------------

targetScope = 'subscription'

// Parameters
@description('Azure region for resource deployment')
param location string = 'eastus'

@description('Resource owner name')
param owner string = 'Greg Tate'

@description('Static date for DateCreated tag (YYYY-MM-DD)')
param dateCreated string

// Common tags applied to all resources
var commonTags = {
  Environment: 'Lab'
  Project: '<EXAM>'
  Domain: '<Domain>'
  Purpose: '<Purpose>'
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

// Resource group name per governance pattern
var resourceGroupName = '<exam>-<domain>-<topic>-bicep'

// Create the resource group
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: commonTags
}

// Example module call (replace with actual modules)
// module networking './modules/networking/main.bicep' = {
//   name: 'networking'
//   scope: rg
//   params: {
//     location: location
//     tags: commonTags
//   }
// }
