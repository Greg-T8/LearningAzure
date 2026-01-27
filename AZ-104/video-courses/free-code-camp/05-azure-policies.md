# Azure Policies

## Policies Intro

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

---

## Non Compliant Resources

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

## Policy Definition File

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

## Configure Policy

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

## Policies CheatSheet

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
