// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameter values for boot diagnostics lab deployment
// Context: AZ-104 Lab - Enable Boot Diagnostics for Azure VMs (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-28
// -------------------------------------------------------------------------

using './main.bicep'

param domain = 'compute'
param topic = 'enable-boot-diagnostics'
param location = 'eastus'
param owner = 'Greg Tate'
param dateCreated = '2026-02-28'
param adminUsername = 'azureadmin'
param adminPassword = 'AzureLab2026!'
