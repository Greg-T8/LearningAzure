# -------------------------------------------------------------------------
# Data: Skills.psd1
# Description: Domain, skill, and task hierarchy for the AZ-305 exam
# Context: AZ-305 — Designing Microsoft Azure Infrastructure Solutions
# Author: Greg Tate
# -------------------------------------------------------------------------

@{
    Domains = @(
        @{
            Name   = 'Design identity, governance, and monitoring solutions'
            Skills = @(
                @{
                    Name  = 'Design solutions for logging and monitoring'
                    Tasks = @(
                        'Recommend a logging solution'
                        'Recommend a solution for routing logs'
                        'Recommend a monitoring solution'
                    )
                }
                @{
                    Name  = 'Design authentication and authorization solutions'
                    Tasks = @(
                        'Recommend an authentication solution'
                        'Recommend an identity management solution'
                        'Recommend a solution for authorizing access to Azure resources'
                        'Recommend a solution for authorizing access to on-premises resources'
                        'Recommend a solution to manage secrets, certificates, and keys'
                    )
                }
                @{
                    Name  = 'Design governance'
                    Tasks = @(
                        'Recommend a structure for management groups, subscriptions, and resource groups, and a strategy for resource tagging'
                        'Recommend a solution for managing compliance'
                        'Recommend a solution for identity governance'
                    )
                }
            )
        }
        @{
            Name   = 'Design data storage solutions'
            Skills = @(
                @{
                    Name  = 'Design data storage solutions for relational data'
                    Tasks = @(
                        'Recommend a solution for storing relational data'
                        'Recommend a database service tier and compute tier'
                        'Recommend a solution for database scalability'
                        'Recommend a solution for data protection'
                    )
                }
                @{
                    Name  = 'Design data storage solutions for semi-structured and unstructured data'
                    Tasks = @(
                        'Recommend a solution for storing semi-structured data'
                        'Recommend a solution for storing unstructured data'
                        'Recommend a data storage solution to balance features, performance, and costs'
                        'Recommend a data solution for protection and durability'
                    )
                }
                @{
                    Name  = 'Design data integration'
                    Tasks = @(
                        'Recommend a solution for data integration'
                        'Recommend a solution for data analysis'
                    )
                }
            )
        }
        @{
            Name   = 'Design business continuity solutions'
            Skills = @(
                @{
                    Name  = 'Design solutions for backup and disaster recovery'
                    Tasks = @(
                        'Recommend a recovery solution for Azure and hybrid workloads that meets recovery objectives'
                        'Recommend a backup and recovery solution for compute'
                        'Recommend a backup and recovery solution for databases'
                        'Recommend a backup and recovery solution for unstructured data'
                    )
                }
                @{
                    Name  = 'Design for high availability'
                    Tasks = @(
                        'Recommend a high availability solution for compute'
                        'Recommend a high availability solution for relational data'
                        'Recommend a high availability solution for semi-structured and unstructured data'
                    )
                }
            )
        }
        @{
            Name   = 'Design infrastructure solutions'
            Skills = @(
                @{
                    Name  = 'Design compute solutions'
                    Tasks = @(
                        'Specify components of a compute solution based on workload requirements'
                        'Recommend a virtual machine-based solution'
                        'Recommend a container-based solution'
                        'Recommend a serverless-based solution'
                        'Recommend a compute solution for batch processing'
                    )
                }
                @{
                    Name  = 'Design an application architecture'
                    Tasks = @(
                        'Recommend a messaging architecture'
                        'Recommend an event-driven architecture'
                        'Recommend a solution for API integration'
                        'Recommend a caching solution for applications'
                        'Recommend an application configuration management solution'
                        'Recommend an automated deployment solution for applications'
                    )
                }
                @{
                    Name  = 'Design migrations'
                    Tasks = @(
                        'Evaluate a migration solution that leverages the Microsoft Cloud Adoption Framework for Azure'
                        'Evaluate on-premises servers, data, and applications for migration'
                        'Recommend a solution for migrating workloads to infrastructure as a service (IaaS) and platform as a service (PaaS)'
                        'Recommend a solution for migrating databases'
                        'Recommend a solution for migrating unstructured data'
                    )
                }
                @{
                    Name  = 'Design network solutions'
                    Tasks = @(
                        'Recommend a connectivity solution that connects Azure resources to the internet'
                        'Recommend a connectivity solution that connects Azure resources to on-premises networks'
                        'Recommend a solution to optimize network performance'
                        'Recommend a solution to optimize network security'
                        'Recommend a load-balancing and routing solution'
                    )
                }
            )
        }
    )
}
