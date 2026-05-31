## Domain: Design infrastructure solutions

### Skill: Design migrations

#### Task: Recommend a solution for migrating workloads to infrastructure as a service (IaaS) and platform as a service (PaaS)

| Supporting product documentation | URL | Why this supports the task |
| --- | --- | --- |
| [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/) | [https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/) | Provides the overarching methodology for evaluating workloads and selecting appropriate rehost (IaaS) or replatform (PaaS) migration strategies. |
| [Azure Migrate](https://learn.microsoft.com/en-us/azure/migrate/) | [https://learn.microsoft.com/en-us/azure/migrate/](https://learn.microsoft.com/en-us/azure/migrate/) | The central hub for discovering, assessing, and executing migrations of on-premises servers, web apps, and databases to Azure IaaS and PaaS targets. |
| [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | [https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) | Provides a compute decision tree to evaluate whether a migrating workload should target an IaaS or PaaS service based on business and technical constraints. |
| [Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/) | [https://learn.microsoft.com/en-us/azure/virtual-machines/](https://learn.microsoft.com/en-us/azure/virtual-machines/) | The primary IaaS target for "lift and shift" server migrations where full OS and infrastructure control is required. |
| [Azure VMware Solution](https://learn.microsoft.com/en-us/azure/azure-vmware/) | [https://learn.microsoft.com/en-us/azure/azure-vmware/](https://learn.microsoft.com/en-us/azure/azure-vmware/) | Provides an IaaS migration path for lifting and shifting entire VMware environments to Azure without changing underlying hypervisors. |
| [App Service](https://learn.microsoft.com/en-us/azure/app-service/) | [https://learn.microsoft.com/en-us/azure/app-service/](https://learn.microsoft.com/en-us/azure/app-service/) | A primary PaaS target for replatforming legacy web applications, reducing operational overhead by offloading underlying infrastructure management. |
| [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/) | [https://learn.microsoft.com/en-us/azure/aks/](https://learn.microsoft.com/en-us/azure/aks/) | A PaaS target for migrating and orchestrating containerized workloads, supporting modern application replatforming and microservices architecture. |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/) | [https://learn.microsoft.com/en-us/azure/container-apps/](https://learn.microsoft.com/en-us/azure/container-apps/) | A serverless PaaS compute option for migrating microservices and containerized applications without the overhead of managing underlying Kubernetes clusters. |

Potentially relevant products considered: Azure Migrate, Microsoft Cloud Adoption Framework, Azure Virtual Machines, Azure VMware Solution, App Service, Azure Kubernetes Service (AKS), Azure Container Apps, Azure Functions.

Forum-discovery note: Public candidate discussions commonly mention needing to distinguish between "lift and shift" (IaaS) and "replatforming" (PaaS) scenarios, frequently referencing the compute decision tree and the Azure Migrate tool's assessment capabilities. These were used only as discovery signals and validated against official Microsoft documentation before inclusion.

Coverage notes:

* The task spans both high-level migration methodology (Cloud Adoption Framework) and specific technical execution tooling (Azure Migrate).
* Architecture guidance, such as the Compute Decision Tree, is highly useful for determining when to recommend an IaaS vs. PaaS target and should be heavily reviewed.
* Documentation sets for Azure Migrate and the Azure Architecture Center are worth downloading first to understand the assessment and decision-making process.
* Target compute products (App Service, Azure VMs, AKS) are covered at a high level to support service selection and migration planning, rather than deep-dive operational configuration.
