# Mastering Strict Mode in Azure App Configuration

Great job getting this right! This question highlights an important concept for the AZ-305 exam known as **Configuration as Code**. When you manage your configuration files in a source control system (like a Git repository), you want that repository to act as the absolute single source of truth for your application's settings [1]. 

Here is a detailed breakdown of how the **Strict** setting (also labeled as **"Delete key-values that are not included in the configuration file"** in Azure Pipelines) works and why it is critical for CI/CD pipelines:

**1. The Problem with Standard Imports (Unchecked)**
When you perform a standard import from a JSON configuration file without the strict setting enabled, App Configuration simply adds new keys or updates existing ones with the values from your file. However, it **leaves everything else in the App Configuration store intact** [2, 3]. 
If a developer deletes an obsolete feature flag or configuration setting from the JSON file in your repository, a standard CI/CD import will *not* delete that setting from the live App Configuration store, leaving behind orphaned and potentially confusing data.

**2. How the "Strict" Setting Fixes This**
Enabling the "Strict" option ensures that your App Configuration store exactly mirrors what is in your source file by proactively deleting leftover keys. The exact deletion behavior depends on the **File content profile** you select for the import [2-4]:

*   **Default Profile:** This profile is used for conventional configuration files (like a standard `appsettings.json`). When Strict mode is enabled, the import process will remove any key-values in the live store that match your specified **prefix and label**, but are missing from the imported configuration file [2, 3].
*   **KVSet Profile:** This profile uses a specialized schema that contains all App Configuration properties (key, value, label, content type, and tags) in one file. When Strict mode is enabled with KVSet, the import process is absolute: it removes **all** key-values in the App Configuration store that aren't explicitly included in the imported configuration file [2, 3, 5].

**Architectural Takeaways for the AZ-305 Exam:**
*   **Configuration as Code:** Use the Strict setting in your Azure DevOps or GitHub Actions CI/CD pipelines to ensure your deployed App Configuration perfectly matches your version-controlled JSON, YAML, or Properties files [1, 6].
*   **Safety Precaution:** Because Strict mode performs destructive actions (deletions), Azure Pipelines provides a **Dry Run** parameter. You can check this box to review the updates and deletions that *would* be performed in the console logs without actually applying the changes to the live store [4].
*   **Error 409 Conflict:** If your CI/CD pipeline attempts to use the Strict setting to remove or overwrite a key-value that has been explicitly **locked** in the App Configuration store, the task will fail and return a 409 Conflict error [7].