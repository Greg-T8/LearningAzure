// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameter file for AzCopy authorization methods lab
// Context: AZ-104 Lab - Storage account authorization methods for AzCopy
// Author: Greg Tate
// Date: 2026-02-07
// -------------------------------------------------------------------------

using './main.bicep'

// Required parameters
param domain = 'storage'
param topic = 'azcopy-auth-methods'

// Optional parameters
param location = 'eastus'
param owner = 'Greg Tate'

// IMPORTANT: Replace with your Microsoft Entra ID user object ID
// To get your object ID, run: az ad signed-in-user show --query id -o tsv
param userObjectId = 'b73b073d-262b-43c4-aaee-492e68f4cc51'
