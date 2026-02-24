// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameter values for Document Intelligence invoice lab deployment
// Context: AI-102 Lab - Document Intelligence prebuilt invoice model
// Author: Greg Tate
// Date: 2026-02-24
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and topic (used for stack naming and resource group naming)
param domain = 'ai-services'
param topic = 'doc-intel-invoice'

// Azure region
param location = 'eastus'

// Lab owner
param owner = 'Greg Tate'

// Date created (static per governance)
param dateCreated = '2026-02-24'
