// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameters file for App Service republication lab deployment
// Context: AZ-104 Lab - Prepare App Service for web app republication
// Author: Greg Tate
// Date: 2026-02-12
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and topic (used for stack naming and resource group naming)
param domain = 'compute'
param topic = 'app-service-republication'

// Azure region
param location = 'eastus'

// Lab owner
param owner = 'Greg Tate'

// App Service Plan SKU - Standard S1 required for deployment slots
param planSku = 'S1'

// Deployment slot name for test user review
param slotName = 'staging'
