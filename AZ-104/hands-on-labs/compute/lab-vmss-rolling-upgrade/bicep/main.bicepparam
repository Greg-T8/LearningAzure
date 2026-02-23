// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameters file for VMSS Rolling Upgrade lab
// Context: AZ-104 Lab - VMSS Rolling Upgrade (Microsoft Azure Administrator)
// Author: Greg Tate
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and topic (used for stack naming and resource group naming)
param domain = 'compute'
param topic = 'vmss-rolling-upgrade'

// Azure region
param location = 'centralus'

// Lab owner
param owner = 'Greg Tate'

// Date created (static value for tagging)
param dateCreated = '2026-02-23'

// Admin username for VMSS instances
param adminUsername = 'azureadmin'

// Admin password for VMSS instances (lab-safe static value)
param adminPassword = 'AzureLab2026!'
