# AZ-104 Administrator Associate Study Cram v2 - Exam Notes

**Video:** [https://www.youtube.com/watch?v=0Knf9nub4-k](https://www.youtube.com/watch?v=0Knf9nub4-k)
**Published:** 2024-02-12

*Generated on 2026-01-28 04:47*

---

## Table of Contents

- [Introduction](#introduction)
- [Materials to prepare](#materials-to-prepare)
- [Entra ID](#entra-id)
- [ADDS to Entra Sync](#adds-to-entra-sync)
- [Tenant](#tenant)
- [Branding](#branding)
- [Users](#users)
- [Groups](#groups)
- [Devices](#devices)
- [Licenses](#licenses)
- [SSPR](#sspr)
- [Roles](#roles)
- [Clouds and regions](#clouds-and-regions)
- [Subscriptions and Management Groups](#subscriptions-and-management-groups)
- [Cost analysis and budgets](#cost-analysis-and-budgets)
- [Resource Groups](#resource-groups)
- [Cost saving mechanisms](#cost-saving-mechanisms)
- [Tags](#tags)
- [Azure Policy](#azure-policy)
- [RBAC](#rbac)
- [Resource locking](#resource-locking)
- [Networking](#networking)
- [Virtual network](#virtual-network)
- [Peering](#peering)
- [Azure Virtual Network Manager](#azure-virtual-network-manager)
- [Network Security Group](#network-security-group)
- [Azure Firewall](#azure-firewall)
- [Azure DNS](#azure-dns)
- [Azure Private DNS](#azure-private-dns)
- [Connectivity](#connectivity)
- [S2S VPN](#s2s-vpn)
- [ExpressRoute](#expressroute)
- [Azure Virtual WAN](#azure-virtual-wan)
- [User Defined Routes](#user-defined-routes)
- [Service endpoints](#service-endpoints)
- [Private endpoints](#private-endpoints)
- [Azure Bastion](#azure-bastion)
- [Load balancing](#load-balancing)
- [Azure Load Balancer](#azure-load-balancer)
- [Azure App Gateway](#azure-app-gateway)
- [Azure Traffic Manager](#azure-traffic-manager)
- [Azure Cross Region Load Balancer](#azure-cross-region-load-balancer)
- [Azure Front Door](#azure-front-door)
- [Storage accounts](#storage-accounts)
- [Storage tools](#storage-tools)
- [Blob tiering](#blob-tiering)
- [Lifecycle management](#lifecycle-management)
- [Object replication](#object-replication)
- [Azure Files](#azure-files)
- [Access](#access)
- [Encryption](#encryption)
- [Managed disks](#managed-disks)
- [Provisioning resources](#provisioning-resources)
- [Types of service](#types-of-service)
- [Virtual machines](#virtual-machines)
- [Availability Set and Zones](#availability-set-and-zones)
- [VMSS](#vmss)
- [Containers](#containers)
- [AKS](#aks)
- [App Service Plan](#app-service-plan)
- [Monitoring](#monitoring)
- [Alerting](#alerting)
- [Log Analytics Workspace](#log-analytics-workspace)
- [Network watcher](#network-watcher)
- [Summary and close](#summary-and-close)

## Introduction

**Timestamp**: 00:00:00 – 00:00:44

**Key Concepts**  
- Updates have been made to the content with some things removed and others added.  
- The description includes links to different sections of the knowledge base for easy navigation.  
- Importance of actively engaging with the study materials and activities.  

**Definitions**  
- None mentioned.

**Key Facts**  
- The study guide breaks down all the areas that need to be studied.  
- The presenter focuses primarily on theory rather than hands-on demonstrations due to the volume of material.  

**Examples**  
- Reference to the study guide as a tool to understand and tick off different study areas.  
- Encouragement to go through learn modules and self-paced preparation options.  

**Key Takeaways 🎯**  
- Use the description links to jump around different sections as needed.  
- Actively complete the activities and review the study guide thoroughly.  
- Hands-on practice is recommended but not covered extensively in this session; focus here is on theory.  
- Utilize available learn modules and self-paced resources to prepare effectively.  

---

## Materials to prepare

**Timestamp**: 00:00:44 – 00:02:20

**Key Concepts**  
- Importance of actively engaging with study materials and activities  
- Use of the official study guide to understand exam topics  
- Hands-on practice is critical for exam preparation  
- Microsoft Learn modules provide comprehensive self-paced learning  
- Labs and applied skills environments offer practical experience  
- Preparing for the administrative exam requires familiarity with multiple tools (portal, CLI, templates)

**Definitions**  
- **Study Guide**: A resource that breaks down all the different areas to study for the exam.  
- **Self-Paced Learning Modules**: Online learning content provided by Microsoft that covers all necessary knowledge for the exam.  
- **Applied Skills Environment**: A sandbox environment where learners can try out various technologies hands-on.

**Key Facts**  
- The exam preparation should include both theory and practical experience.  
- Microsoft Learn modules include labs for hands-on practice.  
- The exam tests knowledge on how to perform various administrative tasks using different methods (portal, CLI, templates).

**Examples**  
- Trying out tasks from the Azure portal  
- Using the CLI (Command Line Interface) to perform tasks  
- Applying templates for deployment or configuration

**Key Takeaways 🎯**  
- Do not just read theory; actively complete activities and labs.  
- Use the study guide to ensure all topics are covered.  
- Leverage Microsoft Learn’s self-paced modules and labs for hands-on experience.  
- Practice using different tools and methods to perform administrative tasks.  
- Being well-prepared involves both knowledge and practical skills.  

---

## Entra ID

**Timestamp**: 00:02:20 – 00:05:01

**Key Concepts**  
- Entra ID is the new name for what was formerly known as Azure AD.  
- Entra ID is Microsoft’s cloud-based identity provider.  
- It uses modern internet protocols for authentication and authorization, such as OAuth 2, OpenID Connect, SAML, and WS-Fed.  
- Communication with Entra ID happens over HTTPS (port 443) using TLS encryption, making it internet-friendly without requiring multiple network ports.  
- Entra ID contrasts with traditional on-premises Active Directory Domain Services (AD DS), which uses protocols like Kerberos, NTLM, and LDAP and requires multiple ports on private networks.  
- Interaction with Entra ID is primarily done through Microsoft Graph API, which uses REST-based calls over HTTPS.  
- Entra ID has a flat structure, unlike AD DS which has organizational units; however, Entra ID supports administrative units for granular permission delegation.  
- Common practice involves syncing on-premises AD DS to Entra ID, with AD DS as the source of truth.  

**Definitions**  
- **Entra ID**: Microsoft’s cloud-based identity provider, formerly known as Azure AD, designed for internet-based authentication and authorization.  
- **Microsoft Graph**: The standard REST API used to interact with Entra ID and other Microsoft 365 services.  
- **Administrative Units**: A feature in Entra ID that allows delegation of permissions at a more granular level, compensating for the lack of organizational units.  

**Key Facts**  
- Entra ID communicates using internet protocols: OAuth 2, OpenID Connect, SAML, WS-Fed.  
- All communication is secured via HTTPS (port 443) and TLS encryption.  
- On-premises AD DS uses Kerberos, NTLM, LDAP, and requires multiple network ports.  
- Entra ID is primarily flat in structure, unlike the hierarchical structure of AD DS.  
- Sync from AD DS to Entra ID is one-way: AD DS is the source of truth.  

**Examples**  
- None specifically mentioned beyond protocol and API usage examples.  

**Key Takeaways 🎯**  
- Understand that Entra ID is the cloud evolution of Azure AD and serves as a modern identity provider optimized for internet protocols.  
- Remember the key protocols used for authentication and authorization in Entra ID (OAuth 2, OpenID Connect, SAML).  
- Know that Entra ID uses Microsoft Graph API for management and interaction, which is REST-based over HTTPS.  
- Recognize the structural difference: Entra ID is flat but supports administrative units for permission delegation.  
- Be aware that syncing from on-premises AD DS to Entra ID is common, with AD DS remaining the authoritative source.

---

## ADDS to Entra Sync

**Timestamp**: 00:05:01 – 00:07:59

**Key Concepts**  
- Replication flow is one-way: from Active Directory Domain Services (AD DS) to Entra ID (Azure AD).  
- Two main technologies for syncing AD DS to Entra ID: Entra Connect Sync and Entra Connect Cloud Sync.  
- Entra Connect Sync runs on-premises on a Windows Server instance.  
- Entra Connect Cloud Sync runs in the cloud with lightweight agents on domain controllers.  
- Once identities are synced to Entra ID, applications trust Entra ID for authentication and authorization.  
- Entra ID tenant acts as the organizational instance containing users, groups, devices, applications, and policies.  
- Entra ID supports authentication for Microsoft services (Azure, Microsoft 365) and third-party SaaS applications.  
- Entra ID can integrate with secure service edge solutions, enabling control over internet access and on-premises TCP/UDP applications via Entra Private Access.

**Definitions**  
- **Entra Connect Sync**: An on-premises synchronization engine running on Windows Server that syncs identities from AD DS to Entra ID.  
- **Entra Connect Cloud Sync**: A cloud-based synchronization service where the engine runs in the cloud, using lightweight agents installed on domain controllers to communicate.  
- **Source of Truth**: AD DS is considered the authoritative source for identity information, which is then replicated to Entra ID.  
- **Tenant**: A dedicated instance of Entra ID for an organization, containing its users, groups, devices, applications, and policies.

**Key Facts**  
- Sync direction is always from AD DS to Entra ID, never the reverse.  
- Entra Connect Cloud Sync uses lightweight agents on domain controllers but the main engine runs in the cloud.  
- Entra Connect Sync engine runs as an application on a Windows Server instance on-premises.  
- Entra ID tenants can be named, e.g., "SavileTech.net" as an example tenant name.

**Examples**  
- Example tenant name: SavileTech.net  
- Applications trusting Entra ID for authentication include Azure, Microsoft 365, and numerous third-party SaaS apps.  
- Entra Private Access can control access to any TCP or UDP on-premises application and internet sites through secure service edge integration.

**Key Takeaways 🎯**  
- Always remember the sync flow direction: AD DS → Entra ID.  
- Choose between Entra Connect Sync (on-premises) and Entra Connect Cloud Sync (cloud-based) depending on infrastructure needs.  
- Entra ID acts as a central identity provider trusted by Microsoft and third-party applications.  
- Integration with secure service edge solutions extends identity-based access control beyond cloud apps to internet and on-premises resources.  
- Your organization’s Entra ID tenant is the core container for identity and access management policies.

---

## Tenant

**Timestamp**: 00:07:59 – 00:10:21

**Key Concepts**  
- An Entra tenant represents an organization’s dedicated instance containing users, groups, devices, applications, and policies.  
- Tenants are global instances, independent of Azure subscriptions.  
- Custom domains can be added and verified to a tenant, replacing the default onmicrosoft.com domain.  
- Tenants support company branding to customize user experience during sign-in and access.

**Definitions**  
- **Tenant**: A specific organizational instance in Entra ID that holds users, groups, devices, applications, and conditional access policies.  
- **Custom Domain**: A verified domain name added to a tenant to replace the default onmicrosoft.com domain for user identities and branding.

**Key Facts**  
- Default tenant domain format is `something.onmicrosoft.com`.  
- Custom domains require DNS verification by adding a record in the domain’s zone to prove ownership.  
- After verification, the custom domain can be set as the primary domain for the tenant.  
- Tenants do not reside within Azure subscriptions; subscriptions trust tenants but tenants are global and independent.  
- Company branding options include configuring backgrounds, images, and sign-in messages with formatting (bold, underline).

**Examples**  
- The speaker’s tenant example: `savilltech.net` as a custom domain added and set as the primary domain.  
- The default domain before adding custom domain is something like `something.onmicrosoft.com`.

**Key Takeaways 🎯**  
- Understand that a tenant is a global, organizational instance separate from Azure subscriptions.  
- Always verify custom domains via DNS to use them within a tenant.  
- Custom domains improve identity management and branding within Entra ID.  
- Company branding allows tailoring the user sign-in experience for better organizational identity.

---

## Branding

**Timestamp**: 00:10:21 – 00:11:08

**Key Concepts**  
- Company branding customization within an Entra tenant  
- User experience interface tweaks related to branding  
- Customizable elements include backgrounds, background images, and logon messages  
- Use of special characters in messages to apply formatting (e.g., bold, underline)  

**Definitions**  
- **Company Branding**: The ability to customize the user interface and experience within an Entra tenant to reflect organizational identity.  

**Key Facts**  
- Branding customization is done within the tenant, not at the subscription level  
- Logon messages can include special characters to format text (bold, underline)  
- Branding affects user experience during sign-in and related interactions  

**Examples**  
- Configuring different background images for the sign-in interface  
- Setting logon messages with formatted text to enhance communication during user sign-in  

**Key Takeaways 🎯**  
- Branding customization is tenant-specific and allows organizations to tailor the sign-in experience  
- Enhancing user experience through visual and textual customization can reinforce company identity  
- Understanding that branding applies at the tenant level helps clarify management scope and capabilities  

---

## Users

**Timestamp**: 00:11:08 – 00:15:51

**Key Concepts**  
- User accounts within a tenant can be cloud-native or synchronized from on-premises Active Directory (hybrid).  
- External users (guests) can come from other identity providers or tenants, enabling collaboration without creating separate accounts.  
- Different user types: native cloud accounts, synchronized hybrid accounts, and guest/external accounts.  
- External users can be assigned as guests or members, affecting policy application.  
- Primary identity of external users remains with their original identity provider (e.g., other Entra tenants, Microsoft accounts, Google, Facebook, SAML).  
- Account provisioning can be done manually, via synchronization, or through automated provisioning endpoints (e.g., HR systems, APIs).  
- Bulk user operations are supported for creation and invitation, using CSV templates or scripts.  
- Groups are used to manage permissions and licenses more efficiently than assigning them individually to users.

**Definitions**  
- **Cloud Account**: A user account created directly in the cloud tenant.  
- **Hybrid Account**: A user account created in on-premises Active Directory and synchronized to the cloud tenant.  
- **Guest User**: An external user invited from another identity provider or tenant, who accesses resources without having a native account in the tenant.  
- **Member User**: An external user who is assigned as a member in the tenant, which can affect policy application.  
- **Provisioning Endpoint**: A system or API that automates the creation and management of user accounts, potentially integrating with HR systems or Active Directory.

**Key Facts**  
- External users can authenticate via various identity providers including other Entra tenants, Microsoft accounts, Google, Facebook, SAML, or via one-time email codes.  
- Provisioning can be integrated with HR systems or other external sources, which may create accounts in Active Directory first and then replicate to Entra.  
- Bulk user creation and invitation are supported through CSV templates and scripting.  
- Managing permissions via groups is more scalable than assigning roles or licenses to individual users.

**Examples**  
- A guest user invited from a different Entra tenant.  
- Guest users authenticated via Google, Facebook, Microsoft accounts, or SAML providers.  
- Provisioning accounts from an HR system through Entra provisioning endpoints.  
- Bulk creating users by uploading a CSV template in the portal.

**Key Takeaways 🎯**  
- Understand the distinction between cloud-native, hybrid, and guest user accounts.  
- External users improve collaboration without requiring separate credentials or accounts in your tenant.  
- Provisioning can be automated and integrated with existing systems like HR or Active Directory.  
- Bulk operations simplify large-scale user management tasks.  
- Use groups to efficiently manage permissions and licenses instead of assigning them individually.

---

## Groups

**Timestamp**: 00:15:51 – 00:18:57

**Key Concepts**  
- Managing permissions and licenses is more efficient when done via groups rather than individual users or devices.  
- Groups can contain users or devices and are used to assign roles, permissions, and licenses collectively.  
- There are two main types of groups: Security groups and Microsoft 365 groups.  
- Group membership can be assigned either directly (manual selection) or dynamically (based on rules).  
- Dynamic groups automatically update membership based on attributes like department, job title, or hire date.  
- Groups simplify administration by reducing the risk of leftover permissions or licenses on individual accounts.

**Definitions**  
- **Security Group**: A group type primarily used to assign roles and permissions within the system.  
- **Microsoft 365 Group**: A group type used for collaboration tools such as calendars, SharePoint, and other Microsoft 365 services.  
- **Dynamic Group**: A group whose membership is automatically managed based on defined rules and attributes (e.g., job title, department).  
- **Direct Membership**: Group membership assigned by explicitly selecting users or devices.

**Key Facts**  
- Dynamic membership rules can include conditions like display name contains certain text, department, job title, or hire date.  
- Example dynamic group: users hired within the last 30 days.  
- Another example: devices like iOS devices grouped dynamically.  
- Groups can be assigned licenses, roles, and applications, making them the preferred method for managing access and permissions.

**Examples**  
- A dynamic security group with a membership rule where the job title matches "hero*" (e.g., hero or heroine).  
- A dynamic group including users hired within the last 30 days.  
- A dynamic group for iOS devices.  
- A group named "Justice League" with dynamic membership rules.

**Key Takeaways 🎯**  
- Use groups to manage permissions and licenses instead of assigning them individually to users or devices.  
- Prefer dynamic groups when possible to automate membership management and reduce administrative overhead.  
- Understand the difference between Security groups (for roles/permissions) and Microsoft 365 groups (for collaboration).  
- Leverage attributes like job title, department, and hire date to define dynamic group membership rules.  
- Assign licenses, roles, and application access at the group level for streamlined management.

---

## Devices

**Timestamp**: 00:18:57 – 00:20:48

**Key Concepts**  
- Shift from traditional domain-joined devices to more flexible device management models.  
- Devices can be either **registered** or **joined** to the Entra tenant.  
- Registered devices are typically personal devices that need limited management and access to corporate resources.  
- Joined devices are corporate-owned and require full control and management.  
- Devices appear as objects within the Entra tenant and can be managed accordingly.  
- Licensing for Entra ID features can be assigned per user and vary by license level (e.g., P1, P2).  

**Definitions**  
- **Registered Device**: A device that is known to the Entra tenant, allowing some management and policy application, typically used for personal devices accessing corporate applications.  
- **Joined Device**: A corporate-owned device fully managed and controlled by the organization, allowing direct authentication with corporate accounts at login.  

**Key Facts**  
- Registered devices allow policy application and management via tools like Intune.  
- Joined devices enable users to log in directly with their corporate accounts (e.g., john@savilltech.net) at the device login screen.  
- Devices show up as objects in the Entra tenant for management purposes.  
- Entra licenses differ by functionality and can be bundled with Microsoft 365 plans (e.g., E5 includes P2 license, E3 includes P1 license).  
- VPN is no longer a strict requirement for device authentication or management due to direct interaction with the Entra tenant.  

**Examples**  
- Registering a personal device so it can access corporate applications while ensuring it is healthy and not jailbroken.  
- Joining a corporate device to allow full control and direct login with corporate credentials.  

**Key Takeaways 🎯**  
- Modern device management favors flexibility to support remote and mobile work scenarios without relying on VPNs.  
- Choosing between registering and joining devices depends on ownership and required control level.  
- Entra tenant integration allows centralized device visibility and management.  
- Licensing should be considered carefully as it impacts available features and management capabilities.

---

## Licenses

**Timestamp**: 00:20:48 – 00:23:27

**Key Concepts**  
- Entra licenses are assigned at a per-user level, not necessarily uniform across the tenant.  
- Different license tiers provide varying levels of functionality.  
- Entra ID licenses often come bundled with other Microsoft licenses (e.g., Microsoft 365 E3/E5).  
- There are three main license levels: base, P1, and P2, plus a governance add-on.  
- Governance add-on includes lifecycle workflows and enhanced audit/reporting capabilities.  
- P1 license includes key features like conditional access and self-service password reset with write-back for hybrid identity.  
- P2 license adds advanced features such as privileged identity management, core access reviews, and identity protection.  
- License assignment can be tailored based on user roles and needs (e.g., privileged users get P2, basic workers get P1).  
- Self-service password reset is an important feature, ideally moving towards passwordless solutions.  

**Definitions**  
- **Entra ID Licenses**: Licensing tiers for Microsoft Entra identity services that determine available features.  
- **P1 License**: Mid-tier license offering features like conditional access and self-service password reset with hybrid write-back.  
- **P2 License**: Premium license including advanced identity protection, privileged identity management, and access reviews.  
- **Governance Add-on**: An additional license component providing lifecycle workflows, entitlement management, certifications, and governance dashboards.  
- **Self-Service Password Reset (SSPR)**: Feature allowing users to reset their passwords themselves, with hybrid write-back capability in P1.  

**Key Facts**  
- Microsoft 365 E5 license includes Entra P2 license.  
- Microsoft 365 E3 license includes Entra P1 license.  
- Governance add-on is a newer addition that enhances lifecycle and governance capabilities.  
- Conditional Access is a P1 feature and critical for HR-driven provisioning.  
- Privileged Identity Management and Identity Protection are P2 features.  
- Self-service password reset with write-back requires P1 license.  

**Examples**  
- Privileged users assigned P2 licenses for privileged identity management and stronger identity protection.  
- Basic workers assigned P1 licenses for conditional access and self-service password reset.  
- Some users assigned governance add-on for lifecycle workflow capabilities.  

**Key Takeaways 🎯**  
- License assignment should be flexible and role-based, not one-size-fits-all.  
- P1 license is essential for conditional access and hybrid self-service password reset.  
- P2 license is necessary for advanced security and governance features.  
- Governance add-on extends lifecycle and audit capabilities beyond P2.  
- Moving towards passwordless authentication is ideal, but self-service password reset remains important.  
- Hybrid environments benefit from password write-back enabled by P1 license.

---

## SSPR

**Timestamp**: 00:23:27 – 00:25:00

**Key Concepts**  
- Self-Service Password Reset (SSPR) as a feature to enable users to reset their own passwords without help desk intervention.  
- Password write-back capability for hybrid identity environments, allowing password changes in the cloud to sync back to on-premises directories.  
- Licensing tiers (P1, P2) determine available features and user groups.  
- Configurable authentication methods and policies for password reset.  
- Role-based access control with emphasis on privileged roles like Global Administrator.

**Definitions**  
- **Self-Service Password Reset (SSPR)**: A feature that allows users to reset their own passwords securely without contacting IT support.  
- **Password Write-Back**: The process where password changes made in the cloud environment are written back to the on-premises directory in hybrid setups.  
- **Global Administrator**: The highest privileged role in Azure AD, with broad permissions, requiring strict control over assignment.

**Key Facts**  
- P1 license is required for SSPR with password write-back in hybrid identity scenarios.  
- Different licenses (P1, P2) can be assigned to different user groups based on their needs (e.g., privileged users may require P2 for privileged identity management).  
- Authentication methods for SSPR can be customized to require one or multiple verification methods, including custom questions.  
- Users are prompted to set up SSPR when they first join the organization and log in.  
- Role assignments can be delegated with specific permissions; privileged roles should be carefully assigned.

**Examples**  
- Privileged users might have P2 licenses for stronger identity protection and privileged identity management.  
- Basic workers might have P1 licenses with standard SSPR capabilities.  
- Password reset options can be configured per user or group, including how many authentication methods are required.

**Key Takeaways 🎯**  
- Implement SSPR to reduce help desk calls related to password resets.  
- Use password write-back to maintain synchronization between cloud and on-premises passwords in hybrid environments.  
- Assign licenses based on user roles and security needs; not all users require the same license level.  
- Configure authentication methods thoughtfully to balance security and usability.  
- Restrict assignment of highly privileged roles like Global Administrator to minimize security risks.

---

## Roles

**Timestamp**: 00:25:00 – 00:27:23

**Key Concepts**  
- Roles define sets of permissions assigned to users or groups within an organization.  
- The **Global Administrator** role is the most privileged and should be tightly controlled.  
- Delegated roles allow assigning specific permissions without granting full admin rights.  
- Administrative Units enable granular role assignment scoped to specific users, groups, or devices.  
- Permissions granted via roles in an administrative unit apply only to objects within that unit.  
- Adding a group to an administrative unit does not automatically grant role permissions over the users in that group; users must be explicitly added to the administrative unit for role permissions to apply.  

**Definitions**  
- **Global Administrator**: The highest privilege role with broad access across the organization; should be restricted to trusted individuals.  
- **Administrative Units**: Containers that group users, groups, and devices to allow scoped role assignments limited to those objects.  

**Key Facts**  
- Role assignments can be scoped to administrative units for more granular control.  
- Role permissions do not cascade from groups to their members within administrative units unless users are explicitly added.  
- This explicit user addition is a safety feature to prevent unintended permission escalation.  

**Examples**  
- Assigning a role to manage a specific group within an administrative unit without granting permissions over the users in that group unless those users are also added to the unit.  

**Key Takeaways 🎯**  
- Restrict the Global Administrator role due to its high level of privilege.  
- Use delegated roles to provide only necessary permissions.  
- Leverage administrative units to limit role scope and improve security management.  
- Always explicitly add users to administrative units if role permissions over those users are required, even if their group is already in the unit.  
- This approach prevents accidental over-permissioning and maintains clear boundaries of administrative control.

---

## Clouds and regions

**Timestamp**: 00:27:23 – 00:34:48

**Key Concepts**  
- Multiple Azure clouds/environments exist beyond the well-known Azure Commercial Cloud.  
- Each cloud/environment has its own control plane URLs and separate Azure AD (Entra) tenants.  
- Resources are deployed into regions, which are geographic locations containing multiple data centers.  
- Regions are subdivided into availability zones (AZs), typically three per region, representing separate data centers for resiliency.  
- Deployment options include zonal (within a single AZ) or zone-redundant (spanning multiple AZs) for higher availability.  
- Azure has many global regions, each with different availability zone support and sustainability info.  
- Regions are paired for safe deployment rollouts and disaster recovery, usually within the same geopolitical boundary.  
- Pairings are used by Microsoft for staged rollouts but customers are not required to use paired regions exclusively.  
- Selecting regions depends on latency, data sovereignty, and resiliency needs.  
- Subscriptions are the deployment boundary and trust a specific tenant.

**Definitions**  
- **Cloud/Environment**: A distinct Azure instance such as Azure Commercial, Azure US Gov, or Azure China, each with separate control planes and tenants.  
- **Region**: A geographic area containing multiple data centers where Azure resources are deployed.  
- **Availability Zone (AZ)**: Physically separate data centers within a region designed to provide redundancy and high availability.  
- **Zonal Deployment**: Deploying a resource within a single availability zone.  
- **Zone-Redundant Deployment**: Deploying a resource across multiple availability zones for resiliency.  
- **Paired Regions**: Two Azure regions geographically paired to enable safe deployment rollouts and disaster recovery.

**Key Facts**  
- Azure exposes 3 availability zones per region to subscriptions, even if more physically exist.  
- Regions should be chosen with large physical distance (hundreds of miles) between them to mitigate natural disasters.  
- Azure region pairings generally stay within the same geopolitical boundary except Brazil South which pairs with South Central US.  
- Microsoft uses region pairings for staged rollouts: internal systems → early access → canary → pilot → broader regions → first region in pair → second region in pair.  
- Customers have flexibility and are not forced to use paired regions for their deployments.  
- Azure has a large number of regions worldwide, including West US, West US 2, West US 3, West Central, Canada Central, etc.

**Examples**  
- PowerShell command `Get-AzEnvironment` shows different clouds/environments: Azure Commercial, Azure US Gov, Azure China.  
- Map example showing multiple regions like West US, West US 2, West US 3, Canada Central, with availability zones indicated.  
- Brazil South region pairs with South Central US region, an exception to the geopolitical boundary pairing rule.

**Key Takeaways 🎯**  
- Understand that Azure is not a single cloud but multiple clouds/environments with separate tenants and control planes.  
- Always deploy resources into regions and consider availability zones for resiliency.  
- Use zone-redundant deployments when possible to span multiple availability zones within a region.  
- Choose at least two regions spaced far apart to protect against regional disasters.  
- Region pairings help Microsoft safely roll out updates but customers can choose their own region strategy.  
- Consider latency and data sovereignty when selecting regions for deployment.  
- Subscriptions are tied to tenants and are the scope where resources are deployed.

---

## Subscriptions and Management Groups

**Timestamp**: 00:34:48 – 00:39:14

**Key Concepts**  
- Azure resources are deployed within **subscriptions**, which serve as organizational and billing boundaries.  
- Subscriptions are tied to a specific **tenant** and trust that tenant.  
- **Management groups** provide a hierarchy above subscriptions to organize and govern multiple subscriptions.  
- Management groups enable centralized governance, role assignment, policy enforcement, and budget tracking across multiple subscriptions.  
- Policies, roles, and budgets set at management group levels are **inherited** by all child management groups and subscriptions.  
- Governance includes role-based access control (RBAC), Azure Policy for enforcing rules, and budget management for financial control.  
- The hierarchy can be structured based on geography, business units, environment (prod/non-prod), or other organizational needs.  
- Cost management and billing tools are available at subscription and management group levels to monitor and forecast spending.

**Definitions**  
- **Tenant**: The overarching Azure Active Directory instance that owns and manages subscriptions.  
- **Subscription**: A container for Azure resources that provides a billing and organizational boundary, tied to a specific tenant.  
- **Management Group**: A container that holds subscriptions and other management groups, allowing for hierarchical organization and centralized governance.  
- **Role-Based Access Control (RBAC)**: A system to assign permissions to users or groups at different scopes (management group, subscription, resource).  
- **Azure Policy**: A governance tool to enforce rules and guardrails on resources, such as restricting resource types or regions.  
- **Budget**: A financial control mechanism to track and limit spending within subscriptions or management groups.

**Key Facts**  
- The **root management group** exists at the tenant level and is the top of the hierarchy.  
- Subscriptions can be directly under the root management group or nested inside child management groups.  
- Management groups support three core governance features: **Access Control (RBAC), Policy, and Budgets**.  
- Policies, roles, and budgets set at higher levels cascade down to all child entities.  
- Azure offers **free trial accounts** and some always-free services to start experimenting without cost.  
- Azure is **consumption-based billing**: you pay only for what you use, so managing resources and costs is critical.  
- Cost analysis and cost management tools are accessible via the Azure portal to monitor spending and forecast costs.

**Examples**  
- Example hierarchy:  
  - Tenant root management group  
    - One subscription tied directly to root  
    - Child management group "All Savile Tech Subscriptions"  
      - Two subscriptions under this child group  
      - Two further child management groups under it  
- Governance scenarios:  
  - Assigning roles at management group level to control access across multiple subscriptions.  
  - Applying policies to restrict resource types or enforce agent installation.  
  - Setting budgets to monitor and control financial spend across environments.

**Key Takeaways 🎯**  
- Use **subscriptions** to organize resources and manage billing boundaries.  
- Build a **management group hierarchy** to simplify governance across multiple subscriptions.  
- Apply **RBAC, policies, and budgets** at management group levels for consistent, inherited governance.  
- Structure management groups based on organizational needs like geography, business units, or environment types.  
- Always monitor costs using Azure’s cost management tools to avoid unexpected charges.  
- Take advantage of free trials and always-free services to experiment and learn without financial risk.  
- Remember that governance settings applied higher in the hierarchy cascade down, enabling centralized control.

---

## Cost analysis and budgets

**Timestamp**: 00:39:14 – 00:43:31

**Key Concepts**  
- Cloud services are consumption-based: you pay only for what you use.  
- Cost analysis tools allow monitoring of spending by subscription, resource, service, location, and resource group.  
- Forecasting helps predict future spending based on current usage trends.  
- Budgets can be set to control and monitor financial spending limits.  
- Alerts can be configured to notify stakeholders when spending reaches certain thresholds or forecasted limits.  
- Azure Advisor provides cost optimization recommendations such as stopping unused resources or right-sizing.  
- Resource groups organize resources within a subscription but cannot be nested.

**Definitions**  
- **Cost Analysis**: A tool to view accumulated costs, forecast spending, and analyze costs by different dimensions such as resource, service, or location.  
- **Budget**: A financial limit set on cloud spending, which can trigger alerts when spending approaches or exceeds set thresholds.  
- **Alerts**: Notifications triggered based on actual spend or forecasted spend crossing defined budget thresholds.  
- **Azure Advisor**: A service that provides recommendations for cost optimization, reliability, performance, operational excellence, and security.

**Key Facts**  
- Cost analysis can show daily costs, costs by resource, and costs by service.  
- Budgets can be set in financial units (e.g., dollars).  
- Alerts can be triggered at specific percentages of budget spent (e.g., 80%) or forecasted spend (e.g., 120%).  
- Alert actions can include SMS, webhooks, function calls, or other action groups.  
- Cost analysis includes smart views that highlight cost distribution (e.g., a resource group accounting for 24% of costs).  
- It is recommended to review cost analysis and budgets at least weekly.

**Examples**  
- Viewing cost analysis for a specific subscription to see accumulated cost and forecast.  
- Setting a budget with alerts that notify when 80% of the budget is spent or when forecasted spend exceeds 120%.  
- Azure Advisor recommending stopping unused resources or right-sizing to optimize costs.

**Key Takeaways 🎯**  
- Always monitor cloud spending regularly using cost analysis tools to avoid unexpected charges.  
- Use budgets and alerts proactively to control costs and receive timely notifications.  
- Leverage Azure Advisor for actionable cost optimization recommendations.  
- Organize resources into resource groups within subscriptions for better cost tracking and management.  
- Be cautious to stop or optimize resources that are not in use to minimize unnecessary spending.

---

## Resource Groups

**Timestamp**: 00:43:31 – 00:45:39

**Key Concepts**  
- Resource groups are a deployment and management container within an Azure subscription.  
- Multiple resource groups can exist within a single subscription, but resource groups cannot be nested inside one another.  
- Role-Based Access Control (RBAC), policies, and budgets can be applied at the resource group level for granular management.  
- Resources such as virtual machines, storage accounts, load balancers, etc., are created inside resource groups.  
- Resource groups are used to logically group resources that are provisioned, run, and decommissioned together.  
- Grouping resources by application or functionality helps with access control, policy application, and cost tracking.

**Definitions**  
- **Resource Group**: A container within an Azure subscription that holds related resources which share lifecycle, access control, policies, and budgeting.

**Key Facts**  
- Resource groups cannot be nested; each resource group exists independently within a subscription.  
- RBAC, policies, and budgets can be applied specifically to resource groups to manage subsets of resources more granularly.  
- Grouping resources in a resource group facilitates tracking spend and applying common controls.

**Examples**  
- A resource group might contain a set of virtual machines, a Kubernetes environment, a load balancer, and a database that together form a business application.  
- Resources that are provisioned, run, and deleted together (e.g., all components of a specific application) are placed in the same resource group.

**Key Takeaways 🎯**  
- Use resource groups to organize resources that share a common lifecycle and purpose.  
- Apply RBAC, policies, and budgets at the resource group level for more precise governance and cost control.  
- Resource groups help in tracking costs and managing access for specific applications or workloads within a subscription.  
- Logical grouping of resources simplifies management and aligns with business or operational units.

---

## Cost saving mechanisms

**Timestamp**: 00:45:39 – 00:51:20

**Key Concepts**  
- Cost optimization involves both operational actions (like sizing and stopping resources) and financial mechanisms to reduce Azure bills.  
- Azure Hybrid Benefit allows use of existing on-premises licenses in the cloud to reduce licensing costs.  
- Azure Reservations provide discounts by committing to specific services in specific regions for 1 or 3 years.  
- Azure Savings Plan offers flexible discounts on included compute services with a commitment of 1 or 3 years.  
- Savings Plan discounts vary by SKU and service type and apply hourly to running resources.  
- Only one financial discount mechanism (Savings Plan or Reserved Instance) can apply to a resource at a time.  
- Tags can be applied to subscriptions, resource groups, or resources to add metadata useful for filtering and billing.

**Definitions**  
- **Azure Hybrid Benefit**: A licensing benefit that lets you use existing Windows Server, SQL Server, or Red Hat Enterprise Linux licenses with software assurance in Azure, reducing consumption costs.  
- **Azure Reservations**: A pricing option where you pre-pay or commit to use a specific Azure service in a specific region for 1 or 3 years to receive a discount.  
- **Azure Savings Plan**: A flexible pricing commitment for included compute services that provides discounts based on hourly spend over 1 or 3 years, applicable across multiple SKUs and services.  
- **Tags**: Key-value pairs applied to Azure resources, resource groups, or subscriptions to add metadata for organization, filtering, and billing purposes.

**Key Facts**  
- Azure Hybrid Benefit applies to Windows Server (Standard or Datacenter), SQL Server, and Red Hat Enterprise Linux licenses.  
- Standard Windows Server licenses must be moved to the cloud to use Hybrid Benefit; Datacenter licenses can be used both on-premises and in the cloud simultaneously.  
- Azure Reservations require specificity in service and region to qualify for discounts.  
- Savings Plans apply only to included compute services such as many VM types, Azure Dedicated Hosts, and certain App Service plans.  
- Commitment terms for Reservations and Savings Plans are typically 1 or 3 years.  
- Savings Plan discounts vary by SKU; newer SKUs may have better discounts.  
- Billing applies discounts hourly, prioritizing the best discount for running resources.  
- Storage accounts can have Reserved Instances but do not support Savings Plans.  
- Financial cost-saving options do not involve resizing or stopping VMs but focus on licensing and commitment discounts.

**Examples**  
- Using Azure Hybrid Benefit to remove Windows Server or SQL Server license costs from the VM pricing.  
- Comparing discounts on different VM SKUs (e.g., V5 SKU has better Savings Plan discount than older SKUs).  
- Applying a 3-year Reserved Instance or Savings Plan commitment to reduce compute costs.  

**Key Takeaways 🎯**  
- Leverage Azure Hybrid Benefit to reduce licensing costs by using existing licenses in the cloud.  
- Use Azure Reservations for predictable workloads where you can commit to specific services and regions to save money.  
- Consider Azure Savings Plans for more flexible compute usage with discounts applied hourly across eligible services.  
- Only one discount mechanism (Savings Plan or Reserved Instance) can be applied to a resource at a time—choose based on workload predictability and flexibility needs.  
- Tags are important for organizing resources and can support cost tracking and billing analysis.  
- Financial cost-saving mechanisms complement operational optimizations like right-sizing and stopping unused resources.

---

## Tags

**Timestamp**: 00:51:20 – 00:54:35

**Key Concepts**  
- Tags are key-value pairs applied to Azure resources, resource groups, or subscriptions to add metadata.  
- Tags help organize, filter, and manage resources beyond the default hierarchy of subscriptions and resource groups.  
- Tags are not inherited automatically from parent scopes (subscription → resource group → resource).  
- Azure Policy can be used to enforce or copy tags from parent scopes to child resources.  
- Tags can be used for billing, filtering views, and tracking ownership or environment details.

**Definitions**  
- **Tag**: A key-value pair assigned to Azure resources, resource groups, or subscriptions to store metadata for organizational or billing purposes.  
- **Inheritance (in context of tags)**: The automatic application of tags from a parent resource (subscription or resource group) to child resources, which does not happen by default in Azure.

**Key Facts**  
- Typically, up to 50 tags can be applied per resource or resource group.  
- Tags set at the subscription level do NOT propagate to resource groups or resources.  
- Tags set at the resource group level do NOT propagate to individual resources.  
- Azure Policy can be configured to copy or enforce tags from parent to child resources, enabling inheritance-like behavior.  

**Examples**  
- Applying a tag at the subscription level: e.g., `environment=dev` on a dev subscription.  
- Applying tags to resource groups or individual resources such as:  
  - `owner` to track who is responsible for a resource  
  - `OS version` to track the operating system version  
  - `cost center` or `business unit` for billing and organizational tracking  
- Filtering resources by tag values, e.g., showing only resources where `cost center=demo group one`.

**Key Takeaways 🎯**  
- Tags are a flexible way to add metadata to Azure resources for management, billing, and filtering.  
- Tags do not inherit automatically; each level (subscription, resource group, resource) must have tags set explicitly unless Azure Policy is used.  
- Using Azure Policy to enforce or copy tags can help maintain consistent tagging standards across resources.  
- Tags improve visibility and control in large environments by enabling filtering and reporting based on metadata.

---

## Azure Policy

**Timestamp**: 00:54:35 – 00:59:09

**Key Concepts**  
- Azure Policy enforces organizational standards and guardrails in a self-service cloud environment.  
- Policies define specific conditions and effects to control resource creation and configuration.  
- Compliance tracking allows monitoring how well resources meet defined policies.  
- Initiatives are collections of multiple policies grouped for easier management and compliance tracking.  
- Policy effects include deny, audit, and deploy if not exists, among others.  
- Starting with audit mode is recommended before enforcing deny to avoid unintended disruptions.  
- Policies and initiatives can be assigned at different scopes: management group, subscription, or resource group.  
- Microsoft provides built-in policy definitions and initiatives, including large sets like the Azure Defender for Cloud initiative.  
- Regulatory compliance initiatives (e.g., FedRAMP, HIPAA, ISO) require a paid Azure plan.  

**Definitions**  
- **Azure Policy**: A service that allows setting guardrails by defining rules and effects to enforce organizational standards on Azure resources.  
- **Policy**: A specific rule with conditions and an effect applied to resources (e.g., allowed locations).  
- **Effect**: The action taken when a policy condition is met or violated, such as deny, audit, or deploy if not exists.  
- **Initiative**: A collection of multiple policies grouped together for bulk assignment and consolidated compliance tracking.  
- **Compliance**: The state of resources meeting the requirements set by policies or initiatives.  

**Key Facts**  
- Initiatives can contain hundreds of policies (example given: one initiative with 665 policies).  
- Assigning an initiative is more efficient than assigning hundreds of individual policies.  
- Compliance can be tracked at multiple scopes: management group, subscription, and resource group.  
- The Microsoft Cloud Security Benchmark initiative is free.  
- Additional regulatory compliance initiatives require a paid Azure plan.  

**Examples**  
- Allowed Locations Policy: Checks if the location of a resource being created is within a specified allowed list; if not, the effect (e.g., deny) is applied.  
- Deploy If Not Exists Effect: Automatically deploys a resource (like an agent) if it is missing from the environment.  
- Azure Defender for Cloud initiative: A large initiative containing hundreds of policies to enforce security standards.  

**Key Takeaways 🎯**  
- Azure Policy replaces manual approval processes with automated guardrails in cloud resource management.  
- Use audit mode initially to understand policy impact before enforcing deny effects.  
- Group policies into initiatives for efficient management and compliance tracking.  
- Compliance visibility helps maintain organizational standards across large environments.  
- Some advanced compliance initiatives require additional licensing.  
- Policies and initiatives can be scoped flexibly to fit organizational hierarchy and needs.

---

## RBAC

**Timestamp**: 00:59:09 – 01:06:56

**Key Concepts**  
- Role-Based Access Control (RBAC) assigns permissions to identities (users, groups, service principals) at specific scopes within Azure.  
- Azure resources are organized hierarchically: management groups > subscriptions > resource groups > individual resources. RBAC roles can be assigned at any of these scopes.  
- Least privilege principle: assign the minimum permissions needed at the smallest possible scope to reduce risk.  
- Roles are collections of actions that apply to resource providers and their resources.  
- Role assignments link an identity, a role, and a scope.  
- Built-in roles include Owner, Contributor, Reader, each with different permission levels.  
- Custom roles can be created by cloning existing roles and adding/removing specific permissions to tailor access precisely.  
- Role assignments are inherited down the resource hierarchy (e.g., a role assigned at a management group applies to all underlying subscriptions and resources).  
- RBAC roles differ from Entra roles, which apply to tenant-level permissions.  
- User Access Administrator role allows elevating permissions across subscriptions that trust the tenant.  
- Resource locks can be applied at subscription, resource group, or resource level to prevent deletion or make resources read-only.

**Definitions**  
- **Role**: A set of permissions (actions) that can be assigned to an identity for managing Azure resources.  
- **Scope**: The level at which a role assignment applies (management group, subscription, resource group, or resource).  
- **Role Assignment**: The binding of an identity to a role at a specific scope.  
- **Owner**: Built-in role with full permissions including managing access.  
- **Contributor**: Built-in role with permissions to manage resources but cannot manage access.  
- **Reader**: Built-in role with read-only access to resources.  
- **Custom Role**: A user-defined role created by modifying existing roles to fit specific permission needs.  
- **User Access Administrator**: A role that allows a user to grant access to Azure resources, often used by global admins to elevate permissions.  
- **Resource Lock**: A mechanism to prevent accidental deletion or modification of resources, with two types: Delete lock and Read-only lock.

**Key Facts**  
- Owner role can have up to 16,000 permissions because it can perform any action on any resource.  
- Role assignments can be inherited from higher scopes down to individual resources.  
- Custom roles allow adding or excluding specific permissions, including wildcard permissions with exceptions.  
- RBAC roles apply to Azure resources, while Entra roles apply to tenant-level permissions.  
- User Access Administrator permission can be granted at the root scope to enable permission elevation across subscriptions.  
- Locks can be applied at multiple levels and are either "cannot delete" or "read-only."

**Examples**  
- Network team given a role at a high management group level to manage virtual networks across the entire structure.  
- A subscription user might have a role only at the subscription or resource group level for limited access.  
- Viewing access control on a resource group shows many possible roles because it contains many resource types.  
- Viewing access control on a container registry or storage account shows fewer roles relevant to that resource type.  
- A BLOB data owner role assigned directly on a storage resource.  
- A managed identity assigned a role on a specific virtual machine resource.  
- Creating a custom role by cloning an existing role and removing write or delete permissions to enforce least privilege.

**Key Takeaways 🎯**  
- Always apply the principle of least privilege: assign only the permissions necessary at the smallest scope possible.  
- Use groups for role assignments rather than individual users to simplify management and avoid orphaned permissions.  
- Understand role inheritance and how assignments at higher scopes affect all underlying resources.  
- Be cautious with powerful built-in roles like Owner; avoid over-assigning these roles.  
- Custom roles are valuable for tailoring permissions when built-in roles are too broad.  
- RBAC roles are distinct from Entra roles; know which applies to your scenario.  
- Use User Access Administrator role carefully to enable permission elevation when needed.  
- Implement resource locks to protect critical resources from accidental deletion or modification.

---

## Resource locking

**Timestamp**: 01:06:56 – 01:09:28

**Key Concepts**  
- Resource locks can be applied at subscription, resource group, or individual resource levels.  
- There are two types of locks: "Cannot delete" and "Read only."  
- Locks affect only the Azure control plane, not the data plane.  
- Locks are inherited down the resource hierarchy.  

**Definitions**  
- **Cannot delete lock**: Prevents deletion of the resource but allows modifications.  
- **Read only lock**: Prevents any modifications, including writes, to the resource.  
- **Control plane**: The management layer of Azure where resources are created, configured, or deleted.  
- **Data plane**: The layer where data operations occur, such as writing or deleting records inside a resource (e.g., database entries, blobs).  

**Key Facts**  
- Locks only restrict actions on the control plane, not on the data plane.  
- Even with a delete lock on a storage account, you can still delete blobs inside it because blob operations happen on the data plane.  
- Locks are inherited from higher levels (subscription/resource group) down to resources.  

**Examples**  
- A "backup protection" lock set to "delete" on a storage account prevents deleting the storage account itself but does not prevent deleting blobs inside it.  
- You can write records to a database or create/delete blobs even if the resource is locked at the control plane level.  

**Key Takeaways 🎯**  
- Resource locks are a control plane feature to prevent accidental deletion or modification of Azure resources.  
- Locks do not protect the data inside resources; data plane operations remain unaffected.  
- Understand the distinction between control plane and data plane when applying locks to avoid false assumptions about data protection.  
- Use locks strategically at appropriate scopes (subscription, resource group, resource) to safeguard critical infrastructure components.

---

## Networking

**Timestamp**: 01:09:28 – 01:10:15

**Key Concepts**  
- Azure networking fundamentals  
- Cost model for data transfer in Azure (ingress vs egress)  
- Virtual Network (VNet) as the basic building block of Azure networking  
- Boundaries of a virtual network in terms of subscription and region  

**Definitions**  
- **Ingress**: Data coming into Azure from outside (no cost)  
- **Egress**: Data leaving Azure data centers (cost incurred)  
- **Virtual Network (VNet)**: A logically isolated network within Azure that exists within a specific subscription and region  

**Key Facts**  
- Azure does not charge for ingress data (data entering Azure)  
- Azure charges for egress data (data leaving Azure data centers)  
- A virtual network is confined to a single subscription and a single Azure region  
- VNets cannot span multiple subscriptions or regions  

**Examples**  
- None mentioned explicitly, but the speaker references a virtual network named "VNet one" as an example  

**Key Takeaways 🎯**  
- Always remember that ingress data into Azure is free, but egress data is chargeable  
- Virtual networks are fundamental to Azure networking and are scoped to a single subscription and region  
- Understanding the boundaries of VNets is crucial for network design and management in Azure  
- For deeper networking knowledge, consider resources like the AZ-700 study cram  

---

## Virtual network

**Timestamp**: 01:10:15 – 01:20:00

**Key Concepts**  
- Virtual Network (VNet) is the fundamental building block of Azure networking.  
- A VNet exists within a single Azure subscription and region (cannot span multiple subscriptions or regions).  
- VNets are defined by one or more IPv4 CIDR ranges, commonly private IP ranges (RFC 1918), but can also include custom or public IP ranges (with limitations).  
- VNets are subdivided into subnets, which are subsets of the VNet’s IP address space.  
- Subnets are regional resources and can span multiple Availability Zones within the same region.  
- Each subnet loses 5 IP addresses due to reserved addresses for network, broadcast, gateway, and DNS purposes.  
- Resources connect to VNets via virtual NICs that receive private IP addresses allocated by Azure DHCP.  
- Public IP addresses can be associated with resources for internet accessibility, but private IPs are not internet routable by default.  
- Public IPs come in Standard and Basic SKUs; Standard is recommended as Basic is being retired by September 2025.  
- Azure supports bringing your own public IP prefixes (ranges) with specific size requirements and validation processes.  
- For outbound internet access, explicit configuration is required (e.g., public IP, NAT gateway, Azure Firewall, or Standard Load Balancer with outbound rules) as implicit internet access is being deprecated.  

**Definitions**  
- **Virtual Network (VNet)**: A logically isolated network in Azure that provides IP address space and subnetting within a specific subscription and region.  
- **Subnet**: A subdivision of a VNet’s IP address range, used to organize and isolate resources within the VNet.  
- **CIDR (Classless Inter-Domain Routing)**: A method for allocating IP addresses and IP routing.  
- **Public IP Address**: An IP address reachable from the internet, which can be associated with Azure resources for inbound/outbound connectivity.  
- **Standard SKU Public IP**: A static, highly available public IP address recommended for use in Azure.  
- **Basic SKU Public IP**: A legacy SKU for public IPs that can be dynamic; being retired by September 2025.  
- **NAT Gateway**: A resource that provides outbound internet connectivity for resources in a subnet, efficiently managing port allocation for SNAT.  
- **Azure Firewall**: A managed network security service that can control outbound and inbound traffic with user-defined routes.  
- **Virtual NIC**: A virtual network interface card attached to a resource, which receives an IP address from the subnet’s address space.  

**Key Facts**  
- VNets cannot span multiple subscriptions or regions.  
- Common private IP ranges used: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 (RFC 1918).  
- Each subnet loses 5 IP addresses: network address (.0), broadcast address (.255 for /24), gateway (.1), and two DNS addresses (.2 and .3).  
- Public IP prefixes brought into Azure must be between /21 and /24 for IPv4, and /48 for IPv6.  
- Basic SKU public IPs will be retired on September 3, 2025; Standard SKU is preferred.  
- Subnets are regional and can span all Availability Zones in that region.  
- DHCP is used internally by Azure to assign IPs; users cannot run their own DHCP servers in VNets.  
- Static private IP assignment is possible by reserving an IP for a resource via Azure Fabric.  
- Implicit outbound internet access from VNets is being deprecated; explicit configuration is required for internet connectivity.  

**Examples**  
- VNet named "VNet1" defined with one or more IPv4 CIDR ranges.  
- Subnets labeled subnet1, subnet2, subnet3, subnet4 as subsets of the VNet IP space.  
- Assigning a public IP directly to a resource’s network configuration (not recommended for high availability).  
- Using a Standard Load Balancer with backend pools for resilient internet-facing services.  
- Associating a NAT gateway at the subnet level to provide outbound internet connectivity.  

**Key Takeaways 🎯**  
- Always design VNets within a single subscription and region boundary.  
- Choose unique IP address spaces for VNets and subnets to avoid routing conflicts, especially when connecting to on-premises or other VNets.  
- Remember the 5 reserved IP addresses per subnet when planning IP allocation.  
- Use Standard SKU public IPs for internet-facing resources to ensure static and supported IPs.  
- Plan for explicit outbound internet connectivity configurations as implicit access is being phased out.  
- Consider using NAT gateways or Azure Firewall for efficient and secure outbound internet access rather than assigning public IPs directly to resources.  
- Bringing your own public IP prefixes is possible but involves a complex validation and provisioning process.  
- Subnets are regional and can span multiple Availability Zones, providing flexibility in resource placement.

---

## Peering

**Timestamp**: 01:20:00 – 01:24:36

**Key Concepts**  
- Virtual Network (VNet) peering allows private IP communication between VNets.  
- Peering can be within the same region or across different regions (inter-region).  
- Peering enables VNets in different subscriptions or regions to communicate without using public endpoints.  
- Hub-and-spoke network topology: a central hub VNet with gateway connectivity and multiple spoke VNets peered to it.  
- Gateway transit allows spoke VNets to use the hub VNet’s gateway for connectivity (e.g., site-to-site VPN, ExpressRoute).  
- Peering relationships are not transitive by default; spokes cannot communicate with each other unless explicitly peered or routed through a network virtual appliance (NVA) like Azure Firewall.  
- User Defined Routes (UDRs) can be used to direct traffic through NVAs to enable transitive routing between VNets.  
- Azure Virtual Network Manager can help manage and configure network groups and peerings at scale.

**Definitions**  
- **VNet Peering**: A connection between two Azure VNets that enables resources in either VNet to communicate with each other privately using private IP addresses.  
- **Gateway Transit**: A peering configuration that allows a spoke VNet to use the gateway (VPN or ExpressRoute) of a hub VNet.  
- **Remote Gateway**: The setting on a spoke VNet peering that allows it to use the gateway of the peered hub VNet.  
- **User Defined Routes (UDRs)**: Custom routing rules that specify next hops for traffic, used to direct traffic through NVAs or firewalls.  
- **Network Virtual Appliance (NVA)**: A virtual appliance (e.g., Azure Firewall) used to manage or inspect network traffic between VNets.  
- **Azure Virtual Network Manager**: A service to centrally manage and configure network groups and peerings across multiple VNets.

**Key Facts**  
- VNets are bound to a specific Azure region and subscription.  
- Peering supports both intra-region and inter-region connections.  
- Gateway transit requires two settings:  
  - On the hub VNet peering: allow gateway transit (or equivalent updated terminology).  
  - On the spoke VNet peering: allow use of remote gateway.  
- Peering connections are not transitive by default; explicit peering or routing is required for spoke-to-spoke communication.  
- Transitive routing can be enabled by routing traffic through an Azure Firewall or other NVA using UDRs.

**Examples**  
- Hub VNet contains a gateway (site-to-site VPN or ExpressRoute).  
- Spoke VNets peer with the hub and are configured to use the hub’s gateway via gateway transit and remote gateway settings.  
- To enable spoke-to-spoke communication, either add direct peering between spokes or route traffic through an Azure Firewall acting as an NVA.  
- Use UDRs to direct traffic from one spoke to another via the Azure Firewall.

**Key Takeaways 🎯**  
- VNet peering enables private, low-latency connectivity between VNets across regions and subscriptions without public internet exposure.  
- Proper configuration of gateway transit and remote gateway settings is essential for spokes to leverage the hub’s gateway connectivity.  
- Peering is not transitive; to enable spoke-to-spoke communication, explicit peering or routing through an NVA is required.  
- NVAs like Azure Firewall combined with UDRs can enable complex routing scenarios including transitive connectivity.  
- Azure Virtual Network Manager can simplify management of multiple peerings and network groups at scale.

---

## Azure Virtual Network Manager

**Timestamp**: 01:24:36 – 01:28:47

**Key Concepts**  
- Azure Virtual Network Manager (AVNM) simplifies management of connectivity and security across multiple virtual networks (VNets).  
- Network Groups: Collections of VNets that can be static (manually assigned) or dynamic (rules-based assignment).  
- Connectivity Configurations: Define how VNets connect, e.g., hub-and-spoke or mesh topology.  
- Mesh topology allows any-to-any connectivity without traditional VNet peering.  
- Security Admin Rules: Precede local subnet or NIC-level rules and control traffic flow at a higher level.  
- Security rules can be set to **Allow**, **Always Allow** (bypass NSGs), or **Deny** traffic.  

**Definitions**  
- **Azure Virtual Network Manager (AVNM)**: A service that enables centralized management of network connectivity and security policies across multiple VNets, reducing the complexity of manual peering and routing configurations.  
- **Network Groups**: Logical groupings of VNets that can be managed collectively, either by manual assignment or dynamic criteria.  
- **Connectivity Configuration**: The defined pattern of connectivity between VNets within network groups, such as hub-and-spoke or mesh.  
- **Security Admin Rules**: High-level traffic filtering rules applied before any local network security groups (NSGs) or subnet/NIC rules.  
- **Always Allow**: A security admin rule setting that permits traffic to bypass NSGs and go directly to the target resource.  

**Key Facts**  
- VNets can belong to multiple network groups simultaneously.  
- Mesh connectivity in AVNM provides any-to-any connectivity within a region without using traditional peering.  
- Security Admin Rules apply before local subnet or NIC-level rules, providing a top-level control point.  
- "Allow" rules pass traffic to NSGs for further filtering; "Always Allow" bypasses NSGs entirely.  
- "Deny" rules block traffic outright before it reaches NSGs.  

**Examples**  
- Using "Always Allow" for critical traffic such as domain controller connectivity or maintenance/patching traffic to prevent accidental blocking by local admins or app owners.  

**Key Takeaways 🎯**  
- AVNM greatly simplifies network management by grouping VNets and defining connectivity patterns centrally.  
- The ability to create dynamic network groups allows for scalable and automated network management.  
- Mesh connectivity removes the need for complex peering setups, enabling straightforward any-to-any communication.  
- Security Admin Rules provide a powerful mechanism to enforce critical traffic flows that cannot be overridden by local NSGs.  
- Use "Always Allow" rules to safeguard essential infrastructure traffic from accidental blocking.  
- AVNM is a more efficient and manageable alternative to manually creating and managing VNet peerings and user-defined routes.  

---

## Network Security Group

**Timestamp**: 01:28:47 – 01:36:27

**Key Concepts**  
- Network Security Groups (NSGs) are sets of rules that control inbound and outbound traffic to Azure resources.  
- NSG rules are based on attributes such as priority, name, source, destination, ports, and action (allow or deny).  
- Sources and destinations in NSG rules can be IP addresses, service tags, or application security groups.  
- Service tags represent groups of IP address ranges for Azure services and can simplify rule management.  
- Application Security Groups (ASGs) are tags assigned to NICs to group resources logically for easier NSG rule application.  
- NSGs must be created in the same Azure region as the virtual network (VNet) they are associated with.  
- NSGs have default rules with priorities ranging from 1 (highest) to 65,500 (lowest).  
- NSGs can be associated with subnets or individual NICs.  
- Effective routes and rules impacting a NIC can be viewed to understand traffic flow and restrictions.  
- Azure Firewall is a Microsoft Network Virtual Appliance that can complement NSGs by providing advanced inbound/outbound filtering and NAT capabilities.

**Definitions**  
- **Network Security Group (NSG)**: A collection of security rules that allow or deny inbound and outbound network traffic to Azure resources.  
- **Service Tag**: A label representing a group of IP address prefixes for specific Azure services, used to simplify NSG rule management.  
- **Application Security Group (ASG)**: A logical grouping of NICs that allows NSG rules to be applied based on application roles rather than IP addresses.  
- **Priority (in NSG rules)**: A numeric value determining the order of rule evaluation; lower numbers have higher priority.  
- **Azure Firewall**: A managed, first-party network virtual appliance that provides advanced filtering, NAT, and traffic inspection capabilities.

**Key Facts**  
- NSG rule priority ranges from 1 (highest) to 65,500 (lowest).  
- Default NSG rules allow all traffic within the virtual network and outbound internet traffic, and deny other inbound traffic by default.  
- Service tags include options like "Internet," "AzureLoadBalancer," and region-specific Azure services.  
- Application Security Groups must be in the same region as the NSG.  
- NSGs can filter traffic by protocol (TCP/UDP), port, source, and destination.  
- Effective routes for a NIC show how traffic is routed, including peering and user-defined routes.

**Examples**  
- Blocking inbound TCP port 80 traffic while allowing Azure Load Balancer probes and virtual network traffic.  
- Using an ASG to tag all SQL databases and another ASG for web front ends, then creating NSG rules allowing web front ends to communicate with SQL databases on port 1433 without managing IP addresses.  
- Viewing effective inbound port rules and routes on a virtual machine’s NIC to understand applied security and routing.

**Key Takeaways 🎯**  
- NSGs provide granular control over network traffic using prioritized rules based on source, destination, ports, and protocols.  
- Using service tags and application security groups simplifies management by abstracting IP addresses and grouping resources logically.  
- Always create NSGs in the same region as the VNet they protect.  
- Default NSG rules provide a baseline security posture but can be customized with higher priority rules.  
- Application Security Groups enable flexible, scalable security policies aligned with application roles rather than static IPs.  
- Understanding effective routes and applied rules on NICs helps troubleshoot and verify network security configurations.  
- Azure Firewall can be used alongside NSGs for more advanced network filtering and NAT capabilities.

---

## Azure Firewall

**Timestamp**: 01:36:27 – 01:38:41

**Key Concepts**  
- Azure Firewall is a first-party Microsoft Network Virtual Appliance used for network traffic filtering and control.  
- It supports defining rules for both inbound and outbound traffic.  
- Rules can be applied at different OSI layers: Layer 4 (network layer) and Layer 7 (application layer).  
- Azure Firewall comes in different SKUs: Basic, Standard, and Premium, each with varying performance and features.  
- User Defined Routes (UDRs) are used to direct traffic through the Azure Firewall from different parts of the network.

**Definitions**  
- **Azure Firewall**: A managed, cloud-based network security service that protects Azure Virtual Network resources by filtering traffic using defined rules.  
- **SNAT (Source Network Address Translation)**: Used by Azure Firewall for outbound traffic to translate private IP addresses to public IP addresses.  
- **DNAT (Destination Network Address Translation)**: Used for inbound traffic to translate public IP addresses to private IP addresses.  
- **Layer 4 Rules**: Network layer rules that filter traffic based on TCP/UDP protocols and ports.  
- **Layer 7 Rules**: Application layer rules that filter traffic based on application-level data such as URLs.  
- **SKU (Stock Keeping Unit)**: Different versions of Azure Firewall offering varying performance and features.

**Key Facts**  
- Basic SKU offers low performance.  
- Standard SKU supports up to 30 Gbps throughput.  
- Premium SKU supports up to 100 Gbps throughput.  
- Standard and Premium SKUs support filtering based on categories and can act as a DNS proxy.  
- Premium SKU additionally supports inbound and outbound TLS termination, fully managed intrusion detection and prevention system (IDPS), URL filtering, and SSL termination.  
- Azure Firewall features vary by SKU, so selection depends on required functionality.

**Examples**  
- None explicitly mentioned beyond general capabilities (e.g., inbound/outbound SNAT and DNAT, layer 4 and layer 7 rules).

**Key Takeaways 🎯**  
- Azure Firewall is a versatile, managed firewall solution integrated into Azure networking.  
- Choose the SKU based on required throughput and advanced features like TLS termination and intrusion prevention.  
- Use User Defined Routes to ensure traffic is routed through the Azure Firewall for inspection and filtering.  
- Azure Firewall supports both network-level and application-level filtering, making it suitable for complex security scenarios.

---

## Azure DNS

**Timestamp**: 01:38:41 – 01:41:35

**Key Concepts**  
- Azure DNS provides both public and private DNS capabilities.  
- DNS is essential because humans cannot easily remember IP addresses; DNS provides friendly names for resources.  
- Public DNS zones manage records accessible over the Internet.  
- Private DNS zones manage records accessible only within private networks (e.g., virtual networks).  
- Alias records in Azure DNS point directly to Azure resources, preventing dangling DNS issues.  
- Dangling DNS occurs when a DNS record points to a deleted or non-existent resource, which can be exploited by attackers.  
- Azure Traffic Manager creates public DNS records but is typically referenced via custom domain DNS records rather than directly.  
- Private DNS zones can have manual and automatic record creation and can be associated with virtual networks.

**Definitions**  
- **Azure DNS**: A service that provides DNS hosting for both public and private DNS zones within Azure.  
- **Public DNS Zone**: A DNS zone accessible over the Internet, used to manage DNS records for public-facing resources.  
- **Private DNS Zone**: A DNS zone accessible only within specified virtual networks, used for internal name resolution.  
- **Alias Record**: A DNS record type in Azure DNS that points directly to an Azure resource, automatically updating or becoming empty if the resource is deleted, preventing dangling DNS.  
- **Dangling DNS**: A DNS record that points to a resource that no longer exists, which can be hijacked by attackers creating a resource with the same name.

**Key Facts**  
- Azure DNS supports various record types including A, CNAME, MX, and alias records (with some limitations on alias record types).  
- Alias records cannot be created for all record types (e.g., MX records cannot be alias records).  
- When an Azure resource pointed to by an alias record is deleted, the alias record becomes empty and unusable, mitigating security risks.  
- Private DNS zones support automatic record creation and can be linked to virtual networks for seamless internal DNS resolution.

**Examples**  
- Creating an alias record that points to an Azure resource ensures that if the resource is deleted, the DNS record does not become a dangling DNS entry.  
- A dangling DNS scenario described: if a resource is deleted but the DNS record remains, an attacker could create a resource with the same name and hijack traffic.  
- Using a custom domain DNS record to point to Azure Traffic Manager rather than pointing directly to Traffic Manager’s DNS record.

**Key Takeaways 🎯**  
- Use Azure DNS to manage both public and private DNS needs within Azure environments.  
- Prefer alias records for Azure resources to avoid dangling DNS and potential security risks.  
- Understand the difference between public and private DNS zones and their appropriate use cases.  
- Associate private DNS zones with virtual networks to enable automatic internal DNS resolution.  
- When using Azure Traffic Manager, use custom domain DNS records to reference it rather than direct DNS entries.

---

## Azure Private DNS

**Timestamp**: 01:41:35 – 01:46:51

**Key Concepts**  
- Azure Private DNS zones provide private, internal DNS resolution within virtual networks (VNets).  
- Private DNS zones can have manual and automatic DNS record creation.  
- Auto-registration allows resources in VNets to automatically register DNS records in a private DNS zone.  
- Private DNS zones can be associated with multiple VNets for registration and resolution purposes.  
- Azure Private DNS resolver enables DNS resolution from on-premises or outside VNets to private DNS zones.  
- Default DNS zones exist per VNet but cannot be manually modified.  
- Custom DNS servers can be configured at the VNet level and integrated with Azure Private DNS.  
- Split-brain DNS scenarios are supported by using both public and private DNS zones for the same domain names.

**Definitions**  
- **Private DNS Zone**: A DNS zone accessible only within specified VNets, used for internal name resolution.  
- **Auto Registration**: A feature where resources in a VNet automatically create DNS records in an associated private DNS zone.  
- **Azure Private DNS Resolver**: A managed service that allows DNS queries from outside VNets (e.g., on-premises) to resolve private DNS zone records and can forward queries to custom DNS servers.  
- **Default DNS Zone**: A built-in DNS zone per VNet (e.g., *.internal.cloudapp.net) that cannot be manually edited but provides default internal DNS resolution.  
- **Split Brain DNS**: A DNS configuration where the same domain name resolves differently internally (private DNS zone) and externally (public DNS zone).

**Key Facts**  
- A virtual network can auto-register to only one private DNS zone.  
- A private DNS zone can be used by up to 100 VNets for auto-registration.  
- A virtual network can resolve DNS records from up to 1000 private DNS zones.  
- A private DNS zone can be linked to up to 1000 VNets for resolution purposes.  
- Azure DNS IP address for resolution is always 168.63.129.16, accessible only from within VNets.  
- Azure Private DNS zones are global and can be linked across subscriptions and tenants with appropriate permissions.

**Examples**  
- When a resource is created and auto-registration is enabled, it automatically creates a DNS record in the private DNS zone for internal resolution.  
- Using custom DNS servers at the VNet level requires consideration of forwarding rules to ensure proper resolution, especially when using private link and auto-registration.

**Key Takeaways 🎯**  
- Azure Private DNS zones enable secure, scalable internal DNS resolution across multiple VNets.  
- Auto-registration simplifies DNS management by automatically creating records for resources.  
- The Azure Private DNS resolver bridges DNS queries from on-premises or external networks to private DNS zones.  
- Proper configuration of custom DNS servers and forwarding is critical to maintain resolution functionality.  
- Split brain DNS allows different DNS responses internally and externally, supporting hybrid environments.  
- Understanding limits on associations (100 VNets for registration, 1000 for resolution) is important for large-scale deployments.

---

## Connectivity

**Timestamp**: 01:46:51 – 01:47:52

**Key Concepts**  
- Use of private and public DNS zones for different resolution scopes (internal vs internet)  
- Internet egress requires explicit configuration in Azure gateways/firewalls (default egress is deprecated)  
- Virtual Network (VNet) subnet sizing considerations for gateway subnets  
- VPN gateway types: policy-based (static routing) vs route-based (dynamic routing)  

**Definitions**  
- **Private DNS Zone**: A DNS zone used internally within Azure for private name resolution, isolated from the public internet.  
- **Public DNS Zone**: A DNS zone published to the internet for public name resolution.  
- **Gateway Subnet**: A subnet within a VNet dedicated to hosting VPN gateways or ExpressRoute gateways.  
- **Policy-based VPN**: A VPN type using static routing, limited to one tunnel, considered legacy and not recommended.  
- **Route-based VPN**: A VPN type using dynamic routing, supports multiple tunnels, and is the preferred modern approach.  

**Key Facts**  
- Gateway subnet minimum size: /29 (8 IP addresses)  
- Recommended gateway subnet size: /27 (32 IP addresses) to allow coexistence of site-to-site VPN and ExpressRoute  
- Policy-based VPN supports only one tunnel and requires basic SKU gateways  
- Route-based VPN supports multiple tunnels and is the standard for current Azure VPN gateways  

**Examples**  
- Splitting DNS resolution between a public Azure DNS zone (for internet-facing resources) and a private DNS zone (for internal resolution)  
- Drawing a VNet with a gateway subnet sized /27 to support both site-to-site VPN and ExpressRoute coexistence  

**Key Takeaways 🎯**  
- Plan DNS zones carefully to separate internal and external name resolution using private and public zones  
- Default internet egress from VNets is deprecated; explicit egress configuration is required via gateways or firewalls  
- Allocate sufficient IP space for gateway subnets (preferably /27) to support multiple connectivity options  
- Avoid policy-based VPNs due to limitations and legacy status; prefer route-based VPNs for flexibility and scalability  

---

## S2S VPN

**Timestamp**: 01:47:52 – 01:50:34

**Key Concepts**  
- Site-to-site (S2S) VPN connects private IP spaces over the Internet.  
- Two main VPN types: policy-based (static routing) and route-based (dynamic routing).  
- Route-based VPNs support multiple tunnels and point-to-site VPN connections.  
- VPN gateways can be configured in active-passive or active-active modes for redundancy.  
- S2S VPN traffic is encrypted but traverses the public Internet, which may cause variable latency.  
- ExpressRoute is an alternative private connectivity option using Microsoft’s global backbone network.

**Definitions**  
- **Policy-based VPN**: A VPN using static routing, limited to one tunnel, considered legacy and restrictive.  
- **Route-based VPN**: A VPN using dynamic routing, supports multiple tunnels and point-to-site connections, preferred in modern setups.  
- **Active-active VPN gateway**: Configuration where multiple VPN gateways are active simultaneously for redundancy.  
- **Active-passive VPN gateway**: Configuration where one VPN gateway is active and the other is standby.  
- **Point-to-site VPN**: Allows individual computers to connect securely to the VPN gateway.  
- **ExpressRoute**: A private connection option that uses Microsoft’s global network backbone instead of the public Internet.

**Key Facts**  
- Minimum gateway subnet size is /29; recommended size is /27 for coexistence with S2S VPN and ExpressRoute.  
- Policy-based VPNs are only supported on basic SKU gateways and often require PowerShell or Azure CLI to create.  
- Route-based VPNs allow multiple tunnels and are the standard choice.  
- VPN traffic is encrypted but subject to Internet latency variability.  
- Microsoft’s global network includes regional gateways and peering points (“meet me’s”) for ExpressRoute connectivity.

**Examples**  
- Setting a gateway subnet with a /27 mask to allow coexistence of S2S VPN and ExpressRoute.  
- Using route-based VPN to establish multiple tunnels and enable point-to-site VPN for individual clients.  
- Configuring VPN gateways in active-active mode for redundancy on the customer side.

**Key Takeaways 🎯**  
- Prefer route-based VPNs over policy-based due to flexibility and modern support.  
- Plan gateway subnet size (/27 recommended) to support multiple connectivity options.  
- Use active-active or active-passive configurations to increase VPN resilience.  
- Understand that S2S VPNs use encrypted Internet connections, which may impact latency.  
- Consider ExpressRoute for private, more reliable connectivity over Microsoft’s backbone network.

---

## ExpressRoute

**Timestamp**: 01:50:34 – 01:56:09

**Key Concepts**  
- ExpressRoute provides private, dedicated connectivity between on-premises networks and Microsoft Azure, bypassing the public internet.  
- Microsoft’s global backbone network connects all Azure regions via resilient, redundant regional network gateways.  
- Peering points (also called "meet me’s") are carrier-neutral facilities where customer networks connect to Microsoft’s network.  
- ExpressRoute circuits connect customer networks to Microsoft’s backbone via cross connects at these peering points.  
- ExpressRoute gateways facilitate private peering, enabling private IP space connectivity between on-premises and Azure virtual networks.  
- Multiple ExpressRoute circuits can be used for redundancy and load balancing, with routing preferences managed via path prepending.  
- ExpressRoute Global Reach allows customers to connect multiple on-premises locations to each other over the Microsoft backbone via their ExpressRoute circuits.  
- ExpressRoute can coexist with Site-to-Site VPN, which can serve as a backup connectivity option.  
- Pricing is circuit-based; a Premium add-on enables connectivity to Azure regions outside the customer’s geopolitical boundary, access to Microsoft 365 services, and support for more advertised routes.  
- Microsoft peering on ExpressRoute allows private connectivity to Azure PaaS services (e.g., storage accounts, databases) without routing through a virtual network or private endpoints.  
- Route filters control which Microsoft services are accessible via Microsoft peering.  

**Definitions**  
- **ExpressRoute**: A service that provides private, dedicated network connectivity between a customer’s on-premises infrastructure and Microsoft Azure, using Microsoft’s global network backbone instead of the public internet.  
- **Peering Points / Meet Me’s**: Carrier-neutral data centers where different networks interconnect, enabling customers to connect their networks to Microsoft’s backbone.  
- **ExpressRoute Circuit**: The logical connection established between a customer’s network and Microsoft’s network at a peering point, enabling private connectivity.  
- **ExpressRoute Gateway**: A virtual network gateway in Azure that facilitates ExpressRoute private peering connectivity.  
- **Private Peering**: A type of ExpressRoute peering that connects private IP spaces between on-premises networks and Azure virtual networks.  
- **ExpressRoute Global Reach**: A feature that enables routing between multiple on-premises locations over the Microsoft backbone using ExpressRoute circuits.  
- **Microsoft Peering**: An ExpressRoute peering option that enables private connectivity to Microsoft Azure PaaS services using BGP route advertisements and route filters.  

**Key Facts**  
- Microsoft’s backbone network is global, resilient, and redundant, connecting all Azure regions.  
- Customers typically use carriers (e.g., MPLS providers) to extend their networks to peering points.  
- Multiple ExpressRoute circuits can be connected to a single ExpressRoute gateway for redundancy and traffic management.  
- ExpressRoute Global Reach allows on-premises sites to communicate via Microsoft’s backbone, not just to Azure.  
- Premium ExpressRoute circuits allow:  
  - Connectivity to Azure regions outside the customer’s geopolitical boundary  
  - Access to Microsoft 365 services over ExpressRoute  
  - Support for a larger number of advertised routes for complex networks  
- Microsoft peering requires route filters to specify which Azure PaaS services are accessible.  

**Examples**  
- Using multiple ExpressRoute circuits at different peering points for redundancy and backup routing.  
- Connecting multiple on-premises locations via ExpressRoute Global Reach to communicate over Microsoft’s backbone.  
- Accessing Azure PaaS services like storage accounts or databases privately via Microsoft peering without going through a virtual network.  

**Key Takeaways 🎯**  
- ExpressRoute offers a more reliable, private alternative to VPN over the internet by leveraging Microsoft’s global network.  
- It supports complex network topologies with multiple circuits, redundancy, and global connectivity between on-premises sites.  
- Premium circuits expand connectivity options and service access.  
- Microsoft peering enables private access to Azure PaaS services without requiring virtual network integration.  
- ExpressRoute can be combined with Site-to-Site VPN for backup or failover scenarios.  
- Understanding peering points, circuits, gateways, and route filters is essential for designing ExpressRoute connectivity.  
- ExpressRoute Global Reach is a powerful feature to interconnect multiple on-premises sites via Microsoft’s backbone, not just connect to Azure.

---

## Azure Virtual WAN

**Timestamp**: 01:56:09 – 01:58:36

**Key Concepts**  
- Azure Virtual WAN simplifies complex network connectivity by managing gateways and hub networks centrally.  
- Two SKUs available: Basic and Standard, each supporting different connectivity features.  
- Basic SKU supports site-to-site VPN only.  
- Standard SKU supports site-to-site VPN, ExpressRoute, transitive communication between VNets, and connectivity between multiple Virtual WANs (typically regional).  
- Standard SKU allows deployment of Azure Firewall and custom network virtual appliances within the Virtual WAN.  
- Routing in Virtual WAN can be controlled and overridden using User Defined Routes (UDRs).  

**Definitions**  
- **Azure Virtual WAN**: A managed service that centralizes and simplifies the creation and management of network connectivity, including VPNs, ExpressRoute, and VNet interconnectivity.  
- **Basic SKU**: Azure Virtual WAN option focused solely on site-to-site VPN connectivity.  
- **Standard SKU**: Azure Virtual WAN option that supports site-to-site VPN, ExpressRoute, user point-to-site VPN, intra-hub and VNet-to-VNet transitive routing, and integration with Azure Firewall and network virtual appliances.  
- **User Defined Routes (UDRs)**: Custom routing rules that override default routing policies to direct traffic to specific next hops such as Azure Firewall or network virtual appliances.  

**Key Facts**  
- Basic SKU = site-to-site VPN only.  
- Standard SKU = site-to-site VPN + ExpressRoute + user point-to-site + transitive routing between VNets and hubs + ability to connect multiple Virtual WANs.  
- Standard SKU supports deploying Azure Firewall and custom network virtual appliances inside the Virtual WAN.  
- Azure Virtual WAN is consumption-based; pricing depends on usage and SKU choice.  
- UDRs allow specifying next hop IP addresses for targeted IP spaces, enabling traffic routing through firewalls or appliances.  

**Examples**  
- Using UDRs to route traffic to an Azure Firewall’s private IP address by linking the UDR to a subnet.  

**Key Takeaways 🎯**  
- Azure Virtual WAN is designed to offload and simplify complex network connectivity tasks.  
- Choose Basic SKU for simple site-to-site VPN needs; choose Standard SKU for richer, more integrated connectivity scenarios including ExpressRoute and firewall integration.  
- Standard SKU is the typical choice for most enterprise environments due to its advanced features.  
- UDRs are essential for customizing traffic flow, such as forcing traffic through Azure Firewall or other network appliances.  
- Azure’s consumption-based pricing model means you pay according to the features and scale you use.

---

## User Defined Routes

**Timestamp**: 01:58:36 – 01:59:55

**Key Concepts**  
- Virtual networks have default routing based on gateways and services like Azure Route Server.  
- User Defined Routes (UDRs) allow overriding these default routes to customize traffic flow.  
- UDRs specify the next hop for specific IP address spaces, directing traffic to chosen network appliances or services.  
- UDRs are linked to subnets to enforce routing policies at that subnet level.  

**Definitions**  
- **User Defined Route (UDR)**: A custom route created to override the default routing behavior in an Azure virtual network by specifying a next hop IP address or service for particular IP address ranges.  

**Key Facts**  
- Default routes are learned automatically based on gateways and Azure Route Server integration.  
- UDRs enable directing traffic to virtual appliances such as Azure Firewall using their private IP addresses.  
- UDRs are applied at the subnet level by associating the route table containing the UDR with the subnet.  

**Examples**  
- To send traffic to an Azure Firewall, create a UDR that points the next hop for a target IP space to the private IP address of the Azure Firewall virtual appliance.  
- Linking the UDR to the subnet ensures all traffic from that subnet follows the defined route to the firewall.  

**Key Takeaways 🎯**  
- Use UDRs when you need to control or modify how traffic flows within your Azure virtual network beyond the default routing.  
- UDRs are essential for directing traffic through security appliances like Azure Firewall.  
- Always associate UDRs with the appropriate subnet to enforce the routing changes.  
- UDRs provide flexibility to integrate custom network virtual appliances into your routing architecture.  

---

## Service endpoints

**Timestamp**: 01:59:55 – 02:04:50

**Key Concepts**  
- Protecting communication to Azure PaaS services (e.g., storage accounts) beyond traditional network security groups (NSGs).  
- Public endpoints of PaaS services are exposed to the internet and do not have private IP addresses within a virtual network.  
- Service endpoints allow a subnet within a virtual network to be recognized by a specific Azure service, enabling controlled access.  
- Service endpoints create a more direct communication path between the subnet and the service, showing private IP addresses in logs.  
- Service endpoints are enabled per subnet and per service type, not across the entire virtual network.  
- Service endpoints allow restricting access to PaaS services only from selected subnets despite the service having a public endpoint.  
- Private endpoints are a more advanced option that assign a private IP address within the subnet to the PaaS service, removing exposure to the public endpoint.

**Definitions**  
- **Service Endpoint**: A feature that extends a virtual network subnet identity to an Azure service, allowing the subnet to be explicitly allowed to communicate with that service over a direct route, even though the service has a public endpoint.  
- **Public Endpoint**: The default network interface of many Azure PaaS services, exposed to the internet with no private IP address inside the virtual network.  
- **Private Endpoint**: A network interface with a private IP address in a subnet that connects privately and securely to a specific instance of an Azure service, eliminating exposure via public endpoints.

**Key Facts**  
- Service endpoints are configured by enabling them on a specific subnet for a particular service type (e.g., storage).  
- Once enabled, service endpoints allow firewall rules on the PaaS service to specify allowed subnets from virtual networks.  
- Logs on the service will show private IP addresses from the subnet instead of public IPs.  
- Service endpoints do not apply to other subnets unless explicitly enabled.  
- Storage accounts and other PaaS services have networking settings where service endpoints can be added or required.  
- Private endpoints create an IP address inside the subnet and connect directly to the service instance, providing a higher level of isolation.

**Examples**  
- Enabling a service endpoint on "subnet 3" of "VNet 1" to allow that subnet to communicate with a storage account.  
- Adding a virtual network and subnet to the storage account’s allowed networks after enabling the service endpoint.  
- Mention of multiple virtual networks in the environment where service endpoints can be enabled selectively.

**Key Takeaways 🎯**  
- Service endpoints enhance security by allowing PaaS services with public endpoints to restrict access only to specific subnets.  
- They do not remove the public endpoint but provide subnet-level access control and improved routing visibility.  
- Private endpoints provide a stronger security model by assigning private IPs and removing public endpoint exposure.  
- Always enable service endpoints on the exact subnet(s) that require access to the service.  
- Use service endpoints to simplify firewall rules on PaaS services by referencing virtual network subnets instead of IP ranges.

---

## Private endpoints

**Timestamp**: 02:04:50 – 02:08:03

**Key Concepts**  
- Private endpoints provide a way to connect to Azure services using an IP address within a private subnet, bypassing the public endpoint.  
- Private endpoints allow shutting off the public endpoint completely for enhanced security.  
- Private endpoints require special DNS configuration, typically using an Azure Private DNS zone, to resolve service names to the private IP address.  
- Private endpoints enable connectivity across different subnets, VNets, and even on-premises networks, as they are IP-based.  
- Private Link Service can be used with a standard load balancer to expose custom services privately without peering VNets.  
- Private endpoints support TLS because the service name resolves correctly to the private IP, allowing certificate validation.  

**Definitions**  
- **Private Endpoint**: An IP address allocated from a subnet that connects privately to a specific instance of an Azure service, eliminating the need for a public endpoint.  
- **Azure Private DNS Zone**: A DNS zone used to resolve service names to private IP addresses associated with private endpoints.  
- **Private Link Service**: A service that allows you to expose your own services privately via private endpoints, often used with a standard load balancer to enable secure access without VNet peering.  

**Key Facts**  
- Private endpoints allocate an IP address from your subnet to connect to a specific service instance.  
- Public endpoints can be completely disabled when using private endpoints.  
- DNS must be configured so that the service name resolves to the private IP address to maintain TLS security.  
- Private endpoints can be accessed from different subnets, VNets, and on-premises networks, unlike service endpoints which are limited to the subnet.  
- Private Link Service performs NAT (Network Address Translation) to enable private connectivity to custom services behind a standard load balancer.  

**Examples**  
- Storage Account Two: Instead of using the public endpoint, a private endpoint is created in a subnet with an IP address that connects privately to the storage account.  
- Custom service behind a standard load balancer: Using Private Link Service, private endpoints can be created to access this service without peering VNets, even if IP ranges overlap.  

**Key Takeaways 🎯**  
- Private endpoints enhance security by eliminating exposure to public endpoints and restricting access to private IPs within your network.  
- Proper DNS setup is critical to ensure service names resolve to private IPs, enabling TLS and connectivity.  
- Private endpoints provide flexible connectivity options across VNets and on-premises without requiring VNet peering.  
- Private Link Service extends private endpoint capabilities to custom services, enabling secure, private access via standard load balancers.  
- Using private endpoints is a best practice to avoid assigning public IPs directly to VMs or services, reducing attack surface.  

---

## Azure Bastion

**Timestamp**: 02:08:03 – 02:10:24

**Key Concepts**  
- Azure Bastion provides secure remote access to virtual machines (VMs) without exposing public IP addresses.  
- Acts as a managed jump box for RDP and SSH connections.  
- Integrates with Azure Entra for enhanced security via conditional access policies.  
- Deploys into a dedicated subnet called the Azure Bastion subnet.  
- Different SKUs (Basic, Standard) offer varying levels of functionality and scalability.  

**Definitions**  
- **Azure Bastion**: A managed service that enables secure and seamless RDP/SSH connectivity to VMs directly through the Azure portal or CLI without exposing public IP addresses.  
- **Azure Bastion Subnet**: A dedicated subnet (with a /26 address space) where the Azure Bastion service is deployed.  

**Key Facts**  
- Azure Bastion subnet size: /26.  
- Basic SKU: Connects only to VMs within the same virtual network.  
- Standard SKU:  
  - Supports connections to VMs in paired virtual networks.  
  - Allows RDP to Linux VMs and SSH to Windows VMs (cross-platform support).  
  - Enables connection via Azure CLI (not just the portal).  
  - Offers better scaling and additional features like shareable links and disabling copy-paste in web clients.  

**Examples**  
- Using Azure Bastion to connect from the internet to VMs securely without assigning public IPs.  
- Conditional access policies requiring strong authentication before allowing access to the Bastion service.  

**Key Takeaways 🎯**  
- Avoid assigning public IP addresses directly to VMs for security reasons; use Azure Bastion instead.  
- Azure Bastion simplifies secure remote management by acting as a managed jump box.  
- Choose the SKU based on your connectivity needs—Basic for single VNet, Standard for multi-VNet and advanced features.  
- Integration with Azure Entra enhances security through conditional access controls.  
- Azure Bastion improves operational security and management efficiency for VM access.  

---

## Load balancing

**Timestamp**: 02:10:24 – 02:12:03

**Key Concepts**  
- Load balancing is critical for service availability.  
- There are two levels of load balancing: global and regional.  
- Global load balancing provides a single endpoint for clients regardless of resource location.  
- Regional load balancing provides high availability within a region by distributing traffic across multiple instances.  
- Different load balancing solutions apply depending on the service type and network layer.  
- Layer 7 load balancing (application layer) handles HTTP, HTTPS, WebSockets, etc.  
- Layer 4 load balancing (transport layer) handles TCP and UDP traffic.

**Definitions**  
- **Global Load Balancing**: A load balancing approach that provides one endpoint to clients that routes traffic to resources across multiple regions.  
- **Regional Load Balancing**: Load balancing within a single region to distribute traffic among multiple instances for high availability.  
- **Layer 7 Load Balancing**: Load balancing at the application layer, understanding protocols like HTTP and HTTPS. Azure Application Gateway is an example.  
- **Layer 4 Load Balancing**: Load balancing at the transport layer, handling protocols like TCP and UDP. Azure Load Balancer is an example.

**Key Facts**  
- Azure Application Gateway is the Layer 7 load balancing solution.  
- Azure Load Balancer operates at Layer 4.  
- Both global and regional load balancing are necessary for comprehensive availability and scalability.

**Examples**  
- Azure Application Gateway for HTTP/HTTPS and WebSocket traffic (Layer 7).  
- Azure Load Balancer for TCP and UDP traffic (Layer 4).

**Key Takeaways 🎯**  
- Understand the difference between global and regional load balancing and their roles in availability.  
- Choose load balancing solutions based on the network layer and protocol requirements of your service.  
- Use Azure Application Gateway for web-based (Layer 7) traffic.  
- Use Azure Load Balancer for transport layer (Layer 4) traffic such as TCP and UDP.

---

## Azure Load Balancer

**Timestamp**: 02:12:03 – 02:18:13

**Key Concepts**  
- Azure Load Balancer operates at Layer 4 (Transport Layer), handling TCP and UDP traffic.  
- It uses front-end IP addresses which can be either internal or external.  
- Back-end pools contain the target resources (NICs or IP addresses) that receive balanced traffic.  
- Health probes monitor the availability of back-end pool instances.  
- Load balancing rules define how traffic is distributed based on tuples (5-tuple, 3-tuple, 2-tuple).  
- NAT rules can be configured for specific traffic redirection.  
- Two SKUs exist: Basic (free) and Standard (paid), with different capabilities and SLAs.  
- Floating IP allows the back-end resource to see the front-end IP instead of its own IP.  

**Definitions**  
- **Azure Load Balancer**: A Layer 4 load balancing service in Azure that distributes incoming TCP/UDP traffic across multiple back-end resources.  
- **Front-end IP**: The IP address exposed by the load balancer to receive incoming traffic; can be internal or external.  
- **Back-end Pool**: A group of IP addresses or NICs that receive traffic from the load balancer.  
- **Health Probe**: A mechanism to check the health and availability of back-end pool members.  
- **Load Balancing Rule**: Configuration that maps incoming traffic to back-end pool members based on matching tuples.  
- **Tuples**: Sets of parameters used to define traffic matching rules:  
  - 5-tuple: destination IP, source IP, destination port, source port, protocol  
  - 3-tuple: destination IP, source IP, protocol  
  - 2-tuple: destination IP, source IP (ignores protocol)  
- **Floating IP**: A rule where the back-end resource sees the front-end IP address as the source IP, avoiding IP rewriting.  
- **Basic SKU (Free)**: Older SKU with limited scale (up to 300 back-end instances), no SLA, and being deprecated by September 30, 2025.  
- **Standard SKU**: Modern SKU supporting up to 1000 back-end instances, availability zones, SLA-backed, requires resources in the same VNet, and supports both NICs and IP addresses in back-end pools.  

**Key Facts**  
- Basic SKU supports up to ~300 back-end instances; no SLA; deprecated and retiring on September 30, 2025.  
- Standard SKU supports up to 1000 back-end instances.  
- Load balancer and back-end resources must be in the same virtual network (no cross-VNet load balancing).  
- Standard SKU supports availability zones and has an SLA.  
- Public IP addresses must match the SKU of the load balancer (Standard with Standard, Basic with Basic).  
- Standard SKU public IPs are locked down by default; outbound rules must be explicitly added for internet access.  
- Basic SKU only supports NICs in back-end pools; Standard SKU supports both NICs and IP addresses (useful for AKS pods which have IP addresses but no NICs).  
- Health probes can be TCP, HTTP, or HTTPS for Standard SKU.  
- Floating IP rules preserve the front-end IP address in traffic sent to back-end resources.  

**Examples**  
- AKS pods can be part of the back-end pool using their IP addresses (Standard SKU).  
- Floating IP useful to avoid IP rewriting in certain communication scenarios.  

**Key Takeaways 🎯**  
- Use Standard SKU for production workloads due to scale, SLA, and feature support; Basic SKU is deprecated.  
- Load balancer front-end IP can be internal or external, but only one type per load balancer instance.  
- Understand tuple-based rules to control session persistence ("stickiness") to back-end pool members.  
- Standard SKU requires back-end resources to be in the same VNet as the load balancer.  
- Floating IP rules are important when you want back-end resources to see the original front-end IP.  
- For web-based applications requiring Layer 7 features, prefer Azure Application Gateway over Azure Load Balancer.  
- Recent updates allow disabling public IP on load balancer front-end and optionally using private IPs.

---

## Azure App Gateway

**Timestamp**: 02:18:13 – 02:25:01

**Key Concepts**  
- Azure Application Gateway (App Gateway) is a Layer 7 load balancer focused on HTTP, HTTPS, HTTP2, and WebSocket traffic.  
- It provides richer functionality than a standard Layer 4 load balancer (like Azure Standard Load Balancer).  
- Supports front-end IP configurations that can be public, private, or optionally none (new feature).  
- Deploys into a subnet within a virtual network; recommended subnet size is /24 for scalability.  
- Supports Web Application Firewall (WAF) integration for protection against common web vulnerabilities.  
- Supports URL-based routing, redirection, SSL/TLS termination, session affinity, and header rewriting.  
- Supports dual stack IP addressing (IPv4 and IPv6).  
- Uses listeners to listen on specific ports and apply routing rules.  
- Supports multisite listeners allowing multiple fully qualified domain names (FQDNs) on the same IP and port.  
- Backend pools are flexible and can include VMs, VM scale sets, IP addresses, FQDNs, and app services, including on-premises resources via VPN or ExpressRoute.  
- Health probes monitor backend target availability.  
- App Gateway is regional; for global load balancing, Azure Traffic Manager (DNS-based) can be used.

**Definitions**  
- **Floating IP**: A feature where the backend pool member sees the frontend IP address instead of its own IP, useful for certain communication scenarios.  
- **Listener**: A configuration on the App Gateway that listens on a specific port and protocol for incoming traffic.  
- **Rule**: Defines how traffic received by a listener is routed to backend pools; can be basic (all traffic to one backend) or path-based.  
- **Web Application Firewall (WAF)**: A security feature integrated with App Gateway that protects against common web vulnerabilities as defined by OWASP.  
- **Multisite Listener**: Allows multiple listeners on the same port differentiated by the hostname (FQDN) in the request, enabling hosting multiple sites on one IP and port.  
- **SSL/TLS Termination**: Offloading the SSL/TLS decryption from backend servers to the App Gateway.

**Key Facts**  
- Previously, App Gateway required a public IP; now public IP is optional and private IP can be used.  
- V2 SKU supports autoscaling and zone redundancy but remains regional.  
- V1 SKU supports up to 32 instances; subnet size recommendations differ accordingly (/26 for V1, /24 recommended for V2).  
- WAF is a paid add-on feature.  
- App Gateway supports session affinity via cookies.  
- Backend pools can include Azure resources or on-premises endpoints via VPN/ExpressRoute or even public IPs.  
- Health probes are used to check backend availability.  
- App Gateway supports both IPv4 and IPv6 (dual stack).  

**Examples**  
- Redirecting HTTP traffic to HTTPS using URL-based routing.  
- Using multisite listeners to host multiple fully qualified domain names on the same IP and port (e.g., multiple sites on port 443).  
- Offloading SSL/TLS termination at the gateway to reduce load on backend servers.  

**Key Takeaways 🎯**  
- Azure App Gateway is ideal for web-based applications needing advanced Layer 7 load balancing features.  
- It offers flexible frontend IP configurations and backend pool targets, including hybrid scenarios.  
- WAF integration enhances security against common web attacks.  
- Multisite listeners and path-based routing enable hosting multiple sites and complex routing rules on a single gateway.  
- SSL/TLS termination and session affinity improve performance and user experience.  
- App Gateway is regional; for global distribution, combine with Azure Traffic Manager.  
- Proper subnet sizing is important for scalability and instance limits.

---

## Azure Traffic Manager

**Timestamp**: 02:25:01 – 02:26:51

**Key Concepts**  
- Azure Traffic Manager operates at the DNS level to route traffic globally.  
- It resolves a DNS name to one of multiple possible endpoints based on routing methods.  
- It is agnostic to the protocol layer (works for both layer 4 and layer 7).  
- Supports multiple routing methods including performance-based, priority, weighted, geographic, multi-value, and subnet-based routing.  
- Can route traffic to various Azure endpoints such as PaaS services, web apps, public IPs, IPv4/IPv6 addresses, nested endpoints, or even other Traffic Manager profiles.  
- Time to live (TTL) can be configured to control DNS record caching duration.

**Definitions**  
- **Azure Traffic Manager**: A DNS-based global traffic routing service that directs client requests to the most appropriate endpoint based on configured routing methods.  

**Key Facts**  
- Traffic Manager uses DNS resolution to direct traffic, not direct packet forwarding.  
- It supports routing to any endpoint reachable by DNS, including Azure services and external IP addresses.  
- Routing methods include priority, weighted, performance (closest endpoint), geographic, multi-value, and subnet.  
- TTL setting controls how long DNS responses are cached before re-querying for updated routing.  
- Can be nested by pointing to another Traffic Manager profile for complex routing scenarios.

**Examples**  
- Performance routing sends users to the closest instance geographically.  
- Traffic Manager can route to a web app, a public IP, or another Traffic Manager profile.  

**Key Takeaways 🎯**  
- Azure Traffic Manager is a flexible, DNS-based global load balancing solution.  
- It is protocol-agnostic and can route to a wide variety of endpoints.  
- Choosing the right routing method (performance, priority, weighted, geographic) is critical for optimal traffic distribution.  
- TTL settings impact how quickly DNS changes propagate to clients.  
- Nested Traffic Manager profiles enable complex, multi-level routing strategies.

---

## Azure Cross Region Load Balancer

**Timestamp**: 02:26:51 – 02:28:09

**Key Concepts**  
- Cross region Load Balancer operates at Layer 4 (transport layer).  
- Provides a global IP address that is public and can route traffic to multiple regional load balancers.  
- Uses anycast IP addressing to direct clients to the closest available regional endpoint.  
- Designed for high availability and resilience both within a region and across regions.  
- Supports global failover: if one region goes down, traffic is routed to another region.  
- Layer 7 global load balancing is handled separately by Azure Front Door.

**Definitions**  
- **Cross Region Load Balancer**: A Layer 4 global load balancing solution in Azure that provides a single public IP address routing traffic to multiple regional load balancers using anycast.  
- **Anycast IP**: An IP addressing method where the same IP is advertised from multiple locations, and client traffic is routed to the nearest or best-performing endpoint.

**Key Facts**  
- The cross region Load Balancer uses a public global IP address.  
- It points to "N" number of regional load balancers (scalable to multiple regions).  
- Microsoft WAN provides the anycast presence and routing.  
- It is primarily a Layer 4 solution for public services.  
- Focus on resilience at all levels: regional and global.

**Examples**  
- None explicitly mentioned, but the concept involves clients connecting to a global IP that routes to the closest regional load balancer.

**Key Takeaways 🎯**  
- Use Azure Cross Region Load Balancer for global Layer 4 load balancing with a single public IP.  
- It ensures high availability by routing traffic to healthy regional endpoints and providing failover across regions.  
- Anycast IP addressing enables clients to connect to the nearest regional load balancer automatically.  
- For Layer 7 global load balancing, Azure Front Door is the recommended service.  
- Important to design for resilience both within regions and globally.

---

## Azure Front Door

**Timestamp**: 02:28:09 – 02:31:50

**Key Concepts**  
- Azure Front Door is a Layer 7 global, public load balancing solution.  
- Provides high availability and resilience both within regions and globally.  
- Integrates Web Application Firewall (WAF) for protection against common attacks.  
- Supports SSL offloading, cookie-based affinity, URL redirection, and URL rewrite.  
- Uses Microsoft’s global WAN with multiple points of presence worldwide.  
- Employs Anycast IP addressing for global accessibility.  
- Utilizes split TCP to establish client connections close to the user, improving performance.  
- Fetches content over Microsoft’s backbone network, enabling fast and reliable data delivery.  
- Supports optional caching to accelerate content delivery for subsequent requests.  
- Can route traffic to multiple backend targets, including Azure App Gateways or other public endpoints.  
- Backends must be publicly accessible (public IP and DNS).  
- Supports cross-region and cross-zone scenarios, and can include non-Azure public endpoints.  
- Available in different SKUs: Standard and Premium (Classic SKU is less relevant).  
- Premium SKU includes advanced features like Microsoft-managed WAF rule sets and bot protection.  
- Features path-based routing and a rules engine for flexible traffic management.

**Definitions**  
- **Azure Front Door**: A Layer 7 global load balancer and application delivery network service that provides secure, fast, and reliable access to applications by routing traffic through Microsoft’s global network.  
- **Anycast IP**: A single IP address advertised from multiple locations, allowing clients to connect to the nearest point of presence.  
- **Split TCP**: A technique where the client establishes a TCP and TLS session with a nearby edge location, and the edge location fetches content from the backend over the Microsoft backbone network.  
- **Web Application Firewall (WAF)**: A security feature that protects web applications from common exploits and vulnerabilities.

**Key Facts**  
- Azure Front Door operates at Layer 7 (application layer).  
- It provides a publicly resolvable DNS name and public IP address.  
- Supports SSL offloading and cookie-based affinity.  
- Caching can be enabled to improve performance for repeated requests.  
- Multiple backend targets can be configured for failover and load balancing.  
- Premium SKU includes bot protection and managed WAF rule sets.  
- Can route traffic to backends outside of Azure as long as they are publicly accessible.

**Examples**  
- Backend targets commonly include Azure App Gateways, which can be regional or global.  
- The service can accelerate content delivery by caching after the first request.

**Key Takeaways 🎯**  
- Azure Front Door is ideal for global, public-facing applications requiring high availability and performance.  
- It leverages Microsoft’s global network to optimize client connections and backend data retrieval.  
- Security is enhanced through integrated WAF and bot protection, especially in the Premium SKU.  
- Supports flexible routing and backend configurations, including non-Azure public endpoints.  
- Understanding Azure Front Door’s networking features is crucial for designing resilient and performant cloud applications.

---

## Storage accounts

**Timestamp**: 02:31:50 – 02:42:07

**Key Concepts**  
- Azure storage accounts are the fundamental building blocks for durable, persistent storage in Azure.  
- Storage accounts live in a specific Azure region and have configurable performance and redundancy options.  
- General Purpose v2 (GPv2) storage accounts are the most commonly used and support blobs, queues, tables, and files.  
- Premium storage options exist, typically service-specific and based on SSD technology, with different billing models.  
- Azure Blob storage supports block blobs (common for multimedia), page blobs (used mainly for disks), and append blobs (for logging scenarios).  
- Azure Files supports SMB and NFS protocols for file shares.  
- Azure Tables provide schemaless key-value storage with partition and row keys.  
- Azure Queues provide FIFO message queuing.  
- Redundancy options determine how many copies of data exist and where they are stored to ensure resiliency.

**Definitions**  
- **Storage Account**: A container in Azure that holds all storage data objects like blobs, files, queues, and tables, scoped to a region with specific performance and redundancy settings.  
- **General Purpose v2 (GPv2)**: The default and most versatile storage account type supporting all storage services with standard performance.  
- **Premium Storage**: Storage backed by SSDs, service-specific, and often billed based on provisioned size rather than actual data usage (notably for premium file shares).  
- **Block Blob**: Blob type optimized for storing large files such as multimedia.  
- **Page Blob**: Blob type optimized for random read/write operations, historically used for disks.  
- **Append Blob**: Blob type optimized for append operations, such as logging.  
- **Locally Redundant Storage (LRS)**: Stores 3 copies of data within a single storage cluster in the same region.  
- **Zone-Redundant Storage (ZRS)**: Stores 3 copies of data spread across availability zones within the same region.  
- **Geo-Redundant Storage (GRS)**: Stores 3 copies in the primary region and asynchronously replicates 3 copies to a paired secondary region (6 copies total).  
- **Geo-Zone-Redundant Storage (GZRS)**: Combines ZRS in the primary region with asynchronous replication to a secondary region (6 copies total).  
- **Read-Access Geo-Redundant Storage (RA-GRS/RA-GZRS)**: Allows read access to the secondary (replica) region for blob data.

**Key Facts**  
- Storage accounts must be named and assigned to a specific Azure region.  
- General Purpose v2 is the recommended and most common storage account type; General Purpose v1 and standard block blob accounts are generally avoided.  
- Premium file shares charge based on provisioned size, not actual data written, because performance scales with provisioned size.  
- Storage Explorer is a powerful tool to interact with storage accounts, allowing viewing and manipulation of blobs, files, queues, and tables.  
- Tables are schemaless, storing key-value pairs with partition and row keys.  
- Redundancy options:  
  - LRS: 3 copies in one cluster  
  - ZRS: 3 copies across availability zones in a region  
  - GRS: 3 copies in primary + 3 copies asynchronously replicated to secondary region  
  - GZRS: ZRS in primary + async replication to secondary region  
- Asynchronous replication means data is acknowledged as stored once in primary region; replication to secondary happens in the background to avoid latency impact.  
- Firewall and network restrictions can be applied to storage accounts (service endpoints, private endpoints).  
- Hierarchical namespace can be enabled for blob storage to support POSIX-style ACLs.

**Examples**  
- Using Storage Explorer to:  
  - View containers and files in a storage account  
  - Add and dequeue messages in a queue  
  - Add schemaless entities to a table with custom properties  
- Explanation of premium file shares billing based on provisioned size, not actual data written.  
- Explanation of redundancy with copies spread across availability zones or paired regions.

**Key Takeaways 🎯**  
- Always use General Purpose v2 storage accounts unless you have a specific premium need.  
- Understand the difference between standard and premium storage, especially billing implications for premium file shares.  
- Choose redundancy options based on your resiliency and availability requirements; higher redundancy means more copies and geographic spread.  
- Use Storage Explorer as a practical tool for managing and interacting with storage accounts.  
- Asynchronous geo-replication ensures durability without impacting application latency.  
- Enable hierarchical namespace if you need POSIX-style ACLs on blob storage.  
- Secure storage accounts with firewall and network restrictions to control access.

---

## Storage tools

**Timestamp**: 02:42:07 – 02:44:20

**Key Concepts**  
- Multiple tools and methods exist to interact with Azure Storage accounts.  
- Storage Explorer is a powerful graphical tool for managing storage data.  
- AZCopy is a command-line tool for efficient data transfer, including server-side asynchronous copy.  
- Data Box and Data Disk enable large-scale physical data migration to/from Azure data centers.  
- Data Factory supports creating pipelines for bulk data movement and ETL (Extract, Transform, Load) operations.  
- Blob Fuse allows mounting Blob storage as a filesystem in Linux environments.  
- Storage accounts can be secured with firewall rules restricting access to service or private endpoints.  
- Different resiliency and cost optimization options are available for Blob storage, including tiering.

**Definitions**  
- **Storage Explorer**: A graphical tool to upload, download, and manipulate data in Azure Storage accounts.  
- **AZCopy**: A command-line utility to efficiently upload, download, and copy data between storage accounts, supporting server-side asynchronous copy to avoid client-side data transfer.  
- **Server-side asynchronous copy**: A method where data is copied directly between storage accounts in the cloud without routing through the client, improving efficiency.  
- **Data Box / Data Disk**: Physical devices used to migrate large volumes of data by shipping disks or units to Azure data centers for import/export.  
- **Data Factory**: A service to create data pipelines for bulk data movement and ETL processes.  
- **Blob Fuse**: A tool to mount Azure Blob storage as a file system on Linux machines.

**Key Facts**  
- Server-side asynchronous copy avoids downloading data to the client during copy operations between storage accounts.  
- Data Box and Data Disk facilitate large-scale migrations without relying on network transfer.  
- Storage accounts can be restricted via firewall rules to service endpoints or private endpoints for enhanced security.  
- Blob storage costs depend on both capacity used and the number of interactions (operations).  
- Blob storage supports tiering (hot, cool, etc.) to optimize cost based on access patterns.

**Examples**  
- Using Storage Explorer to upload and manipulate data.  
- Using AZCopy to perform server-side asynchronous copy between storage accounts.  
- Employing Data Box to physically ship data for large-scale migration.  
- Mounting Blob storage on Linux using Blob Fuse.

**Key Takeaways 🎯**  
- Choose the right tool based on your scenario: GUI (Storage Explorer), CLI (AZCopy), physical migration (Data Box), or pipeline automation (Data Factory).  
- Server-side asynchronous copy is highly efficient for large data transfers between storage accounts.  
- Consider security by restricting storage account access with firewall and endpoint configurations.  
- Optimize costs by understanding that you pay for both storage capacity and operations, and leverage blob tiering accordingly.  
- Blob Fuse enables seamless integration of Blob storage with Linux file systems for easier data access.

---

## Blob tiering

**Timestamp**: 02:44:20 – 02:49:05

**Key Concepts**  
- Blob storage supports tiering to optimize cost based on data access patterns.  
- Four blob tiers available: Hot, Cool, Cold, and Archive.  
- Tiering can be set at the individual blob level.  
- Costs depend on both storage capacity and transaction frequency.  
- Lifecycle management can automate tier transitions and deletions.

**Definitions**  
- **Hot tier**: Highest storage cost but lowest transaction cost; ideal for frequently accessed data.  
- **Cool tier**: Lower storage cost than Hot, higher transaction cost; suitable for infrequently accessed data.  
- **Cold tier**: Even lower storage cost, higher transaction cost; for rarely accessed data that must be instantly available.  
- **Archive tier**: Lowest storage cost, no immediate access; data is offline and requires rehydration (can take 12-13 hours) to access.  

**Key Facts**  
- Storage cost decreases from Hot → Cool → Cold → Archive.  
- Transaction costs increase from Hot → Cool → Cold → Archive (due to retrieval overhead).  
- Archive data must be rehydrated before access, which can take hours.  
- Minimum retention periods apply:  
  - Cool: 30 days  
  - Cold: 90 days  
  - Archive: 180 days  
- Early deletion before minimum retention results in billing for the remaining days.  
- Blob tiering can be mixed within a single container (some blobs Hot, some Cool, Cold, or Archive).  
- Archive blobs cannot be downloaded directly; they must be moved to an online tier first.  
- Cold tier blobs are online and can be downloaded immediately.  

**Examples**  
- A container with mixed tiers: some blobs in Hot (default), some in Cool, Cold, and one in Archive.  
- Archive blob’s download option is disabled (grayed out) because it is offline.  
- Cold tier blobs can be downloaded directly despite higher transaction costs.  

**Key Takeaways 🎯**  
- Choose blob tiers based on access frequency to optimize costs.  
- Remember minimum retention periods to avoid unexpected charges.  
- Use lifecycle management policies to automate tier transitions and deletions based on criteria like last access time or blob name.  
- Archive tier is best for long-term retention when immediate access is not required.  
- Mixing tiers within containers is supported, allowing flexible cost management.  
- Manual tier management is possible but lifecycle management is recommended for efficiency.

---

## Lifecycle management

**Timestamp**: 02:49:05 – 02:50:22

**Key Concepts**  
- Lifecycle management automates data tiering based on rules and filters.  
- Rules can move data between access tiers (hot, cool, cold, archive) based on criteria like last access time, creation, or modification date.  
- Lifecycle management can also automate deletion after a certain period.  
- Filters can be based on blob name, BLOB index keys, or other metadata.  
- Automation helps avoid manual and cumbersome tier management.  

**Definitions**  
- **Lifecycle management**: A system to create rules that automatically move or delete data based on access patterns, age, or other filters to optimize storage costs and accessibility.  
- **Access tiers**: Different storage performance and cost levels (e.g., hot, cool, cold, archive) that data can be moved between depending on usage.  

**Key Facts**  
- Example rules:  
  - Move data to cool tier if not accessed for 15 days.  
  - Move data to cold tier if not accessed for 45 days.  
  - Move data to archive tier if not accessed for 135 days.  
- Changing data from archive tier to online tier for access can take hours.  
- Filters for lifecycle rules can include blob name patterns and BLOB index keys.  

**Examples**  
- Created lifecycle rules that move blobs to cool after 15 days of no access, to cold after 45 days, and to archive after 135 days.  

**Key Takeaways 🎯**  
- Automate data tiering with lifecycle management to optimize storage costs and access efficiency.  
- Respect minimum retention times when setting lifecycle rules to avoid premature deletion or tier changes.  
- Use filters like blob names or index keys to target specific data sets for tiering.  
- Manual tier changes, especially from archive, can be time-consuming; automation reduces operational overhead.

---

## Object replication

**Timestamp**: 02:50:22 – 02:52:45

**Key Concepts**  
- Object replication enables copying data at the container level between storage accounts.  
- Provides flexibility beyond the default paired region replication.  
- Allows replication across different storage accounts and regions.  
- Supports adding filters to control what data gets replicated.  
- Enables creation of custom replication rules between containers in different storage accounts.

**Definitions**  
- **Object replication**: A feature that allows copying blobs from one container in a storage account to another container in a different storage account, potentially in a different region, with customizable rules and filters.

**Key Facts**  
- Default replication is limited to paired regions and cannot be configured beyond that.  
- Object replication allows replication to any storage account and container, not limited to paired regions.  
- Replication rules can be defined to specify which containers replicate to which targets.  
- Filters can be applied to control the scope of replication.

**Examples**  
- Copying data from "container one" in one storage account to a container in "storage account two" or "storage account three" in different regions.  
- Setting rules like "everything in this container copies to that container" across different storage accounts.

**Key Takeaways 🎯**  
- Object replication offers greater control and flexibility over data replication compared to default paired-region replication.  
- It enables cross-region and cross-account replication with customizable rules and filters.  
- Useful for scenarios requiring replication beyond the paired region or involving multiple storage accounts.  
- Important to understand this feature when designing data redundancy and disaster recovery strategies in Azure Blob Storage.

---

## Azure Files

**Timestamp**: 02:52:45 – 02:56:41

**Key Concepts**  
- Azure Files provides fully managed file shares in the cloud, accessible via SMB protocol.  
- Supports multiple performance tiers: transaction optimized, hot, cool, and premium storage accounts.  
- Features include soft delete, backup snapshots, and integration with Azure AD (Entra ID) for data plane access control.  
- Azure File Sync enables synchronization between on-premises Windows file shares and Azure Files.  
- Tiering capability in Azure File Sync allows offloading less-used files to the cloud to save local storage space.  

**Definitions**  
- **Azure Files**: A cloud service that offers fully managed file shares accessible via SMB protocol, supporting various performance tiers and data protection features.  
- **Soft Delete**: A feature that allows recovery of deleted files for a configurable retention period (between 1 and 365 days).  
- **Azure File Sync**: A service that synchronizes file shares between on-premises Windows servers and Azure Files, enabling hybrid file storage solutions.  
- **Sync Group**: A logical grouping in Azure File Sync that contains one cloud endpoint and up to 100 server endpoints to synchronize data.  
- **Tiering**: A feature in Azure File Sync that moves infrequently accessed files to the cloud while keeping placeholders locally, freeing up on-premises storage.  

**Key Facts**  
- Soft delete retention can be set from 1 up to 365 days; default example given is 14 days.  
- Backup snapshots can be configured to capture point-in-time states of file shares.  
- Azure File Sync supports up to 100 server endpoints per sync group, with exactly one cloud endpoint.  
- Tiering triggers when local free space drops below a configured threshold, offloading least used files to Azure Files.  
- Azure Files integrates with Entra ID (Azure AD) for data plane permissioning, similar to Azure Blob storage.  

**Examples**  
- A user has multiple Windows file shares on-premises and creates an Azure Files SMB share in the cloud. Using Azure File Sync, these shares can be synchronized to the cloud endpoint.  
- Tiering example: When local file server space is low, least used files are tiered to Azure Files, leaving a thumbnail/link locally that fetches the file on demand.  

**Key Takeaways 🎯**  
- Azure Files offers flexible, tiered cloud file storage with strong data protection features like soft delete and snapshots.  
- Azure File Sync bridges on-premises and cloud file shares, enabling hybrid scenarios and seamless data access.  
- Tiering helps manage limited on-premises storage by offloading cold data to the cloud without disrupting user access.  
- Integration with Azure AD enhances security by enabling granular access control at the data plane level.  
- Having two storage account access keys allows seamless key regeneration without service interruption.  

---

## Access

**Timestamp**: 02:56:41 – 03:00:30

**Key Concepts**  
- Storage account access keys and their management  
- Role-Based Access Control (RBAC) on the data plane for granular permissions  
- Shared Access Signatures (SAS) for scoped, time-limited access  
- Encryption options for storage data  

**Definitions**  
- **Access Keys**: Two keys provided per storage account to authenticate and authorize access; having two allows key rotation without service interruption.  
- **Data Plane Role-Based Access Control (RBAC)**: Permissions assigned to users or service principals specifically for data operations (e.g., Blob Data Reader, Blob Data Contributor).  
- **Shared Access Signature (SAS)**: A token signed by an access key that grants limited and time-bound access to storage resources at either the account or service level.  
- **Customer Managed Key (CMK)**: Encryption key stored and managed in Azure Key Vault, used instead of platform-managed keys for encrypting storage data.  

**Key Facts**  
- Storage accounts have two access keys to enable seamless key regeneration and rotation.  
- RBAC roles include Blob Data Reader, Blob Data Contributor, Blob Data Owner, File Data, Queue Data, and Table Data roles.  
- Access keys can be disabled to block their use entirely; however, disabling access keys also disables SAS tokens since SAS tokens are signed by access keys.  
- SAS tokens allow granular control over permissions, services, time validity, and IP ranges.  
- Encryption by default uses Microsoft-managed platform keys; customers can opt for customer-managed keys via Azure Key Vault.  

**Examples**  
- Regenerating one access key while using the other to avoid service interruption.  
- Creating a shared access signature at the storage account level with specific permissions, time frames, and IP restrictions.  
- Creating a service-level SAS token with defined properties and duration.  

**Key Takeaways 🎯**  
- Use two access keys to enable seamless key rotation without downtime.  
- Prefer RBAC on the data plane over using access keys for better security and granular permissions.  
- Understand that disabling access keys disables SAS tokens, so plan accordingly.  
- Leverage SAS tokens for fine-grained, temporary access control to storage resources.  
- Consider customer-managed keys for encryption if you require control over key management beyond the default platform-managed keys.

---

## Encryption

**Timestamp**: 03:00:30 – 03:02:54

**Key Concepts**  
- Encryption in Azure Storage by default uses platform-managed keys (Microsoft-managed).  
- Customer-managed keys allow users to control encryption keys via Azure Key Vault.  
- Users are responsible for key rotation when using customer-managed keys.  
- Azure Key Vault supports auto rotation policies and Azure Policy can alert on key expiry (e.g., less than 30 days remaining).  
- Encryption scopes enable the use of different encryption keys at granular levels such as containers or individual blobs within a storage account.  
- Encryption scopes provide flexibility without needing separate storage accounts for different encryption keys.  
- Blob uploads can specify an encryption scope if no container-level scope is set.  

**Definitions**  
- **Platform-managed keys**: Encryption keys managed by Microsoft by default for Azure Storage encryption.  
- **Customer-managed keys**: Encryption keys managed by the customer, stored in Azure Key Vault, giving more control over encryption and key rotation.  
- **Encryption scopes**: Configurations that allow different encryption keys to be applied at the container or blob level within the same storage account.  

**Key Facts**  
- Azure Key Vault can automate key rotation and provide alerts when keys are nearing expiration (e.g., less than 30 days left).  
- Encryption scopes allow multiple keys to be used within a single storage account, avoiding the need for multiple storage accounts for different encryption keys.  

**Examples**  
- An Independent Software Vendor (ISV) providing services to multiple customers can use encryption scopes to assign different encryption keys per customer without creating separate storage accounts.  

**Key Takeaways 🎯**  
- By default, Azure Storage encryption uses Microsoft-managed keys, but customer-managed keys offer greater control and responsibility.  
- Proper key rotation and monitoring are essential when using customer-managed keys.  
- Encryption scopes provide a granular and flexible way to manage encryption keys at container or blob level within the same storage account.  
- This granular encryption approach is especially useful for multi-tenant scenarios where different customers require different encryption keys.

---

## Managed disks

**Timestamp**: 03:02:54 – 03:10:21

**Key Concepts**  
- Managed disks abstract away the underlying storage account and page blobs from the user.  
- Different types of managed disks exist, each with varying performance and latency characteristics.  
- Disk performance is generally tied to disk capacity; larger disks offer better performance.  
- Some disk types allow dynamic adjustment of IOPS and throughput independent of capacity.  
- Encryption for managed disks can be handled via disk encryption sets using customer-managed keys or via guest OS encryption (Azure Disk Encryption).  
- Encryption at host can be combined with disk encryption sets for enhanced security, including encryption of cache files and data in transit.

**Definitions**  
- **Managed Disk**: A disk resource in Azure that abstracts the underlying storage account and page blob, simplifying management and improving scalability.  
- **Disk Encryption Set**: A resource that associates managed disks with a customer-managed key stored in Azure Key Vault for encryption at rest.  
- **Azure Disk Encryption (ADE)**: Encryption performed inside the guest OS (e.g., BitLocker for Windows, DMcrypt for Linux), with keys stored in Key Vault.  
- **Encryption at Host**: Encryption applied to cache files on the physical host running the VM, encrypting data in transit between disk and host, using platform-managed keys.

**Key Facts**  
- Types of managed disks:  
  - Standard HDD  
  - Standard SSD  
  - Premium SSD  
  - Premium SSD V2  
  - Ultra Disk  
- Latency examples:  
  - Ultra Disk offers ~0.5 millisecond latency (lowest latency).  
  - Premium SSD offers ~1 millisecond latency.  
- Disk performance scales with capacity; bigger disks provide better IOPS and throughput.  
- Premium SSD allows selection of performance tiers to temporarily boost performance without resizing the disk.  
- Disks can only be increased in size; shrinking requires creating a new disk and migrating data.  
- Premium SSD V2 and Ultra Disk allow independent selection and dynamic modification of IOPS and throughput up to defined limits.  
- Standard SSD supports sharing, allowing multiple resources to connect to the same disk.  
- Disk encryption sets use customer-managed keys from Azure Key Vault to encrypt managed disks.  
- Azure Disk Encryption (ADE) encrypts data inside the VM guest OS and also uses Key Vault for key management.  
- Encryption at host encrypts cache files and data in transit between disk and host, enhancing security.  
- Temporary performance boosts can be applied by adjusting IOPS and throughput settings on Premium SSD V2 and Ultra Disk.

**Examples**  
- None explicitly mentioned beyond conceptual scenarios (e.g., using disk encryption sets with customer keys, or guest OS encryption with BitLocker/DMcrypt).

**Key Takeaways 🎯**  
- Managed disks simplify storage management by abstracting storage accounts and page blobs.  
- Choose disk type based on required latency and performance; Ultra Disk offers the best performance.  
- Disk size directly impacts performance; plan capacity carefully since disks cannot be shrunk.  
- Use performance tiers or adjustable IOPS/throughput options to optimize cost and performance dynamically.  
- For encryption, disk encryption sets with customer-managed keys provide flexible and secure encryption at rest.  
- Azure Disk Encryption offers guest-level encryption but may impose management constraints.  
- Combining encryption at host with disk encryption sets provides comprehensive encryption coverage, including data in transit and cache files.  
- Always consider encryption and performance needs when provisioning managed disks to balance security, cost, and efficiency.

---

## Provisioning resources

**Timestamp**: 03:10:21 – 03:15:07

**Key Concepts**  
- Provisioning resources in Azure can be done in multiple ways, but some are more efficient and scalable than others.  
- Manual provisioning via the Azure Portal is intuitive but not practical at scale due to complexity and risk of errors.  
- Scripting with Azure CLI or PowerShell allows automation but can be cumbersome for updates and modifications.  
- Declarative provisioning using ARM (Azure Resource Manager) JSON templates or Azure Bicep is preferred.  
- ARM templates and Bicep describe *what* resources are needed, not *how* to create them, enabling idempotent deployments.  
- Templates can be version-controlled and integrated into CI/CD pipelines for consistent and repeatable deployments.  
- Azure Portal allows exporting existing resources as ARM JSON templates for reuse and modification.  
- Bicep is a more human-friendly language that transpiles into ARM JSON, making templates easier to read and maintain.  
- Azure stores resource metadata internally in JSON format, reflecting the ARM template structure.  

**Definitions**  
- **Provisioning**: The process of creating and configuring resources in the cloud environment.  
- **ARM (Azure Resource Manager) JSON Template**: A declarative JSON file that defines the infrastructure and configuration for Azure resources.  
- **Azure Bicep**: A domain-specific language that simplifies authoring ARM templates by providing a more readable syntax; it transpiles into ARM JSON.  
- **Declarative Provisioning**: Defining the desired state of infrastructure rather than the steps to achieve it, allowing the system to reconcile differences automatically.  

**Key Facts**  
- Using the portal to create many resources (e.g., 100 identical resources) is inefficient and error-prone.  
- ARM templates and Bicep enable idempotent deployments: reapplying a template updates the resources to match the template state.  
- Exporting templates from existing resources in the portal generates ARM JSON files that can be modified and reused.  
- Bicep is preferred over raw JSON due to better readability and maintainability.  
- Commands exist to decompile JSON ARM templates into Bicep files.  

**Examples**  
- Creating a virtual machine (VM) with associated resources like network interface, network security group, virtual network, and public IP using an ARM template.  
- Exporting a resource group’s template from the Azure Portal to obtain the ARM JSON for reuse.  
- Demonstrating the difference between ARM JSON and Bicep syntax for the same resource deployment.  

**Key Takeaways 🎯**  
- Avoid manual provisioning via the Azure Portal for large-scale or repeatable deployments.  
- Prefer declarative provisioning with ARM templates or Azure Bicep for consistency, version control, and automation.  
- Use exported ARM templates from existing resources as a starting point for your own templates.  
- Learn both JSON ARM templates and Bicep, but focus on Bicep for easier authoring and maintenance.  
- Understand that Azure internally uses JSON metadata to manage resource states.  
- Declarative templates enable seamless updates by reapplying the desired state without manual intervention.  

---

## Types of service

**Timestamp**: 03:15:07 – 03:19:05

**Key Concepts**  
- Different levels of responsibility exist depending on the type of cloud service used.  
- Layers involved in computing: storage, network, compute (servers), hypervisor, operating system, runtime, application, and data.  
- On-premises environments require full responsibility for all layers.  
- Cloud services shift responsibility between vendor and user depending on service type.  
- Types of cloud services: Infrastructure as a Service (IaaS), Platform as a Service (PaaS), Software as a Service (SaaS).  
- The goal is to minimize user responsibility to focus on business value rather than infrastructure management.

**Definitions**  
- **Infrastructure as a Service (IaaS)**: Cloud service where the vendor manages physical servers, storage, networking, and hypervisor; the user manages the OS and everything above it (patching, antivirus, backup, disaster recovery, etc.).  
- **Platform as a Service (PaaS)**: Cloud service where the vendor manages infrastructure and platform layers; the user is responsible only for the application and data. Includes managed databases and app hosting platforms.  
- **Software as a Service (SaaS)**: Fully managed cloud applications (e.g., Microsoft 365, Dynamics 365) where the vendor handles all infrastructure, platform, and application maintenance; the user mainly manages identities and access.

**Key Facts**  
- In IaaS, users must handle OS patching, antivirus, backup, disaster recovery, and anti-malware.  
- Azure provides tools like agents and extensions to help manage VMs but responsibility remains with the user.  
- PaaS examples include virtual machine scale sets, Azure Kubernetes Service, app services, and serverless offerings like Azure Functions and Logic Apps.  
- SaaS examples include Microsoft 365 and Dynamics 365, where users do not patch or maintain the underlying services.  
- Users should aim to move as far right (towards SaaS) in the service model as possible to reduce operational overhead.  
- Virtual machines have multiple dimensions such as SKU, size, CPU, and memory.

**Examples**  
- IaaS: Virtual machines in Azure.  
- PaaS: Virtual machine scale sets, Azure Kubernetes Service, app services, Azure Functions, Logic Apps.  
- SaaS: Microsoft 365, Dynamics 365.

**Key Takeaways 🎯**  
- Understanding the division of responsibility is critical when choosing cloud service types.  
- The less responsibility you have for infrastructure and platform management, the more you can focus on your application and business logic.  
- Even though VMs are the foundational service, many higher-level services build on top of them.  
- Use Azure tools to assist with management but remember ultimate responsibility depends on the service model.  
- Aim to leverage PaaS and SaaS offerings to reduce operational burden and increase focus on business value.

---

## Virtual machines

**Timestamp**: 03:19:05 – 03:28:11

**Key Concepts**  
- Virtual machines (VMs) have multiple dimensions or characteristics such as CPU, memory, storage, network capabilities, and GPUs.  
- VM SKUs and sizes define these dimensions and are chosen based on workload requirements.  
- Workloads have different "shapes" (resource needs) that should be matched to the appropriate VM SKU and size to optimize resource use and cost.  
- Scaling is often better achieved by multiple smaller VMs rather than one large VM.  
- Azure offers various VM series optimized for different purposes: general purpose, compute optimized, memory optimized, GPU-enabled, storage optimized, and burstable VMs.  
- Burstable VMs (B series) allow CPU credits to be banked and used for short bursts of higher CPU usage, useful for dev/test or variable workloads.  
- VMs run on physical hosts with local storage; ephemeral OS disks can be used to reduce costs and improve performance when state persistence is not required.  
- Managed disks are typically used for OS and data disks unless ephemeral disks are leveraged.  
- VMs support extensions to add capabilities such as running custom scripts, backup integration, auto shutdown, and disaster recovery.  
- Backup management can be centralized via Azure Backup Center with different vault types (Recovery Services vault for legacy workloads and newer backup vaults for disks, blobs, databases, Kubernetes).  
- Secure access to VMs is recommended via Azure Bastion to avoid exposing public IPs and reduce attack surface.  
- Physical hosts and racks correspond to fault domains within data centers, important for availability considerations.

**Definitions**  
- **SKU (Stock Keeping Unit)**: A specific configuration of a VM defining its CPU, memory, storage, and other capabilities.  
- **Burstable VM (B series)**: A VM type that accumulates CPU credits when underused and allows short bursts of higher CPU usage when needed.  
- **Ephemeral Disk**: A temporary OS disk stored on the local host’s physical storage, offering low latency and high performance but without persistent state.  
- **Azure Bastion**: A managed jump box service that provides secure and seamless RDP/SSH connectivity to VMs without exposing public IP addresses.  
- **Managed Disk**: Azure-managed persistent storage used for VM OS and data disks.  
- **Backup Center**: A centralized Azure service for managing backups across various workloads and vault types.

**Key Facts**  
- General purpose VMs typically have a 1:4 ratio of vCPU to memory.  
- Compute optimized VMs have a 1:2 CPU to memory ratio.  
- Memory optimized VMs have a 1:8 CPU to memory ratio.  
- Some VM series (D variant) include temporary local storage (temp disk), while others (non-D) do not.  
- Premium storage support is available on S variants of VMs, not on standard ones.  
- Burstable VMs allow CPU usage beyond the baseline by using banked credits.  
- Ephemeral OS disks are commonly used in scale sets and AKS node pools to reduce managed disk costs and improve performance.  
- Temporary storage is typically mounted as D: on Windows and /dev/sdb on Linux for D-series VMs.

**Examples**  
- Database workloads typically require high memory and storage throughput.  
- Batch processing workloads typically require high CPU resources.  
- Using multiple smaller VMs instead of one large VM allows better scaling and cost efficiency.  
- Dev/test environments can leverage burstable VMs to minimize costs by using CPU credits.  
- Virtual machine scale sets and AKS node pools often use ephemeral disks for OS to reduce costs and improve latency.  
- Azure Bastion is used to securely connect to VMs without exposing public IPs.

**Key Takeaways 🎯**  
- Understand the resource "shape" of your workload to select the appropriate VM SKU and size.  
- Prefer scaling out with multiple smaller VMs rather than scaling up with a single large VM.  
- Use burstable VMs for workloads with variable CPU demand to save costs.  
- Leverage ephemeral disks where possible for stateless or short-lived VMs to reduce storage costs and improve performance.  
- Use VM extensions to automate management tasks like running scripts, backups, and shutdowns.  
- Centralize backup management using Azure Backup Center and choose the appropriate vault type based on workload.  
- Always secure VM access using Azure Bastion or similar managed jump box solutions to minimize attack surface.  
- Consider physical host and fault domain placement for high availability and fault tolerance planning.

---

## Availability Set and Zones

**Timestamp**: 03:28:11 – 03:30:54

**Key Concepts**  
- Azure Bastion provides a secure way to connect to virtual machines without exposing public IPs.  
- A virtual machine runs on a physical host located in a specific rack within a data center.  
- Fault domains represent physical racks or hardware units that can fail independently.  
- Availability Sets group VMs across multiple fault domains (racks) to provide resiliency against rack-level failures.  
- Availability Zones are physically separate locations within an Azure region that isolate power, cooling, networking, and control planes.  
- Availability Zones offer higher fault tolerance than Availability Sets by protecting against entire data center or power substation failures.  

**Definitions**  
- **Azure Bastion**: A managed jump box service that enables secure and seamless RDP/SSH connectivity to VMs without exposing them to the public internet.  
- **Fault Domain**: A logical group of hardware (e.g., a rack) that shares a common power source and network switch, representing a potential point of failure.  
- **Availability Set**: A grouping of VMs that are distributed across multiple fault domains to ensure resiliency against hardware failures within a data center.  
- **Availability Zone**: Physically separate zones within an Azure region, each with independent power, cooling, networking, and control planes, designed to protect against larger-scale failures.  

**Key Facts**  
- Availability Sets distribute VMs across fault domains (e.g., fault domain 0, 1, 2) to avoid single points of failure at the rack level.  
- Workloads should be separated into different availability sets to avoid all instances of one service being placed in the same fault domain.  
- Availability Zones provide protection against failures at the data center or power substation level, offering a larger blast radius protection than Availability Sets.  
- Not all Azure regions support Availability Zones; in those cases, Availability Sets are the fallback option.  

**Examples**  
- Using Availability Sets to round robin VMs across racks (fault domains) to ensure resiliency.  
- Separating different workloads into different availability sets to avoid correlated failures.  
- Deploying VMs across multiple Availability Zones to protect against entire data center failures.  

**Key Takeaways 🎯**  
- Always prefer Availability Zones over Availability Sets when supported, as they provide stronger fault isolation.  
- Use Availability Sets to distribute VMs across fault domains within a data center to protect against rack-level failures.  
- Separate different workloads into distinct availability sets to avoid placing all instances in the same fault domain.  
- Azure Bastion is recommended for secure VM access instead of exposing public IPs.  
- Understand the physical infrastructure behind VMs (racks, fault domains, zones) to design resilient architectures.

---

## VMSS

**Timestamp**: 03:30:54 – 03:34:35

**Key Concepts**  
- Virtual Machine Scale Sets (VMSS) enable automatic scaling of multiple VMs without manual creation/deletion.  
- Two types of VMSS: Uniform (traditional) and Flexible (newer).  
- Scaling profile defines VM template, SKU, image, configuration, minimum and maximum instance counts, and scale actions.  
- Horizontal auto scaling: adding/removing VM instances based on workload demand (e.g., CPU usage).  
- Flexible VMSS allows mixing different VM SKUs and Spot instances within the scale set.  
- Spot instances use Azure’s spare capacity at lower cost, suitable for interruptible workloads.  

**Definitions**  
- **Virtual Machine Scale Set (VMSS)**: A service that manages a group of identical, load-balanced VMs that can automatically scale in or out based on defined rules.  
- **Uniform VMSS**: Traditional VM scale set where all VMs are identical and scaling is managed via a scaling profile.  
- **Flexible VMSS**: Allows optional scaling profiles, mixing of different VM SKUs, and inclusion of Spot instances.  
- **Scaling Profile**: Configuration that specifies VM template details, min/max instance counts, and scaling rules based on metrics like CPU usage.  
- **Spot Instances**: VMs that use Azure’s spare capacity at discounted rates, suitable for workloads that can tolerate interruptions.  
- **Horizontal Scaling**: Adding or removing VM instances to match workload demand.  
- **Vertical Scaling**: Changing the size (SKU) of a VM, which typically requires downtime and is less practical.  

**Key Facts**  
- Scaling actions example: If CPU > 70%, add 2 instances; if CPU < 30%, remove 1 instance.  
- Horizontal scaling is preferred over vertical scaling due to no downtime when adding/removing instances.  
- Flexible VMSS can mix regular VMs and Spot instances to optimize cost and performance.  

**Examples**  
- Auto scaling based on CPU utilization thresholds (e.g., add instances when CPU > 70%, remove when CPU < 30%).  
- Using Spot instances in Flexible VMSS for dev or batch workloads that can be interrupted and resumed.  

**Key Takeaways 🎯**  
- VMSS automates scaling of VMs horizontally to efficiently handle variable workloads.  
- Use Uniform VMSS for consistent VM instances and mandatory scaling profiles.  
- Use Flexible VMSS for more customization, mixing VM types, and cost optimization with Spot instances.  
- Horizontal scaling is more practical than vertical scaling in cloud environments due to reduced downtime.  
- Spot instances are a cost-effective option for non-critical or interruptible workloads within VMSS.  

---

## Containers

**Timestamp**: 03:34:35 – 03:37:25

**Key Concepts**  
- Containers virtualize the operating system rather than the hardware (unlike virtual machines).  
- Containers share the host OS kernel but run isolated user-mode sandboxes.  
- Container images are created from base images and customized via Docker files.  
- Container hosts run container images in isolated environments sharing the kernel.  
- Azure Container Instances (ACI) provide a simple way to run containers on Azure with pay-per-use billing.  
- For more complex needs (scaling, orchestration, networking, storage), Kubernetes is used as the container orchestrator.  
- Azure Kubernetes Service (AKS) is Azure’s managed Kubernetes offering.

**Definitions**  
- **Container**: A lightweight, isolated user-mode sandbox that shares the host OS kernel, used to run application images.  
- **Container Registry**: A storage and distribution system for container images.  
- **Docker file**: A script that defines how to build a custom container image from a base image by adding layers and commands.  
- **Azure Container Instance (ACI)**: Azure’s service to run containers easily without managing servers, billed based on runtime.  
- **Kubernetes**: The de facto open-source container orchestration platform for managing containerized applications at scale.  
- **Azure Kubernetes Service (AKS)**: Azure’s managed Kubernetes service for orchestrating containers with advanced features.

**Key Facts**  
- Containers are much thinner than VMs because they share the OS kernel rather than running a full OS.  
- Containers isolate processes, networking, and storage at the user mode level, preventing interference between containers.  
- Azure Container Registry is integrated with Azure Container Instances for image storage and deployment.  
- Azure Container Instances are suited for simple, individual container runs or burst workloads.  
- Kubernetes provides richer orchestration, scaling, networking, and storage capabilities for managing many containers.

**Examples**  
- Creating a custom container image by writing a Docker file that builds on a base image and adds software or commands.  
- Running containers manually on a container host that shares the kernel but isolates containers in sandboxes.  
- Using Azure Container Instances to run container images on demand and paying only for the runtime.  
- Using Kubernetes (via AKS) to manage large-scale container deployments requiring orchestration and resilience.

**Key Takeaways 🎯**  
- Containers offer a lightweight alternative to VMs by virtualizing the OS, enabling faster startup and less overhead.  
- Docker files are essential for defining and customizing container images.  
- Azure Container Instances are ideal for simple, short-lived container workloads.  
- For production-grade, scalable, and resilient container management, Kubernetes (AKS) is the recommended solution.  
- Understanding the difference between containers and VMs is critical for choosing the right deployment model.

---

## AKS

**Timestamp**: 03:37:25 – 03:42:34

**Key Concepts**  
- Kubernetes as the de facto container orchestrator  
- Azure Kubernetes Service (AKS) as Azure’s managed Kubernetes offering  
- AKS architecture: control plane (management layer) and node pools (worker nodes)  
- Pods as the smallest deployable units running containers  
- Persistent storage integration via Persistent Volume Claims (PVCs) and Persistent Volumes (PVs)  
- Networking models in AKS: Kubenet, Azure CNI, and Overlay networking  
- Scaling in AKS at two levels: pods and nodes  
- Autoscaling tools: Horizontal Pod Autoscaler, KEDA (Kubernetes Event Driven Autoscaler), and Cluster Autoscaler  
- Bursting capacity to Azure Container Instances (ACI) via virtual kubelet  

**Definitions**  
- **Kubernetes**: An open-source container orchestration system for automating deployment, scaling, and management of containerized applications.  
- **Azure Kubernetes Service (AKS)**: A managed Kubernetes service in Azure that abstracts the control plane and simplifies cluster management.  
- **Control Plane**: The management layer of Kubernetes that runs components like the API server, scheduler, ETCD database, and controllers.  
- **Node Pool**: A group of virtual machine nodes in AKS that run the container workloads.  
- **Pod**: The smallest Kubernetes object that encapsulates one or more containers running together.  
- **Persistent Volume Claim (PVC)**: A request for storage by a pod that maps to a Persistent Volume (PV).  
- **Kubenet**: A basic AKS networking model using a separate IP space for pods with NAT for communication.  
- **Azure CNI**: A networking model where pods share the same IP space as nodes or use a dynamic subnet allocation.  
- **Overlay Networking**: A preferred networking model using a separate CIDR range for pods with native communication plumbing, avoiding Kubenet limitations.  
- **Horizontal Pod Autoscaler**: Automatically scales the number of pod instances based on workload metrics.  
- **KEDA**: An advanced event-driven autoscaler for Kubernetes pods with more flexible scaling triggers.  
- **Cluster Autoscaler**: Automatically adds or removes nodes in the cluster based on pod scheduling needs.  
- **Virtual Kubelet**: A connector that allows AKS to burst workloads to Azure Container Instances seamlessly.  

**Key Facts**  
- AKS control plane components include API server, ETCD database, scheduler, and controllers, all managed by Azure (not visible to users).  
- Node pools run on virtual machine scale sets within the user’s Azure subscription.  
- Persistent storage options include Azure Files, Azure NetApp Files, Azure Disks, Elastic SAN, and Azure Container Storage.  
- Kubenet requires NAT and has a separate IP space for pods, making it less popular.  
- Azure CNI pods share the node IP space or use dynamic subnet allocation to avoid IP exhaustion.  
- Overlay networking is now the preferred AKS networking model for better scalability and fewer issues.  
- Horizontal Pod Autoscaler and KEDA handle pod-level scaling; Cluster Autoscaler manages node-level scaling.  
- AKS can burst to Azure Container Instances using virtual kubelet for short-term capacity needs.  

**Examples**  
- Using persistent volume claims to connect pods to durable storage like Azure Files or Azure Disks.  
- Bursting cluster capacity to Azure Container Instances via virtual kubelet for short-term demand spikes.  

**Key Takeaways 🎯**  
- AKS simplifies Kubernetes management by handling the control plane and providing node pools for workload execution.  
- Understanding AKS networking models is crucial for designing scalable and efficient clusters; overlay networking is currently preferred.  
- Scaling in AKS is multi-dimensional: pods scale horizontally based on demand, and nodes scale automatically to accommodate pod scheduling.  
- Integration with Azure storage services provides persistent storage options for stateful applications.  
- Virtual kubelet enables flexible bursting to serverless container instances, enhancing cluster elasticity.

---

## App Service Plan

**Timestamp**: 03:42:34 – 03:45:25

**Key Concepts**  
- App Service is one of the earliest and most basic PaaS offerings in Azure.  
- An App Service Plan defines the underlying compute resources (worker nodes) that host one or more apps.  
- Multiple apps (e.g., app one, app two) share the same App Service Plan resources.  
- Deployment slots (e.g., staging, production) exist within the same App Service Plan and share capacity.  
- App Service Plans are region-specific and require choosing OS (Windows or Linux) and runtime stack.  
- App Service Environment (ASE) allows deployment directly into a customer’s Virtual Network (VNet) with no shared infrastructure.  
- Pricing tiers/plans determine hardware specs and feature availability (e.g., custom domains, zone redundancy, VNet integration).  
- Scaling options include:  
  - Traditional rule-based scaling configured by the user.  
  - Elastic scaling that automatically adjusts based on HTTP load, including pre-warmed instances.  
- Multiple deployment methods supported: DevOps pipelines, GitHub Actions, direct URL, FTP, zip/file upload.

**Definitions**  
- **App Service Plan**: A set of compute resources (worker nodes) in a specific region that host one or more Azure App Services (web apps).  
- **Deployment Slots**: Separate deployment environments (e.g., staging, production) within the same App Service Plan sharing the same compute resources.  
- **App Service Environment (ASE)**: A dedicated App Service deployment that runs in a customer’s VNet with isolated infrastructure and no shared components.  
- **Pricing Plan**: The tier selected for an App Service Plan that determines hardware capabilities and feature availability.

**Key Facts**  
- Apps within an App Service Plan share the same worker nodes and capacity.  
- App Service Plans require selecting OS (Windows or Linux) and runtime stack.  
- Pricing tiers affect features such as:  
  - Custom domain support  
  - Zone redundancy  
  - Virtual Network integration  
- Elastic scaling automatically adds nodes based on HTTP load without manual rule configuration.  
- Deployment methods include DevOps pipelines, GitHub Actions, URL-based deployment, FTP, and zip/file upload.

**Examples**  
- Running multiple apps (app one, app two) within the same App Service Plan sharing resources.  
- Using deployment slots for staging and production environments within the same plan.  
- Elastic scaling that pre-warms instances and adjusts node count automatically based on HTTP traffic.

**Key Takeaways 🎯**  
- App Service Plans are fundamental to hosting Azure web apps and define the compute resources shared by apps.  
- Choosing the right pricing tier is crucial as it impacts hardware, scaling capabilities, and features like custom domains and VNet integration.  
- Elastic scaling simplifies capacity management by automatically adjusting resources based on load.  
- Multiple deployment options provide flexibility to get code into the App Service.  
- App Service Environment offers isolated, secure deployment inside a customer’s VNet for advanced networking needs.

---

## Monitoring

**Timestamp**: 03:45:25 – 03:50:48

**Key Concepts**  
- Monitoring provides observability to ensure system health and performance.  
- Monitoring occurs at multiple layers: subscription level (control plane) and resource level.  
- Activity Log captures control plane changes at the subscription level.  
- Resources emit metrics (time-based signals) and logs, which need to be configured.  
- Diagnostic settings enable collection and routing of logs and metrics.  
- Logs and metrics can be sent to different destinations: Azure Storage, Event Hub, Log Analytics workspace.  
- Log Analytics workspace enables powerful analytics using Kusto Query Language (KQL).  
- Guest OS monitoring is possible via Azure Monitor agent and guest metrics.  
- Alerts can be created based on activity logs, metrics, or log queries to proactively notify issues.

**Definitions**  
- **Activity Log**: A free log that records control plane changes at the subscription level.  
- **Diagnostic Settings**: Configuration that enables collection of logs and metrics from resources and defines where to send them.  
- **Azure Monitor Metrics**: Time-based signals from resources that are free and provide workload-specific metrics.  
- **Log Analytics Workspace**: A centralized service for storing and analyzing logs with advanced querying capabilities using KQL.  
- **Event Hub**: A publish-subscribe service that can receive diagnostic data for external SIEM or processing.  
- **Guest Metrics**: Metrics collected from within the guest OS of a VM using Azure Monitor agent.  
- **Alerts**: Configurable notifications triggered by conditions on activity logs, metrics, or log queries.

**Key Facts**  
- Activity Log is free and scoped at subscription, resource group, or resource level.  
- Metrics are free and provide aggregated data (e.g., average CPU usage).  
- Logs do not exist by default and require diagnostic settings to be enabled.  
- Diagnostic data can be sent to multiple destinations simultaneously.  
- Azure Storage is the cheapest option for storing logs but less interactive.  
- Log Analytics workspace supports advanced analytics and querying with KQL.  
- VMs can provide detailed performance counters and logs when diagnostic settings are enabled.  
- Cosmos DB and other resources allow granular selection of diagnostic categories and destinations.  
- Alerts can be based on activity logs, metrics, or custom KQL queries and integrate with Azure Sentinel.

**Examples**  
- Viewing VM metrics such as availability, CPU, disk bytes, and CPU credits for B-series VMs.  
- Splitting metrics by LUN to get detailed disk usage insights.  
- Configuring diagnostic settings on Cosmos DB to capture specific logs and metrics and send them to chosen destinations.  
- Using App Insights for application-level monitoring and synthetic transaction tests.  

**Key Takeaways 🎯**  
- Monitoring is essential for maintaining system health and requires observability at multiple layers.  
- Always enable diagnostic settings to collect logs and metrics beyond default metrics.  
- Choose appropriate destinations for diagnostic data based on cost, usability, and integration needs.  
- Use Log Analytics workspace for powerful querying and insights with KQL.  
- Implement alerts to proactively detect and respond to issues based on various data sources.  
- Extend monitoring to guest OS and application layers for comprehensive coverage.

---

## Alerting

**Timestamp**: 03:50:48 – 03:54:57

**Key Concepts**  
- Alerting enables proactive awareness beyond passive observability.  
- Alerts can be created based on multiple data sources: activity logs, monitor metrics, log analytics queries, and Azure Sentinel workspaces.  
- Alerts can be simple threshold-based or use machine learning to detect anomalies based on sensitivity levels (low, medium, high).  
- Alert processing rules allow automated handling of alerts, including invoking action groups or suppressing alerts under certain conditions.  
- Action groups define the actions triggered by alerts, such as sending SMS, emails, calling functions, webhooks, runbooks, or integrating with ITSM systems.  
- Alert processing rules provide a centralized, scalable way to manage alert responses and suppressions, improving organization and reducing manual configuration.  
- Scheduling can be applied to alert processing rules to control when alerts trigger actions or suppressions.

**Definitions**  
- **Alert**: A configured notification or action triggered when specific conditions are met in monitoring data.  
- **Alert Processing Rule**: A configuration that defines what happens when an alert is generated, such as calling action groups or suppressing alerts based on scope, priority, or schedule.  
- **Action Group**: A collection of notification or automation actions (e.g., SMS, email, webhook, runbook) that can be triggered by alerts.  

**Key Facts**  
- Alerts can be based on:  
  - Activity logs  
  - Monitor metrics  
  - Log Analytics workspace queries (KQL)  
  - Azure Sentinel workspace queries  
- Machine learning alerts detect anomalies by comparing current values against common baselines and trigger alerts based on sensitivity settings.  
- Alert processing rules can suppress alerts during specific times (e.g., weekends, holidays) or based on priority levels.  
- Action groups support a wide variety of actions including SMS, email, ARM role calls, runbooks, functions, ITSM ticket creation, logic apps, and secure webhooks.  
- Using alert processing rules is more efficient than assigning action groups individually to each alert, especially when managing hundreds of alerts.  

**Examples**  
- Suppressing alerts during Christmas or weekends for low-priority issues to avoid paging people.  
- Calling an action group that sends SMS or email notifications when a critical alert is raised.  
- Using alert processing rules to automatically route alerts of a certain type or scope to specific action groups.  

**Key Takeaways 🎯**  
- Alerting transforms monitoring data into actionable notifications and automated responses.  
- Centralizing alert response logic with alert processing rules simplifies management and improves operational efficiency.  
- Action groups provide flexible integration points for notifications and automation workflows.  
- Suppression and scheduling capabilities help reduce alert noise and avoid unnecessary disruptions.  
- Leveraging machine learning-based alerts can enhance detection of unusual conditions beyond static thresholds.

---

## Log Analytics Workspace

**Timestamp**: 03:54:57 – 03:59:05

**Key Concepts**  
- Different types of Log Analytics workspaces exist with varying capabilities and costs.  
- Data ingestion, storage, and query execution all contribute to costs.  
- Retention policies affect whether data is stored interactively or moved to archive.  
- Archive storage allows long-term retention but limits direct querying without restore/search jobs.  
- Basic logs offer a cost-effective but limited subset of KQL and shorter retention.  
- Analytics logs provide full KQL capabilities and longer retention periods.  
- Tables within a workspace can be configured to use either analytics or basic logs.  
- Network Watcher integrates with Log Analytics for network health and troubleshooting.

**Definitions**  
- **Log Analytics Workspace**: A centralized repository for collecting, storing, and analyzing log data using Kusto Query Language (KQL).  
- **Analytics Logs**: Full-featured logs with complete KQL support, longer retention (30-90 days interactive), and higher cost.  
- **Basic Logs**: Logs with a subset of KQL capabilities, cheaper, limited to 8 days of interactive retention, with additional costs for queries and storage.  
- **Archive Storage**: Long-term storage (up to 12 years) for logs beyond interactive retention; data is not directly queryable without restore or search jobs.  
- **KQL (Kusto Query Language)**: Query language used to analyze log data in Log Analytics.  
- **Network Watcher**: Azure service providing network monitoring and troubleshooting capabilities, integrated with Log Analytics.

**Key Facts**  
- Analytics logs retention: typically 30 days interactive, extendable to 90 days with Sentinel, and up to 2 years interactive in some cases.  
- Basic logs retention: 8 days interactive only; after that, data moves to archive.  
- Archive retention: up to 12 years, with storage costs and additional fees for restore/search jobs.  
- Costs include data ingestion, storage beyond included retention, and query execution (especially for basic logs and archive restores).  
- Basic logs do not support cross-table queries but can use consolidated schemas (e.g., container insights V2 schema) to mitigate this.  
- Changing table settings from analytics to basic affects how much data is interactive vs archived based on retention settings.  
- Example: Setting a 30-day retention with basic logs results in 8 days interactive and 22 days archived.

**Examples**  
- Container insights V2 schema allows storing all data in a single table, enabling use of basic logs despite KQL limitations.  
- Adjusting table retention from analytics to basic changes the split between interactive and archive data (e.g., 30 days total retention with basic logs results in 8 days interactive + 22 days archive).  
- Using Network Watcher for network health monitoring and troubleshooting integrated with Log Analytics.

**Key Takeaways 🎯**  
- Choose between analytics and basic logs based on cost, retention needs, and query capabilities.  
- Archive storage is cost-effective for long-term retention but requires paid restore/search jobs for querying.  
- Basic logs reduce costs but limit query complexity and retention duration.  
- Retention settings directly impact how much data remains interactive vs archived.  
- Use consolidated schemas like container insights V2 to optimize basic log usage.  
- Network Watcher complements Log Analytics by providing network-specific insights and troubleshooting tools.

---

## Network watcher

**Timestamp**: 03:59:05 – 04:00:16

**Key Concepts**  
- Network Watcher is a tool for monitoring and troubleshooting the overall health of a network.  
- Provides multiple capabilities to analyze network traffic and diagnose issues.  
- Helps verify network security rules and connectivity paths.  
- Supports packet capture and synthetic testing for troubleshooting.

**Definitions**  
- **Network Watcher**: A network monitoring and diagnostic service that offers insights into network topology, traffic flow, security rules, and connectivity health.  

**Key Facts**  
- Features include:  
  - Topology view to visualize network layout.  
  - IP flow verify to check if security rules block communication.  
  - Next hop identification to determine the next routing point.  
  - VPN troubleshooting and gateway health checks.  
  - Connection statistics and NSG (Network Security Group) diagnostics using flow logs.  
  - Packet capture for detailed traffic analysis.  
  - Connection troubleshoot that sends synthetic packets via an extension to test connectivity.

**Examples**  
- Using IP flow verify to determine if a security rule blocks communication.  
- Using connection troubleshoot to send synthetic packets to test if a connection works.

**Key Takeaways 🎯**  
- Network Watcher is essential for comprehensive network troubleshooting.  
- It provides both high-level insights (topology) and low-level diagnostics (packet capture, flow verification).  
- The tool helps identify and resolve connectivity and security issues effectively.  
- Utilize the various features to proactively monitor and maintain network health.

---

## Summary and close

**Timestamp**: 04:00:16 – unknown

**Key Concepts**  
- Use of various troubleshooting tools and diagnostics for network and VPN issues (security rules, next hop, VPN gateway health, connection stats, NSG diagnostics, flow logs, packet capture).  
- Connection troubleshoot feature uses synthetic packets to test connectivity.  
- Importance of hands-on practice and going through learning modules for exam preparation.  
- Logical thinking and process of elimination during the exam.  
- Reviewing score reports after a failed attempt to focus on weak areas.

**Definitions**  
- **Connection troubleshoot**: A tool that uses an extension into the resource to send synthetic packets to verify if a connection would work.  
- **NSG diagnostics**: Network Security Group diagnostics that use flow logs to analyze IP traffic for troubleshooting.

**Key Facts**  
- The video covered a large amount of material related to troubleshooting and network diagnostics.  
- Microsoft designs exam functionalities to be logical and not intended to confuse candidates.  
- If you don’t pass the exam on the first try, analyze the score report to identify weak areas and study those further.

**Examples**  
- Using connection troubleshoot to send synthetic packets to test connectivity.  
- Using flow logs in NSG diagnostics to map IP traffic.  
- Packet capture for troubleshooting network issues.

**Key Takeaways 🎯**  
- Make sure to complete learning modules and get as much hands-on experience as possible before the exam.  
- During the exam, remain calm, think logically, and use process of elimination to answer questions.  
- Don’t panic if you fail the first time; use the score report to improve and try again.  
- Microsoft’s exam questions are designed to be logical and straightforward, not to confuse.  
- Understanding the order of steps and what makes the most sense is crucial in troubleshooting scenarios.  
