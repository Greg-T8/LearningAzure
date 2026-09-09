# Azure Governance: Choosing Modify over Append for Tagging Enforcement

Selecting **Append** is a very common and understandable choice because both `append` and `modify` can add fields (like tags) to resources during deployment [1, 2]. However, in modern Azure governance, **Modify** is the most appropriate and recommended effect for this scenario due to several critical architectural differences [1]:

### 1. Built-in Tag Inheritance Policies Natively Use "Modify"
Azure provides built-in policy definitions specifically designed for tag inheritance, such as **"Inherit a tag from the resource group"** and **"Inherit a tag from the resource group if missing"** [3, 4]. Both of these built-in policies natively utilize the **`modify`** effect under the hood, rather than `append` [2, 5]. 

### 2. Remediation Support for Existing Resources
The single most decisive difference between the two effects is how they handle pre-existing resources that do not have the correct tags:
* **Modify supports remediation:** If you deploy a policy with the `modify` effect, you can trigger a **remediation task** [6, 7]. This task acts as a bulk-fix, automatically scanning your resource groups and writing the `'Environment: Development'` tag onto all pre-existing resources [2, 7]. 
* **Append does NOT support remediation:** The `append` effect only evaluates and alters properties during the creation or update of a resource [1]. If you have resources already running in your resource group that are missing the tag, `append` cannot fix them retroactively [1]. They will remain non-compliant indefinitely until they are manually updated or redeployed [1].

### 3. Ability to Overwrite vs. Simply Adding
Another major difference is how they handle tags that are already defined but contain incorrect values:
* **Append cannot overwrite:** If a developer deploys a resource and has already specified an incorrect or mismatched tag (e.g., `'Environment: Production'`), `append` will not change it [1]. It is strictly non-destructive and only adds properties that are completely missing [1].
* **Modify offers granular operation modes:** The `modify` effect supports different operation types, including **`addOrReplace`** [8]. If you need to ensure that resources *strictly* inherit `'Environment: Development'` from their resource group and want to prevent developers from accidentally deploying resources labeled with a production tag, a `modify` policy with `addOrReplace` will actively overwrite the incorrect value to enforce compliance [8].

### Summary for the AZ-305 Exam:
* Use **`append`** only when you want to add fields during creation/update and do not need to overwrite existing values or remediate pre-existing resources [1].
* Use **`modify`** (which requires a managed identity for the policy assignment [9, 10]) as the modern standard for **tagging governance** [2] because it allows you to remediate drift on existing resources and gives you the flexibility to either add missing tags or replace incorrect ones [7, 8].

***

🏷️ Since tagging is a major component of landing zone design, would you like to review how to enforce tags on resources using Azure Policy while ensuring legacy services that do not support tags are excluded from compliance reports?