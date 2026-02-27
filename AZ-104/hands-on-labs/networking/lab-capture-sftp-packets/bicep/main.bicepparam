// -------------------------------------------------------------------------
// Program: main.bicepparam
// Description: Parameter values for packet capture lab deployment
// Context: AZ-104 Lab - Capture SFTP Packets with Network Watcher
// Author: Greg Tate
// Date: 2026-02-27
// -------------------------------------------------------------------------

using './main.bicep'

param domain = 'networking'
param topic = 'capture-sftp-packets'
param location = 'eastus'
param owner = 'Greg Tate'
param dateCreated = '2026-02-27'
param adminUsername = 'azureadmin'
param adminPassword = 'AzureLab2026!'
