# Strategic Tag Governance: Choosing Modify over Append in Azure

While **`append`** can add missing fields during resource creation, **`modify` with a remediation task** is the correct answer because of key architectural differences in how Azure Policy handles tag inheritance and pre-existing resources [1, 2].

Here is a detailed breakdown of why **`append`** was incorrect and why **`modify`** is the required choice for this scenario:

---

### 1. Lack of Remediation for Existing Resources
The most significant limitation of the `append` effect is how it treats resources deployed before the policy was assigned [2]:
* **`append` only acts on active requests:** The `append` effect evaluates resources strictly during a creation or explicit update operation. It cannot alter or fix pre-existing resources that are already running without the `CostCenter` tag [2]. Those existing resources will remain non-compliant indefinitely unless someone manually updates or redeploys them [2].
* **`modify` supports remediation tasks:** Policies using the `modify` effect support **remediation tasks** [3, 4]. Administrators can trigger a remediation task (which uses a managed identity assigned to the policy) to retroactively scan all pre-existing resources in the subscription and write the missing `CostCenter` tag onto them [3, 5].

---

### 2. Built-in Tag Inheritance Policy Architecture
Microsoft's built-in policy definitions for inheriting tags from parent containers specifically use the **`modify`** effect [4, 6]:
* Built-in definitions such as **"Inherit a tag from the subscription if missing"** and **"Inherit a tag from the resource group if missing"** are implemented using `modify` [4, 6]. 
* Legacy policies previously used `append`, but Microsoft updated tag governance recommendations to use `modify` because it includes native support for remediating existing resources [2].

---

### 3. Granular Operations (`add` vs. `addOrReplace`)
The `modify` effect provides distinct operation modes within its policy rule details [7, 8]:
* **`add`:** Adds the tag only when it is missing from the resource, preserving any custom tag value if the resource already has one defined [7].
* **`addOrReplace`:** Overwrites an existing tag value with the parent container's value if strict enforcement is required [8].

By utilizing `modify` with an `add` operation, Azure Policy inspects the resource for the `CostCenter` tag, and if it is missing, fetches the value from the parent subscription (e.g., using `[subscription().tags['CostCenter']]`) and writes it during deployment or via a remediation task [3, 7].

---

### 🎯 AZ-305 Exam Summary:
* **Use `append`** only for simple, non-destructive control-plane additions during resource creation/update when backfilling pre-existing resources is not required [2].
* **Use `modify`** (paired with a managed identity and remediation tasks) as the standard for **tag governance and tag inheritance** across existing and new resources [1, 3, 4].

---

🏷️ Would you like to review how to set up the managed identity and RBAC permissions required on a policy assignment so that remediation tasks can write tags across subscription boundaries?