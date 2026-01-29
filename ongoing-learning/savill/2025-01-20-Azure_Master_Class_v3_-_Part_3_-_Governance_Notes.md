# Azure Master Class v3 - Part 3 - Governance - Exam Notes

**Video:** [https://www.youtube.com/watch?v=t-i4XrygWCc](https://www.youtube.com/watch?v=t-i4XrygWCc)  
**Published:** 2025-01-20  
**Duration:** 2:12:02  

*Generated on 2026-01-29 05:34*

---

## Table of Contents

- [Introduction](#introduction)
- [Governance 101](#governance-101)
- [Understanding requirements](#understanding-requirements)
- [Compliance manager in Purview](#compliance-manager-in-purview)
- [Mitigating risk](#mitigating-risk)
- [Key organizational components](#key-organizational-components)
- [Management groups](#management-groups)
- [Entra GA Azure resource elevation](#entra-ga-azure-resource-elevation)
- [Organizing management groups](#organizing-management-groups)
- [Subscriptions](#subscriptions)
- [Controlling subscription policies](#controlling-subscription-policies)
- [Azure limits](#azure-limits)
- [How many subscriptions?](#how-many-subscriptions)
- [Resource groups](#resource-groups)
- [Moving resources](#moving-resources)
- [Naming standards](#naming-standards)
- [Tags](#tags)
- [Types of governance](#types-of-governance)
- [Inheritance](#inheritance)
- [Who, what and how much](#who-what-and-how-much)
- [Locks](#locks)
- [ARM and resource structure](#arm-and-resource-structure)
- [Actions available on resources](#actions-available-on-resources)
- [Role Based Access Control](#role-based-access-control)
- [Role assignments](#role-assignments)
- [Permissions in a role](#permissions-in-a-role)
- [Data plane roles](#data-plane-roles)
- [Sum of role assignments](#sum-of-role-assignments)
- [Custom roles](#custom-roles)
- [PIM usage](#pim-usage)
- [Attribute Based Access Control](#attribute-based-access-control)
- [Azure Policy](#azure-policy)
- [Cost management and budgets](#cost-management-and-budgets)
- [Budgets](#budgets)
- [Tag inheritance for billing](#tag-inheritance-for-billing)
- [Cost allocation](#cost-allocation)
- [API and PowerBI](#api-and-powerbi)
- [Pricing calculator](#pricing-calculator)
- [Optimizing costs](#optimizing-costs)
- [Azure reservations](#azure-reservations)
- [Azure Compute Savings Plan](#azure-compute-savings-plan)
- [Azure Hybrid Benefit](#azure-hybrid-benefit)
- [On-demand capacity reservations](#on-demand-capacity-reservations)
- [Deployment stacks](#deployment-stacks)
- [Resource graph](#resource-graph)
- [Resource configuration change](#resource-configuration-change)
- [Azure Advisor](#azure-advisor)
- [Great resources](#great-resources)
- [Close](#close)

## Introduction

**Timestamp**: 00:00:00 – 00:01:00

**Key Concepts**

- Importance of guardrails in cloud resource management
- Core constructs for applying guardrails: management groups, subscriptions, resource groups
- Types of guardrails: policy, role-based access control (RBAC), budgets
- Governance as a critical aspect of cloud usage

**Definitions**

- **Guardrails**: Controls and policies applied to manage how application owners create and manage cloud resources.
- **Management Groups**: Organizational containers to manage access, policies, and compliance across multiple subscriptions.
- **Subscriptions**: Billing and resource management containers within the cloud.
- **Resource Groups**: Logical containers for grouping related cloud resources.
- **Policy**: Rules that enforce specific conditions on resources.
- **Role-Based Access Control (RBAC)**: Permissions management system to control user access.
- **Budgets**: Financial limits set to control cloud spending.

**Key Facts**

- Guardrails are necessary due to changes in how application owners create resources in the cloud.
- Governance in the cloud differs significantly from on-premises environments.
- The module will cover best practices, standards, and architectural guidance related to governance.

**Examples**

- Example of an application owner managing resources on-premises versus in the cloud (briefly mentioned).

**Key Takeaways 🎯**

- Understanding and implementing guardrails is essential for effective cloud governance.
- Governance ensures controlled and secure resource creation and management.
- Familiarity with management groups, subscriptions, and resource groups is foundational.
- Policies, RBAC, and budgets are primary tools for enforcing governance.
- Cloud governance requires a different approach compared to traditional on-premises setups.

---

## Governance 101

**Timestamp**: 00:01:00 – 00:06:01

**Key Concepts**

- Governance in the cloud is critical due to the fundamentally different behavior compared to on-premises environments.
- On-premises resource provisioning involves an operations team enforcing organizational policies before resources are provisioned.
- In the cloud, app owners have direct access to provision resources without an intermediary.
- Governance is needed to enforce organizational, regulatory, and security policies regardless of how resources are provisioned.
- Governance controls what resources can be created, their configurations, and limits to prevent risks such as data leaks or exposure.
- Understanding organizational requirements and standards is the first step before designing governance solutions.
- Standards may come from internal policies or external regulatory compliance (industry, country).
- Cloud environments have shared responsibility models that impact governance.

**Definitions**

- **Governance**: The process and mechanisms to enforce organizational rules, policies, and standards on cloud resource provisioning and usage to ensure compliance, security, and operational control.
- **App Owner**: The individual or team responsible for an application who requests or provisions cloud resources.
- **Operations Team**: In on-premises environments, the group responsible for reviewing and enforcing policies before provisioning resources.

**Key Facts**

- On-premises provisioning typically requires a request to an operations team who enforces policies before resource creation.
- Cloud provisioning allows direct resource creation via portals, CLI, infrastructure as code, or pipelines without human intervention.
- Lack of governance in cloud provisioning can lead to misconfigurations, exposure of sensitive data, and security vulnerabilities.
- Governance must be enforced consistently regardless of the provisioning method.
- Cloud environments offer a large variety of services, some of which can pose security risks if misused.

**Examples**

- On-premises: An app owner requests a VM or container via a form, email, or phone call to an operations team who then provisions the resource according to organizational rules.
- Cloud: The app owner directly provisions a VM or container using the Azure portal, CLI, or DevOps pipeline without an operations team intermediary.

**Key Takeaways 🎯**

- Cloud governance is essential because cloud resource provisioning bypasses traditional operational controls.
- Governance ensures compliance with company policies and regulatory requirements even when app owners provision resources directly.
- Governance protects against risks like accidental exposure of public-facing resources or data leaks.
- Before implementing governance, organizations must clearly understand their internal and external compliance requirements.
- Governance mechanisms must be able to enforce rules automatically and consistently across all provisioning methods.
- Recognize the shared responsibility model in cloud governance to understand what the cloud provider manages versus what the organization must control.

---

## Understanding requirements

**Timestamp**: 00:06:01 – 00:09:32

**Key Concepts**

- Understanding organizational requirements is the first step before designing any solution.
- Requirements often stem from internal policies or external regulatory compliance.
- Compliance responsibilities in cloud environments are shared between the provider (Microsoft) and the customer.
- Microsoft provides extensive compliance certifications and detailed information through its Trust Center.
- The Trust Center and Compliance offerings portals help users explore applicable standards by service type, country, and industry.
- Accessibility reports, regional compliance reports, and audit reports are available for deeper insights.
- Microsoft Purview (Compliance Manager) assists in tracking compliance status and managing regulatory assessments.

**Definitions**

- **Governance**: Enforcing rules and standards to ensure compliance regardless of how resources are created or managed.
- **Shared Responsibility Model**: The division of compliance and security duties between the cloud provider (Microsoft) and the customer, varying by service type (IaaS, PaaS, SaaS).
- **Microsoft Trust Center**: A portal providing detailed information on Microsoft’s compliance certifications, standards, and audit reports.
- **Microsoft Purview Compliance Manager**: A tool within Microsoft Purview that helps track compliance status and manage regulatory requirements, requiring appropriate Microsoft 365 or Office licenses.

**Key Facts**

- Compliance requirements can be internal (organizational policies) or external (country or industry regulations).
- Moving from Infrastructure as a Service (IaaS) to Platform as a Service (PaaS) to Software as a Service (SaaS) generally reduces customer responsibility but does not eliminate it.
- Microsoft holds a large number of compliance certifications and provides detailed compliance documentation.
- The Trust Center allows filtering compliance information by country, service type (Azure, Dynamics), and compliance category.
- Compliance Manager in Microsoft Purview requires specific licenses and offers special assessments for US Government and Department of Defense clouds.

**Examples**

- Using the Microsoft Trust Center to view compliance offerings and audit reports.
- Accessing accessibility and regional compliance reports via the compliance portal.
- Using Microsoft Purview Compliance Manager to track compliance status and regulatory assessments.

**Key Takeaways 🎯**

- Always start by thoroughly understanding your compliance and governance requirements before designing cloud solutions.
- Leverage Microsoft’s Trust Center and compliance portals to research applicable standards and certifications.
- Recognize the shared responsibility model and know which compliance aspects you as a customer must manage.
- Use tools like Microsoft Purview Compliance Manager to monitor and manage compliance effectively.
- Compliance is an ongoing process supported by detailed documentation and reporting available from Microsoft.

---

## Compliance manager in Purview

**Timestamp**: 00:09:32 – 00:12:18

**Key Concepts**

- Microsoft Purview includes a Compliance Manager tool to track compliance status.
- Compliance Manager provides a compliance score and highlights key improvement actions.
- Assessments can be viewed and added, such as the data protection baseline.
- Shared responsibility model: some compliance controls are the customer’s responsibility, others are Microsoft’s.
- Detailed tracking of controls and improvement actions is possible, including assigning owners and editing implementation status.
- Implementation details can include testing status, pass/fail results, dates, and notes.
- Purview serves as a centralized portal for organizations to monitor and manage compliance efforts.
- The ultimate goal of governance and compliance tools is risk mitigation (data loss, infiltration, service interruption, reputation damage).

**Definitions**

- **Compliance Manager**: A feature within Microsoft Purview that helps organizations track their compliance status, manage assessments, and monitor improvement actions.
- **Data Protection Baseline**: A specific assessment framework within Compliance Manager focusing on data protection controls.
- **Shared Responsibility Model**: The division of compliance responsibilities between Microsoft and the customer.

**Key Facts**

- Access to Compliance Manager requires an Office or Microsoft 365 license.
- Special assessments are available for US Government or Department of Defense (DOD) Cloud customers.
- Microsoft generally achieves higher compliance scores than customers in the shared responsibility model.
- Users can assign owners to compliance tasks and track progress in detail.
- Implementation status options include: doing it, doing something else, out of scope, tested, passed, with notes.

**Examples**

- Viewing the data protection baseline assessment to see progress and points earned.
- Assigning an owner to a compliance improvement action and tracking its implementation status.
- Editing details to mark an action as tested and passed, including notes on how and when it was done.

**Key Takeaways 🎯**

- Compliance Manager in Purview is a powerful tool for tracking and managing compliance efforts within an organization.
- The portal provides transparency into both Microsoft’s and the customer’s responsibilities under the shared responsibility model.
- Assigning owners and updating implementation details helps maintain accountability and progress visibility.
- Using Purview helps organizations mitigate various risks by ensuring compliance controls are properly managed and tracked.
- Compliance management is an ongoing process that benefits from detailed documentation and active monitoring.

---

## Mitigating risk

**Timestamp**: 00:12:18 – 00:12:41

**Key Concepts**

- Governance activities primarily focus on mitigating various types of risk.
- Risks include data loss, infiltration, service interruption, reputation damage, and job security risks related to poor implementation.

**Definitions**

- **Mitigating risk**: The process of reducing or managing potential negative outcomes related to organizational operations and compliance.

**Key Facts**

- Governance and compliance mechanisms are designed to address and reduce risks.
- Types of risks explicitly mentioned:
  - Risk of data loss
  - Risk of infiltration (security breaches)
  - Risk of service interruption
  - Risk of reputation damage
  - Risk of being fired due to poor implementation

**Examples**

- None mentioned specifically in this segment.

**Key Takeaways 🎯**

- The core purpose of governance and compliance efforts is to mitigate risk.
- Understanding the types of risks helps organizations prioritize their governance strategies.
- Effective tracking and implementation of compliance measures are essential to risk mitigation.

---

## Key organizational components

**Timestamp**: 00:12:41 – 00:12:49

**Key Concepts**

- Organizational components are crucial in governance approaches.
- Management groups form a hierarchy structure.
- Azure subscriptions are placed under management groups.

**Definitions**

- **Management Groups**: Organizational units that help form a hierarchy under which Azure subscriptions are organized.
- **Azure Subscriptions**: The fundamental building blocks within Azure where resources and services are created.

**Key Facts**

- Management groups are the first key organizational component mentioned.
- Azure subscriptions serve as the building blocks for creating resources.

**Examples**

- None mentioned explicitly in this short segment.

**Key Takeaways 🎯**

- Understanding management groups is essential for structuring governance in Azure.
- Organizing subscriptions under management groups helps manage resources effectively within an organization.

---

## Management groups

**Timestamp**: 00:12:49 – 00:15:37

**Key Concepts**

- Management groups form a hierarchical structure to organize Azure subscriptions.
- Azure subscriptions are the fundamental building blocks for creating resources in Azure.
- Each Azure subscription trusts a specific Entra tenant for identity and security principals.
- Every Entra tenant has a single root management group at the top of the hierarchy.
- Under the root management group, multiple management groups can be created to organize subscriptions and apply governance.
- The management group hierarchy can be up to six levels deep.
- Entra permissions, such as being a global administrator, influence Azure resource access and management capabilities.

**Definitions**

- **Management groups**: Organizational containers in Azure that allow you to group subscriptions into a hierarchy for governance and management purposes.
- **Azure subscription**: A container for Azure resources that trusts a specific Entra tenant for identity and access management.
- **Entra tenant**: The directory service that houses security principals and identities trusted by Azure subscriptions.
- **Root management group**: The single, immutable top-level management group present in every Entra tenant under which all other management groups and subscriptions are organized.

**Key Facts**

- Each Entra tenant has exactly one root management group.
- The management group hierarchy can be up to six levels deep.
- The root management group cannot be moved or reorganized.
- Global administrators in Entra can have special permissions to manage all Azure subscriptions and management groups within the tenant.
- Access management for Azure resources can be enabled or disabled in Entra properties, affecting permissions.

**Examples**

- An organization’s Entra tenant contains a root management group.
- Under this root, the organization creates multiple management groups to organize subscriptions based on governance needs.
- A global administrator with "access management for Azure resources" enabled can manage all subscriptions and management groups in the tenant.

**Key Takeaways 🎯**

- Management groups provide a flexible and hierarchical way to organize Azure subscriptions for governance.
- The root management group is foundational and cannot be altered or moved.
- Proper structuring of management groups helps apply consistent governance policies across subscriptions.
- Entra tenant permissions directly impact the ability to manage Azure subscriptions and management groups.
- Avoid unnecessary complexity in management group hierarchies; use up to six levels only if needed.

---

## Entra GA Azure resource elevation

**Timestamp**: 00:15:37 – 00:17:25

**Key Concepts**

- Global administrators in Entra can elevate their permissions to manage Azure resources.
- Access management for Azure resources can be enabled in Entra properties.
- Elevation grants special permissions to manage all Azure subscriptions and management groups within the tenant.
- The "User Access Administrator" role can be inherited from the root management group.
- This elevation acts as a "break glass" capability for emergency access scenarios.
- Root management group ID cannot be renamed, but its display name can be changed.
- Subscriptions must trust the tenant to be part of the management group hierarchy.

**Definitions**

- **Access Management for Azure Resources**: A setting in Entra that allows a global administrator to manage Azure subscriptions and management groups across the tenant.
- **User Access Administrator**: A role that allows managing role assignments and access control on Azure subscriptions or management groups.
- **Break Glass Capability**: An emergency access method allowing a global admin to temporarily elevate permissions to resolve access issues.

**Key Facts**

- Entra allows enabling access management for Azure resources (typically off by default).
- Elevation grants the ability to manage all Azure subscriptions and management groups in the tenant.
- The "User Access Administrator" role can be inherited from the root management group.
- Root management group ID is fixed and cannot be renamed; only the display name can be changed.
- All subscriptions must trust the tenant to be included in the management group hierarchy.

**Examples**

- A global administrator enables access management for Azure resources to gain permission to manage all subscriptions.
- If a subscription owner leaves and locks everyone out, a global admin can elevate themselves temporarily to regain access.

**Key Takeaways 🎯**

- Entra global admins can elevate themselves to manage Azure resources by enabling access management in the tenant properties.
- This elevated access is powerful but should be used sparingly and only in emergency ("break glass") situations.
- The root management group is central to permission inheritance and governance hierarchy.
- Proper trust relationships between subscriptions and the tenant are required for management group governance.
- Display names of root management groups can be customized, but IDs are immutable.

---

## Organizing management groups

**Timestamp**: 00:17:25 – 00:20:12

**Key Concepts**

- Management groups are hierarchical containers used to organize subscriptions for governance at scale.
- Each management group can have only one parent but can have many child management groups.
- Policies and permissions can be applied at different levels of the management group hierarchy to control governance broadly or specifically.
- Subscriptions trust a tenant and roll up under the tenant root management group by default.
- Only subscription owners have the authority to move subscriptions between management groups.

**Definitions**

- **Management Group**: A container that helps organize subscriptions into a hierarchy for applying governance policies and permissions at scale.
- **Tenant Root Management Group**: The top-level management group in a tenant hierarchy; cannot be renamed but its display name can be changed.
- **Subscription**: The basic unit in Azure for billing, management, and security; it trusts a specific tenant and is placed under the tenant root management group by default.

**Key Facts**

- Up to 10,000 management groups can exist per tenant.
- A management group can only have one parent but can have multiple children.
- Subscriptions automatically roll up to the tenant root management group unless moved.
- Only subscription owners can change the placement of subscriptions within management groups.
- Changing the tenant a subscription trusts is possible but causes loss of role-based access control and managed identities (billing remains unchanged).

**Examples**

- Organizing management groups by geography (geo) to apply location-specific policies.
- Organizing by business unit to reflect different permission requirements.
- Organizing by environment, such as development, test, and production, to apply environment-specific policies.
- Example hierarchy: Tenant root → Child management groups like "All Savile Tech Subscriptions," "Development," and "Production," with subscriptions rolled up under these groups.

**Key Takeaways 🎯**

- Use management groups to simplify governance by applying policies at appropriate levels—broad policies at the root, specific policies lower down.
- Structure management groups based on logical divisions such as geography, business units, or environments to reflect organizational needs.
- Remember that only subscription owners can move subscriptions between management groups.
- The tenant root management group is fixed in ID but customizable in display name.
- Be cautious when changing the tenant a subscription trusts due to potential loss of access controls and identities.

---

## Subscriptions

**Timestamp**: 00:20:12 – 00:21:48

**Key Concepts**

- Subscriptions are the foundational unit for creating and managing resources in Azure.
- Subscriptions serve as the basic unit for billing and management.
- Each subscription is trusted by a specific Entra tenant.
- Changing the Entra tenant a subscription trusts is possible but complex and generally discouraged.
- Security and permissions tied to a subscription are critical and lost if the tenant trust is changed.
- Azure administrators can control whether subscriptions can join or leave a tenant.
- Subscription policies can be managed via the Azure portal to control tenant join/leave permissions.

**Definitions**

- **Subscription**: The starting unit in Azure for creating resources; it is the basic unit for billing, management, and security.
- **Entra Tenant**: The identity boundary that a subscription trusts for authentication and authorization.

**Key Facts**

- Changing the Entra tenant a subscription trusts will remove all role-based access control and managed identities but does not affect billing.
- Moving a subscription to another tenant is generally not recommended due to loss of security and permissions.
- Subscription owners have the authority to move subscriptions within management groups.
- Administrators can set policies to allow or restrict subscriptions from joining or leaving a tenant.
- Policy options include allowing everyone, permitting no one, or exempting specific users.

**Examples**

- None specifically detailed beyond the mention of managing subscriptions and policies in the Azure portal.

**Key Takeaways 🎯**

- Subscriptions are central to Azure resource management and billing.
- Tenant trust is a critical security boundary for subscriptions.
- Changing tenant trust is a difficult operation with significant security implications.
- Administrators have control over subscription lifecycle policies, including tenant join/leave permissions.
- Proper management of subscriptions and their policies is essential to maintain security and operational integrity.

---

## Controlling subscription policies

**Timestamp**: 00:21:48 – 00:23:34

**Key Concepts**

- Control over who can add or remove subscriptions within an Azure tenant.
- Use of "Manage Policies" in the Azure portal to configure subscription joining and leaving permissions.
- Ability to set broad permissions (e.g., allow everyone or permit no one) and create exemptions for specific users.
- Organizing multiple subscriptions under management groups for better hierarchy and governance.
- Awareness of Azure limits related to subscriptions and management groups.

**Definitions**

- **Manage Policies**: An advanced options menu in the Azure portal under subscriptions that allows administrators to control subscription joining/leaving permissions.
- **Subscription**: A container in Azure that holds resources and is associated with billing and access control.
- **Management Group**: A container that helps organize subscriptions into a hierarchy for unified policy and access management.

**Key Facts**

- Administrators can allow or restrict who can add or remove subscriptions in their tenant.
- Permissions can be set to "allow everyone," "permit no one," or customized with exempted users.
- Multiple subscriptions can be grouped under a single management group.
- Azure has limits such as:
  - Up to 10,000 management groups.
  - A root management group plus six levels of nested management groups.
  - Unlimited number of subscriptions per tenant.
  - 980 resource groups per subscription (mentioned as upcoming topic).
- There are additional limits on tags, deployments, resource groups, templates, and entry IDs.

**Examples**

- Setting "permit no one" for adding or removing subscriptions but allowing specific exempted users to perform those actions.
- Grouping subscriptions named Subscription A, B, C under a management group for organizational purposes.

**Key Takeaways 🎯**

- Use the Manage Policies feature to tightly control subscription membership and movement within your tenant.
- Establish clear permissions and exemptions to maintain security and governance.
- Organize subscriptions logically under management groups to simplify management and policy application.
- Be aware of Azure service limits to plan your subscription and management group architecture effectively.
- Refer to Azure’s subscription limits documentation for detailed constraints and best practices.

---

## Azure limits

**Timestamp**: 00:23:34 – 00:24:46

**Key Concepts**

- Azure has various limits across different service types.
- Limits exist at multiple levels: management groups, subscriptions, resource groups, templates, and more.
- Understanding these limits is important for planning and managing Azure resources effectively.
- Guidance on the number of subscriptions to have has evolved over time.

**Definitions**

- **Management Group Limits**: Constraints on the number of management groups, including a maximum of 10,000 and up to six levels beneath the root.
- **Subscription Limits**: Restrictions related to subscriptions such as the number of subscriptions per tenant, resource groups per subscription, tags, and deployment counts.
- **Resource Group Limits**: Limits related to resource groups within subscriptions (details to be discussed later).

**Key Facts**

- Maximum of 10,000 management groups.
- Up to six levels of management groups under the root.
- Unlimited number of subscriptions per Azure Active Directory tenant.
- Maximum of 980 resource groups per subscription.
- Other limits include the number of tags on a subscription and subscription-level deployments.
- There is a dedicated subscription limit page available for detailed reference.

**Examples**

- None mentioned explicitly in this segment.

**Key Takeaways 🎯**

- Always consult the Azure subscription limit page to understand specific service limits.
- The previous strict guidance on minimizing the number of subscriptions has relaxed.
- It is now acceptable to create multiple subscriptions as needed, especially to separate workloads or business units.
- Naming standards and organizational hierarchy remain important when managing multiple subscriptions.

---

## How many subscriptions?

**Timestamp**: 00:24:46 – 00:26:38

**Key Concepts**

- The guidance on the number of Azure subscriptions has evolved from strict limits to a more flexible approach.
- Subscriptions act as boundaries for certain resources (e.g., virtual networks cannot span subscriptions).
- Management groups help organize subscriptions logically for permissions and policies.
- Sharing multiple apps within a single subscription can complicate alert management and resource limits.
- Resource groups are containers within subscriptions where resources are deployed.

**Definitions**

- **Subscription**: A container for Azure resources that serves as a boundary for some services and resource limits.
- **Management Group**: A higher-level organizational structure that groups subscriptions to apply policies and permissions consistently.
- **Resource Group**: A logical container within a subscription where Azure resources are deployed; resource groups cannot be nested.

**Key Facts**

- Previous guidance recommended keeping subscriptions to a very small number and only adding when necessary.
- Current guidance allows creating as many subscriptions as needed based on workload or business needs.
- Virtual networks cannot span multiple subscriptions.
- Service health alerts may lack specificity when multiple apps share a single subscription.
- Management groups enable applying policies and RBAC across multiple subscriptions effectively.
- Every Azure resource lives in exactly one resource group.
- Resource groups exist within subscriptions and are not nested inside each other.

**Examples**

- Having 20 different apps sharing one subscription can make it difficult to identify which app a service health alert relates to.
- Creating a subscription per workload or business unit is now considered a sensible approach.

**Key Takeaways 🎯**

- It is no longer necessary to limit the number of subscriptions strictly; create subscriptions as it makes sense for workloads or business organization.
- Use management groups to maintain logical structure and consistent policies across subscriptions.
- Be aware that some resources and limits are scoped at the subscription level, so organizing workloads accordingly can simplify management.
- Resource groups are the deployment units inside subscriptions and cannot be nested.

---

## Resource groups

**Timestamp**: 00:26:38 – 00:29:35

**Key Concepts**

- Resource groups are the containers into which Azure resources are deployed.
- Every Azure resource belongs to exactly one resource group.
- Resource groups exist within a specific subscription.
- Resource groups are flat structures; they cannot be nested inside one another.
- Resources grouped together typically share a common lifecycle (creation, running, deprovisioning).
- Policies and role-based access control (RBAC) can be applied at the resource group level.
- Resource groups are not boundaries for resource interaction; resources in different groups can still work together.
- A resource group has a region specified, but this only applies to where its metadata is stored.
- Resources from multiple regions can coexist within the same resource group.
- Resources can be moved between resource groups, subscriptions, and regions (with validation).

**Definitions**

- **Resource group**: A logical container within an Azure subscription that holds related resources sharing a common lifecycle and management policies.

**Key Facts**

- One resource can only belong to one resource group.
- Resource groups cannot be nested; the structure is flat within a subscription.
- Policies and RBAC permissions are commonly applied at the resource group level.
- The region assigned to a resource group refers only to metadata location, not resource location.
- Resources can be moved across resource groups, subscriptions, and regions, subject to validation.

**Examples**

- An AKS (Azure Kubernetes Service) cluster and a MySQL database can be placed in the same resource group if they share a lifecycle.
- A virtual network (VNet) might be in a different resource group than the AKS cluster nodes that connect to it, often due to different team permissions (e.g., networking team managing VNets).
- Using the Azure portal, resources can be moved from one resource group to another, or even to a different subscription or region.

**Key Takeaways 🎯**

- Use resource groups to organize resources that share a lifecycle and management policies.
- Resource groups help simplify applying policies and access controls to related resources.
- Do not assume resource groups restrict resource connectivity; resources across groups can interact.
- The region of a resource group is only about metadata location; resources within can be from any region.
- Resources can be moved between groups and subscriptions, but moving across regions requires validation.

---

## Moving resources

**Timestamp**: 00:29:35 – 00:32:16

**Key Concepts**

- Resources can be moved between resource groups, subscriptions, and regions (with some restrictions).
- Resource groups have a specified region, but this only applies to metadata location, not the resources themselves.
- Moving resources involves validation checks, especially when moving across regions.
- Resource groups cannot be renamed; to "rename," you must create a new group and move resources.
- Governance and management scopes are applied primarily at management groups, subscriptions, and resource groups.
- Applying governance at the resource level is generally avoided due to complexity and limits.
- Proper grouping of resources in resource groups reduces the need for resource-level governance.

**Definitions**

- **Resource Group**: A container that holds related Azure resources; it has a region assigned for metadata but can contain resources from multiple regions.
- **Move (Resources)**: The process of transferring resources from one resource group, subscription, or region to another, subject to validation.

**Key Facts**

- Moving resources to another region requires validation to check feasibility.
- You cannot rename a resource group because it is part of the identity of the resources within it.
- Deleting a resource group deletes all resources contained within it.
- Governance is applied at different scopes: management groups (broad), subscriptions (more specific), resource groups (very specific), and rarely at the resource level.
- There are limits on how many role-based access control (RBAC) assignments can be applied at the resource level.

**Examples**

- Using the Azure portal, the "Move" option allows moving resources to another resource group, subscription, or region.
- To rename a resource group, you must create a new resource group and move resources into it.

**Key Takeaways 🎯**

- Resource groups serve as key organizational and governance boundaries in Azure.
- Moving resources is flexible but constrained by validation, especially for cross-region moves.
- Renaming resource groups is not supported; plan resource group names carefully.
- Governance should be applied at higher scopes (management groups, subscriptions, resource groups) rather than individual resources to maintain manageability.
- Proper initial grouping of resources reduces complexity in governance and management.

---

## Naming standards

**Timestamp**: 00:32:16 – 00:34:28

**Key Concepts**

- Importance of having a standardized naming convention for Azure resources.
- Naming and tagging strategies are core components of resource management.
- Consistency in naming across cloud and on-premises environments is crucial.
- Naming conventions help quickly identify resource type, workload, environment, region, and instance.
- Tagging complements naming by allowing key-value pairs for additional metadata.

**Definitions**

- **Naming convention**: A systematic method for naming resources that includes elements such as resource type, workload/application, environment, region, and instance number.
- **Tagging**: The use of key-value pairs assigned to resources to provide additional metadata beyond the resource name.

**Key Facts**

- Azure provides recommended naming standards as part of its Cloud Adoption Framework.
- Naming conventions typically include:
  - Resource type
  - Workload or application name
  - Environment (e.g., dev, non-prod)
  - Azure region or on-premises data center location
  - Instance number
- Tagging is supported on nearly all Azure resources, including subscriptions and resource groups, but not management groups.
- Naming and tagging strategies improve manageability and clarity of resources.

**Examples**

- Naming components might look like: `[resource type]-[workload]-[environment]-[region]-[instance number]`
- Example environments mentioned: dev, non-prod
- Regions could be Azure regions or on-premises data centers.

**Key Takeaways 🎯**

- Develop and enforce a consistent naming convention across both cloud and on-premises environments.
- Use naming conventions to intuitively understand resource details at a glance.
- Extend naming standards to guest OS and other related components for uniformity.
- Use tagging to supplement naming where additional metadata is needed.
- Consistency in naming and tagging simplifies management and reduces complexity in large environments.

---

## Tags

**Timestamp**: 00:34:28 – 00:41:54

**Key Concepts**

- Tags are metadata key-value pairs applied to Azure resources to provide additional information beyond naming conventions.
- Tags can be applied at multiple levels: subscription, resource group, and individual resource (but not management groups).
- Tags help organize, filter, and manage resources effectively, especially for governance, billing, and operational clarity.
- Tag inheritance does not happen by default; child resources do not automatically inherit tags from parent scopes.
- Azure Policy can be used to enforce tagging standards and enable tag inheritance from parent resources.
- Consistency in tag keys and values is critical for effective use and automation.
- Tags can hold complex data, including JSON documents, to store richer information within tag values.

**Definitions**

- **Tag**: A metadata element consisting of a key and a value pair that can be applied to Azure resources to provide additional descriptive information.
- **Azure Policy**: A governance tool that can enforce rules and effects over resources, including tag enforcement and inheritance.

**Key Facts**

- Tags are supported on nearly all Azure resource types except management groups.
- Up to 50 tags can be applied per resource in most cases; some resource types allow only 15.
- Tag names can be up to 512 characters; tag values can be up to 256 characters.
- Common recommended tags include: business criticality, business unit, operations team, app owner, cost center, environment, Azure region, and owner name.
- Tag values should be standardized (e.g., use "prod" consistently instead of mixing "prod," "production," or "live").
- Tags are not inherited by default from subscriptions or resource groups to resources.
- Azure Policy can be configured to inherit tags from resource groups or subscriptions if missing on resources.
- Billing can leverage tag inheritance from resource groups or subscriptions without copying tags to resources.

**Examples**

- Using tags like "environment" with consistent values such as "prod" instead of mixed terms.
- Storing JSON documents as tag values to hold detailed configuration info like anti-malware versions or firewall settings.
- Azure Policy definitions that enforce tag inheritance from resource groups or subscriptions to resources when tags are missing.

**Key Takeaways 🎯**

- Develop and enforce a clear tagging strategy with standardized keys and values to avoid confusion and enable effective resource management.
- Use tags to identify resource ownership and avoid accidental deletion of critical resources.
- Be cautious when enforcing tags via policy, as it can block automation that creates resources without tags.
- Remember that tags do not inherit automatically; use Azure Policy to enable inheritance where needed.
- Tags are powerful for filtering views, managing billing, and governance but require discipline and planning to be effective.
- Consider using richer tag values (e.g., JSON) to store complex metadata within tag limits.
- Tagging complements naming conventions but provides more flexible and detailed metadata for resources.

---

## Types of governance

**Timestamp**: 00:41:54 – 00:42:16

**Key Concepts**

- Governance is applied across multiple hierarchical levels: management groups, subscriptions, and resource groups.
- Governance capabilities include applying policies and permissions.
- Inheritance is a fundamental principle in governance application.

**Definitions**

- **Inheritance**: The process by which policies or permissions applied at a higher level (e.g., management group) automatically propagate down to all subordinate levels (subscriptions, resource groups, resources).

**Key Facts**

- Governance settings applied at the root level affect every management group, subscription, resource group, and resource.
- Applying governance at the subscription level affects all resource groups and resources within that subscription.
- Applying governance at the resource group level affects all resources within that group.

**Examples**

- None mentioned explicitly in this time range.

**Key Takeaways 🎯**

- Always be cautious about where governance policies or permissions are applied because they inherit downwards.
- Understanding the inheritance model is critical to effective governance management.
- Governance structures enable powerful cost management and organizational control by leveraging inheritance across hierarchical levels.

---

## Inheritance

**Timestamp**: 00:42:16 – 00:43:45

**Key Concepts**

- Inheritance applies to policies, permissions, budgets, and other governance aspects within management groups, subscriptions, resource groups, and resources.
- Applying settings at a higher scope automatically applies them to all child scopes below.
- Careful consideration is needed when choosing the scope to apply policies or permissions due to inheritance.
- Budgets set at a higher scope roll up and aggregate costs or limits from all child resources.

**Definitions**

- **Inheritance**: The mechanism by which policies, permissions, budgets, and other governance settings applied at a parent scope (e.g., management group or subscription) automatically propagate down to all child scopes (e.g., subscriptions, resource groups, resources).

**Key Facts**

- Applying a policy or permission at the root level affects every management group, subscription, resource group, and resource beneath it.
- Budgets set at the subscription level include all resources within all resource groups under that subscription.
- Inheritance is fundamental to governance in cloud resource management.

**Examples**

- Applying a policy at the root scope means every management group, subscription, resource group, and resource inherits that policy.
- Setting a budget at the subscription level aggregates costs from all resource groups and resources within that subscription.

**Key Takeaways 🎯**

- Always be mindful of the scope where policies, permissions, or budgets are applied because of automatic inheritance to child scopes.
- Inheritance enables powerful, centralized governance across an entire organization or subscription.
- Budgets and policies roll up or roll down through the hierarchy, making it easier to manage at scale.
- Understanding inheritance is critical to effectively managing role-based access control, policies, and budgets in cloud environments.

---

## Who, what and how much

**Timestamp**: 00:43:45 – 00:45:11

**Key Concepts**

- Role-Based Access Control (RBAC): Defines who can perform actions at a given scope.
- Policy: Defines what actions can be performed.
- Budget: Defines how much can be spent or used.
- Locking: Controls modifications at the subscription, resource group, or resource level.

**Definitions**

- **Role-Based Access Control (RBAC)**: A mechanism to specify who can do certain actions at a specific scope within Azure.
- **Policy**: A set of rules that govern what actions are allowed or denied on resources.
- **Budget**: A financial or resource usage limit set to control how much can be spent or consumed.
- **Lock**: A control applied at the Azure control plane to prevent changes or deletion of resources, without affecting data operations inside the resource.

**Key Facts**

- Budgets can be set not only for financial spend but also for limits on the quantity of certain resource types.
- Budgets roll up to the scope they are set on, affecting all child resources.
- Locks can be applied at multiple levels: subscription, resource group, or individual resource.
- Locks prevent changes to resource attributes or deletion of the resource itself but do not prevent data operations within the resource (e.g., deleting data inside a locked storage account is still possible).

**Examples**

- Setting a budget at the subscription level affects all resources and resource groups within that subscription.
- Locking a storage account prevents deleting or modifying the storage account but does not prevent deleting data inside it.

**Key Takeaways 🎯**

- Azure governance constructs (RBAC, policy, budget, locking) work together to control who can do what and how much at various scopes.
- Inheritance is fundamental: settings applied at a higher scope cascade down to child scopes.
- Locks operate at the control plane level and do not block data plane operations.
- Budgets provide both financial and resource quantity controls, supporting cost management and resource governance.

---

## Locks

**Timestamp**: 00:45:11 – 00:48:50

**Key Concepts**

- Locks are applied at the Azure control plane level.
- Locks do not prevent data operations within a resource, only control plane operations.
- Locks can be set to two types: Read-only or Delete prevention.
- Locks are inherited down the resource hierarchy (subscription → resource group → resource).
- Locks help protect against accidental deletion or modification of resources.
- Only owners at the scope where the lock is applied can remove the lock.
- Azure services like Azure Backup may automatically add locks to resources.
- Locks are part of Azure governance and enforced by Azure Resource Manager.

**Definitions**

- **Lock (Azure)**: A control plane mechanism that restricts certain management operations on Azure resources to prevent accidental deletion or modification.
- **Read-only Lock**: Prevents any changes or deletion of the resource attributes.
- **Delete Lock (CanNotDelete)**: Allows changes to resource attributes but prevents deletion of the resource.
- **Control Plane**: The management layer in Azure responsible for resource configuration and management operations, distinct from data plane operations which handle data within resources.

**Key Facts**

- Locks do not block data actions such as deleting data inside a storage account or database rows.
- Locks can be applied at multiple scopes: subscription, resource group, or individual resource.
- Locks are inherited down the hierarchy, meaning a lock at subscription level applies to all underlying resources.
- To remove a lock, you must have owner permissions at the scope where the lock is applied.
- Azure Resource Manager enforces locks as part of governance.

**Examples**

- Locking a storage account to prevent deletion or attribute changes, but still allowing deletion of blobs inside it.
- Azure Backup automatically adding a lock to a resource to protect it.
- Creating a lock at the resource group or subscription level to protect all contained resources.

**Key Takeaways 🎯**

- Locks are a governance tool to prevent accidental resource deletion or modification at the management layer.
- They do not protect the actual data inside resources, only the resource configuration and existence.
- Locks are hierarchical and inherited, so applying a lock at a higher scope protects all nested resources.
- Proper permissions (owner role) are required to remove locks.
- Understanding the distinction between control plane and data plane is crucial when using locks.
- Locks complement other governance features like policies and budgets in Azure.

---

## ARM and resource structure

**Timestamp**: 00:48:50 – 00:53:09

**Key Concepts**

- Azure Resource Manager (ARM) is the underlying framework that structures Azure resources.
- Resources in Azure are organized under resource providers, each offering different resource types.
- Each resource type has specific properties and actions that can be performed on it.
- ARM exposes resource attributes which are fundamental for services like Azure Policy.
- The structure and metadata of resources can be explored via tools like Azure Resource Explorer and the Azure portal.
- Resource definitions are consistent across different interfaces, including ARM templates and Bicep files.
- API versions are used to define resource details when creating or managing resources programmatically.
- Azure roles and permissions can be queried to see what actions are allowed on specific resource types.

**Definitions**

- **Azure Resource Manager (ARM)**: The deployment and management service for Azure that provides a consistent management layer for resources, organizing them by resource providers and resource types.
- **Resource Provider**: A service in Azure that offers a set of resource types (e.g., Compute, Storage).
- **Resource Type**: A specific kind of resource under a resource provider (e.g., virtual machines under the Compute provider).
- **API Version**: The version of the REST API used to define or interact with a resource, important for specifying resource details in templates.
- **Azure Resource Explorer**: A tool to browse and inspect the structure and metadata of Azure resources.
- **Bicep**: A domain-specific language (DSL) for declaratively deploying Azure resources, which uses the same resource types and providers as ARM templates.

**Key Facts**

- Azure is composed of many resource providers, each with multiple resource types.
- Example resource types under the Compute provider include virtual machines, virtual machine scale sets, and managed disks.
- The Azure portal allows viewing the JSON representation of any resource, showing its type and properties.
- There are limits on the number of queries you can make to the Azure control plane in a given time.
- The resource type naming convention includes the provider namespace, e.g., `Microsoft.Storage/storageAccounts`.
- ARM templates and Bicep files use the same resource type and provider naming conventions.
- Actions applicable to resources can be queried, for example, to see what operations are allowed on a virtual machine.

**Examples**

- Viewing the JSON of a storage account resource in the Azure portal shows its type as `Microsoft.Storage/storageAccounts`.
- A Bicep file example creating a storage account uses the same resource provider and resource type (`Microsoft.Storage/storageAccounts`).
- Querying Azure roles to list all actions applicable to a virtual machine resource.

**Key Takeaways 🎯**

- Understanding the ARM resource structure is crucial for managing Azure resources effectively.
- Resource providers and resource types form the backbone of Azure’s resource organization.
- The consistency of resource types across the portal, ARM templates, and Bicep simplifies automation and infrastructure as code.
- Tools like Azure Resource Explorer and the portal’s JSON view help in exploring and understanding resource details.
- Knowing the API version and available actions for resources is important when scripting or automating resource management.
- Azure Policy leverages resource attributes exposed by ARM, so understanding resource structure aids in policy creation and enforcement.

---

## Actions available on resources

**Timestamp**: 00:53:09 – 00:54:28

**Key Concepts**

- Actions are specific operations that can be performed on Azure resources.
- Different resources expose different sets of actions.
- Understanding available actions is important for creating custom roles and managing permissions.
- Role-Based Access Control (RBAC) can be applied at multiple scopes including management groups, subscriptions, resource groups, and individual resources.
- Permissions and actions assigned at higher scopes are inherited by child resources.

**Definitions**

- **Actions**: Operations or commands that can be executed on a resource, such as starting or stopping a virtual machine.
- **Role-Based Access Control (RBAC)**: A system to assign permissions to users or identities at various scopes to control what actions they can perform on Azure resources.

**Key Facts**

- Actions vary widely depending on the resource type.
- Example actions for a virtual machine include: `start`, `power off`, and `reapply`.
- RBAC supports assignment at multiple levels: management groups, subscriptions, resource groups, and individual resources.
- Permissions assigned at a parent scope are inherited by all child resources.

**Examples**

- Querying Azure roles to list all actions applicable to a virtual machine.
- Actions shown for a VM include start, power off, and reapply.
- Using this information to create custom roles or understand capabilities.

**Key Takeaways 🎯**

- Knowing the available actions on a resource is crucial for advanced policy creation and permission management.
- You can query and inspect actions to tailor custom roles precisely.
- RBAC inheritance simplifies permission management but applying access control at the individual resource level can be complex to manage.
- Always consider the scope of RBAC assignments to balance manageability and granularity.

---

## Role Based Access Control

**Timestamp**: 00:54:28 – 00:57:07

**Key Concepts**

- Role-Based Access Control (RBAC) is supported at multiple scopes: management groups, subscriptions, resource groups, and individual resources.
- Permissions assigned at a higher scope are inherited by child scopes.
- Managing permissions at the resource group level or above is recommended for easier management.
- There is a limit to the number of role assignments per subscription (approximately 4,000).
- Inheritance of permissions cannot be blocked.
- RBAC does not support explicit deny permissions that override granted permissions at higher scopes.
- Roles are collections of actions grouped together for easier permission management.
- Assigning permissions one action at a time is possible but impractical and hard to manage.
- Common sets of permissions are grouped into roles, which are then assigned to groups or identities.

**Definitions**

- **Role-Based Access Control (RBAC)**: A system to control what actions various identities can perform at different scopes within a cloud environment by assigning roles that group permissions.
- **Role**: A collection of actions/permissions grouped together to simplify management and assignment of access rights.
- **Inheritance**: Permissions assigned at a higher scope (e.g., subscription) automatically apply to all child scopes (e.g., resource groups, resources).

**Key Facts**

- RBAC can be applied at management groups, subscriptions, resource groups, and resource levels.
- Permissions assigned at a higher scope are inherited by all child resources.
- There is a limit of about 4,000 role assignments per subscription.
- It is difficult to manage permissions at the individual resource level due to scale and limits.
- There is no capability to block inheritance of permissions.
- RBAC does not have a deny permission that overrides granted permissions at higher scopes.
- Some policies can deny certain actions (e.g., deleting resources), but this is outside RBAC.

**Examples**

- Applying permissions at the resource group level is preferred over per resource to avoid complexity and hitting assignment limits.
- Denying the ability to delete a resource can be done through policy but not through RBAC deny permissions.

**Key Takeaways 🎯**

- Use RBAC primarily at the resource group level or above for manageable permission control.
- Understand that permissions flow downwards via inheritance and cannot be blocked.
- Avoid assigning roles at the resource level unless necessary due to limits and complexity.
- Roles simplify permission management by grouping common actions.
- RBAC does not support explicit deny permissions; use policies for restrictions like denying deletes.
- Always consider the scope and inheritance model when designing access control strategies.

---

## Role assignments

**Timestamp**: 00:57:07 – 00:59:15

**Key Concepts**

- Grouping individual permissions/actions into roles simplifies management.
- Roles are assigned to groups rather than individual identities to reduce complexity.
- Role assignments link a role to a security principal (usually a group) at a specific scope.
- Scopes can be subscription, management group, or resource group levels.
- Built-in roles exist and are scoped to resource types (e.g., storage-related roles).
- Common built-in roles include Owner and Contributor, each with different permission levels.

**Definitions**

- **Role**: A collection of permissions/actions grouped together to simplify access management.
- **Role Assignment**: The act of granting a role to a security principal (typically a group) at a defined scope.
- **Scope**: The boundary at which a role assignment applies, such as subscription, management group, or resource group.
- **Security Principal**: An identity that can be assigned roles; can be a user, managed identity, service principal, or group.

**Key Facts**

- Assigning permissions individually is possible but impractical due to complexity.
- Roles are typically granted to groups rather than individuals to avoid messy management.
- When viewing roles in a resource like a storage account, only roles relevant to that resource type are shown.
- The **Owner** role has full permissions, including the ability to change permissions on the resource.
- The **Contributor** role can perform almost all actions except changing permissions.

**Examples**

- Assigning a role to a group at a subscription or resource group scope.
- Viewing storage-related roles in the access control panel of a storage account.
- Owner role: full control including permission changes.
- Contributor role: can modify resources but cannot change permissions.

**Key Takeaways 🎯**

- Use roles to group permissions for easier management.
- Prefer assigning roles to groups rather than individuals to maintain clarity and scalability.
- Understand the scope concept to properly limit where roles apply.
- Recognize built-in roles and their permission boundaries, especially Owner vs Contributor.
- Role assignments are fundamental to implementing role-based access control effectively.

---

## Permissions in a role

**Timestamp**: 00:59:15 – 01:00:54

**Key Concepts**

- Roles define sets of permissions related to specific resources or resource types.
- Built-in roles can be filtered by resource type (e.g., storage) to show relevant roles only.
- Roles vary in scope and power, from very broad (Owner) to more limited (Contributor).
- Granularity in role assignment is important to ensure least privilege access.
- Roles can include different types of actions: control plane actions and data plane actions.

**Definitions**

- **Owner**: A role with full permissions across all resource providers, including the ability to change permissions on the resource.
- **Contributor**: A role that can perform almost all actions the Owner can, except it cannot change permissions on the resource.
- **Control Plane Actions**: Operations related to managing the resource itself (e.g., configuration, properties).
- **Data Plane Actions**: Operations related to the data within the resource (e.g., reading or writing blobs in storage).

**Key Facts**

- When viewing roles for a storage account, only roles related to storage are shown.
- Owner role includes all permissions and can modify permissions.
- Contributor role can modify resource attributes and properties but cannot assign permissions.
- Resource groups can have every possible role available because they encompass many resource types.
- Some roles, like "Storage Account Contributor," have control plane actions but no data actions.
- Other roles, such as "Blob Data Contributor," include both control plane and data plane actions.
- There are multiple data-related roles for storage, including storage queue data and storage table data roles.

**Examples**

- Owner role: full permissions including permission changes.
- Contributor role: can change properties but cannot assign permissions.
- Storage Account Contributor: has control plane actions but no data actions.
- Blob Data Contributor: has both control plane and data plane actions.

**Key Takeaways 🎯**

- Always assign the minimum necessary role to users to follow the principle of least privilege.
- Understand the difference between control plane and data plane actions when assigning roles.
- Use resource-specific role filtering to find appropriate roles.
- Owner role should be used sparingly due to its broad permissions.
- Data-related roles provide finer granularity for managing access to the actual data within storage resources.

---

## Data plane roles

**Timestamp**: 01:00:54 – 01:02:27

**Key Concepts**

- Distinction between control plane actions and data plane actions in Azure roles.
- Data plane roles allow permissions directly on data resources (e.g., Blob storage, queues, tables).
- Integration of data plane permissions into Azure Entra identity model, replacing the need for access keys.
- Role-based access control (RBAC) can now be applied at a granular data level.
- Managed identities can use data plane roles to interact with data securely.
- Multiple role assignments aggregate permissions (sum of all assigned roles).

**Definitions**

- **Control Plane Actions**: Operations related to managing the resource itself (e.g., creating, deleting storage accounts).
- **Data Plane Actions**: Operations related to accessing or manipulating the data within the resource (e.g., reading/writing blobs).
- **Data Plane Roles**: Azure roles that include permissions for data plane actions, allowing fine-grained access control on data.
- **Access Keys**: Legacy method for accessing storage data, not identity-specific and difficult to audit.
- **Managed Identities**: Azure feature providing automatic identities for resources to securely access other resources without credentials.

**Key Facts**

- Storage account contributor roles primarily include control plane actions and initially no data actions.
- Blob data contributor and similar roles include both control plane and data plane actions.
- More Azure services, including databases, now support data plane role permissions integrated with Entra.
- Using data plane RBAC is preferred over access keys for better granularity and auditability.
- Permissions from multiple roles assigned to a user/resource are cumulative.

**Examples**

- Storage account contributor role has control plane actions but no data actions by default.
- Blob data contributor role includes data plane actions for blob storage.
- Managed identities can be assigned data plane roles to interact with data without using access keys.

**Key Takeaways 🎯**

- Prefer using data plane role-based access control integrated with Azure Entra over access keys for security and audit benefits.
- Data plane roles provide granular permissions on data resources, improving security posture.
- Managed identities simplify secure access to data by leveraging these roles.
- When multiple roles are assigned, permissions are additive, so consider all role assignments when auditing access.
- Understanding the difference between control plane and data plane actions is critical for proper access management.

---

## Sum of role assignments

**Timestamp**: 01:02:27 – 01:04:20

**Key Concepts**

- Role assignments are cumulative; a user receives the combined permissions of all roles assigned.
- Permissions can be inherited from parent scopes such as management groups or subscriptions.
- Access control shows all role assignments and their inheritance paths.
- Permissions are not limited to the highest or lowest role but are the sum of all applicable roles.
- Roles consist of specific actions assigned at particular scopes.

**Definitions**

- **Role Assignment**: The association of a role to an identity at a specific scope, granting permissions.
- **Scope**: The level at which a role is assigned (e.g., resource, subscription, management group).
- **Inherited Permissions**: Permissions granted at a higher scope that apply to lower-level resources.
- **Sum of Role Assignments**: The total set of permissions a user has from all assigned roles combined.

**Key Facts**

- Permissions from multiple roles assigned to a user are additive.
- Most role assignments are often inherited from higher-level scopes rather than assigned directly on the resource.
- Checking access on a resource shows the full set of permissions aggregated from all role assignments.
- Roles include both management actions and data actions specific to the scope.

**Examples**

- A user may be an Owner because they have that role assigned at a parent management group level.
- A user can simultaneously be a Contributor and an Owner due to multiple role assignments.
- Some permissions are assigned directly on the resource for demonstration purposes, but most come from inheritance.

**Key Takeaways 🎯**

- Always consider the cumulative effect of all role assignments when evaluating permissions.
- Inherited roles from parent scopes significantly impact effective permissions on a resource.
- Use access checks to view the full set of permissions granted by all roles.
- Roles are defined by actions at specific scopes, and permissions are additive, not exclusive.
- Understanding role inheritance and summation is critical for accurate access control and auditing.

---

## Custom roles

**Timestamp**: 01:04:20 – 01:07:50

**Key Concepts**

- Custom roles allow creation of tailored permission sets when built-in roles do not meet specific needs.
- Custom roles are composed of actions, data actions, not actions, and not data actions.
- Assignable scopes for custom roles must be explicitly defined and can be limited to subscriptions, resource groups, or management groups.
- Cloning existing roles is a practical way to start creating a custom role and then modify permissions.
- Use of "not actions" allows exclusion of specific permissions, especially when wildcards are involved.
- Managing assignable scopes thoughtfully can maximize reuse and avoid unnecessary proliferation of roles.
- Assigning roles to groups (preferably) rather than individual users helps manage role assignments efficiently.
- Privileged Identity Management (PIM) can be leveraged with custom roles for just-in-time and just-enough access.

**Definitions**

- **Custom Role**: A role created by the user that defines a specific set of permissions (actions and data actions) tailored to meet precise requirements not covered by built-in roles.
- **Assignable Scope**: The specific Azure scope(s) (subscription, resource group, management group) where a custom role can be assigned.
- **Not Actions / Not Data Actions**: Permissions explicitly excluded from a custom role, useful for refining roles that include wildcards.
- **Privileged Identity Management (PIM)**: A service that enables just-in-time privileged access by making roles eligible and requiring activation for a limited time.

**Key Facts**

- Up to 5,000 custom roles can be created per Azure tenant (2,000 for China cloud).
- Custom roles cannot have the same broad assignable scope flexibility as built-in roles; scopes must be specified explicitly.
- Assignable scopes can include multiple subscriptions, resource groups, or management groups.
- Cloning an existing role is a common starting point for creating a custom role.
- Using groups for role assignments reduces the number of individual assignments and simplifies management.

**Examples**

- Cloning the built-in "Storage Queue Data Contributor" role to create a custom role by modifying permissions and excluding certain actions.
- Specifying assignable scopes such as a subscription and a resource group when creating a custom role.

**Key Takeaways 🎯**

- Create custom roles only when built-in roles do not meet the exact permission requirements.
- Be cautious not to create too many custom roles to avoid management complexity.
- Use cloning of existing roles to simplify custom role creation.
- Carefully define assignable scopes to maximize role reuse and avoid unnecessary duplication.
- Prefer assigning roles to groups rather than individual users to streamline access management.
- Leverage PIM to provide just-in-time access, enhancing security by limiting active permissions to when they are needed.

---

## PIM usage

**Timestamp**: 01:07:50 – 01:09:38

**Key Concepts**

- Use of Privileged Identity Management (PIM) to manage role assignments.
- Granting roles as "eligible" rather than "active" to enable just-in-time access.
- Integration of PIM into the Azure portal for role assignment.
- Time-bound or permanent eligibility with PIM policies.
- PIM as a recommended best practice to minimize standing privileges.
- PIM is a premium (P2) feature with associated costs.
- Role-Based Access Control (RBAC) access reviews to monitor and adjust group memberships.
- Introduction to Attribute-Based Access Control (ABAC) as a more granular alternative to RBAC.

**Definitions**

- **Privileged Identity Management (PIM)**: A service that provides just-in-time privileged access to Azure resources by making roles eligible instead of permanently active, allowing activation only when needed.
- **Eligible Role Assignment**: A role assignment state where the user can activate the role for a limited time rather than having continuous active permissions.
- **Role-Based Access Control (RBAC)**: A method of regulating access to resources based on assigned roles.
- **Attribute-Based Access Control (ABAC)**: An access control method that uses attributes (of users and resources) to determine permissions, enabling more granular access management.

**Key Facts**

- PIM allows roles to be assigned as eligible, requiring activation for a specific period.
- The Azure portal now integrates PIM directly into the role assignment process, showing "assignment type" options.
- Eligible assignments can be permanent or time-bound.
- PIM is a P2 feature, implying additional licensing costs.
- Access reviews in RBAC help track and fine-tune group memberships.
- ABAC helps avoid RBAC bloat when managing very granular permissions, such as data actions on storage account containers.

**Examples**

- When adding a role assignment to a resource group or subscription, you can select "eligible" as the assignment type instead of "active."
- Managing permissions for different containers within a single storage account can be complex with RBAC alone, motivating the use of ABAC.

**Key Takeaways 🎯**

- Always prefer granting roles to groups rather than individual users to simplify management.
- Leverage PIM to enforce just-in-time and just-enough access, reducing standing privileges.
- Use the Azure portal’s PIM integration to assign roles as eligible and apply appropriate policies.
- Be aware of the licensing cost associated with PIM (P2 feature).
- Conduct regular access reviews to maintain proper access control.
- Consider ABAC for scenarios requiring fine-grained access control beyond what RBAC can efficiently handle.

---

## Attribute Based Access Control

**Timestamp**: 01:09:38 – 01:18:00

**Key Concepts**

- Attribute-Based Access Control (ABAC) extends Role-Based Access Control (RBAC) by adding conditional access based on attributes of the user, resource, or environment.
- ABAC helps manage granular permissions efficiently, especially when dealing with complex data scenarios like multiple containers within a storage account.
- Conditions in ABAC can include matching user attributes to resource tags, environmental factors (e.g., subnet, private endpoint), and time windows.
- ABAC is currently limited to certain built-in or custom roles related to BLOB or queue data actions but is expected to expand.
- Custom security attributes in Microsoft Entra can be used to define user attributes that participate in ABAC conditions.

**Definitions**

- **Attribute-Based Access Control (ABAC)**: An access control method that grants or denies permissions based on attributes of the user, resource, and environment, allowing for fine-grained and dynamic access decisions.
- **Custom Security Attributes (in Entra)**: User-defined attributes assigned to identities in Microsoft Entra to enable attribute-based conditions in access control policies.
- **BLOB Index Tag**: Metadata tags applied to BLOB storage containers or objects used to match against user attributes in ABAC conditions.

**Key Facts**

- ABAC conditions can compare user attributes (e.g., a custom attribute called "primary project") with resource tags (e.g., a BLOB index tag called "project").
- Conditions can also enforce access based on network environment (e.g., requiring connection from a specific subnet or via PrivateLink) and time (e.g., UTC time windows).
- ABAC role assignments are optional and currently apply primarily to BLOB and queue data permissions.
- Example custom security attribute set: "Project Attribute Set" with predefined values such as alpha, gamma, bravo.
- Example user: Clark Kent has a "primary project" attribute set to "alpha".
- Storage containers and blobs have BLOB index tags that must match the user's project attribute for access to be granted.

**Examples**

- A role assignment grants the "BLOB data reader" permission to the Justice League group with two conditions:
  1. Container name must be "general" (case-insensitive).
  2. User's "primary project" attribute must match the BLOB index tag "project" on the blob.
- Clark Kent (user) with "primary project" = alpha can access blobs tagged with "alpha" but not those tagged with "bravo" or other projects.
- Clark Kent can access the "general" container and specific blobs matching his project attribute but is denied access to blobs tagged with different projects.
- Access is authenticated via Microsoft Entra identity, not by storage access keys, enabling enforcement of ABAC policies.

**Key Takeaways 🎯**

- ABAC allows for much more granular and dynamic access control than RBAC alone, especially useful in complex data environments.
- Matching user attributes to resource tags reduces the need for multiple storage accounts or containers to segregate data by project or group.
- ABAC conditions can incorporate environmental and temporal factors, enhancing security posture.
- Custom security attributes in Entra are essential for implementing ABAC in Azure.
- ABAC currently supports data actions on BLOB and queue storage but is expected to expand.
- Using Entra authentication (instead of access keys) is critical to enforce ABAC policies effectively.
- ABAC transforms permission management by enabling attribute-driven access, simplifying governance in multi-project or multi-team scenarios.

---

## Azure Policy

**Timestamp**: 01:18:00 – 01:32:51

**Key Concepts**

- Azure Policy is a governance tool that sits on top of Azure Resource Manager (ARM) and enforces rules across all management interfaces (portal, CLI, infrastructure as code).
- Policies cannot be bypassed; all resource operations must go through the control plane and policy evaluation.
- Azure Policy supports both **audit** (to check compliance) and **enforcement** (to restrict actions).
- Policies are based on conditions applied to resource attributes exposed via **aliases**.
- Policies can be assigned at different scopes: management group, subscription, resource group, or individual resources.
- Policies can be grouped into **initiatives** (policy sets) for easier management and compliance tracking.
- Policy effects include **audit**, **deny**, **append**, **modify**, **deployIfNotExists**, **disabled**, and others.
- Exemptions can be applied at child scopes to waive compliance for specific resources or resource groups.
- Custom policies can be created to meet specific organizational requirements.
- Policy assignments can exclude certain scopes using **notScopes**.
- Common use cases include restricting regions, VM SKUs, storage redundancy types, mandatory tags, and public IP restrictions.

**Definitions**

- **Azure Policy**: A service that enforces organizational standards and assesses compliance at-scale by evaluating resource properties against defined rules.
- **Alias**: A reference to resource properties exposed by Azure Policy to build conditions.
- **Initiative**: A collection of policy definitions grouped together to simplify assignment and compliance tracking.
- **Effect**: The action taken when a policy rule condition is met (e.g., audit, deny, append).
- **DeployIfNotExists**: A policy effect that triggers deployment of a resource or configuration if it does not exist, useful for remediation.
- **Exemption**: A waiver applied to a resource or resource group that excludes it from compliance evaluation without changing the policy assignment.
- **NotScope**: A scope exclusion applied during policy assignment to exclude specific child resources or groups.

**Key Facts**

- Azure Policy applies to all management interfaces and cannot be bypassed.
- Starting with **audit** mode is recommended to understand impact before enforcing policies.
- Policy definitions can be built-in or custom.
- Parameters can be passed during policy assignment to customize behavior.
- There are built-in initiatives for compliance standards like FedRAMP High, NIST, PCI DSS v4, containing hundreds of policies (e.g., 719 policies in PCI DSS initiative).
- Up to 400 exclusions (notScopes) can be specified per policy assignment.
- Deny effect currently supports preventing deletion of resources.
- DeployIfNotExists can use managed identities to deploy extensions or agents post-deployment.
- Exemptions require permission at the scope of assignment to apply.

**Examples**

- Audit mode used to check compliance before enforcement to avoid accidental blocking.
- Policy to restrict storage accounts to have network ACL default action set to deny.
- Custom policy denying deletion of storage accounts with names matching a pattern (e.g., "SCG*prod").
- Policy denying public IP assignment except for specified subnets.
- Initiatives like FedRAMP High or PCI DSS group hundreds of policies for compliance.
- DeployIfNotExists used to add a Log Analytics extension if missing.
- Exemptions applied to resources tracked by Defender for Cloud to mark them as compliant despite policy violations.

**Key Takeaways 🎯**

- Azure Policy is a foundational governance tool that enforces rules consistently across Azure resources.
- Always start with audit mode to understand the impact before moving to enforcement.
- Use initiatives to manage and assign large sets of policies efficiently.
- Customize policies and initiatives to fit organizational needs and compliance requirements.
- Utilize exemptions and notScopes to handle exceptions without breaking overall compliance.
- DeployIfNotExists is a powerful remediation tool to automatically fix non-compliant resources.
- Proper descriptions and explanations in policies help users understand why actions are denied.
- Governance via Azure Policy should be established early to set guardrails before resource creation.

---

## Cost management and budgets

**Timestamp**: 01:32:51 – 01:37:02

**Key Concepts**

- Cost management provides insight and control over cloud spending (Azure and AWS).
- Cost analysis tools help track and understand spending patterns.
- Smart views use machine learning to detect spending deviations and provide insights.
- Customizable views allow filtering and grouping of cost data by various parameters (e.g., tags, resource groups).
- Automatic export of cost data can be configured for external use.
- Cost anomaly alerts notify stakeholders of unusual spending patterns using machine learning.
- Budgets enable setting spending limits at different scopes with specific filters.
- Budget alerts can trigger notifications, webhooks, or Azure functions based on thresholds.
- Budgets can be based on actual spend or forecasted spend.

**Definitions**

- **Cost Management**: Tools and features that provide insight and control over cloud spending, including cost analysis and anomaly detection.
- **Smart Views**: Predefined cost analysis views enhanced by machine learning to highlight spending anomalies and insights.
- **Cost Anomaly Alerts**: Alerts triggered by machine learning detection of unusual spending patterns, notifying designated people.
- **Budgets**: Configurable spending limits set at various scopes (management groups, resource groups, etc.) with customizable filters and alert actions.

**Key Facts**

- Cost management supports both Azure and AWS environments via connectors.
- Smart views can show daily run rate changes, e.g., a 72% increase on a certain day.
- Filters can be applied on cost data by tags, resource types, and other parameters.
- Grouping options include resource group name and others.
- Automatic export allows scheduled export of cost data for external analysis.
- Budget alerts can be configured to notify via email, call webhooks, or trigger Azure functions.
- Budgets can be scoped very specifically, including by tag or resource type.
- Budgets support alerts based on both actual spend and forecasted spend.

**Examples**

- Using smart views to identify a daily run rate increase of 72% on a specific day.
- Adding filters to cost analysis to view costs only for resources with a specific tag.
- Setting up cost anomaly alerts to email certain people when unusual spending is detected.
- Creating budgets scoped to resource groups or filtered by tags, with notifications or automated actions triggered at spending thresholds.

**Key Takeaways 🎯**

- Cost management tools are essential for gaining visibility and control over cloud expenditures.
- Machine learning-powered smart views and anomaly alerts help proactively detect and respond to unexpected costs.
- Customizable cost analysis views and filters enable precise tracking tailored to organizational needs.
- Budgets are powerful for enforcing spending limits and automating responses to cost thresholds.
- Budgeting can be proactive by using forecasted spend, not just actual spend.
- Integration with alerts and automation (webhooks, Azure functions) allows for flexible cost governance workflows.

---

## Budgets

**Timestamp**: 01:37:02 – 01:39:43

**Key Concepts**

- Budgets allow setting spending limits within Azure Cost Management.
- Budgets can be scoped at different levels: management groups, subscriptions, resource groups.
- Budgets support filtering by tags, resource types, and other criteria for granular control.
- Budgets can trigger actions based on thresholds of actual or forecasted spend.
- Actions can include notifications (emails), webhooks, Azure functions, and integration with action groups.
- Forecast-based budgets enable proactive cost management by triggering alerts before the budget is fully spent.
- Action groups enable diverse responses such as SMS, secure webhooks, logic apps, and ITSM ticket creation.

**Definitions**

- **Budget**: A predefined spending limit set within Azure Cost Management to monitor and control cloud costs.
- **Action Group**: A collection of notification preferences and actions that can be triggered when budget thresholds are met, including emails, SMS, webhooks, and automation workflows.
- **Forecasted Spend**: An estimate of future spending based on current usage trends, used to trigger budget alerts before actual spend reaches the limit.

**Key Facts**

- Budgets can be created without filters or with specific filters like resource type or tags.
- Example budget amount mentioned: $125 for an entire subscription.
- Budget actions can be triggered at various thresholds, e.g., at 80% actual spend or if forecasted spend is trending to exceed 120%.
- Budgets support both actual spend and forecasted spend thresholds for triggering actions.
- Action groups allow integration with multiple communication and automation tools.
- Tags do not inherit automatically except for billing purposes, which can be enabled or disabled.

**Examples**

- A budget set at the subscription level with no filters and a $125 limit.
- Actions configured to trigger when actual spend hits 80% or forecasted spend is trending to 120%.
- Using action groups to send SMS, call webhooks, trigger Azure functions, or create ITSM tickets based on budget alerts.

**Key Takeaways 🎯**

- Budgets provide flexible, granular control over Azure spending with the ability to filter by tags and resource types.
- Forecast-based budget alerts enable proactive cost management by warning before overspending occurs.
- Integration with action groups expands the ways budget alerts can be handled, supporting automation and operational workflows.
- Understanding and configuring budget thresholds and actions is critical for effective cost governance.
- Tag inheritance for billing can be enabled to ensure consistent cost tracking across resources and subscriptions.

---

## Tag inheritance for billing

**Timestamp**: 01:39:43 – 01:41:01

**Key Concepts**

- Tag inheritance in Azure is generally not automatic except for billing purposes.
- Tag inheritance can be enabled at the subscription or resource group level to apply tags for billing roll-ups.
- Tag inheritance does not write tags directly to individual resources but affects billing aggregation.
- Cost allocation can be managed using tags, especially in environments with shared resources across business units.

**Definitions**

- **Tag inheritance**: A feature that allows billing systems to consider tags from parent resources (like subscriptions or resource groups) when calculating costs, even if those tags are not explicitly applied to individual resources.
- **Cost allocation**: The process of distributing shared resource costs across different business units or subscriptions, often facilitated by tagging.

**Key Facts**

- Tag inheritance is disabled by default and must be enabled manually in cost management settings.
- Enabling tag inheritance is useful when granular tagging policies are not enforced at the resource level but billing needs to reflect parent-level tags.
- Tag inheritance impacts billing roll-ups but does not modify the actual resource tags.

**Examples**

- Enabling tag inheritance on a lab subscription to have resources inherit billing tags from the subscription or resource group level.
- Scenario where multiple business units have their own subscriptions and apps, but shared resources exist that need cost allocation via tags.

**Key Takeaways 🎯**

- Tag inheritance is a billing-specific feature that helps unify cost tracking without changing resource-level tags.
- It is important to enable tag inheritance in cost management settings if billing tags are managed at a higher level than individual resources.
- Cost allocation using tags supports scenarios with shared resources across multiple business units or subscriptions.

---

## Cost allocation

**Timestamp**: 01:41:01 – 01:44:39

**Key Concepts**

- Cost allocation involves distributing shared resource costs among multiple consumers or business units.
- Shared resources (sources) can be subscriptions, resource groups, or tagged resources.
- Targets are the entities (subscriptions, resource groups, tags) that benefit from shared resources and among which costs are split.
- Cost splits can be even, custom percentage-based, or proportional based on spend.
- Proportional splitting can be based on overall spend or specific resource provider spend (compute, storage, network).
- Allocated costs appear on the target’s bill alongside their accumulated costs, providing transparency.
- Cost allocation helps organizations fairly distribute costs of shared infrastructure and services.

**Definitions**

- **Cost Allocation**: The process of dividing the cost of shared resources among multiple consumers or business units based on defined rules or usage metrics.
- **Source**: The shared resource(s) whose costs are being allocated (e.g., an ExpressRoute circuit, domain controllers).
- **Target**: The subscriptions, resource groups, or tagged entities that consume or benefit from the shared resources and receive allocated costs.

**Key Facts**

- Cost splits can be:
  - Even (equal distribution)
  - Custom percentage-based
  - Proportional to spend (e.g., if one subscription spends $10,000 and another $1,000, the larger spender gets 10x the allocated cost)
- Proportional splits can be refined by resource provider spend (compute, storage, network) to better reflect actual usage.
- Allocated costs show up on bills as a separate line item, helping targets understand their share of shared resource costs.
- Azure provides an API (Microsoft billing resource provider) to review costs at subscription or enterprise agreement levels.
- Microsoft Cost Management Connector in Power BI Desktop can be used to analyze costs.
- Microsoft Cost Management covers not only Azure but also M365, Dynamics 365, and Power Platform costs.

**Examples**

- Shared ExpressRoute circuit costs allocated proportionally based on network spend of consuming subscriptions.
- Shared domain controllers or infrastructure costs split among business units using those services.

**Key Takeaways 🎯**

- Cost allocation enables fair and transparent distribution of shared resource costs across business units or teams.
- Using proportional splits based on actual spend or resource-specific spend provides a more accurate cost distribution.
- Allocated costs are visible on bills, improving cost accountability and understanding.
- Utilize Azure’s billing APIs and Power BI connectors for detailed cost analysis and reporting.
- Cost allocation is essential for organizations with shared infrastructure to avoid absorbing costs without clear attribution.

---

## API and PowerBI

**Timestamp**: 01:44:39 – 01:45:15

**Key Concepts**

- Availability of an Azure reporting API through the Microsoft billing resource provider for cost review.
- Use of the Microsoft Cost Management Connector in Power BI Desktop to analyze costs.
- Microsoft Cost Management covers not only Azure but also Microsoft 365, Dynamics 365, and Power Platform costs.

**Definitions**

- **Azure Reporting API**: An API provided via the Microsoft billing resource provider that allows users to review and analyze costs at subscription or enterprise agreement levels.
- **Microsoft Cost Management Connector**: A Power BI Desktop connector that enables integration and visualization of cost data from Microsoft Cost Management.

**Key Facts**

- The Azure reporting API can be used at both subscription and enterprise agreement levels.
- Microsoft Cost Management includes costs across multiple Microsoft services, not limited to Azure.
- Power BI Desktop supports a dedicated connector for Microsoft Cost Management data.

**Examples**

- None mentioned explicitly within this timestamp range.

**Key Takeaways 🎯**

- Utilize the Azure reporting API to programmatically access and review cost data.
- Leverage the Microsoft Cost Management Connector in Power BI for detailed cost analysis and reporting.
- Remember that Microsoft Cost Management provides a unified view of costs across Azure, Microsoft 365, Dynamics 365, and Power Platform, enabling comprehensive cost tracking.

---

## Pricing calculator

**Timestamp**: 01:45:15 – 01:46:36

**Key Concepts**

- Use of a pricing calculator to estimate Azure costs before deployment.
- Planning and forecasting costs based on resource usage and configuration.
- Considering multiple service types (VMs, storage, databases, AI services) in cost estimation.
- Importance of understanding cost dimensions and usage patterns to avoid unexpected bills.
- Cost optimization mindset when architecting solutions.

**Definitions**

- **Pricing calculator**: A tool that allows users to estimate the cost of Azure services by selecting resource types, quantities, and usage durations.

**Key Facts**

- The pricing calculator can be used to estimate costs for various Azure resources such as virtual machines, storage, databases, and AI services.
- Users can specify parameters like number of VMs, type of VM, and running hours to calculate estimated costs.
- Microsoft Cost Management covers not only Azure but also M365, Dynamics 365, and Power Platform costs.

**Examples**

- Selecting a virtual machine in the pricing calculator and specifying how many hours it will run and how many instances are needed to estimate cost.
- Considering how a service that allows user uploads might impact costs if usage grows unexpectedly.

**Key Takeaways 🎯**

- Always plan and estimate your Azure costs using the pricing calculator before deploying resources.
- Understand all cost dimensions related to your solution, including indirect usage patterns that might increase costs.
- Avoid surprises by thinking through how users and services interact with your resources.
- Cost optimization should be an ongoing process, not just a one-time calculation.
- Use the pricing calculator as a key tool in budgeting and managing cloud expenses effectively.

---

## Optimizing costs

**Timestamp**: 01:46:36 – 01:47:27

**Key Concepts**

- Cost optimization requires understanding all dimensions of how a resource is used and how costs can accumulate.
- Right-sizing resources and choosing appropriate service types and shapes is essential.
- Use autoscaling to adjust resource instances based on workload demand.
- Leverage serverless computing to only pay for work triggered by events.
- Shut down or delete unused resources, especially in testing environments, and recreate them via infrastructure as code when needed.
- Take advantage of free tiers and offerings where possible.
- Azure Reservations offer discounts for committing to specific resources over one or three years.

**Definitions**

- **Azure Reservations**: A pricing mechanism that provides discounts when you commit to using a specific Azure resource (e.g., a VM family in a specific region) for a one- or three-year term.

**Key Facts**

- Discounts from Azure Reservations vary depending on:
  - The resource type
  - The commitment term length (1 or 3 years)
  - The exact resource specification (e.g., VM family and region)
- Cost optimization is a very specific operation requiring detailed knowledge of resource usage and billing dimensions.

**Examples**

- Using autoscale to dynamically change the number of VM instances based on workload.
- Using serverless functions to only execute code when triggered by an event.
- Deleting test environments and recreating them with infrastructure as code to avoid unnecessary charges.

**Key Takeaways 🎯**

- Always consider how users or processes might drive unexpected costs (e.g., users uploading excessive data).
- Optimize not just the architecture but also the interaction patterns that affect costs.
- Use automation and infrastructure as code to manage resources efficiently.
- Commit to Azure Reservations for predictable workloads to gain cost savings.
- Cost optimization is ongoing and requires attention to detail and proactive management.

---

## Azure reservations

**Timestamp**: 01:47:27 – 01:50:28

**Key Concepts**

- Azure Reservations provide discounted pricing for committing to specific Azure resources over a fixed term.
- Reservations are very specific to resource type, family, region, and term length.
- Billing applies discounts hourly based on reserved resources, regardless of actual usage.
- Reserved instances can be scoped across enterprise agreements, management groups, or subscriptions.
- Azure Compute Savings Plan is a more flexible alternative focused on compute services.

**Definitions**

- **Azure Reservations**: A billing mechanism where you commit to using a specific resource (e.g., VM family in a region) for one or three years in exchange for a discount.
- **Reserved Instances**: Specific reserved compute resources that you pay for regardless of usage; can be traded in (as of recording, trade-in extended indefinitely).
- **Azure Compute Savings Plan**: A flexible savings option covering compute services (VMs, dedicated hosts, etc.) that applies discounts across scopes without being as specific as reservations.

**Key Facts**

- Reservations require specifying the exact resource family (e.g., Dv5, Ev5), region (e.g., West US3, East US2), and term (1 or 3 years).
- Discounts vary depending on resource type and term length.
- Billing engine applies discounts every hour.
- Payment is required for the reserved amount even if the resource is underutilized or unused.
- Reserved instances can be traded in, with Microsoft extending this ability indefinitely as of the recording.
- Reservations can be scoped to enterprise agreements, management groups, or subscriptions.
- Azure Compute Savings Plan covers all compute services and is more flexible than reservations.

**Examples**

- Creating a reservation for Dv5 VMs in West US3 for one year.
- Creating a separate reservation for Ev5 VMs in East US2 for three years.
- Creating a reservation for storage in a specific region for a certain amount and duration.

**Key Takeaways 🎯**

- Azure Reservations offer significant discounts but require precise commitment to specific resource types, regions, and terms.
- You pay for reserved resources whether you use them or not, so accurate forecasting is critical.
- Reserved instances can be traded in, providing some flexibility if needs change.
- Azure Compute Savings Plan offers a more flexible alternative focused on compute workloads.
- Understanding your resource usage patterns and requirements is essential to maximize savings with reservations.

---

## Azure Compute Savings Plan

**Timestamp**: 01:50:28 – 01:54:12

**Key Concepts**

- Azure Compute Savings Plan offers flexible discounts on compute services.
- It applies across multiple compute resource types and scopes (enterprise agreement, management group, subscription).
- Discounts are less than Azure Reservations but provide greater flexibility.
- Savings Plan discounts apply as a billing mechanism across any eligible compute usage in any region.
- Azure Reservations take precedence over Savings Plan discounts when both exist.
- Azure Hybrid Benefit is separate and relates to using existing OS or SQL licenses.

**Definitions**

- **Azure Compute Savings Plan**: A flexible discount plan that applies to a broad range of Azure compute services (VMs, container instances, dedicated hosts, etc.) across any region, for a commitment of one or three years.
- **Azure Reservation**: A more specific, less flexible discount option for particular VM SKUs or resources, offering higher discounts.
- **Azure Hybrid Benefit**: A licensing benefit that allows customers to apply their existing OS or SQL licenses to Azure resources to reduce costs.

**Key Facts**

- Savings Plan covers: VMs, dedicated hosts, Azure Container Instances, Azure Container Apps, Azure Spring Apps Enterprise (deprecated soon), Functions Premium Plan, App Service Premium V3, and App Service Isolated V2.
- Exclusions: Bare metal VMs and AV1 VMs are not included.
- Duration options: 1 year or 3 years.
- Discounts comparison (example D2V5 VM SKU):
  - Azure Reservation: 58% (1 year), 63% (3 years)
  - Savings Plan: 31% (1 year), 54% (3 years)
- Azure Container Instances discount under Savings Plan: 27% (1 year), 52% (3 years)
- Savings Plan discounts apply regardless of region.
- When both Azure Reservation and Savings Plan exist, Reservation discounts apply first.

**Examples**

- Changing VM SKU to D2V5 to compare discounts between Azure Reservation and Savings Plan.
- Azure Container Instances not available under Azure Reservations but covered under Savings Plan with notable discounts.

**Key Takeaways 🎯**

- Azure Compute Savings Plan is ideal for users needing flexibility across various compute resources and regions.
- While the discount is generally lower than Azure Reservations, the Savings Plan covers a broader range of compute services.
- Savings Plans simplify billing by applying discounts automatically across eligible compute usage.
- Azure Reservations should be used when you have predictable, specific VM usage for maximum savings.
- Azure Hybrid Benefit helps reduce costs further by leveraging existing licenses, separate from Savings Plan discounts.

---

## Azure Hybrid Benefit

**Timestamp**: 01:54:12 – 01:55:11

**Key Concepts**

- Azure Hybrid Benefit allows customers to use their existing OS or SQL licenses on Azure resources.
- It helps reduce costs by not charging separately for licenses when using eligible resources.
- The benefit applies primarily to Windows OS and SQL licenses, with some applicability to Linux.
- Azure Hybrid Benefit affects billing by separating compute charges from license charges.

**Definitions**

- **Azure Hybrid Benefit**: A licensing benefit that lets customers apply their existing on-premises OS or SQL licenses to Azure virtual machines and other resources, reducing the cost by not billing separately for those licenses.

**Key Facts**

- When Azure Hybrid Benefit is applied, billing only includes the raw compute cost, not the OS or SQL license fees.
- The VM charge typically includes two components: compute cost and OS license cost.
- Azure Hybrid Benefit removes the license charge component from the billing.
- This benefit does not guarantee resource capacity availability despite the term "reservation" used in other Azure offerings.

**Examples**

- A Windows VM charge normally includes compute plus OS license fees.
- With Azure Hybrid Benefit enabled, the license fee is waived, and only compute charges apply.

**Key Takeaways 🎯**

- Use Azure Hybrid Benefit to leverage existing licenses and reduce Azure costs.
- It is important to understand that Azure Hybrid Benefit only affects licensing costs, not compute capacity or availability.
- The term "reservation" in Azure does not guarantee capacity; it only commits you to a discounted spend.
- Always combine licensing benefits like Azure Hybrid Benefit with other savings options (e.g., reservations, savings plans) for maximum cost efficiency.

---

## On-demand capacity reservations

**Timestamp**: 01:55:11 – 01:58:18

**Key Concepts**

- Azure Reservations vs On-demand Capacity Reservations are different in purpose and guarantees.
- Azure Reservations commit to spending on specific SKUs and regions but do **not** guarantee capacity availability.
- On-demand capacity reservations provide an SLA-backed guarantee of capacity availability for a specific SKU in a specific region or availability zone (AZ).
- Flexibility in region and SKU choice increases the chances of resource creation during high demand ("rainy day") scenarios.
- On-demand capacity reservations require immediate payment upon creation and allow creating VMs into the reserved capacity.
- Capacity reservations can be deleted anytime but may not be recreated if capacity is unavailable.
- Combining Azure Reservations with on-demand capacity reservations can lock in both cost savings and capacity availability.

**Definitions**

- **Azure Reservation**: A commitment to spend a certain amount of money on a specific SKU in a specific region for a discount, without guaranteeing capacity availability.
- **On-demand Capacity Reservation**: A paid reservation that guarantees capacity availability with an SLA for a specific SKU in a specific region or availability zone, allowing guaranteed provisioning of resources.

**Key Facts**

- Azure Reservations do **not** reserve actual capacity; capacity failures can still occur during high demand.
- On-demand capacity reservations start billing immediately upon creation.
- You can create and delete capacity reservations at any time.
- If capacity is unavailable, creating a new capacity reservation will fail.
- Combining Azure Reservations with capacity reservations is generally safe and beneficial.

**Examples**

- Hotel room analogy:  
  - Being flexible about hotel or location increases chances of availability.  
  - Needing a specific hotel, floor, and features reduces availability chances.  
  - Similarly, flexibility in region and SKU improves resource creation success.

**Key Takeaways 🎯**

- Do not confuse Azure Reservations with capacity reservations; only the latter guarantees capacity.
- Use on-demand capacity reservations when you absolutely must have guaranteed capacity with SLA backing.
- Always consider flexibility in region and SKU to reduce capacity failures.
- On-demand capacity reservations complement Azure Reservations by locking in capacity as well as cost.
- Understand the billing implications: capacity reservations bill immediately upon creation.
- Plan carefully to avoid capacity reservation failures and unnecessary costs.

---

## Deployment stacks

**Timestamp**: 01:58:18 – 02:02:48

**Key Concepts**

- Deployment stacks are a modern replacement for Azure blueprints.
- They serve as lifecycle boundaries for a collection of resources.
- Deployment stacks can span multiple resource groups, subscriptions, or management groups.
- They enable coordinated creation, update, and deletion of grouped resources.
- Deployment stacks support deny assignments to protect resources from modification or deletion.
- Deployment stacks use the same ARM/Bicep templates but are deployed differently via `az stack` commands.
- The name of the deployment stack is important as it identifies the lifecycle unit.
- Deny settings in deployment stacks are more flexible and granular than in blueprints.
- Deployment stacks allow exclusion of certain principals or actions from deny policies.
- Deployment stacks improve resource management and cleanup capabilities.

**Definitions**

- **Deployment stack**: A collection of Azure resources managed together as a lifecycle unit, which can be deployed, updated, or deleted collectively, potentially spanning multiple resource groups or subscriptions.
- **Deny assignments**: Policies applied to deployment stacks that prevent certain actions (like modify or delete) on the resources within the stack, providing protection and control over resource management.

**Key Facts**

- Blueprints are being deprecated and replaced by deployment stacks.
- Blueprints combined resource groups, RBAC, ARM templates, and policies but had limited deny assignment capabilities.
- Deployment stacks allow resources to be deployed across multiple resource groups, subscriptions, or management groups depending on the deployment scope.
- Deployment stacks are deployed using `az stack` commands instead of the usual `az deployment` commands.
- Deny assignments in deployment stacks can exclude specific principals (e.g., break glass accounts) or certain types of actions.
- Deny settings can cascade to child resources with fine-grained control.
- Using deployment stacks has no downside compared to regular deployments.
- The deployment stack name is significant and must be chosen carefully as it represents the lifecycle boundary.

**Examples**

- Deploying a deployment stack scoped to a resource group requires all resources to be children of that resource group.
- Deploying a deployment stack at the subscription level allows resources to be spread across multiple resource groups within that subscription.
- Deploying a deployment stack at the management group level allows resources to be in any resource group in any subscription under that management group.
- Using `az stack group` command in VS Code to deploy a stack instead of `az deployment group`.

**Key Takeaways 🎯**

- Deployment stacks provide a richer, more flexible, and modern way to manage grouped Azure resources compared to blueprints.
- They enable lifecycle management across multiple scopes (resource groups, subscriptions, management groups).
- Deny assignments in deployment stacks offer advanced protection features beyond what blueprints provided.
- Always use deployment stacks for grouped resource deployments to benefit from lifecycle management and resource protection.
- The deployment stack name is critical and should be carefully chosen as it identifies the stack.
- Deployment stacks use the same ARM/Bicep templates, so existing templates can be reused with minimal changes.
- Switching to deployment stacks is recommended as blueprints are deprecated and deployment stacks have no downsides.

---

## Resource graph

**Timestamp**: 02:02:48 – 02:06:11

**Key Concepts**

- Azure Resource Graph enables efficient querying of Azure resources at scale.
- It queries the control plane data using Kusto Query Language (KQL), the same language used in Log Analytics.
- Resource Graph is read-only; it cannot make changes to resources.
- It provides a high-performance, separate database optimized for querying resource information.
- There are query rate limits but they are generous enough for most use cases.
- Resource Graph Explorer in the Azure portal allows running and testing queries interactively.
- Resource configuration changes tracking is built on Resource Graph, enabling change analysis across the tenant.

**Definitions**

- **Azure Resource Graph**: A service that allows fast and efficient querying of Azure resource metadata and configurations at scale using KQL.
- **Kusto Query Language (KQL)**: A query language used for querying large datasets, employed by Azure Resource Graph and Log Analytics.
- **Resource Configuration Changes**: A feature powered by Resource Graph that tracks modifications to resource properties, including who made the change and how.

**Key Facts**

- ARM API has limits of approximately 12,000 reads per hour; Resource Graph is designed to be faster and more scalable.
- Resource Graph query limits: 15 requests every 5 seconds per user.
- Queries return only resources the user has access to.
- Resource Graph queries can be run via Azure portal, PowerShell, CLI, or Resource Graph Explorer.
- Resource configuration changes provide tenant-wide querying with filtering by change actor, client used, and operation called.

**Examples**

- Running a KQL query to summarize and count resources by subscription, formatted as a table.
- Using Resource Graph Explorer to list all public IP addresses with the provided KQL query.
- Viewing quota remaining and reset time after running queries to monitor usage limits.

**Key Takeaways 🎯**

- Use Azure Resource Graph for fast, scalable, and flexible querying of resource metadata instead of relying solely on ARM API calls.
- Resource Graph is read-only and ideal for inventory, auditing, and configuration analysis.
- The query limits are sufficient for most operational needs and reset frequently.
- Resource Graph Explorer in the portal is a convenient tool for building and testing queries.
- Resource configuration changes feature enhances visibility into who changed what, when, and how across the tenant.
- For understanding resource configurations and changes, Resource Graph is the recommended tool.

---

## Resource configuration change

**Timestamp**: 02:06:11 – 02:08:15

**Key Concepts**

- Resource Graph as a powerful tool for querying resource configurations.
- Resource configuration changes capability built on Resource Graph.
- Change analysis solution for tracking modifications in environment resources.
- Tenant-wide querying and detailed filtering of configuration changes.
- Visibility into change actor, client used, and operation performed.
- Change feed enables investigation of what changed and when.
- Default enablement on ARM control plane; can be enabled on other resources like app service plans.
- Retention of change data for 14 days by default.
- Possibility to export change data to Log Analytics or other stores for longer retention or advanced analysis.

**Definitions**

- **Resource Graph**: A service that allows querying and exploration of Azure resource configurations across subscriptions.
- **Resource configuration changes capability**: A feature powered by Resource Graph that tracks and analyzes changes to resource properties over time.
- **Change actor**: The identity or user who made the change to a resource.
- **Change feed**: A log or stream of recorded changes to resource configurations, showing before and after states.

**Key Facts**

- Change analysis provides tenant-wide querying with enhanced filtering.
- Change details include who changed it, which client was used (e.g., Azure portal), and the operation called.
- Change analysis preview shows before and after states of resource property changes.
- Enabled by default on the ARM control plane.
- Can be enabled on other resource types such as app service plans.
- Change data is retained for 14 days at the time of recording.
- For longer retention or more complex workflows, exporting to Log Analytics or using Logic Apps/functions is recommended.

**Examples**

- A storage account tag was changed via the Azure portal.
- The change analysis showed creation of a new tag and updates to creation time.
- User can select changes to view detailed before and after property values.

**Key Takeaways 🎯**

- Use Resource Graph for querying resource configurations and understanding environment state.
- Leverage the resource configuration changes capability to track and analyze what has changed in your Azure resources.
- Change analysis helps troubleshoot issues by showing exactly what changed, when, and by whom.
- The feature is enabled by default on ARM control plane and supports tenant-wide queries.
- Retention is limited to 14 days, so consider exporting data for longer-term analysis.
- This capability enhances observability and operational insight into resource modifications.

---

## Azure Advisor

**Timestamp**: 02:08:15 – 02:10:45

**Key Concepts**

- Azure Advisor provides personalized recommendations to optimize Azure resources.
- It continuously evaluates your environment for cost, security, reliability, operational excellence, and performance improvements.
- Advisor score reflects how well your environment aligns with best practices.
- Alerts and notifications can be configured based on recommendation categories and impact levels.
- Summarized recommendation digests can be scheduled and emailed regularly.
- Advisor supports actionable assessments that guide through optimization steps.

**Definitions**

- **Azure Advisor**: A service that analyzes your Azure environment and provides recommendations to optimize cost, security, reliability, operational excellence, and performance.
- **Advisor Score**: A metric indicating how optimized your Azure environment is based on core best practice areas.
- **Action Group**: A collection of notification preferences and actions (e.g., email, ITSM ticket creation) triggered by alerts.

**Key Facts**

- Azure Advisor recommendations cover multiple categories: cost, security, reliability, operational excellence, and performance.
- Advisor score example given: 88% based on core optimization areas.
- Alerts can be set to trigger based on specific categories and impact levels.
- Recommendations include suggestions like enabling autoscale for idle VMs or changing disk types.
- Summarization digests can be created to receive periodic email summaries of recommendations.
- Advisor assessments can ask questions and provide actionable steps for improvements.

**Examples**

- Notification alert for security recommendations triggering an action group (e.g., email or ITSM ticket).
- Recommendation to enable autoscale on idle virtual machines.
- Suggestion to use a different disk type for better performance or cost efficiency.
- Creating a recommendation digest to receive summary emails on a set frequency.

**Key Takeaways 🎯**

- Regularly review Azure Advisor (weekly recommended) to stay updated on optimization opportunities.
- Use the advisor score as a quick health check of your environment’s optimization status.
- Configure alerts to proactively respond to critical recommendations, especially in security.
- Leverage recommendation digests to keep stakeholders informed without manual checks.
- Utilize assessments within Advisor for guided, actionable improvement steps.
- Azure Advisor is a powerful tool to help maintain best practices and cost efficiency in Azure environments.

---

## Great resources

**Timestamp**: 02:10:45 – 02:11:38

**Key Concepts**

- Governance documentation provides guidance for planning and best practices.
- Landing zones help prepare environments for easy adoption, covering identity, governance, security, monitoring, and networking.
- The Cloud Adoption Framework and Well-Architected Framework guide Azure usage and workload configuration.
- The Azure Architecture Center offers architectural examples aligned with best practices.
- Advisor tool offers actionable recommendations and assessments to improve environment health.

**Definitions**

- **Landing Zones**: Pre-configured environments designed to simplify and standardize cloud adoption by addressing identity, governance, security, monitoring, and networking needs.
- **Cloud Adoption Framework**: A set of guidelines and best practices for adopting Azure cloud services effectively.
- **Well-Architected Framework**: A framework that helps evaluate and improve the architecture of workloads on Azure.
- **Azure Architecture Center**: A resource hub providing architectural examples and best practices for Azure solutions.
- **Advisor**: An Azure tool that provides recommendations, assessments, and actionable steps to optimize cloud environments.

**Key Facts**

- Governance docs help with planning and implementing best practices.
- Landing zones cover multiple critical areas: identity, governance, HR, disaster recovery (DR), security, monitoring, and networking.
- The Well-Architected Framework includes a review process for architecture.
- Videos are available to help understand these resources better.

**Examples**

- None specifically detailed in this segment, but references to governance docs, landing zones, Cloud Adoption Framework, Well-Architected Framework, and Azure Architecture Center as resource examples.

**Key Takeaways 🎯**

- Spend time exploring Azure Advisor for actionable recommendations and assessments.
- Utilize governance documentation and landing zones to establish a strong foundation for cloud adoption.
- Leverage the Cloud Adoption Framework and Well-Architected Framework to guide Azure workload design and configuration.
- Use the Azure Architecture Center for practical architectural examples.
- These resources collectively support best practices and successful Azure governance and adoption.

---

## Close

**Timestamp**: 02:11:38 – unknown

**Key Concepts**

- Importance of security, monitoring, and networking in governance
- Utilizing frameworks to establish best practices in cloud adoption
- The role of the Cloud Adoption Framework and Well-Architected Framework in Azure architecture
- Leveraging Azure Architecture Center as a resource for architectural examples

**Definitions**

- **Cloud Adoption Framework**: A set of guidelines and best practices to help organizations adopt cloud technologies effectively.
- **Well-Architected Framework**: A framework that provides a structured approach to evaluate and improve cloud workloads based on best practices.

**Key Facts**

- The Well-Architected Framework includes a review process for workloads.
- Azure Architecture Center offers numerous examples covering different architectural scenarios.
- Supporting videos are available to deepen understanding of these frameworks.

**Examples**

- None mentioned explicitly, but references to examples available in the Azure Architecture Center.

**Key Takeaways 🎯**

- Governance in cloud environments is strengthened through security, monitoring, and networking.
- Frameworks like the Cloud Adoption Framework and Well-Architected Framework are essential tools for designing and managing Azure workloads.
- Utilize the Azure Architecture Center and related videos as valuable learning resources.
- This marks the conclusion of the governance module, encouraging continued learning through upcoming content.
