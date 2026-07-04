**SC-300 Study Review Sheet: Manage Custom Security Attributes**

### **1. Core Architecture & Prerequisites**

* **Architectural Prerequisite:** Creating custom security attributes is a strict two-step process. Every custom security attribute must be housed inside an **Attribute Set** (a logical container used for grouping and delegation).
* **PowerShell Configuration Sequence:**
    1. Create the container: `New-MgDirectoryAttributeSet`.
    2. Create the attribute inside it: `New-MgDirectoryCustomSecurityAttributeDefinition`.
* **Licensing Note:** *Note that specific Entra ID P1/P2 licensing requirements are not detailed in the provided sources and should be verified independently for the exam.*
* **Scenario Example:** To track department data, you must first create an "Engineering" attribute set before you can create the "Project" or "CostCenter" attributes within it.

### **2. Structural Limits & Naming Conventions**

| Feature | Maximum Limit | Key Details |
| :--- | :--- | :--- |
| **Active Attribute Definitions** | 500 per tenant | **Exam Trap:** Deactivated attributes do *not* count toward this limit. There is no limit to deactivated attributes. |
| **Attribute Sets** | 500 per tenant | Broad tenant-wide ceiling. |
| **Predefined Values** | 100 per attribute | Configured as a strict dropdown list. |
| **Assignments per Object** | 50 per object | A single user or enterprise application can hold a max of 50 assigned values, distributed across single or multi-valued attributes. |

* **Naming Constraints:** Both Attribute Names and Attribute Set Names are strictly limited to **32 characters**, are case sensitive, **cannot include spaces or special characters** (e.g., `@`, `#`, `_`, `-`), and cannot start with a number.

### **3. Data Types & Value Restrictions**

| Data Type | Supports Multiple Values (`IsCollection`)? | Supports "Only allow predefined values"? |
| :--- | :--- | :--- |
| **String** | Yes | Yes |
| **Integer** | Yes | Yes |
| **Boolean** | **No** (Strictly single-value) | **No** (Completely incompatible) |

* **Graph API Configuration Detail:** Microsoft Entra ID does not have an "Array" data type. To allow multiple values for Strings or Integers, you must set the boolean property **`IsCollection = $true`**.
* **Value Character Limitations:**
  * *Standard Use:* Assigned values natively allow **all special characters**.
  * *Scenario Example (Azure ABAC):* If you are using values to match with **Azure Storage blob index tags**, the values are strictly restricted to alphanumeric characters, a space, and `+ - . : = _ /`.

### **4. Immutability & Lifecycle Management**

| Property Type | Specific Properties |
| :--- | :--- |
| **Immutable (Locked upon creation)** | Attribute name, Attribute set name, Data type, "Allow multiple values to be assigned" setting. |
| **Mutable (Can be updated)** | Attribute description, Attribute status (Active/Deactivated), "Maximum number of attributes" (on the set). |

* **Configuration Detail ("Predefined values" toggle):** This is a one-way toggle. You **can** change it from "Yes" to "No" (opening it to free-form text). You **cannot** change it from "No" to "Yes" to prevent data reconciliation errors.
* **Exam Trap (Deactivation):** You **cannot delete** attribute definitions. When deactivated, existing values **persist** on user/app objects and remain completely visible to authorized administrators. The system will *never* delete assigned values automatically; deactivation simply blocks future assignments.

### **5. Role-Based Access Control (RBAC) & PIM Restrictions**

Custom security attributes use a strictly isolated RBAC model to protect sensitive data.

| Role | Permissions |
| :--- | :--- |
| **Attribute Definition Administrator** | Can create, edit, and deactivate attribute sets and attribute definitions. Cannot assign values. |
| **Attribute Assignment Administrator** | Can assign, read, and update attribute values on users/applications. **Cannot** manage the schema. |
| **Attribute Assignment Reader** | Can only read assigned values on objects. |

* **Exam Trap (Global Admin Exception):** By default, Global Administrators and standard admin roles **do not have permissions** to read, define, or assign custom security attributes. They must explicitly assign the roles above to themselves.
* **Exam Trap (PIM Limitation):** If delegating administration at the granular **attribute set scope** (e.g., granting access only to the "Marketing" set), Privileged Identity Management (PIM) **eligible role assignments are NOT supported**. The assignment must be permanent.

### **6. Advanced Querying & Troubleshooting**

* **Graph API Configuration Details:** To filter users based on custom security attributes, you must explicitly opt-in to advanced routing.
  * You **must** include the header/parameter: `ConsistencyLevel=eventual`.
  * You **must** include the companion parameter: `$count=true` (or `-CountVariable` in PowerShell).
* **Troubleshooting Detail:** If you forget these parameters, the Graph API will fail and return a **`400 Bad Request`** with a **`Request_UnsupportedQuery`** error message.
* **Exam Trap (Admin Center Filters):** When filtering in the portal UI, the operators are strictly limited to **equals (==)**, **not equals (!=)**, and **starts with**. The **contains** operator is explicitly NOT supported.

### **7. Audit Log Governance**

* **Configuration Detail:** Custom security attribute audit logs are isolated into a completely separate endpoint from standard directory audit logs to prevent inadvertent disclosure of sensitive data (like salaries) to standard IT staff.
* **RBAC Requirement:** Standard Security Administrators cannot read these logs. You must assign the **Attribute Log Administrator** or **Attribute Log Reader** role.
* **Troubleshooting Detail (Diagnostic Settings):** You cannot stream these logs using existing directory diagnostic settings. An Attribute Log Administrator must configure brand *new* diagnostic settings specifically dedicated to the `CustomSecurityAttributeAuditLogs` endpoint.

### **8. Unsupported Scenarios & Supported Alternatives**

| Unsupported Scenario | Supported Alternative for Exam Scenarios |
| :--- | :--- |
| **Dynamic Membership Groups** | Use **Extension attributes 1-15** (e.g., `extensionAttribute15`) or **Directory (Microsoft Entra ID) extensions** (e.g., `user.extension_[GUID]_[Attribute]`). |
| **SAML Token Claims** | Use Extension attributes 1-15 or Directory extensions. |
| **Microsoft Entra Domain Services** | *Not supported.* |
