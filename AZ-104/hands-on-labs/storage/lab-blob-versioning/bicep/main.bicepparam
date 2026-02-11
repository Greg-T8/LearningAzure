// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameters file for blob versioning lab deployment
// Context: AZ-104 lab - blob versioning and write operations
// Author: Greg Tate
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and topic (used for stack naming and resource group naming)
param domain = 'storage'
param topic = 'blob-versioning'

// Base name for resources (will be combined with environment and unique string)
param baseName = 'blobver'

// Environment
param environment = 'dev'

// Azure region
param location = 'eastus'

// Lab owner
param owner = 'Greg Tate'

// Enable blob versioning
param enableVersioning = true
