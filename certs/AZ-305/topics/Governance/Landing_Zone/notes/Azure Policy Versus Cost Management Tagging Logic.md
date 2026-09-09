# Azure Policy Versus Cost Management Tagging Logic

The key to why your answer was incorrect lies in the phrase **"to update the resource properties."** While Cost Management tag inheritance and Azure Policy both relate to tagging, they operate at completely different layers of the Azure platform [1, 2].

### 1. Why "Tag Inheritance in Cost Management" Was Incorrect
* **Billing Pipeline Only:** When you enable tag inheritance in Microsoft Cost Management, Azure copies tags down exclusively to the **usage and billing records** within the Cost Management data pipeline [2, 3].
* **No Resource Property Changes:** Tag inheritance **never writes tags onto the physical resources** in Azure Resource Manager (ARM) [1, 2]. The actual resources remain untagged, and their resource properties in ARM are left completely unchanged [2]. Because your selected option claimed that tag inheritance would *"update the resource properties,"* it was technically inaccurate [2].

### 2. Why "Azure Policy with a 'modify' effect" is the Correct Design
When a requirement specifies that tags must physically appear on the resources themselves (updating their ARM resource properties) [4]:
* **Control-Plane Modification:** Azure Policy with the **`modify`** effect actively alters the resource properties during deployment or update, writing the tags directly onto the resource in ARM [4, 5]. Built-in policy definitions like *"Inherit a tag from the resource group"* natively use `modify` [5].
* **Remediating Existing Resources:** For resources that were already deployed before the policy was assigned, Azure Policy flags them as non-compliant but does not alter them automatically [6]. To backfill and apply missing tags onto those existing resources, you must execute a **remediation task** [5, 6].

---

### 🎯 AZ-305 Summary
* **Cost Management Tag Inheritance:** Modifies **usage/billing records only**; does NOT alter physical resources or ARM properties [1-3].
* **Azure Policy (`modify` + Remediation):** Modifies **actual resource properties** in ARM so the tags physically exist on the resources [1, 4, 5].

***

🏷️ Would you like to review how managed identities are configured on policy assignments to grant remediation tasks the RBAC permissions needed to write tags onto resources?