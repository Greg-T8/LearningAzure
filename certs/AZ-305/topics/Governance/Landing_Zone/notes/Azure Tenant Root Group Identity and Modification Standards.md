# Azure Tenant Root Group Identity and Modification Standards

Your answer was incorrect because it mixed up the **Management Group ID** with the **Display Name**. While they are related, Azure Resource Manager (ARM) treats them as two completely separate properties with different mutability rules [1, 2].

---

### 1. ID vs. Display Name: What Is Fixed vs. What Is Editable

* **Management Group ID (Fixed):** The ID is the directory-unique identifier used internally by ARM to reference the group in resource paths and CLI/API commands [2, 3]. For the Tenant root group, this ID is automatically generated during setup and is **fixed to the Microsoft Entra Tenant ID (GUID)** [1, 2]. Like all management group IDs, it can **never** be changed after creation [2].
* **Display Name (Editable):** The display name is the friendly text shown in the Azure portal, CLI, or PowerShell [2, 3]. By default, the Tenant root group's display name is **"Tenant root group"**, but it **can be changed at any time** to better represent your organization (e.g., "Contoso Root") [1, 2].

---

### 2. Required Permissions to Change the Display Name

To rename the display name of the Tenant root group, your account must possess write permissions on that specific management group scope (`Microsoft.Management/managementGroups/write`) [4, 5].

* **Owner or Contributor Role:** Having the **Owner** or **Contributor** role (or **Management Group Contributor**) assigned directly or inherited at the Root Management Group scope grants the necessary rename action [1, 4].
* **Global Admin Distinction:** Note that being a **Microsoft Entra Global Administrator** does not automatically grant you RBAC rights on the Root Management Group. A Global Admin must first elevate access to receive the *User Access Administrator* role at the root scope, and then assign themselves or another user the **Owner** or **Contributor** role on the root management group to modify its properties [6-8].

---

### 🎯 AZ-305 Exam Takeaways:
* **Management Group ID:** Permanent, immutable GUID (equals Tenant ID for the root group) [1, 2].
* **Display Name:** Friendly, editable text string [2].
* **Permissions:** Requires **Owner**, **Contributor**, or **Management Group Contributor** at the target root scope [1, 4].

---

🛡️ Would you like to review how **Hierarchy Settings** on the Tenant Root Group allow you to enforce write permission requirements for creating new child management groups or set a default management group for new subscriptions?