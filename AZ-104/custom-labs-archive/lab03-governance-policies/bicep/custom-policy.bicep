targetScope = 'subscription'

@description('Name of the custom policy definition')
param policyName string = 'storage-naming-convention'

@description('Display name for the policy')
param displayName string = 'Enforce Storage Account Naming Convention'

@description('Description of the policy')
param description string = 'Storage account names must follow pattern: st<env><app><region><seq>'

// Create custom policy definition for storage account naming
resource storagePolicyDefinition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: policyName
  properties: {
    displayName: displayName
    description: description
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'Storage'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts'
          }
          {
            not: {
              field: 'name'
              match: 'st[dev|test|prod]*[eus|wus|cus]*[0-9][0-9]'
            }
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

// Assign the custom policy
resource storagePolicyAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: 'enforce-storage-naming'
  properties: {
    displayName: 'Enforce Storage Naming Convention'
    description: 'Enforces storage account naming standards'
    policyDefinitionId: storagePolicyDefinition.id
  }
}

output policyDefinitionId string = storagePolicyDefinition.id
output policyAssignmentId string = storagePolicyAssignment.id
