# -------------------------------------------------------------------------
# Data: Skills.psd1
# Description: Domain, skill, and task hierarchy for the AZ-104 exam
# Context: AZ-104 — Microsoft Azure Administrator
# Author: Greg Tate
# -------------------------------------------------------------------------

@{
    Domains = @(
        @{
            Name   = 'Manage Azure Identities and Governance'
            Skills = @(
                @{
                    Name  = 'Manage Microsoft Entra users and groups'
                    Tasks = @(
                        'Create users and groups'
                        'Manage user and group properties'
                        'Manage licenses in Microsoft Entra ID'
                        'Manage external users'
                        'Configure self-service password reset (SSPR)'
                    )
                }
                @{
                    Name  = 'Manage access to Azure resources'
                    Tasks = @(
                        'Manage built-in Azure roles'
                        'Assign roles at different scopes'
                        'Interpret access assignments'
                    )
                }
                @{
                    Name  = 'Manage Azure subscriptions and governance'
                    Tasks = @(
                        'Implement and manage Azure Policy'
                        'Configure resource locks'
                        'Apply and manage tags on resources'
                        'Manage resource groups'
                        'Manage subscriptions'
                        'Manage costs by using alerts, budgets, and Azure Advisor recommendations'
                        'Configure management groups'
                    )
                }
            )
        }
        @{
            Name   = 'Implement and Manage Storage'
            Skills = @(
                @{
                    Name  = 'Configure access to storage'
                    Tasks = @(
                        'Configure Azure Storage firewalls and virtual networks'
                        'Create and use shared access signature (SAS) tokens'
                        'Configure stored access policies'
                        'Manage access keys'
                        'Configure identity-based access for Azure Files'
                    )
                }
                @{
                    Name  = 'Configure and manage storage accounts'
                    Tasks = @(
                        'Create and configure storage accounts'
                        'Configure Azure Storage redundancy'
                        'Configure object replication'
                        'Configure storage account encryption'
                        'Manage data by using Azure Storage Explorer and AzCopy'
                    )
                }
                @{
                    Name  = 'Configure Azure Files and Azure Blob Storage'
                    Tasks = @(
                        'Create and configure a file share in Azure Storage'
                        'Create and configure a container in Blob Storage'
                        'Configure storage tiers'
                        'Configure soft delete for blobs and containers'
                        'Configure snapshots and soft delete for Azure Files'
                        'Configure blob lifecycle management'
                        'Configure blob versioning'
                    )
                }
            )
        }
        @{
            Name   = 'Deploy and Manage Azure Compute Resources'
            Skills = @(
                @{
                    Name  = 'Automate deployment of resources by using ARM templates or Bicep files'
                    Tasks = @(
                        'Interpret an Azure Resource Manager template or a Bicep file'
                        'Modify an existing Azure Resource Manager template'
                        'Modify an existing Bicep file'
                        'Deploy resources by using an ARM template or a Bicep file'
                        'Export a deployment as an ARM template or convert an ARM template to a Bicep file'
                    )
                }
                @{
                    Name  = 'Create and configure virtual machines'
                    Tasks = @(
                        'Create a virtual machine'
                        'Configure Azure Disk Encryption'
                        'Move a VM to another resource group, subscription, or region'
                        'Manage virtual machine sizes'
                        'Manage virtual machine disks'
                        'Deploy VMs to availability zones and availability sets'
                        'Deploy and configure an Azure Virtual Machine Scale Sets'
                    )
                }
                @{
                    Name  = 'Provision and manage containers in the Azure portal'
                    Tasks = @(
                        'Create and manage an Azure container registry'
                        'Provision a container by using Azure Container Instances'
                        'Provision a container by using Azure Container Apps'
                        'Manage sizing and scaling for containers, including Azure Container Instances and Azure Container Apps'
                    )
                }
                @{
                    Name  = 'Create and configure Azure App Service'
                    Tasks = @(
                        'Provision an App Service plan'
                        'Configure scaling for an App Service plan'
                        'Create an App Service'
                        'Configure certificates and TLS for an App Service'
                        'Map an existing custom DNS name to an App Service'
                        'Configure backup for an App Service'
                        'Configure networking settings for an App Service'
                        'Configure deployment slots for an App Service'
                    )
                }
            )
        }
        @{
            Name   = 'Implement and Manage Virtual Networking'
            Skills = @(
                @{
                    Name  = 'Configure and manage virtual networks in Azure'
                    Tasks = @(
                        'Create and configure virtual networks and subnets'
                        'Create and configure virtual network peering'
                        'Configure public IP addresses'
                        'Configure user-defined network routes'
                        'Troubleshoot network connectivity'
                    )
                }
                @{
                    Name  = 'Configure secure access to virtual networks'
                    Tasks = @(
                        'Create and configure NSGs and application security groups'
                        'Evaluate effective security rules in NSGs'
                        'Implement Azure Bastion'
                        'Configure service endpoints for Azure PaaS'
                        'Configure private endpoints for Azure PaaS'
                    )
                }
                @{
                    Name  = 'Configure name resolution and load balancing'
                    Tasks = @(
                        'Configure Azure DNS'
                        'Configure an internal or public load balancer'
                        'Troubleshoot load balancing'
                    )
                }
            )
        }
        @{
            Name   = 'Monitor and Maintain Azure Resources'
            Skills = @(
                @{
                    Name  = 'Monitor resources in Azure'
                    Tasks = @(
                        'Interpret metrics in Azure Monitor'
                        'Configure log settings in Azure Monitor'
                        'Query and analyze logs in Azure Monitor'
                        'Set up alert rules, action groups, and alert processing rules in Azure Monitor'
                        'Configure and interpret monitoring of VMs, storage accounts, and networks by using Azure Monitor Insights'
                        'Use Azure Network Watcher and Connection Monitor'
                    )
                }
                @{
                    Name  = 'Implement backup and recovery'
                    Tasks = @(
                        'Create a Recovery Services vault'
                        'Create an Azure Backup vault'
                        'Create and configure a backup policy'
                        'Perform backup and restore operations by using Azure Backup'
                        'Configure Azure Site Recovery for Azure resources'
                        'Perform a failover to a secondary region by using Site Recovery'
                        'Configure and interpret reports and alerts for backups'
                    )
                }
            )
        }
    )
}
