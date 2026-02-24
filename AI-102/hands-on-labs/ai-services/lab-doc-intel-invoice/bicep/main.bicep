// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Entry point - creates resource group and deploys Document Intelligence
// Context: AI-102 Lab - Document Intelligence prebuilt invoice model
// Author: Greg Tate
// Date: 2026-02-24
// -------------------------------------------------------------------------

targetScope = 'subscription'

// Parameters
@description('AI-102 exam domain')
@allowed([
  'ai-services'
  'agentic'
  'computer-vision'
  'generative-ai'
  'knowledge-mining'
  'nlp'
])
param domain string = 'ai-services'

@description('Lab topic in kebab-case')
param topic string = 'doc-intel-invoice'

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner for tagging')
param owner string = 'Greg Tate'

@description('Static date for DateCreated tag (YYYY-MM-DD)')
param dateCreated string

// -------------------------------------------------------------------------
// Local variables for naming and tagging
// -------------------------------------------------------------------------
var resourceGroupName = 'ai102-${domain}-${topic}-bicep'

var commonTags = {
  Environment: 'Lab'
  Project: 'AI-102'
  Domain: 'AI Services'
  Purpose: 'Document Intelligence Invoice'
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

// -------------------------------------------------------------------------
// Resource Group
// -------------------------------------------------------------------------
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  #disable-next-line BCP416
  name: resourceGroupName
  location: location
  tags: commonTags
}

// -------------------------------------------------------------------------
// Deploy Document Intelligence resource into resource group via module
// -------------------------------------------------------------------------
module documentIntelligence 'document-intelligence.bicep' = {
  scope: rg
  params: {
    location: location
    tags: commonTags
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
@description('Resource group name')
output resourceGroupName string = rg.name

@description('Resource group ID')
output resourceGroupId string = rg.id

@description('Location')
output location string = rg.location

@description('Document Intelligence account name')
output documentIntelligenceName string = documentIntelligence.outputs.accountName

@description('Document Intelligence endpoint')
output documentIntelligenceEndpoint string = documentIntelligence.outputs.endpoint
