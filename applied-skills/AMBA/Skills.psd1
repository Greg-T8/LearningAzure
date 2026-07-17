# -------------------------------------------------------------------------
# Data: Skills.psd1
# Description: Domain, skill, and task hierarchy for the AMBA applied skill
# Context: AMBA - Azure Monitor Baseline Alerts
# Author: Greg Tate
# -------------------------------------------------------------------------

@{
    Domains = @(
        @{
            Name   = 'AMBA Concepts and Alert Catalog'
            Skills = @(
                @{
                    Name  = 'Explain AMBA'
                    Tasks = @(
                        'Summarize AMBA resources, patterns, and visualizations.'
                    )
                }
                @{
                    Name  = 'Classify alerts'
                    Tasks = @(
                        'Classify alert types, thresholds, and default states.'
                    )
                }
                @{
                    Name  = 'Understand AMBA-ALZ policy initiatives'
                    Tasks = @(
                        'Map AMBA-ALZ initiatives to management group scope.'
                    )
                }
                @{
                    Name  = 'Understand remediation'
                    Tasks = @(
                        'Explain remediation for greenfield and brownfield resources.'
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
                        'Deploy AMBA in portal at management group scope.'
                    )
                }
                @{
                    Name  = 'Deploy via Terraform'
                    Tasks = @(
                        'Deploy AMBA with Terraform module and archetypes.'
                    )
                }
                @{
                    Name  = 'Configure notifications'
                    Tasks = @(
                        'Configure notification assets and BYON routing options.'
                    )
                }
                @{
                    Name  = 'Validate deployment'
                    Tasks = @(
                        'Validate policy states, alerts, action groups, and APRs.'
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
                        'Select AMBA categories with initiative deployment toggles.'
                    )
                }
                @{
                    Name  = 'Select individual alerts'
                    Tasks = @(
                        'Select specific alerts with custom policy assignments.'
                    )
                }
                @{
                    Name  = 'Disable or suppress alerts'
                    Tasks = @(
                        'Compare suppression controls and exclusion mechanisms.'
                    )
                }
                @{
                    Name  = 'Tune thresholds'
                    Tasks = @(
                        'Tune thresholds globally and by resource tags.'
                    )
                }
                @{
                    Name  = 'Operate AMBA over time'
                    Tasks = @(
                        'Plan AMBA updates, remediation, and cleanup operations.'
                    )
                }
            )
        }
    )
}
