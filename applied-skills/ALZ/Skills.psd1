# -------------------------------------------------------------------------
# Data: Skills.psd1
# Description: Domain, skill, and task hierarchy for the ALZ applied skill
# Context: ALZ - Azure Landing Zone
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
                        'Identify accelerator phases and output strategy.'
                    )
                }
                @{
                    Name  = 'Understand the platform_landing_zone template'
                    Tasks = @(
                        'Map template files, AVM modules, and core resources.'
                    )
                }
                @{
                    Name  = 'Deploy or dry-run the platform landing zone'
                    Tasks = @(
                        'Configure scope and run a safe landing zone plan.'
                    )
                }
                @{
                    Name  = 'Verify the baseline landing zone'
                    Tasks = @(
                        'Validate baseline hierarchy, policies, and management resources.'
                    )
                }
            )
        }
    )
}
