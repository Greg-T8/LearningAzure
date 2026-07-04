**SC-300 Study Review Sheet: Create Managed Identities (Expanded)**

### **1. Architecture & Security Foundations**

* **Core Security Benefit:** Completely eliminates the need for developers to manage, store, or rotate credentials.
  * Azure handles credentials in the background.
  * No human user, including Global Administrators, can view or copy the underlying secrets.
  * Prevents hardcoding passwords in source code and leaking them to public repositories like GitHub.
* **Under the Hood:** Managed identities are a **special type of service principal** designed exclusively for Azure resources.
  * Because Azure fully manages them, they cannot be edited like standard applications.
* **Licensing & Cost Prerequisites:**
  * **Cost:** No additional cost.
  * **Licensing:** No premium licensing required.
* **Platform Prerequisite Limitations:**
  * Managed identities can *only* be assigned to services hosted within Microsoft Azure.
* **Exam Trap:** If a scenario features a workload hosted on-premises, in AWS, or in Google Cloud, you *cannot* use a managed identity. You must use the **OAuth 2.0 client credentials flow**.

#### **Comparison Table: Workload Authentication based on Host Location**

| Feature | Inside Microsoft Azure | Outside Microsoft Azure (On-Prem, AWS, GCP) |
| :--- | :--- | :--- |
| **Authentication Method** | Managed Identities | OAuth 2.0 Client Credentials Flow |
| **Credential Management** | Handled automatically by Azure | Managed manually by developers/admins |
| **Preferred Credential Type** | N/A (Secret-less) | Certificates or Federated Credentials |
| **Permission Type Used** | Azure RBAC or Application Permissions | Strictly Application Permissions (`.default` scope) |

---

### **2. Managed Identity Types & Lifecycles**

* **System-Assigned Managed Identity:**
  * **Lifecycle:** Tied directly to a specific Azure resource (e.g., a Virtual Machine).
  * **Relationship:** 1:1 relationship with the resource.
  * **Deletion Behavior:** Automatically deleted by Azure when the parent resource is deleted.
  * **Security Benefit:** Eliminates "orphaned accounts" that attackers can exploit.
* **User-Assigned Managed Identity:**
  * **Lifecycle:** Standalone Azure resource managed independently.
  * **Relationship:** 1:Many relationship (can be assigned to zero, one, or multiple Azure resources).
  * **Deletion Behavior:** Must be manually deleted by an administrator.
* **Exam Trap:** Deleting all Virtual Machines that utilize a user-assigned managed identity *does not* delete the identity itself.

#### **Comparison Table: System-Assigned vs. User-Assigned**

| Attribute | System-Assigned | User-Assigned |
| :--- | :--- | :--- |
| **Creation** | Enabled directly on an existing Azure resource | Created as a standalone Azure resource |
| **Lifecycle** | Shared with the parent resource | Independent lifecycle |
| **Sharing** | Cannot be shared (1:1) | Can be shared across multiple resources (1:Many) |
| **RBAC Role to Create** | Requires permissions over the specific compute resource | Requires **Managed Identity Contributor** |

---

### **3. Role-Based Access Control (RBAC) Requirements**

* **Creating User-Assigned Managed Identities:**
  * Requires interaction with the Azure Resource Manager (because it is a standalone resource).
  * **Least Privileged Role:** Azure RBAC **Managed Identity Contributor** role.
  * **Entra ID Role Requirement:** **None**.
* **Exam Trap:** Do not confuse Azure RBAC roles with Microsoft Entra directory roles. Possessing a highly privileged Entra role (like Global Administrator) does not automatically grant the Azure RBAC permissions required to create this resource.

---

### **4. Configuration Details: Authentication Routing**

* **The Default Behavior:** If a Virtual Machine has *both* a system-assigned identity and one or more user-assigned identities, Azure defaults to using the **system-assigned managed identity** for token requests.
* **Overriding the Default:**
  * To use a user-assigned identity instead, the application code must explicitly request the token using the target identity's **Client ID**.
* **Microsoft Best Practice:** Assign **only one type** of managed identity to a resource to avoid authentication routing ambiguity and application errors.

---

### **5. Configuration Details: Authorizing Graph API Permissions**

* **The Portal UI Limitation:**
  * You can assign Azure RBAC roles (e.g., Storage Account access) to a managed identity via the Azure portal.
  * You **cannot** assign Microsoft Graph API permissions (e.g., `User.Read.All`) via the Microsoft Entra admin center UI.
* **The Required Tool:**
  * You strictly **must use PowerShell** (e.g., Microsoft Graph PowerShell SDK) to authorize Graph API permissions.
* **Configuration Steps (PowerShell):**
    1. Retrieve the object ID of the managed identity.
    2. Locate the "Microsoft Graph" enterprise application (service principal) and identify the specific App Role ID to be granted.
    3. Execute the command `New-MgServicePrincipalAppRoleAssignment` to bind the permission.
* **Troubleshooting Detail:** After running the PowerShell script, administrators can verify the assignment by navigating to the **Enterprise Applications** blade in the portal, selecting the managed identity, and checking the **Permissions** tab.

---

### **6. Resiliency Mechanisms**

* **Proactive Token Renewal:**
  * Managed identities use **long-lived access tokens**.
  * The service requests new tokens in the background *before* the current tokens expire.
  * **Benefit:** The application continues running seamlessly without interruption during temporary network hiccups.
* **Regional Endpoints:**
  * Consolidates service dependencies geographically.
  * Forces authentication traffic to stay strictly within the resource's physical region (e.g., WestUS2 traffic stays in WestUS2).
  * **Benefit:** Provides **fault isolation** by preventing out-of-region failures.
* **Backup Authentication System:**
  * A redundantly layered, regionally isolated authentication service.
  * **Benefit:** Keeps infrastructure online by transparently handling authentications if the primary Microsoft Entra service becomes degraded.
* **Exam Trap:** Regional endpoints are *not* designed to "allow identities to be shared across global regions." They do the exact opposite: they lock traffic to a specific local geography for fault isolation.

---

### **7. Portal Navigation & Troubleshooting**

* **Application Objects vs. Service Principals:**
  * **Application Object:** The global blueprint/template (1:1 with the software), residing only in the home tenant. Managed under **App Registrations**.
  * **Service Principal:** The concrete, local instance of the application in a specific tenant (1:Many with the application object). Managed under **Enterprise Applications**.
* **Finding Managed Identities:**
  * Because managed identities are automatically generated by Azure, developers do not manually build blueprints for them.
  * They are a special type of **Service Principal**.
  * **Configuration Detail:** To find them, navigate to **Enterprise Applications**, locate the **Application type** filter, and change the value to **Managed Identities**.
* **Exam Trap:** Never look for managed identities in the "App Registrations" blade.

---

### **8. Advanced Scenario: Cross-Tenant Customer-Managed Keys (CMK)**

* **The Scenario:** An Independent Software Vendor (ISV) hosts a multi-tenant SaaS application in Tenant 1, but needs to encrypt data using a customer's Azure Key Vault located in Tenant 2.
* **The Configuration:**
    1. ISV creates a multi-tenant application and a **user-assigned managed identity** in Tenant 1.
    2. ISV configures the user-assigned managed identity as a **federated identity credential** on the multi-tenant application.
    3. Customer installs the multi-tenant application in Tenant 2 (which creates a local service principal).
    4. Customer assigns the **Key Vault Crypto Service Encryption User** role to the local service principal.
* **How it Works:** The federated identity credential allows the user-assigned managed identity to **impersonate** the multi-tenant application across tenant boundaries to request an access token.
* **Prerequisite/Limitation Note:** An application can only have a maximum of **20 federated identity credentials** configured on it.
* **Exam Trap:** You *must* use a user-assigned managed identity for this impersonation scenario. A system-assigned managed identity cannot be configured as a federated credential on an app registration.
