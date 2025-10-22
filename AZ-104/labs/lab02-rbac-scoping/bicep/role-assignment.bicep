targetScope = 'resourceGroup'

@description('Principal ID of the user, group, or service principal')
param principalId string

@description('Built-in role ID')
param roleDefinitionId string = 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor

@description('Principal Type')
@allowed([
  'User'
  'Group'
  'ServicePrincipal'
])
param principalType string = 'User'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, roleDefinitionId) // Creates a deterministic unique name
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: principalType
  }
}

output roleAssignmentId string = roleAssignment.id
