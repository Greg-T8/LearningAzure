// -------------------------------------------------------------------------
// Program: role-assignment.bicep
// Description: Module to create a role assignment on a resource
// Context: AZ-104 Lab - Role assignment module for storage authorization
// Author: Greg Tate
// Date: 2026-02-07
// -------------------------------------------------------------------------

// Parameters
@description('Principal ID (user, group, or service principal object ID)')
param principalId string

@description('Role definition ID (built-in or custom role GUID)')
param roleDefinitionId string

@description('Name of the resource to assign the role on')
param resourceName string

@description('Type of the resource (e.g., Microsoft.Storage/storageAccounts)')
param resourceType string

// Variables
var roleAssignmentName = guid(principalId, roleDefinitionId, resourceName)

// Role Assignment
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: resourceGroup()
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalType: 'User'
  }
}

// Outputs
@description('Role assignment ID')
output roleAssignmentId string = roleAssignment.id

@description('Role assignment name')
output roleAssignmentName string = roleAssignment.name
