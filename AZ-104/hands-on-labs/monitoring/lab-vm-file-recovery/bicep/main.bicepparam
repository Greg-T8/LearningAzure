// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameters file for VM file recovery lab deployment
// Context: AZ-104 Lab - Recover Configuration File from Azure VM Backup
// Author: Greg Tate
// Date: 2026-02-17
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and topic (used for stack naming and resource group naming)
param domain = 'monitoring'
param topic = 'vm-file-recovery'

// Azure region
param location = 'centralus'

// Lab owner
param owner = 'Greg Tate'

// Date created
param dateCreated = '2026-02-17'

// VM credentials
param adminUsername = 'azureadmin'
param adminPassword = 'AzureLab2026!'
