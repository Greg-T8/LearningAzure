targetScope = 'subscription'

@description('Array of allowed locations for resources')
param allowedLocations array = [
  'eastus'
  'westus'
]

@description('Name of the policy assignment')
param policyAssignmentName string = 'allowed-locations-policy'

@description('Built-in policy definition ID for Allowed Locations')
param policyDefinitionId string = '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'

// Assign Allowed Locations policy
resource allowedLocationsAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: policyAssignmentName
  properties: {
    displayName: 'Allowed Locations - East US and West US Only'
    description: 'Restricts resource deployment to East US and West US regions'
    policyDefinitionId: policyDefinitionId
    parameters: {
      listOfAllowedLocations: {
        value: allowedLocations
      }
    }
  }
}

// Assign Require Tag on Resource Groups policy
resource requireTagAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: 'require-costcenter-tag-rg'
  properties: {
    displayName: 'Require CostCenter Tag on Resource Groups'
    description: 'Requires all resource groups to have a CostCenter tag'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025'
    parameters: {
      tagName: {
        value: 'CostCenter'
      }
    }
  }
}

output allowedLocationsAssignmentId string = allowedLocationsAssignment.id
output requireTagAssignmentId string = requireTagAssignment.id
