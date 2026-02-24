// -------------------------------------------------------------------------
// Program: document-intelligence.bicep
// Description: Azure AI Document Intelligence (Form Recognizer) resource
// Context: AI-102 Lab - Document Intelligence prebuilt invoice model
// Author: Greg Tate
// Date: 2026-02-24
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Resource tags')
param tags object

// -------------------------------------------------------------------------
// Generate unique name (Cognitive Services requires unique names due to soft-delete)
// -------------------------------------------------------------------------
var accountName = 'di-invoice-${uniqueString(resourceGroup().id)}'

// -------------------------------------------------------------------------
// Deploy Azure AI Document Intelligence (Form Recognizer)
// -------------------------------------------------------------------------
resource docIntelligence 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: accountName
  location: location
  tags: tags
  kind: 'FormRecognizer'
  sku: {
    name: 'F0'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    customSubDomainName: accountName
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
@description('Document Intelligence account name')
output accountName string = docIntelligence.name

@description('Document Intelligence endpoint')
output endpoint string = docIntelligence.properties.endpoint

@description('Document Intelligence resource ID')
output resourceId string = docIntelligence.id
