// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameter values for KEDA scaling rule lab deployment
// Context: AZ-104 Lab - Configure KEDA Scaling Rule for Azure Container Apps
// Author: Greg Tate
// -------------------------------------------------------------------------

using './main.bicep'

// Domain and topic values used by stack naming and resource group naming.
param domain = 'compute'
param topic = 'keda-scaling-rule'

// Default Azure region.
param location = 'eastus'

// Tag values.
param owner = 'Greg Tate'
param dateCreated = '2026-03-05'
