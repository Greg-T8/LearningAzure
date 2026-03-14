// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameters file for App Service Plan CPU quotas lab
// Context: AZ-104 Lab - App Service Plan CPU quotas (Free/Shared tiers)
// Author: Greg Tate
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and topic (used for stack naming and resource group naming)
param domain = 'compute'
param topic = 'app-service-plan-quotas'

// Azure region
param location = 'eastus'

// Lab owner
param owner = 'Greg Tate'

// Date created (static value for tagging)
param dateCreated = '2026-02-13'
