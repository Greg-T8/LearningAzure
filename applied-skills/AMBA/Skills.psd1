# -------------------------------------------------------------------------
# Data: Skills.psd1
# Description: Domain, skill, and task hierarchy for the AMBA applied skill
# Context: AMBA - Azure Monitor Baseline Alerts
# Author: Greg Tate
# -------------------------------------------------------------------------

@{
    Domains = @(
        @{
            Name   = 'Landing Zone Foundation with Terraform and AVM'
            Skills = @(
                @{
                    Name  = 'Understand the ALZ Terraform Accelerator'
                    Tasks = @(
                        'Identify the accelerator phases: planning, prerequisites, bootstrap, and run. Explain when to use GitHub, Azure DevOps, or local filesystem output.'
                    )
                }
                @{
                    Name  = 'Understand the platform_landing_zone template'
                    Tasks = @(
                        'Map the template files, generated variables, examples, and AVM modules. Identify what deploys management groups, policy, role definitions, management resources, connectivity, DDoS, and private DNS.'
                    )
                }
                @{
                    Name  = 'Deploy or dry-run the platform landing zone'
                    Tasks = @(
                        'Configure subscriptions, starter locations, and either hub-and-spoke or Virtual WAN. Prefer terraform plan first; only apply if cost and permissions are acceptable.'
                    )
                }
                @{
                    Name  = 'Verify the baseline landing zone'
                    Tasks = @(
                        'Validate management group hierarchy, policy assignments, Log Analytics workspace, automation account, and connectivity resources.'
                    )
                }
            )
        }
        @{
            Name   = 'AMBA Concepts and Alert Catalog'
            Skills = @(
                @{
                    Name  = 'Explain AMBA'
                    Tasks = @(
                        'Summarize the Azure Resources, Patterns/Scenarios, and Visualizations sections of the AMBA docs.'
                    )
                }
                @{
                    Name  = 'Classify alerts'
                    Tasks = @(
                        'Distinguish activity log alerts, metric alerts, log-search alerts, static thresholds, dynamic thresholds, default enabled alerts, and default disabled alerts.'
                    )
                }
                @{
                    Name  = 'Understand AMBA-ALZ policy initiatives'
                    Tasks = @(
                        'Map initiatives such as Resource and Service Health, Connectivity, Identity, Management, VM, Key Management, Load Balancing, Network Changes, Recovery Services, Storage, Web, and Notification Assets.'
                    )
                }
                @{
                    Name  = 'Understand remediation'
                    Tasks = @(
                        'Explain why greenfield resources can be handled automatically while existing resources often need policy remediation.'
                    )
                }
            )
        }
        @{
            Name   = 'AMBA Deployment Methods'
            Skills = @(
                @{
                    Name  = 'Deploy via Azure portal'
                    Tasks = @(
                        'Use the AMBA-ALZ portal accelerator. Practice both management group and subscription deployment paths if you have a safe test scope.'
                    )
                }
                @{
                    Name  = 'Deploy via Terraform'
                    Tasks = @(
                        'Use the AMBA Terraform module and/or the ALZ Terraform Accelerator AMBA option. Configure library references, AMBA archetypes, AMBA resource group, managed identity, and policy default values.'
                    )
                }
                @{
                    Name  = 'Configure notifications'
                    Tasks = @(
                        'Practice AMBA-created notification assets and Bring Your Own Notifications (BYON). Compare email, ARM role, webhook, Logic App, Event Hub, and Function options.'
                    )
                }
                @{
                    Name  = 'Validate deployment'
                    Tasks = @(
                        'Check policy assignments, policy states, remediation tasks, metric alerts, activity log alerts, action groups, and alert processing rules.'
                    )
                }
            )
        }
        @{
            Name   = 'Alert Selection, Tuning, and Operations'
            Skills = @(
                @{
                    Name  = 'Select alert categories'
                    Tasks = @(
                        'Use portal or parameter toggles such as enableAMBAStorage, enableAMBAVM, and enableAMBAServiceHealth to deploy broad initiatives.'
                    )
                }
                @{
                    Name  = 'Select individual alerts'
                    Tasks = @(
                        'Use Terraform/custom policy assignments when the requirement is only these 10 alerts. Avoid treating the portal accelerator as the precise-alert selection mechanism.'
                    )
                }
                @{
                    Name  = 'Disable or suppress alerts'
                    Tasks = @(
                        'Compare AlertState, PolicyEffect, MonitorDisable, management group/subscription exclusions, and alert processing rules.'
                    )
                }
                @{
                    Name  = 'Tune thresholds'
                    Tasks = @(
                        'Adjust assignment parameters for global thresholds and use threshold override tags for resource-specific metric/log-search thresholds.'
                    )
                }
                @{
                    Name  = 'Operate AMBA over time'
                    Tasks = @(
                        'Practice version lookup, update planning, cleanup, and brownfield remediation.'
                    )
                }
            )
        }
    )
}
