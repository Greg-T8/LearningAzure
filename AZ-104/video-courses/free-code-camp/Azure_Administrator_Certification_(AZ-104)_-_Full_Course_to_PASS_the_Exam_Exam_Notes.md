# Azure Administrator Certification (AZ-104) - Full Course to PASS the Exam - Exam Notes

*Generated on 2026-01-26 17:40*

---

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Course Contents](#course-contents)
  * [Getting Started](#getting-started)
* [Monitor](#monitor)
  * [Intro](#intro)
* [Azure AD](#azure-ad)
  * [Use Cases](#use-cases)
  * [AD vs AAD](#ad-vs-aad)
  * [Terminology](#terminology)
  * [Tenant](#tenant)
  * [AD DS](#ad-ds)
  * [AD Connect](#ad-connect)
  * [Users](#users)
  * [Groups](#groups)
  * [Assign Access Rights](#assign-access-rights)
  * [External Identities](#external-identities)
  * [Create a Tenant](#create-a-tenant)
  * [Upgrade License](#upgrade-license)
  * [User and Groups](#user-and-groups)
  * [Guest Users](#guest-users)
  * [Mass Import](#mass-import)
  * [MFA](#mfa)
  * [Self Service Rest Password](#self-service-rest-password)
  * [AD CheatSheet](#ad-cheatsheet)
* [AD Device Management](#ad-device-management)
  * [Intro to Device Management](#intro-to-device-management)
  * [AD Registered Devices](#ad-registered-devices)
  * [Windows Hello](#windows-hello)
  * [MDM and MAM](#mdm-and-mam)
  * [EMS](#ems)
  * [MS Authenticator App](#ms-authenticator-app)
  * [AD Joined Devices](#ad-joined-devices)
  * [FIDO2 and Security Keys](#fido2-and-security-keys)
  * [Hybrid AD Joined Devices](#hybrid-ad-joined-devices)
  * [Windows Autopilot](#windows-autopilot)
  * [Device Management Cheatsheet](#device-management-cheatsheet)
  * [Roles](#roles)
  * [Roles](#roles-1)
  * [Type of Roles](#type-of-roles)
  * [IAM Access Controls](#iam-access-controls)
  * [Classic Administrator](#classic-administrator)
  * [RBAC](#rbac)
  * [AD Roles](#ad-roles)
  * [Roles](#roles-2)
  * [Policies vs RBAC](#policies-vs-rbac)
  * [AD Roles vs RBAC](#ad-roles-vs-rbac)
  * [Roles CheatSheet](#roles-cheatsheet)
  * [Intro](#intro-1)
* [Azure Policies](#azure-policies)
  * [Non Compliant Resources](#non-compliant-resources)
  * [Policy Definition File](#policy-definition-file)
  * [Configure Policy](#configure-policy)
  * [Policies CheatSheet](#policies-cheatsheet)
  * [Intro](#intro-2)
* [ARM](#arm)
  * [Use Case](#use-case)
  * [Scoping](#scoping)
  * [Subscriptions](#subscriptions)
  * [Management Groups](#management-groups)
  * [Resource Groups](#resource-groups)
  * [Resource Providers](#resource-providers)
  * [Resource Tags](#resource-tags)
  * [Resource Locks](#resource-locks)
  * [Blueprints](#blueprints)
  * [Moving Resources](#moving-resources)
  * [ARM CheatSheet](#arm-cheatsheet)
* [ARM Templates](#arm-templates)
  * [Intro to ARM Templates](#intro-to-arm-templates)
  * [ARM Template Skeleton](#arm-template-skeleton)
  * [ARM Template Resources](#arm-template-resources)
  * [ARM Template Parameters](#arm-template-parameters)
  * [ARM Template Functions](#arm-template-functions)
  * [ARM Template Variables](#arm-template-variables)
  * [ARM Template Output](#arm-template-output)
  * [Launch an ARM Template](#launch-an-arm-template)
  * [ARM Template CheatSheet](#arm-template-cheatsheet)
* [Storage Accounts](#storage-accounts)
  * [Intro to Storage Accounts](#intro-to-storage-accounts)
  * [Storage Comparison](#storage-comparison)
  * [Core Storage Services](#core-storage-services)
  * [Performance Tiers](#performance-tiers)
  * [Access Tiers](#access-tiers)
  * [Replication Data Redundancy](#replication-data-redundancy)
  * [LRS ZRS](#lrs-zrs)
  * [GRS GZRS](#grs-gzrs)
  * [RAGRS\_RA GZRS](#ragrs_ra-gzrs)
  * [Intro to Blob](#intro-to-blob)
  * [Blob Types](#blob-types)
  * [Blob Moving Data](#blob-moving-data)
  * [Intro to Files](#intro-to-files)
  * [Files Use Cases](#files-use-cases)
  * [Files Feature](#files-feature)
  * [File Sync](#file-sync)
  * [Storage Explorer](#storage-explorer)
  * [AZCopy](#azcopy)
  * [Import Export Service](#import-export-service)
  * [SAS](#sas)
  * [Use AZCopy to copy files to Storage Accounts](#use-azcopy-to-copy-files-to-storage-accounts)
  * [Create a File Share with Files](#create-a-file-share-with-files)
  * [Setup Files Sync](#setup-files-sync)
  * [Storage Accounts CheatSheet](#storage-accounts-cheatsheet)
  * [Intro](#intro-3)
* [VMs](#vms)
  * [Operation Systems](#operation-systems)
  * [Cloud Init](#cloud-init)
  * [Sizes](#sizes)
  * [ACUs](#acus)
  * [MobileApp](#mobileapp)
  * [VM Generations](#vm-generations)
  * [3 Ways To Connect](#3-ways-to-connect)
  * [SSH](#ssh)
  * [RDP](#rdp)
  * [Bastion](#bastion)
  * [Windows Vs Linux](#windows-vs-linux)
  * [Update Management](#update-management)
  * [Create a Bastion](#create-a-bastion)
  * [Create a Windows VM and RDP](#create-a-windows-vm-and-rdp)
  * [Create a Linux VM and SSH](#create-a-linux-vm-and-ssh)
  * [VM Monitoring](#vm-monitoring)
  * [VM CheatSheets](#vm-cheatsheets)
  * [Intro](#intro-4)
* [Disks](#disks)
  * [Encryption](#encryption)
  * [Disk Roles](#disk-roles)
  * [Managed Disk Snapshots Managed Custom Image](#managed-disk-snapshots-managed-custom-image)
  * [Disk Types](#disk-types)
  * [Bursting](#bursting)
  * [Attaching Partitioning and Mounting a Disk](#attaching-partitioning-and-mounting-a-disk)
  * [Disks CheatSheet](#disks-cheatsheet)
  * [Intro](#intro-5)
* [Application Gateway](#application-gateway)
  * [Routing Rules](#routing-rules)
  * [AGW CheatSheet](#agw-cheatsheet)
* [Scale Sets](#scale-sets)
  * [Intro to Scale Sets](#intro-to-scale-sets)
  * [Associate a Load Balancer](#associate-a-load-balancer)
  * [Scaling Policy](#scaling-policy)
  * [Health Monitoring](#health-monitoring)
  * [Advanced Features](#advanced-features)
  * [Scale Sets CheatSheet](#scale-sets-cheatsheet)
  * [Intro](#intro-6)
* [App Service](#app-service)
  * [Runtimes](#runtimes)
  * [Custom Containers](#custom-containers)
  * [Deployment Slots](#deployment-slots)
  * [App Service Environment](#app-service-environment)
  * [Deployment](#deployment)
  * [App Service Plan](#app-service-plan)
  * [WebJobs](#webjobs)
  * [Configure and Deploy App Service](#configure-and-deploy-app-service)
  * [Trigger a Deploy via Github Actions](#trigger-a-deploy-via-github-actions)
  * [Create Deployment Slots](#create-deployment-slots)
  * [Scaling App Service](#scaling-app-service)
  * [App Services CheatSheet](#app-services-cheatsheet)
* [Availability Follow Along](#availability-follow-along)
  * [Backup VM using Images](#backup-vm-using-images)
  * [Review Availability Sets](#review-availability-sets)
  * [Create a Scale Sets](#create-a-scale-sets)
  * [Create an Application Gateway](#create-an-application-gateway)
  * [Intro](#intro-7)
  * [The Pillars of Observability](#the-pillars-of-observability)
  * [Anatomy of Monitor](#anatomy-of-monitor)
  * [Sources Application](#sources-application)
  * [Sources Operation System](#sources-operation-system)
  * [Sources Resources](#sources-resources)
  * [Source Subscription](#source-subscription)
  * [Sources Tenant](#sources-tenant)
  * [Sources Custom Sources](#sources-custom-sources)
  * [Data Stores](#data-stores)
  * [Log Analytics Workspaces](#log-analytics-workspaces)
  * [Log Analytics](#log-analytics)
  * [Kusto](#kusto)
  * [Kusto Entities](#kusto-entities)
  * [Scalar Data Types](#scalar-data-types)
  * [Control Commands](#control-commands)
  * [Functions](#functions)
  * [Scalar Operators](#scalar-operators)
  * [Tabular Operators](#tabular-operators)
  * [Metrics Explorer](#metrics-explorer)
  * [Alerts](#alerts)
  * [Dashboards](#dashboards)
  * [Workbooks](#workbooks)
  * [Application Insights](#application-insights)
  * [Monitor CheatSheet](#monitor-cheatsheet)
  * [Backup](#backup)
* [Containers](#containers)
  * [ACI](#aci)
  * [ACR](#acr)
  * [AKS](#aks)
* [Networking](#networking)
  * [DNS](#dns)
  * [Networking](#networking-1)
  * [NSG](#nsg)
  * [Virtual WAN](#virtual-wan)
  * [VNGs](#vngs)

## Course Contents

---

### Getting Started

**Timestamp**: 00:00:00 – 00:19:45

**Key Concepts**  
- Purpose of AZ-104 certification: validate Azure administrator skills for managing cloud workloads  
- AZ-104 is an associate-level certification focused on managing/configuring devices, users, permissions, compute, storage, and networking in Azure  
- Azure certification roadmap: Fundamentals (AZ-900) → Associate (e.g., AZ-104) → Expert (e.g., AZ-303) → Specialty certifications  
- AZ-104 is ideal for those seeking configuration-based roles rather than development roles  
- Azure exams emphasize practical, hands-on knowledge more than AWS or GCP exams  
- Exam delivery options: in-person or online proctored (PSI or Pearson VUE)  
- Exam format includes multiple question types: multiple choice, multiple answer, drag and drop, hot areas, and case studies  
- Passing score is 700/1000 (70%), but aiming for 75%+ on practice exams is recommended  
- Exam duration is 180 minutes, but allocate 210 minutes total for instructions and review  
- Certification validity is 24 months with possible free recertification options  
- Official exam skills outline is updated frequently; candidates should check Microsoft’s site for changes  
- Core exam domains:  
  - Manage Azure identities and governance  
  - Implement and manage storage  
  - Deploy and manage Azure compute resources  
  - Configure and manage virtual networks  
  - Monitor and backup Azure resources  

**Definitions**  
- **AZ-104**: Microsoft Azure Administrator Associate certification exam code  
- **Azure Active Directory (Azure AD)**: Cloud-based identity and access management service for user sign-ins and resource access  
- **Role-Based Access Control (RBAC)**: Method to assign permissions to users/groups at different scopes in Azure  
- **Azure Resource Manager (ARM)**: Deployment and management service for Azure resources using templates  
- **Proctored Exam**: An exam supervised by a person (in-person or online) to ensure exam integrity  
- **Case Study Questions**: Exam questions based on a business scenario requiring multiple related answers  

**Key Facts**  
- AZ-104 is generally taken after AZ-900 and before expert-level certifications like AZ-303  
- Study time recommendations:  
  - 2-3 years Azure experience → ~12 hours study  
  - 1 year experience → ~30 hours study  
  - No experience but passed AZ-900 → ~60 hours study (3 weeks at 1-3 hours/day)  
- Exam question count: 40 to 60 questions  
- No penalty for wrong answers; never leave questions blank  
- Some questions cannot be skipped and must be answered in order  
- Exam scoring is scaled; some questions worth more than one point  
- Microsoft Learn provides free content but is generally insufficient alone to pass AZ-104  
- Paid practice exams and layered study materials increase chances of passing  
- Certification lasts 24 months before recertification is required  

**Examples**  
- Example exam question type: Steps to set up Azure File Share Sync in correct order  
- Use of Azure AD for single sign-on to multiple resources like Microsoft 365, Azure Portal, SaaS apps, and internal apps  
- Exam pro platform uses Azure AD for admin panel login  

**Key Takeaways 🎯**  
- Start your Azure certification journey with AZ-900 before AZ-104  
- AZ-104 focuses on practical skills managing core Azure services: identities, storage, compute, networking, and monitoring  
- Hands-on labs and follow-alongs in your own Azure account are critical for success  
- Aim for 85% on practice exams to build a buffer for the real exam’s 70% passing score  
- Prefer in-person exam delivery if possible to avoid technical issues common in online proctored exams  
- Regularly check Microsoft’s official exam guide for updates and changes to exam content  
- Understand the variety of question types and be prepared for case studies and scenario-based questions  
- Use multiple study resources including free videos, Microsoft Learn, and paid practice exams for best results  
- Manage your exam time wisely, allowing extra time for instructions and review  
- Certification renewal is required every 2 years, with potential free recertification options available  

---

## Monitor

---

### Intro

**Timestamp**: 00:19:45 – 00:21:43

**Key Concepts**  
- Azure Active Directory (Azure AD) is a cloud-based identity and access management service.  
- It manages user sign-ins and access to both external and internal resources.  
- Supports single sign-on (SSO) to enable users to log into multiple applications with one set of credentials.  
- Azure AD integrates with various platforms including Microsoft Office 365, Azure Portal, SaaS apps, on-premises applications, and workstations.  
- Azure AD comes in four editions with increasing features: Free, Office 365 Apps, Premium P1, and Premium P2.  
- Higher tiers include advanced features like hybrid identity synchronization, conditional access, identity protection, and governance.  
- Custom access controls require Premium P1 or P2 licenses.

**Definitions**  
- **Azure Active Directory (Azure AD)**: Microsoft’s cloud-based identity and access management service that helps employees sign in and access resources securely.  
- **Single Sign-On (SSO)**: A user authentication process that permits a user to access multiple applications with one set of login credentials.  
- **Hybrid Architecture**: A setup that integrates on-premises Active Directory with Azure AD for seamless identity management across environments.

**Key Facts**  
- Free tier includes MFA (Multi-Factor Authentication), SSO, basic security, usage reports, and user management.  
- Office 365 Apps tier adds company branding, SLA, and sync capabilities between on-premises and cloud.  
- Premium tiers (P1 and P2) target enterprise and hybrid environments with advanced group access, conditional access, identity protection, and governance.  
- Custom access controls are only available in Premium tiers.  
- Azure AD is widely adopted in enterprises and used in real-world scenarios such as Exam Pro’s integration with Microsoft Teams, AWS, and Azure.

**Examples**  
- Exam Pro uses Azure AD for:  
  - Microsoft Teams authentication  
  - Admin panel login for the Exam Pro platform  
  - Logging into AWS and Azure portals  

**Key Takeaways 🎯**  
- Understand Azure AD as a core cloud identity and access management service essential for enterprise environments.  
- Know the four Azure AD editions and their feature differences, especially the limitations of the free tier vs. premium tiers.  
- Remember that SSO is a major benefit of Azure AD, simplifying user access across multiple platforms.  
- Be aware that custom access controls require Premium licenses—important for exam scenarios involving access management.  
- Recognize the practical use cases of Azure AD in real organizations to contextualize its importance.

---

## Azure AD

---

### Use Cases

**Timestamp**: 00:21:43 – 00:22:44

**Key Concepts**  
- Azure AD can authenticate and authorize users across multiple sources.  
- Integration with on-premise Active Directory via Azure AD Connect.  
- Support for external identity providers (IdPs) like Facebook and Google for user login.  
- Connection to cloud applications such as Office 365 and Microsoft Azure through Azure AD.  
- App registrations enable web applications to connect and authenticate via Azure AD.

**Definitions**  
- **Azure AD Connect**: A tool that synchronizes on-premise Active Directory with Azure AD to enable hybrid identity scenarios.  
- **Identity Provider (IdP)**: A service that authenticates users, e.g., Facebook, Google, allowing users to log in using those credentials.  
- **App Registration**: The process of registering an application in Azure AD to enable authentication and authorization.

**Key Facts**  
- Azure AD supports authentication to on-premise AD, web applications, external IdPs, and cloud services.  
- External identities allow users to log in using social accounts like Facebook or Google.  
- Azure AD acts as a central identity platform bridging on-premise and cloud environments.

**Examples**  
- Using Azure AD Connect to sync on-premise AD with Azure AD.  
- Web applications authenticating users via Azure AD app registrations.  
- Users logging into applications using Facebook or Google accounts as external IdPs.  
- Cloud applications like Office 365 and Microsoft Azure integrated with Azure AD for authentication.

**Key Takeaways 🎯**  
- Understand that Azure AD is a versatile identity platform supporting hybrid and cloud-only scenarios.  
- Remember Azure AD Connect is essential for linking on-premise AD with Azure AD.  
- Know that Azure AD supports external IdPs, enabling social logins.  
- App registrations are critical for enabling web apps to use Azure AD authentication.  
- Azure AD centralizes identity management across diverse environments and applications.

---

### AD vs AAD

**Timestamp**: 00:22:44 – 00:23:37

**Key Concepts**  
- Active Directory (AD) is a long-established on-premise identity management service.  
- Azure Active Directory (Azure AD or AAD) is a cloud-based identity as a service (IDaaS) solution.  
- Both AD and Azure AD coexist and serve different purposes but can be connected.  
- AD manages on-premise infrastructure with a single user identity across systems.  
- Azure AD extends identity management to cloud and hybrid environments.

**Definitions**  
- **Active Directory Domain Services (AD DS)**: Introduced in Windows 2000, it allows organizations to manage multiple on-premise infrastructure components and systems using a single user identity.  
- **Azure Active Directory (Azure AD)**: A cloud-hosted identity as a service (IDaaS) solution for managing user identities and access to applications across cloud and on-premise environments.

**Key Facts**  
- Active Directory has been around for over 20 years (since Windows 2000).  
- Azure AD provides identity management as a cloud service, supporting both cloud and on-premise apps.  
- AD is primarily for on-premise use; Azure AD is cloud-based.  
- AD and Azure AD can be connected to work together.

**Examples**  
- None specifically mentioned in this section.

**Key Takeaways 🎯**  
- Remember that AD is the traditional on-premise directory service, while Azure AD is the modern cloud-based identity service.  
- Both services are still relevant and often integrated in enterprise environments.  
- Azure AD is not just a cloud version of AD but an identity as a service platform designed for cloud and hybrid scenarios.  
- Understanding the distinction and relationship between AD and Azure AD is critical for exam questions on identity management in Microsoft environments.

---

### Terminology

**Timestamp**: 00:23:37 – 00:25:54

**Key Concepts**  
- Active Directory (AD) terminology is important to understand even if not core to Azure exams.  
- Domains organize AD objects logically, similar to Azure resource groups.  
- Domain controllers authenticate users and authorize access, often deployed redundantly.  
- AD objects include users, groups, computers, printers, shared folders, etc.  
- Group Policy Objects (GPOs) control policy settings and access permissions for AD objects.  
- Organizational Units (OUs) are subdivisions within AD for further logical grouping of objects.  
- Directory services store and provide access to directory data, running on domain controllers.  
- A tenant represents an organization in Azure AD and is created automatically with Azure, Intune, or Microsoft 365 sign-up.

**Definitions**  
- **Domain**: A logical grouping of Active Directory objects on a network, organized by a single authentication database.  
- **Domain Controller**: A server that authenticates user identities and authorizes access to resources; multiple domain controllers provide redundancy and availability.  
- **Domain Computer**: A computer registered with the central authentication database; considered an AD object.  
- **AD Object**: The basic element in Active Directory such as users, groups, computers, printers, shared folders, etc.  
- **Group Policy Object (GPO)**: A virtual collection of policy settings that controls what an AD object can access.  
- **Organizational Unit (OU)**: A subdivision within Active Directory used to group users, groups, computers, and other OUs logically.  
- **Directory Service**: A service that stores directory data and makes it available to network users and administrators; runs on domain controllers.  
- **Tenant**: Represents an organization in Azure AD; each tenant is distinct and created automatically when signing up for Azure, Intune, or Microsoft 365.

**Key Facts**  
- Domains are logical groupings similar to Azure resource groups but for AD objects.  
- Multiple domain controllers are common to ensure redundancy and availability.  
- A tenant has a unique tenant ID and is tied to the Azure AD service instance.  
- Tenants are separate and distinct from each other.  
- Example tenant shown: "ExamPro" tenant licensed for Office 365 tier of Azure AD.

**Examples**  
- Domain controller redundancy allows users to log in from different locations.  
- Tenant example: "ExamPro" tenant with its own tenant ID and Office 365 licensing.

**Key Takeaways 🎯**  
- Understand the role and purpose of domains, domain controllers, and AD objects as foundational AD concepts.  
- Know that Group Policy Objects and Organizational Units help manage and organize AD objects and their permissions.  
- Remember that directory services run on domain controllers to provide authentication and directory data access.  
- Recognize that an Azure AD tenant represents an organization and is created automatically with Microsoft cloud services sign-up.  
- While Azure exams focus more on Azure AD, familiarity with traditional AD terminology helps in understanding documentation and hybrid environments.

---

### Tenant

**Timestamp**: 00:25:54 – 00:26:42

**Key Concepts**  
- A tenant represents an organization within Azure Active Directory (Azure AD).  
- Each tenant is dedicated to a single Azure AD service instance.  
- Tenants are distinct and separate from one another.  
- A tenant is automatically created when signing up for Microsoft Azure, Microsoft Intune, or Microsoft 365.  
- Tenant information includes a unique tenant ID and licensing details (e.g., Office 365 tier).  
- Azure AD provides a domain controller for authentication, but enterprises may choose to set up their own domain controller if needed.

**Definitions**  
- **Tenant**: An organization’s dedicated instance within Azure Active Directory, created automatically upon subscription to Microsoft cloud services.  
- **Domain Controller**: The server responsible for authenticating users to the directory service.

**Key Facts**  
- Each Azure AD tenant has a unique tenant ID.  
- Tenants are licensed for specific service tiers, such as Office 365.  
- Azure automatically sets up a domain controller when creating an Active Directory in the cloud.  
- Enterprises with existing on-premises Active Directory may migrate to Azure AD for a fully managed cloud directory but might need to maintain their own domain controller for certain domain services not available in Azure AD.

**Examples**  
- The speaker’s tenant named "ExamPro one" with its own tenant ID and licensed for Office 365.  

**Key Takeaways 🎯**  
- Remember that a tenant is the fundamental organizational unit in Azure AD and is created automatically with Microsoft cloud subscriptions.  
- Each tenant is isolated and has its own unique tenant ID.  
- Understanding tenant licensing (e.g., Office 365) helps identify the Azure AD service tier in use.  
- Know that Azure AD provides domain controllers by default, but enterprises may need to deploy their own domain controllers to support features not available in Azure AD’s managed domain services.

---

### AD DS

**Timestamp**: 00:26:42 – 00:27:51

**Key Concepts**  
- Azure Active Directory Domain Services (Azure AD DS) provide managed domain services in the cloud.  
- Azure AD DS supports domain joins, group policies, LDAP, and NTLM authentication.  
- Azure AD DS eliminates the need to deploy, manage, or patch domain controllers manually.  
- Organizations with existing on-premises Active Directory can move to Azure AD for a fully managed cloud directory but may need Azure AD DS for full domain controller features.

**Definitions**  
- **Domain Controller**: A server that users authenticate against to access directory services.  
- **Azure Active Directory Domain Services (Azure AD DS)**: A managed domain service in Azure that provides traditional domain controller features without the need for manual deployment or management.

**Key Facts**  
- Azure sets up an Active Directory automatically, but enterprises may choose to set up their own domain controller in Azure for full feature support.  
- Azure AD DS supports key domain services such as domain join, group policies, LDAP, and NTLM authentication.  
- Azure AD DS is fully managed by Azure, meaning no manual patching or management is required.

**Examples**  
- An enterprise with an existing on-premises Active Directory may move to Azure AD but still require Azure AD DS to access domain controller features not available in the default Azure AD setup.

**Key Takeaways 🎯**  
- Understand the difference between Azure AD and Azure AD DS: Azure AD is primarily identity management, while Azure AD DS provides traditional domain controller capabilities in a managed service.  
- Remember that Azure AD DS supports legacy authentication protocols like NTLM and LDAP, which are not natively supported in Azure AD alone.  
- For exam scenarios involving hybrid or cloud migrations, know when to use Azure AD DS to maintain domain services without managing domain controllers yourself.

---

### AD Connect

**Timestamp**: 00:27:51 – 00:29:04

**Key Concepts**  
- Azure AD Connect is a hybrid service connecting on-premise Active Directory (AD) to Azure AD.  
- Enables seamless single sign-on (SSO) from on-premise workstations to Microsoft Azure.  
- Supports multiple sign-in methods and synchronization features.  
- Provides health monitoring through Azure AD Connect Health.

**Definitions**  
- **Azure AD Connect**: A tool/service that synchronizes and integrates on-premise Active Directory with Azure Active Directory to enable hybrid identity management.  
- **Password Hash Synchronization**: A sign-in method that synchronizes a hash of the on-premise AD user password with Azure AD.  
- **Password Authentication**: A sign-in method allowing users to use the same password on-premise and in the cloud.  
- **Federation Integration**: Uses on-premise AD FS infrastructure to enable hybrid environments and certificate renewal.  
- **Synchronization**: The process of creating and matching users, groups, and other AD objects between on-premise AD and Azure AD.  
- **Azure AD Connect Health**: A monitoring service providing a centralized view of Azure AD Connect activity and health status in the Azure portal.

**Key Facts**  
- Azure AD Connect supports:  
  - Password hash synchronization  
  - Password authentication  
  - Federation integration (using AD FS)  
  - Synchronization of users, groups, and objects  
  - Health monitoring via Azure AD Connect Health  
- Enables seamless single sign-on experience for users across on-premise and cloud environments.

**Examples**  
- None specifically mentioned for Azure AD Connect itself, but the service is described as enabling seamless SSO from on-premise workstations to Azure.

**Key Takeaways 🎯**  
- Remember Azure AD Connect is essential for hybrid identity setups connecting on-prem AD with Azure AD.  
- Know the different sign-in methods: password hash sync, password authentication, and federation integration.  
- Synchronization ensures AD objects are consistent across on-prem and cloud.  
- Azure AD Connect Health is important for monitoring and troubleshooting the hybrid connection.  
- Focus on the hybrid nature and seamless SSO capabilities for exam scenarios.

---

### Users

**Timestamp**: 00:29:04 – 00:30:04

**Key Concepts**  
- Users represent identities for people or employees within a domain.  
- Users have login credentials to access the Azure portal.  
- Users can be assigned roles, including administrative roles.  
- Users can be added to groups to simplify permission management.  
- Authentication enforcement (e.g., MFA) can be applied to users.  
- User sign-ins and device access can be tracked and managed.  
- Microsoft licenses can be assigned to users.  
- Azure AD distinguishes between two types of users: organizational users and guest users from other organizations.  
- Groups allow resource owners to assign access permissions collectively rather than individually.  
- Group owners manage membership and permissions within groups.  
- Roles and applications can be assigned directly to groups.  
- Group owners can enable self-service group joining with options for automatic acceptance or approval.

**Definitions**  
- **User**: An identity representing a person or employee in a domain, with credentials to log into Azure portal.  
- **Guest User**: A user from an external organization invited to access resources.  
- **Group Owner**: A user with permissions to add or remove members from a group.  
- **Group Member**: A user who has rights to perform actions as assigned within the group.

**Key Facts**  
- Users can be tracked for sign-in activity and device usage.  
- Groups can contain owners and members with distinct permission levels.  
- Assigning roles or applications to groups simplifies access management.  
- Self-service group joining reduces administrative overhead.

**Examples**  
- The presenter shows their own user account with login counts and group memberships in Azure AD.  
- Groups in "Exam Pro" contain owners who manage membership and members who have assigned rights.

**Key Takeaways 🎯**  
- Remember that users are the fundamental identity objects in Azure AD with credentials and access rights.  
- Distinguish between organizational users and guest users for access scenarios.  
- Use groups to efficiently manage permissions and role assignments at scale.  
- Leverage group owners and self-service group joining to reduce manual administrative tasks.  
- Track user sign-ins and device access to maintain security and compliance.

---

### Groups

**Timestamp**: 00:30:04 – 00:30:53

**Key Concepts**  
- Groups in Azure AD allow resource owners to assign access permissions collectively to all group members.  
- Groups can have owners and members; owners manage group membership, members receive assigned rights.  
- Roles and applications can be assigned directly to groups.  
- Group owners can enable users to request to join groups, with options for automatic acceptance or approval required.

**Definitions**  
- **Group Owner**: A user with permissions to add or remove members from the group.  
- **Group Member**: A user who belongs to the group and inherits the access permissions assigned to the group.

**Key Facts**  
- Assigning permissions to groups avoids the need to assign rights individually to each user.  
- Group owners can configure join settings to allow self-service group membership requests.  
- Role and application assignments can be made directly to groups, simplifying access management.

**Examples**  
- Example given: In the "Exam Pro" tenant, multiple groups exist with owners and members managing access.

**Key Takeaways 🎯**  
- Remember that groups streamline access management by bundling permissions for multiple users.  
- Know that group owners control membership and can set join policies to reduce administrative overhead.  
- Understand that roles and applications can be assigned at the group level, not just to individual users.  
- Be familiar with the concept of self-service group joining and approval workflows as a practical feature.

---

### Assign Access Rights

**Timestamp**: 00:30:53 – 00:31:38

**Key Concepts**  
- There are four different ways to assign users rights to access resources in Azure AD.  
- Access can be assigned directly to users or indirectly via groups or rules.  
- External authorities can also provide access rights.

**Definitions**  
- **Direct Assignment**: The resource owner assigns access rights directly to an individual user.  
- **Group Assignment**: The resource owner assigns access rights to a group, automatically granting access to all group members.  
- **Rule-Based Assignment**: The resource owner creates a group and uses rules to dynamically assign users to the resource based on criteria.  
- **External Authority Assignment**: Access rights are granted based on an external source such as an on-premises directory or SaaS application.

**Key Facts**  
- Four methods to assign access rights: Direct, Group, Rule-based, External authority.  
- Group assignment simplifies management by granting access to all members of a group at once.  
- Rule-based assignment automates user membership in groups based on defined rules.  
- External authority assignment integrates external identity providers or directories for access control.

**Examples**  
- None specifically mentioned in this segment.

**Key Takeaways 🎯**  
- Understand the four methods of assigning access rights and when to use each.  
- Group assignment is efficient for managing multiple users at once.  
- Rule-based assignment helps automate access based on user attributes or conditions.  
- External authority assignment is important for hybrid or SaaS environments integrating external identities.  
- Be prepared to identify and differentiate these assignment methods on the exam.

---

### External Identities

**Timestamp**: 00:31:38 – 00:32:17

**Key Concepts**  
- External identities in Azure AD enable users outside your organization to access your apps and resources.  
- External users can sign in using their preferred identity providers.  
- Supports collaboration with partners, distributors, suppliers, vendors, and other guests.  
- Allows sharing of apps with external users (B2B scenarios).  
- Supports development of apps for Azure AD tenants (single-tenant or multi-tenant).  
- Azure AD B2C enables creation of white-label apps for consumers and customers.

**Definitions**  
- **External Identities**: Azure AD feature that allows external users to access organizational resources using their own identity providers (e.g., Google, Facebook).  
- **Azure AD B2C**: A service to develop consumer-facing applications that allow users to sign in with social or local accounts.

**Key Facts**  
- External identities can come from social identity providers like Google or Facebook.  
- External identities facilitate business-to-business (B2B) collaboration.  
- Azure AD supports both single-tenant and multi-tenant app development for external access.

**Examples**  
- Partners, distributors, suppliers, vendors accessing resources using their own identities.  
- Sharing apps with external users for B2B purposes.  
- Developing white-label consumer apps using Azure AD B2C.

**Key Takeaways 🎯**  
- Remember that external identities allow external users to use their preferred login methods without needing an Azure AD account in your tenant.  
- Use external identities to enable secure B2B collaboration.  
- Azure AD B2C is specifically for consumer-facing applications, distinct from B2B external identities.  
- Understand the difference between B2B (external users accessing your resources) and B2C (consumer apps with external identities).

---

### Create a Tenant

**Timestamp**: 00:32:17 – 00:35:14

**Key Concepts**  
- Azure Active Directory (Azure AD) tenants are logical containers grouping users within an organization.  
- A tenant is essentially an instance of Azure Active Directory.  
- You can create multiple tenants to represent different organizations or isolated environments.  
- There are two main types of tenants: B2B (Business to Business) and B2C (Business to Consumer).  
- B2B tenants allow collaboration between different businesses.  
- B2C tenants enable users to access consumer-facing applications and share administration experiences.  
- When creating a tenant, you must provide a unique organization name and initial domain name.  
- The initial domain is appended with “.onmicrosoft.com” (not Microsoft.com as misstated in the transcript).  
- The tenant’s default location can be set (e.g., Canada), but data center deployment is typically in the US.  
- Tenant creation requires a unique domain name; if the chosen name is taken, you must try alternatives.  

**Definitions**  
- **Tenant**: An instance of Azure Active Directory that logically groups users and resources for an organization.  
- **B2B (Business to Business)**: Tenant type that facilitates collaboration between multiple organizations.  
- **B2C (Business to Consumer)**: Tenant type designed for consumer-facing applications allowing external users to access services.  

**Key Facts**  
- Every Azure account starts with a single default tenant representing your organization.  
- Tenant names and initial domains must be unique across Azure AD.  
- The initial domain uses the format: `[chosenname].onmicrosoft.com`.  
- Tenant creation can take a few minutes to complete.  
- Location selection affects defaults but does not necessarily change the physical data center location.  

**Examples**  
- Created a tenant named “Starfleet” but had to modify the domain name multiple times due to naming conflicts (e.g., tried “USS Starfleet” but it was invalid due to characters, ended with “Starfleet1984”).  
- Switched between multiple tenants such as “Hushnook,” “ExamPro,” and “Starfleet” to isolate users per tenant.  

**Key Takeaways 🎯**  
- Understand that tenants are the fundamental boundary for users and resources in Azure AD.  
- Know the difference between B2B and B2C tenants and their use cases.  
- When creating a tenant, ensure the organization name and domain are unique and valid (no special characters, numeric allowed).  
- Tenant creation is done via the Azure portal under Azure Active Directory > Manage tenants.  
- You can switch between tenants in the portal to manage different isolated environments.  
- Remember that the initial domain ends with “.onmicrosoft.com” and must be unique globally.  
- Tenant location setting is mostly for administrative purposes; actual data center location may differ.  
- Practice creating tenants to get familiar with naming constraints and the creation workflow.

---

### Upgrade License

**Timestamp**: 00:35:14 – 00:37:58

**Key Concepts**  
- Azure Active Directory (Azure AD) tenants can be switched to isolate users and resources.  
- Azure AD has different license tiers, with higher tiers offering more features.  
- Azure AD Premium P2 is a popular enterprise tier with advanced features.  
- You can upgrade an Azure AD tenant license to Premium P2 via the Azure portal.  
- A free trial for Azure AD Premium P2 is available but limited to one trial per account.  
- Upgrading to Premium P2 enables additional features like multi-factor authentication, policy-driven management, and end-user self-service.  

**Definitions**  
- **Azure AD Tenant**: A dedicated instance of Azure Active Directory that contains users, groups, and applications isolated from other tenants.  
- **Azure AD Premium P2**: A paid license tier of Azure Active Directory offering advanced security and management features, including dynamic role assignment and enhanced identity protection.  

**Key Facts**  
- Azure AD Free is the default tier with basic functionality.  
- Upgrading to Premium P2 costs money but includes a free trial period during which you are not billed.  
- The free trial must be explicitly activated via the "Licenses" section in the Azure portal under "All products" → "Try and buy."  
- Activation of the Premium P2 license may take some time to reflect in the Azure portal UI.  

**Examples**  
- Switching tenants from "ExamPro," "Hushnook," and "Starfleet" to isolate users.  
- Activating the Azure AD Premium P2 free trial by navigating to Licenses → All products → Azure AD Premium 2 → Free trial → Activate.  

**Key Takeaways 🎯**  
- Know how to switch between Azure AD tenants to manage isolated user sets.  
- Understand the difference between Azure AD Free and Premium tiers, especially Premium P2.  
- Be able to locate and activate the Azure AD Premium P2 free trial in the Azure portal.  
- Remember that the Premium P2 license unlocks advanced features useful in enterprise environments.  
- The UI may not immediately update after license activation—refresh or wait a few moments.  
- While Premium P2 features are important, some may not be directly tested but knowing the upgrade process is essential.  

---

### User and Groups

**Timestamp**: 00:37:58 – 00:41:39

**Key Concepts**  
- Tenants in Azure AD and how to identify/switch between them  
- Creating groups before creating users for easier assignment  
- Types of groups: Security groups vs Microsoft 365 groups  
- Membership types: Static vs Dynamic (Dynamic requires Azure AD Premium P2)  
- User creation process including auto-generated passwords and group/role assignment  
- Soft-delete and recovery of users and groups within 30 days  

**Definitions**  
- **Tenant**: A dedicated instance of Azure Active Directory representing an organization.  
- **Security Group**: A group used primarily for managing access to Azure resources and permissions.  
- **Microsoft 365 Group**: A group that provides access to collaboration tools like mailbox, calendar, files, and SharePoint.  
- **Dynamic Group**: A group where membership is automatically managed based on rules or queries (requires Azure AD Premium P2).  
- **Soft Delete**: A feature where deleted users or groups are retained for 30 days before permanent deletion, allowing recovery.  

**Key Facts**  
- You can see the current tenant in the top right corner of the Azure portal.  
- Switching tenants can be done via the "Switch Tenant" button or by searching for Azure Active Directory.  
- Security groups are used for Azure-related access; Microsoft 365 groups are for collaboration tools.  
- Dynamic membership is only available with Azure AD Premium P2 license; free tier users cannot use dynamic groups.  
- Auto-generated passwords for new users are typically 4 letters followed by 4 numbers (easy to remember but not very secure).  
- Deleted users and groups remain recoverable for 30 days.  

**Examples**  
- Created a security group named "developers" with manual membership assignment.  
- Created a user named "Kevin Uxbridge" with an auto-generated password and assigned him to the "developers" group and specific roles.  
- Demonstrated restoring a deleted user named "Rishon" from the soft-delete state.  

**Key Takeaways 🎯**  
- Always create groups before users to simplify user management and access assignment.  
- Understand the difference between security groups and Microsoft 365 groups for correct usage.  
- Dynamic groups require Azure AD Premium P2; know your licensing limitations.  
- Auto-generated passwords are temporary; users must reset them on first login.  
- Deleted users and groups can be restored within 30 days—useful for accidental deletions.  
- Tenant context is important—always verify which tenant you are working in before making changes.

---

### Guest Users

**Timestamp**: 00:41:39 – 00:43:53

**Key Concepts**  
- Guest users allow inviting users from other Azure AD tenants into your tenant.  
- Inviting guest users is simpler than setting up federation between Active Directories.  
- Federation involves joining multiple Active Directories (on-premises or external), which has significant administrative overhead.  
- Azure AD guest user invitations are done via email and can be assigned to groups and roles.  

**Definitions**  
- **Guest User**: A user invited from an external Azure AD tenant to collaborate within your tenant without needing federation.  
- **Federation**: The process of linking two or more Active Directories to allow shared authentication and access, typically complex and administratively heavy.  

**Key Facts**  
- Guest users show up in the tenant’s user list marked as "guest."  
- Invitations to guest users are sent via email.  
- Guest user creation can be done through the Azure portal under "Users" → "New guest user."  
- You can assign guest users to groups and roles just like regular users.  

**Examples**  
- Created a user named "Hushnook" in one tenant (Hushnuk one) with email hushnook@microsoft.com.  
- Switched to another tenant (Starfleet) and invited "Hushnook" as a guest user by entering their email and sending an invitation.  

**Key Takeaways 🎯**  
- Remember that guest users simplify cross-tenant collaboration without federation complexity.  
- Guest users must be invited via their email address and will receive an invitation to join.  
- Guest users appear distinctly as "guest" in the user list.  
- Assigning groups and roles to guest users works the same as for internal users.  
- Federation is more complex and generally avoided if all parties use Azure AD.  

---

### Mass Import

**Timestamp**: 00:43:53 – 00:46:45

**Key Concepts**  
- Bulk operations allow importing multiple users into an account simultaneously.  
- A CSV template is provided to facilitate bulk user creation.  
- The CSV must include required fields such as principal username and password.  
- After filling out the CSV, it can be uploaded to the system for processing.  
- The system provides status updates on the bulk import operation, including success or failure counts.  
- Successfully imported users appear in the user list after completion.

**Definitions**  
- **Bulk Create**: A feature that enables the creation of multiple user accounts at once by uploading a CSV file with user details.  
- **Principal Username**: The unique identifier for a user in the system, required in the CSV for bulk import.

**Key Facts**  
- The CSV template can be downloaded directly from the bulk create interface.  
- Required CSV fields include principal username and password; other fields may be optional.  
- The bulk import process may take a short time to complete and can be monitored via a status page.  
- The example used the principal username "Picard" repeatedly for multiple users.  
- The bulk import result shows total requests, successes, and failures.

**Examples**  
- Downloaded a CSV template, edited it in Excel to add multiple users with principal username "Picard" and a password.  
- Uploaded the CSV file via drag-and-drop or file selection and submitted it for processing.  
- Checked the bulk operation results page to confirm success with 0 failures.  
- Verified that the imported users appeared in the user list labeled as "mass imported."

**Key Takeaways 🎯**  
- Always use the provided CSV template to ensure correct formatting for bulk imports.  
- Make sure to include all required fields, especially principal username and password.  
- Monitor the bulk import status to confirm successful user creation and troubleshoot failures.  
- Bulk import is an efficient way to add many users at once, saving time compared to manual entry.  
- Remember that after import, users will appear in the system and can be managed like any other user.

---

### MFA

**Timestamp**: 00:46:45 – 00:50:51

**Key Concepts**  
- Multi-Factor Authentication (MFA) adds a secondary step to confirm user identity during login.  
- MFA can be enabled per user or in bulk for multiple users.  
- MFA options include phone call, text message, mobile app notification, verification codes, and hardware tokens (e.g., UbiKey).  
- App passwords allow users to sign into non-browser apps when MFA is enabled.  
- Trusted IP addresses can be whitelisted to bypass MFA prompts.  
- MFA enforcement can require users to create app passwords for non-browser apps.  
- Remember MFA on trusted devices can be configured for a set number of days to reduce repeated prompts.

**Definitions**  
- **Multi-Factor Authentication (MFA)**: A security process requiring users to provide two or more verification factors to gain access to a resource, enhancing account security beyond just a password.  
- **App Passwords**: Special passwords generated to allow non-browser applications (like Outlook or Lynx) to authenticate when MFA is enabled.  
- **Hardware Token**: A physical device (e.g., UbiKey) used as a second factor for authentication.

**Key Facts**  
- MFA is often disabled by default, especially on free Azure AD versions.  
- Azure AD Premium P2 license is required to enable MFA features fully.  
- Verification options include:  
  - Call to phone (user receives a call and enters letters/numbers)  
  - Text message  
  - Mobile app notification (via companion app on Android, iOS, Windows)  
  - Verification code from mobile app or hardware token  
- Bulk enabling MFA can be done by downloading a sample CSV file, editing user MFA status, and uploading it back.  
- Enforcing MFA means users must create app passwords for non-browser apps.  
- Remember MFA on trusted devices can be set for a custom number of days or disabled for maximum security.

**Examples**  
- Enabling MFA for a single user named Kevin by clicking "Enable" next to his name.  
- Bulk update example: downloading a sample file, pasting user names and MFA status, then uploading it to enable MFA for multiple users.  
- Using a UbiKey as a hardware token for MFA.  
- Enforcing MFA so users must create app passwords to use Outlook or Lynx.

**Key Takeaways 🎯**  
- Know that MFA adds an essential security layer beyond passwords and is highly recommended.  
- Understand the different verification methods available and when hardware tokens might be used.  
- Remember that Azure AD Premium P2 is required for full MFA capabilities; free tiers may not support it.  
- Be familiar with the process to enable MFA both individually and in bulk.  
- App passwords are necessary for non-browser apps once MFA is enforced.  
- Consider the trade-off between user convenience (remember MFA on trusted devices) and security (require MFA every time).  
- Enforcing MFA is a best practice to ensure users comply with security policies.

---

### Self Service Rest Password

**Timestamp**: 00:50:51 – 00:53:22

**Key Concepts**  
- Enabling self-service password reset (SSPR) allows users to reset their own passwords without administrator intervention.  
- Password reset can be enabled for all users or targeted groups (e.g., developers).  
- Authentication methods can be configured to require multiple verification steps for password reset.  
- Custom and predefined security questions can be used as part of the authentication process.  
- Users can be required to register their authentication methods upon sign-in.  
- Admins and users can be notified about password reset events.  
- A customizable help desk link/email can be provided for users needing assistance.  
- Usage and insights provide data on password reset activity.

**Definitions**  
- **Self-Service Password Reset (SSPR)**: A feature that allows users to reset their own passwords securely without needing to contact an administrator.  
- **Authentication Methods**: Verification steps (e.g., security questions, phone, email) required to confirm user identity during password reset.  
- **Registration**: The process where users set up their authentication methods, often required at first sign-in or periodically thereafter.

**Key Facts**  
- Password reset can be enabled tenant-wide or scoped to specific groups.  
- Number of authentication methods required for reset can be set (e.g., two methods for higher security).  
- Custom security questions can be created and added by administrators.  
- Default reconfirmation period for authentication methods is 180 days.  
- Notifications can be sent to users upon password reset and to all admins when other admins reset passwords.  
- Help desk contact info (URL or email) can be customized for user support.  

**Examples**  
- Adding a custom security question such as "What is the best song?" to the pool of questions users can answer during password reset.  
- Enabling notifications for password resets and admin password changes.  
- Providing an email address as a help desk contact for users needing assistance.

**Key Takeaways 🎯**  
- Always enable self-service password reset to reduce admin workload and improve user experience.  
- Configure multiple authentication methods to enhance security during password resets.  
- Use a mix of custom and predefined security questions to provide flexibility and security.  
- Require users to register authentication methods and periodically reconfirm them (default 180 days).  
- Enable notifications for password reset events to maintain security awareness.  
- Customize help desk contact information to ensure users know where to get help.  
- Monitor usage and insights to track password reset activity and identify potential issues.

---

### AD CheatSheet

**Timestamp**: 00:53:22 – 00:57:31

**Key Concepts**  
- Active Directory (AD) is Microsoft’s Identity and Access Management (IAM) service for on-premises environments.  
- Azure Active Directory (Azure AD) is the cloud-based version of AD, offered as Identity as a Service (IDaaS).  
- Azure AD comes in four editions: Free, Office 365 Apps, Premium P1, and Premium P2.  
- Azure AD supports authentication and authorization to multiple sources (on-premises, web apps, external identities like Facebook/Google, Office 365, Azure).  
- Key AD terminologies: domain, domain controller, domain computer, AD objects, Group Policy Objects (GPO), organizational units (OUs), directory services.  
- Azure AD tenant represents an organization and is a dedicated Azure AD instance created automatically upon sign-up.  
- Azure AD Domain Services (ADDS) provide managed domain services in Azure (domain join, group policies, LDAP).  
- Azure AD Connect synchronizes on-prem AD with Azure AD and supports features like password hash sync, pass-through authentication, federation, health monitoring.  
- Users in Azure AD are AD objects representing identities; two types exist: member users (belong to your org) and guest users (external).  
- Groups in Azure AD allow bulk assignment of access permissions; groups have owners and members.  
- Role and application assignments can be made directly to groups.  
- Group owners can configure self-service group join requests with auto-approval or approval workflows.  
- Four ways to assign resource access rights: direct assignment, group assignment, rule-based assignment, external authority assignment.

**Definitions**  
- **Active Directory (AD)**: Microsoft’s on-premises identity and access management service.  
- **Azure Active Directory (Azure AD)**: Cloud-based version of AD, offered as Identity as a Service (IDaaS).  
- **Domain**: A network area organized by a single authentication database; logical grouping of AD objects.  
- **Domain Controller (DC)**: Server that authenticates user identities and authorizes access to resources.  
- **Domain Computer**: A computer registered with the central authentication database (an AD object).  
- **AD Objects**: Base elements in AD such as users, groups, printers, etc.  
- **Group Policy Object (GPO)**: A virtual collection of policy settings applied to AD objects.  
- **Organizational Unit (OU)**: A subdivision within AD to organize users, groups, and computers.  
- **Directory Service**: Service like Active Directory Domain Services (ADDS) that stores directory data and provides access to network users.  
- **Tenant**: A dedicated Azure AD instance representing an organization, created automatically on sign-up.  
- **Azure AD Domain Services (ADDS)**: Managed domain services in Azure providing domain join, group policies, LDAP, etc.  
- **Azure AD Connect**: Tool to synchronize on-prem AD with Azure AD, supporting password hash sync, pass-through authentication, federation, and health monitoring.  
- **User (Azure AD)**: Identity object representing a person with login credentials; can be member or guest.  
- **Group (Azure AD)**: Collection of users to assign access permissions collectively.  

**Key Facts**  
- Azure AD editions: Free, Office 365 Apps, Premium P1, Premium P2.  
- Azure AD Connect features: password hash sync, pass-through authentication, federation, synchronization, health monitoring.  
- Four ways to assign access rights: direct, group, rule-based, external authority.  
- Tenant is distinct and separate from other tenants.  
- Lift and shift of AD to Azure may require ADDS as not all features are supported natively.  

**Examples**  
- External identities such as Facebook or Google can be used for authentication via Azure AD.  
- Group owners can configure groups to allow users to request to join, with options for auto-approval or requiring approval.  
- Assigning roles and applications directly to groups simplifies access management.  

**Key Takeaways 🎯**  
- Understand the difference between on-prem AD and Azure AD (cloud-based IDaaS).  
- Know the four Azure AD editions and their significance.  
- Be familiar with key AD terminologies and their roles (domain, DC, OU, GPO, objects).  
- Know the purpose and features of Azure AD Connect for hybrid identity scenarios.  
- Remember the two user types in Azure AD: member and guest.  
- Groups are critical for scalable access management; know how assignments and self-service group joins work.  
- Be able to list and explain the four methods of assigning resource access rights.  
- Recognize that tenants are isolated Azure AD instances per organization.  
- Understand that ADDS provides managed domain services in Azure when migrating on-prem AD.

---

## AD Device Management

---

### Intro to Device Management

**Timestamp**: 00:57:31 – 01:00:14

**Key Concepts**  
- Device management in Azure AD involves managing physical devices (phones, tablets, laptops, desktops) that access company resources.  
- Device management helps protect organizational assets, especially in distributed or remote work environments and BYOD scenarios.  
- There are three primary ways to get devices into Azure AD:  
  1. Azure AD Registered  
  2. Azure AD Joined  
  3. Hybrid Azure AD Joined  

**Definitions**  
- **Device Management**: The administration of physical devices granted access to company resources such as printers and cloud services, often controlled via device-based conditional access.  
- **Azure AD Registered Device**: A device personally owned by the user, signed in with a personal Microsoft or local account, typically used for BYOD or mobile devices.  
- **Azure AD Joined Device**: A device owned by the organization, signed in with an Azure AD organizational account, cloud-native, typically Windows 10 or Windows Server 2019 VMs.  
- **Hybrid Azure AD Joined Device**: A device owned by the organization, signed in with an Azure AD Domain Services account, existing both on-premises and in the cloud, supporting older OS versions like Windows 7, 8.1, 10, and Windows Server 2008 or newer.  

**Key Facts**  
- Azure AD Registered devices are primarily personal devices (BYOD) and support Windows 10, iOS, Android, and Mac OS.  
- Azure AD Joined devices are cloud-native and owned by the organization.  
- Hybrid Azure AD Joined devices support both cloud and on-premises environments and older Windows OS versions.  
- Device management is critical for securing organizational resources when employees work remotely or use personal devices.  

**Examples**  
- Devices listed in Azure AD device management can include desktops, laptops, phones, tablets.  
- BYOD scenario: personal mobile devices registered as Azure AD Registered.  
- Organizational laptops running Windows 10 or Windows Server 2019 VMs as Azure AD Joined.  
- On-premises Windows 7 or Windows Server 2008 devices as Hybrid Azure AD Joined.  

**Key Takeaways 🎯**  
- Remember the ownership and sign-in account distinctions:  
  - Azure AD Registered = personal device + personal account  
  - Azure AD Joined = organization-owned + cloud-only account  
  - Hybrid Azure AD Joined = organization-owned + cloud/on-prem account  
- For exam questions about on-premises device management, Hybrid Azure AD Joined is the correct choice.  
- Understand the supported OS types for each join type to select the correct device management approach.  
- Device management is essential for securing resources in distributed and BYOD environments.

---

### AD Registered Devices

**Timestamp**: 01:00:14 – 01:01:57

**Key Concepts**  
- AD Registered Devices represent one of the three ways to get devices into Azure Active Directory.  
- These devices are registered to Azure AD without requiring organizational accounts to sign into the device, meaning they typically use personal accounts.  
- Commonly used in Bring Your Own Device (BYOD) scenarios or mobile devices.  
- Device ownership can be either user-owned or organization-owned, but primarily personal.  
- Supported operating systems include Windows 10, iOS, Android, and Mac OS.  
- Provisioning methods vary by OS: Windows 10 settings, iOS/Android company portal with Microsoft Authenticator app, Mac OS company portal.  
- Device sign-in options include end user local credentials such as password, Windows Hello, and PIN.  
- Device management is done through Mobile Device Management (MDM) like Microsoft Intune and Mobile Application Management (MAM).  
- Key capabilities include Single Sign-On (SSO) to cloud resources, conditional access when enrolled in Intune, app protection policies, and enabling phone sign-in via Microsoft Authenticator app.

**Definitions**  
- **AD Registered Device**: A device registered to Azure AD that does not require an organizational account to sign in, typically using personal accounts.  
- **Windows Hello**: An alternative Windows 10 sign-in method using biometrics such as fingerprint, iris scan, or facial recognition.  
- **Mobile Device Management (MDM)**: A management system (e.g., Microsoft Intune) used to control and secure devices.  
- **Mobile Application Management (MAM)**: Similar to MDM but focuses on managing and protecting apps on devices.

**Key Facts**  
- AD Registered Devices are primarily for personal or BYOD scenarios.  
- Supported OS: Windows 10, iOS, Android, Mac OS.  
- Sign-in options include password, PIN, Windows Hello (biometrics).  
- Management tools include Microsoft Intune for both MDM and MAM.  
- Enables SSO, conditional access, app protection policies, and phone sign-in with Microsoft Authenticator.

**Examples**  
- BYOD or mobile devices using personal accounts registering to Azure AD.  
- Using Windows Hello biometric sign-in on Windows 10 devices.  
- Provisioning iOS or Android devices via company portal and Microsoft Authenticator app.

**Key Takeaways 🎯**  
- Remember AD Registered Devices are primarily for personal accounts and BYOD scenarios.  
- Know the supported operating systems and provisioning methods for these devices.  
- Understand the difference between device sign-in options, especially Windows Hello as a biometric alternative.  
- Be familiar with management capabilities via MDM (Intune) and MAM.  
- Key exam focus: AD Registered Devices enable SSO, conditional access, app protection policies, and phone sign-in with Microsoft Authenticator.  
- Windows Hello may appear on the exam—know it provides biometric sign-in options like fingerprint, iris, or facial recognition.

---

### Windows Hello

**Timestamp**: 01:01:57 – 01:02:31

**Key Concepts**  
- Windows Hello provides alternative authentication methods for Windows 10 users.  
- It enables biometric sign-in options such as fingerprint, iris scan, and facial recognition.  

**Definitions**  
- **Windows Hello**: A Windows 10 feature that allows users to log into their devices and applications using biometric authentication methods instead of traditional passwords.  

**Key Facts**  
- Supports fingerprint, iris scan, and facial recognition as login methods.  
- Designed to offer a more secure and convenient sign-in experience.  

**Examples**  
- Iris scanner mentioned as a biometric option (noted as a cool but potentially costly feature).  

**Key Takeaways 🎯**  
- Remember Windows Hello as an alternative sign-in method using biometrics.  
- Be familiar with the types of biometric authentication Windows Hello supports (fingerprint, iris, face).  
- Expect questions about Windows Hello on exams, especially regarding its purpose and authentication methods.  

---

### MDM and MAM

**Timestamp**: 01:02:31 – 01:04:16

**Key Concepts**  
- Mobile Device Management (MDM) controls the entire device, allowing actions like wiping data and resetting to factory settings.  
- Mobile Application Management (MAM) controls apps individually by publishing, pushing, configuring, securing, monitoring, and updating mobile apps.  
- MDM and MAM are managed under Azure Active Directory (Azure AD) in the "mobility" section.  
- Microsoft Intune is the primary service used to implement MDM and MAM.  
- Microsoft Intune requires Azure AD Premium P2 license.  
- Microsoft Intune is part of Microsoft Endpoint Manager, which itself is part of Microsoft Enterprise Mobility + Security (EMS).  
- EMS is an umbrella platform that includes Azure AD, Microsoft Endpoint Configuration Manager, Microsoft Intune, and other services.  

**Definitions**  
- **Mobile Device Management (MDM)**: A management approach that controls entire devices, enabling actions such as wiping data and factory resetting devices.  
- **Mobile Application Management (MAM)**: A management approach focused on controlling and securing individual mobile applications, including publishing, configuring, and updating apps.  
- **Microsoft Intune**: A cloud-based service used to apply MDM and MAM policies, part of Microsoft Endpoint Manager and EMS.  
- **Enterprise Mobility + Security (EMS)**: Microsoft's intelligent mobility management and security platform that protects organizations and enables flexible work.  

**Key Facts**  
- To use Microsoft Intune, an upgrade to Azure AD Premium P2 is required.  
- Microsoft Intune and Endpoint Manager are often referenced interchangeably or together in the context of device and app management.  
- EMS includes multiple services, but the two most important to remember for MDM/MAM are Microsoft Intune and Azure Active Directory.  
- The naming and bundling of these services can be confusing due to marketing and business reasons.  

**Examples**  
- None mentioned explicitly, but the concept of wiping company devices or managing apps remotely was implied as practical use cases.  

**Key Takeaways 🎯**  
- Remember the distinction: MDM controls the whole device; MAM controls apps individually.  
- Microsoft Intune is the go-to service for implementing both MDM and MAM.  
- Intune requires Azure AD Premium P2 license—know this for exam scenarios involving licensing.  
- EMS is the overarching platform that includes Intune and Azure AD—understand this hierarchy.  
- Don’t get confused by the overlapping names: Microsoft Intune, Endpoint Manager, and EMS are closely related and often discussed together in device/app management contexts.  
- Focus on Intune and Azure AD as the core services for MDM and MAM in Microsoft environments.

---

### EMS

**Timestamp**: 01:04:16 – 01:05:10

**Key Concepts**  
- EMS stands for Enterprise Mobility + Security.  
- EMS is an intelligent mobility management and security platform.  
- EMS protects and secures organizations while enabling flexible work for employees.  
- EMS is an umbrella for multiple Microsoft and Azure services.  
- Key components to remember within EMS are Microsoft Intune and Azure Active Directory (Azure AD).  
- Microsoft Intune is part of Microsoft Endpoint Manager, which itself is part of EMS.  
- EMS relates closely to Mobile Device Management (MDM) and Mobile Application Management (MAM).

**Definitions**  
- **EMS (Enterprise Mobility + Security)**: A Microsoft platform that provides intelligent mobility management and security to protect organizations and empower flexible employee work styles.  
- **Microsoft Intune**: A cloud-based service within EMS used for device and application management (MDM and MAM).  
- **Azure Active Directory (Azure AD)**: A cloud-based identity and access management service, also part of EMS.

**Key Facts**  
- To use Microsoft Intune, an upgrade to Azure AD Premium 2 is required.  
- EMS includes Azure Active Directory, Microsoft Endpoint Configuration Manager, Microsoft Intune, and other services.  
- Microsoft Intune and Azure AD are the two most important EMS components to focus on for exams.  
- EMS components and naming can be confusing due to marketing and business reasons, but they generally revolve around device and identity management.

**Examples**  
- None specifically mentioned in this section.

**Key Takeaways 🎯**  
- Remember EMS as the overarching Microsoft platform for enterprise mobility and security.  
- Focus on Microsoft Intune and Azure Active Directory as the core EMS services relevant for exams.  
- Understand that Intune is part of Microsoft Endpoint Manager, which is under EMS.  
- Be aware that EMS deals with MDM and MAM concepts.  
- Don’t get confused by the overlapping names and marketing terms—EMS bundles these related services.

---

### MS Authenticator App

**Timestamp**: 01:05:10 – 01:05:50

**Key Concepts**  
- Microsoft Authenticator is an app used for secure sign-ins across multiple accounts.  
- Supports multi-factor authentication (MFA).  
- Enables passwordless sign-in or auto-fills passwords.  
- Available on Google Play Store and Apple App Store.  
- Useful for managing registered devices and enhancing security.

**Definitions**  
- **Microsoft Authenticator**: An application that facilitates secure sign-ins using multi-factor authentication, allowing passwordless login or password autofill for registered devices.

**Key Facts**  
- The app supports passwordless authentication, reducing reliance on passwords.  
- It is compatible with both Android and iOS devices.  
- Recommended to install for hands-on experience with its capabilities.

**Examples**  
- None specifically mentioned beyond general use for registered devices and accounts.

**Key Takeaways 🎯**  
- Understand Microsoft Authenticator as a key tool for MFA and passwordless sign-in.  
- Remember it is widely available and supports multiple account types.  
- Installing and using the app is recommended to gain practical familiarity.  
- It plays a role in device management and secure authentication in Azure environments.

---

### AD Joined Devices

**Timestamp**: 01:05:50 – 01:07:35

**Key Concepts**  
- AD Joined Devices are joined only to Azure Active Directory (Azure AD).  
- Require organizational (work or school) accounts to sign into the device, not personal accounts.  
- Suitable for both cloud-only and hybrid organizations (hybrid meaning on-premises + cloud).  
- Device ownership is organizational (company-owned devices).  
- Supported operating systems include Windows 10 Pro (not Windows 10 Home) and Windows Server 2019 (virtual machines in Azure). Server Core is not supported.  
- Provisioning methods include self-service via Windows Out-Of-Box Experience (OOBE), bulk enrollment, and Windows Autopilot.  
- Device sign-in options include organizational accounts with passwords, Windows Hello for Business, and FIDO 2.0 security keys.  
- Device management can be done via Mobile Device Management (MDM), co-management with Microsoft Intune and Microsoft Endpoint Configuration Manager.  
- Key capabilities include Single Sign-On (SSO) to cloud and on-premises resources, conditional access based on MDM enrollment and compliance, self-service password reset, Windows Hello PIN reset on lock screen, and enterprise state roaming across devices.

**Definitions**  
- **AD Joined Device**: A device joined exclusively to Azure AD that requires an organizational account for sign-in.  
- **Windows Autopilot**: A provisioning method for setting up devices (mentioned as upcoming topic).  
- **FIDO 2.0 Security Keys**: Authentication keys based on Fast Identity Online Alliance standards for passwordless or multi-factor authentication.

**Key Facts**  
- Windows 10 Home edition is not supported for AD join; only Windows 10 Pro and above.  
- Windows Server 2019 VMs in Azure are supported; Server Core is not.  
- Sign-in options include passwords, Windows Hello for Business, and FIDO 2.0 security keys.  
- Device management supports MDM and co-management with Intune and Endpoint Configuration Manager.  
- Supports SSO to both cloud and on-premises resources.  
- Conditional access policies rely on MDM enrollment and compliance status.  
- Self-service password reset and Windows Hello PIN reset are available directly on the lock screen.  
- Enterprise state roaming allows user settings and data to roam across devices.

**Examples**  
- None specifically mentioned beyond supported OS and provisioning methods.

**Key Takeaways 🎯**  
- Remember AD Joined devices require organizational accounts and are primarily for company-owned devices.  
- Know the supported OS versions: Windows 10 Pro (not Home) and Windows Server 2019 (no Server Core).  
- Understand provisioning options: Windows OOBE, bulk enrollment, and Autopilot.  
- Be familiar with sign-in options including FIDO 2.0 security keys as a modern authentication method.  
- Device management integrates with MDM and co-management tools like Intune and Endpoint Configuration Manager.  
- Key features such as SSO, conditional access, self-service password reset, and enterprise state roaming are important capabilities to know for exams.

---

### FIDO2 and Security Keys

**Timestamp**: 01:07:35 – 01:09:41

**Key Concepts**  
- FIDO Alliance develops open authentication standards to reduce reliance on passwords.  
- FIDO2 is a combination of protocols and standards enabling stronger, simpler user authentication.  
- Security keys act as a secondary authentication device (second factor) for accessing devices, workstations, or applications.  
- FIDO2 includes specifications such as U2F (Universal 2nd Factor), UAF (Universal Authentication Framework), CTAP (Client to Authenticator Protocol), and WebAuthN.  

**Definitions**  
- **FIDO Alliance**: An open industry association focused on creating authentication standards to reduce password dependency.  
- **FIDO2**: The collective term for FIDO specifications including CTAP and WebAuthN that enable passwordless or second-factor authentication.  
- **Security Key**: A physical secondary device used in multi-factor authentication that generates security tokens when activated (e.g., by touch).  
- **U2F (Universal 2nd Factor)**: A FIDO protocol for second-factor authentication.  
- **UAF (Universal Authentication Framework)**: A FIDO protocol for passwordless authentication.  
- **CTAP (Client to Authenticator Protocol)**: A protocol that works with WebAuthN to enable communication between client devices and authenticators.  
- **WebAuthN**: A web standard for secure authentication, complementary to CTAP.  

**Key Facts**  
- Security keys often look like USB sticks and generate autofill security tokens upon user interaction (e.g., finger touch).  
- A popular brand of security key is the **UbiKey**.  
- UbiKey supports multiple protocols: FIDO2, WebAuthN, U2F.  
- UbiKey features include waterproof and crush resistance, and dual connectors (USB-A and NFC) on a single device.  
- UbiKey works out-of-the-box with services like Gmail and Facebook, plus hundreds more.  
- Cost of a UbiKey is approximately $30 USD, making it an affordable security enhancement.  

**Examples**  
- The instructor personally uses a UbiKey for authenticating to multiple devices.  
- UbiKey compatibility includes Gmail, Facebook, and many other online services.  

**Key Takeaways 🎯**  
- Understand that FIDO2 is a set of open standards aimed at improving authentication security beyond passwords.  
- Know the main protocols involved: U2F, UAF, CTAP, and WebAuthN, and that together they form FIDO2.  
- Recognize what a security key is and how it functions as a second factor in authentication.  
- Remember UbiKey as a practical, widely supported example of a security key device.  
- Be aware of the affordability and ease of use of security keys, making them a recommended security tool.  
- For exam scenarios, expect questions on the purpose of FIDO2, the role of security keys, and the protocols involved.

---

### Hybrid AD Joined Devices

**Timestamp**: 01:09:41 – 01:11:24

**Key Concepts**  
- Hybrid Azure AD Join allows devices to be joined to both on-premises Active Directory (AD) and Azure AD.  
- Requires organizational account sign-in, emphasizing on-premises infrastructure integration.  
- Suitable for hybrid organizations with existing on-premises AD environments.  
- Devices are company-owned and managed.  
- Supports a range of Windows OS versions for joining and provisioning.  
- Device management can be done via Group Policies, Configuration Manager, Intune (standalone or co-management).  
- Provides Single Sign-On (SSO) to both cloud and on-premises resources.  
- Supports conditional access policies through domain join or Intune if co-managed.  
- Enables self-service password reset and Windows Hello PIN reset from the lock screen.  
- Supports enterprise state roaming across devices.

**Definitions**  
- **Hybrid Azure AD Join**: A device join type that connects devices to both on-premises Active Directory and Azure Active Directory, allowing organizational account sign-in and management in hybrid environments.  

**Key Facts**  
- Supported OS for joining: Windows 10, 8.1, Windows 7, Windows Server 2008 R2, 2012, and others.  
- Supported OS for provisioning: Windows 10, Windows Server 2016, 2019.  
- Domain join can be automated via Azure AD Connect or configured with ADFS.  
- Windows Autopilot can be used for domain join (covered in next section).  
- Device sign-in options include password and Windows Hello for Business.  

**Examples**  
- None specifically mentioned for Hybrid AD Join devices in this segment.

**Key Takeaways 🎯**  
- Hybrid Azure AD Join is ideal for organizations with existing on-premises AD infrastructure wanting to leverage Azure AD capabilities.  
- Understand the supported OS versions for joining and provisioning devices.  
- Remember that device management can be done via traditional Group Policies or modern tools like Intune, including co-management scenarios.  
- Key benefits include SSO to cloud and on-premises resources, conditional access, and self-service password and PIN resets.  
- Knowing the difference between join types (Hybrid AD Join vs others) is important for exam scenarios.

---

### Windows Autopilot

**Timestamp**: 01:11:24 – 01:12:19

**Key Concepts**  
- Windows Autopilot is a collection of technologies used to set up and pre-configure new Windows devices.  
- It prepares devices for productive use without needing custom images or drivers for each model.  
- Uses an OEM-optimized version of Windows 10 pre-installed on devices.  
- Instead of re-imaging, existing Windows 10 installations are transformed into a business-ready state.  
- Post-deployment management can be done via Microsoft Intune, Windows Update for Business, Microsoft Endpoint Configuration Manager, and similar tools.

**Definitions**  
- **Windows Autopilot**: A set of technologies designed to simplify the initial deployment and configuration of new Windows devices, enabling them to be business-ready without traditional imaging processes.

**Key Facts**  
- Windows Autopilot leverages an OEM-optimized Windows 10 version pre-installed on devices.  
- No need to maintain custom images or drivers for every device model.  
- Enables transformation of existing Windows 10 installations into a managed, business-ready state.  
- Compatible with management tools like Microsoft Intune and Endpoint Configuration Manager.

**Examples**  
- None mentioned explicitly in this segment.

**Key Takeaways 🎯**  
- Remember that Windows Autopilot streamlines device provisioning by using pre-installed OEM Windows 10, avoiding the need for custom imaging.  
- Focus on the fact that it transforms existing Windows installations rather than wiping and re-imaging devices.  
- Understand that Autopilot integrates with Microsoft Intune and other management tools for ongoing device management.  
- This technology is primarily used during the initial deployment of new Windows devices.

---

### Device Management Cheatsheet

**Timestamp**: 01:12:19 – 01:13:38

**Key Concepts**  
- Device Management enables organizations to manage laptops, desktops, and phones accessing cloud resources.  
- Device Management is accessed via Azure Active Directory (Azure AD).  
- There are three device join types to bring devices into management: Azure Registered, Azure AD Join, and Hybrid Azure AD Join.  
- Mobile Device Management (MDM) controls the entire device, including wiping data and factory resetting.  
- Mobile Application Management (MAM) manages apps at the data layer by publishing, pushing, configuring, securing, monitoring, and updating apps.

**Definitions**  
- **Azure Registered**: Devices personally owned by users (e.g., mobile devices, Windows 10, iOS) signed in with a local personal account.  
- **Azure AD Join**: Devices owned by the organization, signed in with an organizational account; primarily for cloud-native access but can support hybrid scenarios.  
- **Hybrid Azure AD Join**: Devices owned by the organization managed using Active Directory Domain Services (AD DS) in a hybrid environment.  
- **Mobile Device Management (MDM)**: Management approach that controls the entire device, including wiping and resetting it.  
- **Mobile Application Management (MAM)**: Management focused on mobile apps, handling app deployment, configuration, security, monitoring, and updates without controlling the entire device.

**Key Facts**  
- Device Management is found under Azure AD service.  
- MDM allows wiping and factory resetting devices.  
- MAM operates at the data/app layer, not the entire device.  

**Examples**  
- Azure Registered devices include personally owned devices like Windows 10 laptops or iOS phones signed in with personal accounts.  
- Azure AD Join devices are organizationally owned and signed in with corporate accounts.  
- Hybrid Azure AD Join devices use AD DS for management in hybrid setups.

**Key Takeaways 🎯**  
- Understand the three device join types and their ownership/sign-in distinctions.  
- Know the difference between MDM (full device control) and MAM (app-level control).  
- Remember Device Management is integrated with Azure AD for managing cloud resource access.  
- Be able to identify which join type applies based on device ownership and management infrastructure.

---

### Roles

### Roles

### Type of Roles

**Timestamp**: 01:13:38 – 01:14:32

**Key Concepts**  
- Azure has three types of roles for access and management.  
- Classic subscription administrator roles are the original Azure role system but are largely legacy.  
- Azure Roles are part of Role-Based Access Control (RBAC), built on Azure Resource Manager.  
- Azure Active Directory (Azure AD) Roles manage Azure AD resources within a directory.  
- IAM (Identity Access Management) in Azure is the system to create and assign roles to users.  
- Azure RBAC roles restrict access to resource actions (operations).  

**Definitions**  
- **Classic Subscription Administrator Roles**: The original Azure role system used to manage subscriptions; mostly legacy now.  
- **Azure Roles (RBAC)**: Authorization system built on Azure Resource Manager that controls access to Azure resources by assigning roles.  
- **Azure Active Directory (Azure AD) Roles**: Roles used to manage Azure AD resources within a directory.  
- **IAM (Identity Access Management)**: The system that allows creation and assignment of roles to users to control access.  

**Key Facts**  
- Azure has three distinct role types: Classic subscription administrator roles, Azure RBAC roles, and Azure AD roles.  
- RBAC roles are tied to Azure Resource Manager and control access to resource operations.  

**Examples**  
- None mentioned explicitly in this segment.  

**Key Takeaways 🎯**  
- Understand the difference between the three Azure role types and their purposes.  
- Know that Classic roles are legacy but still exist.  
- Azure RBAC is the primary authorization system for managing access to Azure resources.  
- Azure AD roles specifically manage directory-related resources.  
- IAM is the overarching system for assigning these roles to users.

---

### IAM Access Controls

**Timestamp**: 01:14:32 – 01:16:04

**Key Concepts**  
- IAM (Identity Access Management) in Azure is used to create and assign roles to users for access control.  
- Azure Roles are part of Role-Based Access Control (RBAC), which restricts access to resource operations.  
- There are two types of Azure RBAC roles: built-in roles and custom roles.  
- Role assignment applies roles to users, groups, or service principals.  
- Deny assignments explicitly block users from performing specific actions, even if a role grants access.  
- Classic administrators represent the original Azure role system, now largely replaced by RBAC.

**Definitions**  
- **IAM (Identity Access Management)**: A system that allows creation and assignment of roles to users to control access.  
- **Azure Roles**: Roles used in Azure RBAC to restrict access to resource actions.  
- **Built-in Roles**: Predefined, read-only roles managed by Microsoft (e.g., Owner, Contributor, Reader).  
- **Custom Roles**: User-created roles with custom permissions.  
- **Role Assignment**: The process of assigning a role to a user, group, or service principal.  
- **Deny Assignment**: A mechanism to block specific actions regardless of role assignments; can only be applied via Azure Blueprints.  
- **Classic Administrators**: The original Azure role system with three roles: Account Administrator, Service Administrator, and Co-Administrator.

**Key Facts**  
- Built-in roles are managed by Microsoft and are read-only.  
- Common built-in roles include Owner, Contributor, and Reader.  
- Deny assignments can only be applied through Azure Blueprints.  
- Account Administrator: Billing owner of the subscription, no Azure portal access.  
- Service Administrator: Has full access to the Azure portal, equivalent to Owner role at subscription scope.  

**Examples**  
- Role assignments can be applied to service principals, user groups, or individual users.  
- Deny assignments act as guardrails to prevent certain actions regardless of other permissions.  
- Classic Administrator roles:  
  - Account Administrator (billing only, no portal access)  
  - Service Administrator (full portal access, owner-level permissions)  

**Key Takeaways 🎯**  
- Always prefer using RBAC over Classic Administrator roles for access control.  
- Understand the difference between built-in and custom roles in RBAC.  
- Remember that deny assignments override role assignments and are only set via Azure Blueprints.  
- Know the three classic administrator roles and their access scopes, especially the distinction between Account and Service Administrator.  
- Role assignments can be applied to users, groups, or service principals—know these entities for exam scenarios.

---

### Classic Administrator

**Timestamp**: 01:16:04 – 01:17:14

**Key Concepts**  
- Classic Administrator is the original Azure role system, predating Azure RBAC.  
- It is accessed via the "Classic Administrator" tab under Access Control in the Azure portal.  
- There are three types of classic administrator roles: Account Administrator, Service Administrator, and Co-Administrator.  
- Classic Administrator roles differ in scope and portal access compared to RBAC roles.  
- Although largely replaced by RBAC, a classic administrator role is still created automatically when an Azure account is set up.

**Definitions**  
- **Account Administrator**: The billing owner of the subscription; does **not** have access to the Azure portal.  
- **Service Administrator**: Has the same access as a user assigned the Owner role at the subscription scope; has full access to the Azure portal.  
- **Co-Administrator**: Has the same access as a user assigned the Owner role at the subscription scope; can manage services but is distinct from the Service Administrator.

**Key Facts**  
- Classic Administrator roles are simpler and more limited compared to RBAC roles.  
- When an Azure account is created, it automatically assigns one classic administrator role (typically the Account Administrator).  
- The Service Administrator and Co-Administrator roles have Owner-level access at the subscription scope.  
- The Account Administrator role is primarily for billing and does not grant portal access.

**Examples**  
- The instructor mentions that when their Azure account was set up by a colleague ("Baker"), one classic administrator role was automatically assigned.  
- No other specific examples mentioned.

**Key Takeaways 🎯**  
- Prefer using Azure RBAC over Classic Administrator roles for managing access.  
- Understand the distinctions between the three classic administrator roles, especially regarding portal access and billing.  
- Remember that classic administrator roles are still created by default with new Azure subscriptions but are mostly legacy.  
- Know that Service Administrator and Co-Administrator roles have Owner-level permissions at the subscription scope.  
- Classic Administrator roles are managed under the "Classic Administrator" tab in Access Control.  

---

### RBAC

**Timestamp**: 01:17:14 – 01:20:06

**Key Concepts**  
- Role-Based Access Control (RBAC) manages who has access to Azure resources, what actions they can perform, and the scope of their access.  
- A role assignment consists of three elements: security principal, role definition, and scope.  
- Azure has fundamental built-in roles and many additional built-in roles (over 70).  
- Azure AD roles are distinct from Azure RBAC roles and manage Azure Active Directory resources.

**Definitions**  
- **Security Principal**: The identity requesting access to an Azure resource. This can be:  
  - A user in Azure Active Directory (AAD)  
  - A group in AAD  
  - A service principal (security identity used by applications or services)  
  - A managed identity (AAD identity automatically managed by Azure)  
- **Scope**: The set of resources the role assignment applies to. Scope levels include management groups, subscriptions, resource groups, or individual resources.  
- **Role Definition**: A collection of permissions that specify allowed operations such as read, write, delete. Roles can be broad (e.g., Owner) or specific (e.g., Virtual Machine Reader).  
- **Azure AD Roles**: Roles used to manage Azure Active Directory resources like users, licenses, domains, and administrative privileges.

**Key Facts**  
- Four fundamental Azure RBAC built-in roles to know:  
  1. **Owner** – Full access including managing access permissions.  
  2. **Contributor** – Can read and create/update/delete resources but cannot grant access to others.  
  3. **Reader** – Read-only access to resources.  
  4. **User Access Administrator** – Can grant access permissions to others but cannot create or modify resources.  
- Azure RBAC includes over 70 built-in roles beyond the fundamental four.  
- Azure AD roles include predefined roles such as Application Administrator and Application Developer.

**Examples**  
- None explicitly detailed, but the explanation of roles implies practical usage such as:  
  - Owner role assigned at subscription scope has full control.  
  - Contributor can manage resources but not assign roles.  
  - User Access Administrator manages access permissions without modifying resources.

**Key Takeaways 🎯**  
- Understand the three elements of role assignment: security principal, role definition, and scope.  
- Memorize the four fundamental Azure RBAC roles and their permission levels.  
- Know the difference between Azure RBAC roles (resource management) and Azure AD roles (directory management).  
- Remember scope hierarchy: management groups > subscriptions > resource groups > resources.  
- Recognize that service principals and managed identities are types of security principals used for applications and services.  
- Azure AD roles are essential for managing directory-level tasks like user creation and license management.

---

### AD Roles

**Timestamp**: 01:20:06 – 01:21:30

**Key Concepts**  
- Azure AD roles are used to manage Azure Active Directory resources.  
- These roles control actions like creating/editing users, assigning admin roles, resetting passwords, managing licenses, and domains.  
- Azure AD has many predefined built-in roles accessible under "Roles and Administrators" in the Azure portal.  
- Important built-in roles include Global Administrator, User Administrator, and Billing Administrator.  
- Custom Azure AD roles can be created but require an Azure AD Premium (P1 or P2) subscription.  
- Role definitions can be inspected to understand their permissions rather than relying solely on role names.  
- Azure role documents have different syntaxes depending on whether PowerShell or CLI is used.

**Definitions**  
- **Azure AD Roles**: Roles specifically designed to manage Azure Active Directory resources and administrative tasks within the directory.  
- **Global Administrator**: A built-in role with full access to all Azure AD features and settings.  
- **User Administrator**: A built-in role with full access to create and manage users.  
- **Billing Administrator**: A built-in role responsible for managing purchases, subscriptions, and support tickets.  
- **Custom Roles**: User-defined roles that can be created to tailor permissions but require Azure AD Premium licensing.

**Key Facts**  
- Custom Azure AD roles require Azure AD Premium P1 or P2 licenses (paid feature).  
- Azure AD Premium tiers (P1 and P2) provide enhanced control and features for role management.  
- Azure role definitions can be viewed and analyzed using PowerShell or CLI, with slight syntax differences.  
- Azure AD roles are distinct from Azure built-in roles like Owner, Contributor, Reader, and User Access Administrator.

**Examples**  
- Built-in roles mentioned: Global Administrator, User Administrator, Billing Administrator.  
- Role management location: Azure Portal > Azure Active Directory > Roles and Administrators.  
- PowerShell example syntax for role inspection mentioned (no detailed script provided).

**Key Takeaways 🎯**  
- Know the purpose of Azure AD roles: managing directory resources and administrative tasks.  
- Remember key built-in Azure AD roles and their primary responsibilities.  
- Understand that creating custom roles requires Azure AD Premium licensing (P1 or P2).  
- Always review role permissions in detail rather than assuming based on role names alone.  
- Be aware of the difference in syntax when managing roles via PowerShell vs CLI.  
- This knowledge is important for exam questions on Azure AD role management and licensing requirements.  

---

### Roles

**Timestamp**: 01:21:30 – 01:24:21

**Key Concepts**  
- Azure roles define permissions to control access to Azure resources.  
- Custom roles require Azure Active Directory Premium (P1 or P2).  
- Roles have specific properties that define their behavior and scope.  
- Wildcards (*) can be used in role definitions to represent all actions within a category.  
- Roles differ from Azure policies, which enforce compliance rather than access control.

**Definitions**  
- **Azure Role**: A set of permissions that define what actions a user or service principal can perform on Azure resources.  
- **Custom Role**: A user-defined role with specific permissions, requiring Azure AD Premium P1 or P2.  
- **Assignable Scopes**: The specific Azure management groups or subscriptions where a custom role can be assigned.  
- **Actions**: Permissions explicitly allowed by the role.  
- **Not Actions**: Permissions explicitly denied by the role, acting as guardrails.  
- **Data Actions**: Permissions related to data operations within a resource.  
- **Not Data Actions**: Data operations explicitly denied by the role.  
- **Wildcard (*)**: A symbol used in role definitions to indicate all possible actions or data actions within a category.

**Key Facts**  
- Creating custom roles requires Azure Active Directory Premium P1 or P2 license.  
- Role properties include: Name, ID (auto-generated), IsCustom (boolean), Description, Actions, NotActions, DataActions, NotDataActions, and AssignableScopes.  
- AssignableScopes for custom roles can only include one management group.  
- Role definitions can be represented in JSON or PowerShell syntax, with slight differences in property names.  
- Wildcards (*) can be used in Actions, NotActions, DataActions, and NotDataActions to match all permissions in that category.

**Examples**  
- The transcript references a JSON example of a role definition (not fully shown) and notes that PowerShell uses slightly different property names (e.g., "Name" vs. "RoleName").  
- Example of wildcard usage: Using "*" in actions to represent all operations like read, write, delete, run, etc., within a category such as cost management.

**Key Takeaways 🎯**  
- Always review built-in managed roles to understand what permissions they grant instead of relying solely on the role name.  
- Custom roles require Azure AD Premium P1 or P2, so plan licensing accordingly.  
- Understand the difference between Actions and NotActions to effectively design roles with appropriate permissions and restrictions.  
- Use wildcards carefully to avoid overly broad permissions.  
- Remember that Azure roles control access (who can do what), whereas Azure policies enforce compliance (what state resources must be in).  
- Be familiar with the syntax differences between JSON and PowerShell role definitions for exam scenarios.

---

### Policies vs RBAC

**Timestamp**: 01:24:21 – 01:25:35

**Key Concepts**  
- Azure Policies ensure compliance of resources by evaluating resource states against business rules.  
- Azure Roles (RBAC) control access to Azure resources by managing user actions and applying restrictions.  
- Policies evaluate resource properties and do not restrict actions directly.  
- RBAC focuses on restricting what actions users can perform at various scopes.  
- Even if a user has permission to perform an action, Azure Policy can block the action if it results in a non-compliant resource.

**Definitions**  
- **Azure Policies**: Tools used to enforce compliance by evaluating resource states and ensuring they meet organizational standards, regardless of who performs the action.  
- **Azure Roles (RBAC)**: Role-based access control mechanisms that manage and restrict user permissions to perform actions on Azure resources.

**Key Facts**  
- Azure Policies examine properties of resources represented in Azure Resource Manager and some resource providers.  
- Policies do not restrict operations (actions) but enforce compliance by blocking non-compliant resource creation or updates.  
- RBAC restricts user actions at different scopes within Azure resources.  
- Azure Policies and RBAC serve complementary but distinct purposes: compliance vs access control.

**Examples**  
- None mentioned explicitly in this section.

**Key Takeaways 🎯**  
- Remember that Azure Policies focus on *what* state a resource should be in (compliance), not *who* can do what.  
- RBAC controls *who* can perform *which* actions on Azure resources.  
- Even with RBAC permissions, Azure Policy can block changes if they violate compliance rules.  
- Policies and RBAC work together to ensure secure and compliant resource management in Azure.

---

### AD Roles vs RBAC

**Timestamp**: 01:25:35 – 01:26:50

**Key Concepts**  
- Azure AD roles control access to Azure Active Directory resources.  
- Azure roles (RBAC) control access to Azure resources.  
- AD roles and Azure roles operate independently by default and do not span across each other’s domains.  
- Global Administrator in Azure AD does not have access to Azure resources by default.  
- Access to Azure resources for AD Global Administrators requires explicit assignment of an Azure role (e.g., User Access Administrator).  

**Definitions**  
- **Azure AD Roles**: Roles that manage permissions related to Azure Active Directory resources such as users, groups, billing, licensing, and application registrations.  
- **Azure Roles (RBAC)**: Role-Based Access Control roles that manage permissions on Azure resources like virtual machines, databases, storage, and networking.  

**Key Facts**  
- Azure AD roles focus on identity and directory-related resources.  
- Azure RBAC roles focus on managing access to Azure infrastructure and services.  
- The Global Administrator role in Azure AD does not inherently grant access to Azure resources.  
- To manage Azure resources, Global Administrators must be assigned an Azure RBAC role explicitly.  

**Examples**  
- AD resources: users, groups, billing, licensing, application registration.  
- Azure resources: virtual machines, databases, cloud storage, cloud networking.  

**Key Takeaways 🎯**  
- Understand the clear separation between Azure AD roles and Azure RBAC roles.  
- Remember that Azure AD roles do not grant access to Azure resources by default.  
- Know that Global Administrator access to Azure resources requires an additional Azure RBAC role assignment.  
- Be able to distinguish between managing identity-related resources (Azure AD roles) versus managing cloud infrastructure and services (Azure RBAC).  
- When studying IAM in Azure, differentiate between classic subscription administrator roles, Azure RBAC roles, and Azure AD roles.

---

### Roles CheatSheet

**Timestamp**: 01:26:50 – 01:28:32

**Key Concepts**  
- Azure has three types of roles related to Identity and Access Management (IAM):  
  1. Classic subscription administrator roles  
  2. Azure Roles (Role-Based Access Control - RBAC)  
  3. Azure Active Directory (Azure AD) roles  
- Roles restrict access to resource actions (operations) by assigning permissions.  
- Role assignments consist of three components: security principal, role definition, and scope.  
- There are built-in roles and custom roles:  
  - Built-in roles are Microsoft-managed and often read-only or predefined (e.g., Owner, Contributor, Reader, User Access Administrator).  
  - Custom roles are user-created with custom permissions.  
- Classic administrator roles include Account Administrator, Service Administrator, and Co-administrator.  
- Important Azure AD roles include Global Administrator, User Administrator, and Billing Administrator.  
- Custom Azure AD roles require Azure AD Premium P1 or P2 licenses.  

**Definitions**  
- **Classic subscription administrator roles**: Legacy roles managing Azure subscriptions before RBAC was introduced.  
- **Azure Roles (RBAC)**: Role-Based Access Control roles built on Azure Resource Manager (ARM) to manage access to Azure resources.  
- **Azure AD roles**: Roles that manage permissions within Azure Active Directory, separate from Azure resource access.  
- **Role assignment**: The process of applying a role to a user, consisting of a security principal (user/group/service principal), role definition (permissions), and scope (resource level).  
- **Built-in roles**: Predefined roles provided by Microsoft for common access scenarios.  
- **Custom roles**: Roles created by users to tailor permissions beyond built-in roles.  

**Key Facts**  
- By default, Azure roles and Azure AD roles do NOT span across Azure and Azure AD.  
- The Global Administrator role in Azure AD does NOT have access to Azure resources by default.  
- Global Administrators can gain Azure resource access if assigned the User Access Administrator role in Azure RBAC.  
- Built-in Azure RBAC roles to know: Owner, Contributor, Reader, User Access Administrator.  
- Classic administrator roles to know: Account Administrator, Service Administrator, Co-administrator.  
- Important Azure AD roles to remember: Global Administrator, User Administrator, Billing Administrator.  
- Creating custom Azure AD roles requires Azure AD Premium P1 or P2 licenses.  

**Examples**  
- None specifically mentioned in this section.  

**Key Takeaways 🎯**  
- Understand the difference between classic subscription roles, Azure RBAC roles, and Azure AD roles.  
- Remember that Azure AD roles and Azure resource roles are separate and do not overlap by default.  
- Know the main built-in Azure RBAC roles and classic administrator roles for the exam.  
- Global Administrator in Azure AD does not automatically have Azure resource access—requires explicit role assignment.  
- Custom Azure AD roles require premium licensing (P1 or P2).  
- Be familiar with role assignments as the combination of security principal, role definition, and scope.

---

### Intro

**Timestamp**: 01:28:32 – 01:30:06

**Key Concepts**  
- Azure AD roles and their importance  
- Custom Azure AD roles require P1 or P2 licenses  
- Azure Policies enforce organizational standards and assess compliance at scale  
- Azure Policies observe compliance but do not restrict access  
- Components of Azure Policies: policy definition, policy assignment, policy parameters, initiative definition  
- Policy initiatives are groups of policy definitions to enforce compliance standards (e.g., PCI DSS)  
- Compliance status can be monitored in the Azure Policy portal  

**Definitions**  
- **Azure AD Roles**: Predefined roles such as global administrator, user administrator, billing administrator, etc., that control access and permissions in Azure Active Directory.  
- **Custom Azure AD Roles**: User-defined roles that require Azure AD Premium P1 or P2 licenses to create.  
- **Azure Policy**: A service that enforces organizational standards and assesses compliance by evaluating resources against defined rules.  
- **Policy Definition**: A JSON file that describes business rules to control access or compliance.  
- **Policy Assignment**: The scope (user, resource group, management group) where a policy is applied.  
- **Policy Parameters**: Values passed into policy definitions to make policies flexible.  
- **Initiative Definition**: A collection of policy definitions grouped together to enforce a broader compliance standard.  

**Key Facts**  
- Azure has many built-in policies ready to use for standards like NIST, FedRAMP, HIPAA.  
- Policies check compliance but do not block access or actions.  
- Compliance status can be viewed under the "policies and compliance" section in the Azure portal.  
- Example given: An Azure Virtual Machine launched for disaster recovery was shown as non-compliant in the portal.  

**Examples**  
- Turning on built-in policies for compliance standards such as NIST, FedRAMP, HIPAA.  
- Monitoring compliance status of an Azure Virtual Machine used for disaster recovery.  

**Key Takeaways 🎯**  
- Remember key Azure AD roles for the exam: global administrator, user administrator, billing administrator, and know that more exist.  
- Custom Azure AD roles require P1 or P2 licenses—important for exam scenarios.  
- Azure Policies are for compliance assessment, not access restriction—do not confuse with access control.  
- Understand the components of Azure Policies: definitions, assignments, parameters, and initiatives.  
- Know that initiatives group multiple policies to enforce complex compliance requirements.  
- Be familiar with how to check compliance status in the Azure portal—this practical knowledge can help in exam questions.  
- Reviewing the structure of a policy definition JSON file is good practice but likely not required for the exam.

---

## Azure Policies

---

### Non Compliant Resources

**Timestamp**: 01:30:06 – 01:30:35

**Key Concepts**  
- Azure Policies are used to enforce organizational standards and compliance.  
- Compliance status can be monitored under the "Policies and Compliance" section in Azure.  
- Resources can be flagged as compliant or non-compliant based on the policies applied.

**Definitions**  
- **Non-Compliant Resource**: A resource that does not meet the requirements defined by the assigned Azure policies.  
- **Azure Policies and Compliance**: A feature in Azure that allows you to view whether resources comply with organizational policies.

**Key Facts**  
- You can check compliance status easily by navigating to the policies and compliance area in Azure.  
- Example given: An Azure Virtual Machine used for disaster recovery was shown to be in a non-compliant state.

**Examples**  
- An Azure Virtual Machine launched for disaster recovery was identified as non-compliant.

**Key Takeaways 🎯**  
- Always verify resource compliance status after applying policies to ensure organizational standards are met.  
- Knowing how to find and interpret compliance status in Azure is important for exam scenarios involving policy enforcement.  
- Understanding the concept of non-compliance helps in troubleshooting and governance within Azure environments.

---

### Policy Definition File

**Timestamp**: 01:30:35 – 01:34:45

**Key Concepts**  
- Anatomy of an Azure Policy Definition file  
- Types of policies: built-in, custom, static  
- Components of a policy definition: display name, type, description, metadata, mode, parameters, policy rules  
- Policy modes: all, index, resource provider  
- Parameters allow flexibility in policies (types, metadata, default values, allowed values)  
- Policy rules structure: if-then logic with conditions and effects  
- Policy effects: deny, audit, append, auditIfNotExists, deployIfNotExists, disabled  

**Definitions**  
- **Built-in Policy**: Maintained by Microsoft.  
- **Custom Policy**: Created by the user.  
- **Static Policy**: Owned by Microsoft for regulatory compliance (e.g., HIPAA, FedRAMP).  
- **Mode**: Determines the scope of resources the policy applies to (e.g., all resources, only those supporting tags, or specific resource providers).  
- **Parameters**: Values passed into policies to make them flexible and reusable.  
- **Policy Rule**: Contains an "if" condition and a "then" effect that defines what happens when the condition is met.  
- **Policy Effects**: Actions taken when a policy condition is met, including:  
  - **Deny**: Blocks resource creation or update if non-compliant.  
  - **Audit**: Logs a warning event without blocking the request.  
  - **Append**: Adds additional fields (e.g., tags) during resource creation or update.  
  - **AuditIfNotExists**: Logs a warning if a related resource does not exist.  
  - **DeployIfNotExists**: Triggers a template deployment if a condition is met.  
  - **Disabled**: Ignores the policy rule, often used for testing.  

**Key Facts**  
- Display name describes the policy purpose and is usually descriptive enough.  
- Metadata is optional and can provide additional info about parameters.  
- Modes:  
  - **All**: Applies to all resource types including resource groups and subscriptions.  
  - **Index**: Applies only to resource types supporting tags and locations.  
  - **Resource Provider**: Limited scope, e.g., Microsoft.ContainerService.data (generally deprecated), Kubernetes data, Key Vault data.  
- Parameters can be of types: string, array, object, boolean, integer, float, etc.  
- Policy rules use logical operators to combine conditions.  
- Effects determine how Azure enforces or audits compliance.  

**Examples**  
- Policy rule example: If resource type is virtual machines, then apply the effect parameter to check health status.  
- Append effect example: Adding tags like cost center or allowed IPs to storage resources during creation or update.  
- DeployIfNotExists example: Running a template deployment to enable SQL encryption on a database after creation.  

**Key Takeaways 🎯**  
- Understand the structure of a policy definition file: display name, type, description, metadata, mode, parameters, and rules.  
- Know the difference between built-in, custom, and static policies.  
- Remember the policy modes and what scope they cover.  
- Parameters make policies flexible and reusable—know their types and metadata.  
- Policy rules use if-then logic; conditions trigger effects.  
- Be familiar with the main policy effects and what they do, especially deny, audit, append, and deployIfNotExists.  
- Disabled effect is useful for testing policies without enforcement.  
- While detailed policy file structure may not be directly tested, understanding these concepts helps in managing Azure Policy effectively.

---

### Configure Policy

**Timestamp**: 01:34:45 – 01:41:06

**Key Concepts**  
- Azure Policy is used to keep resources compliant within an Azure account.  
- Policies can be assigned at different scopes such as subscription or resource group.  
- Policy Initiatives are collections of multiple policies grouped together for easier management.  
- Policies evaluate resources for compliance but do not restrict access.  
- Compliance evaluation happens periodically after policy assignment.  
- Existing resources can be remediated after policy assignment using remediation tasks.  
- Policy definitions are written in JSON format.  
- Assigning a policy can take around 10-30 minutes to take effect and show compliance status.  
- Azure provides many built-in policy definitions and initiatives to get started quickly.  
- Policies can be enabled, disabled, or excluded from assignment scopes.  

**Definitions**  
- **Azure Policy**: A service that enforces organizational standards and assesses compliance at scale by evaluating resources against defined rules.  
- **Policy Definition**: A JSON file that describes the rules and conditions of a policy.  
- **Policy Initiative**: A collection (group) of multiple policy definitions, formerly called a policy set.  
- **Scope**: The level at which a policy is assigned, such as subscription, resource group, or resource.  
- **Remediation Task**: An action to update existing resources to bring them into compliance after a policy is assigned.  

**Key Facts**  
- Policy assignments by default only affect newly created resources unless remediation is applied for existing ones.  
- Policy evaluation and compliance status update can take approximately 10 to 30 minutes after assignment.  
- Azure automatically assigns some default policies to subscriptions to encourage best practices.  
- You can disable or exclude policies if needed.  
- Azure Blueprints are related but not required for AZ-104 exam; they provide a more comprehensive way to deploy policies and resources.  

**Examples**  
- Assigning a built-in policy to audit virtual machines without disaster recovery configured.  
- Creating a cheap Ubuntu virtual machine (B1LS size) to test policy compliance.  
- Viewing non-compliance status on a VM that does not meet the assigned policy criteria.  

**Key Takeaways 🎯**  
- Understand the difference between policy definitions and initiatives (grouped policies).  
- Know that policies evaluate compliance but do not block resource creation or access.  
- Remember that policy assignments take time to evaluate and show compliance results.  
- Be familiar with how to assign policies to scopes and how remediation can be used for existing resources.  
- Know that Azure provides many built-in policies and initiatives to simplify compliance management.  
- Blueprints are useful but not required knowledge for the AZ-104 exam.  
- Policies are described in JSON and can be customized or disabled as needed.

---

### Policies CheatSheet

**Timestamp**: 01:41:06 – 01:41:54

**Key Concepts**  
- Azure Policies enforce organizational standards and assess compliance at scale.  
- Policies do not restrict access; they only observe and evaluate compliance.  
- Policy evaluation happens periodically after assignment.  
- Policy rules are defined in JSON files called policy definitions.  
- Multiple policy definitions can be grouped into a policy initiative (formerly policy set).  

**Definitions**  
- **Azure Policy**: A service that enforces organizational standards and assesses compliance without restricting access.  
- **Policy Definition**: A JSON file that describes the rules of a policy.  
- **Policy Initiative**: A group of policy definitions bundled together to manage compliance more effectively (formerly called a policy set).  

**Key Facts**  
- Policies evaluate compliance state periodically once assigned.  
- The concept of policy initiatives helps organize multiple policies for broader compliance scenarios.  
- No direct exam questions on complex use cases of policy initiatives were noted, but understanding them can enhance knowledge.  

**Examples**  
- None mentioned explicitly in this segment.  

**Key Takeaways 🎯**  
- Remember that Azure Policies observe and enforce standards but do not block or restrict access.  
- Know the structure: policy definitions (JSON) and policy initiatives (grouped policies).  
- Be aware that compliance is evaluated periodically, not instantly.  
- Familiarize yourself with the terminology as it may appear on the exam.  
- Additional reading on use cases in Azure docs can deepen understanding but is not required for the exam.  

---

### Intro

**Timestamp**: 01:41:54 – 01:43:18

**Key Concepts**  
- Azure Resource Manager (ARM) is a deployment and management service for Azure resources.  
- ARM acts as a management layer that enables creation, update, and deletion of Azure resources.  
- ARM enforces management features such as access controls, resource locks, tags, and infrastructure as code via JSON templates.  
- ARM is composed of several components including subscriptions, management groups, resource groups, resource providers, resource locks, Azure blueprints, resource tags, access control (IAM/role-based access control), Azure policies, and ARM templates.  
- ARM functions as a gatekeeper that processes all requests to Azure resources, deciding if the requested action can be performed.

**Definitions**  
- **Azure Resource Manager (ARM)**: A service that manages Azure resources by enabling creation, update, and deletion, and applying management features through a centralized management layer.  
- **Policy Definition**: A JSON file describing the rules of a policy used to evaluate compliance.  
- **Policy Initiative**: A group of policy definitions, formerly called a policy set.  
- **Management Layer**: The collection of services that make up ARM, handling resource management and governance.

**Key Facts**  
- ARM evaluates compliance states periodically once a policy is assigned.  
- ARM is not a single service you can "type in" but a collection of services forming the management layer.  
- Requests to Azure resources flow through ARM, regardless of whether they originate from the Azure portal, PowerShell, CLI, REST API, or SDKs.

**Examples**  
- None explicitly mentioned, but the analogy of ARM as a "gatekeeper" managing all resource requests was used to visualize its role.

**Key Takeaways 🎯**  
- Understand that ARM is the central management layer for Azure resources and governs all resource operations.  
- Know the core components that make up ARM (subscriptions, resource groups, policies, etc.).  
- Remember that policies are defined in JSON and grouped into initiatives for compliance management.  
- Requests to Azure resources always pass through ARM, which authorizes and processes them.  
- Familiarize yourself with the concept of ARM templates for infrastructure as code.  
- No direct exam questions on policy use cases were noted, but reviewing Azure docs on policies can deepen understanding.

---

## ARM

---

### Use Case

**Timestamp**: 01:43:18 – 01:44:26

**Key Concepts**  
- Azure Resource Manager (ARM) acts as a deployment and management service for Azure resources.  
- ARM functions as a gatekeeper that controls and authorizes all requests to Azure resources.  
- Requests to Azure resources can come from multiple sources: Azure Portal, Azure PowerShell, Azure CLI, REST API, and SDKs.  
- ARM works in conjunction with Azure Active Directory for authentication and access control.  
- Resources managed include virtual machines, containers, databases, storage, and other Azure services.  
- The concept of **scope** defines boundaries of control and governance for Azure resources by grouping and applying rules.

**Definitions**  
- **Azure Resource Manager (ARM)**: A service that enables creation, updating, and deletion of Azure resources while managing access and authorization.  
- **Scope**: A boundary of control for Azure resources used to logically group resources and apply governance rules.  
- **Management Groups**: Logical groupings of multiple Azure subscriptions to organize and manage access at a higher level.

**Key Facts**  
- All requests to Azure resources flow through ARM, which decides if the request can be performed.  
- Authentication for ARM is generally done via Azure Active Directory and cannot be swapped out.  
- Scopes help govern resources by placing them in logical groupings and applying restrictions.

**Examples**  
- Requests can originate from:  
  - Azure Portal  
  - Azure PowerShell  
  - Azure CLI  
  - REST API (client)  
  - Azure SDKs  
- Resources accessed include virtual machines, containers, databases, and storage.

**Key Takeaways 🎯**  
- Understand that ARM is the central control point for managing Azure resources and enforcing access control.  
- Remember that all resource requests must pass through ARM and be authenticated via Azure AD.  
- Know the different request sources that interact with ARM.  
- Grasp the concept of scope as a governance boundary and the role of management groups in organizing subscriptions.  
- For exams, focus on ARM’s role as a gatekeeper and the importance of scopes in resource management.  

---

### Scoping

**Timestamp**: 01:44:26 – 01:45:54

**Key Concepts**  
- Scoping defines boundaries of control for Azure resources.  
- Scopes help govern resources by grouping them logically and applying rules.  
- Azure Resource Manager uses scopes to organize and manage resources.  
- Scopes include management groups, subscriptions, resource groups, and resources themselves.  

**Definitions**  
- **Scope**: A boundary of control for Azure resources; a logical grouping to govern resources with rules.  
- **Management Group**: A logical grouping of multiple subscriptions, used to organize subscriptions under a domain such as development, business, or data science.  
- **Subscription**: Grants access to Azure services based on billing and support agreements; determines billing for resources launched under it.  
- **Resource Group**: A logical grouping of multiple resources within a subscription.  
- **Resource**: The actual Azure service instance, e.g., a Virtual Machine.  

**Key Facts**  
- You can have multiple subscriptions in an Azure account.  
- Subscriptions are tied to billing and support plans.  
- Resources must be launched under a subscription to determine billing.  
- Management groups allow grouping of subscriptions for organizational purposes.  
- Resource groups organize resources within a subscription.  

**Examples**  
- Management groups could be organized by domains such as development, business, or data science.  
- Resources examples include virtual machines, containers, databases, and storage.  

**Key Takeaways 🎯**  
- Understand the hierarchy: Management Group > Subscription > Resource Group > Resource.  
- Always associate resources with a subscription to enable billing and access controls.  
- Scopes are foundational for applying governance and role-based access controls in Azure.  
- Remember that subscriptions define billing and support agreements and are required before deploying resources.

---

### Subscriptions

**Timestamp**: 01:45:54 – 01:47:00

**Key Concepts**  
- A subscription is required before you can do anything in an Azure account.  
- Subscriptions define the billing plan for resources launched in Azure.  
- Multiple subscriptions can exist within one Azure account.  
- Common subscription types include Free Trial, Pay-As-You-Go, and Azure for Students.  
- Subscriptions allow management of resource tags and access controls.  
- Azure Management Groups enable hierarchical management of multiple subscriptions.  
- The Root Management Group is the top-level container for all subscriptions in a directory.  
- Subscriptions inherit policies and conditions applied to their management group.

**Definitions**  
- **Subscription**: A billing and management container in Azure that determines the plan and permissions for resources launched under it.  
- **Azure Management Group**: A hierarchical container that organizes multiple subscriptions and applies policies or access controls across them.  
- **Root Management Group**: The single top-level management group in an Azure directory that contains all other management groups and subscriptions.

**Key Facts**  
- You must have a subscription to launch any Azure resources.  
- There are multiple subscription types beyond the common three, e.g., developer support subscriptions require payment.  
- Access controls and resource tags can be set at the subscription level.  
- Management groups allow grouping of subscriptions by departments such as HR, IT, Marketing.  
- Subscriptions automatically inherit conditions from their parent management group.

**Examples**  
- Common subscription types: Free Trial, Pay-As-You-Go, Azure for Students.  
- Management groups example hierarchy: Root Management Group > Human Resources / IT / Marketing > Subscriptions > Resource Groups.

**Key Takeaways 🎯**  
- Always remember that a subscription is mandatory to use Azure services and determines billing.  
- Understand the difference between subscriptions and management groups: subscriptions hold resources; management groups organize subscriptions.  
- Know the common subscription types and that more specialized subscriptions (like developer support) may require additional payment.  
- Policies and access controls can be applied at the subscription or management group level and are inherited down the hierarchy.  
- Be familiar with the hierarchical structure: Root Management Group at the top, then management groups, then subscriptions, then resource groups.

---

### Management Groups

**Timestamp**: 01:47:00 – 01:48:05

**Key Concepts**  
- Management Groups allow management of multiple Azure subscriptions within a hierarchical structure.  
- Each Azure directory has a single top-level management group called the Root Management Group.  
- Subscriptions inherit policies and access controls applied to their parent management group.  
- Hierarchical structure enables organizing subscriptions under management groups like HR, IT, Marketing.  
- Management groups create "choke points" to apply access controls and permissions efficiently across subscriptions.

**Definitions**  
- **Management Group**: A container that helps manage access, policies, and compliance across multiple Azure subscriptions in a hierarchy.  
- **Root Management Group**: The single top-level management group automatically created for each Azure directory, under which all other management groups and subscriptions reside.  
- **Subscription**: An Azure account that holds resources and is managed under management groups.  
- **Resource Group**: A container that holds related Azure resources (mentioned briefly as a further subdivision).

**Key Facts**  
- All subscriptions within a management group automatically inherit the conditions (access controls, policies) applied at the management group level.  
- The hierarchy typically looks like: Root Management Group → Management Groups (e.g., HR, IT, Marketing) → Subscriptions → Resource Groups → Resources.  
- Access controls can be scoped to management groups to restrict user permissions effectively (e.g., marketing users only access billing info).

**Examples**  
- Example hierarchy: Root Management Group at the top, with child management groups such as Human Resources, IT, Marketing, each containing different subscriptions.  
- Access control example: Limiting marketing team users to only have access to billing information by applying permissions at the marketing management group level.

**Key Takeaways 🎯**  
- Understand that management groups provide centralized management for multiple subscriptions via a hierarchical structure.  
- Remember the Root Management Group is the top-level container for all management groups and subscriptions in a directory.  
- Policies and access controls applied at a management group level automatically flow down to all subscriptions beneath it.  
- Use management groups to enforce governance and security boundaries efficiently across large Azure environments.  
- Be able to distinguish between management groups, subscriptions, resource groups, and resources in the Azure hierarchy.

---

### Resource Groups

**Timestamp**: 01:48:05 – 01:48:40

**Key Concepts**  
- Resource groups act as containers that hold related Azure resources.  
- Individual resources (e.g., virtual machines) reside within these resource groups.  
- Resource providers supply the actual Azure services/resources within these groups.

**Definitions**  
- **Resource Group**: A container that holds related Azure resources for management and organization.  
- **Resource**: An individual Azure service or component, such as a virtual machine.  
- **Resource Provider**: A service that supplies Azure resources (e.g., Microsoft.Compute provides compute resources like VMs).

**Key Facts**  
- Resource groups help organize and manage related resources collectively.  
- Resource providers must be registered in your Azure subscription to use their services.  
- Many resource providers are registered by default, enabling immediate use of common services.  

**Examples**  
- Visual example: multiple virtual machines grouped inside a single resource group.  
- Microsoft.Compute is an example of a resource provider supplying virtual machines.

**Key Takeaways 🎯**  
- Understand that resource groups are logical containers for related Azure resources.  
- Know that each resource belongs to a resource group.  
- Remember that resource providers must be registered to enable the use of specific Azure services.  
- Many providers come pre-registered, but some (like Kubernetes) may require manual registration.  
- Registration acts as a safeguard to control access to potentially costly or complex services.

---

### Resource Providers

**Timestamp**: 01:48:40 – 01:49:49

**Key Concepts**  
- Resource providers must be registered to use specific Azure resources.  
- Many resource providers come pre-registered by default in an Azure subscription.  
- Resource providers are services that supply Azure resources (e.g., Microsoft.Compute).  
- Registration acts as a control mechanism to enable or disable access to certain services.  

**Definitions**  
- **Resource Provider**: A service in Azure that supplies resources (such as virtual machines, storage, etc.) to a subscription.  
- **Registering a Resource Provider**: The process of enabling a resource provider within an Azure subscription to allow the use of its services.  

**Key Facts**  
- Some resource providers are registered automatically in a subscription, allowing immediate use of many Azure services.  
- If a service (e.g., Kubernetes) does not appear in search or documentation, it may be because its resource provider is not registered.  
- Users can manually register resource providers via the Azure subscription settings.  
- Registration is a safeguard to ensure users consciously enable potentially costly or complex services.  

**Examples**  
- Microsoft.Compute is an example of a resource provider that supplies compute resources like virtual machines.  
- Kubernetes resource provider might need manual registration if it does not appear by default.  

**Key Takeaways 🎯**  
- Always check if the required resource provider is registered before attempting to use a new Azure service.  
- If a service is missing in the Azure portal or search, verify and register the corresponding resource provider.  
- Understand that resource provider registration is a deliberate action to control service availability and cost management.  
- Familiarize yourself with common resource providers like Microsoft.Compute as foundational knowledge for Azure resource management.

---

### Resource Tags

**Timestamp**: 01:49:49 – 01:51:24

**Key Concepts**  
- Resource tags are key-value pairs assigned to Azure resources.  
- Tags help organize and manage Azure resources effectively.  
- Tags can be applied during resource creation via the tags page.  
- Tags support multiple organizational purposes including resource management, cost management, operations, and security.

**Definitions**  
- **Resource Tag (Tag)**: A key and value pair assigned to Azure resources to categorize and organize them.

**Key Facts**  
- Tags can represent attributes such as department, status, team, environment, project, or location.  
- Uses of tags include:  
  - Resource management (e.g., specifying workloads, environments like development)  
  - Cost management and optimization (e.g., cost tracking, budgets, alerts)  
  - Operations management (e.g., identifying mission-critical services, SLA commitments)  
  - Security classification (e.g., data classification, compliance requirements)  
  - Automation and workload optimization  

**Examples**  
- Department: Finance, IT, HR  
- Status: Approved  
- Environment: Development, Production  
- Project: ProjectX  
- Location: East US  

**Key Takeaways 🎯**  
- Always consider applying tags to your Azure resources, especially in production environments.  
- Tags improve resource organization, cost tracking, and operational management.  
- Tags are a best practice for managing large-scale Azure deployments.  
- Even if not frequently used in demos or labs, tagging is critical for real-world Azure governance and management.  

---

### Resource Locks

**Timestamp**: 01:51:24 – 01:52:04

**Key Concepts**  
- Resource locks are used to prevent accidental deletion or modification of critical Azure resources.  
- Locks can be applied at different scopes: subscription, resource group, or individual resource level.  
- There are two lock levels available in Azure Portal:  
  1. **CanNotDelete**  
  2. **ReadOnly**

**Definitions**  
- **Resource Lock**: A mechanism to restrict actions on Azure resources to protect them from accidental changes or deletion.  
- **CanNotDelete Lock**: Prevents deletion of the resource but still allows authorized users to read and modify it.  
- **ReadOnly Lock**: Allows authorized users to only read the resource; they cannot delete or update it.

**Key Facts**  
- Locks help maintain resource integrity by limiting destructive operations.  
- Even with locks, authorized users retain read access (in both lock modes).  
- The difference between the two lock levels is whether modification is allowed (CanNotDelete) or not (ReadOnly).

**Examples**  
- None mentioned explicitly, but implied use case: locking a subscription, resource group, or resource to avoid accidental deletion or modification.

**Key Takeaways 🎯**  
- Use resource locks to safeguard critical Azure resources from accidental deletion or modification.  
- Understand the difference between CanNotDelete (prevents deletion, allows modification) and ReadOnly (prevents deletion and modification).  
- Locks can be applied at multiple scopes depending on the level of protection needed.  
- Remember that locks do not prevent reading the resource; they only restrict delete/update operations.

---

### Blueprints

**Timestamp**: 01:52:04 – 01:54:06

**Key Concepts**  
- Azure Blueprints enable quick creation of governed subscriptions.  
- Governed subscriptions have predefined processes and expectations for setup.  
- Blueprints are reusable compositions of artifacts based on organizational patterns.  
- Blueprints provide a declarative way to orchestrate deployment of resources and configurations.  
- Artifacts in Blueprints can include role assignments, policy assignments, ARM templates, and resource groups.  
- Azure Blueprints are backed by globally distributed Azure Cosmos DB for replication and backup.  
- Blueprints maintain an active relationship between the blueprint definition and its assignments, allowing upgrades and multi-subscription management.  
- Blueprints support improved tracking and auditing of deployments compared to ARM templates.

**Definitions**  
- **Azure Blueprints**: A service that allows you to define a repeatable set of Azure resources and policies to create governed subscriptions with consistent environments.  
- **Declarative**: A method where the desired state is fully specified, so the system knows exactly what to create or configure.  
- **Artifact**: Components included in a blueprint such as role assignments, policy assignments, ARM templates, and resource groups.  
- **ARM Template**: Azure Resource Manager template, a JSON file that defines infrastructure and configuration for Azure resources.

**Key Facts**  
- Blueprints are stored and replicated globally using Azure Cosmos DB.  
- ARM templates can automate deployment but lack the active linkage and upgrade capabilities of Blueprints.  
- Blueprints can upgrade multiple subscriptions governed by the same blueprint simultaneously.  
- Blueprints provide better tracking and auditing features than standalone ARM templates.

**Examples**  
- None specifically mentioned beyond general artifact types (role assignments, policy assignments, ARM templates, resource groups).

**Key Takeaways 🎯**  
- Use Azure Blueprints when you need governed, repeatable, and auditable subscription setups.  
- Blueprints are preferred over ARM templates alone for managing multiple subscriptions and upgrades.  
- Understand that Blueprints are declarative and backed by Cosmos DB for reliability and replication.  
- Remember the difference: ARM templates automate deployment but lack the governance and lifecycle management features of Blueprints.

---

### Moving Resources

**Timestamp**: 01:54:06 – 02:06:40

**Key Concepts**  
- Moving Azure resources between resource groups, regions, and subscriptions.  
- Limitations and edge cases when moving certain resource types (e.g., App Services, DevOps services, VMs).  
- Resource locks and their impact on modifying, deleting, and moving resources.  
- Behavior of moving resources into or out of resource groups with locks applied.  
- Deployment conflicts when moving resources during active deployments.  

**Definitions**  
- **Resource Group**: A container that holds related Azure resources for an Azure solution.  
- **Resource Lock**: A setting applied to a resource or resource group to prevent accidental modification or deletion. Types include:  
  - **Read-only lock**: Prevents any write operations (modifications) on the resource.  
  - **Delete lock**: Prevents deletion of the resource but allows modifications.  

**Key Facts**  
- Moving resources between resource groups can also involve moving across regions and subscriptions.  
- Some resources, like App Services, cannot be moved if a similar resource already exists in the target subscription.  
- Diagnostic tools can help debug issues when moving resources.  
- Locks affect operations as follows:  
  - **Read-only lock**: Cannot modify or move the resource out of the resource group.  
  - **Delete lock**: Cannot delete the resource but can move it out of the resource group.  
- You can move a resource **into** a resource group that has a read-only lock applied.  
- Moving a resource while an active deployment is ongoing in the resource group will cause the move to fail.  
- Locks must be removed before moving a resource out of a resource group if the lock is read-only.  
- Locks are applied at the resource group level and can be named (e.g., "Do not delete me", "Don't touch").  

**Examples**  
- Created two resource groups: "Federation of Planets" (East US) and "Klingon Empire" (West US).  
- Created a disk resource named "dilithium" in the Federation of Planets group and moved it to Klingon Empire group successfully.  
- Applied a read-only lock on the disk resource and attempted to resize it — operation failed due to lock.  
- Applied a delete lock and attempted to delete the disk — deletion failed due to lock.  
- Tried moving the disk resource out of the resource group with both locks applied — failed due to read-only lock.  
- Removed read-only lock, left delete lock, and successfully moved the resource out.  
- Created another resource group "Romulan Star Empire" with a read-only lock and successfully moved a new disk resource into it.  
- Noted that moving resources during active deployments causes move failure.  

**Key Takeaways 🎯**  
- Always check for resource locks before moving resources; read-only locks block moves out, delete locks block deletions only.  
- You can move resources into resource groups with read-only locks but cannot move them out without removing the lock.  
- Moving resources during active deployments in the resource group will fail — avoid concurrent deployments and moves.  
- Some resource types have specific limitations when moving across subscriptions or regions (e.g., App Services).  
- Use diagnostic tools to troubleshoot move failures.  
- Understand the difference between read-only and delete locks and their impact on resource management.  
- Locks are a critical feature to prevent accidental changes and deletions, especially in production environments.  
- Exam questions may test your knowledge of these lock behaviors and move limitations — memorize these scenarios.

---

### ARM CheatSheet

**Timestamp**: 02:06:40 – 02:08:58

**Key Concepts**  
- Azure Resource Manager (ARM) is a management layer for Azure resources.  
- ARM allows creation, updating, deletion of resources and management features like access controls, locks, and tags.  
- ARM supports infrastructure as code (IaC) through JSON templates (ARM templates).  
- ARM spans multiple Azure features: subscriptions, management groups, resource groups, resource providers, resource locks, blueprints, tags, IAM (role-based access control), policies, and templates.  
- ARM acts as a gatekeeper for all requests to Azure resources, deciding if requests are permitted.  
- Scope defines boundaries of control and governance for Azure resources, organized hierarchically: management groups > subscriptions > resource groups > resources.  
- Resource providers represent Azure services; some are registered by default, others require manual registration.  
- Resource tags are key-value pairs assigned to resources for organization.  
- Resource locks prevent accidental modification or deletion; two types exist: "CanNotDelete" and "ReadOnly".  
- Azure Blueprints enable quick creation of governed subscriptions and can deploy nearly everything achievable with ARM templates.  

**Definitions**  
- **Azure Resource Manager (ARM)**: The service layer that manages Azure resources by enabling creation, update, deletion, and management features like access control and tagging.  
- **Scope**: A boundary of control for Azure resources used to govern and apply rules logically across resources.  
- **Resource Providers**: Services within Azure that provide resources; some are pre-registered, others need explicit registration.  
- **Resource Tags**: Key-value pairs assigned to Azure resources for categorization and management.  
- **Resource Locks**: Mechanisms to prevent accidental deletion or modification of resources; two types:  
  - **CanNotDelete**: Prevents deletion of resources.  
  - **ReadOnly**: Prevents modification of resources.  
- **Azure Blueprints**: A service to deploy governed subscriptions quickly, using definitions and assignments, often leveraging ARM templates.  

**Key Facts**  
- ARM templates are JSON files used for infrastructure as code.  
- Azure accounts can have multiple subscriptions; common types include Free, Trial, Pay-As-You-Go, and Azure for Students.  
- If a service is not available in the Azure portal search, it may need to be registered manually.  
- There is some inconsistency between the Azure portal and API regarding resource lock terminology (e.g., "CanNotDelete" vs "Delete").  

**Examples**  
- None explicitly mentioned in this section.  

**Key Takeaways 🎯**  
- Understand ARM as the central management layer and gatekeeper for Azure resource operations.  
- Know the hierarchy of scopes: management groups > subscriptions > resource groups > resources.  
- Remember the two types of resource locks and their purposes to protect resources.  
- Be aware that some resource providers require manual registration before use.  
- Azure Blueprints complement ARM templates for governed subscription deployment.  
- ARM templates are JSON files used to define infrastructure as code declaratively.  
- For exam scenarios, expect questions on resource scopes, locks, tags, and the role of ARM in managing Azure resources.

---

## ARM Templates

---

### Intro to ARM Templates

**Timestamp**: 02:08:58 – 02:11:53

**Key Concepts**  
- ARM templates are JSON files used for Infrastructure as Code (IaC) in Azure.  
- ARM templates are declarative: what you define is exactly what you get.  
- They enable provisioning, configuring, standing up, tearing down, or sharing entire Azure architectures quickly and consistently.  
- ARM templates reduce configuration mistakes and help establish an architectural baseline for compliance.  
- They are modular and extendable (can include PowerShell and Bash scripts).  
- ARM templates support testing via ARM Template Toolkit (ARM TTK).  
- Preview changes feature allows seeing what will be created before deployment.  
- Built-in validation ensures templates only deploy if they pass validation.  
- Deployment tracking helps monitor changes over time.  
- ARM templates integrate with Azure Policy as code to enforce compliance.  
- Microsoft Blueprints build on ARM templates by managing relationships between resources and templates.  
- ARM templates support CI/CD integration and can export current resource states.  
- Visual Studio Code offers advanced authoring tools for ARM templates.  

**Definitions**  
- **ARM Template**: A JSON file that declaratively defines Azure resources and configurations to be provisioned.  
- **Infrastructure as Code (IaC)**: Managing and provisioning data centers and cloud resources through machine-readable definition files instead of manual or interactive configuration.  
- **Declarative IaC**: Defining the desired state explicitly; the system provisions exactly what is described.  
- **Imperative IaC**: Defining commands or steps to achieve a desired state, often requiring the system to infer missing details.  
- **Azure Blueprints**: A higher-level service that uses ARM templates to quickly create governed subscriptions and manage relationships between resources and templates.  
- **ARM Template Toolkit (ARM TTK)**: A testing framework to validate ARM templates before deployment.  

**Key Facts**  
- ARM templates are JSON files.  
- They enable rapid deployment or teardown of entire environments in minutes.  
- ARM templates help maintain compliance by establishing architectural baselines.  
- They support modularization and reuse by breaking architectures into multiple files.  
- Preview and validation features reduce deployment errors.  
- ARM templates can be integrated into CI/CD pipelines.  
- Visual Studio Code is recommended for authoring ARM templates due to advanced features.  

**Examples**  
- None explicitly mentioned in this section; general references to adding PowerShell/Bash scripts and using Visual Studio Code for authoring.  

**Key Takeaways 🎯**  
- Understand that ARM templates are declarative JSON files for Azure resource provisioning.  
- Remember ARM templates reduce errors and speed up environment deployment.  
- Know the benefits: modularity, extendability, testing, preview, validation, and deployment tracking.  
- Be aware of Azure Blueprints as an extension that manages resource-template relationships.  
- Use ARM TTK for testing templates before deployment.  
- Use Visual Studio Code for efficient ARM template authoring.  
- Prefer ARM templates/IaC over manual portal configurations for production workloads to ensure consistency and compliance.

---

### ARM Template Skeleton

**Timestamp**: 02:11:53 – 02:13:15

**Key Concepts**  
- ARM templates are JSON files that define the infrastructure and configuration for Azure resources.  
- The general structure (skeleton) of an ARM template includes several key sections that organize the template’s content and behavior.  
- Each section in the template serves a specific purpose, from defining schema to specifying resources and outputs.

**Definitions**  
- **Schema**: Describes the JSON structure and properties expected within the ARM template. It links to a JSON schema URL that validates the template format.  
- **Content Version**: A user-defined version string for the template, used to track changes; it is arbitrary and does not affect deployment.  
- **API Profile**: A value used to avoid specifying API versions individually for each resource in the template.  
- **Parameters**: Input values passed into the template to customize deployments.  
- **Variables**: Expressions or transformations applied to parameters or resource properties to simplify template logic.  
- **Functions**: User-defined functions available within the template to perform operations or calculations.  
- **Resources**: The Azure resources (e.g., VMs, storage accounts) that the template will deploy or update.  
- **Outputs**: Values returned after deployment, useful for referencing deployed resource properties.

**Key Facts**  
- The ARM template skeleton consists of these main sections: schema, contentVersion, apiProfile, parameters, variables, functions, resources, and outputs.  
- The **type** attribute in a resource follows the format: `<resource provider>/<resource type>` (e.g., Microsoft.Storage/storageAccounts).  
- The **apiVersion** attribute specifies the REST API version for the resource; each resource provider has its own API versions that must be referenced correctly.  
- Resource **name** can be dynamic, often set using variables.

**Examples**  
- Example resource type: Storage account (`Microsoft.Storage/storageAccounts`).  
- Resource name example: Using a variable to dynamically assign the resource name.

**Key Takeaways 🎯**  
- Understand the purpose and content of each ARM template section—especially schema, parameters, variables, resources, and outputs.  
- Remember that the contentVersion is a user-defined string for version tracking and does not impact deployment behavior.  
- Know that apiProfile helps simplify API version management but individual resource apiVersion attributes still need to be accurate.  
- Be familiar with the resource section attributes: type, apiVersion, and name, as these are critical for defining Azure resources correctly.  
- Use variables to make resource names and properties dynamic and reusable within templates.  
- Outputs are important for retrieving information post-deployment, useful in chained deployments or scripts.

---

### ARM Template Resources

**Timestamp**: 02:13:15 – 02:14:32

**Key Concepts**  
- ARM template resources define the Azure resources you want to deploy or update.  
- Each resource has specific attributes such as type, API version, name, location, and other resource-specific properties.  
- Parameters allow passing values into the template to make deployments dynamic.  
- Variables can be used to dynamically set resource names or other properties.  
- API version is specific to each resource provider and must be looked up individually.  
- Location specifies the Azure region where the resource will be deployed.  
- Properties vary depending on the resource type (e.g., storage account kind).

**Definitions**  
- **Resource**: An Azure entity (e.g., virtual machine, database, storage account) defined in the ARM template to be provisioned or updated.  
- **Type**: The resource provider and resource type identifier used in the template (e.g., Microsoft.Storage/storageAccounts).  
- **API Version**: The REST API version used for the resource, specific to each resource provider.  
- **Name**: The identifier for the resource, which can be static or dynamically set using variables or parameters.  
- **Location**: The Azure region where the resource will be deployed.  
- **Parameters**: Inputs passed into the ARM template to customize deployments.  
- **Properties**: Resource-specific settings that vary based on the resource type.

**Key Facts**  
- API versions differ per resource provider and must be individually referenced.  
- Most resources require a location property specifying the deployment region.  
- Resource names can be dynamic by referencing variables or parameters.  
- Properties section varies widely depending on the resource type (e.g., storage account kind is a property for storage accounts).  
- Parameters require a type declaration (e.g., string).

**Examples**  
- Storage account resource example with:  
  - Type set to storage account resource provider format.  
  - API version specified for the storage account.  
  - Name set dynamically using a variable.  
  - Location property defined.  
  - Properties including the kind of storage account.

**Key Takeaways 🎯**  
- Always specify the correct API version for each resource provider in your ARM templates.  
- Use parameters to pass dynamic values into your templates and declare their types explicitly.  
- Use variables to create dynamic resource names or properties.  
- Remember that location is a required property for most resources.  
- Understand that resource properties differ by resource type—know the key properties for common resources like storage accounts.  
- Review resource provider documentation to confirm API versions and required properties before deployment.

---

### ARM Template Parameters

**Timestamp**: 02:14:32 – 02:16:02

**Key Concepts**  
- Parameters in ARM templates allow passing variables into the template to customize deployments.  
- Parameters are defined at the top of the ARM template and referenced within resource definitions.  
- Parameters have types that define the kind of data they accept.  
- Additional constraints and metadata can be applied to parameters to control input and provide clarity.

**Definitions**  
- **Parameter**: A variable input to an ARM template that allows customization of resource deployment.  
- **Parameter Types**: Data types that parameters can have, including string, secure string, int, bool, object, secure object, and array.  
- **Default Value**: A fallback value used if no parameter value is provided during deployment.  
- **Allowed Values**: A predefined list of acceptable values for a parameter, restricting input to those values only.  
- **Min/Max Value**: Numeric constraints that limit the minimum and maximum allowed integer values for a parameter.  
- **Min/Max Length**: String constraints that specify the minimum and maximum number of characters allowed.  
- **Description**: A text explanation of the parameter’s purpose, useful for clarity when deploying via the portal.

**Key Facts**  
- Parameter types include: string, secure string, int, bool, object, secure object, array.  
- Default values are used if no input is provided for a parameter.  
- Allowed values restrict parameters to a specific set of inputs (defined as an array).  
- Min and max values apply to integer parameters to enforce numeric limits.  
- Min and max length apply to string parameters to enforce character count limits.  
- Descriptions help users understand the parameter’s role during deployment.

**Examples**  
- Example of setting a parameter type as string.  
- Using parameters within resources by referencing them in the ARM template.  
- None of the examples showed full parameter JSON syntax, but the concept of defining and referencing parameters was demonstrated.

**Key Takeaways 🎯**  
- Always define the parameter type to ensure correct input validation.  
- Use default values to provide fallback options and avoid deployment failures.  
- Use allowed values to restrict inputs and prevent invalid configurations.  
- Apply min/max values and lengths to enforce input constraints and improve template robustness.  
- Include descriptive text for parameters to improve usability and clarity in the Azure portal.  
- Understanding parameters is critical for customizing ARM template deployments effectively.

---

### ARM Template Functions

**Timestamp**: 02:16:02 – 02:17:42

**Key Concepts**  
- ARM template functions allow transformations on ARM template variables and parameters.  
- Functions come in two types:  
  - **Template functions**: Built-in functions provided by ARM.  
  - **User-defined functions**: Custom functions created to extend functionality (not covered in detail).  
- Functions are identified by their name followed by parentheses containing arguments.  
- Functions cover various categories including arrays, comparisons, dates, deployments, logical operators, numerical operations, objects, resources, providers, and strings.  
- Parameters and variables themselves are accessed via functions.  
- Variables simplify templates by storing transformed values for reuse and can be nested within JSON objects.

**Definitions**  
- **Template functions**: Predefined functions in ARM templates used to manipulate and transform data.  
- **User-defined functions**: Custom functions created by users to add specific functionality beyond built-in functions.  
- **Variables**: Named values in ARM templates that store results of functions or expressions for reuse and simplification.

**Key Facts**  
- Functions use the syntax: `functionName(arguments)` (parentheses indicate a function).  
- Examples of function categories:  
  - Array functions: `array`, `concat`, `contains`, `createArray`, `empty`, `first`  
  - Comparison functions: `less`, `equals`, `lessOrEquals`, `greater`, `greaterOrEquals`  
  - Logical operators: `and`, `or`, `if`, `not`  
  - Numerical functions: `add`, `div`, `float`, `int`, `min`, `max`  
  - Object functions: `contains`, `empty`, `intersection`  
  - Resource functions: `extensionResourceId`  
  - Provider and reference functions: `providers`, `reference`  
  - String functions: `base64`, `concat`, `contains`  
- Parameters and variables are accessed via functions, highlighting their functional nature.

**Examples**  
- None explicitly shown in this section; only function names and categories were listed.  
- Mentioned example: `equals()` function syntax explained as `equals(argument1, argument2)`.

**Key Takeaways 🎯**  
- Recognize that ARM template functions are essential for transforming and manipulating template data.  
- Understand the two types of functions: built-in (template) and user-defined.  
- Remember the syntax pattern: function name followed by parentheses with arguments.  
- Be familiar with the broad categories of built-in functions and their general purposes.  
- Know that parameters and variables are accessed via functions, reinforcing their dynamic nature.  
- Variables help simplify templates by storing reusable transformed values and can be nested within JSON objects.  
- User-defined functions exist but are less critical for exam focus based on this content.

---

### ARM Template Variables

**Timestamp**: 02:17:42 – 02:18:44

**Key Concepts**  
- Variables simplify ARM templates by storing reusable values.  
- Variables transform parameters and resource properties using functions.  
- Variables help shorten resource definitions by avoiding repeated complex expressions.  
- Variables can be nested within JSON objects for structured and hierarchical data.  
- Accessing nested variables uses square bracket notation.

**Definitions**  
- **Variables**: Named values in ARM templates that hold expressions or transformed data, making templates easier to read and maintain.  
- **Nested Variables**: Variables defined as JSON objects containing other variables or values, allowing hierarchical organization.

**Key Facts**  
- Variables are defined under the `variables` section in an ARM template.  
- Variables can include function calls and expressions on the right-hand side.  
- Nested variables can be accessed using syntax like `variables('environmentSettings')['test']`.  
- Using variables reduces repetition and complexity in resource property definitions.

**Examples**  
- Defining a variable `storageName` by combining multiple functions into one reusable value.  
- Nested variable example: `variables('environmentSettings')['test']['instanceSizes']` accessing a parameter-defined nested object.

**Key Takeaways 🎯**  
- Always use variables to simplify and shorten ARM template resource property expressions.  
- Understand how to define and access nested variables using square bracket notation.  
- Remember variables can hold complex expressions and function results, improving template maintainability.  
- Practice reading and writing nested variables to handle complex template scenarios efficiently.

---

### ARM Template Output

**Timestamp**: 02:18:44 – 02:19:36

**Key Concepts**  
- ARM template **outputs** are used to return values from deployed resources.  
- Outputs enable you to access resource properties pragmatically after deployment.  
- Outputs can be simple strings or complex expressions using variables and functions.  
- Outputs are useful for chaining ARM templates by passing values from one deployment to another.  
- You can retrieve output values using the Azure CLI after deployment.

**Definitions**  
- **Outputs**: Sections in an ARM template that return values from deployed resources, allowing those values to be used programmatically or passed to subsequent deployments.

**Key Facts**  
- Outputs can return resource properties such as resource IDs.  
- Output values can be accessed via CLI commands querying the deployment.  
- Outputs facilitate sequential deployment workflows by passing data between templates.

**Examples**  
- Outputting a resource ID as a string using a variable or functions inside the output value.  
- Using CLI to show deployment outputs, e.g., retrieving the resource ID from the deployment output.

**Key Takeaways 🎯**  
- Remember to define outputs in your ARM templates to expose important resource information after deployment.  
- Use outputs to chain multiple ARM templates together by passing necessary values forward.  
- Practice retrieving outputs via Azure CLI to verify deployment results and use outputs in automation scripts.  
- Outputs help automate infrastructure as code by enabling dynamic referencing of deployed resource properties.  

---

### Launch an ARM Template

**Timestamp**: 02:19:36 – 02:30:12

**Key Concepts**  
- ARM Templates enable Infrastructure as Code (IaC) for Azure resources using JSON files.  
- Templates define resources and their configurations declaratively, allowing repeatable deployments.  
- ARM templates are deployed at the resource group or subscription level, specifically within resource group deployments.  
- Outputs from one deployment can be used as inputs for chaining subsequent deployments.  
- Parameters and variables in templates allow customization and reuse.  
- Deployment failures do not roll back partially created resources; manual cleanup is required.  
- Azure portal allows deploying custom ARM templates via the “Deploy a custom template” option.  
- Existing resources can be exported as ARM templates from resource groups for reuse or modification.  

**Definitions**  
- **ARM Template**: A JSON file that declaratively defines Azure resources and their configurations for automated deployment.  
- **Infrastructure as Code (IaC)**: Managing and provisioning infrastructure through machine-readable definition files rather than manual or interactive configuration.  
- **Parameters**: Inputs to ARM templates that allow customization of resource properties at deployment time.  
- **Variables**: Values defined within the template that can be static or derived using functions, used to simplify template management.  
- **Outputs**: Values returned by a deployment that can be used programmatically or passed to other templates.  

**Key Facts**  
- Default content version in ARM templates is typically "1.0.0.0".  
- Common VM sizes must be available in the target region; e.g., Standard D1 may not be available, Standard B1LS is a valid alternative.  
- Password parameters can be set as secure strings to hide input during deployment.  
- Deployment failures do not automatically roll back created resources; manual deletion of resources is necessary.  
- Exporting templates from existing resource groups can include multiple resources but may not capture all configurations.  

**Examples**  
- Deploying a virtual machine named "WARF" with parameters such as username "warf", password "Testing123456", Ubuntu OS version 14, and storage replication type LRS.  
- Initial deployment failed due to unavailable VM size (Standard D1) in the region; corrected to Standard B1LS.  
- Partial resources like virtual network, storage account, and network interface were created despite deployment failure.  
- Exporting templates from resource groups to capture existing resource configurations for reuse.  

**Key Takeaways 🎯**  
- Understand that ARM templates are declarative JSON files used to automate Azure resource deployments.  
- Know how to deploy ARM templates via the Azure portal using the “Deploy a custom template” option.  
- Always verify VM sizes and other resource properties are available in the target region to avoid deployment failures.  
- Remember that deployment failures do not roll back created resources; manual cleanup is required.  
- Use parameters and variables effectively to customize and simplify templates.  
- Outputs are useful for chaining deployments and passing data between templates.  
- You can export ARM templates from existing resource groups to capture current infrastructure as code.  
- Secure string parameters hide sensitive information like passwords during deployment.  
- Familiarize yourself with the difference between declarative (ARM templates) and imperative IaC approaches.

---

### ARM Template CheatSheet

**Timestamp**: 02:30:12 – 02:32:04

**Key Concepts**  
- Infrastructure as Code (IaC) is managing and provisioning data centers via machine-readable definition files instead of manual or interactive configuration.  
- IaC has two approaches:  
  - Declarative: Define exactly what you want and get exactly that.  
  - Imperative: Specify generally what you want; system fills in the blanks.  
- ARM templates are JSON files used for declarative IaC in Azure.  
- ARM templates define Azure resources and configurations exactly as specified.  

**Definitions**  
- **Infrastructure as Code (IaC)**: Managing and provisioning computing infrastructure through machine-readable files rather than manual setup.  
- **Declarative IaC**: Defining the desired state explicitly; the system ensures the environment matches this state.  
- **Imperative IaC**: Defining steps or commands to achieve a desired state, often leaving some details to the system.  
- **ARM Template**: A JSON file that declaratively defines Azure resources and their configurations for deployment.  

**Key Facts**  
- ARM templates use a JSON structure with key sections:  
  - **$schema**: Describes available properties in the template.  
  - **contentVersion**: Version of the template; any value can be used.  
  - **apiProfile**: Optional; simplifies specifying API versions for resources.  
  - **parameters**: Inputs passed into the template to customize deployment.  
  - **variables**: Used to transform parameters or resource properties using functions and expressions.  
  - **functions**: Predefined functions available within templates (too many to list).  
  - **resources**: Defines Azure resources to deploy/update, including:  
    - type  
    - apiVersion  
    - name  
    - location  
    - properties (varies widely by resource)  
  - **outputs**: Values returned after deployment for further use.  

**Examples**  
- None specifically mentioned; focus was on the structure and components of ARM templates.  

**Key Takeaways 🎯**  
- Know the JSON structure of ARM templates and the purpose of each section.  
- Understand the difference between declarative and imperative IaC, with ARM templates being declarative.  
- Be familiar with key template elements: schema, contentVersion, parameters, variables, resources, and outputs.  
- Remember that resource properties vary widely and are resource-specific.  
- Outputs can be used to retrieve values post-deployment for further automation or referencing.  
- API profile can simplify version management but is optional.  
- Functions and variables allow dynamic and reusable template logic but are complex and numerous—focus on practical usage rather than memorizing all functions.

---

## Storage Accounts

---

### Intro to Storage Accounts

**Timestamp**: 02:32:04 – 02:33:48

**Key Concepts**  
- Azure Storage Accounts contain all Azure Storage data objects: blobs, files, queues, tables, and disks.  
- Storage Accounts are multi-purpose services with different storage types inside them.  
- Different storage types have distinct features and pricing models.  
- The term "storage type" is used interchangeably with "account kind" in the Azure UI.  
- Common features across storage accounts include supported services, performance tiers, access tiers, replication, and deployment models.  

**Definitions**  
- **Storage Account**: A container in Azure that holds various storage data objects such as blobs, files, queues, tables, and disks.  
- **Account Kind**: The classification of a storage account that determines the type of storage and features available (e.g., General Purpose v1, General Purpose v2, Blob Storage).  
- **Performance Tiers**: Levels indicating the speed of read/write operations, typically Standard or Premium.  
- **Access Tiers**: Frequency-based tiers indicating how often data is accessed (e.g., hot, cool).  
- **Replication**: The number and location of redundant copies of data to ensure durability and availability.  
- **Deployment Models**: The method used to deploy storage accounts, mainly Resource Manager or Classic (only for General Purpose v1).  

**Key Facts**  
- Storage account types include: General Purpose v1, General Purpose v2, Blob Storage, Block Blob Storage, and File Storage.  
- The Azure portal UI uses "account kind" instead of "storage type."  
- Supported services vary by storage account type (e.g., containers, queues, tables).  
- Performance tiers available are Standard and Premium.  
- Deployment model is mostly Resource Manager except for General Purpose v1 which supports Classic.  

**Examples**  
- None explicitly mentioned beyond listing storage account types and their features.  

**Key Takeaways 🎯**  
- Remember that "account kind" in the UI corresponds to "storage type."  
- Know the main storage account types and that each supports different services and pricing.  
- Understand the difference between performance tiers (Standard vs Premium) and access tiers (frequency of access).  
- Replication options affect data durability and availability.  
- Deployment model is almost always Resource Manager except for General Purpose v1 which can use Classic.  
- Focus on these distinctions as they often appear in exam questions about Azure Storage Accounts.

---

### Storage Comparison

**Timestamp**: 02:33:48 – 02:35:49

**Key Concepts**  
- Different storage types have varying features based on version and type.  
- Deployment models mainly use Resource Manager, except for Storage version 1 which supports Classic deployment.  
- Replication options are most extensive in Storage version 2.  
- Access tiers (hot, cool, archive) are only available in General Purpose v2 and Blob storage.  
- Performance tiers include Standard and Premium; Premium is used for file storage and block blob storage, Standard for legacy blob storage.  
- Blob storage has three types with some differences in support and use cases.  
- File storage supports only file types, while General Purpose v2 supports all storage types.  

**Definitions**  
- **Deployment Model**: The method by which storage services are deployed; either Classic or Resource Manager (modern standard).  
- **Replication**: The process of creating redundant copies of data to ensure durability and availability.  
- **Access Tiers**: Levels of data accessibility and cost optimization (e.g., hot, cool, archive) available for certain storage types.  
- **Performance Tiers**: Storage speed and cost options, mainly Standard and Premium.  

**Key Facts**  
- Only Storage version 1 supports the Classic deployment model; all others use Resource Manager.  
- Storage version 2 offers the most replication options.  
- Access tiers are exclusive to General Purpose v2 and Blob storage.  
- File storage and block blob storage typically use Premium performance tier.  
- Legacy Blob storage uses Standard performance tier.  
- General Purpose v2 is the most versatile storage type supporting all features.  

**Examples**  
- File storage is always premium and supports only file types.  
- Blob storage comes in three types, with some supporting page blobs (though details are not emphasized).  

**Key Takeaways 🎯**  
- Focus on General Purpose v2 storage for the broadest feature set and flexibility.  
- Remember that replication options and access tiers are primarily a feature of Storage version 2.  
- Deployment model differences are mostly behind the scenes; practically, Resource Manager is the default.  
- Know that performance tiers affect cost and speed, with Premium used for file and block blob storage.  
- Understanding which storage types support access tiers can help optimize cost and performance.  

---

### Core Storage Services

**Timestamp**: 02:35:49 – 02:37:43

**Key Concepts**  
- Azure provides five core storage services under storage accounts.  
- Different storage services serve different purposes: object storage, file sharing, messaging, and block storage.  
- Storage accounts are used to launch most storage services except Azure Disks, which are launched separately.  

**Definitions**  
- **Azure Blob Storage**: A massively scalable object store for text and binary data; supports big data analytics via Data Lake Storage Gen2. Files are treated as objects without needing to manage a file system.  
- **Azure Files**: A managed file share service that allows multiple virtual machines to share the same file system and files.  
- **Azure Queues**: A NoSQL store for schema-less structured data, used for messaging between application components (categorized under storage but functions as messaging).  
- **Azure Disk Storage**: Block-level storage volumes specifically for Azure Virtual Machines (VMs). Disks are launched separately from storage accounts.  

**Key Facts**  
- Azure Blob Storage supports big data analytics through Data Lake Storage Gen2.  
- Azure Files enables shared file systems across multiple VMs.  
- Azure Queues provide reliable messaging but are categorized under storage accounts.  
- Azure Disks are block-level storage volumes for VMs and are managed separately from the other four core storage services.  
- Some storage accounts (like general-purpose v2) may be involved in disk backup or storage, but disks themselves are launched independently.  

**Examples**  
- Using Azure Files to share the same file system among multiple virtual machines.  
- Azure Blob Storage for uploading files as objects without managing file systems.  

**Key Takeaways 🎯**  
- Remember the five core storage services: Blob, Files, Queues, (Messaging), and Disks.  
- Blob storage is ideal for scalable object storage and big data analytics.  
- Azure Files is best when multiple VMs need shared access to the same files.  
- Azure Queues, though under storage accounts, function as a messaging service for application components.  
- Azure Disks are block storage volumes for VMs and are managed separately from storage accounts.  
- For exam purposes, know the purpose and basic use case of each core storage service.

---

### Performance Tiers

**Timestamp**: 02:37:43 – 02:39:51

**Key Concepts**  
- Performance tiers apply primarily to Azure Blob storage accounts.  
- Two main performance tiers: **Standard** and **Premium**.  
- Performance is measured in IOPS (Input/Output Operations Per Second).  
- Premium tier uses SSDs (Solid-State Drives) optimized for low latency and higher throughput.  
- Standard tier uses HDDs (Hard Disk Drives) with varied performance depending on access tier.

**Definitions**  
- **IOPS (Input/Output Operations Per Second)**: A measure of how many read/write operations a storage device can perform per second; higher IOPS means faster performance.  
- **Premium Performance Tier**: Storage backed by SSDs, offering higher IOPS, low latency, and higher throughput.  
- **Standard Performance Tier**: Storage backed by HDDs, with performance varying by access tier (hot, cool, archive).

**Key Facts**  
- Premium tier SSDs have no moving parts, enabling faster random read/write operations.  
- Standard tier HDDs have moving parts (an ARM) and perform best with sequential read/write operations.  
- SSDs are suited for interactive workloads, analytics, AI/ML, and data transformation.  
- HDDs are suited for backup, disaster recovery, media content, and bulk data processing.  
- Neither SSD nor HDD is inherently better; choice depends on workload needs and cost considerations.

**Examples**  
- Premium SSDs used for AI/ML workloads and interactive analytics.  
- Standard HDDs used for backup and disaster recovery scenarios.

**Key Takeaways 🎯**  
- Remember the two performance tiers: Standard (HDD) vs. Premium (SSD).  
- Higher IOPS = better performance; premium tier provides this via SSDs.  
- Choose performance tier based on workload type and cost: SSDs for speed-critical tasks, HDDs for cost-effective bulk storage.  
- Understand that HDDs excel at sequential data access, SSDs excel at random access with low latency.  
- Performance tier selection impacts latency, throughput, and cost—know these trade-offs for exam scenarios.

---

### Access Tiers

**Timestamp**: 02:39:51 – 02:43:37

**Key Concepts**  
- Azure Storage offers three access tiers for standard storage: Hot, Cool, and Archive.  
- Access tiers help optimize storage costs based on how frequently data is accessed.  
- Tiering can be applied at the storage account level or at the individual BLOB level.  
- Moving data between tiers can incur different costs and sometimes delays (rehydration).  
- Lifecycle management policies can automate moving data between tiers based on rules.

**Definitions**  
- **Hot Tier**: For data accessed frequently; highest storage cost but lowest access cost. Suitable for active data or data staged for processing.  
- **Cool Tier**: For infrequently accessed data stored for at least 30 days; lower storage cost than Hot but higher access cost. Used for short-term backup, disaster recovery, or older media content.  
- **Archive Tier**: For rarely accessed data stored for at least 180 days; lowest storage cost but highest access cost. Intended for long-term backup, archival, compliance data, or original raw data preservation.  
- **Rehydration**: The process of moving a BLOB out of the Archive tier to a hotter tier, which can take several hours.  
- **BLOB Lifecycle Management**: Rule-based policies to automatically transition BLOBs between tiers or delete them based on age or other criteria.

**Key Facts**  
- Cool tier requires data to be stored for a minimum of 30 days.  
- Archive tier requires data to be stored for a minimum of 180 days.  
- Not all replication types support the Archive tier; configuration may affect tier availability.  
- Changing tiers is instant except when moving out of Archive (rehydration delay).  
- When moving a BLOB to a cooler tier, the operation is billed as a write operation at the destination tier rates.  
- When moving a BLOB to a hotter tier, the operation is billed as a read operation at the source tier rates.  
- Early deletion charges apply if data is moved out of Cool or Archive tiers before the minimum storage duration (30 days for Cool, 180 days for Archive). Charges are prorated.  
- If a BLOB does not have an explicitly assigned tier, it inherits the tier from the storage account’s default access tier.

**Examples**  
- Cool tier use cases: short-term backup, disaster recovery data sets, older media content not frequently viewed but expected to be available immediately, large data sets stored cost-effectively while gathering more data.  
- Archive tier use cases: long-term backup, secondary backup, archival data sets, original raw data preservation, compliance data rarely accessed.

**Key Takeaways 🎯**  
- Remember the minimum storage durations: 30 days for Cool, 180 days for Archive to avoid early deletion charges.  
- Understand cost implications: Hot tier has highest storage cost but lowest access cost; Archive has lowest storage cost but highest access cost.  
- Know that rehydration from Archive can take hours—plan accordingly for data retrieval.  
- Use lifecycle management policies to automate cost optimization by moving data between tiers based on usage patterns.  
- Be aware that some replication settings may disable the Archive tier option.  
- Tier changes are immediate except for Archive to other tiers, which require rehydration.  
- Charges for tier changes depend on the direction of the move (write vs read operations).

---

### Replication Data Redundancy

**Timestamp**: 02:43:37 – 02:45:30

**Key Concepts**  
- Replication is used to create multiple copies of data to protect against outages, hardware failures, network/power issues, and natural disasters.  
- Different replication types offer varying levels of redundancy and cost.  
- Replication types are categorized into three main groups based on redundancy scope and access:  
  1. Primary region redundancy  
  2. Secondary region redundancy  
  3. Secondary region redundancy with read access  

**Definitions**  
- **Replication**: The process of copying data multiple times across different locations or zones to ensure durability and availability.  
- **Local Redundant Storage (LRS)**: Replicates data synchronously three times within a single primary region; most cost-effective.  
- **Zone Redundant Storage (ZRS)**: Replicates data across multiple availability zones within the primary region.  
- **Geo-Redundant Storage (GRS)**: Replicates data to a secondary geographic region for higher redundancy.  
- **Geo-Zone Redundant Storage (GZRS)**: Combines geo-redundancy with zone redundancy.  
- **Read Access Geo-Redundant Storage (RAGRS)**: Provides read access to the secondary region’s replicated data.  
- **Read Access Geo-Zone Redundant Storage (RAGZRS)**: Read access with geo-zone redundancy.

**Key Facts**  
- LRS and ZRS fall under primary region redundancy.  
- GRS and GZRS fall under secondary region redundancy.  
- RAGRS and RAGZRS provide read access to replicated data in the secondary region.  
- LRS is typically used for development accounts due to its cost-effectiveness.  
- Data in primary region redundancy is replicated at least three times within the primary region.  
- LRS uses synchronous replication within the region.

**Examples**  
- Using LRS for development accounts as a cost-effective replication choice.  
- No other specific practical examples mentioned.

**Key Takeaways 🎯**  
- Understand the three categories of replication redundancy and their use cases.  
- Remember the acronyms and what they stand for, focusing on LRS, ZRS, GRS, GZRS, RAGRS, and RAGZRS.  
- Know that higher redundancy levels come with higher costs.  
- LRS replicates data three times synchronously within the primary region and is the most cost-effective option.  
- Secondary region redundancy options provide disaster recovery across geographic regions.  
- Read access redundancy options allow reading from the secondary region replica, useful for read-heavy workloads or failover scenarios.

---

### LRS ZRS

**Timestamp**: 02:45:30 – 02:47:01

**Key Concepts**  
- Primary region redundancy options for Azure Storage replication  
- Differences between LRS (Locally Redundant Storage) and ZRS (Zone-Redundant Storage)  
- Synchronous replication within the primary region  
- Durability levels associated with LRS and ZRS  
- Impact of availability zone failures on data availability  

**Definitions**  
- **LRS (Locally Redundant Storage)**: Replicates data synchronously three times within a single availability zone in the primary region.  
- **ZRS (Zone-Redundant Storage)**: Replicates data synchronously across three different availability zones within the primary region.  

**Key Facts**  
- LRS uses synchronous replication to maintain three copies of data within one availability zone.  
- ZRS uses synchronous replication to maintain three copies of data across three separate availability zones.  
- Durability for LRS is 11 nines (99.999999999%).  
- Durability for ZRS is 12 nines (99.9999999999%), making it more durable than LRS.  
- LRS is the cheapest storage option and suitable for developer accounts or scenarios where replication is not critical.  
- ZRS provides higher availability by protecting against an entire availability zone failure within the primary region.  
- If an availability zone fails, data in LRS is lost; in ZRS, data remains available in other zones.  

**Examples**  
- Choosing LRS for developer accounts where replication durability is less critical.  
- Choosing ZRS when you need higher durability and protection against availability zone outages.  

**Key Takeaways 🎯**  
- Remember that both LRS and ZRS replicate data synchronously within the primary region but differ in the scope of replication (single zone vs multiple zones).  
- ZRS offers better durability and availability than LRS by spanning multiple availability zones.  
- LRS is the most cost-effective option but has lower fault tolerance.  
- Understand the difference in durability levels (11 nines vs 12 nines) as a measure of reliability.  
- For exam scenarios involving availability zone failures, ZRS is the preferred choice over LRS.

---

### GRS GZRS

**Timestamp**: 02:47:01 – 02:49:02

**Key Concepts**  
- Secondary region redundancy protects against regional disasters by replicating data to a paired secondary region.  
- Secondary regions are paired automatically; users cannot choose the pair.  
- Secondary regions are normally on standby and not available for read/write access except during failover.  
- GRS (Geo-Redundant Storage) and GZRS (Geo-Zone-Redundant Storage) combine synchronous replication within the primary region and asynchronous replication to the secondary region.  
- Synchronous replication guarantees data consistency within the primary region.  
- Asynchronous replication to the secondary region means data may not be fully up-to-date or consistent at any given moment.  
- GZRS adds zone-redundancy within the primary region by replicating data asynchronously across three availability zones before geo-replication.  
- Durability for GRS is extremely high (16 nines).  
- Read-access geo-redundant options (RAGRS, RAGZRS) provide synchronous replication to the secondary region to enable consistent read replicas.

**Definitions**  
- **Secondary Region Redundancy**: Replication of data to a geographically paired region to protect against regional outages or disasters.  
- **Paired Region**: A fixed secondary region automatically assigned to a primary region for geo-replication purposes.  
- **Synchronous Replication**: Data is copied in real-time ensuring consistency and durability guarantees.  
- **Asynchronous Replication**: Data is copied with a delay, so the secondary copy may lag behind the primary.  
- **GRS (Geo-Redundant Storage)**: Storage replication strategy that synchronously replicates data within the primary region and asynchronously replicates to a paired secondary region.  
- **GZRS (Geo-Zone-Redundant Storage)**: Similar to GRS but adds asynchronous replication across three availability zones within the primary region before geo-replication.  
- **RAGRS / RAGZRS**: Read-access geo-redundant storage options that provide synchronous replication to the secondary region, enabling read access to the secondary copy.

**Key Facts**  
- Secondary regions are not available for read/write access unless failover occurs (except for RAGRS/RAGZRS).  
- GRS durability is 16 nines (99.99999999999999%).  
- Data in the secondary region is asynchronously copied, so it may not be fully up-to-date.  
- GZRS replicates data asynchronously across 3 availability zones in the primary region before geo-replication.  
- The secondary region in GZRS may not replicate data across multiple AZs (based on the graphic referenced).  
- RAGRS and RAGZRS provide synchronous replication to the secondary region to ensure data consistency for read replicas.

**Examples**  
- None explicitly mentioned beyond conceptual descriptions of replication behavior.

**Key Takeaways 🎯**  
- Understand the difference between synchronous (within primary region) and asynchronous (to secondary region) replication in GRS and GZRS.  
- Remember that secondary regions are paired and cannot be chosen by the user.  
- Know that GRS/GZRS provide geo-redundancy but secondary copies are not readable unless failover occurs.  
- RAGRS/RAGZRS enable read access to the secondary region by using synchronous replication across regions.  
- GZRS adds zone redundancy within the primary region, improving durability before geo-replication.  
- Durability of GRS is extremely high (16 nines), making it suitable for critical data requiring geo-redundancy.

---

### RAGRS_RA GZRS

**Timestamp**: 02:49:02 – 02:49:44

**Key Concepts**  
- Redundancy in the secondary region with read access  
- Read-access geo-redundant storage (RAGRS) and read-access geo-zone-redundant storage (RAGZRS)  
- Synchronous data replication between primary and secondary regions for read replicas  
- Ensuring data consistency (one-to-one sync) between primary and secondary regions for read operations  

**Definitions**  
- **RAGRS / RAGZRS**: Storage options that provide read access to a secondary region with synchronous data replication to maintain data consistency between primary and secondary regions.  

**Key Facts**  
- Data is synchronous in both primary and secondary regions when using RAGRS or RAGZRS  
- The purpose of these options is to enable a read replica in another region with data in sync  
- This differs from asynchronous replication where data may lag or be out of sync  

**Examples**  
- None mentioned explicitly, but the concept described is having a read replica in a secondary region with synchronous data replication  

**Key Takeaways 🎯**  
- Remember that RAGRS and RAGZRS provide synchronous replication to the secondary region to support read replicas  
- Synchronous replication ensures data consistency for read operations across regions  
- This is critical when you want to read from a geographically distant region without risking stale data  
- Understand the difference between asynchronous replication (used in other redundancy options) and synchronous replication in RAGRS/RAGZRS  

---

### Intro to Blob

**Timestamp**: 02:49:44 – 02:50:51

**Key Concepts**  
- Azure Blob Storage is an object store optimized for massive amounts of unstructured data.  
- Unstructured data refers to data without a specific data model or schema, such as text or binary data.  
- Azure Blob Storage hierarchy includes Storage Account → Containers → Blobs.  
- Storage accounts provide a fully qualified domain name (FQDN) for global access.  
- Containers in Blob Storage act like folders to organize blobs.  
- There are three types of blobs: block blobs, append blobs, and (implicitly) page blobs (not mentioned here).  

**Definitions**  
- **Blob Storage**: A service optimized for storing large amounts of unstructured data like text or binary.  
- **Storage Account**: The top-level namespace for Azure storage, providing a unique FQDN for access.  
- **Container**: A logical grouping within a storage account that organizes blobs, similar to folders.  
- **Block Blob**: The primary blob type used to store text and binary data, composed of individually manageable blocks.  
- **Append Blob**: Blob type optimized for append operations, ideal for scenarios like logging where data is added sequentially.  

**Key Facts**  
- Storage accounts have a unique name treated like a domain name to ensure global uniqueness.  
- Block blobs can store up to 4.7 terabytes of data.  
- Append blobs are efficient for appending data, such as virtual machine logs.  

**Examples**  
- Append blobs are used for writing logs from a virtual machine, as they efficiently append data to the end of the file.  

**Key Takeaways 🎯**  
- Remember that Azure Blob Storage is designed for unstructured data and is organized hierarchically: Storage Account → Containers → Blobs.  
- Storage account names must be globally unique because they form part of the URL (FQDN).  
- Block blobs are the most common blob type for storing large text or binary files.  
- Use append blobs specifically when you need to add data sequentially, such as logging scenarios.  
- Understand the difference between containers (folders) and blobs (actual data objects) in Azure Blob Storage.

---

### Blob Types

**Timestamp**: 02:50:51 – 02:51:45

**Key Concepts**  
- Azure Blob Storage organizes data into containers (similar to folders).  
- There are three main types of blobs used to store different kinds of data and optimized for different scenarios.

**Definitions**  
- **Block Blobs**: Store text and binary data as blocks that can be managed individually.  
- **Append Blobs**: Optimized for append operations, ideal for scenarios like logging where data is continuously added to the end.  
- **Page Blobs**: Store random access files, primarily used for virtual hard drives (VHDs) and serve as disks for Azure Virtual Machines.

**Key Facts**  
- Block blobs can store up to 4.7 terabytes of data.  
- Append blobs are efficient for appending data, such as VM logs.  
- Page blobs can store up to 8 terabytes and are used for VHD files.

**Examples**  
- Append blobs are used for writing logs from virtual machines efficiently by appending data to the end of the file.  
- Page blobs are used to store virtual hard drives (VHD files) that serve as disks for Azure VMs.

**Key Takeaways 🎯**  
- Remember the three blob types and their primary use cases:  
  - Block blobs for general text/binary storage.  
  - Append blobs for append-only scenarios like logging.  
  - Page blobs for random access files and VM disks.  
- Know the size limits: 4.7 TB for block blobs, 8 TB for page blobs.  
- Understanding blob types is essential for choosing the right storage solution in Azure.

---

### Blob Moving Data

**Timestamp**: 02:51:45 – 02:52:50

**Key Concepts**  
- Multiple methods exist to move data into Azure Blob Storage beyond just the portal or File Explorer.  
- Command-line tools, libraries, ETL services, virtual file system drivers, and physical data transport options are available.  

**Definitions**  
- **AzCopy**: A command-line tool for Windows and Linux used to efficiently move data to Azure Storage.  
- **Azure Storage Data Movement Library**: A .NET library that uses AzCopy under the hood to facilitate data transfer programmatically.  
- **Azure Data Factory**: An ETL (Extract, Transform, Load) service by Azure designed to move and transform data into Azure.  
- **Blob Fuse**: A virtual file system driver that allows Linux systems to mount Azure Blob Storage as a file system using the FUSE library.  
- **Azure Data Box**: A rugged physical device used to securely transport large amounts of data physically to Azure.  
- **Azure Import Export Service**: A service where customers ship their physical disks to Azure for data import/export operations.  

**Key Facts**  
- AzCopy supports both Windows and Linux platforms.  
- Blob Fuse leverages the Linux FUSE library to enable file system access to Blob Storage.  
- Azure Data Box and Azure Import Export Service are physical data transfer solutions, useful when network transfer is impractical or too slow.  

**Examples**  
- None specifically mentioned in this segment, but AzCopy is highlighted as a practical command-line tool for data movement.  

**Key Takeaways 🎯**  
- Know the variety of tools and services available for moving data into Azure Blob Storage, including command-line, programmatic, ETL, virtual file system, and physical transport options.  
- AzCopy is a fundamental tool to be familiar with for exam purposes.  
- Understand the difference between virtual (AzCopy, Data Factory, Blob Fuse) and physical (Data Box, Import Export Service) data transfer methods.  
- Remember Blob Fuse is Linux-specific and uses the FUSE library to mount Blob Storage as a file system.

---

### Intro to Files

**Timestamp**: 02:52:50 – 02:54:05

**Key Concepts**  
- Azure Files is a fully managed file share service in the cloud.  
- It acts like a centralized file server allowing multiple virtual machines to connect and share data simultaneously.  
- Uses network protocols to facilitate communication: Server Message Block (SMB) and Network File System (NFS).  
- Mounting is the process of connecting the Azure file share to a specific directory or drive letter on a client machine.  

**Definitions**  
- **Azure Files**: A cloud-based fully managed file share service that provides a shared drive accessible by multiple clients at the same time.  
- **Mounting**: The process of making a remote file share accessible locally by assigning it to a folder or drive letter (e.g., Z: drive on Windows).  
- **Server Message Block (SMB)**: A network protocol created by Microsoft used for file sharing, commonly used on Windows systems.  
- **Network File System (NFS)**: A network protocol commonly used on Linux or Unix-based systems for file sharing.  

**Key Facts**  
- Azure Files supports multiple simultaneous connections from virtual machines.  
- On Windows, Azure Files can be mounted to drive letters such as Z:, X:, or Y:.  
- SMB is primarily used on Windows clients; NFS is commonly used on Linux/Unix clients.  

**Examples**  
- Mounting Azure Files as a Z: drive on a Windows server so that accessing Z: uses the Azure file share.  

**Key Takeaways 🎯**  
- Remember Azure Files acts like a shared network drive in the cloud accessible by multiple VMs.  
- Know the two main protocols: SMB (Windows) and NFS (Linux/Unix).  
- Understand the concept of mounting and how it maps a remote file share to a local drive or folder.  
- Azure Files can replace or supplement on-premises file servers and NAS devices, making it important for cloud migrations and hybrid scenarios.

---

### Files Use Cases

**Timestamp**: 02:54:05 – 02:57:31

**Key Concepts**  
- Azure Files can replace or supplement on-premises file servers and NAS devices.  
- Lift and Shift migration strategies: classic lift and hybrid lift.  
- Shared storage simplifies cloud deployments by centralizing configuration files and logs.  
- Azure Files supports containerized applications by providing persistent storage volumes.  
- Azure Files is fully managed, scalable, resilient, and supports standard file protocols out-of-the-box.  
- Automation and scripting support via Azure API and PowerShell.  
- Backup capabilities with incremental shared snapshots and soft delete to prevent accidental data loss.

**Definitions**  
- **Lift and Shift**: Moving workloads to the cloud without re-architecting them.  
- **Classic Lift**: Moving both the application and its data fully to Azure.  
- **Hybrid Lift**: Moving only the application data to Azure Files while the application runs on-premises.  
- **Mounting**: Assigning a drive letter (e.g., Z:) on Windows to access Azure Files as a network share.  
- **Shared Snapshots**: Read-only, incremental backups of file shares that store only changed data.  
- **Soft Delete**: A feature to prevent accidental deletion of file shares and backups by retaining deleted data temporarily.

**Key Facts**  
- Azure Files can be mounted as drive letters on Windows (e.g., Z:).  
- Lift and shift allows moving VMs and data to Azure without changes.  
- Shared logs and configuration files can be centralized for multiple VMs via Azure Files.  
- Containers are stateless by default; Azure Files provides persistent volume storage.  
- Azure Files is fully managed, automatically patched, and scalable.  
- Up to 200 snapshots per file share are supported.  
- Snapshots are incremental, storing only changed data (e.g., adding 1 MB only stores 1 MB extra).  
- Backup retention can be up to 10 years.  
- Backups are stored within the file share; deleting the share deletes backups unless soft delete is enabled.

**Examples**  
- Using Azure Files as a replacement for on-premises NAS devices.  
- Classic lift: moving both app and data to Azure.  
- Hybrid lift: app stays on-premises, data moves to Azure Files.  
- Sharing application settings/configuration files across multiple VMs by mounting the same Azure Files share.  
- Centralizing diagnostic logs from multiple VMs for developer debugging.  
- Sharing development tools quickly by placing them on Azure Files for easy mounting.  
- Persisting container volumes using Azure Files.

**Key Takeaways 🎯**  
- Understand the difference between classic lift and hybrid lift migration strategies.  
- Remember Azure Files can replace on-premises file servers and simplify shared storage needs.  
- Azure Files supports standard SMB/NFS protocols and is fully managed, reducing operational overhead.  
- Backup with incremental snapshots is efficient and supports long retention (up to 10 years).  
- Soft delete is critical to prevent accidental data loss of file shares and backups.  
- Azure Files is ideal for scenarios requiring shared access across multiple VMs or containers.  
- Automation via Azure API and PowerShell enhances management and scalability.

---

### Files Feature

**Timestamp**: 02:57:31 – 03:01:21

**Key Concepts**  
- Azure Files supports backups via shared snapshots that are read-only and incremental.  
- Snapshots store only changed data, optimizing storage space.  
- Soft delete protects against accidental deletion by retaining deleted shares for a retention period before permanent deletion.  
- Advanced Threat Protection (ATP) adds security intelligence to detect anomalous activity on storage accounts.  
- Azure Files offers multiple storage tiers optimized for different workloads and cost/performance needs.  
- Identity options for Azure Files include Azure AD Domain Services (managed or on-premises) and storage account keys.  
- Azure Files can be accessed inside and outside the Azure environment via storage account public endpoints.  
- SMB protocol uses port 445 for mounting Azure file shares.  
- Encryption at rest uses Azure Storage Service Encryption (SSE). Encryption in transit uses SMB 3.0 encryption or HTTPS.  
- Azure File Sync enables caching of Azure file shares on on-premises Windows Servers or Azure VMs, allowing local access with protocols like SMB, NFS, FTP.  

**Definitions**  
- **Shared Snapshots**: Read-only, incremental backups of Azure file shares that capture only changed data since the last snapshot.  
- **Soft Delete**: A feature that retains deleted file shares for a configurable retention period to prevent accidental permanent deletion.  
- **Advanced Threat Protection (ATP)**: Security feature providing alerts on anomalous activities detected in storage accounts.  
- **Storage Tiers**: Different performance and cost options for Azure Files, including Premium (SSD), Transaction Optimized (HDD), Hot, and Cool tiers.  
- **Azure File Sync**: A service that caches Azure file shares on local Windows Servers or VMs, enabling local protocol access and multi-site sync.  

**Key Facts**  
- Up to 200 snapshots per file share are supported.  
- Backups (snapshots) can be retained for up to 10 years.  
- Snapshots only store incremental changes (e.g., adding 1 MB to a 100 GB share adds only 1 MB to the snapshot).  
- Premium tier uses SSD with single-digit millisecond latency and high IOPS.  
- Transaction Optimized tier uses HDD, suitable for transaction-heavy workloads without premium latency needs.  
- Hot tier is optimized for general-purpose file sharing and Azure File Sync scenarios.  
- Cool tier is HDD-based, cost-effective for online archiving.  
- SMB protocol requires port 445 to be open for mounting file shares.  
- Encryption at rest uses Azure Storage Service Encryption (SSE).  
- Encryption in transit uses SMB 3.0 encryption or HTTPS.  

**Examples**  
- Incremental snapshot example: A 100 GB file share with 1 MB added results in a snapshot storing only that 1 MB change.  
- Azure File Sync acts like a OneDrive for file shares, caching files locally and syncing with the cloud, allowing access via SMB, NFS, or FTP protocols.  

**Key Takeaways 🎯**  
- Understand the incremental nature of Azure Files snapshots and their storage efficiency.  
- Remember soft delete is crucial to prevent accidental data loss in Azure Files.  
- Know the different storage tiers and their appropriate use cases (Premium = SSD/low latency, Transaction Optimized = HDD, Hot = general purpose, Cool = archival).  
- Be aware of identity options for accessing Azure Files, especially Azure AD Domain Services integration.  
- SMB port 445 must be open for mounting Azure file shares—important for networking considerations.  
- Encryption is enabled both at rest and in transit, ensuring data security.  
- Azure File Sync enables hybrid scenarios with local caching and multi-protocol access, useful for on-premises integration.  
- ATP is an additional security layer but less critical for foundational certification levels.

---

### File Sync

**Timestamp**: 03:01:21 – 03:02:21

**Key Concepts**  
- Azure File Sync allows caching of Azure file shares on on-premises Windows Servers or cloud VMs.  
- Enables local access to cloud files using native Windows Server protocols (SMB, NFS, FTP).  
- Supports multiple cache locations globally to keep files synchronized.  
- Files can be referenced locally without needing to store all files physically on the local server.  

**Definitions**  
- **Azure File Sync**: A service that synchronizes Azure file shares with on-premises Windows Servers or cloud VMs, enabling local caching and access to cloud files using standard file protocols.  

**Key Facts**  
- Supports protocols: SMB, NFS, FTP on Windows Server for local access.  
- Multiple caches can be deployed worldwide to keep data in sync.  
- Files are accessed on-demand, reducing local storage requirements.  

**Examples**  
- Described as similar to OneDrive for file shares, where files are kept in sync between cloud and local caches.  

**Key Takeaways 🎯**  
- Remember Azure File Sync is ideal for hybrid environments needing local access to cloud files with familiar protocols.  
- It reduces local storage needs by caching files and accessing others on-demand.  
- Supports multiple cache servers globally for distributed access and synchronization.  
- Think of it as cloud file storage with local caching and syncing capabilities, similar in concept to OneDrive but for file shares.  

---

### Storage Explorer

**Timestamp**: 03:02:21 – 03:02:55

**Key Concepts**  
- Azure Storage Explorer is a standalone application for managing Azure Storage data.  
- It supports multiple operating systems: Windows, Mac OS, and Linux.  
- Provides a graphical interface to access subscriptions, storage accounts, disks, and storage data.  
- Allows operations such as uploading, downloading, opening, cloning, and creating storage items.  
- Simplifies working with Azure Storage by providing easy and convenient access.

**Definitions**  
- **Azure Storage Explorer**: A cross-platform standalone app that enables users to easily manage and interact with Azure Storage resources and data.

**Key Facts**  
- Available on Windows, Mac OS, and Linux.  
- Interface includes navigation for subscriptions, storage accounts, and disks on the left-hand side.  
- Supports file operations like upload and download directly within the app.

**Examples**  
- Running Azure Storage Explorer on a Mac with visible subscriptions and storage accounts on the left panel.  
- Using options to upload files, download files, open, clone, and create storage items.

**Key Takeaways 🎯**  
- Know that Azure Storage Explorer is a GUI tool for managing Azure Storage across platforms.  
- Remember it supports multiple file operations and provides easy access to storage accounts and data.  
- Useful for exam scenarios involving managing Azure Storage resources without using the portal or CLI.  
- Familiarity with its cross-platform availability and basic functionality can help in practical and exam contexts.

---

### AZCopy

**Timestamp**: 03:02:55 – 03:04:42

**Key Concepts**  
- AZCopy is a command-line utility used to copy blobs or files to and from Azure Storage accounts.  
- It supports Windows, Linux, and Mac OS platforms.  
- Proper authorization is required to use AZCopy, based on user roles.  
- Authentication can be done via Azure Active Directory or Shared Access Signature (SAS).  
- The basic usage involves logging in, then using the `azcopy copy` command with source and destination paths.

**Definitions**  
- **AZCopy**: A command-line tool for transferring data to and from Azure Blob Storage or file storage.  
- **Storage Blob Data Reader**: Role needed for downloading blobs.  
- **Storage Blob Data Contributor**: Role needed for uploading blobs.  
- **Storage Blob Data Owner**: Role with full permissions over blobs.  
- **Azure Active Directory (AAD)**: Microsoft's cloud-based identity and access management service used for authentication.  
- **Shared Access Signature (SAS)**: A URI that grants restricted access rights to Azure Storage resources.

**Key Facts**  
- AZCopy executable is available for Windows, Linux, and Mac OS.  
- Required roles for AZCopy operations:  
  - Download: Storage Blob Data Reader  
  - Upload: Storage Blob Data Contributor or Storage Blob Data Owner  
- Authentication via `azcopy login` opens a web browser for AAD sign-in and requires entering a displayed code.  
- Copy command syntax: `azcopy copy [source] [destination]`  
- To download files, reverse the source and destination in the command.

**Examples**  
- Logging in: `azcopy login` → opens browser for Azure AD authentication.  
- Upload example: `azcopy copy <local-file-path> <storage-account-endpoint>/<container>/<path>`  
- Download example: `azcopy copy <storage-account-endpoint>/<container>/<file> <local-path>`

**Key Takeaways 🎯**  
- Ensure you have the correct Azure role assigned before using AZCopy (Reader for downloads, Contributor/Owner for uploads).  
- Use `azcopy login` to authenticate via Azure Active Directory before performing operations.  
- Remember the command structure: `azcopy copy [source] [destination]` and reverse it for downloads.  
- AZCopy is a powerful tool for efficient data transfer to/from Azure Storage and supports all major OS platforms.  
- Be aware of authentication options: Azure AD or SAS tokens depending on your scenario.

---

### Import Export Service

**Timestamp**: 03:04:42 – 03:07:10

**Key Concepts**  
- Azure Import Export Service is used to move large amounts of data to Azure Blob Storage and Azure Files by physically shipping disk drives to Azure data centers.  
- Two options for drives: use your own disk drives or Microsoft-provided Azure Data Box Disks (SSD drives).  
- Data is copied locally to the drives, encrypted, and then shipped to Azure.  
- Preparation of drives is done using the WA Import Export Tool (command line).  
- There are two versions of WA Import Export Tool:  
  - Version 1 for Azure Blob Storage  
  - Version 2 for Azure Files  
- Export jobs are only supported for Azure Blob Storage, not Azure Files.  

**Definitions**  
- **Azure Import Export Service**: A service that enables transferring large data sets to Azure by shipping physical disk drives to Azure data centers.  
- **Azure Data Box Disks**: Microsoft-provided solid state drives used for data import/export, shipped in sets of five.  
- **WA Import Export Tool**: A Windows 64-bit command line tool used to prepare drives for import/export, including copying data, encrypting it with AES-256 BitLocker, and generating journal files.  
- **Journal File**: A file generated by the WA Import Export Tool containing metadata such as drive serial numbers, encryption keys, and storage account details, used to create import jobs.  

**Key Facts**  
- Up to 40 terabytes of data can be shipped per import order. For more than 40 TB, multiple orders are required.  
- Drives connect via USB 3.0 for data copying.  
- Encryption uses AES-256 BitLocker (software encryption).  
- WA Import Export Tool is only compatible with Windows 64-bit OS (no Linux or Mac support).  
- Export jobs allow shipping up to 10 empty drives to Azure per job for data export.  
- Export is supported only for Azure Blob Storage, not Azure Files.  

**Examples**  
- Microsoft sends five Azure Data Box Disks (SSD drives) per order for import/export.  
- Data is copied locally to the drives using USB 3.0, encrypted, and then shipped back to Azure.  

**Key Takeaways 🎯**  
- Remember the two versions of WA Import Export Tool and their target storage types (v1 for Blob, v2 for Files).  
- Know the 40 TB per import order limit and the need for multiple orders if exceeding this.  
- Encryption is mandatory and done with AES-256 BitLocker via the tool.  
- Export jobs are limited to Azure Blob Storage only, with a maximum of 10 drives per export job.  
- WA Import Export Tool only runs on Windows 64-bit — no Linux or Mac support.  
- The journal file is critical for creating import jobs and contains essential metadata.  
- Understand the physical shipping process as a method for large data transfer to Azure when network transfer is impractical.

---

### SAS

**Timestamp**: 03:07:10 – 03:10:09

**Key Concepts**  
- Shared Access Signature (SAS) is a URI that grants restricted, temporary access to Azure storage resources.  
- SAS provides a way to authorize access besides using Active Directory.  
- There are different types of SAS depending on the scope and authentication method.  
- SAS tokens can be created as ad hoc or with stored access policies.  
- SAS URIs include query parameters that define permissions, start and expiry times, resource types, and authentication signatures.

**Definitions**  
- **Shared Access Signature (SAS)**: A URI that grants restricted access rights to Azure storage resources for a limited time and with specific permissions.  
- **Account-level SAS**: Grants access to resources across one or more storage services within a storage account.  
- **Service-level SAS**: Grants access to a single storage service using storage account keys.  
- **User Delegated SAS**: Uses Azure AD credentials to access storage accounts, limited to Blob and container resources; considered best practice by Microsoft.  
- **Ad hoc SAS**: SAS token with start time, expiry time, and permissions embedded directly in the URI.  
- **Service SAS with Stored Access Policy**: SAS token linked to a stored access policy defined on a resource container, allowing management of constraints across multiple SAS tokens.

**Key Facts**  
- SAS types: Account-level, Service-level, User Delegated.  
- User Delegated SAS is limited to Blob and container resources only.  
- Stored access policies apply to Blob, container, table, queue, and file share resources (disks are excluded).  
- SAS URI components include:  
  - `sv`: Storage service version  
  - `st`: Start time  
  - `se`: Expiry time  
  - `sr`: Storage resource type (e.g., B for Blob, Q for Queue)  
  - `sp`: Permissions (e.g., read, write)  
  - `sig`: Signature used for authentication (SHA-256)  
- SAS tokens can be easily generated via the Azure Portal under the storage account’s Shared Access Signature section.

**Examples**  
- Example URI structure discussed:  
  - Storage account URL + container + file name + query string parameters (sv, st, se, sr, sp, sig)  
- Generating SAS token: Open Azure Portal → Storage Account → Shared Access Signature → select options → generate URI → use URI for access.

**Key Takeaways 🎯**  
- Understand the different SAS types and when to use each (account, service, user delegated).  
- User Delegated SAS with Azure AD is the recommended best practice for Blob storage access.  
- Know the difference between ad hoc SAS and SAS with stored access policies.  
- Be familiar with the key query parameters in a SAS URI and what they represent.  
- Remember that SAS tokens provide temporary and scoped access, enhancing security over sharing account keys.  
- Practice generating SAS tokens in the Azure Portal as it is straightforward and exam-relevant.

---

### Use AZCopy to copy files to Storage Accounts

**Timestamp**: 03:10:09 – 03:26:14

**Key Concepts**  
- AZCopy is a command-line tool used to efficiently copy files to and from Azure Storage Accounts.  
- You can use AZCopy via Cloud Shell for a consistent cross-platform experience (Linux, Mac, Windows).  
- Authentication with AZCopy can be done using either:  
  - Azure AD login (`azcopy login`)  
  - Shared Access Signature (SAS) tokens appended to URLs  
- Storage accounts contain containers, which hold blobs (files). Containers can be private or public.  
- Proper role assignments are required to upload/download blobs using AZCopy (e.g., Storage Blob Data Owner or Contributor).  
- SAS tokens provide granular, time-limited access to storage resources without sharing account keys.  

**Definitions**  
- **AZCopy**: A command-line utility designed to copy data to/from Azure Storage accounts quickly and securely.  
- **Shared Access Signature (SAS)**: A URI that grants restricted access rights to Azure Storage resources without exposing account keys.  
- **Container**: A logical grouping within a storage account that holds blobs (files).  
- **Blob**: A file stored in Azure Blob Storage.  
- **Storage Blob Data Owner/Contributor**: Azure roles that grant permissions to manage blobs within storage accounts.  

**Key Facts**  
- AZCopy can be downloaded for multiple platforms: Windows, Linux, Mac.  
- When using Cloud Shell, files can be uploaded to the mounted storage share for use with AZCopy.  
- To extract the AZCopy binary from a tarball in Cloud Shell, use: `tar -xvzf <filename>.tar.gz`  
- The AZCopy executable may require execution permissions (`chmod u+x azcopy`).  
- To authenticate with Azure AD via AZCopy, run `azcopy login` and complete the browser sign-in with a provided code.  
- Blob URLs follow the format:  
  `https://<storage-account-name>.blob.core.windows.net/<container-name>/<blob-name>`  
- Role assignments for blob access must be done via Access Control (IAM) in the Azure portal; changes can take ~5 minutes to propagate.  
- SAS tokens start with a question mark (`?`) and are appended to blob/container URLs to grant access.  
- Common SAS permissions include read, write, add, create, and list.  
- SAS tokens can be generated in the Azure portal under the storage account’s Shared Access Signature settings.  
- Sometimes AZCopy in Cloud Shell may have issues with SAS authentication; using a local AZCopy client (e.g., Windows version) can resolve this.  

**Examples**  
- Created a storage account named **Fajo** with a container named **Kivas Fagio** (private access).  
- Uploaded an image file (`Kivas Fagio.jpg`) to the container using AZCopy with Azure AD login authentication.  
- Generated a SAS token with permissions for Blob storage (read, write, add, create) and attempted to upload using SAS appended to the URL.  
- Encountered a 403 error initially due to missing role assignment; resolved by assigning Storage Blob Data Contributor role to the user.  
- Demonstrated troubleshooting steps when SAS upload failed in Cloud Shell but succeeded using Windows AZCopy client.  

**Key Takeaways 🎯**  
- Always ensure you have the correct role assignments (Storage Blob Data Owner or Contributor) to perform blob operations with AZCopy.  
- Use `azcopy login` for Azure AD authentication or SAS tokens appended to URLs for delegated access.  
- Blob URLs must be correctly formatted: `https://<account>.blob.core.windows.net/<container>/<blob>`  
- SAS tokens must start with a question mark (`?`) when appended to URLs.  
- When using Cloud Shell, upload your files and AZCopy binaries to the mounted storage share before running commands.  
- If AZCopy commands fail in Cloud Shell, try using a local AZCopy client as a fallback.  
- Role assignment changes may take several minutes to take effect—be patient before retrying operations.  
- Practice generating SAS tokens with appropriate permissions and understand their scope and expiry.  
- Remember to clean up resources (delete resource groups) after practice to avoid unnecessary charges.

---

### Create a File Share with Files

**Timestamp**: 03:26:14 – 03:37:22

**Key Concepts**  
- Azure File Share is a sub-service within a Storage Account, not a standalone service.  
- File shares can be created under General Purpose v2 or Premium storage accounts.  
- Premium storage accounts can be dedicated to file storage only (FileStorage account kind).  
- Azure Files supports SMB protocol for mounting shares to virtual machines.  
- Mounting Azure File Shares on Linux requires installing `cifs-utils`.  
- Port 445 (TCP) must be opened on the VM’s network security group for SMB communication.  
- Credentials for mounting are stored securely in a file with restricted permissions.  
- Azure File Shares support soft delete (default 7 days) and can be configured for large file shares (up to 100 TB).  
- File operations on the mounted share reflect immediately on the Azure File Share.  

**Definitions**  
- **Azure File Share**: A managed file share service within Azure Storage Accounts that can be mounted via SMB protocol to VMs.  
- **General Purpose v2 Storage Account**: A multi-purpose storage account that supports blobs, files, queues, and tables.  
- **Premium FileStorage Account**: A storage account dedicated solely to file shares, optimized for premium performance.  
- **SMB (Server Message Block)**: A network file sharing protocol used to mount Azure File Shares.  
- **cifs-utils**: A Linux utility package required to mount SMB file shares.  

**Key Facts**  
- Azure Files supports file shares up to 100 terabytes (large file shares feature, disabled by default).  
- Default file share capacity example used: 3 GB (small for demo purposes).  
- VM size chosen for demo: B1LS (cost-effective, approx. $6/month).  
- Linux VM image used: Ubuntu 18.04 LTS, Generation 2.  
- SMB communicates over TCP port 445, which must be explicitly opened in the VM’s network security group.  
- Soft delete for Azure File Shares is enabled by default for 7 days.  
- Mounting requires creating a mount directory and a credentials file with restricted permissions (`chmod 600`).  

**Examples**  
- Created a resource group and storage account named "KeyVoss".  
- Created a file share named "Kivas" with 3 GB quota.  
- Launched an Ubuntu Linux VM named "Kivas" to mount the file share.  
- Opened port 445 on the VM’s network security group for SMB.  
- Installed `cifs-utils` on the Linux VM (`sudo apt update && sudo apt install cifs-utils`).  
- Created directories `/mnt/kivas` and `/etc/smbcredentials` on the VM.  
- Created a credentials file with Azure Storage account username and key, set permissions to 600.  
- Mounted the Azure File Share using the CIFS protocol with the credentials file.  
- Uploaded an image file ("Kivas Faggio") via the Azure Portal upload button to the file share.  
- Verified file presence and demonstrated file operations (move, delete) reflecting immediately on the mounted share.  

**Key Takeaways 🎯**  
- Always create Azure File Shares inside a Storage Account (General Purpose v2 or Premium FileStorage).  
- Remember to open TCP port 445 on the VM’s NSG to allow SMB traffic.  
- On Linux VMs, install `cifs-utils` to enable mounting SMB shares.  
- Use a credentials file with restricted permissions to securely store storage account keys for mounting.  
- Azure File Shares support soft delete and large file shares (up to 100 TB) but large file shares must be enabled explicitly.  
- File operations on the mounted share are immediately reflected in Azure Files and vice versa.  
- For file sync scenarios, Windows VMs are required (Linux mounting is for direct file share access only).  
- Use cost-effective VM sizes (e.g., B1LS) for demo or lab environments.  
- When copying multi-line commands in Cloud Shell or SSH, paste line-by-line to avoid errors.  

---

### Setup Files Sync

**Timestamp**: 03:37:22 – 03:54:31

**Key Concepts**  
- Azure File Sync extends Azure File Shares by enabling synchronization between on-premises Windows Servers (or Azure VMs) and Azure Files in the cloud.  
- Requires a Windows Server VM to install the Azure File Sync Agent (cannot be done from Linux).  
- Setup involves creating a Storage Account, a File Share, a Storage Sync Service, and launching a Windows Server VM.  
- Registration of the Windows Server VM with the Storage Sync Service is necessary via the Azure File Sync Agent.  
- Sync Groups are created to manage synchronization between cloud endpoints (Azure File Shares) and server endpoints (folders on Windows Server).  
- Cloud tiering can be enabled to optimize local disk space by keeping frequently accessed files locally and tiering others to the cloud.  
- Proper cleanup requires deleting server endpoints, cloud endpoints, sync groups, and then the storage sync service before deleting the resource group.

**Definitions**  
- **Azure File Sync**: A service that centralizes file shares in Azure Files while keeping the flexibility, performance, and compatibility of an on-premises file server. It synchronizes files between Windows Servers and Azure File Shares.  
- **Storage Sync Service**: The Azure resource that orchestrates file synchronization between cloud and server endpoints.  
- **Sync Group**: A grouping of cloud endpoints and server endpoints that are kept in sync.  
- **Cloud Endpoint**: The Azure File Share in the cloud that is part of a sync group.  
- **Server Endpoint**: A folder on a registered Windows Server that syncs with the cloud endpoint.  
- **Cloud Tiering**: A feature that preserves a specified percentage of free space on the server volume by tiering infrequently accessed files to Azure Files.

**Key Facts**  
- Windows Server 2019 (Generation 2) was used for the VM in the example.  
- Minimum VM size requires at least 2 vCPUs (e.g., DSV3 or D2 v2).  
- File Share size example: 5 GB (small size sufficient for demo).  
- Ports to open on VM: at least port 3389 (RDP) plus any others needed.  
- Azure File Sync Agent installation requires PowerShell module AzureRM and disabling IE Enhanced Security Configuration temporarily for easier download.  
- Cloud tiering example: preserve 20% free space on the volume.  
- Deletion order for cleanup: delete server endpoints → delete cloud endpoints → delete sync group → delete storage sync service → delete resource group.

**Examples**  
- Creating a Windows Server VM named "Kivas" with Windows Server 2019 for Azure File Sync.  
- Creating a Storage Account and a 5 GB file share named "Kivas".  
- Installing AzureRM PowerShell module and Azure File Sync Agent on the Windows VM.  
- Registering the VM with the Storage Sync Service using Azure File Sync Agent.  
- Creating a folder `C:\kivas` on the VM, adding a test file `hello.txt`, and sharing it.  
- Creating a Sync Group named "Kivas" and adding cloud and server endpoints to sync the folder.  
- Enabling cloud tiering with 20% free space preservation to avoid sync pending issues.

**Key Takeaways 🎯**  
- Azure File Sync requires a Windows Server environment; Linux-only setups cannot use Azure File Sync.  
- Always ensure VM size meets minimum requirements (2 vCPUs minimum).  
- Remember to open RDP port 3389 to connect to the Windows VM.  
- Install AzureRM PowerShell module before installing Azure File Sync Agent.  
- Disable IE Enhanced Security Configuration temporarily to download the Azure File Sync Agent smoothly.  
- Register the Windows Server VM with the Storage Sync Service via the Azure File Sync Agent to enable syncing.  
- Create Sync Groups to manage synchronization between cloud and server endpoints.  
- Enable cloud tiering to prevent sync endpoints from staying in a pending state and to optimize local storage.  
- Proper resource cleanup in Azure requires deleting endpoints before deleting sync groups and services to avoid deletion errors.  
- Be familiar with the Azure portal navigation to find Storage Sync Services (search for "Azure File Sync").  
- Sync errors may occur but verify file presence in Azure File Shares to confirm syncing is working.  
- Exam questions may test knowledge on setup order, components involved, and cleanup procedures for Azure File Sync.

---

### Storage Accounts CheatSheet

**Timestamp**: 03:54:31 – 04:02:22

**Key Concepts**  
- Azure has **five core storage services**:  
  1. Azure Blob  
  2. Azure Files  
  3. Azure Queues  
  4. Azure Tables  
  5. Azure Disks  
- Blob Storage performance tiers: **Standard (HDD)** and **Premium (SSD)**  
- Blob Storage supports **three types of blobs**: Block Blobs, Append Blobs, Page Blobs  
- Blob Storage access tiers (Standard): **Hot**, **Cool**, and **Archive**  
- Blob tiering can be done at **account level** or **blob level**  
- **Rehydration** is required when moving blobs out of Archive tier (can take hours)  
- Blob lifecycle management allows **rule-based automatic tier transitions**  
- Charges apply differently when moving blobs between tiers (read/write operations and data retrieval costs)  
- Early deletion charges apply for blobs moved to Cool (30 days minimum) or Archive (180 days minimum) tiers  
- Multiple tools to move data into Azure Blob Storage: AZCopy, Azure Storage Data Movement Library, Azure Data Factory, Blob Fuse, Azure Databox, Azure Import/Export Service  
- Storage account replication types:  
  - Locally Redundant Storage (LRS)  
  - Zone-Redundant Storage (ZRS)  
  - Geo-Redundant Storage (GRS)  
  - Geo-Zone-Redundant Storage (GZRS)  
  - Read-Access Geo-Redundant Storage (RA-GRS)  
  - Read-Access Geo-Zone-Redundant Storage (RA-GZRS)  
- Azure Files: fully managed cloud file shares accessible via SMB or NFS protocols  
- Azure Files supports **shared snapshots** (read-only, incremental, up to 200 per share, retention up to 10 years)  
- Soft delete for Azure Files prevents accidental deletion by retaining deleted files for a configurable period  
- Azure Files storage tiers: Premium, Transaction Optimized, Hot, Cool (on GPv2 accounts)  
- Azure Files can be accessed inside or outside Azure via public endpoints; SMB uses **port 445** (may require unblocking)  
- Encryption: at rest (Azure Storage Service Encryption) and in transit (SMB 3.0 or HTTPS)  
- Azure File Sync allows caching Azure file shares on on-prem Windows Servers or Cloud VMs  
- Azure Import/Export Service allows secure import/export of large data sets using physical drives (own drives or Microsoft-provided Azure Data Box Disks)  
- WA Import/Export tool is Windows 64-bit only; two versions exist (v1 for blobs, v2 for Azure Files)  
- Shared Access Signatures (SAS) provide restricted, temporary access to storage resources with different types:  
  - Account-level SAS  
  - Service-level SAS  
  - User-delegated SAS (best practice, uses Azure AD credentials, limited to blobs or containers)  
- SAS formats include ad hoc SAS and service SAS with stored access policies  

**Definitions**  
- **Blob Storage**: Object storage for unstructured data, supporting block, append, and page blobs.  
- **Access Tiers (Blob Storage)**: Hot (frequent access), Cool (infrequent access), Archive (rare access, minimum 180 days retention).  
- **Rehydration**: Process of moving blobs from Archive tier back to Hot or Cool, which can take several hours.  
- **Replication Types**: Methods to replicate data for durability and availability across regions or zones.  
- **Azure Files**: Managed file shares in the cloud accessible via SMB or NFS protocols.  
- **Soft Delete**: Feature that retains deleted files for a period to prevent accidental data loss.  
- **Shared Access Signature (SAS)**: URI granting restricted, temporary access to storage resources without sharing account keys.  

**Key Facts**  
- Blob Storage has 3 blob types and 3 access tiers for Standard performance.  
- Archive tier requires data to be stored for at least 180 days; Cool tier has a 30-day minimum retention.  
- Moving blobs out of Archive requires rehydration, which can take hours.  
- Early deletion charges apply if blobs are moved out of Cool or Archive before minimum retention.  
- Azure Files supports up to 200 incremental snapshots per file share, retained up to 10 years.  
- SMB protocol for Azure Files uses port 445 (may need to be unblocked).  
- Azure Data Box Disks: 5 encrypted SSDs per order, 40 TB total capacity.  
- WA Import/Export tool is Windows 64-bit only; version 1 for blobs, version 2 for Azure Files.  
- SAS types: account-level, service-level, user-delegated (best practice).  

**Examples**  
- Tools to move data into Blob Storage: AZCopy, Azure Data Factory, Blob Fuse, Azure Databox, Azure Import/Export Service.  
- Azure File Sync caches Azure file shares on-premises or cloud VMs for faster access.  
- Using BitLocker to encrypt drives for Azure Import/Export.  

**Key Takeaways 🎯**  
- Know the five core Azure storage services and their purposes.  
- Understand the differences between blob types and access tiers, including costs and retention policies.  
- Be familiar with replication options and when to use each.  
- Remember port 445 is required for SMB access to Azure Files and may need to be unblocked.  
- Soft delete and snapshot features protect against accidental data loss in Azure Files.  
- Know the basics of Azure Import/Export Service and WA Import/Export tool requirements.  
- Shared Access Signatures are critical for secure, temporary access; user-delegated SAS using Azure AD is best practice.  
- Be aware of charges related to tier changes, early deletions, and data retrievals.  
- Understand rehydration timing and implications when moving blobs from Archive tier.

---

### Intro

**Timestamp**: 04:02:22 – 04:05:15

**Key Concepts**  
- Azure Virtual Machines (VMs) provide customizable virtual servers with selectable OS, compute, memory, and storage.  
- VMs run on virtualization technology, eliminating the need for physical hardware management.  
- Users are responsible for managing the software layer: OS patches and configuration.  
- VM size is determined by the Azure image, which defines the combination of vCPUs, memory, and storage capacity.  
- Azure subscription limits VM instances to 20 per region by default.  
- Azure VMs are billed hourly.  
- Availability depends on disk type and deployment:  
  - Single instance with premium disk offers 99.9% availability.  
  - To achieve 99.95% availability, deploy 2 instances in an availability set.  
- Multiple managed disks can be attached to a VM.  
- Launching a VM automatically creates or associates several networking components grouped in a resource group.  

**Definitions**  
- **Azure Virtual Machine (VM)**: A highly configurable virtual server running on Azure’s virtualization platform, allowing users to run an OS and applications without managing physical hardware.  
- **VM Size**: The specification of a VM’s compute resources (vCPUs, memory, storage) defined by the selected Azure image.  
- **Network Security Group (NSG)**: A virtual firewall attached to the VM’s network interface that controls inbound and outbound traffic via port and protocol rules.  
- **Network Interface**: The component that handles IP protocols, enabling the VM to communicate over the internet or internal networks.  
- **Virtual Network (VNet)**: The isolated network environment in which the VM is launched, either pre-existing or created during VM setup.  
- **Public IP Address**: The internet-facing IP assigned to a VM instance allowing external access.  

**Key Facts**  
- Default limit: 20 VMs per subscription per region.  
- Single VM with premium disk: 99.9% availability.  
- Two VMs in an availability set: 99.95% availability.  
- VM launch process creates multiple components (NSG, network interface, public IP, VNet) often grouped in a resource group.  

**Examples**  
- None explicitly mentioned beyond general VM setup and component creation.  

**Key Takeaways 🎯**  
- Understand that Azure VMs are virtualized servers requiring user management at the OS/software level.  
- Know the VM size is tied to the Azure image, which bundles CPU, memory, and storage specs.  
- Remember the default VM limit per region and billing is hourly.  
- Availability improves with premium disks and deploying multiple instances in availability sets.  
- Be familiar with the networking components created with a VM: NSG (firewall), network interface, public IP, and VNet.  
- During the exam, expect questions on VM architecture, availability SLAs, and networking components associated with VMs.

---

## VMs

---

### Operation Systems

**Timestamp**: 04:05:15 – 04:07:01

**Key Concepts**  
- Operating System (OS) manages all other programs on a computer.  
- The OS for an Azure VM is determined by the image selected during VM creation.  
- Azure Marketplace offers a wide variety of OS images, including those optimized and updated for Azure.  
- Users can bring their own Linux OS by packaging it into a VHD (Virtual Hard Disk) format.  
- Azure supports only the VHD format, not the newer VHDX format.  
- Cloud Init is a multi-distribution, cross-platform cloud instance initialization tool supported by major cloud providers (Azure, AWS, GCP).

**Definitions**  
- **Operating System (OS)**: The program that manages all other programs on a computer.  
- **VHD (Virtual Hard Disk)**: A virtual hard disk file format used to package an OS for deployment in Azure VMs.  
- **Cloud Init**: An industry-standard tool for initializing cloud instances across multiple distributions and cloud platforms.

**Key Facts**  
- Common OS examples: Windows, Mac OS, Linux.  
- Supported/partnered Linux distributions on Azure include: SUSE, Red Hat, Ubuntu, Debian, FreeBSD, Flatcar Container Linux, RancherOS (for containerization), Bitnami (preloaded software images), Mesosphere, Docker-enabled images, Jenkins.  
- Azure does not support the VHDX format; only VHD is supported for custom OS images.

**Examples**  
- Bitnami WordPress image (preloaded software).  
- RancherOS for containerization.  
- Bringing your own Linux OS by creating a VHD using Hyper-V on Windows.

**Key Takeaways 🎯**  
- When creating an Azure VM, the OS is selected via the image from the Azure Marketplace or a custom VHD.  
- Know the difference between VHD and VHDX formats; only VHD is supported in Azure.  
- Familiarize yourself with the variety of Linux distributions supported natively or via partnerships on Azure.  
- Cloud Init is not on the exam but is important industry knowledge for cloud instance initialization across platforms.

---

### Cloud Init

**Timestamp**: 04:07:01 – 04:08:55

**Key Concepts**  
- Cloud Init is a multi-distribution, cross-platform cloud instance initialization method.  
- It is supported across all major public cloud providers (Azure, AWS, GCP), private cloud provisioning systems, and bare metal installations.  
- Cloud instance initialization is the process of preparing a cloud instance with configuration data for the OS and runtime environment.  
- Initialization uses a base VM image plus instance data such as metadata, user data, and vendor data.  
- The primary data used in practice is **user data**, which is a script run when the instance first boots.  
- Cloud Init mainly works with Linux distributions and is not typically used for Windows VMs.  
- In Azure, user data is less explicitly labeled but is used under the hood when deploying via ARM templates (infrastructure as code).  

**Definitions**  
- **Cloud Init**: A standardized method to initialize cloud instances across multiple Linux distributions and cloud platforms by applying configuration data at first boot.  
- **User Data**: A script or set of instructions provided to a cloud instance that runs during its initial boot to configure the OS and environment.  

**Key Facts**  
- Cloud Init is industry standard and supported by Azure, AWS, GCP, private clouds, and bare metal installs.  
- Azure does not explicitly call it "user data" in the portal but uses Cloud Init functionality when deploying Linux VMs programmatically.  
- Cloud Init is primarily Linux-focused; Windows VMs generally do not use Cloud Init.  

**Examples**  
- AWS instance launch wizard includes a "user data" box where you can input scripts to run at first boot.  
- Azure ARM templates use Cloud Init behind the scenes for Linux VM provisioning.  

**Key Takeaways 🎯**  
- Know that Cloud Init is the standard for Linux VM initialization across clouds.  
- Understand that "user data" scripts are the main mechanism to customize instances at first boot.  
- Remember Cloud Init is not typically used for Windows VMs.  
- In exam scenarios, associate "user data" with Cloud Init, especially when dealing with Linux VM provisioning.  
- Although not explicitly tested, familiarity with Cloud Init is valuable for real-world cloud deployments and infrastructure as code.  

---

### Sizes

**Timestamp**: 04:08:55 – 04:12:15

**Key Concepts**  
- Azure Virtual Machines (VMs) come in various **sizes** (also called series or SKU families) optimized for different workloads.  
- Sizes are grouped into **types** based on CPU-to-memory ratio and intended use cases.  
- Azure Compute Units (ACUs) provide a standardized way to compare CPU performance across VM sizes.

**Definitions**  
- **Sizes / Series / SKU families**: Different categories of Azure VMs optimized for specific workloads; terms used interchangeably in Azure documentation.  
- **General Purpose**: Balanced CPU-to-memory ratio, suitable for testing, development, small to medium databases, and low to medium traffic web servers.  
- **Compute Optimized**: High CPU-to-memory ratio, ideal for medium traffic web servers, network appliances, batch processes, and app servers.  
- **Memory Optimized**: High memory-to-CPU ratio, good for relational databases, large caches, and in-memory analytics.  
- **Storage Optimized**: High disk throughput and IOPS, designed for big data, SQL/NoSQL databases, data warehousing, and large transactional databases.  
- **GPU Optimized**: Specialized VMs with single or multiple GPUs for graphic rendering, video editing, and deep learning tasks.  
- **High Performance Compute (HPC)**: Fastest and most powerful CPUs with optional high throughput networking for demanding compute workloads.  
- **Azure Compute Units (ACUs)**: A performance metric to compare CPU power across VM sizes, standardized against the older A1 VM size (value = 100).

**Key Facts**  
- The most commonly used general purpose VM size is **B1**, noted for being very cost-effective and frequently used for Linux VMs in labs and demos.  
- Compute optimized popular size: **F series (FSv2)**.  
- Storage optimized popular size: **LSv2**.  
- Pricing and available sizes depend on the chosen VM image; not all sizes are available for every image.  
- Azure portal allows filtering VM sizes by cost and other parameters, making it easy to find the most cost-effective option.  
- ACU values are relative and based on a benchmark against the older A1 VM size, which is no longer commonly used.

**Examples**  
- Using the **B1 series** VM for Linux machines due to its low cost (~CAD $9.72).  
- Compute optimized VM example: **FSv2 (F series)** for CPU-intensive workloads.  
- Storage optimized VM example: **LSv2** for big data and database workloads.

**Key Takeaways 🎯**  
- Remember that **sizes**, **series**, and **SKU families** all refer to the same concept of VM categorization in Azure.  
- Choose VM size based on workload needs: balanced (general purpose), CPU-heavy (compute optimized), memory-heavy, storage-heavy, GPU, or HPC.  
- The **B1 size** is a common, cost-effective choice for general Linux VM deployments.  
- Use Azure Compute Units (ACUs) to compare CPU performance across VM sizes when selecting the right VM.  
- Not all VM sizes are available for every OS image; availability depends on the image selected.  
- Utilize Azure portal filters to find the best VM size for your budget and requirements.

---

### ACUs

**Timestamp**: 04:12:15 – 04:13:48

**Key Concepts**  
- Azure Compute Units (ACUs) provide a standardized way to compare CPU performance across different Azure VM SKUs (sizes/series).  
- ACU values are benchmark-based relative performance scores.  
- The baseline for ACUs is the Standard A1 VM SKU, which is assigned a value of 100 ACUs.  
- Other VM SKUs have ACU values representing how much faster they perform compared to the A1 baseline.

**Definitions**  
- **Azure Compute Units (ACUs)**: A metric used by Azure to compare the compute (CPU) performance of different VM SKUs by assigning a relative performance score.  
- **SKU (Stock Keeping Unit)**: Refers to VM sizes or series in Azure.

**Key Facts**  
- The Standard A1 VM SKU is the baseline with an ACU value of 100.  
- The A1 series is an older series and generally not recommended for new deployments.  
- The D-series VMs (D1 to D14) have ACU values ranging from approximately 160 to 250.  
- This means D-series VMs can be roughly 60% to 150% more performant than the A1 baseline.  
- The ratio of vCPUs to cores in A1 is 1:1.

**Examples**  
- Comparison example:  
  - A1 VM = 100 ACUs (baseline)  
  - D1-D14 VMs = 160 to 250 ACUs (60% to 150% faster than A1)  

**Key Takeaways 🎯**  
- Understand that ACUs are a relative performance metric to help compare VM CPU capabilities across Azure SKUs.  
- Always consider ACU values when selecting VM sizes for performance needs.  
- The A1 VM SKU is the baseline for ACU scoring but is generally outdated.  
- D-series VMs offer significantly better CPU performance compared to A-series based on ACU scores.  
- ACUs simplify VM performance comparison without needing to understand the underlying hardware details.

---

### MobileApp

**Timestamp**: 04:13:48 – 04:14:38

**Key Concepts**  
- Azure Mobile App integration with Azure Virtual Machines  
- Monitoring and managing VMs remotely via mobile app  
- QR code usage for quick connection to VMs (optional)  
- Access to Cloud Shell through the mobile app  

**Definitions**  
- **Azure Mobile App**: A mobile application available on Android and iOS that allows users to connect to their Azure account, monitor virtual machines, and perform basic management tasks remotely.  

**Key Facts**  
- The Azure Mobile App can scan a QR code displayed on Azure Virtual Machines for quick access, but scanning is not mandatory if logged in.  
- Users can check VM performance and take basic actions directly from their phone.  
- The app supports Cloud Shell access, enabling command-line management on the go.  
- Available on both Android and iOS platforms (confirmed on Android).  

**Examples**  
- Scanning the QR code on a VM to connect via the Azure Mobile App.  
- Logging into the Azure Mobile App to monitor VM performance without scanning.  

**Key Takeaways 🎯**  
- Remember to install the Azure Mobile App on your phone for convenient VM monitoring and management.  
- You do not need to scan the QR code if you are already logged into your Azure account on the app.  
- The app provides access to Cloud Shell, enhancing remote management capabilities.  
- Useful for quick checks and basic VM actions when away from a desktop.  

---

### VM Generations

**Timestamp**: 04:14:38 – 04:17:26

**Key Concepts**  
- Hyper-V is Microsoft’s hardware virtualization platform that allows creation and running of virtual machines (VMs).  
- Hyper-V supports two VM generations: Generation 1 and Generation 2.  
- Azure also supports Gen 1 and Gen 2 VMs, but Azure’s implementation is not exactly the same as Hyper-V’s.  
- The main difference between Gen 1 and Gen 2 VMs is their boot architecture: Gen 1 uses BIOS-based boot, Gen 2 uses UEFI-based boot.  
- UEFI offers advanced features such as secure boot and support for larger boot volumes.

**Definitions**  
- **Hyper-V**: Microsoft’s virtualization technology that creates software-based virtual machines acting like complete computers.  
- **Generation 1 VM**: A VM using BIOS-based boot architecture, supporting most guest operating systems.  
- **Generation 2 VM**: A VM using UEFI-based boot architecture, supporting most 64-bit Windows versions and newer Linux/FreeBSD OSes.  
- **BIOS (Basic Input/Output System)**: Traditional firmware interface for booting computers.  
- **UEFI (Unified Extensible Firmware Interface)**: Modern firmware interface replacing BIOS, providing features like secure boot and larger boot volume support.  
- **Secure Boot**: A UEFI feature that verifies the bootloader is signed by a trusted authority to enhance security.  
- **VHD / VHDX**: Virtual hard disk file formats used to package Hyper-V virtual machines.

**Key Facts**  
- Generation 1 VMs support most guest OSes; Generation 2 supports most 64-bit Windows and newer Linux/FreeBSD OSes.  
- Azure Gen 1 and Gen 2 VMs are not exactly the same as Hyper-V Gen 1 and Gen 2 VMs; do not rely solely on Hyper-V documentation for Azure VM generation features.  
- Gen 1 uses BIOS-based boot architecture; Gen 2 uses UEFI-based boot architecture.  
- UEFI supports secure boot and boot volumes up to 64 terabytes.  
- Hyper-V VMs are packaged as VHD or VHDX files.

**Examples**  
- None specifically mentioned beyond general references to Windows and Linux OS compatibility with VM generations.

**Key Takeaways 🎯**  
- Understand that VM generations differ mainly by boot architecture: BIOS (Gen 1) vs UEFI (Gen 2).  
- Know that Gen 2 VMs provide enhanced features like secure boot and support for larger boot volumes.  
- Remember that Azure VM generations are similar but not identical to Hyper-V generations—do not assume feature parity.  
- Be familiar with VHD and VHDX as virtual disk formats for Hyper-V VMs.  
- When choosing VM generation, consider OS compatibility and required features rather than always defaulting to Gen 2.

---

### 3 Ways To Connect

**Timestamp**: 04:17:26 – 04:19:29

**Key Concepts**  
- There are three main ways to connect to Azure virtual machines: SSH, RDP, and Bastion.  
- Each connection method serves different use cases and protocols.  
- SSH is primarily used for secure terminal access, especially on Linux VMs.  
- RDP provides a graphical interface for remote desktop access, mainly for Windows VMs.  
- Azure Bastion allows browser-based VM access through the Azure portal without needing client software.

**Definitions**  
- **SSH (Secure Shell)**: A protocol to establish a secure, encrypted connection between a client and server, commonly used for remote terminal access to VMs.  
- **RDP (Remote Desktop Protocol)**: A Microsoft proprietary protocol that provides a graphical interface to remotely control another computer over a network.  
- **Azure Bastion**: An Azure service that enables secure and seamless RDP/SSH connectivity to VMs directly through a web browser via the Azure portal.

**Key Facts**  
- SSH uses TCP port **22**.  
- SSH authentication is typically done using an RSA key pair rather than username/password.  
- RDP uses TCP and UDP port **3389**.  
- Azure Bastion eliminates the need to install SSH or RDP clients on your local machine.  
- SSH key pairs are generated using the command: `ssh-keygen -t rsa`.

**Examples**  
- Using SSH to remotely connect to an Azure VM terminal via port 22.  
- Using RDP to open a remote Windows desktop session on a VM via port 3389.  
- Using Azure Bastion to connect to a VM from a Chrome OS device that lacks native SSH or RDP clients.

**Key Takeaways 🎯**  
- Remember **port 22** for SSH and **port 3389** for RDP—these are critical exam facts.  
- SSH key pair authentication is the preferred and more secure method over username/password.  
- Azure Bastion is useful when client software installation is not possible or practical, enabling browser-based VM access.  
- Memorize the SSH key generation command `ssh-keygen -t rsa` as it is commonly used in practice and exams.

---

### SSH

**Timestamp**: 04:19:29 – 04:20:41

**Key Concepts**  
- SSH (Secure Shell) is commonly used to access and authenticate to virtual machines (VMs).  
- Authentication is typically done using an SSH key pair (public and private keys).  
- The private key remains on the local system and must be kept secure.  
- The public key is stored on the VM to allow authentication.  
- SSH key pairs are generated using the command `ssh-keygen -t rsa`.  
- When connecting via SSH, the private key is provided to match against the public key on the VM.  
- Public key files have a `.pub` extension.

**Definitions**  
- **SSH key pair**: A pair of cryptographic keys (private and public) used to securely authenticate a user to a remote system without using passwords.  
- **Private key**: The secret key kept on the user's local machine, never shared.  
- **Public key**: The key stored on the remote VM that corresponds to the private key for authentication.

**Key Facts**  
- The SSH key generation command to memorize is: `ssh-keygen -t rsa`.  
- The private key should never be shared or exposed outside the local system.  
- The public key file ends with `.pub`.  
- SSH authentication works by matching the private key provided during connection with the public key stored on the VM.

**Examples**  
- Using SSH to connect: `ssh -i [private_key_file] [username]@[server_address]` where the `.pub` file is the public key stored on the VM.

**Key Takeaways 🎯**  
- Memorize the SSH key generation command: `ssh-keygen -t rsa`.  
- Understand the difference between private and public keys and their roles in authentication.  
- Always keep your private key secure and never share it.  
- Recognize `.pub` files as public keys used on the VM side.  
- Know how to use the private key with the SSH command to access your VM.

---

### RDP

**Timestamp**: 04:20:41 – 04:21:25

**Key Concepts**  
- Remote Desktop Protocol (RDP) connection process to a virtual machine (VM)  
- Use of an RDP file to initiate the connection  
- Authentication via username and password specified during VM creation  
- Platform-specific availability of RDP clients  

**Definitions**  
- **RDP file**: A file with an `.rdp` extension used to initiate a Remote Desktop connection to a VM.  
- **RDP Client**: Software used to connect to a remote machine using the Remote Desktop Protocol.  

**Key Facts**  
- To connect via RDP, first download the `.rdp` file associated with the VM.  
- Double-clicking the `.rdp` file prompts for username and password authentication.  
- The username and password are those set when the VM was created.  
- On Windows, the RDP client is pre-installed—no additional installation required.  
- On Mac, the Remote Desktop Client must be installed from the Apple Store.  

**Examples**  
- None mentioned specifically for RDP beyond the general process of downloading and opening the `.rdp` file and entering credentials.  

**Key Takeaways 🎯**  
- Always download and use the `.rdp` file to connect to your VM via RDP.  
- Remember the username and password you configured during VM setup—they are required for login.  
- Know your platform: Windows has built-in RDP client; Mac users need to install it from the Apple Store.  
- This process is essential for accessing Windows-based VMs or any VM configured for RDP access.  

---

### Bastion

**Timestamp**: 04:21:25 – 04:23:57

**Key Concepts**  
- Azure Bastion is a managed, hardened intermediate instance that enables secure RDP and SSH connectivity to virtual machines directly through the Azure portal.  
- Bastion provides a web-based RDP client or SSH terminal, eliminating the need for local clients.  
- It is especially useful for devices that lack native SSH or RDP clients, such as Google Chromebooks or restricted Windows environments.  
- Bastion enhances security by providing a controlled and auditable access point to VMs without exposing them via public IP addresses.  
- To deploy Azure Bastion, you must create or use a subnet named **AzureBastionSubnet** with a minimum size of **/27 (32 IP addresses)** in your virtual network (VNet).  

**Definitions**  
- **Azure Bastion**: A PaaS service that provides secure and seamless RDP/SSH connectivity to Azure VMs directly through the Azure portal over SSL, without exposing the VM to the public internet.  

**Key Facts**  
- Azure Bastion requires a dedicated subnet named **AzureBastionSubnet** in the VNet.  
- The subnet must be at least a **/27** subnet, providing **32 IP addresses**.  
- Bastion supports both RDP (for Windows VMs) and SSH (for Linux VMs).  
- For SSH connections, Bastion supports authentication via username/password or SSH private key (.pem file), with private key authentication recommended.  

**Examples**  
- Connecting to a Windows VM via Bastion: Select "Connect with Azure Bastion," enter username and password, and access the VM through the browser-based RDP client.  
- Connecting to a Linux VM via Bastion: Enter username, switch to SSH private key authentication, upload the .pem private key file, and connect via the browser-based SSH terminal.  
- Use case: Users on Google Chromebooks (which only have browsers) can connect to Azure VMs without needing to install any client software.  

**Key Takeaways 🎯**  
- Remember the **AzureBastionSubnet** naming requirement and subnet size (/27) when deploying Bastion.  
- Bastion is ideal for secure, clientless RDP/SSH access, especially from devices without native clients.  
- Use SSH private key authentication for Linux VMs when connecting via Bastion for better security.  
- Bastion helps avoid exposing VMs to the public internet and provides auditing capabilities for access control.  
- Understand the difference between traditional RDP/SSH client usage and Bastion’s browser-based approach.  

---

### Windows Vs Linux

**Timestamp**: 04:23:57 – 04:26:34

**Key Concepts**  
- Azure supports running both Windows and Linux virtual machines (VMs).  
- Windows VMs require a license to run but launching without one results in an unactivated state, not immediate charges.  
- Windows VMs typically require larger instance sizes due to running a full desktop environment.  
- Linux VMs generally do not require licenses (except some distributions like Red Hat if support is needed).  
- Linux VMs can run on smaller instance sizes since they usually operate in a terminal-based environment without a full desktop.  
- Access methods differ: Windows uses RDP with username/password; Linux uses SSH with username/password or SSH key pairs.  
- Update management can automate OS patching for both Windows and Linux VMs across Azure, on-premises, and other clouds.

**Definitions**  
- **Hybrid License**: A licensing option where enterprises bring their own existing Windows licenses to Azure VMs instead of using Azure-provided licenses.  
- **Update Management**: A service that automates the installation of operating system updates and patches on virtual machines regardless of their location.

**Key Facts**  
- Windows Server requires a license but launching without one only shows "Windows is unactivated" and requires manual activation.  
- Windows VMs need larger instance types (e.g., B2) compared to Linux VMs (e.g., B1) due to the full desktop environment.  
- Linux VMs typically do not have licensing fees unless using enterprise distributions like Red Hat with support.  
- Windows VMs are accessed via Remote Desktop Protocol (RDP) using username and password.  
- Linux VMs are accessed via SSH using username/password or SSH private key (.pem file).  
- Update management supports patching for both Windows and Linux VMs on Azure, on-premises, and other cloud providers.

**Examples**  
- Windows VM requires a B2 instance size (larger and more expensive) because it runs a full desktop environment.  
- Linux VM can run on smaller instance sizes like B1 since it is terminal-based and does not run a full desktop environment.

**Key Takeaways 🎯**  
- Do not worry about immediate licensing fees when launching Windows VMs; manual activation is required later.  
- Use SSH private keys for Linux VM access for better security; Windows VMs require username/password for RDP.  
- Linux VMs are generally more cost-effective for learning and certification purposes due to smaller instance requirements and no licensing fees.  
- Understand the difference in access methods and resource requirements between Windows and Linux VMs.  
- Use update management to automate patching and updates across both Windows and Linux environments, including hybrid and multi-cloud setups.

---

### Update Management

**Timestamp**: 04:26:34 – 04:28:25

**Key Concepts**  
- Update Management automates installation of OS updates and patches for both Windows and Linux virtual machines.  
- It supports VMs running on Azure, on-premises environments, and other cloud providers.  
- Update Management is accessed via the Operations tab under "guest + host updates" in the Azure portal.  
- Although it appears as a standalone service, Update Management runs on top of Azure Automation.  
- The Microsoft Monitoring Agent (MMA) must be installed on each machine to enable update management.  
- Compliance scans for updates run automatically: every 12 hours on Windows VMs and every 3 hours on Linux VMs.  
- Dashboard data reflecting update compliance can take from 30 minutes up to 6 hours to refresh after scans.  
- Azure Automation offers additional features beyond update management, such as change tracking, inventory, and VM start/stop scheduling.  
- These features depend on linking a Log Analytics workspace with an Automation account.

**Definitions**  
- **Update Management**: A service that automates the deployment of operating system updates and patches across Windows and Linux virtual machines in Azure, on-premises, or other clouds.  
- **Microsoft Monitoring Agent (MMA)**: The agent installed on VMs that enables communication with Azure Automation for update management and monitoring.  
- **Azure Automation**: A broader Azure service that underpins Update Management and provides automation capabilities like patching, change tracking, and VM scheduling.  
- **Log Analytics Workspace**: A workspace required to collect and analyze monitoring data, which must be linked to the Automation account for update management features to work.

**Key Facts**  
- Compliance scans frequency:  
  - Windows: every 12 hours  
  - Linux: every 3 hours  
- Dashboard update latency: 30 minutes to 6 hours after scan completion.  
- Update Management supports multi-environment patching: Azure, on-premises, other clouds.  
- Dependency on Log Analytics workspace linked to Automation account for full functionality.

**Examples**  
- None specifically mentioned beyond general usage scenarios.

**Key Takeaways 🎯**  
- Remember that Update Management requires the Microsoft Monitoring Agent installed on each VM.  
- Know the scan intervals for Windows (12 hours) and Linux (3 hours) machines.  
- Understand that Update Management is part of Azure Automation and depends on linking a Log Analytics workspace.  
- Update Management can be used beyond Azure VMs, including on-premises and other cloud environments.  
- Be aware of the potential delay (up to 6 hours) before update compliance data appears in the dashboard.  
- Azure Automation offers multiple server management features beyond patching—know these for broader exam context.

---

### Create a Bastion

**Timestamp**: 04:28:25 – 04:33:23

**Key Concepts**  
- Azure Bastion Service allows secure RDP/SSH connectivity to virtual machines directly through the Azure portal without exposing public IP addresses.  
- Bastion requires a dedicated subnet with a specific address space within the virtual network.  
- Bastion setup can be done either directly from the Bastions blade or after creating a virtual machine (VM).  
- Bastion connections run entirely in the browser, eliminating the need for external RDP/SSH clients.  
- Bastion is useful for devices or OS environments where native RDP/SSH clients are unavailable or difficult to install (e.g., Chromebooks, Linux).  

**Definitions**  
- **Azure Bastion**: A managed PaaS service that provides secure and seamless RDP/SSH connectivity to VMs over SSL directly in the Azure portal without exposing public IPs.  
- **Address Space (Subnet)**: A CIDR block (e.g., 10.0.1.0/24) allocated specifically for the Bastion subnet within the virtual network.  

**Key Facts**  
- Bastion requires creating a new subnet with an address space such as 10.0.1.0/24.  
- Bastion setup now includes a wizard that simplifies creating required resources (subnet, network security group, etc.), which previously had to be done manually.  
- Bastion provisioning can take some time to complete.  
- Bastion connections use the Azure portal web interface for RDP/SSH access.  
- Pricing for Bastion is not detailed but noted to have a cost, so resources should be cleaned up after use to avoid charges.  

**Examples**  
- Created a Windows Server VM in a new resource group called "Enterprise."  
- Used username "Azure user" and password "Testing123456" for VM login.  
- Connected to the VM first via traditional RDP by downloading the RDP file to verify connectivity.  
- Created a Bastion subnet with address space 10.0.1.0/24 and deployed Bastion in the same resource group.  
- Connected to the VM using Bastion through the Azure portal by entering username and password directly in the browser.  

**Key Takeaways 🎯**  
- Know how to create and configure Azure Bastion, including the requirement for a dedicated subnet with a specific address space.  
- Understand that Bastion enables secure, browser-based RDP/SSH without exposing VM public IPs or requiring external clients.  
- Remember Bastion provisioning can take several minutes—plan accordingly.  
- Be aware of Bastion’s pricing implications and the importance of cleaning up resources after use.  
- Bastion is especially useful for users on platforms where native RDP/SSH clients are unavailable or inconvenient.

---

### Create a Windows VM and RDP

**Timestamp**: 04:33:23 – 04:38:53

**Key Concepts**  
- Creating a Windows virtual machine (VM) in Azure via the portal  
- Selecting appropriate VM size for Windows OS  
- Setting up inbound port rules for Remote Desktop Protocol (RDP) access  
- Using RDP client to connect to the Windows VM  
- Managing VM lifecycle: deployment and deletion  
- Licensing considerations for Windows VMs in Azure  

**Definitions**  
- **Virtual Machine (VM)**: A software emulation of a physical computer that runs an operating system and applications just like a physical computer.  
- **RDP (Remote Desktop Protocol)**: A protocol that allows users to connect to another computer over a network connection using a graphical interface.  
- **Inbound Port 3389**: The default port used by RDP to allow remote desktop connections.  
- **Resource Group**: A container in Azure that holds related resources for an Azure solution.  

**Key Facts**  
- Windows 10 Pro is used as the example OS for the VM (preferred for ease of learning).  
- VM size must be at least B2S to run Windows Server/Windows 10 Pro; smaller sizes like B1LS are insufficient.  
- Password example used: Username = Cardassia, Password = Cardassia123 (with capital letters).  
- Inbound port 3389 must be allowed for RDP access.  
- Standard SSD is selected for the disk type.  
- Azure automatically creates a new Virtual Network (VNet) and Network Security Group (NSG) when creating the VM.  
- Windows license activation is not required for learning/testing purposes; unactivated Windows will still run but with limitations.  
- RDP client is built-in on Windows; Mac users can download the Microsoft Remote Desktop app from the App Store.  
- After use, delete the VM and resource group to avoid unnecessary charges.  

**Examples**  
- Creating a resource group named "Cardassia" and a VM also named "Cardassia."  
- Setting password as "Cardassia123" with capitalization.  
- Connecting to the VM via RDP by downloading the RDP file and entering credentials.  
- Observing that Windows 10 Pro loads without activation but is usable for learning.  
- Deleting the resource group "Cardassia" to clean up resources after use.  

**Key Takeaways 🎯**  
- Always select a VM size that supports Windows OS (B2S or larger).  
- Remember to open inbound port 3389 for RDP access when creating the VM.  
- Use meaningful resource group and VM names for easy management.  
- Windows VMs can be used without license activation for testing, but expect some limitations.  
- Use the built-in RDP client on Windows or download the Microsoft Remote Desktop app on Mac.  
- Always delete VMs and associated resource groups after use to avoid unnecessary costs.  
- Azure automates network setup (VNet and NSG) during VM creation, simplifying deployment.

---

### Create a Linux VM and SSH

**Timestamp**: 04:38:53 – 04:53:15

**Key Concepts**  
- Creating a Linux virtual machine (VM) in Azure via the portal  
- Selecting subscription, resource group, region, and availability zone  
- Choosing VM image (Ubuntu 18.04 used in example)  
- Selecting VM size based on cost and resource needs (e.g., B1LS with 0.5 GB RAM)  
- Authentication options: SSH public key (preferred) vs password  
- Generating and downloading SSH key pairs for secure access  
- Configuring inbound port rules (SSH port 22 and HTTP port 80) via Network Security Group (NSG)  
- Disk options: standard HDD vs premium SSD (cost vs performance considerations)  
- Networking setup: automatic creation of virtual network (vNet), subnet, NIC, NSG, and public IP  
- Azure Bastion service for secure browser-based SSH access without needing external clients like PuTTY  
- Requirement to create a special subnet named "AzureBastionSubnet" with prefix /27 for Bastion deployment  
- Connecting to Linux VM via Bastion using SSH private key authentication  
- Installing Apache web server on Ubuntu VM using `apt-get install apache2`  
- Verifying Apache service is running and accessible via VM’s public IP on port 80  
- Cleaning up resources by deleting the resource group to remove all associated resources including VM, NIC, NSG, vNet, and public IP  
- Importance of double-checking that all resources, especially public IP addresses, are deleted to avoid unexpected charges  

**Definitions**  
- **Virtual Machine (VM)**: A software emulation of a physical computer running an operating system and applications.  
- **SSH (Secure Shell)**: A protocol for securely connecting to remote machines, typically used for Linux VM access.  
- **Network Security Group (NSG)**: A set of inbound and outbound security rules applied to network interfaces or subnets to control traffic.  
- **Azure Bastion**: A managed PaaS service that provides secure and seamless RDP/SSH connectivity to VMs directly through the Azure portal without exposing public IPs.  
- **Resource Group**: A container that holds related Azure resources for management and billing purposes.  

**Key Facts**  
- VM size example: B1LS with 0.5 GB RAM, cost-effective for lightweight workloads  
- SSH port: 22 must be open for SSH access  
- HTTP port: 80 must be open to serve web traffic (e.g., Apache server)  
- Azure Bastion requires a subnet named exactly `AzureBastionSubnet` with at least a /27 prefix  
- Disk types: Standard HDD (cost-effective), Premium SSD (better performance, recommended for production workloads)  
- Apache installation command on Ubuntu: `apt-get install apache2`  
- After VM creation, Azure automatically creates associated resources: NIC, NSG, vNet, public IP  
- Public IP addresses can incur significant costs if not deleted (warning about $700 yearly cost if left allocated)  

**Examples**  
- Created a Linux VM named "Bajour" in the US East region with Ubuntu 18.04 image  
- Selected B1LS VM size for cost efficiency  
- Generated SSH key pair named "Bajour" for authentication  
- Opened inbound ports 22 (SSH) and 80 (HTTP) in NSG  
- Created Azure Bastion by adding a subnet `AzureBastionSubnet` with /27 prefix  
- Connected to the VM via Bastion using SSH private key authentication  
- Installed Apache web server and accessed the default Apache page via the VM’s public IP address  
- Deleted the resource group "Bajour" to clean up all resources  

**Key Takeaways 🎯**  
- Always choose the appropriate VM size balancing cost and performance; B1LS is a good low-cost option for testing  
- Use SSH public key authentication over passwords for better security  
- Ensure inbound NSG rules allow port 22 for SSH and port 80 for web traffic if running a web server  
- Azure Bastion simplifies secure access to VMs without exposing public IP or needing external SSH clients  
- Remember to create the `AzureBastionSubnet` with correct prefix before deploying Bastion  
- After deployment, verify all associated resources (especially public IPs) are deleted during cleanup to avoid unexpected charges  
- Practice connecting to Linux VMs via Bastion and installing basic services like Apache to confirm setup  
- Use resource groups to logically group and easily delete all related resources in one operation  

---

### VM Monitoring

**Timestamp**: 04:53:15 – 05:27:55

**Key Concepts**  
- Monitoring Azure Virtual Machines (VMs) involves checking performance and diagnostics.  
- Important Azure services for VM monitoring: Automation Accounts, Log Analytics, Metrics, and Alerts.  
- Resource providers for alerts management and insights must be registered/enabled in the subscription.  
- Guest OS diagnostics/metrics require the Azure Monitoring Agent (WAG agent) installed on the VM.  
- Log Analytics Workspace acts as a centralized data lake for collecting and querying logs from multiple resources.  
- Automation Accounts manage configuration and update management for VMs, including patching and running automated scripts (runbooks).  
- Diagnostic settings enable collection of guest metrics such as memory, disk, network, and CPU usage.  
- Host metrics are collected by default (CPU, etc.), but guest metrics (memory, disk space) require explicit enabling.  
- Alerts can be created based on log queries or metric thresholds to notify on VM health or performance issues.  
- Performance counters on Windows VMs must be enabled to send guest metrics.  
- Stress testing tools (e.g., StressNG on Linux) can be used to generate load and test monitoring data collection.  
- Azure Monitor Logs use Kusto Query Language (KQL) for querying collected data.  

**Definitions**  
- **Automation Account**: Azure service for managing VM configurations, updates, and running automated tasks (runbooks).  
- **Log Analytics Workspace**: A centralized repository (data lake) for collecting, storing, and querying logs and metrics from Azure resources.  
- **Guest Metrics**: Performance and diagnostic data collected from inside the VM OS (memory usage, disk space, network stats).  
- **Host Metrics**: Performance data collected from the VM host infrastructure (CPU usage, basic metrics).  
- **Runbook**: A set of automated tasks or scripts executed via Azure Automation to manage VMs or other resources.  
- **WAG Agent (Windows Azure Guest Agent)**: Agent installed on VMs to enable diagnostics and monitoring data collection.  
- **Diagnostic Settings**: Configuration on a VM to send guest metrics and logs to Azure Monitor or storage accounts.  
- **Heartbeat**: A periodic signal sent by a VM to indicate it is alive and responsive.  

**Key Facts**  
- Resource providers to enable:  
  - `alertsmanagement` (for alerts)  
  - `insights` (for monitoring and diagnostics)  
- Minimal Linux installs may lack the WAG agent, preventing guest metrics collection unless manually installed.  
- Windows Server VMs require at least DS2v2 or DS2v3 size for proper monitoring support (due to CPU/memory requirements).  
- Diagnostic data is stored in Azure Storage accounts created automatically or manually linked.  
- Automation Accounts require an Azure Run As Account with contributor permissions to manage resources.  
- Log Analytics workspace can be created manually or via Automation Account setup for better integration.  
- Performance counters on Windows need to be started manually to begin sending guest metrics.  
- Guest metrics include memory, network, disk, and storage usage; these are not collected by default.  
- Alerts can be created based on log queries with customizable thresholds and incur monthly costs.  
- Azure Monitor Logs use Kusto Query Language (KQL) for querying logs and metrics.  
- VM monitoring data may take some time to appear after enabling diagnostics and generating load.  
- StressNG is a Linux tool used to simulate high memory usage for testing monitoring setups.  

**Examples**  
- Created three VMs for demonstration:  
  - Ubuntu minimal install (no guest metrics agent by default)  
  - Ubuntu LTS with guest metrics enabled (WAG agent installed)  
  - Windows Server VM (DS2v3 size, guest metrics enabled, performance counters started manually)  
- Installed StressNG on Ubuntu VM to generate 90% memory usage to produce monitoring data.  
- Created Automation Account named "DAX Automation" linked to resource group "DAX" for update management and runbooks.  
- Created Log Analytics workspace manually and linked VMs to it for centralized log collection.  
- Ran sample Kusto queries in Log Analytics to check VM availability via heartbeat logs.  
- Created alert rules based on log queries with threshold values.  

**Key Takeaways 🎯**  
- Always ensure the required resource providers (`alertsmanagement` and `insights`) are registered before enabling monitoring features.  
- Guest OS diagnostics require the Azure Monitoring Agent (WAG agent); minimal Linux installs may need manual installation.  
- Use Automation Accounts for patch management and running automated scripts on VMs.  
- Create and link a Log Analytics workspace to collect and query VM logs and metrics effectively.  
- Enable diagnostic settings on VMs to collect guest metrics like memory and disk usage, which are not collected by default.  
- On Windows VMs, start performance counters manually to enable guest metrics collection.  
- Use tools like StressNG to generate load and verify monitoring data collection during exams or practicals.  
- Familiarize yourself with Kusto Query Language (KQL) for querying Azure Monitor Logs.  
- Alerts can be configured based on log queries or metrics to proactively monitor VM health and performance.  
- Be aware that monitoring data may take time to appear after setup; patience is required during troubleshooting.  
- Always clean up resources (resource groups) after practice to avoid unnecessary costs.  

---

### VM CheatSheets

**Timestamp**: 05:27:55 – 05:31:25

**Key Concepts**  
- Azure Virtual Machines (VMs) support both Linux and Windows OS.  
- VM size is determined by the image, which defines vCPUs, memory, and storage capacity.  
- Default VM limit per subscription: 20 VMs per region.  
- VM billing is hourly.  
- Availability: Single instance VM with all premium storage disks offers 99.9% SLA. Two VMs in an availability set also provide 99.9% SLA.  
- Multiple managed disks can be attached to a VM.  
- Networking components (NSGs, NICs, IPs, VNets) are created or associated when a VM is launched.  
- Bring your own Linux by creating a custom virtual hard disk.  
- Azure Compute Unit (ACU) benchmarks CPU performance relative to Standard A1 SKU.  
- Hyper-V virtualization: two generations (Gen 1 supports most OS, Gen 2 supports most 64-bit Windows and modern Linux/FreeBSD).  
- Connection methods to VMs: SSH (port 22), RDP (port 3389), and Azure Bastion (browser-based SSH/RDP).  
- Update Management: manages OS updates/patches for Windows and Linux VMs across Azure, on-premises, or other clouds. Compliance scans run every 12 hours (Windows) or 3 hours (Linux).  

**Definitions**  
- **Azure Virtual Machine (VM)**: A software emulation of a physical computer running an OS, created and managed in Azure.  
- **Image**: A template defining the VM’s OS, vCPU count, memory, and storage configuration.  
- **Availability Set**: A grouping of VMs to ensure higher availability and redundancy.  
- **Azure Compute Unit (ACU)**: A relative measure of CPU performance across Azure VM SKUs benchmarked against Standard A1.  
- **Hyper-V**: Microsoft’s hardware virtualization technology to create and run virtual machines.  
- **SSH (Secure Shell)**: A protocol for secure command-line access to Linux VMs, using port 22 and RSA key pairs.  
- **RDP (Remote Desktop Protocol)**: A graphical protocol to connect remotely to Windows VMs, using port 3389 TCP/UDP.  
- **Azure Bastion**: A managed PaaS service that enables secure browser-based SSH and RDP access to VMs without exposing public IPs or requiring client software.  
- **Update Management**: Azure service to scan and apply OS updates and patches on VMs across environments, with compliance scan intervals.  

**Key Facts**  
- VM limit: 20 per region per subscription.  
- Single VM SLA with premium disks: 99.9%.  
- Two VMs in availability set SLA: 99.9%.  
- SSH uses port 22; RDP uses port 3389 (TCP/UDP).  
- Update compliance scans: every 12 hours for Windows, every 3 hours for Linux.  
- Update dashboard data latency: 30 minutes to 6 hours after scan.  

**Examples**  
- None explicitly mentioned beyond general use cases (Linux and Windows VMs, custom Linux VHD).  

**Key Takeaways 🎯**  
- Remember the VM limit per region (20).  
- Know the SLA differences: single VM with premium disks vs. availability set.  
- Understand the ports and protocols for VM access: SSH (22), RDP (3389).  
- Azure Bastion is important for secure, browser-based VM access without client software.  
- Update Management is critical for maintaining VM OS compliance and patching across environments.  
- ACU helps compare CPU performance across VM SKUs—Standard A1 is the baseline.  
- Distinguish Hyper-V generations and their OS support, but note Azure Hyper-V differs from on-prem Hyper-V.

---

### Intro

**Timestamp**: 05:31:25 – 05:32:56

**Key Concepts**  
- Azure Managed Disks are virtual block-level storage volumes used by Azure VMs.  
- Managed disks abstract away the underlying hardware, simplifying disk management.  
- High availability and durability are ensured by Azure through data replication.  
- Managed disks integrate with Azure features like availability sets, availability zones, backup, and RBAC.  
- Encryption options for disks include server-side encryption and Azure Disk Encryption.

**Definitions**  
- **Azure Managed Disks (Azure Disks)**: Block-level storage volumes managed by Azure, used as virtual hard drives for Azure VMs.  
- **Server-Side Encryption (SSE)**: Encryption at rest enabled by default for managed disk snapshots and images to meet security compliance.  
- **Azure Disk Encryption (ADE)**: Encryption solution that encrypts OS and data disks of IaaS virtual machines.  

**Key Facts**  
- Managed disks offer 99.999% availability.  
- Azure creates 3 replicas of managed disk data for durability.  
- You can create up to 50 VM disks per subscription per region.  
- Scale sets can have up to 1,000 virtual machines using marketplace images.  
- Managed disks support integration with availability sets and availability zones.  
- Azure Backup supports time-based backups and retention policies for managed disks.  
- RBAC can assign specific permissions on managed disks to users.  
- VHDs can be directly imported into Azure disks.  
- Azure Private Link can be used to keep traffic between disks and VMs within Microsoft’s network.  
- Temporary disks are not encrypted by SSE unless encryption at the host is enabled.  
- Encryption keys can be platform-managed (by Azure) or customer-managed.

**Examples**  
- None mentioned explicitly.

**Key Takeaways 🎯**  
- Remember that Azure Managed Disks provide highly available, durable, and managed block storage for VMs without hardware management.  
- Know the difference between server-side encryption (default, at rest) and Azure Disk Encryption (encrypts OS/data disks).  
- Be aware of the limits: 50 disks per subscription per region, and 1,000 VMs in a scale set.  
- Understand integration points: availability sets/zones, backup, RBAC, and private links for secure traffic.  
- Encryption keys management options (platform vs customer) are important for compliance and security.

---

## Disks

---

### Encryption

**Timestamp**: 05:32:56 – 05:34:01  

**Key Concepts**  
- Two types of disk encryption in Azure: Server-Side Encryption (SSE) and Azure Disk Encryption (ADE)  
- SSE provides encryption at rest and is enabled by default for managed disk snapshots and images  
- ADE encrypts OS and data disks for IaaS virtual machines  
- Encryption keys can be platform-managed or customer-managed  

**Definitions**  
- **Server-Side Encryption (SSE)**: Encryption at rest for managed disk snapshots and images, enabled by default, safeguarding data to meet security compliance. Temporary disks are not encrypted by SSE unless encryption at the host is enabled.  
- **Azure Disk Encryption (ADE)**: Encryption solution for OS and data disks on Azure IaaS VMs; uses BitLocker for Windows and DMcrypt for Linux.  
- **Platform-Managed Keys**: Encryption keys managed by Azure.  
- **Customer-Managed Keys**: Encryption keys managed by the customer.  

**Key Facts**  
- SSE is enabled by default for all managed disk snapshots and images.  
- Temporary disks are not encrypted by SSE unless encryption at the host is enabled.  
- ADE supports encryption of OS and data disks on Azure IaaS virtual machines.  
- Windows VMs use BitLocker for disk encryption; Linux VMs use DMcrypt.  

**Examples**  
- None specifically mentioned within this time range.  

**Key Takeaways 🎯**  
- Remember the distinction between SSE (default encryption at rest) and ADE (encryption of OS/data disks on VMs).  
- Know that temporary disks are not encrypted by SSE by default.  
- Understand the difference between platform-managed and customer-managed keys for encryption.  
- ADE uses BitLocker for Windows and DMcrypt for Linux virtual machines.

---

### Disk Roles

**Timestamp**: 05:34:01 – 05:35:42

**Key Concepts**  
- Azure virtual machines use three types of disk roles: Data disk, OS disk, and Temporary disk.  
- Each disk role serves a specific purpose related to storage and VM operation.  
- These disks can be viewed in Windows Disk Management when connected to a VM.  

**Definitions**  
- **Data Disk**: A managed disk attached to a VM for storing application and user data. Registered as an SCSI drive and labeled with a drive letter.  
- **OS Disk**: The operating system disk attached to every VM containing the boot volume and pre-installed OS selected during VM creation.  
- **Temporary Disk**: A non-managed disk providing short-term storage for temporary data like page or swap files. Data may be lost during maintenance or redeployment but persists through standard reboots.  

**Key Facts**  
- Data disks:  
  - Maximum capacity of 32 GB (note: this may be a transcript error or outdated; typically data disks can be larger, but only what was stated is included here).  
  - Number and type of data disks depend on the VM size.  
- OS disk:  
  - Maximum capacity of 4 GB (as per transcript).  
  - Contains the boot volume and OS.  
- Temporary disk:  
  - Not a managed disk.  
  - Used for short-term storage such as page or swap files.  
  - Data can be lost during maintenance or redeployment but persists after normal reboots.  
  - Typically mounted as `/dev/sdb` on Linux.  
  - Assigned to the D: drive on Windows.  
- Encryption: These disks are not encrypted with Storage Encryption (SE) unless host-level encryption is enabled.  

**Examples**  
- Viewing disk roles by spinning up a Windows 10 Pro server VM and checking Disk Management to see OS disk, temporary disk, and data disk.  
- Temporary disk mount points: `/dev/sdb` on Linux and D: drive on Windows.  

**Key Takeaways 🎯**  
- Remember the three disk roles and their purposes: OS disk (boot and OS), data disk (persistent application data), and temporary disk (ephemeral storage).  
- Temporary disk data is not guaranteed to persist through maintenance or redeployment—do not store critical data here.  
- Data disks are managed and attached as SCSI drives with configurable drive letters.  
- OS disk contains the boot volume and is essential for VM operation.  
- Encryption is not enabled by default on these disks unless host-level encryption is configured—important for security considerations.  
- Practical exam tip: Knowing the typical mount points and drive letters for temporary disks on Linux and Windows can help in troubleshooting or configuration questions.

---

### Managed Disk Snapshots Managed Custom Image

**Timestamp**: 05:35:42 – 05:37:07

**Key Concepts**  
- Managed disk snapshots and managed custom images are related but serve different purposes.  
- Snapshots are read-only, crash-consistent, point-in-time copies of a single managed disk.  
- Managed custom images capture all managed disks attached to a VM (OS and data disks) as a single image.  
- Snapshots exist independently of the source disk and can be used to create new managed disks.  
- Snapshots are billed based on the used size of the disk, not the allocated size.  
- Managed custom images are necessary when coordination of multiple disks is required (e.g., disk striping).  
- Snapshots do not support coordination between multiple disks.  

**Definitions**  
- **Managed Disk Snapshot**: A read-only, crash-consistent full copy of a single managed disk stored as a standard disk, used for point-in-time recovery.  
- **Managed Custom Image**: An image that contains all managed disks (OS and data disks) associated with a VM, used to capture the entire VM disk configuration.  

**Key Facts**  
- Snapshots are billed only for the used space (e.g., if a 24 GB disk uses 10 GB, billing is for 10 GB).  
- Snapshots are suitable for copying individual disks (e.g., a single data disk).  
- Managed custom images are required when multiple disks need to be captured together for scenarios like striping.  
- Snapshots do not support multi-disk coordination.  

**Examples**  
- Use snapshots to copy a single data disk.  
- Use managed custom images when you need to capture all disks of a VM together.  

**Key Takeaways 🎯**  
- Remember that snapshots are disk-level, point-in-time copies and are independent of the source disk.  
- Snapshots are cost-efficient as billing is based on used space, not total disk size.  
- Use managed custom images when you need to capture the entire VM disk setup, including OS and multiple data disks.  
- Snapshots cannot coordinate multiple disks, so they are not suitable for multi-disk scenarios like striping.  
- Understand when to choose snapshots vs. managed custom images based on your backup or deployment needs.  

---

### Disk Types

**Timestamp**: 05:37:07 – 05:40:35

**Key Concepts**  
- Azure managed disks come in four tiers, each with different performance and cost characteristics.  
- Disk tiers affect throughput, IOPS, latency, and VM compatibility.  
- Disk bursting allows temporary performance boosts for IOPS and throughput without permanently upgrading disks.  

**Definitions**  
- **Ultra Disk**: High throughput, high IOPS, and consistently low latency disk storage for Azure VMs. Suitable for data-intensive workloads (e.g., SAP HANA, top-tier databases, transaction-heavy workloads). Only usable as data disks and supported on specific VM series. Performance can be dynamically changed without VM restart.  
- **Premium SSD**: High-performance, low-latency disks designed for mission-critical workloads requiring guaranteed IOPS and throughput. Compatible only with premium storage-supported VM series. Provides low single-digit millisecond latency.  
- **Standard SSD**: Cost-effective storage optimized for workloads needing consistent performance but lower IOPS than Premium SSD. Suitable for web servers, low IOPS app servers, lightly used enterprise apps, and dev/test workloads. Provides single-digit millisecond latency with better availability and reliability than HDD.  
- **Standard HDD**: Lowest cost tier, reliable but with variable latency, IOPS, and throughput. Suitable for latency-insensitive workloads. Available for all VMs and regions.  

**Key Facts**  
- Ultra Disk supports dynamic performance scaling without VM restart but only as data disks.  
- Premium SSD guarantees IOPS and throughput; standard tiers do not guarantee IOPS.  
- Typical max IOPS values to remember:  
  - Premium SSD starts at ~20,000 IOPS  
  - Ultra Disk can go up to 160,000 IOPS  
- Maximum disk size across tiers is roughly 32,767 GB.  
- Maximum throughput examples:  
  - Standard HDD: lower throughput, variable performance  
  - Premium SSD: up to 900 MB/s  
  - Ultra Disk: up to 2,000 MB/s  
- Standard HDD designed for write latency under 10 ms and read latency under 20 ms for most I/O operations.  
- Bursting allows temporary increase in disk IOPS and throughput to handle unexpected traffic without upgrading disk tier. Bursting on disks and VMs are independent features.  

**Examples**  
- Ultra Disk recommended for SAP HANA, top-tier databases, and transaction-heavy workloads.  
- Premium SSD recommended for mission-critical applications requiring guaranteed performance.  
- Standard SSD suitable for web servers, low IOPS app servers, dev/test environments.  
- Standard HDD used by small startups or for non-critical, latency-insensitive workloads.  

**Key Takeaways 🎯**  
- Remember the four disk tiers: Ultra Disk, Premium SSD, Standard SSD, Standard HDD, each with distinct performance and cost profiles.  
- Premium SSD starts at ~20,000 IOPS — a key number to recall for exams.  
- Ultra Disk offers the highest performance but limited VM compatibility and only as data disks.  
- Standard HDD is the lowest cost but with variable and higher latency, suitable for less critical workloads.  
- Use bursting to handle temporary spikes in disk performance without upgrading permanently.  
- Always check VM compatibility before selecting Ultra Disk or Premium SSD tiers.  
- Choose disk tier based on workload criticality, performance needs, and cost constraints.

---

### Bursting

**Timestamp**: 05:40:35 – 05:41:48

**Key Concepts**  
- Bursting is a performance feature for both virtual machines (VMs) and disk storage.  
- It temporarily boosts performance metrics such as IOPS (Input/Output Operations Per Second) and throughput (MB/s) for disks, and CPU utilization for VMs.  
- Bursting helps handle unexpected spikes in disk or VM workload without needing to permanently upgrade resources.  
- Bursting for disks and VMs operate independently but can be combined depending on use case.  

**Definitions**  
- **Bursting (Disks)**: Temporary increase in disk IOPS and throughput to handle sudden increases in disk traffic.  
- **Bursting (VMs)**: Temporary boost in CPU performance and related resources for virtual machines.  

**Key Facts**  
- Burstable VMs require specific VM series that support bursting: VSV2, DS3, and ESV3 series.  
- Bursting is enabled by default on VMs that support it.  
- For premium SSD disks, bursting is available and enabled by default on disk sizes P20 and smaller, across all regions.  

**Examples**  
- None explicitly mentioned beyond the VM series and disk size specifications.  

**Key Takeaways 🎯**  
- Understand that bursting is a cost-effective way to handle workload spikes without permanent upgrades.  
- Know which VM series support bursting (VSV2, DS3, ESV3).  
- Remember bursting is enabled by default on supported VMs and disks (premium SSDs P20 and smaller).  
- Bursting on disks and VMs are independent features; you can have one without the other.  
- Useful for exam scenarios involving performance optimization and cost management in Azure environments.

---

### Attaching Partitioning and Mounting a Disk

**Timestamp**: 05:41:48 – 06:01:36

**Key Concepts**  
- Attaching additional disks to Azure VMs after creation  
- Partitioning disks using Linux `parted` command  
- Creating a Linux file system on the partition with `mkfs` (XFS)  
- Informing the OS of partition table changes with `partprobe`  
- Mounting the partition to a directory using `mount`  
- Creating mount points with `mkdir`  
- Persisting disk mounts across reboots by editing `/etc/fstab` with UUIDs  
- Using `blkid` to find disk UUIDs for `/etc/fstab` entries  
- Checking mounted disks and usage with `df -h` and `grep`  
- Creating snapshots of managed disks in Azure for backup  
- Attaching and partitioning disks on Windows VMs using PowerShell commands  
- Formatting disks in Windows via Disk Management GUI or PowerShell  
- Differences in disk attachment and formatting between Linux and Windows VMs  

**Definitions**  
- **Managed Disk**: Azure-managed block-level storage volumes used by VMs, providing high durability and availability.  
- **Partitioning**: Dividing a disk into sections that can be formatted and used separately.  
- **Mounting**: Attaching a file system to a directory so it can be accessed by the OS.  
- **UUID (Universally Unique Identifier)**: A unique identifier for a disk partition used in `/etc/fstab` to ensure consistent mounting.  
- **`parted`**: A Linux command-line tool used for disk partitioning.  
- **`mkfs`**: Command to create a file system on a partition (e.g., `mkfs.xfs`).  
- **`partprobe`**: Command to inform the OS kernel of partition table changes.  
- **`/etc/fstab`**: File that defines how disk partitions and other file systems are mounted at boot.  
- **Snapshot**: A point-in-time backup of an Azure managed disk, can be full or incremental.  

**Key Facts**  
- Disk names in Linux follow the pattern `/dev/sdX` where `X` is a letter (a, b, c, d...) representing the disk order. Partitions add a number suffix (e.g., `/dev/sdc1`).  
- Use `sudo parted /dev/sdc --script mklabel gpt` to create a GPT partition table on the disk.  
- Use `sudo mkfs.xfs /dev/sdc1` to format the partition with the XFS file system.  
- Use `sudo partprobe` to notify the OS of partition changes.  
- Mount point directories can be created anywhere, e.g., `/DAX`.  
- Use `sudo mount /dev/sdc1 /DAX` to mount the partition.  
- To make mounts persistent, add an entry in `/etc/fstab` using the disk’s UUID, mount point, file system type, and options like `defaults,nofail 1 2`.  
- Use `sudo blkid` to find UUIDs of partitions.  
- Snapshots can be created from the Azure portal, choosing full or incremental backup types.  
- Windows disk initialization and partitioning can be done via PowerShell using `Get-Disk`, `Initialize-Disk`, `New-Partition`, and `Format-Volume`.  
- Windows disks can also be formatted via Disk Management GUI with quick format option.  

**Examples**  
- Creating and attaching a second disk (standard SSD) to an Ubuntu VM named DAX.  
- Partitioning the disk `/dev/sdc` using `parted` and formatting it with XFS.  
- Mounting the partition to `/DAX` and verifying with `df -h | grep sd`.  
- Editing `/etc/fstab` to add the UUID entry for automatic mounting on reboot.  
- Creating a snapshot named "my disk backup" of the attached disk in Azure portal.  
- Attaching a disk to a Windows Server VM, initializing and formatting it using PowerShell commands and Disk Management GUI.  

**Key Takeaways 🎯**  
- Know the Linux commands for partitioning (`parted`), formatting (`mkfs`), and mounting (`mount`, `mkdir`).  
- Understand the importance of updating `/etc/fstab` with UUIDs to persist mounts after reboot.  
- Be familiar with how to find disk UUIDs using `blkid`.  
- Remember that disk names in Linux follow `/dev/sdX` convention.  
- Snapshots provide a way to back up managed disks and can be full or incremental.  
- Windows disk management differs; PowerShell commands and GUI tools are used for partitioning and formatting.  
- Practice the process of attaching, partitioning, mounting, and backing up disks in both Linux and Windows Azure VMs for exam readiness.  
- Don’t memorize exact commands but understand the workflow and purpose of each step.  
- Using `&&` in Linux command lines ensures sequential execution only if the previous command succeeds, which is preferable to `;`.  

---

These notes cover the practical steps and concepts needed for exam questions related to attaching, partitioning, mounting, and backing up Azure VM disks.

---

### Disks CheatSheet

**Timestamp**: 06:01:36 – 06:06:20

**Key Concepts**  
- Azure Managed Disks are block-level storage volumes managed by Azure, used within Azure VMs.  
- Managed Disks provide high availability with 99.999% uptime by maintaining 3 replicas of data.  
- Integration with Availability Sets and Availability Zones for resilience.  
- Role-Based Access Control (RBAC) can assign specific permissions to managed disks.  
- Azure Backup supports time-based backups and retention policies for managed disks.  
- Two types of encryption for managed disks: Server-Side Encryption (SSE) by default and optional encryption at the host.  
- Azure Disk Encryption uses BitLocker for Windows and DMcrypt for Linux to encrypt OS and data disks.  
- Three main disk roles: OS disk, Data disk, and Temporary disk.  
- Temporary disks provide short-term storage, are not managed disks, and data may be lost during maintenance or VM redeployment.  
- Managed disk snapshots are read-only, crash-consistent full copies used for point-in-time recovery and billed based on used size.  
- Managed custom images can capture all managed disks (OS + data) of a VM for reuse.  
- Azure offers four disk performance tiers: Ultra, Premium SSD, Standard SSD, and Standard HDD, each optimized for different workload needs.

**Definitions**  
- **Azure Managed Disks**: Block-level storage volumes managed by Azure, used as VM disks with built-in replication for durability.  
- **Data Disk**: Managed disk attached to a VM to store application or user data; size and number depend on VM size.  
- **OS Disk**: The managed disk containing the operating system and boot volume of a VM; max capacity mentioned as 4 GB (likely a transcript error, typically larger).  
- **Temporary Disk**: Non-managed disk providing ephemeral storage for page or swap files; data may be lost on maintenance or redeployment.  
- **Managed Disk Snapshot**: Read-only, crash-consistent full copy of a managed disk used for backup or creating new disks.  
- **Managed Custom Image**: Image capturing all managed disks (OS + data) of a VM for creating new VMs with the same configuration.  
- **Server-Side Encryption (SSE)**: Default encryption for managed disks using platform-managed or customer-managed keys.  
- **Azure Disk Encryption**: Encryption of OS and data disks using BitLocker (Windows) or DMcrypt (Linux).  

**Key Facts**  
- Azure Managed Disks provide 99.999% availability with 3 replicas of data.  
- Up to 50,000 managed disks per subscription per region.  
- Temporary disks are typically mounted as `/dev/sdb` on Linux and `D:` drive on Windows.  
- Temporary disks are not encrypted by default with SSE unless encryption at the host is enabled.  
- Snapshots are billed based on the actual used size, not the provisioned size (e.g., 64 GB disk with 10 GB used billed for 10 GB).  
- Four disk tiers:  
  - **Ultra Disk**: High throughput, high IOPS, low latency for demanding workloads.  
  - **Premium SSD**: High performance and low latency for IO-intensive workloads.  
  - **Standard SSD**: Cost-effective with consistent performance at lower IOPS.  
  - **Standard HDD**: Low-cost, reliable for latency-insensitive workloads.  

**Examples**  
- Temporary disk usage: storing page or swap files; data loss possible during maintenance.  
- Snapshot billing example: 64 GB disk with only 10 GB used is billed for 10 GB snapshot size.  
- Encryption example: Windows VMs use BitLocker; Linux VMs use DMcrypt for disk encryption.  

**Key Takeaways 🎯**  
- Know the three disk types and their roles: OS disk (boot volume), data disk (application data), temporary disk (ephemeral storage).  
- Understand the difference between snapshots (single disk) and managed custom images (multiple disks).  
- Remember that temporary disks are not backed up or encrypted by default and data can be lost on maintenance.  
- Be familiar with the four disk tiers and their use cases to select the right disk type for workload needs.  
- Snapshots are cost-efficient as they are billed on used space, not provisioned size.  
- Azure Disk Encryption differs by OS: BitLocker for Windows, DMcrypt for Linux.  
- RBAC can be applied specifically to managed disks for fine-grained access control.  
- Managed disks integrate with availability sets and zones to ensure high availability and durability.

---

### Intro

**Timestamp**: 06:06:20 – 06:08:47

**Key Concepts**  
- Azure Application Gateway is a load balancer operating at OSI Layer 7 (Application Layer).  
- It performs application-level routing based on HTTP requests.  
- Application Gateway can inspect HTTP request contents such as URL paths, cookies, and apply Web Application Firewall (WAF) policies.  
- Configuration involves setting up a frontend, routing rules, and backend pools.  
- Frontend IP can be either private (internal load balancer) or public (external load balancer).  
- Backend pools are collections of resources (VMs, VM scale sets, IP addresses, domain names, app services, possibly on-premises).  
- Routing rules connect frontend listeners to backend pools and define how traffic is forwarded.  
- Listeners monitor specified ports and IPs for incoming traffic using defined protocols.  
- Routing rules come in two types:  
  - Basic: forwards all requests to a backend pool regardless of domain.  
  - Multi-site: forwards requests to different backend pools based on host headers or host names.  
- Priority/order of routing rules matters; basic rules should be last to avoid capturing all traffic prematurely.

**Definitions**  
- **Application Gateway**: Azure’s Layer 7 load balancer that routes HTTP requests based on application-level information.  
- **Frontend**: The IP configuration (public or private) that receives incoming traffic for the Application Gateway.  
- **Backend Pool**: A group of resources (VMs, scale sets, IPs, etc.) that receive traffic from the Application Gateway.  
- **Listener**: Component that listens on a specific port and IP for incoming traffic using a specified protocol.  
- **Routing Rule**: Logic that connects frontend listeners to backend pools and determines how requests are forwarded.  
- **Basic Routing Rule**: Forwards all requests to a single backend pool.  
- **Multi-site Routing Rule**: Routes requests to different backend pools based on host headers or host names.

**Key Facts**  
- Application Gateway operates at OSI Layer 7 (Application Layer).  
- Frontend IP options:  
  - Private IP → internal load balancer  
  - Public IP → external load balancer  
- Backend pools can include VMs, VM scale sets, IP addresses, domain names, app services, and possibly on-premises resources.  
- Routing rules must be prioritized; basic rules should be last in order.

**Examples**  
- Routing based on URL path:  
  - Requests with path `/payments` routed to payment system VM.  
  - Requests with path `/admin` routed to admin VM.  
- Applying WAF policies to filter malicious HTTP traffic.  
- Backend pools containing various resource types to receive traffic.

**Key Takeaways 🎯**  
- Understand that Application Gateway is a Layer 7 load balancer focused on HTTP traffic inspection and routing.  
- Know the difference between frontend IP types and their impact (internal vs external load balancer).  
- Be able to explain backend pools and what resources they can contain.  
- Remember the two types of routing rules (basic and multi-site) and their use cases.  
- Routing rules order is important—basic rules should be last to avoid capturing all traffic prematurely.  
- Application Gateway can apply advanced routing logic based on URL paths, host headers, cookies, and WAF policies—important for exam scenarios involving application-level traffic management.

---

## Application Gateway

---

### Routing Rules

**Timestamp**: 06:08:47 – 06:11:43

**Key Concepts**  
- Routing rules determine how incoming traffic is directed to backend pools or redirections.  
- A listener listens on a specified port, IP address, and protocol to capture traffic.  
- Routing rules are applied when listener criteria are met.  
- Two types of routing rules: Basic and Multi-site.  
- HTTP settings define how requests are handled for backend pools.  

**Definitions**  
- **Listener**: Component that listens on a specified port and IP address for traffic using a specified protocol.  
- **Routing Rule**: Logic that decides where to forward incoming requests based on listener criteria.  
- **Basic Routing Rule**: Forwards all requests for any domain to a single backend pool (catch-all).  
- **Multi-site Routing Rule**: Forwards requests to different backend pools based on host header or hostname.  
- **Backend Pool**: A collection of resources (VMs, IPs, app services, etc.) that receive traffic.  
- **HTTP Settings**: Configuration that controls how HTTP requests are handled when routed to backend pools.  
- **Redirection**: HTTP redirection response (e.g., 403, temporary, permanent) instead of forwarding to backend.  

**Key Facts**  
- Basic routing rules should be placed last in priority because they catch all traffic.  
- Backend port is usually 80 (HTTP) or 443 (HTTPS), depending on where SSL termination occurs.  
- Cookie-based affinity keeps user sessions on the same backend server by persisting cookies.  
- Connection draining gracefully removes backend pool members during updates by waiting for existing connections to close before stopping traffic to them.  
- Request timeout specifies how many seconds the gateway waits for a backend response before timing out.  
- Override backend path allows routing requests for one URL path to a different internal path.  
- Override host name is used to modify the host header, useful for multi-tenant services like App Service or API Management.  

**Examples**  
- Basic rule acts as a catch-all and should be last in priority order.  
- Multi-site routing can forward requests based on host headers to different backend pools.  
- Override backend path example: routing requests for `/bananas` internally to `/oranges` or `/plantains`.  
- Override host name example: changing host headers for multi-tenant services requiring specific host headers.  

**Key Takeaways 🎯**  
- Always place the basic routing rule last to avoid it capturing all traffic prematurely.  
- Understand the difference between basic and multi-site routing rules for domain-based traffic routing.  
- Configure HTTP settings carefully: backend port, cookie affinity, connection draining, timeouts, and path/host overrides are critical for smooth operation.  
- Use connection draining to avoid dropping user connections during backend updates.  
- Use override backend path and host name features to support complex routing scenarios and multi-tenant services.  
- Remember that routing rules are central to how Application Gateway directs traffic at Layer 7 (application layer).  

---

### AGW CheatSheet

**Timestamp**: 06:11:43 – 06:13:20

**Key Concepts**  
- Azure Application Gateway (AGW) operates at OSI Layer 7 (Application Layer) for application-level routing and load balancing.  
- AGW can have a Web Application Firewall (WAF) attached for enhanced security.  
- AGW components include:  
  - **Front-ends**: Choose IP address type (private or public).  
  - **Backend pools**: Collections of resources (VMs, VM scale sets, IP addresses, domain names, or app services) that receive routed traffic.  
  - **Routing rules**: Made up of listeners, backend targets, and HTTP settings.  
- Listeners monitor specific IP/port/protocol combinations and trigger routing rules. Two types: basic and multi-site.  
- Routing rules are processed in order; basic listeners should be added last to avoid capturing all requests prematurely.  
- Backend targets specify where traffic is routed—either to backend pools or redirections.  
- HTTP settings define how requests are handled (cookies, connection draining, ports, timeouts, etc.).

**Definitions**  
- **Azure Application Gateway**: A Layer 7 load balancer and application-level routing service in Azure.  
- **Listener**: A configuration that listens on a specific IP, port, and protocol to match incoming requests.  
- **Backend Pool**: A group of backend resources (VMs, scale sets, IPs, domain names, app services) that receive traffic from the gateway.  
- **HTTP Settings**: Configuration settings that control how the Application Gateway communicates with backend targets (e.g., cookie handling, connection draining, timeouts).  
- **Multi-site Listener**: A listener that can route traffic based on host headers for multiple sites.  
- **Basic Listener**: A simple listener that listens on a single IP and port.

**Key Facts**  
- AGW operates at OSI Layer 7 (application layer).  
- Backend pools can include: VM, VM scale set, IP address, domain name, or app service.  
- Listener types: basic and multi-site; order of rules matters (basic listeners last).  
- HTTP settings control detailed request handling (cookies, draining, ports, timeouts).  

**Examples**  
- None explicitly mentioned in this segment, but a practical note on overriding host names for multi-tenant services like App Service or API Management was referenced just before this section.

**Key Takeaways 🎯**  
- Remember AGW is a Layer 7 load balancer with WAF capabilities.  
- Understand the three main components: front-end IPs, backend pools, and routing rules.  
- Know the difference between basic and multi-site listeners and the importance of rule order.  
- HTTP settings are critical for managing backend communication behavior.  
- Backend pools are flexible and can include various resource types.  
- Overriding host names is important when routing to multi-tenant services (though this was just prior to the section).

---

## Scale Sets

---

### Intro to Scale Sets

**Timestamp**: 06:13:20 – 06:14:18

**Key Concepts**  
- Azure Scale Sets automatically increase or decrease virtual machine (VM) capacity based on demand.  
- Scale policies use host metrics (e.g., CPU utilization, network in) to trigger scaling actions.  
- Health checks and repair policies help maintain VM instance health by replacing unhealthy instances.  
- Load balancers can be associated with scale sets to distribute traffic evenly across VMs and availability zones.  
- Scale sets support scaling up to hundreds or thousands of VMs (e.g., 100 to 1,000 VMs).  

**Definitions**  
- **Azure Scale Sets**: A service that allows automatic scaling of identical VMs to match workload demand, improving availability and cost efficiency.  
- **Scale Policies**: Rules that define when and how to add or remove VM instances based on monitored metrics.  
- **Repair Policy**: Configuration that automatically replaces unhealthy VM instances within a scale set.  
- **Load Balancer**: A service that distributes incoming traffic evenly across multiple VMs to ensure high availability and reliability.  

**Key Facts**  
- Scale sets can scale to 100 or even 1,000 VMs.  
- Associating a load balancer with a scale set helps distribute VMs across multiple availability zones (AZs) for high availability.  
- Recommended practice: run application workloads in scale sets behind load balancers.  
- Running 3 VMs across 3 availability zones is a common pattern to achieve high availability.  
- Load balancer probe checks provide more robust health monitoring than scale set health checks alone.  

**Examples**  
- Example scenario: A web application behind an application load balancer experiences increased traffic, triggering the scale set to add more identical VMs automatically. When traffic decreases, VMs are removed to save costs.  

**Key Takeaways 🎯**  
- Understand that Azure Scale Sets enable automatic VM scaling based on real-time metrics to handle variable workloads efficiently.  
- Always associate scale sets with load balancers to ensure even traffic distribution and high availability across availability zones.  
- Know that scale sets support large-scale deployments (up to thousands of VMs).  
- Remember to configure health checks and repair policies to maintain VM health and availability.  
- For exam scenarios, expect questions on how scale sets integrate with load balancers and availability zones to provide scalable and resilient infrastructure.

---

### Associate a Load Balancer

**Timestamp**: 06:14:18 – 06:15:24

**Key Concepts**  
- Associating a load balancer with Azure scale sets helps distribute virtual machines (VMs) evenly across availability zones.  
- Load balancers improve high availability by spreading VMs across multiple zones (e.g., 3 VMs across 3 availability zones).  
- Load balancer health probes provide more robust health checks than scale set health checks.  
- Two main types of Azure load balancers:  
  - Application Gateway: for HTTP/HTTPS (web traffic) load balancing.  
  - Azure Load Balancer: supports TCP and UDP network traffic.  
- Choice of load balancer depends on the OSI layer and traffic type you need to manage.

**Definitions**  
- **Load Balancer**: A service that distributes incoming network traffic across multiple VMs to ensure reliability and availability.  
- **Application Gateway**: A layer 7 load balancer designed for web traffic (HTTP/HTTPS).  
- **Azure Load Balancer**: A layer 4 load balancer that handles TCP and UDP traffic.

**Key Facts**  
- Scale sets can scale up to 100 or even 1,000 VMs.  
- Best practice is to run application workloads in scale sets behind a load balancer for high availability.  
- Load balancer probes offer enhanced health monitoring compared to scale set health checks.  
- Distributing VMs across multiple availability zones (e.g., 3 VMs in 3 AZs) is recommended for high availability.

**Examples**  
- None explicitly mentioned beyond the general recommendation to run 3 VMs across 3 availability zones behind a load balancer.

**Key Takeaways 🎯**  
- Always associate a load balancer with scale sets to ensure even VM distribution and high availability.  
- Understand the difference between Application Gateway (web traffic) and Azure Load Balancer (network traffic) to choose the correct load balancer type.  
- Use load balancer health probes for more reliable health checks than scale set defaults.  
- Designing for high availability means deploying VMs across multiple availability zones behind a load balancer.

---

### Scaling Policy

**Timestamp**: 06:15:24 – 06:18:51

**Key Concepts**  
- Scaling policies determine when to add (scale out) or remove (scale in) virtual machines in a scale set to meet demand.  
- Scaling out increases capacity by adding VM instances; scaling in decreases capacity by removing VM instances.  
- Metrics drive scaling decisions, commonly CPU usage, network in/out, disk read/write.  
- Aggregates and operators (e.g., greater than, greater than or equal to) refine when scaling triggers occur.  
- Actions specify how many VMs to add or remove, either by fixed count or percentage.  
- Scale-in policies define which VM instance to remove when scaling in (e.g., highest instance ID, newest VM, oldest VM), considering availability zones.  
- Update policies control how VM instances are updated to the latest scale set model: automatic, manual, or rolling updates.  
- Automatic OS upgrades can be enabled to safely update OS disks across instances.  

**Definitions**  
- **Scaling Out**: Adding VM instances to a scale set to increase capacity.  
- **Scaling In**: Removing VM instances from a scale set to decrease capacity.  
- **Scale-in Policy**: Rules that determine which VM instance is removed during scale-in operations.  
- **Update Policy**: Defines how VM instances receive updates to the scale set model (automatic, manual, rolling).  

**Key Facts**  
- Initial scaling policy setup uses a simple wizard focusing on CPU threshold as the metric.  
- More advanced scaling policies allow selection from built-in host metrics: CPU, network in/out, disk read/write.  
- Scaling actions can be specified as a fixed number of VMs or as a percentage increase/decrease (e.g., increase by 30% adds 3 VMs if you have 10).  
- Scale-in options include deleting the VM with the highest instance ID (default), newest VM, or oldest VM, all balancing across availability zones.  
- Update policies include:  
  - Automatic: upgrades start immediately, randomly or in order.  
  - Manual: requires manual upgrade of instances.  
  - Rolling: upgrades in batches with optional pauses.  
- Automatic OS upgrades can be enabled to ease update management by safely upgrading OS disks for all instances.  

**Examples**  
- Increasing load by 30% on 10 servers results in adding 3 additional servers.  
- Scale-in policy default deletes the VM with the highest instance ID while balancing across availability zones.  

**Key Takeaways 🎯**  
- Understand the difference between scaling out (adding VMs) and scaling in (removing VMs).  
- Know the common metrics used to trigger scaling actions and how aggregates and operators refine these triggers.  
- Remember scale-in policies affect which VM is removed and can impact availability zone balancing.  
- Be familiar with update policies and the benefits of automatic OS upgrades for scale sets.  
- Scaling policies start simple but become highly customizable after initial creation—know both basic and advanced options.

---

### Health Monitoring

**Timestamp**: 06:18:51 – 06:20:18

**Key Concepts**  
- Health monitoring determines if a virtual machine instance is healthy or unhealthy.  
- Health monitoring can be enabled or disabled based on needs.  
- Two modes of health monitoring: Application Health Extension and Load Balancer Probe.  
- Automatic repair policy can replace unhealthy instances by terminating and relaunching them.  

**Definitions**  
- **Health Monitoring**: A feature that checks the health status of VM instances to ensure they are functioning properly.  
- **Application Health Extension**: A mode where an HTTP/HTTPS request is sent to a specific path on the VM, expecting a specific status code (e.g., 200) to confirm health.  
- **Load Balancer Probe**: A health check mode that uses TCP, UDP, or HTTP requests through an associated load balancer to determine instance health.  

**Key Facts**  
- Application Health Extension expects a specific HTTP status code (commonly 200) to mark an instance as healthy.  
- Load Balancer Probe requires an associated load balancer and is generally more robust than the Application Health Extension.  
- Automatic repair policy is **not enabled by default**; it must be explicitly turned on.  
- When automatic repair detects an unhealthy instance, it terminates and replaces it with a new instance.  

**Examples**  
- Using a custom health check page (e.g., a dedicated “health check” endpoint) to verify instance health via Application Health Extension.  
- Load Balancer Probe checking health via TCP, UDP, or HTTP requests when a load balancer is present.  

**Key Takeaways 🎯**  
- Always consider enabling health monitoring to maintain VM instance reliability.  
- Prefer Load Balancer Probe mode if you have a load balancer, as it provides a more robust health check.  
- Use custom health check pages for more precise application-level health validation.  
- Remember to explicitly enable the automatic repair policy if you want unhealthy instances to be automatically replaced.  
- Health monitoring helps maintain availability and stability in scale sets by detecting and handling unhealthy instances promptly.

---

### Advanced Features

**Timestamp**: 06:20:18 – 06:21:22

**Key Concepts**  
- Allocation policy for scale sets to manage instance placement beyond default limits  
- Proximity placement groups to physically group Azure resources closer together within the same region  
- Single vs multiple placement groups affecting scale set size and VM distribution  

**Definitions**  
- **Allocation Policy**: A setting that allows scale sets to exceed the default limit of 100 instances, enabling scaling up to 1000 instances by managing VM placement.  
- **Proximity Placement Group**: A feature that groups Azure resources physically closer in the same region to reduce latency and improve performance, especially important for high-performance computing (HPC) workloads.  
- **Placement Group**: A logical grouping of VMs within a scale set. By default, a scale set uses a single placement group that can hold up to 100 VMs. Setting `singlePlacementGroup` to false allows multiple placement groups and scaling up to 1000 VMs.  

**Key Facts**  
- Default scale set limit: 100 instances per single placement group  
- Maximum scale set size with multiple placement groups: up to 1000 instances  
- Proximity placement groups improve latency by physically locating VMs closer together in the same Azure region  
- To scale beyond 100 VMs, allocation policy and multiple placement groups must be enabled  

**Examples**  
- None mentioned explicitly, but HPC workloads are cited as a use case for proximity placement groups due to latency sensitivity  

**Key Takeaways 🎯**  
- Remember that scale sets default to a single placement group limited to 100 VMs; to scale beyond this, you must disable single placement group mode and use allocation policies.  
- Use proximity placement groups when low latency and physical proximity of VMs matter, such as in HPC scenarios.  
- Understanding placement groups and allocation policies is critical for managing large-scale VM deployments in Azure.

---

### Scale Sets CheatSheet

**Timestamp**: 06:21:22 – 06:23:06

**Key Concepts**  
- Azure Scale Sets allow automatic scaling of VM capacity (scale out and scale in).  
- Load balancers can be associated with scale sets to evenly distribute VMs across multiple Availability Zones (AZs) for high availability.  
- Scaling policies control when VMs are added or removed based on demand.  
- Scale in policies determine which VMs are removed (default, newest VM, oldest VM).  
- Update policies control how VM instances are updated to the latest scale set model (automatic, manual, rolling).  
- Health monitoring can be enabled to check VM health using application health extensions or load balancer probes.  
- Automatic repair policy can delete and replace unhealthy VM instances.

**Definitions**  
- **Scale Out**: Adding VM instances to increase capacity.  
- **Scale In**: Removing VM instances to decrease capacity.  
- **Application Health Extension**: Health monitoring method that sends HTTP requests to a specific path expecting a status 200 response.  
- **Load Balancer Probe**: Health check method using TCP, UDP, or HTTP requests to verify VM health.  
- **Automatic Repair Policy**: Automatically deletes and replaces unhealthy VM instances.

**Key Facts**  
- By default, a scale set uses a single placement group supporting up to 100 VMs.  
- Setting the scale set property `singlePlacementGroup` to false allows multiple placement groups and scaling up to 1000 VMs.  
- Load balancers help evenly distribute traffic and perform robust health checks.  
- Scale in policies options: default, newest VM, oldest VM.  
- Update policies options: automatic, manual, rolling.  
- Health monitoring modes: application health extension and load balancer probe.

**Examples**  
- None specifically mentioned beyond general usage scenarios (e.g., distributing VMs across AZs for high availability).

**Key Takeaways 🎯**  
- Remember the difference between scale out (add VMs) and scale in (remove VMs).  
- Know the default VM limit per placement group (100) and how to scale beyond that (up to 1000 with multiple placement groups).  
- Understand the importance of load balancers for distributing traffic and performing health probes.  
- Be familiar with scale in policies and update policies options.  
- Health monitoring and automatic repair policies are critical for maintaining VM health and availability.

---

### Intro

**Timestamp**: 06:23:06 – 06:25:02

**Key Concepts**  
- Azure App Service is a Platform as a Service (PaaS) for hosting web apps, REST APIs, and mobile backends.  
- Supports multiple programming languages and can run on Windows or Linux environments.  
- Azure App Service manages underlying infrastructure tasks such as OS and language security patches, load balancing, and auto-scaling.  
- Integrations available with Azure DevOps, GitHub, Docker Hub, and package management.  
- Supports easy setup of staging environments, custom domains, and SSL certificates.  
- Pricing is based on Azure App Service plans with multiple tiers (Shared, Basic, Standard, Premium, Isolated).  
- Supports running Docker containers (single or multi-container).  
- When creating an app, a default domain on azurewebsites.net is assigned, which can be overridden with a custom domain.  
- Runtimes in Azure App Service are predefined containers including programming languages, libraries, and web frameworks.

**Definitions**  
- **Azure App Service**: An HTTP-based PaaS for deploying and managing web applications, REST APIs, and mobile backends without managing infrastructure.  
- **Runtime**: Software instructions executed while a program runs, including the programming language, libraries, and frameworks used. In Azure App Service, runtimes are predefined containers with these components installed.

**Key Facts**  
- Azure App Service supports both Windows and Linux environments.  
- Pricing tiers include Shared (free, no Linux support), Basic, Standard, Premium (versions 1, 2, 3), and Isolated.  
- Azure App Service is comparable to Heroku in terms of PaaS functionality.  
- Docker containers (single or multi) can be run on Azure App Service.  
- Default domain format: [appname].azurewebsites.net.

**Examples**  
- Comparison to Heroku as a similar PaaS offering.  
- Integration examples: Azure DevOps, GitHub, Docker Hub.

**Key Takeaways 🎯**  
- Understand Azure App Service as a PaaS that abstracts infrastructure management for web apps and APIs.  
- Know the pricing tiers and that Shared tier does not support Linux.  
- Remember Azure App Service supports multiple languages and runtimes via predefined containers.  
- Be aware that Docker container deployment is supported.  
- Default domain names can be customized with your own domain and SSL certificates.  
- Runtimes define the environment your app runs in, including language and framework support.

---

## App Service

---

### Runtimes

**Timestamp**: 06:25:02 – 06:26:32

**Key Concepts**  
- A runtime is the software environment that executes your program while it is running.  
- Runtimes define the programming language, libraries, and frameworks used by your application.  
- Azure App Services provide predefined containerized runtimes with common languages and libraries installed.  
- Multiple versions of runtimes are supported, but older versions may be retired to maintain security and modern standards.  
- If a language is not supported natively, you can deploy a custom Docker container with your desired runtime.

**Definitions**  
- **Runtime**: Software instructions executed during program execution, including the programming language, libraries, and frameworks used.  
- **Azure App Services Runtime**: A predefined container environment in Azure that includes specific programming languages and commonly used libraries/frameworks for web applications.

**Key Facts**  
- Supported runtimes include: .NET, .NET Core, Java, Ruby, Node.js, PHP, Python.  
- Azure App Services supports multiple versions of these runtimes (e.g., Ruby 2.6, 2.7; multiple PHP and Node.js versions).  
- Cloud providers commonly retire older runtime versions to encourage security best practices and modernization.  
- Ruby is supported in Azure App Services, but as of the video date, Application Insights does not support Ruby.  
- Custom runtimes can be created using Docker containers and deployed via Azure Container Registry.

**Examples**  
- Using Ruby 2.6 or 2.7 runtime in Azure App Services.  
- Deploying a custom Docker container with Elixir runtime if the language is not natively supported.

**Key Takeaways 🎯**  
- Understand that runtimes are essential for defining the environment your app runs in, including language and libraries.  
- Always check which runtime versions are supported and be aware that older versions may be deprecated.  
- For unsupported languages or custom dependencies, use Docker containers to create custom runtimes.  
- Remember the limitation that some runtimes (e.g., Ruby) may have partial support in Azure services like Application Insights.  
- Keeping runtimes updated is critical for security and compatibility in cloud environments.

---

### Custom Containers

**Timestamp**: 06:26:32 – 06:27:15

**Key Concepts**  
- Using custom containers allows deployment of applications in languages or environments not natively supported by Azure App Services.  
- Custom containers can be created for both Windows and Linux environments.  
- Docker containers are built locally and then pushed to Azure Container Registry for deployment.  
- Custom containers enable bundling specific packages or dependencies directly into the container image.

**Definitions**  
- **Custom Container**: A Docker container image created by the user that packages an application and its dependencies, which can be deployed to Azure App Services when native support is unavailable or insufficient.

**Key Facts**  
- Azure App Services supports deploying custom container images from Azure Container Registry.  
- Custom containers can be used to run languages not supported by default on Azure App Services (e.g., Elixir).  
- Both Windows and Linux containers are supported for custom container deployment.

**Examples**  
- Deploying an Elixir application by creating a custom Docker container, pushing it to Azure Container Registry, and deploying it to Azure App Service.

**Key Takeaways 🎯**  
- Remember that custom containers provide flexibility to run unsupported languages or include specific dependencies.  
- Know the workflow: create Docker container locally → push to Azure Container Registry → deploy to Azure App Service.  
- Useful for scenarios requiring custom runtime environments or bundled packages beyond Azure’s default offerings.

---

### Deployment Slots

**Timestamp**: 06:27:15 – 06:28:12

**Key Concepts**  
- Deployment slots allow creation of multiple environments for a web app within Azure App Service.  
- Each slot can have its own unique host name.  
- Slots are useful for staging, QA, development, or any custom environment needs.  
- Deployment slots enable quick cloning of the production environment for testing or validation.  
- Swapping deployment slots facilitates blue-green deployment strategies.  

**Definitions**  
- **Deployment Slots**: Separate deployment environments within an Azure App Service that can run different versions of an app simultaneously and have distinct hostnames.  
- **Swapping**: The process of exchanging the content and configuration of one deployment slot with another, typically swapping a staging slot with production to promote a tested version live.  
- **Blue-Green Deployment**: A deployment technique where two identical environments (blue and green) are maintained; one is live while the other is used for testing new releases, then swapped to minimize downtime and risk.  

**Key Facts**  
- Deployment slots provide different hostnames (e.g., app, staging, beta).  
- Swapping allows seamless promotion of a tested slot to production without downtime.  
- This approach supports safer and more controlled app deployments.  

**Examples**  
- Having a “staging” or “beta” slot as a clone of production to deploy and test new app versions before swapping to production.  

**Key Takeaways 🎯**  
- Understand deployment slots as a way to manage multiple app environments within the same Azure App Service.  
- Remember that swapping slots is a core feature enabling blue-green deployment, reducing downtime and deployment risk.  
- Know that each slot has its own hostname, allowing parallel testing and validation.  
- Deployment slots are essential for staging, QA, and developer environments in production workflows.

---

### App Service Environment

**Timestamp**: 06:28:12 – 06:30:49

**Key Concepts**  
- Azure App Service Environment (ASE) provides a fully isolated and dedicated environment for running App Service at high scale.  
- ASE supports hosting web apps (Windows and Linux), Docker containers, mobile apps, and Azure Functions.  
- ASE is designed for workloads requiring high scale, isolation, secure network access, and high memory utilization.  
- ASE can be created multiple times within a single Azure region or across multiple regions for horizontal scaling of stateless app tiers.  
- ASE uses a specific pricing tier called the **Isolated** tier.  
- ASE apps can be secured behind upstream devices like Web Application Firewalls (WAF).  
- ASE supports deployment into availability zones using zone pinning.  
- There are two types of ASE deployments: **External ASE** and **ILB ASE (Internal Load Balancer ASE)**.  

**Definitions**  
- **App Service Environment (ASE)**: A fully isolated and dedicated Azure App Service feature that enables secure, high-scale hosting of web apps, containers, mobile apps, and functions.  
- **Isolated Tier**: The pricing tier associated with ASE, providing dedicated resources and isolation.  
- **External ASE**: ASE deployment exposing apps on an internet-accessible IP address.  
- **ILB ASE (Internal Load Balancer ASE)**: ASE deployment exposing apps only internally within a virtual network via an internal load balancer.  
- **Zone Pinning**: Deployment of ASE into specific availability zones for high availability and fault tolerance (mentioned but not defined in detail).  
- **WAF (Web Application Firewall)**: A security device that can be used upstream to gate access to ASE apps.  

**Key Facts**  
- ASE allows hosting of multiple app types: Windows web apps, Linux web apps, Docker containers, mobile apps, and Azure Functions.  
- Multiple ASEs can be created in one or across multiple Azure regions for horizontal scaling.  
- ASE apps can be connected securely to on-premises networks via site-to-site VPN or ExpressRoute.  
- ASE resides within a customer’s own Virtual Network (VNet) and subnet, allowing direct access to VNet resources without extra configuration.  
- External ASE exposes apps to the internet; ILB ASE restricts access to internal VNet only.  

**Examples**  
- External ASE: App exposed on an internet-accessible IP address.  
- ILB ASE: App accessible only internally within the VNet, suitable for private/internal applications.  
- ASE connected to on-premises networks via site-to-site VPN or ExpressRoute for hybrid connectivity.  

**Key Takeaways 🎯**  
- Remember ASE is designed for enterprise-grade, high-scale, isolated, and secure app hosting beyond typical PaaS offerings.  
- Know the difference between External ASE (internet-facing) and ILB ASE (internal-only).  
- ASE requires the Isolated pricing tier.  
- ASE supports integration with upstream security devices like WAF for enhanced security.  
- ASE can be deployed across availability zones (zone pinning) for resilience.  
- ASE’s placement inside a VNet allows seamless access to other VNet resources and hybrid connectivity options.  
- Useful for exam scenarios involving secure, large-scale app hosting and network isolation in Azure App Service.

---

### Deployment

**Timestamp**: 06:30:49 – 06:34:53

**Key Concepts**  
- Deployment is the process of pushing changes or updates from a local environment or repository to a remote environment.  
- Azure App Services offers a wide variety of deployment options, making it very flexible and powerful.  
- Deployment methods can involve direct file copying, package mounting, continuous integration, FTP, cloud sync, and container-based deployments.  
- The deployment directory for Azure App Services is typically `wwwroot` (on both Windows and Linux).  
- File lock conflicts can occur if files are replaced directly in the `wwwroot` folder during deployment, causing unpredictable app behavior.  
- Using package-based deployment (e.g., zip packages mounted as read-only) can help avoid file lock issues.  
- Kudu is the engine behind many Azure App Service deployments, supporting zip deployments, file cleanup, build processes, deployment scripts, and logs.  
- FTP deployment is supported but considered outdated; it requires credentials and an FTP client.  
- Cloud Sync deployment via Dropbox or OneDrive is possible, syncing files directly to the `wwwroot` folder.  
- Azure App Service pricing depends on the App Service Plan tier chosen, which affects features and cost.

**Definitions**  
- **Deployment**: The action of pushing changes or updates from a local environment or repository into a remote environment.  
- **ILB (Internal Load Balancer)**: Mentioned briefly as a difference in a deployment setup; it stands for Internal Load Balancer.  
- **Kudu**: An open-source engine behind Git deployments and Azure App Services, supporting zip deployments, build processes, deployment scripts, and logs.  
- **wwwroot directory**: The root directory where deployed web app files reside and run from in Azure App Services.

**Key Facts**  
- Deployment methods include:  
  - Run from package (zip mounted read-only)  
  - Zip or RAR deployment using Kudu  
  - FTP deployment  
  - Cloud Sync deployment via Dropbox or OneDrive  
  - Continuous deployment from GitHub, Azure Pipelines, GitHub Actions, ARM templates, Docker Hub, Azure Container Registry, local Git repos (mentioned but not detailed)  
- The `wwwroot` directory is used for app runtime files on both Windows and Linux Azure App Service instances.  
- File lock conflicts can cause deployment failures and unpredictable app behavior if files are replaced directly in `wwwroot`.  
- Kudu supports zip deployments up to 2 GB in size.  
- FTP deployment requires an FTP endpoint, username, and password, and uses an FTP client.  
- Cloud Sync deployment creates a folder in Dropbox or OneDrive that syncs to the app’s `wwwroot`.  
- Azure App Service plans determine pricing and available features (tiers discussed after this section).

**Examples**  
- Running from a package: zip package mounted as read-only instead of copying files to `wwwroot`.  
- Zip deployment using Kudu: supports file deletions, build processes, deployment scripts, logs, and can be done via CLI, REST API, or Azure portal.  
- FTP deployment: old-school method where you connect via FTP client using credentials from the deployment center.  
- Cloud Sync deployment: syncing from Dropbox or OneDrive folders to the app’s `wwwroot` directory.

**Key Takeaways 🎯**  
- Understand the variety of deployment options available in Azure App Services and their use cases.  
- Remember that the `wwwroot` directory is the key folder for app files, and direct file replacement can cause issues.  
- Using package-based deployment (run from package) can help avoid file lock conflicts.  
- Kudu is a critical component for zip-based deployments and continuous integration scenarios.  
- FTP deployment is supported but generally outdated; Cloud Sync via Dropbox/OneDrive is a unique but less common option.  
- Be aware that deployment size limits (e.g., 2 GB for zip deployments) and methods of deployment (CLI, REST, portal) exist.  
- Know that Azure App Service plans control pricing and features, which is important for deployment scalability and cost management.

---

### App Service Plan

**Timestamp**: 06:34:53 – 06:38:11

**Key Concepts**  
- Azure App Service requires an App Service Plan to determine pricing and available features.  
- App Service Plans are divided into tiers that define compute resources, scaling, and SLA.  
- There are three main tiers: Shared, Dedicated, and Isolated.  
- Each tier has sub-levels with varying compute power, memory, disk space, and scaling capabilities.  
- SLA (Service Level Agreement) availability varies by tier.  
- Some tiers have limitations on OS support (e.g., Shared tier not supported on Linux).  

**Definitions**  
- **App Service Plan**: A pricing and resource allocation model in Azure App Service that determines how much you pay and what features/resources are available for your web apps.  
- **Shared Tier**: A low-cost tier where apps share compute resources; includes Free (F1) and Shared options.  
- **Dedicated Tier**: Higher performance tiers with dedicated compute resources; includes Basic, Standard, Premium, and Premium v2/v3.  
- **Isolated Tier**: Highest tier with dedicated Azure Virtual Networks and full network isolation, designed for App Service Environments (ASE).  
- **SLA (Service Level Agreement)**: The guaranteed uptime percentage for the service (e.g., 99.95% for Dedicated and Isolated tiers).  

**Key Facts**  
- **Shared Tier**:  
  - Free (F1): 1 GB disk space, up to 10 apps on shared instance, no SLA, 60 minutes compute quota per app per day.  
  - Shared: Up to 100 apps on shared instance, no SLA, 240 minutes compute quota per app per day.  
  - Not supported on Linux; only Windows.  
- **Dedicated Tier**:  
  - Basic (B1, B2, B3): More disk space, unlimited apps, varying compute/memory/disk.  
  - Standard: Scales out to 3 dedicated instances, SLA 99.95%, 3 levels with varying resources.  
  - Premium: Scales out to 10 dedicated instances, SLA 99.95%, multiple hardware levels.  
- **Isolated Tier**:  
  - Scales to 100 instances, SLA 99.95%, full network isolation via Azure Virtual Networks.  
  - Primarily used for App Service Environments (ASE).  
- Terminology and tier names can be confusing and inconsistent.  

**Examples**  
- None explicitly mentioned for App Service Plan configuration, but the speaker references the tier names and their features.  

**Key Takeaways 🎯**  
- Always associate your Azure App Service with an App Service Plan to define cost and capabilities.  
- Understand the differences between Shared, Dedicated, and Isolated tiers to choose the right plan based on app needs and budget.  
- Shared tiers are limited in compute time and do not have SLA guarantees; suitable for development or testing.  
- Dedicated tiers offer better performance, scaling, and SLA, suitable for production workloads.  
- Isolated tier is for advanced scenarios requiring network isolation and large scale.  
- Shared tier is not available for Linux-based apps; Linux apps require at least Basic tier or higher.  
- Be aware that tier names and pricing can be confusing; review Azure documentation carefully before selecting.  
- SLA of 99.95% is standard for Dedicated and Isolated tiers.  
- The App Service Plan abstracts much of the infrastructure management, making it easier to deploy apps without granular resource management.

---

### WebJobs

**Timestamp**: 06:38:11 – 06:39:37

**Key Concepts**  
- WebJobs allow running background scripts or programs within Azure App Services.  
- WebJobs run at no additional cost on Azure App Services.  
- WebJobs currently support only Windows-based environments (no Linux support yet).  
- Supported file types for WebJobs include: command files, bat files, executables, PowerShell, bash, PHP, Python, JavaScript, and Java files.  
- Two types of WebJobs:  
  - **Continuous**: Runs continuously until stopped; supports debugging.  
  - **Triggered**: Runs only when triggered (e.g., scheduled or manual trigger); does not support debugging.  
- Triggered WebJobs can be scheduled using cron expressions and can expose webhooks for manual triggers.  
- Scaling for WebJobs (continuous only):  
  - **Multi-instance**: Runs the WebJob across all instances of the App Service plan.  
  - **Single-instance**: Runs only one copy of the WebJob regardless of the number of App Service instances.

**Definitions**  
- **WebJobs**: A feature of Azure App Services that allows running background scripts or programs alongside web applications without additional cost.  
- **Continuous WebJob**: A WebJob type that runs continuously until manually stopped and supports debugging.  
- **Triggered WebJob**: A WebJob type that runs only when triggered by a schedule or webhook and does not support debugging.

**Key Facts**  
- WebJobs are free to use with Azure App Services.  
- Linux is not supported for WebJobs as of the time of this content.  
- Supported scripting/programming file types are broad, including common scripting and programming languages.  
- Continuous WebJobs support debugging; triggered WebJobs do not.  
- Triggered WebJobs can be scheduled using cron jobs or triggered manually via webhooks.  
- Scaling options apply only to continuous WebJobs.

**Examples**  
- Running a random script within an Azure App Service using WebJobs.  
- Scheduling a triggered WebJob using a cron expression.  
- Using a webhook to manually trigger a WebJob.

**Key Takeaways 🎯**  
- Remember that WebJobs come at no extra cost and are tightly integrated with Azure App Services.  
- WebJobs currently only support Windows environments; Linux support is not available yet.  
- Choose **continuous** WebJobs if you need ongoing execution and debugging capabilities.  
- Use **triggered** WebJobs for on-demand or scheduled execution but note the lack of debugging support.  
- Understand scaling options for continuous WebJobs to optimize resource usage across App Service instances.  
- Be familiar with supported file types to know what scripts or programs can be run as WebJobs.

---

### Configure and Deploy App Service

**Timestamp**: 06:39:37 – 06:48:52

**Key Concepts**  
- Azure App Service is designed to simplify deployment of web applications, with better synergy for Windows, Python, and .NET stacks compared to others like Ruby on Rails on Linux.  
- Azure App Service requires the appropriate resource provider to be registered before use (under "web and domain registration").  
- App Service plans determine pricing and features; Linux plans do not support the free tier, unlike Windows plans.  
- Deployment slots are an advanced feature available only on paid tiers (e.g., B1 and above).  
- Deployment Center in Azure App Service allows linking to source control repositories (e.g., GitHub) for continuous deployment.  
- GitHub Actions can be used to automate deployment workflows triggered by code changes.  

**Definitions**  
- **Azure App Service**: A platform-as-a-service (PaaS) offering to host web applications, APIs, and mobile backends.  
- **Resource Provider**: A service in Azure that must be registered in a subscription to enable specific resource types (e.g., Microsoft.Web for App Services).  
- **Deployment Slots**: Separate deployment environments (e.g., staging, production) within an App Service to enable zero-downtime deployments.  
- **Deployment Center**: Azure portal feature to configure continuous deployment from source control to App Service.  
- **GitHub Actions**: CI/CD workflows integrated with GitHub repositories to automate build and deployment processes.  

**Key Facts**  
- Azure App Service resource provider is under "web and domain registration" and must be registered to use App Services.  
- App Service plan pricing example: Premium V2 tier costs approximately $0.20 USD per hour (~$146 USD/month), with regional price variations (e.g., Canada East shows CAD pricing).  
- Linux App Service plans do not support the free tier; Windows plans do.  
- Deployment slots require at least a B1 tier plan ($0.20/hr).  
- The example app used is a simple Python Flask "Hello World" app from the Azure samples GitHub repository.  
- GitHub repository branch naming may be "master" instead of "main" in some older samples.  
- Deployment via Deployment Center requires GitHub authorization and linking to a repository; a fork may be needed if the original repo is not accessible.  
- GitHub Actions workflow YAML file defines the deployment steps including checkout, Python setup, and build on Ubuntu-latest runner.  
- Deployment is triggered by code changes; no deployment occurs until a commit is made.  

**Examples**  
- Deploying a Python Flask app from the Azure-samples GitHub repo: `github.com/azuresamples/python/docs/helloworld`  
- Using Deployment Center to connect to GitHub, authorize, fork the sample repo, and configure deployment from the "master" branch.  
- GitHub Actions workflow automates deployment steps on push to the repository.  

**Key Takeaways 🎯**  
- Always verify the Azure App Service resource provider is registered before creating App Services.  
- Understand the pricing and feature differences between Linux and Windows App Service plans, especially regarding free tiers and deployment slots.  
- Deployment Center is the primary Azure portal tool for configuring continuous deployment from GitHub.  
- GitHub Actions is the underlying mechanism for automated deployments; be familiar with the workflow YAML file structure.  
- For exam scenarios, know how to link an App Service to a GitHub repo, authorize access, and trigger deployments via commits.  
- Be aware that some sample repos may use "master" branch naming, which can affect deployment configuration.  
- Deployment slots require a paid tier; free tiers do not support this feature.  
- If authentication issues arise with GitHub, creating a new GitHub account or forking the repo can be a workaround.

---

### Trigger a Deploy via Github Actions

**Timestamp**: 06:48:52 – 06:56:24

**Key Concepts**  
- Deployment via GitHub Actions requires a workflow YAML file in the `.github/workflows` directory specifying build and deployment steps.  
- A deployment is triggered by committing changes to the specified branch (e.g., `main`).  
- GitHub Actions runs on Ubuntu latest environment and includes steps like checkout, Python setup, build, and deploy.  
- After committing a change, the GitHub Actions workflow runs automatically and can be monitored via logs.  
- If the deployed app does not serve correctly, troubleshooting involves SSH into the deployment instance to check running processes and ports.  
- Python apps often run with Gunicorn as the WSGI server; configuration is needed to bind Gunicorn to the correct port (usually port 80).  
- A `startup.txt` file can be added to the repo to configure Gunicorn with commands to bind the app to port 80 and specify worker count.  
- Committing the `startup.txt` triggers a new deployment with the correct startup configuration.  
- To verify deployment success, make a visible code change (e.g., change a string in `app.py`), commit, and confirm the change reflects on the live site.  
- Deployment slots and advanced features require upgrading the Azure App Service plan from Basic to Standard or Premium tiers.

**Definitions**  
- **GitHub Actions**: A CI/CD platform integrated with GitHub that automates workflows such as building, testing, and deploying code based on repository events.  
- **Workflow YAML file**: A configuration file in `.github/workflows` that defines the steps and environment for GitHub Actions to execute.  
- **Gunicorn**: A Python WSGI HTTP server used to serve Python web applications in production.  
- **Startup.txt**: A configuration file containing commands to start the app server correctly (e.g., binding Gunicorn to port 80).  
- **Deployment slots**: Feature in Azure App Service allowing staging and production environments for zero-downtime deployments, requiring a higher service tier.

**Key Facts**  
- GitHub Actions workflow runs on `ubuntu-latest`.  
- Deployment logs show progress and duration (example: 1 minute 29 seconds for a deploy).  
- Default Flask app runs on port 5000, which is not accessible externally in Azure App Service; port 80 must be used.  
- Gunicorn needs explicit configuration to bind to port 80 and specify worker count.  
- Adding or modifying `startup.txt` triggers a new deployment.  
- Upgrading from Basic (B1) to Standard or Premium tier is required to use deployment slots.  
- Standard tier example cost mentioned: approximately $80/month.

**Examples**  
- Making a trivial change (adding a space) to trigger a deployment.  
- Using `ps aux | grep python` via SSH to check running Python/Gunicorn processes.  
- Running `curl localhost` on the instance to verify if the app is responding.  
- Creating a `startup.txt` file with Gunicorn command:  
  ```
  gunicorn --bind=0.0.0.0:80 --workers=4 app:app
  ```  
- Changing a string in `app.py` (e.g., changing displayed text to "Vulkan") to verify deployment success.

**Key Takeaways 🎯**  
- Always ensure your GitHub Actions workflow YAML is correctly configured and present to automate deployments.  
- Deployment is triggered by commits to the specified branch; no manual trigger needed beyond pushing changes.  
- Monitor deployment progress and logs via GitHub Actions interface.  
- If the app does not serve correctly after deployment, SSH into the instance to debug processes and ports.  
- Configure Gunicorn (or your app server) to bind to port 80 to serve the app properly in Azure App Service.  
- Use a `startup.txt` or equivalent startup script committed to the repo to automate app startup configuration.  
- Verify deployments by making visible code changes and confirming updates on the live site.  
- Deployment slots and advanced deployment features require upgrading your Azure App Service plan beyond Basic tier.  
- Remember port 5000 (Flask default) is not accessible externally; always use port 80 for production deployments in Azure App Service.

---

### Create Deployment Slots

**Timestamp**: 06:56:24 – 07:07:44

**Key Concepts**  
- Deployment slots allow running different versions of an app simultaneously (e.g., production and staging).  
- Deployment slots require upgrading the Azure App Service plan from Basic (B1) to Standard or Premium tiers.  
- Each deployment slot has its own deployment configuration and code, even though some settings may be copied.  
- Separate GitHub workflows (e.g., staging.yaml) are created for deployment slots to manage deployments independently.  
- Deployment slots enable zero-downtime swapping of app versions between staging and production.  
- Traffic can be split between slots by specifying percentage traffic routing to each slot.  
- Scaling (scale up and scale out) is related but separate from deployment slots and requires Standard or higher tiers.

**Definitions**  
- **Deployment Slot**: A live app environment within the same App Service that allows testing and staging different versions of an app before swapping to production.  
- **Swap**: The process of exchanging the content and configuration of two deployment slots (e.g., staging and production) with zero downtime.  
- **Scale Up**: Increasing the size or capacity of the App Service instance (e.g., upgrading from B1 to S1).  
- **Scale Out**: Increasing the number of instances running the app to handle more traffic.

**Key Facts**  
- Deployment slots are not available on the Basic (B1) plan; must upgrade to Standard or Premium.  
- Example upgrade cost mentioned: Standard tier at about $80/month (temporarily used for demo).  
- Separate deployment workflows are created for each slot (e.g., staging.yaml for the staging slot).  
- Branches in GitHub can be used to deploy different versions to different slots (e.g., main branch for production, staging branch for staging).  
- Swapping deployment slots is zero downtime and can be done without preview if no configuration changes exist.  
- Traffic routing between slots can be split by percentage (e.g., 50% production, 50% staging).  
- Maximum instance limit mentioned for scaling is 10 instances.

**Examples**  
- Created a staging slot from production branch; initially showed default page because code was not deployed yet.  
- Created a separate GitHub branch called "staging" with different app content ("Hello Klingons") deployed to the staging slot.  
- Swapped staging slot with production slot, resulting in production showing "Hello Klingons" and staging showing previous production content.  
- Adjusted traffic routing to 50% between production and staging slots, verified by refreshing the app URL multiple times.  
- Edited app.py in different branches to demonstrate different app versions deployed to different slots.

**Key Takeaways 🎯**  
- Always upgrade to Standard or Premium tier to use deployment slots.  
- Deployment slots have independent deployment pipelines; code must be deployed separately to each slot.  
- Use separate Git branches to manage different slot deployments effectively.  
- Use the swap feature to promote tested staging versions to production with zero downtime.  
- Traffic splitting allows gradual rollout/testing by directing a percentage of users to staging.  
- Understand the difference between scaling (up/out) and deployment slots; both require Standard or higher plans.  
- Familiarize yourself with managing deployment workflows in GitHub Actions for each slot.  
- Remember that some UI elements (like traffic percentage sliders) may be grayed out if not at the correct management level or during certain views.

---

### Scaling App Service

**Timestamp**: 07:07:44 – 07:14:02

**Key Concepts**  
- Azure App Service scaling is divided into two types: **scale up** and **scale out**.  
- **Scale up** means increasing the size (SKU) of the instance (e.g., from B1 to S1).  
- **Scale out** means increasing the number of instances to handle more load.  
- Auto-scaling can be configured based on metrics such as CPU percentage.  
- Auto-scale rules include setting minimum and maximum instance counts, metric thresholds, duration, and cooldown periods.  
- Monitoring scaling events is done via the **run history** under the monitoring tab.  
- Scaling rules can be adjusted to be more or less aggressive depending on the workload.  
- Scale down actions happen automatically based on configured rules, but may require proper setup of scale out/in rules to function as expected.

**Definitions**  
- **Scale Up**: Increasing the size or capacity of a single instance (e.g., upgrading from a smaller SKU to a larger SKU).  
- **Scale Out**: Increasing the number of instances running the application to handle increased load.  
- **Auto Scale**: Automatic adjustment of the number of instances based on predefined metrics and thresholds.  
- **Cooldown Period**: Time to wait after a scale action before another scaling action can occur, to avoid rapid fluctuations.

**Key Facts**  
- Scaling up requires at least Standard tier or above (Standard, Premium, etc.).  
- Maximum number of instances allowed for scaling out is 10 by default.  
- Auto scale rules can be based on CPU percentage; example thresholds used were 10% for scaling out and 50% for scaling down.  
- Duration for triggering scale actions can be set (e.g., 1 minute for quick response, 5 minutes to avoid transient spikes).  
- Cooldown time is typically set to 5 minutes to prevent rapid scale changes.  
- Monitoring scaling events is done through the **run history** which shows instance counts over time.

**Examples**  
- Configured auto scale to add an instance when CPU usage exceeds 10% for 1 minute, with a max of 2 instances.  
- Adjusted scaling rule duration from 1 minute to 5 minutes to reduce aggressive scaling.  
- Attempted to trigger scale down by setting CPU threshold to 50% and duration to 1 minute.  
- Observed scaling events in run history showing instance count changes.

**Key Takeaways 🎯**  
- Understand the difference between scale up (vertical scaling) and scale out (horizontal scaling).  
- Know that auto scale requires Standard tier or higher.  
- Be able to configure auto scale rules based on metrics like CPU percentage, with appropriate thresholds and durations.  
- Remember to set cooldown periods to avoid rapid scaling fluctuations.  
- Use the monitoring run history to verify scaling events and troubleshoot scaling behavior.  
- Scaling down may require proper scale out/in rule configuration to work correctly.  
- Practical exam scenarios may test your ability to configure and interpret auto scale settings in Azure App Services.  

---

### App Services CheatSheet

**Timestamp**: 07:14:02 – 07:16:53

**Key Concepts**  
- Azure App Services is an HTTP-based platform-as-a-service (PaaS) for hosting web apps, REST APIs, and mobile backends.  
- Supports multiple programming languages and can run on Windows or Linux environments.  
- Provides easy integration with Azure DevOps, GitHub, Docker Hub, and package management.  
- Supports deployment slots for staging environments and blue-green deployments.  
- App Service Environment (ASE) offers fully isolated, dedicated environments for high-scale and secure app hosting.  
- WebJobs allow running background scripts or programs within the same instance as the web app without extra cost.

**Definitions**  
- **Azure App Services**: A PaaS offering by Azure for hosting web applications, REST APIs, and mobile backends with support for multiple languages and environments.  
- **App Service Plan**: Pricing and resource tier model for Azure App Services (Standard, Dedicated, Isolated).  
- **Deployment Slots**: Separate deployment environments within an App Service that can be swapped for zero-downtime deployments (e.g., blue-green deployment).  
- **App Service Environment (ASE)**: A fully isolated and dedicated environment for securely running Azure App Services at high scale, supporting horizontal scaling and high request workloads.  
- **WebJobs**: A feature of Azure App Services that runs background scripts or programs on the same instance as the web app, with no additional cost.

**Key Facts**  
- Azure App Services supports runtimes: .NET, .NET Core, Java, Ruby, Node.js, PHP, Python.  
- App Service Plans have tiers: Standard, Dedicated, and Isolated. The Isolated tier does NOT support Linux.  
- Azure App Services can run Docker containers (single or multi-container) and supports custom containers via Azure Container Registry.  
- ASE can be deployed with two types: External ASE and ILB (Internal Load Balancer) ASE.  
- ASE supports zone pinning for deployment into availability zones.  
- Apps running on ASE can have access controlled by upstream devices like Web Application Firewall (WAF).  
- WebJobs incur no additional cost beyond the App Service plan.

**Examples**  
- Using deployment slots to perform blue-green deployments by swapping environments.  
- Deploying custom Docker containers by uploading to Azure Container Registry and deploying to App Services.  
- ASE used for high-scale, secure, isolated app hosting with multiple ASEs possible in one or multiple Azure regions.

**Key Takeaways 🎯**  
- Remember Azure App Services is Azure’s PaaS equivalent to Heroku or AWS Elastic Beanstalk.  
- Know the supported runtimes and that the Isolated tier does not support Linux.  
- Deployment slots are critical for zero-downtime deployments and staging environments.  
- ASE provides isolation and security for apps requiring high scale and compliance, with options for external or internal load balancer deployment.  
- WebJobs are a cost-effective way to run background tasks alongside your web app.  
- Understand the integration capabilities with CI/CD tools like Azure DevOps and GitHub for streamlined deployments.

---

## Availability Follow Along

---

### Backup VM using Images

**Timestamp**: 07:16:53 – 07:23:27

**Key Concepts**  
- Creating managed images from virtual machines (VMs) to back them up or replicate them.  
- Using snapshots to capture the state of a VM for image creation.  
- Two main ways to create images:  
  - Managed images (standalone)  
  - Shared Image Gallery (SIG) images with versioning and replication features.  
- Importance of stopping the VM during image capture to avoid inconsistent states.  
- Zone resilience option for images to enable deployment across availability zones.  
- Differences between general and specialized images in SIG.  
- Using images to quickly create new VMs with pre-configured settings.  

**Definitions**  
- **Managed Image**: A snapshot-based image of a VM that can be used to create new VMs; created by capturing the VM’s disk state.  
- **Shared Image Gallery (SIG)**: A service that stores and manages VM images with versioning, replication, and sharing capabilities across regions and subscriptions.  
- **Zone Resilience**: A feature that allows an image to be deployed across multiple availability zones for higher availability.  
- **Generalized Image**: An image prepared for reuse where the VM has been generalized (e.g., using sysprep on Windows or waagent -deprovision on Linux), requiring a new hostname and configuration on deployment.  
- **Specialized Image**: An image capturing the VM exactly as is, including machine-specific information; no need for reconfiguration on deployment.  

**Key Facts**  
- VM must be stopped to create a managed image to ensure consistency.  
- Zone resilience should be enabled on images if you want to deploy VMs in any availability zone.  
- Creating an image from a VM can be done via the Azure portal’s “Capture” option.  
- Shared Image Gallery images require an image definition and versioning (e.g., version 0.0.1).  
- Shared Image Gallery is the preferred method for image management due to version control and replication.  
- Creating a VM from an image is straightforward: select the image and Azure pre-populates the VM creation form.  
- Images can be created with or without placing them in a shared image gallery.  

**Examples**  
- Created a Linux VM named “Wolf” running Ubuntu 18.04 LTS with Apache installed via custom data (bash script).  
- Captured an image of the “Wolf” VM twice: once as a standalone managed image (not in SIG) and once in the Shared Image Gallery.  
- Demonstrated creating a VM from both types of images.  

**Key Takeaways 🎯**  
- Always stop the VM before capturing an image to avoid inconsistent snapshots.  
- Use Shared Image Gallery for better image management, including versioning and replication across regions.  
- Enable zone resilience on images if you want to deploy VMs across availability zones.  
- Understand the difference between generalized and specialized images and when to use each.  
- Creating a VM from an image is simple and useful for backups, scaling, or disaster recovery.  
- Remember that images can be created via the VM “Capture” button or directly through the Images or Shared Image Gallery services.  
- For exam scenarios, expect questions on image creation, image types, and benefits of using Shared Image Gallery.  

---

### Review Availability Sets

**Timestamp**: 07:23:27 – 07:26:03

**Key Concepts**  
- Availability Sets are critical for ensuring high availability of VMs by distributing them across fault domains and update domains.  
- Fault domains represent physical hardware racks that can fail independently.  
- Update domains represent groups of VMs that can be updated or rebooted at the same time without affecting others.  
- Availability Sets help maintain service uptime during planned maintenance or hardware failures.  
- Availability Zones physically separate resources within an Azure region for higher availability.  
- Virtual Machine Scale Sets (VMSS) relate to availability but have automatic scaling and default fault/update domain settings.

**Definitions**  
- **Availability Set**: A logical grouping of VMs that ensures VMs are distributed across multiple fault domains and update domains to avoid single points of failure.  
- **Fault Domain**: A physical unit of failure, such as a rack of servers, where hardware failures can affect all VMs in that domain.  
- **Update Domain**: A group of VMs that can be updated or rebooted simultaneously during planned maintenance without impacting other update domains.  
- **Availability Zone**: Physically separate locations within an Azure region to increase fault tolerance.  
- **Virtual Machine Scale Set (VMSS)**: A group of identical, load-balanced VMs with automatic scaling capabilities, typically defaulting to 5 fault domains and 5 update domains.

**Key Facts**  
- Availability Sets require specifying the number of fault domains and update domains when created.  
- Scale Sets default to 5 fault domains and 5 update domains.  
- Availability Sets do not support automatic scaling; all VMs are identical in the set.  
- Availability Zones provide physical separation within a region, enhancing availability beyond fault/update domains.  
- Exam questions may ask how to achieve specific SLA percentages (e.g., 99.5%) using combinations of availability sets, scale sets, and zones.

**Examples**  
- None explicitly demonstrated; the instructor references a graphic showing racks (fault domains) and update domains to illustrate VM distribution and update scheduling.

**Key Takeaways 🎯**  
- Understand how fault domains and update domains work together in Availability Sets to maintain uptime.  
- Know the difference between Availability Sets and Scale Sets, especially regarding scaling and default domain counts.  
- Be familiar with Availability Zones as a higher-level physical separation option within regions.  
- Be prepared for exam questions on SLAs requiring knowledge of how to combine these availability features to meet uptime requirements.  
- When creating an Availability Set, you must specify fault and update domains; for Scale Sets, these are defaulted.  
- Availability Sets are foundational knowledge for AZ-900 and essential for administrator-level exams.

---

### Create a Scale Sets

**Timestamp**: 07:26:03 – 07:31:07

**Key Concepts**  
- Virtual Machine Scale Sets (VMSS) allow you to deploy and manage a set of identical VMs.  
- Scale sets support automatic scaling and availability across multiple availability zones.  
- Scale sets can be created from existing images, such as those in a Shared Image Gallery.  
- Scaling policies can be manual or automatic based on metrics like CPU usage.  
- Health monitoring and automatic repair can be enabled to maintain instance health.  
- Upgrade policies and over-provisioning settings control how scale sets update and manage instances.  

**Definitions**  
- **Virtual Machine Scale Set (VMSS)**: A group of identical, load-balanced VMs that can automatically scale to meet demand.  
- **Availability Zones**: Physically separate locations within an Azure region to increase availability and fault tolerance.  
- **Scaling Policy**: Rules that determine how and when the number of VM instances in a scale set increases or decreases.  
- **Health Monitoring**: A feature that checks the health of VM instances and can trigger automatic repairs.  
- **Over-provisioning**: Creating more VM instances than requested initially to speed up deployment, which can be controlled to avoid unexpected billing.  

**Key Facts**  
- Default availability zones for scale sets are typically set to 3 for enterprise-grade availability.  
- Initial VM instance count can be set manually; example used was 3 instances matching 3 availability zones.  
- Scaling policies can be set to manual or based on metrics such as average CPU percentage.  
- Health monitoring can be configured on specific ports (e.g., port 80 for web servers).  
- Automatic repair replaces unhealthy instances after a configurable grace period (example: 10 minutes).  
- Upgrade policies control how and when VM instances are updated or replaced.  
- Over-provisioning is enabled by default but can be turned off to prevent unexpected charges.  

**Examples**  
- Created a scale set named "Wolf Scale Set" using an image from the Shared Image Gallery.  
- Set the scale set to use 3 availability zones and an initial instance count of 3.  
- Used manual scaling to increase instances from 1 to 3.  
- Enabled health monitoring on port 80 and automatic repair with a 10-minute grace period.  

**Key Takeaways 🎯**  
- Always use 3 availability zones for enterprise-scale VM scale sets to ensure high availability.  
- Use Shared Image Gallery images to simplify scale set creation.  
- Understand the difference between manual and automatic scaling policies; automatic scaling can be based on CPU or other metrics.  
- Enable health monitoring and automatic repair to maintain VM instance health and availability.  
- Be aware of upgrade policies and over-provisioning settings to control costs and update behavior.  
- Manual scaling is straightforward for exam scenarios, but know how to configure auto scaling rules as well.  
- Remember that scale sets integrate with load balancers or application gateways for traffic distribution (covered in next sections).

---

### Create an Application Gateway

**Timestamp**: 07:31:07 – 07:37:36

**Key Concepts**  
- Application Gateway is a type of load balancer operating at Layer 7 (application layer).  
- Azure Load Balancers operate at Layer 4 (transport layer - TCP/UDP).  
- Application Gateway is suitable for web applications requiring HTTP/HTTPS routing and advanced traffic management.  
- Setting up an Application Gateway involves configuring frontend IP, backend pools, listeners, HTTP settings, and routing rules.  
- Subnets must be dedicated for the Application Gateway within the virtual network.  
- Backend pools can include virtual machine scale sets, but they must be in the same virtual network.  
- After adding a scale set to the backend pool, the scale set instances may require an upgrade for changes to take effect.  
- Health probes can be configured to monitor backend instance health via custom paths (e.g., /healthcheck).

**Definitions**  
- **Application Gateway**: A Layer 7 load balancer in Azure that manages web traffic by routing HTTP/HTTPS requests based on URL paths, host headers, and other application-level information.  
- **Load Balancer (Azure Load Balancer)**: A Layer 4 load balancer that distributes traffic based on TCP/UDP protocols without inspecting application-level data.  
- **Backend Pool**: A group of backend servers (VMs or scale sets) that receive traffic from the Application Gateway.  
- **Listener**: A configuration that listens for incoming traffic on a specified frontend IP and port.  
- **HTTP Settings**: Configuration that defines how the Application Gateway communicates with backend servers, including port, cookie-based affinity, and connection draining.  
- **Health Probe**: A mechanism to monitor the health of backend instances by periodically sending requests to a specified path.

**Key Facts**  
- Application Gateway requires a dedicated subnet within the virtual network (e.g., subnet named "VGW" with address range 10.0.2.0/24).  
- Recommended to have at least three instances for availability (rule of three).  
- Frontend IP can be public or private; in this example, a public IP named "Wolf VGW" was created.  
- Backend pool was linked to a virtual machine scale set named "Wolf skill set."  
- Listener configured for HTTP on port 80 with a single frontend IP.  
- HTTP settings used port 80, no cookie-based affinity or connection draining enabled for this simple app.  
- Scale set instances must be upgraded after adding them to the backend pool for the changes to apply.  
- Health probes can be customized to check specific URLs like "/healthcheck" for backend health monitoring.

**Examples**  
- Web application: Simple Apache page served via Application Gateway.  
- Virtual network used: "WolfVNet 499" with a dedicated subnet "VGW" created for the Application Gateway.  
- Backend pool linked to a VM scale set named "Wolf skill set."  
- Listener named "mylistener" configured for HTTP port 80 on public frontend IP.  
- HTTP settings named "my HTTP settings" with default port 80 and no advanced options enabled.

**Key Takeaways 🎯**  
- Understand the difference between Azure Load Balancer (Layer 4) and Application Gateway (Layer 7) and when to use each.  
- Always create a dedicated subnet for the Application Gateway within the virtual network.  
- Ensure backend pools and Application Gateway are in the same virtual network to avoid configuration issues.  
- Remember to upgrade VM scale set instances after adding them to the backend pool to activate changes.  
- Configure listeners and HTTP settings carefully to match your application requirements (e.g., port, protocol, cookie affinity).  
- Use health probes to monitor backend health and improve application availability.  
- For exam scenarios, be prepared to identify components of Application Gateway and troubleshoot common issues like subnet conflicts or scale set upgrades.

---

### Intro

**Timestamp**: 07:37:36 – 07:38:06

**Key Concepts**  
- Azure Monitor is a comprehensive service for telemetry data collection, analysis, and action.  
- Observability is a critical concept in DevOps for understanding internal system behavior.  
- Observability relies on three pillars: metrics, logs, and traces.

**Definitions**  
- **Observability**: The ability to measure and understand how internal systems work to answer questions about performance, tolerance, security, and faults in systems and applications.  
- **Metrics**: Numerical measurements taken over a period of time (introduced as the first pillar of observability).

**Key Facts**  
- Many Azure services send their telemetry data to Azure Monitor by default.  
- Azure Monitor supports features like visual dashboards, smart alerts, automated actions, and log monitoring.  
- Using metrics, logs, and traces in isolation does not provide full observability; all three must be used together.

**Examples**  
- Visual dashboard provided by Azure Monitor as an example of telemetry data visualization.

**Key Takeaways 🎯**  
- Understand the concept of observability and its importance in monitoring cloud and on-premise environments.  
- Remember the three pillars of observability: metrics, logs, and traces—these are essential to fully understand system behavior.  
- Azure Monitor is a powerful, built-in tool that integrates telemetry data from many Azure services automatically.  
- Be able to explain why observability is more than just collecting data—it’s about using multiple data types together to gain insights.

---

### The Pillars of Observability

**Timestamp**: 07:38:06 – 07:39:18

**Key Concepts**  
- Observability is the ability to measure and understand internal system behavior to answer questions about performance, tolerance, security, and faults.  
- Observability requires three pillars used together: metrics, logs, and traces.  
- Using metrics, logs, or traces in isolation does not provide full observability.  

**Definitions**  
- **Observability**: The capability to measure and understand how internal systems work to diagnose performance, tolerance, security, and fault issues.  
- **Metrics**: Numerical measurements aggregated over time (e.g., average CPU usage).  
- **Logs**: Text files containing event data recorded at specific times.  
- **Traces**: A history of requests traveling through multiple applications and services to pinpoint performance issues or failures.  

**Key Facts**  
- The three pillars of observability are metrics, logs, and traces.  
- Observability is a core concept in DevOps and cloud monitoring but is not specific to Azure.  
- Azure Monitor and other cloud services leverage these pillars to provide monitoring capabilities.  

**Examples**  
- Measuring CPU usage over time to get an average CPU metric.  
- Logs as text files with event data lines timestamped.  
- Traces showing request paths through multiple apps/services to identify failures or performance bottlenecks.  

**Key Takeaways 🎯**  
- Remember the three pillars of observability: metrics, logs, and traces—using all three together is essential.  
- Understand that observability helps answer critical operational questions about system health and behavior.  
- Be able to distinguish between metrics (quantitative data), logs (event records), and traces (request journeys).  
- Observability concepts apply broadly in DevOps and cloud monitoring, including Azure Monitor.  
- Visualize observability as a "Triforce" combining the three pillars for full insight.

---

### Anatomy of Monitor

**Timestamp**: 07:39:18 – 07:40:36

**Key Concepts**  
- Azure Monitor collects data from multiple sources including application data, operating system data, Azure resources, tenant-level data, and custom sources.  
- Data collected is stored in logs and metrics within Azure Monitor.  
- Azure Monitor provides various functions to work with the data: insights, visualization, analysis, response, and integration.  

**Definitions**  
- **Azure Monitor**: A comprehensive monitoring service in Azure that collects, stores, and analyzes telemetry data from various sources to provide insights and enable responses.  
- **Logs and Metrics**: Data stores within Azure Monitor where collected data is saved for further processing.  
- **Insights**: Services that provide detailed information about virtual machines, containers, and applications.  
- **Visualization**: Tools like dashboards, Power BI, and workbooks used to visually represent monitoring data.  
- **Analysis**: Using log and metric analysis tools to interpret collected data.  
- **Response**: Automated or manual actions such as alerts and auto-scaling triggered by monitoring data.  
- **Integration**: Connecting Azure Monitor with other services using logic apps or export APIs.  

**Key Facts**  
- Data sources include application data, OS data, Azure resource data at subscription and tenant levels, and custom sources.  
- Functions of Azure Monitor are categorized into insights, visualization, analysis, response, and integration.  

**Examples**  
- Visualization examples: creating dashboards, using Power BI, and workbooks.  
- Response examples: creating alerts and initiating auto-scaling.  
- Integration examples: using logic apps and export APIs to connect Azure Monitor with other systems.  

**Key Takeaways 🎯**  
- Understand the multiple data sources feeding into Azure Monitor and their scope (application to tenant level).  
- Remember that Azure Monitor stores data in logs and metrics for further use.  
- Be able to identify the five main functions of Azure Monitor: insights, visualization, analysis, response, and integration.  
- Know practical examples of each function to illustrate how Azure Monitor can be used in real scenarios.  
- Focus on the flow: data sources → storage (logs/metrics) → functions (insights, visualization, analysis, response, integration).  

---

### Sources Application

**Timestamp**: 07:40:36 – 07:42:26

**Key Concepts**  
- Application telemetry collection focuses on performance and functionality monitoring.  
- Data flow: Sources (application) → Storage → Services (analysis and visualization).  
- Instrumentation packages installed in application code enable data collection into Application Insights.  
- Availability tests measure application responsiveness from multiple public internet locations.  
- Metrics describe application performance, operations, and custom metrics.  
- Logs store operational data such as page views, requests, exceptions, and traces.  
- Application data can be archived in Azure Storage for long-term retention.  
- Availability test results and debug snapshots can be stored for further analysis and troubleshooting.  
- Monitoring guest operating systems (inside VMs) requires installing agents like Log Analytics agent and Dependency agent.  
- Host operating system monitoring is managed by Azure or the cloud provider and is not the user’s responsibility.

**Definitions**  
- **Application Insights**: A service for collecting rich telemetry data from applications to monitor performance and usage.  
- **Availability Tests**: Tests that check the responsiveness of an application from different geographic locations on the public internet.  
- **Log Analytics Agent**: An agent installed on guest OS to collect logs and send them to Log Analytics.  
- **Dependency Agent**: An agent that monitors processes and dependencies on the guest OS.

**Key Facts**  
- Application Insights requires installing an instrumentation package in the application code.  
- Availability tests help compare response times across different regions (e.g., East Canada vs. West US).  
- Logs include page views, application requests, exceptions, and traces.  
- Data can be archived in Azure Storage or saved as debug snapshots for later debugging.  
- Guest OS monitoring requires installing specific agents; host OS monitoring is handled by Azure.

**Examples**  
- Using availability tests to ensure consistent response times between East Canada and West US deployments.  
- Collecting application telemetry such as traces, logs, and user telemetry via instrumentation packages.

**Key Takeaways 🎯**  
- Remember to install instrumentation packages in your application to enable Application Insights telemetry.  
- Use availability tests to monitor application responsiveness from multiple locations.  
- Store logs and metrics to track application health and performance.  
- Archive data or create debug snapshots for troubleshooting purposes.  
- Focus monitoring efforts on the guest OS inside VMs by installing Log Analytics and Dependency agents; do not worry about the host OS monitoring.

---

### Sources Operation System

**Timestamp**: 07:42:26 – 07:44:00

**Key Concepts**  
- Monitoring the guest operating system (OS) inside a virtual machine (VM), not the host OS.  
- Use of agents installed on the guest OS to collect monitoring data.  
- Log Analytics Agent and Dependency Agent are key tools for monitoring processes and logs.  
- Diagnostic extension is required for performance counters and health state information.  
- Data collected can be stored in Azure Storage or streamed via Azure Event Hub.  
- Azure resource logs and metrics are automatically created but require diagnostic settings for log destinations.  
- Metrics can be analyzed in Metrics Explorer; logs can be analyzed in Log Analytics.  

**Definitions**  
- **Guest Operating System**: The OS running inside a VM that you control and monitor, distinct from the host OS which is managed by Azure or the cloud provider.  
- **Log Analytics Agent**: An agent installed on the guest OS to collect logs and send them to Log Analytics for analysis.  
- **Dependency Agent**: An agent that monitors running processes on the guest OS (e.g., MySQL, Redis, Rails app).  
- **Diagnostic Extension**: A tool installed on the guest OS to collect performance counters, health state information, and enable streaming to Event Hub.  
- **Azure Event Hub**: A service to stream monitoring data from the guest OS to other destinations or applications.  

**Key Facts**  
- Monitoring the host OS is not required; it is managed by Azure or the cloud provider.  
- Agents (Log Analytics and Dependency) can be installed on Azure VMs, on-premises machines, or other cloud providers like AWS.  
- Diagnostic extension is necessary for performance counters and health state data collection.  
- Resource logs are automatically created for Azure resources but require diagnostic settings to specify log destinations.  
- Metrics for Azure resources are automatically available and do not require additional configuration.  
- Logs and resource logs can be archived in Azure Storage for long-term backup.  

**Examples**  
- Monitoring processes such as MySQL, Redis, or a Rails app using the Dependency Agent.  
- Using Diagnostic Extension to stream data to Azure Event Hub.  

**Key Takeaways 🎯**  
- Always distinguish between guest OS (your responsibility) and host OS (managed by Azure).  
- Install Log Analytics Agent and Dependency Agent on the guest OS to enable comprehensive monitoring.  
- Use Diagnostic Extension to collect performance counters and health state info, and to enable streaming to Event Hub.  
- Configure diagnostic settings on Azure resources to collect and route resource logs appropriately.  
- Use Metrics Explorer for metrics analysis and Log Analytics for log data analysis.  
- Remember that agents and extensions can be installed on various environments, not just Azure.

---

### Sources Resources

**Timestamp**: 07:44:00 – 07:44:57

**Key Concepts**  
- Azure resource logs provide insights into internal operations of Azure resources.  
- Diagnostic settings must be configured to specify destinations for resource logs collection.  
- Metrics for Azure resources are collected automatically without additional configuration.  
- Metrics can be analyzed using Metrics Explorer.  
- Log Analytics is used to analyze log data for trends and other insights.  
- Platform metrics can be copied to logs for further analysis.  
- Resource logs can be archived in Azure Storage for long-term backup.  
- Event Hubs can be used to send or trigger data to other destinations.

**Definitions**  
- **Resource Logs**: Logs that provide insights into the internal operations of Azure resources.  
- **Diagnostic Settings**: Configuration that specifies where resource logs are sent or collected.  
- **Metrics Explorer**: A tool to analyze automatically collected Azure resource metrics.  
- **Log Analytics**: A service used to analyze log data for trends and detailed insights.  
- **Event Hubs**: A service used to stream data from Azure resources to other destinations.

**Key Facts**  
- Resource logs are automatically created but require diagnostic settings to be collected.  
- Metrics do not require additional configuration and are available by default.  
- Resource logs can be archived in Azure Storage for long-term retention.  
- Event Hubs serve as a mechanism to send or trigger data to external destinations.

**Examples**  
- Using Event Hubs to stream diagnostic data to other destinations.  
- Analyzing metrics in Metrics Explorer.  
- Archiving resource logs in Azure Storage.

**Key Takeaways 🎯**  
- Always configure diagnostic settings to collect resource logs to your desired destination.  
- Metrics are automatically available—use Metrics Explorer for analysis without extra setup.  
- Use Log Analytics for deeper log data analysis and trend detection.  
- Consider archiving logs in Azure Storage for compliance and backup.  
- Event Hubs enable integration with other systems by streaming diagnostic data externally.

---

### Source Subscription

**Timestamp**: 07:44:57 – 07:45:16

**Key Concepts**  
- Monitoring an Azure subscription involves checking the service health of resources and Azure Active Directory status.  
- Azure tenant monitoring includes tenant-wide services such as Active Directory.  
- Tenant is closely linked to Azure Active Directory.  
- Monitoring includes reporting on sign-in activity history and audit trails of changes within the tenant.

**Definitions**  
- **Tenant**: A dedicated instance of Azure Active Directory that is highly coupled with Azure AD services and is used for managing tenant-wide services and monitoring.

**Key Facts**  
- Service health monitoring covers resource status (e.g., whether they are running or okay) and Azure AD-related information.  
- Reporting includes historical sign-in activity and audit trails of tenant changes.

**Examples**  
- None mentioned explicitly in this timestamp range.

**Key Takeaways 🎯**  
- Understand that monitoring an Azure subscription includes both resource health and Azure AD tenant-wide services.  
- Remember that tenant monitoring focuses on security and compliance aspects like sign-in history and audit logs.  
- Tenant is a core concept tied to Azure AD and is essential for managing and monitoring identity-related services within Azure.

---

### Sources Tenant

**Timestamp**: 07:45:16 – 07:45:42

**Key Concepts**  
- Azure tenant is closely linked to Azure Active Directory (Azure AD).  
- Tenant-wide services include Active Directory-related monitoring.  
- Monitoring includes reporting on sign-in activity history and audit trails of changes within the tenant.  

**Definitions**  
- **Tenant**: A dedicated instance of Azure Active Directory that represents an organization and contains users, groups, and applications. It is the boundary for identity and access management in Azure.  

**Key Facts**  
- Tenant monitoring focuses on tenant-wide services such as Active Directory.  
- Reports include historical sign-in activity and audit trails of changes made within the tenant.  

**Examples**  
- Monitoring sign-in activity history for users in the tenant.  
- Audit trails showing changes made within the tenant environment.  

**Key Takeaways 🎯**  
- Remember that the Azure tenant is fundamentally tied to Azure AD and tenant-wide monitoring revolves around identity and access management data.  
- Tenant monitoring provides critical security and compliance insights through sign-in reports and audit logs.  
- For exam purposes, associate tenant monitoring primarily with Azure AD services and their logs.  

---

### Sources Custom Sources

**Timestamp**: 07:45:42 – 07:46:08

**Key Concepts**  
- Custom sources allow collection of data that does not fit into predefined Azure Monitor categories.  
- Data collection via Azure Monitor API using REST clients.  
- Custom data is stored in Azure Monitor or Log Analytics for analysis.

**Definitions**  
- **Custom Sources**: Data inputs collected through Azure Monitor API when other predefined data categories do not apply, enabling flexible data ingestion.  
- **Azure Monitor API**: An interface that allows sending custom data to Azure Monitor using REST calls.

**Key Facts**  
- Custom sources are used when none of the standard data categories fit the data collection needs.  
- Data collected via REST client is stored in Log Analytics or Azure Monitor for further use.

**Examples**  
- None mentioned explicitly in the transcript.

**Key Takeaways 🎯**  
- Remember that custom sources provide flexibility to ingest any data via Azure Monitor API.  
- Use REST clients to push custom data into Azure Monitor or Log Analytics workspaces.  
- This is essential when monitoring scenarios require data outside of built-in Azure service logs or metrics.

---

### Data Stores

**Timestamp**: 07:46:08 – 07:47:43

**Key Concepts**  
- Azure Monitor handles two fundamental types of data: **logs** and **metrics**.  
- There are two main Azure services for these data types: **Azure Monitor Logs** and **Azure Monitor Metrics**.  
- Logs are consolidated into **workspaces** for organization and analysis.  
- Log data can come from multiple sources: platform logs, VM agents, application usage/performance data.  
- Logs are queried interactively using **Log Analytics**.  
- Metrics are numeric values collected at regular intervals, stored in a time-series database.  
- Metrics support near real-time monitoring and alerting, analyzed via **Metrics Explorer**.  
- Workspaces provide isolated environments with their own data repository, configuration, and data sources for log data.  
- Creating and using workspaces is a best practice, especially when collecting data outside Azure services or needing data isolation.

**Definitions**  
- **Azure Monitor Logs**: Service that collects and organizes log and performance data from monitored resources into workspaces.  
- **Log Analytics**: Sub-service for querying and interacting with log data stored in Azure Monitor Logs.  
- **Azure Monitor Metrics**: Service that collects numeric metric data from monitored resources into a time-series database for near real-time analysis.  
- **Metrics Explorer**: Tool to interactively analyze metric data.  
- **Workspace**: A unique environment in Azure Monitor Logs that contains its own data repository, configuration, and data sources.

**Key Facts**  
- Logs consolidate data from platform logs, VM agents, and application usage/performance.  
- Metrics are lightweight numeric values collected at regular intervals, ideal for alerting and fast issue detection.  
- Workspaces are required for isolating data and collecting data from outside Azure services.  
- It is possible to use Log Analytics without creating a workspace, but workspaces offer more robust options.

**Examples**  
- None explicitly mentioned beyond general sources of logs (platform logs, VM agents, applications).

**Key Takeaways 🎯**  
- Understand the distinction between logs and metrics and the corresponding Azure services.  
- Know that logs are stored in workspaces and queried via Log Analytics.  
- Remember that metrics are numeric, time-series data analyzed with Metrics Explorer.  
- Creating workspaces is recommended for data isolation and advanced configurations.  
- Be familiar with the role of workspaces as containers for log data and configurations.

---

### Log Analytics Workspaces

**Timestamp**: 07:47:43 – 07:48:35

**Key Concepts**  
- Log Analytics workspaces are unique environments within Azure Monitor for storing log data.  
- Each workspace has its own data repository, configuration, data sources, and solutions.  
- Workspaces help isolate and organize log data, especially when collecting data outside of Azure services.  
- Using a workspace provides more robust options for data collection and management.  

**Definitions**  
- **Log Analytics Workspace**: A dedicated environment in Azure Monitor that stores log data with its own repository, configuration, and connected data sources.  

**Key Facts**  
- You can use Log Analytics without creating a workspace, but workspaces are recommended for data isolation and advanced scenarios.  
- Workspaces are essential when collecting data from sources outside of Azure services.  

**Examples**  
- None mentioned explicitly, but implied use case: collecting and isolating log data from external (non-Azure) sources requires a workspace.  

**Key Takeaways 🎯**  
- Always create and use Log Analytics workspaces to isolate and manage your log data effectively.  
- Workspaces are foundational for advanced log data collection and configuration in Azure Monitor.  
- Remember that while you can use Log Analytics without a workspace, it limits your ability to organize and isolate data.  
- Understanding the role of workspaces is critical before moving on to querying logs with Kusto Query Language (KQL).  

---

### Log Analytics

**Timestamp**: 07:48:35 – 07:49:12

**Key Concepts**  
- Log Analytics is a tool within Azure Monitor Logs used to edit and run queries.  
- It operates similarly to querying a database with tables and columns.  
- The query language used is Kusto Query Language (KQL).  
- KQL is designed to filter, sort, and manipulate log data efficiently.  

**Definitions**  
- **Log Analytics**: A tool to write and run queries against Azure Monitor logs, structured like a database.  
- **Kusto Query Language (KQL)**: The query language used in Log Analytics, based on Azure Data Explorer, for querying and analyzing log data.  

**Key Facts**  
- Azure Monitor Logs is based on Azure Data Explorer technology.  
- KQL supports relational database concepts such as databases, tables, columns, and clusters.  
- KQL is widely used across Azure services beyond just Monitor Logs and Data Explorer.  

**Examples**  
- None mentioned explicitly in this segment.  

**Key Takeaways 🎯**  
- Understand that Log Analytics uses a database-like structure for logs.  
- Be familiar with KQL as the primary language for querying logs in Azure Monitor.  
- Remember that KQL is powerful for filtering, sorting, and analyzing log data.  
- Know that Azure Monitor Logs and KQL are built on Azure Data Explorer technology.  
- Recognize that KQL concepts align with relational database structures (tables, columns, clusters).  

---

### Kusto

**Timestamp**: 07:49:12 – 07:50:31

**Key Concepts**  
- Kusto Query Language (KQL) is the query language used to filter, sort, and manipulate Azure Monitor Logs and Azure Data Explorer data.  
- Kusto is based on a relational database management system (RDBMS) model.  
- Core entities in Kusto include clusters, databases, tables, columns, and functions.  
- Queries execute in the context of a Kusto database attached to a Kusto cluster.  
- KQL supports many operators such as calculated columns, searching/filtering rows, group by aggregates, and join functions.  
- KQL is widely used across Azure services including Log Analytics, log alert rules, workbooks, dashboards, logic apps, PowerShell, and Azure Monitor log APIs.

**Definitions**  
- **Kusto Query Language (KQL)**: The query language used to interact with Azure Data Explorer and Azure Monitor Logs for querying and analyzing data.  
- **Cluster**: An entity that holds multiple databases in Kusto.  
- **Database**: A named entity within a cluster that contains tables and stores functions.  
- **Table**: A named entity within a database that holds data organized in columns and rows. Each row contains one data value per column.  
- **Column**: A named field within a table representing a data attribute.  
- **Function**: Stored operations or reusable query components within a database.

**Key Facts**  
- Azure Monitor Logs is based on Azure Data Explorer, which uses Kusto and KQL.  
- Kusto supports relational database concepts: clusters > databases > tables > columns > rows.  
- Tables have an ordered set of columns and zero or more rows.  
- KQL operators include calculated columns, filtering, grouping, aggregation, and joins.  
- KQL is integrated into many Azure services beyond just Monitor Logs.

**Examples**  
- None mentioned explicitly in this segment.

**Key Takeaways 🎯**  
- Understand the hierarchical structure of Kusto: clusters contain databases, databases contain tables, tables contain columns and rows.  
- Know that KQL is the primary language for querying Azure Monitor Logs and Azure Data Explorer data.  
- Be familiar with the types of operations KQL supports (filtering, grouping, joins, calculated columns).  
- Remember that KQL is used broadly across Azure services, making it a critical skill for Azure monitoring and analytics tasks.  
- Queries always run in the context of a database attached to a cluster.

---

### Kusto Entities

**Timestamp**: 07:50:31 – 07:51:55

**Key Concepts**  
- Kusto entities form the structural hierarchy of Kusto data management.  
- Entities include clusters, databases, tables, columns, stored functions, and external tables.  
- Each entity has a specific role and relationship to others in the Kusto environment.  
- Columns have scalar data types and are referenced contextually in queries.  
- External tables allow querying or exporting data stored outside the Kusto cluster without ingestion.

**Definitions**  
- **Cluster**: An entity that holds multiple databases; the top-level container in Kusto.  
- **Database**: A named entity within a cluster that holds tables and stores functions.  
- **Table**: A named entity within a database that contains data organized in columns and rows.  
- **Column**: A named identity within a table that has a scalar data type; each row holds one value per column.  
- **Stored Function**: A named reusable query or query part stored within a database.  
- **External Table**: A table that exists outside the Kusto cluster, typically referencing data in external storage like BLOB storage (e.g., CSV files), used for querying or exporting data without ingestion.  
- **Scalar**: A single value fully described by magnitude or numerical value alone.

**Key Facts**  
- Tables have an ordered set of columns and zero or more rows.  
- Columns are referenced relative to the tabular data stream context of the query operator.  
- External tables are often stored in storage accounts such as BLOB storage and can be used for data export or querying external data sources.  

**Examples**  
- External tables referencing CSV files in BLOB storage.  

**Key Takeaways 🎯**  
- Understand the hierarchy: Cluster > Database > Table > Column.  
- Know that columns have scalar data types and are essential for query referencing.  
- Remember stored functions enable query reuse and modularity.  
- External tables provide flexibility to work with data outside Kusto without ingestion.  
- Be able to identify and differentiate between internal Kusto entities and external tables.

---

### Scalar Data Types

**Timestamp**: 07:51:55 – 07:54:33

**Key Concepts**  
- Scalar data types represent single values fully described by magnitude or numerical value alone.  
- Data types define how data is interpreted in Kusto, used for columns, function parameters, etc.  
- Kusto supports multiple scalar data types, each with specific characteristics and use cases.  
- Null is a special value representing missing data and can apply to any data type.

**Definitions**  
- **Scalar**: A quantity described by a single value or magnitude.  
- **Data Type**: A classification that defines how a piece of data is interpreted and stored.  
- **Boolean**: Represents a true or false value.  
- **DateTime / Date**: Represents date and time values stored in UTC.  
- **Decimal**: Numbers with fractional parts (e.g., 12.88).  
- **Integer**: Whole numbers without fractions.  
- **Long**: Integers with a greater range than standard integers.  
- **GUID / UUID**: Globally unique identifiers, random hashes used to uniquely identify values.  
- **Real**: Double precision floating point numbers, suitable for very large or precise values (e.g., finance).  
- **String**: Unicode text strings, limited by default to 1 MB, enclosed in quotations.  
- **TimeSpan**: Represents time intervals (e.g., 2D = 2 days, 30M = 30 minutes, 1 tick = 100 nanoseconds).  
- **Dynamic**: A flexible type that can hold any scalar value, arrays, or nested property bags (similar to JSON objects).  
- **Null**: A special value indicating missing or undefined data; applicable to all data types.

**Key Facts**  
- DateTime values are stored in UTC time zone.  
- Strings are Unicode and limited to 1 MB by default.  
- TimeSpan supports multiple interval formats, including days (D), minutes (M), and ticks (100 nanoseconds).  
- Dynamic type can hold complex nested structures, arrays, or primitive scalar values.  
- Null values can be assigned to any scalar data type (e.g., Boolean can be true, false, or null).

**Examples**  
- Boolean: true or false  
- Decimal: 12.88  
- TimeSpan: "2D" means 2 days, "30M" means 30 minutes, "1 tick" equals 100 nanoseconds  
- Dynamic: Can hold JSON-like key-value pairs or arrays (no explicit example given, but described conceptually)  
- String example: "hello world" (wrapped in quotations)

**Key Takeaways 🎯**  
- Understand the difference between scalar and complex data types; scalar means single value.  
- Be familiar with the common scalar data types in Kusto and their typical use cases.  
- Remember that DateTime is always in UTC and strings have a size limit.  
- Dynamic data type is versatile and important for handling JSON-like or nested data.  
- Null can be assigned to any scalar type and represents missing data—important for data integrity and querying.  
- TimeSpan format uses shorthand notation (D, M, tick) for representing intervals—know these for interpreting time data.

---

### Control Commands

**Timestamp**: 07:54:33 – 07:55:51

**Key Concepts**  
- Control commands in Kusto are special commands used to manage databases and tables, not just query data.  
- They are part of the Kusto Query Language (KQL) but serve administrative and management purposes.  
- Control commands always start with a period (`.`).  
- They provide functionality similar to database management commands in other systems (e.g., Postgres).  
- Common control commands include creating tables and showing metadata like existing tables.  
- Control commands can be explored interactively by typing a period and starting to type the command in query tools like Log Analytics.

**Definitions**  
- **Control Commands**: Commands in Kusto that begin with a period (`.`) and are used to manage databases, tables, and other schema objects rather than querying data directly.  
- **.create table**: A control command used to create a new table with specified columns in Kusto.  
- **.show tables**: A control command used to list all tables and count the number of tables in the database.

**Key Facts**  
- Control commands always start with a period (`.`).  
- The `.create table` command requires specifying the table name and columns.  
- The `.show` command can take various parameters to display different metadata; `.show tables` is a common usage.  
- Documentation for the full list of control commands is extensive and sometimes hard to find, but query tools provide autocomplete and suggestions when typing `.`.  

**Examples**  
- `.create table logs (Column1:type, Column2:type)` — creates a table named "logs" with two columns.  
- `.show tables` — displays all tables and counts them.

**Key Takeaways 🎯**  
- Remember that control commands are distinct from query commands and are used for database/table management.  
- Always start control commands with a period (`.`).  
- Use `.show tables` to quickly check existing tables in your Kusto database.  
- Utilize autocomplete in query tools to discover available control commands since documentation can be overwhelming.  
- Knowing how to create tables and list tables with control commands is essential for managing Kusto environments.

---

### Functions

**Timestamp**: 07:55:51 – 07:57:30

**Key Concepts**  
- Kusto functions are reusable queries or query parts.  
- Functions in Kusto come in several types: stored functions, query-defined functions, and built-in functions.  
- Stored functions are user-defined and managed as database schema entities.  
- User-defined functions are categorized into scalar functions and tabular functions.  
- Query-defined functions exist only within the scope of a single query.  
- Built-in functions are hard-coded by Kusto and cannot be modified by users.  
- Built-in functions include special functions (to select entities), aggregate functions (to perform calculations like count), and window functions (operate on multiple rows, e.g., row_number).  
- Scalar operators work with scalar data types and include byte-wise operators (binary AND, NOT, OR, shifts, XOR) and logical operators (equality, inequality, AND, OR).

**Definitions**  
- **Stored Functions**: User-defined functions stored and managed as part of the database schema.  
- **Scalar Functions**: Functions that take scalar inputs and return scalar outputs.  
- **Tabular Functions**: Functions that take tabular inputs and return tabular outputs (multiple rows).  
- **Query-Defined Functions**: User-defined functions limited to the scope of a single query.  
- **Built-in Functions**: Predefined, hard-coded functions by Kusto that provide utility and cannot be changed by users.  
- **Aggregate Functions**: Functions that perform calculations on sets of values and return a single value (e.g., count).  
- **Window Functions**: Functions that operate on multiple rows, often used for ranking or row numbering (e.g., row_number).  
- **Byte-wise Operators**: Operators that manipulate bits (AND, NOT, OR, shift left/right, XOR).  
- **Logical Operators**: Operators for logical comparisons (equals, not equals, AND, OR).

**Key Facts**  
- Stored functions are managed as database schema entities.  
- Scalar functions handle single values; tabular functions handle tables (multiple rows).  
- Query-defined functions differ from stored functions by their limited scope (single query).  
- Built-in functions cannot be modified by users.  
- Aggregate functions return a single value from multiple inputs.  
- Window functions can assign row numbers or perform calculations across rows.  
- Byte-wise operators require knowledge of binary math but are available if needed.

**Examples**  
- Using `.show tables` to list tables and count them (mentioned as a control command example).  
- Aggregate function example: `count()` to count rows or values.  
- Window function example: `row_number()` to assign row numbers within query results.

**Key Takeaways 🎯**  
- Understand the different types of functions in Kusto and their scope (stored vs query-defined vs built-in).  
- Remember scalar vs tabular functions and their input/output types.  
- Built-in functions are essential utilities but cannot be changed.  
- Aggregate and window functions are important for summarizing and analyzing data sets.  
- Be familiar with scalar operators, especially logical operators, as they are commonly used in queries.  
- Byte-wise operators exist but are more specialized—know they are available but focus on logical operators for exams.

---

### Scalar Operators

**Timestamp**: 07:57:30 – 07:59:35

**Key Concepts**  
- Scalar operators work with scalar data types to perform comparisons and calculations.  
- Categories of scalar operators include byte-wise, logical, date/time arithmetic, numerical, string, and range operators.  
- Byte-wise operators manipulate binary data at the bit level.  
- Logical operators handle common comparisons like equality and inequality.  
- Date/time operators allow arithmetic on dates and time spans (add, subtract, multiply, divide).  
- Numerical operators work on integers, longs, and reals with arithmetic and modulus operations.  
- String operators often have negated forms indicated by an exclamation mark (!).  
- Between operators check if a value falls within an inclusive range.

**Definitions**  
- **Byte-wise operators**: Operators that work on binary data using bitwise logic such as AND, OR, NOT, XOR, shift left, and shift right.  
- **Logical operators**: Operators for boolean logic and comparisons, e.g., equals (=), not equals (!=), AND, OR.  
- **Date/time arithmetic operators**: Operators that add, subtract, multiply, or divide date and time values or time spans.  
- **Numerical operators**: Arithmetic operators (+, -, *, /) and modulus (%) for numeric types like int, long, and real.  
- **String operators**: Operators that perform operations on string values, often with negated versions using !.  
- **Between operator**: Checks if a value lies inclusively between two other values (e.g., between 1 and 10).

**Key Facts**  
- Byte-wise operators include: binary AND, NOT, OR, XOR, shift left, shift right.  
- Modulus operator (%) determines divisibility and remainder (e.g., 17 % 2 returns 1 because 17 is not divisible by 2).  
- Logical operators include equals, not equals, less than, greater than, less or equal, greater or equal.  
- String operators have negated variants prefixed with an exclamation mark (!).  
- Between operator works with numbers and date/time ranges inclusively.

**Examples**  
- Modulus example: `17 % 2` returns 1 (since 17 is not divisible by 2).  
- Between example: `between 1 and 10` or `between these date times` to check if a value falls within that range.

**Key Takeaways 🎯**  
- Understand the different categories of scalar operators and their purposes.  
- Remember that byte-wise operators manipulate bits and are useful if you know binary math.  
- Logical and numerical operators are fundamental for comparisons and arithmetic in queries.  
- The modulus operator is useful for checking divisibility.  
- String operators often have negated forms using `!`—know this for filtering conditions.  
- The between operator is a concise way to check if a value lies within an inclusive range.  
- These scalar operators form the basis for more complex query logic in Kusto Query Language (KQL).

---

### Tabular Operators

**Timestamp**: 07:59:35 – 08:01:11

**Key Concepts**  
- Tabular operators perform comparisons and operations on multiple rows of data (tables).  
- These operators are fundamental to the power of Kusto Query Language (KQL).  
- Many tabular operators have direct analogues in SQL, making them easier to understand if you have SQL experience.  

**Definitions**  
- **Count**: Returns the total number of rows in a table.  
- **Take**: Returns up to a specified number of rows from the table (similar to SQL’s LIMIT).  
- **Sort**: Orders rows by one or more columns, e.g., sorting by a property descending.  
- **Project**: Selects a specific set of columns from the table (similar to SQL’s SELECT).  
- **Where**: Filters rows based on a predicate condition.  
- **Top**: Returns the first N records sorted by specified columns; a shorthand combining take and sort.  
- **Extend**: Creates a new column by computing a value based on existing columns (e.g., `duration = endtime - starttime`).  
- **Summarize**: Aggregates groups of rows, similar to SQL’s GROUP BY.  
- **Render**: Outputs results as graphical visualizations.  

**Key Facts**  
- Tabular operators work on sets of rows, enabling powerful data manipulation and analysis in KQL.  
- Operators like take, sort, project, and where have direct SQL equivalents, aiding learning and application.  
- The top operator simplifies the combination of take and sort into a single step.  
- Extend allows creation of calculated columns for further use in queries.  
- Summarize is essential for aggregation and grouping data.  
- Render is used to visualize query results graphically within Kusto.  

**Examples**  
- Sorting rows by a damage property in descending order (`sort by damage desc`).  
- Creating a new column `duration` by subtracting `starttime` from `endtime` using extend (`extend duration = endtime - starttime`).  

**Key Takeaways 🎯**  
- Understand the core tabular operators as they form the backbone of querying in KQL.  
- Remember the SQL analogies to help recall operator functions:  
  - take ≈ limit  
  - sort ≈ order by  
  - project ≈ select  
  - summarize ≈ group by  
- Use top for quick retrieval of sorted subsets of data.  
- Use extend to add computed columns for richer data analysis.  
- Summarize is critical for aggregation tasks.  
- Render is useful for producing visual outputs directly from queries.  
- Focus on these common operators rather than trying to memorize all tabular operators.

---

### Metrics Explorer

**Timestamp**: 08:01:11 – 08:02:39

**Key Concepts**  
- Metrics Explorer is a subservice of Azure Monitor used to plot charts and visualize metric trends.  
- It helps investigate spikes and dips in metric values through customizable graphs.  
- Visualization setup involves selecting scope, namespace, metric, and aggregation method.  

**Definitions**  
- **Metrics Explorer**: A tool within Azure Monitor that allows users to create visual charts of metric data to analyze trends and anomalies.  
- **Scope**: The resource or set of resources selected for metric visualization (e.g., subscription, resource group, or individual resource).  
- **Namespace**: A specific grouping of metric data within a resource, varying by service type (e.g., for storage accounts: account, BLOB, file, queue, table).  
- **Metric**: The specific measurement or data point you want to visualize (e.g., availability, ingress, egress).  
- **Aggregation**: The method used to summarize metric data over time, such as average, minimum, or maximum.  

**Key Facts**  
- Some services allow selecting multiple resources for scope; others only allow a single resource instance.  
- The available namespaces and metrics depend on the resource type selected.  
- Aggregation options vary depending on the resource and metric chosen.  

**Examples**  
- Example resource: a storage account named "Dastrum Institute."  
- Storage account namespaces include account, BLOB, file, queue, and table.  
- Metrics for storage accounts include availability, ingress, egress, etc.  

**Key Takeaways 🎯**  
- Always start by selecting the correct scope (resource or resources) before defining the metric visualization.  
- Understand that namespaces group related metrics and vary by service type.  
- Choose the appropriate metric and aggregation method to get meaningful insights.  
- Metrics Explorer is essential for visualizing and troubleshooting resource performance and behavior trends.  

---

### Alerts

**Timestamp**: 08:02:39 – 08:04:22

**Key Concepts**  
- Azure Alerts notify you when issues are detected in infrastructure or applications.  
- Alerts help identify and resolve problems before users notice them.  
- There are three types of alerts: Metric alerts, Log alerts, and Activity log alerts.  
- Alerts are based on alert rules that define what to monitor and when to trigger an alert.  
- Target resources emit signals (metrics, logs, activity logs, application insights) that alerts evaluate.  
- Criteria or logical tests determine if an alert should be triggered (e.g., CPU usage > 70%).  
- Action groups define what actions to take when an alert triggers (e.g., run automation, call webhooks).  
- Alert states track the lifecycle of an alert, with system-set monitor conditions and user-set alert states (e.g., marking an alert as closed).

**Definitions**  
- **Alert Rule**: A configuration that specifies the resource to monitor and the conditions under which an alert is triggered.  
- **Signal**: Data emitted by a resource, such as metrics, logs, or activity logs, used to evaluate alert criteria.  
- **Criteria / Logical Test**: The condition(s) evaluated against signals to determine if an alert should be triggered.  
- **Action Group**: A collection of actions (automation runbooks, Azure Functions, ITSM, Logic Apps, Webhooks) executed when an alert fires.  
- **Monitor Condition**: The alert state set automatically by the system indicating the current status of the alert.  
- **Alert State**: The status set by the user to track the alert lifecycle (e.g., active, acknowledged, closed).

**Key Facts**  
- Alerts can be triggered based on metrics, logs, or activity logs.  
- Actions on alert trigger can include automation runbooks, Azure Functions, ITSM integrations, Logic Apps, Webhooks, and Secure Webhooks.  
- Monitor condition is system-controlled; alert state is user-controlled for tracking resolution status.

**Examples**  
- Example of a criteria: CPU percentage greater than 70%.  
- Example actions: running an automation runbook or triggering a Logic App.

**Key Takeaways 🎯**  
- Understand the three types of Azure alerts and their data sources.  
- Know the components of an alert: alert rule, signal, criteria, and action group.  
- Remember that alerts help proactively detect and resolve issues before impacting users.  
- Be familiar with how alert states work for tracking and managing alerts.  
- Know common actions that can be automated when an alert triggers.  
- While detailed alert state management may not be exam-critical, understanding the overall alert workflow is important.

---

### Dashboards

**Timestamp**: 08:04:22 – 08:05:04  

**Key Concepts**  
- Azure Dashboards are virtual workspaces designed for quick task launching and resource monitoring.  
- Dashboards can be customized based on projects, tasks, or user roles.  
- Users can add various tiles such as videos, links, clocks, metrics, and markdown to tailor the dashboard.  
- Dashboards help focus on relevant infrastructure elements by role or responsibility.  

**Definitions**  
- **Azure Dashboards**: Customizable virtual workspaces within the Azure portal that allow users to monitor resources and launch operational tasks efficiently.  

**Key Facts**  
- Dashboards support drag-and-drop tile editing for easy customization.  
- Tiles can include multimedia (video), links (help/support), clocks, metrics, and markdown content.  

**Examples**  
- Adding a video tile, a help/support link, a clock, and key metrics to a dashboard to create a role-focused workspace.  

**Key Takeaways 🎯**  
- Understand that Azure Dashboards are customizable and role-based to improve operational efficiency.  
- Remember the types of content you can add to dashboards (video, links, clocks, metrics, markdown).  
- Dashboards are distinct from Workbooks, which are more document-like and focused on data storytelling and analysis.  

---

### Workbooks

**Timestamp**: 08:05:04 – 08:06:21

**Key Concepts**  
- Workbooks provide a flexible, interactive canvas for data analysis and rich visual reporting within the Azure portal.  
- They unify multiple Azure data sources into a single, interactive experience.  
- Workbooks tell a "story" about application and service performance and availability.  
- Unlike dashboards, Workbooks are more like documents embedding real-time analytics for investigation and discussion.  
- Highly customizable and designed for performance monitoring and analysis.  
- Comparable conceptually to Jupyter Notebooks but focused on performance and monitoring.  
- Similar tools exist in other platforms (e.g., Datadog notebooks).

**Definitions**  
- **Azure Workbooks**: A flexible canvas in the Azure portal that combines multiple data sources into interactive, customizable reports to analyze and visualize application and service performance and availability.  
- **Application Insights**: An Application Performance Management (APM) service within Azure Monitor that automatically detects performance anomalies and provides analytics to diagnose issues and understand user behavior.

**Key Facts**  
- Workbooks are part of Azure Monitor’s scope.  
- They are not dashboards but document-like with embedded real-time analytics.  
- Workbooks support combining multiple Azure data sources.  
- Application Insights is a sub-service of Azure Monitor focused on APM.  
- Application Insights supports apps built on .NET, Node.js, Java, Python, and can be used on-premises, hybrid, or any public cloud.

**Examples**  
- Workbooks are likened to Jupyter Notebooks for performance monitoring.  
- Datadog’s similar feature is called notebooks instead of workbooks.  
- Application Insights is used as an example of an APM service integrated with Azure Monitor.

**Key Takeaways 🎯**  
- Remember that Azure Workbooks are interactive, customizable documents for real-time performance and availability analysis, not just static dashboards.  
- Workbooks enable combining multiple data sources to tell a comprehensive story about your applications.  
- Think of Workbooks as a tool for investigation and discussion, similar to Jupyter Notebooks but focused on monitoring.  
- Application Insights is a key APM tool within Azure Monitor that automatically detects anomalies and helps diagnose issues across multiple app platforms.  
- Knowing the distinction between dashboards and Workbooks is important for exam scenarios related to Azure monitoring tools.

---

### Application Insights

**Timestamp**: 08:06:21 – 08:09:54

**Key Concepts**  
- Application Insights is an Application Performance Management (APM) service and a sub-service of Azure Monitor.  
- APM tools monitor and manage software application performance and availability.  
- Application Insights automatically detects performance anomalies and provides powerful analytics to diagnose issues and understand user behavior.  
- Supports multiple programming languages officially (.NET, Node.js, Java, Python) and unofficially others like Ruby.  
- Integrates with DevOps processes and can monitor telemetry from mobile apps via Visual Studio App Center.  
- Instrumentation involves installing SDKs or enabling monitoring directly in supported Azure services.  
- Telemetry data from instrumented apps can be viewed and analyzed through various tools and exported to multiple services.  
- Application Insights can monitor apps running on any environment, including on-premises, hybrid, public cloud, and even AWS.  
- The Application Insights resource in Azure is identified by an instrumentation key (IKEY).  

**Definitions**  
- **Application Insights**: An APM service within Azure Monitor that collects telemetry data to monitor application performance and usage.  
- **APM (Application Performance Management)**: Tools and processes that monitor and manage the performance and availability of software applications, aiming to detect and diagnose complex performance problems.  
- **Instrumentation**: The process of adding code or enabling features in an application to send telemetry data to Application Insights.  
- **Instrumentation Key (IKEY)**: A unique identifier for an Application Insights resource used to associate telemetry data with the correct resource.  

**Key Facts**  
- Application Insights monitors:  
  - Request rates, response times, failure rates  
  - Dependency rates and response times  
  - Exceptions, page views, load performance, AJAX calls  
  - User and session counts  
  - Performance counters, host diagnostics, diagnostic trace logs  
  - Custom events and metrics  
- Telemetry data can be consumed via:  
  - Smart detection and manual alerts  
  - Application map and profiler  
  - Usage analysis and diagnostic search  
  - Metrics explorer, dashboards, live metric streams  
  - Analytics, Visual Studio integration, Snapshot Debugger  
  - Power BI, REST API, continuous export  
- Instrumentation can be done by installing SDKs or enabling monitoring with a button in Azure services where supported.  
- Application Insights works across multiple environments, including AWS-hosted apps.  

**Examples**  
- Example application architecture mentioned includes a front end, back end, and workers to illustrate instrumentation points.  
- Comparison to Datadog and other APM tools like Skylight and New Relic to contextualize Application Insights.  

**Key Takeaways 🎯**  
- Always instrument your applications with Application Insights to gain visibility into performance and user behavior.  
- Understand that Application Insights is part of Azure Monitor and integrates deeply with Azure services and DevOps workflows.  
- Know the key telemetry metrics Application Insights collects and the variety of tools available to analyze this data.  
- Remember the importance of the instrumentation key (IKEY) to link telemetry data to the correct Application Insights resource.  
- Application Insights supports multiple languages and deployment environments, making it versatile for cloud and hybrid scenarios.  
- Familiarize yourself with the different ways to access telemetry data (portal, APIs, Power BI, Visual Studio, etc.) for monitoring and diagnostics.

---

### Monitor CheatSheet

**Timestamp**: 08:09:54 – 08:15:45

**Key Concepts**  
- Azure Monitor is a comprehensive telemetry solution for cloud and on-premises environments.  
- Observability requires the combined use of metrics, logs, and traces.  
- Azure Monitor collects two fundamental types of data: logs and metrics.  
- Logs are collected and analyzed in Log Analytics workspaces using Kusto Query Language (KQL).  
- Metrics are numeric data collected over time, visualized via Metrics Explorer.  
- Alerts notify on issues and come in three types: metrics alerts, logs alerts, and activity log alerts.  
- Azure Dashboards and Workbooks provide visualization and reporting capabilities.  
- Application Insights is an Application Performance Management (APM) service under Azure Monitor for monitoring app performance and usage.  
- Instrumentation (via SDK or agents) is required to enable Application Insights on applications.

**Definitions**  
- **Azure Monitor**: An umbrella service that collects, analyzes, and acts on telemetry data from cloud and on-premises resources.  
- **Metrics**: Numerical values measured over time intervals, useful for near real-time monitoring and fast issue detection.  
- **Logs**: Text-based event data capturing what happened in the system, consolidated in workspaces.  
- **Traces**: A history of requests flowing through multiple apps and services to diagnose performance or failures.  
- **Log Analytics Workspace**: A unique environment with its own data repository and configuration for storing and querying logs.  
- **Kusto Query Language (KQL)**: The query language used to analyze Azure Monitor logs, based on a relational database model.  
- **Metric Explorer**: A tool to visualize and analyze metric data by defining scope, namespace, metric, and aggregation.  
- **Alerts**: Notifications triggered by metrics, logs, or activity logs to proactively address issues.  
- **Azure Dashboards**: Virtual workspaces for monitoring and managing Azure resources.  
- **Azure Workbooks**: Flexible canvases for data analysis and rich visual report creation in Azure Portal.  
- **Application Insights**: An APM service that detects anomalies, diagnoses issues, and tracks user behavior across multiple platforms.  
- **Instrumentation Key (I Key)**: A unique identifier for an Application Insights resource used to collect telemetry data.

**Key Facts**  
- Azure Monitor logs and metrics are the two fundamental data types collected.  
- Logs are consolidated from multiple sources including platform logs, Azure services, and VM agents.  
- KQL supports operations similar to SQL: calculated columns, filtering, grouping, and stored functions.  
- Clusters contain databases; databases contain tables and stored functions; tables contain columns.  
- Alerts come in three types: metrics alerts, logs alerts, and activity log alerts.  
- Application Insights supports multiple platforms (.NET, Node.js, Java, Python) and deployment models (on-prem, hybrid, cloud).  
- Instrumentation can be done via SDK packages or Application Insights agents.  
- Application Insights telemetry is viewed through the Azure portal by accessing the Application Insights resource.

**Examples**  
- None explicitly mentioned beyond general use cases (e.g., web applications, multi-platform app monitoring).

**Key Takeaways 🎯**  
- Understand the three pillars of observability: metrics, logs, and traces, and how Azure Monitor integrates them.  
- Know the difference between logs (text event data) and metrics (numeric time-series data).  
- Be familiar with Log Analytics and KQL for querying log data.  
- Remember the structure of Kusto entities: clusters, databases, tables, columns, and functions.  
- Use Metric Explorer to visualize and analyze metrics data effectively.  
- Know the three types of Azure alerts and their purpose in proactive monitoring.  
- Recognize the role of Azure Dashboards and Workbooks for operational monitoring and reporting.  
- Application Insights is key for application performance monitoring and requires instrumentation to collect data.  
- The instrumentation key uniquely identifies Application Insights resources and is essential for telemetry collection.

---

### Backup

**Timestamp**: 08:15:45 – 08:31:10

**Key Concepts**  
- Azure Backup Service is a backup layer integrated across multiple Azure services but not searchable as a standalone service in the portal.  
- Azure Backup supports backing up on-premises resources, Azure VMs, Azure Files, SQL Server on Azure VMs, SAP HANA on Azure VMs, and Azure Database for PostgreSQL.  
- Azure Recovery Services Vault is a storage entity that holds backup data and recovery points over time.  
- The MARS (Microsoft Azure Recovery Services) agent is installed on Windows machines (on-prem or Azure VMs) to back up files, folders, and system state to the Recovery Services Vault.  
- Azure Site Recovery (ASR) is a hybrid disaster recovery solution that replicates workloads from a primary site (often on-premises) to a secondary site (often Azure) for failover.  
- Backup policies define backup frequency, retention (daily, weekly, monthly, yearly), and snapshot retention.  
- Recovery Point Objective (RPO) and Recovery Time Objective (RTO) are critical terms in backup and disaster recovery strategies.

**Definitions**  
- **Azure Backup Service**: A backup solution integrated with various Azure services to protect data and workloads without needing third-party tools.  
- **Azure Recovery Services Vault**: A logical storage entity in Azure that stores backup data and recovery points for workloads.  
- **MARS Agent (Microsoft Azure Recovery Services Agent)**: A Windows-only backup agent installed on machines to back up files, folders, and system state to the Recovery Services Vault. Also known as Azure Backup Agent.  
- **Azure Site Recovery (ASR)**: A hybrid cloud disaster recovery service that replicates workloads between sites (on-premises to Azure or between Azure regions) to enable failover and business continuity.  
- **Backup Policy**: Configuration that specifies backup frequency, retention periods, and snapshot schedules for protected resources.  
- **Recovery Point Objective (RPO)**: The maximum acceptable amount of data loss measured in time (how often backups occur).  
- **Recovery Time Objective (RTO)**: The target time to restore service after a disruption.

**Key Facts**  
- Azure Backup provides unlimited data transfer with no extra charge.  
- Backup data is secured both at rest and in transit.  
- Azure Backup supports app-consistent backups, enabling restoration to an exact application state.  
- Recovery Services Vault supports role-based access control (RBAC), soft delete, and cross-region restore.  
- The MARS agent only supports Windows OS; Linux backups are handled differently through Azure Recovery Services.  
- Backup policies can be created and assigned via the Recovery Services Vault, with options for daily, weekly, monthly, and yearly retention.  
- Azure Site Recovery supports replication of Windows, Linux, VMware, Hyper-V, and physical machines, and can replicate workloads across clouds.  
- Azure Backup is not directly searchable as a standalone service; it is accessed via individual service backup tabs or through Recovery Services Vaults.  
- Backup policies are essential for managing backup schedules and retention and can be customized per workload.

**Examples**  
- Creating a Recovery Services Vault named "Picard backup" in a resource group.  
- Deploying a Windows Server 2019 Gen 2 VM (B2S size) named "Virtual Machine Picard" for backup demonstration.  
- Enabling backup on the VM using a default or custom backup policy with daily backups retained for 30 days or longer (e.g., 180 days).  
- Using the Azure portal Backup Center to manage vaults, backup jobs, and policies.

**Key Takeaways 🎯**  
- Know the difference between Azure Backup Service, Recovery Services Vault, and the MARS agent.  
- Understand that Azure Backup is integrated into individual services and accessed via Recovery Services Vaults rather than as a standalone service.  
- Be familiar with the MARS agent’s role, its Windows-only support, and that it backs up to Recovery Services Vault.  
- Backup policies are critical: know how to configure frequency and retention settings.  
- Remember RPO and RTO as fundamental concepts in backup and disaster recovery planning.  
- Azure Site Recovery is a key hybrid disaster recovery tool supporting cross-site and cross-cloud replication.  
- Azure Backup offers unlimited data transfer and built-in security, making it scalable and cost-effective.  
- Soft delete and RBAC in Recovery Services Vault help protect backup data and control access.  
- Practical exam scenarios may involve creating vaults, assigning backup policies, and enabling backups on Azure VMs.

---

## Containers

### ACI

**Timestamp**: 08:31:10 – 08:41:42

**Key Concepts**  
- Azure Container Instances (ACI) allow packaging, deploying, and managing cloud applications using containers.  
- ACI is a fully managed Docker-as-a-service, removing the need to manage underlying VMs.  
- Containers can be provisioned in seconds vs. minutes for VMs.  
- Containers are billed per second; VMs are billed per hour.  
- Containers support granular/custom sizing of vCPU, memory, and GPUs; VM sizes are fixed.  
- ACI supports both Windows and Linux containers.  
- Persistent storage in ACI is achieved by mounting external volumes, commonly Azure Files.  
- Containers are stateless by default; state persistence requires external volume mounts.  
- Container groups are collections of containers scheduled on the same host, sharing lifecycle, network, and storage resources.  
- Container groups are similar to Kubernetes pods but are not the same.  
- Multi-container groups currently support only Linux containers.  
- Deployment of multi-container groups can be done via ARM templates (for complex deployments) or YAML files (for container-only deployments).  
- Container restart policies: **Always**, **Never**, and **OnFailure**.  
- Environment variables (including secured environment variables) can be passed to containers via portal, CLI, or PowerShell.  
- CLI commands for troubleshooting: `az container logs`, `az container attach`, `az container exec`, and `az monitor metrics list`.  

**Definitions**  
- **Azure Container Instances (ACI)**: A service to launch containers in Azure without managing underlying VMs, designed for isolated containers running simple apps, task automation, or build jobs.  
- **Container Group**: A set of containers deployed on the same host machine that share lifecycle, network, and storage resources.  
- **Restart Policies**: Rules defining when a container should restart:  
  - **Always**: Restart container regardless of exit status (ideal for services/web servers).  
  - **Never**: Run container once and do not restart (ideal for background jobs/tasks).  
  - **OnFailure**: Restart container only if it exits with an error.  
- **Environment Variables (nVars)**: Key-value pairs passed to containers for configuration; can be secured to avoid exposure of sensitive data.  

**Key Facts**  
- Containers start in seconds; VMs take minutes.  
- Billing is per second for containers, per hour for VMs.  
- Multi-container groups only support Linux containers currently.  
- Persistent storage options include Azure Files, Secret Volumes, Empty Directory, Cloud Git Repo.  
- Mounting external volumes requires CLI or PowerShell; not supported via portal UI.  
- Containers accessed via fully qualified domain names (FQDN).  

**Examples**  
- Deploying a simple "Hello World" container instance using Azure’s quick start image.  
- Creating a container group named "Banana" with a Linux container in East US 2 region.  
- Mounting Azure Files to containers to persist data across container restarts.  
- Using CLI commands to fetch logs (`az container logs`), attach to container (`az container attach`), execute commands inside container (`az container exec`), and retrieve metrics (`az monitor metrics list`).  

**Key Takeaways 🎯**  
- Know the benefits of containers over VMs: faster provisioning, per-second billing, and flexible sizing.  
- Understand container groups and their similarity to Kubernetes pods but recognize they are not identical.  
- Remember multi-container groups only support Linux containers at this time.  
- Be familiar with the three container restart policies and their use cases.  
- Containers are stateless by default; always plan to mount external storage for persistence.  
- Know how to pass environment variables securely to containers, especially secrets.  
- Be comfortable with Azure CLI commands for troubleshooting containers, as these may appear on the exam.  
- Remember that mounting external volumes cannot be done through the portal; use CLI or PowerShell.  
- ACI containers are accessible via fully qualified domain names, which is common in Azure services.

---

### ACR

**Timestamp**: 08:41:42 – 08:45:19

**Key Concepts**  
- Azure Container Registry (ACR) is a managed private Docker registry service based on Docker Registry 2.0.  
- ACR integrates with existing container development and deployment pipelines.  
- ACR Tasks enable automated building and patching of container images in Azure.  
- Container images stored in ACR can be pulled to various deployment targets such as Kubernetes, DCOS, Docker Swarm, and multiple Azure services (AKS, Azure App Service, Azure Batch, Azure Service Fabric).  
- ACR supports multiple ways to interact: Azure CLI, PowerShell, Portal, SDK, and Docker Extension for Visual Studio Code.  
- ACR Tasks can be triggered on demand, by source code updates, base image updates, or on a schedule.  
- Multi-step ACR Tasks allow complex build workflows.  
- Each ACR Task has an associated source code context (location of source files for building images).  
- Run variables in ACR Tasks enable reuse of task definitions and standardized tagging.

**Definitions**  
- **Azure Container Registry (ACR)**: A managed private Docker registry service in Azure for storing and managing private container images and related artifacts.  
- **ACR Tasks**: Automated workflows in ACR to build, patch, and manage container images, supporting triggers and multi-step processes.  
- **Source Code Context**: The location of source files used by an ACR Task to build container images or artifacts.  
- **Run Variables**: Variables used in ACR Tasks to reuse task definitions and standardize image tagging.

**Key Facts**  
- ACR is based on open source Docker Registry 2.0.  
- Supports integration with container orchestrators and Azure services like AKS, Azure App Service, Azure Batch, and Azure Service Fabric.  
- Developers can push images to ACR using Azure Pipelines, Jenkins, CLI, PowerShell, Portal, SDK, or Docker Extension for VS Code.  
- ACR Tasks do not require a local Docker Engine installation to push images.  
- Triggers for ACR Tasks include source code changes, base image updates, and scheduled timers.  
- Multi-step tasks allow complex build sequences.  
- Run variables help standardize and reuse task definitions.

**Examples**  
- Using ACR Tasks to automate OS and framework patching for Docker containers.  
- Triggering automated builds when source code or base images are updated.  
- Pulling container images from ACR to Kubernetes, DCOS, or Docker Swarm clusters.  
- Using Docker Extension for Visual Studio Code to work with ACR.

**Key Takeaways 🎯**  
- Know that ACR is a managed private Docker registry service tightly integrated with Azure and container orchestration platforms.  
- Understand the purpose and capabilities of ACR Tasks for automating container image builds and patching.  
- Remember that ACR Tasks support multiple trigger types and multi-step workflows.  
- Be familiar with the concept of source code context and run variables in ACR Tasks.  
- Recognize the various ways to interact with ACR, including CLI, PowerShell, Portal, SDK, and VS Code Docker Extension.  
- For the exam, focus on ACR’s role in container image management and automation within Azure DevOps pipelines and deployment workflows.

---

### AKS

**Timestamp**: 08:45:19 – 09:13:36

**Key Concepts**  
- Azure Kubernetes Service (AKS) is a fully managed Kubernetes as a Service offering by Azure.  
- AKS manages the Kubernetes master components (control plane), health monitoring, and maintenance.  
- Users are responsible only for managing the agent nodes (worker nodes).  
- AKS service itself is free; you only pay for the agent nodes.  
- AKS supports advanced features during deployment such as advanced networking, Azure AD integration (RBAC), monitoring, and Windows Server containers.  
- AKS is suitable when full container orchestration is needed: service discovery, automatic scaling, coordinated application upgrades.  
- Bridge to Kubernetes is a Visual Studio/Visual Studio Code extension that allows developers to debug microservices locally while connected to an AKS cluster.  
- Kubernetes clusters in Azure require registration of the Kubernetes resource provider before use.  
- Azure CLI (`az`) and `kubectl` are primary tools for managing AKS clusters and Kubernetes resources.  
- Deployments can be created using pre-built container images (e.g., NGINX, HTTPD/Apache).  
- Pods can be scaled using `kubectl scale` to increase replicas.  
- Node pools can be scaled using `az aks scale` to increase the number of nodes.  
- Kubernetes resources and cluster management can be done via Azure Portal, CLI, or YAML/JSON configuration files.  
- Cleaning up involves deleting deployments, pods, and the AKS cluster to avoid unnecessary costs.

**Definitions**  
- **AKS (Azure Kubernetes Service)**: A managed Kubernetes service in Azure where the control plane is managed by Azure and users manage only the agent nodes.  
- **Agent Nodes**: Worker nodes in the Kubernetes cluster that run containerized applications.  
- **Bridge to Kubernetes**: A Visual Studio/VS Code extension that enables local development and debugging of microservices connected to an AKS cluster by proxying traffic.  
- **kubectl**: Kubernetes command-line tool used to interact with Kubernetes clusters.  
- **Node Pool**: A group of nodes within an AKS cluster that share the same configuration.  
- **Load Balancer Service**: A Kubernetes service type that exposes an application externally using a cloud provider’s load balancer.

**Key Facts**  
- AKS control plane (masters) is free; only agent nodes incur cost.  
- Recommended node count for production: 3 nodes; for development: 1 node.  
- Minimum node VM size requirements: at least 2 cores and 4 GB memory.  
- Default node size DS2 v2 costs approximately $136/month; smaller sizes cost less but may not meet minimum requirements.  
- Scaling pods example: increasing replicas from 1 to 3 using `kubectl scale deployment <name> --replicas=3`.  
- Scaling nodes example: increasing node count to 3 using `az aks scale --resource-group <rg> --name <cluster> --node-count 3`.  
- After deployment, services can be exposed with type LoadBalancer to get an external IP address for public access.  
- Azure Portal may have delays or inconsistencies in reflecting real-time cluster status; CLI verification is recommended.

**Examples**  
- Creating an AKS cluster named "Borg" in resource group "Borg" with 1 node for development.  
- Deploying NGINX using: `kubectl create deployment nginx --image=nginx`  
- Exposing NGINX deployment with: `kubectl expose deployment nginx --port=80 --type=LoadBalancer`  
- Deploying Apache HTTPD using: `kubectl create deployment httpd --image=httpd`  
- Scaling HTTPD deployment to 3 pods: `kubectl scale deployment httpd --replicas=3`  
- Scaling AKS node pool to 3 nodes: `az aks scale --resource-group Borg --name Borg --node-count 3`  
- Cleaning up by deleting deployments (`kubectl delete deployment nginx` and `kubectl delete deployment httpd`) and deleting the AKS cluster from Azure Portal or CLI.

**Key Takeaways 🎯**  
- Remember AKS control plane is free; cost is only for agent nodes.  
- Always register the Kubernetes resource provider before creating AKS clusters.  
- Use Azure CLI (`az aks`) and `kubectl` commands for cluster and workload management.  
- Know how to deploy container images, expose services, and scale pods and nodes.  
- Use Bridge to Kubernetes extension for efficient local debugging of microservices within AKS.  
- Verify cluster and node status via CLI due to possible Azure Portal delays.  
- Clean up resources after use to avoid unnecessary charges.  
- Understand the difference between pod scaling (replicas) and node scaling (worker nodes).  
- For exam scenarios, focus on AKS architecture, cost model, deployment basics, and scaling commands.

---

## Networking

### DNS

**Timestamp**: 09:13:36 – 09:30:07

**Key Concepts**  
- DNS (Domain Name System) resolves domain names to IP addresses.  
- Azure DNS is a hosting service for DNS domains using Microsoft Azure infrastructure.  
- Two types of Azure DNS zones: Public DNS (internet-facing) and Private DNS (internal-facing).  
- DNS Zone: container for all DNS records of a specific domain.  
- DNS Record: a rule that directs where to send a domain name; composed of name, type, and value.  
- Record Sets: groupings of DNS records; Azure DNS always uses record sets even if only one record exists.  
- Time To Live (TTL): duration other servers cache DNS records before querying again.  
- Azure Alias record type: special record that points directly to Azure resources, preventing dangling domains.  

**Definitions**  
- **Domain Name**: A service that translates and resolves a service name to its IP address.  
- **Azure DNS**: A Microsoft Azure service that hosts DNS domains and provides name resolution.  
- **DNS Zone**: A container holding all DNS records for a specific domain.  
- **DNS Record**: A rule with a name, type, and value that directs domain traffic.  
- **Record Set**: A collection of DNS records grouped together; Azure DNS creates record sets rather than individual records.  
- **TTL (Time To Live)**: The time period DNS records are cached by other servers before refreshing.  
- **Alias Record**: Azure-specific DNS record type that points directly to Azure resources (e.g., VMs, load balancers), automatically updating if the resource changes.  
- **Public DNS**: DNS zone accessible over the internet for managing internet-facing domains.  
- **Private DNS**: DNS zone used internally within Azure for custom domains instead of Azure provider domains.  

**Key Facts**  
- Azure DNS does **not** provide domain registration services; domains must be purchased elsewhere (e.g., GoDaddy, Namecheap) and then managed via Azure DNS.  
- Common DNS record types to know:  
  - **A**: Points domain to IPv4 address.  
  - **AAAA**: Points domain to IPv6 address.  
  - **CNAME**: Canonical name alias from one domain to another.  
  - **MX**: Mail exchange records for email routing.  
  - **NS**: Name server records for DNS delegation and redundancy.  
  - **PTR**: Pointer record for reverse DNS lookup.  
  - **SRV**: Service locator records (e.g., for Active Directory).  
  - **TXT**: Text records used for verification and documentation (e.g., domain ownership verification).  
  - **SOA**: Start of Authority record containing administrative info about the domain.  
- TTL should be set low for records that change frequently or require failover to reduce caching delays.  
- Wildcard records (e.g., `*`) can be used to catch all subdomains; Azure supports wildcard subdomain matching like `*.subdomain`.  
- The `@` symbol in DNS records is shorthand for the root (naked/apex) domain.  
- Azure Alias records work with A, AAAA, and CNAME types and should be used whenever possible to avoid manual updates when Azure resource IPs or hostnames change.  

**Examples**  
- Creating a public DNS zone named `wharf.com` in Azure DNS.  
- Setting an A record pointing `site.wharf.com` to a VM’s public IP address.  
- Using an alias record to point `site2.wharf.com` directly to the Azure VM resource, avoiding dangling IP issues if the VM’s IP changes.  
- Creating a CNAME record to alias `google.warf.com` to `google.com`.  
- Creating child DNS zones for subdomains like `app.wharf.com` or multi-tenant subdomains like `mytenant1.app.wharf.com`.  
- TXT record example: used by Gmail to verify domain ownership by adding a specific TXT value.  

**Key Takeaways 🎯**  
- Remember Azure DNS is for managing DNS records, **not** for purchasing domains.  
- Know the difference between public and private DNS zones in Azure.  
- Understand DNS zones, records, and record sets — Azure always uses record sets.  
- Be familiar with common DNS record types (A, AAAA, CNAME, MX, NS, PTR, SRV, TXT, SOA).  
- Use TTL wisely: low TTL for frequently changing records or failover scenarios; longer TTL reduces DNS query load.  
- Always prefer Azure Alias records when pointing to Azure resources to avoid stale or dangling DNS entries.  
- Know the meaning of special DNS record naming conventions: `@` for apex domain, `*` for wildcard subdomains.  
- Practical knowledge of creating DNS zones, records, and alias records in Azure is useful but exam focus is on concepts and record types.  

---

### Networking

**Timestamp**: 09:30:07 – 10:53:41

**Key Concepts**  
- Azure Virtual Network (VNet) as a logically isolated network segment for Azure resources  
- Azure DNS and record sets for domain management  
- Network Security Groups (NSGs) as virtual firewalls at subnet or NIC level  
- ExpressRoute for private, high-speed connections between on-premises and Azure  
- Virtual WAN for centralized network routing  
- Virtual Network Gateway for site-to-site VPN connections  
- Network Interfaces (NICs) as virtual network adapters attached to VMs  
- Load balancers and other networking components  
- VNet Peering: connecting multiple VNets to act as one network (regional and global)  
- Route Tables and User-Defined Routes to control traffic flow  
- Address Spaces and CIDR notation for IP allocation in VNets  
- Subnets as logical divisions of address spaces, with public/private distinction based on routing  
- Azure Private Link for secure, private connectivity within Azure network  
- Azure Firewall as a managed, stateful firewall service with high availability and scalability  
- Network Watcher for monitoring, diagnostics, and troubleshooting network resources  
- Network Performance Monitor (NPM) for hybrid network performance monitoring  
- NSG flow logs and packet capture for traffic analysis  

**Definitions**  
- **Virtual Network (VNet)**: A logically isolated section of the Azure network where resources are launched.  
- **Network Interface (NIC)**: A virtual network adapter attached to an Azure VM enabling network communication.  
- **Route Table**: A set of routes that define how traffic is directed within a network or subnet.  
- **User-Defined Route (UDR)**: Custom routes created to override Azure’s default system routes.  
- **Address Space**: The range of IP addresses allocated to a VNet, defined using CIDR notation.  
- **Subnet**: A logical subdivision of an address space within a VNet, used to isolate workloads.  
- **Network Security Group (NSG)**: A set of security rules filtering inbound and outbound traffic at subnet or NIC level.  
- **Azure Private Link**: A service that enables private connectivity to Azure services over a private IP in your VNet.  
- **ExpressRoute**: A private, dedicated connection between on-premises infrastructure and Azure datacenters, bypassing the public internet.  
- **Azure Firewall**: A fully stateful, managed firewall service protecting VNets with centralized policy and logging.  
- **Network Watcher**: Azure service providing tools for monitoring, diagnosing, and viewing network metrics and logs.  
- **Network Performance Monitor (NPM)**: A cloud-based solution to monitor network performance and detect issues like traffic blackholing and routing errors.  

**Key Facts**  
- Azure VNets can have multiple address spaces (unlike AWS VPCs which have one).  
- Each subnet requires a route table; Azure provides default system routes including internet access.  
- User-defined routes can override default routes, e.g., setting internet route hop to "None" to create private subnets.  
- There are four hop types for routes: Virtual Network Gateway, Virtual Network Internet, Virtual Appliance (e.g., firewall VM), and None.  
- Five IP addresses are reserved per subnet: network address, Azure default gateway, two for Azure DNS and VNet space, and broadcast address.  
- VNet peering types:  
  - Regional Peering: between VNets in the same Azure region  
  - Global Peering: between VNets in different Azure regions  
- Azure Firewall uses a static public IP for outbound traffic identification and integrates with Azure Monitor.  
- ExpressRoute Direct supports bandwidth from 50 Mbps up to 10 Gbps for hybrid scenarios requiring high throughput and low latency.  
- Network Watcher is disabled by default per region and must be enabled manually.  
- NSG security rules have properties: name, source/destination (IP, CIDR, service tag), port range, protocol (TCP/UDP/ICMP), action (allow/deny), and priority (100-4096).  

**Examples**  
- Creating a private subnet by overriding the default internet route with hop type "None" in a user-defined route table.  
- Attaching multiple NICs to an Azure VM for network communication.  
- Using Private Link endpoints with private IPs to connect securely to Azure services or third-party marketplace services.  
- Setting up Azure Firewall in its own subnet and routing subnet traffic through it using a user-defined route with hop type "Virtual Appliance" pointing to the firewall’s private IP.  
- Testing VNet peering connectivity using PowerShell’s `Test-NetConnection` cmdlet between VMs in peered VNets (regional and global).  
- Using Network Watcher tools like IP Flow Verify, NSG Diagnostic, Packet Capture, and NSG Flow Logs for network troubleshooting and monitoring.  

**Key Takeaways 🎯**  
- Understand the components and purpose of Azure networking: VNets, subnets, NICs, NSGs, route tables, and peering.  
- Know how to create and apply user-defined routes to control traffic flow, including blocking internet access for private subnets.  
- Be familiar with VNet peering types and benefits, and how to test connectivity between peered VNets.  
- Azure Firewall is a managed, scalable, stateful firewall that requires routing subnet traffic through it via route tables.  
- ExpressRoute provides private, high-speed connections bypassing the internet, with ExpressRoute Direct offering up to 10 Gbps bandwidth.  
- Azure Private Link enables private connectivity to Azure services using private IPs within your VNet.  
- Network Watcher is essential for monitoring and troubleshooting Azure network resources but must be enabled per region.  
- NSG rules are fundamental for filtering traffic; know their key properties and how to diagnose issues using Network Watcher tools.  
- Remember reserved IP addresses in subnets reduce the number of usable IPs by 5.  
- Azure allows multiple address spaces per VNet, unlike AWS VPCs.  
- For exams, focus on concepts of routing, peering, firewall setup, and monitoring tools rather than deep configuration steps.  

---

### NSG

**Timestamp**: 10:53:41 – 11:00:44

**Key Concepts**  
- Network Security Groups (NSGs) filter network traffic to and from Azure resources within a Virtual Network (VNet).  
- NSGs consist of multiple security rules that control inbound and outbound traffic.  
- Rules specify source, destination, port range, protocol, action (allow/deny), and priority.  
- NSGs are stateful, meaning return traffic is automatically allowed without explicit rules.  
- NSGs can be applied at the subnet level and/or the Network Interface Card (NIC) level.  
- When NSGs are applied at both subnet and NIC levels, rules are evaluated first at the subnet, then at the NIC. Both must allow traffic for it to pass.  

**Definitions**  
- **Network Security Group (NSG)**: A set of security rules that filter network traffic to and from Azure resources in a VNet.  
- **Security Rule**: A rule within an NSG that defines traffic filtering based on source, destination, port, protocol, action, and priority.  
- **Stateful**: NSGs track active connections (flow records), allowing return traffic automatically without needing explicit inbound/outbound rules for the response.  
- **Flow Record**: A record created for existing connections that helps NSGs maintain statefulness by tracking connection states.  

**Key Facts**  
- Each security rule has:  
  - Unique name  
  - Source and destination (IP address, CIDR block, service tag, application group)  
  - Port range (single port, range, or all ports with *)  
  - Protocol (TCP, UDP, ICMP)  
  - Action (Allow or Deny)  
  - Priority (number between 100 and 4096; lower numbers processed first)  
- Two types of rules: inbound (traffic entering NSG) and outbound (traffic leaving NSG).  
- Default NSG rules:  
  - Inbound: Allow traffic from any virtual network, allow Azure Load Balancer, deny all else.  
  - Outbound: Allow traffic to any virtual network and internet, deny all else.  
- Limits:  
  - Up to 5,000 NSGs per subscription.  
  - Up to 1,000 security rules per NSG.  
- You cannot create two rules with the same priority and direction.  
- NSG rules are processed in priority order, from lowest number to highest.  
- NSGs are stateful: specifying an outbound rule automatically allows the inbound response, and vice versa.  
- Removing a security rule does not immediately interrupt existing connections; flows are interrupted only after no traffic flows for a few minutes.  
- If no NSG is assigned to subnet or NIC, all traffic is allowed (not recommended).  
- When NSG is applied only to NIC, rules behave predictably based on allow/deny.  
- When NSGs are applied to both subnet and NIC, both must allow traffic for it to pass (e.g., port 80 must be open on both).  

**Examples**  
- Scenario: Virtual machine with NIC but no NSG assigned → all traffic allowed.  
- Scenario: NSG assigned to NIC only → traffic filtered according to NSG rules on NIC.  
- Scenario: NSG assigned to subnet and NIC → traffic must be allowed by both NSGs; if subnet blocks port 80 but NIC allows it, traffic is blocked.  

**Key Takeaways 🎯**  
- Understand the components of an NSG rule: name, source/destination, port range, protocol, action, priority.  
- Remember NSGs are stateful; you don’t need to create both inbound and outbound rules for response traffic.  
- Know default inbound and outbound rules created by Azure NSGs.  
- Priority numbers matter: lower numbers are processed first. No duplicate priority numbers allowed in same direction.  
- NSGs can be applied at subnet and NIC levels; both sets of rules are evaluated, and both must allow traffic.  
- Always have NSGs applied to at least subnet or NIC to avoid unrestricted traffic.  
- Be familiar with limits on NSGs per subscription and rules per NSG for exam context.  
- Review diagrams/slides on NSG application scenarios (subnet vs NIC) as they are important for exam understanding.

---

### Virtual WAN

**Timestamp**: 11:00:44 – 11:12:38

**Key Concepts**  
- Azure Virtual WAN is a consolidated networking service combining networking, security, and routing functionalities into a single operational interface.  
- It supports branch connectivity, site-to-site VPN, remote user VPN (point-to-site), intra-cloud connectivity, ExpressRoute, internet routing, and Azure Firewall encryption for private connectivity.  
- Virtual WAN is essentially Azure’s implementation of Software-Defined WAN (SD-WAN).  
- SD-WAN decouples CPU-intensive router tasks (management, operation, control plane) from physical devices and centralizes control virtually.  
- SD-WAN enables more efficient, cost-effective routing over the internet compared to traditional MPLS networks.  
- Points of Presence (POPs) are network edge entry points, typically ISP data centers, used to connect to networks.  
- A "hop" refers to moving from one POP/network to another during data transit.  
- MPLS (Multi-Protocol Label Switching) is a private network routing method using labels instead of IP addresses to forward packets efficiently.  
- MPLS is outsourced to service providers, uses specialized hardware (Label Switch Routers - LSRs), and offers guaranteed performance but is expensive and lacks inherent encryption.  
- SD-WAN can replace MPLS by routing over the internet with HTTPS security, offering cost savings and easier configuration at scale.  
- Azure Virtual WAN hubs are VNets with service endpoints at region edges that connect on-premises networks to Azure cloud resources via virtual devices.  

**Definitions**  
- **Azure Virtual WAN**: A unified networking service that integrates multiple networking, security, and routing features into a single interface, enabling efficient cloud and branch connectivity.  
- **Software-Defined WAN (SD-WAN)**: A WAN architecture that centralizes control of network traffic routing by decoupling management and control functions from physical routers, enabling optimized and secure internet-based connectivity.  
- **Point of Presence (POP)**: An entry point at the edge of a network, such as an ISP data center, where devices connect to the network.  
- **Hop**: The act of moving data packets from one POP or network to another during transmission.  
- **MPLS (Multi-Protocol Label Switching)**: A packet forwarding technique using labels to determine the shortest path through a private network, managed by service providers using specialized hardware (LSRs).  
- **Label Switch Router (LSR)**: A network device in MPLS that reads labels on packets to forward them along predetermined paths.  
- **Virtual Network Gateway**: A software VPN device deployed in Azure VNets that enables secure connectivity between Azure and on-premises or other networks.  

**Key Facts**  
- Azure Virtual WAN supports multiple connectivity types: branch, site-to-site VPN, point-to-site VPN, ExpressRoute, intra-cloud, internet routing, and Azure Firewall encryption.  
- MPLS is considered OSI Layer 2.5 because it inserts a label (shim) between Layer 2 and Layer 3 in packets.  
- MPLS offers traffic engineering and quality assurance but is costly and lacks encryption.  
- SD-WAN uses HTTPS for secure communication over the internet.  
- SD-WAN offers cost-effectiveness and simpler configuration compared to MPLS, especially at scale.  
- Azure has many POPs globally, enabling fast and efficient routing to Microsoft services like Office 365.  
- Virtual WAN hubs are VNets with service endpoints configured at region edges to optimize connectivity.  

**Examples**  
- Connecting an office to another branch or data center over the internet involves multiple POP hops through different ISPs (e.g., Bell, Rogers, Vodafone, AT&T, NTT).  
- MPLS example: Using a private network with Label Switch Routers to forward packets efficiently between office and branch.  
- Office 365 access example: Instead of routing through MPLS and partner data centers, SD-WAN routes traffic directly to the nearest Microsoft POP for faster and cheaper access.  

**Key Takeaways 🎯**  
- Understand that Azure Virtual WAN is a comprehensive SD-WAN solution integrating multiple networking features for cloud and branch connectivity.  
- Know the difference between MPLS and SD-WAN: MPLS is private, expensive, and hardware-dependent; SD-WAN is internet-based, cost-effective, and centrally managed.  
- Remember that POPs and hops are fundamental concepts in network routing and are critical to understanding WAN traffic flow.  
- SD-WAN improves performance and reduces costs by routing traffic over the internet using HTTPS and leveraging Azure’s global POPs.  
- Virtual WAN hubs (VNets with service endpoints) are key components for connecting on-premises networks to Azure efficiently.  
- For exam scenarios, be prepared to explain why SD-WAN is preferred over MPLS in modern cloud architectures.  
- Virtual Network Gateways are essential for VPN connectivity in Azure and involve deploying specialized VMs in a gateway subnet.

---

### VNGs

**Timestamp**: 11:12:38 – unknown

**Key Concepts**  
- Virtual Network Gateway (VNG) is the software VPN device for Azure Virtual Networks (VNets).  
- VNGs enable secure connections between Azure VNets and on-premises networks or individual devices.  
- VNG deployment involves creating a gateway subnet and deploying two or more specialized VMs running routing tables and gateway services.  
- Gateway types determine whether the gateway is a VPN gateway or an ExpressRoute gateway.  
- VPN gateways support multiple connection topologies: site-to-site, multi-site, point-to-site, and VNet-to-VNet.  
- VPN gateways use IPsec tunnels for secure connections over the internet.  
- ExpressRoute is an alternative to VPN gateways but requires more complex setup and uses edge partners instead of the public internet.

**Definitions**  
- **Virtual Network Gateway (VNG)**: The software VPN device deployed in Azure VNets that manages VPN connections by deploying specialized VMs in a gateway subnet.  
- **VPN Gateway**: A type of virtual network gateway that establishes secure IPsec tunnels over the internet to connect Azure VNets to on-premises networks or individual clients.  
- **ExpressRoute Gateway**: A gateway type used for private, dedicated connections between Azure and on-premises networks via edge partners, not over the public internet.  
- **Gateway Subnet**: A specific subnet within a VNet where the virtual network gateway VMs are deployed.

**Key Facts**  
- Deploying a VNG requires creating a gateway subnet in the VNet.  
- The VNG deployment includes two or more specialized VMs.  
- VPN gateways traverse the public internet using IPsec tunnels for encryption and security.  
- ExpressRoute connections do not traverse the internet but require more setup and use edge partners.  
- VPN gateway topologies include:  
  - Site-to-site (Azure to on-premises data center)  
  - Multi-site (Azure to multiple on-premises data centers)  
  - Point-to-site (Azure to individual client devices)  
  - VNet-to-VNet (connecting two Azure VNets across regions or subscriptions)

**Examples**  
- Site-to-site VPN: Connecting an Azure VNet to an on-premises data center via an IPsec tunnel.  
- Multi-site VPN: Connecting Azure to multiple on-premises sites with multiple tunnels.  
- Point-to-site VPN: Employees connecting securely from laptops worldwide to an Azure VNet.  
- VNet-to-VNet VPN: Connecting two VNets in different Azure regions or subscriptions.

**Key Takeaways 🎯**  
- Remember that a Virtual Network Gateway is essential for enabling VPN connections in Azure VNets.  
- Always create a gateway subnet before deploying a VNG.  
- Understand the difference between VPN gateways (internet-based, IPsec tunnels) and ExpressRoute gateways (private, dedicated connections).  
- Know the four main VPN gateway topologies and their use cases: site-to-site, multi-site, point-to-site, and VNet-to-VNet.  
- VPN gateways provide a cost-effective and simpler alternative to ExpressRoute for connecting Azure to on-premises or remote clients.  
- ExpressRoute may still require VPN gateways for certain configurations.  
- For exam scenarios, be prepared to identify appropriate gateway types and topologies based on connectivity requirements.
