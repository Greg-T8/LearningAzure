You are helping me prepare for the AZ-305: Designing Microsoft Azure Infrastructure Solutions exam.

Source study guide:
<https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305>

Goal:
Analyze the official AZ-305 study guide and produce a documentation map organized by the study guide hierarchy:

<domain> → <skill> → <task>

For each exam task, identify 5–15 relevant links to official Microsoft documentation that would be useful for grounding study tools.

Important requirements:

1. Use only official Microsoft sources.
   - Prefer Microsoft Learn product documentation under `https://learn.microsoft.com/en-us/azure/`
   - Include Microsoft Entra, Azure Architecture Center, Cloud Adoption Framework, Well-Architected Framework, Microsoft Purview, and Microsoft Defender documentation only when directly relevant.
   - Do not include third-party sites, blogs, exam dumps, unofficial notes, or forum answers.

2. Prioritize documentation sets, not individual article titles.
   - The **Supporting product documentation** value must represent the parent Microsoft Learn documentation set that would be downloaded as a PDF.
   - Do not use the leaf article title, feature title, or final URL segment as the documentation name unless that is also the top-level documentation set name.
   - Determine the documentation name from the left navigation top node, root documentation page, or Microsoft Learn documentation collection title.
   - Remove the generic word “Documentation” from the displayed name.

3. Naming examples:
   - `https://learn.microsoft.com/en-us/azure/azure-monitor/`  
     Supporting product documentation = `Azure Monitor`
   - `https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs`  
     Supporting product documentation = `Azure Monitor`, not `Azure Monitor Logs`
   - `https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview`  
     Supporting product documentation = `Azure Monitor`, not `Azure Monitor Alerts`
   - `https://learn.microsoft.com/en-us/entra/identity/monitoring-health/`  
     Supporting product documentation = `Monitoring and health`, because that is the top node of that Microsoft Entra documentation set
   - `https://learn.microsoft.com/en-us/azure/cosmos-db/overview`  
     Supporting product documentation = `Azure Cosmos DB`

4. Output columns:
   Use exactly these columns:
   - Supporting product documentation
   - URL
   - Why this supports the task

   Do not include a dedicated PDF filename column.

5. URL column rule:
   - Rename the column to `URL`, not `Friendly URL`.
   - The URL column must contain the main Microsoft Learn URL being recommended.
   - Use the canonical `https://learn.microsoft.com/en-us/...` URL.
   - Do not use tracking URLs, localized URLs, redirected URLs, or shortened URLs.

6. Hyperlink rule:
   - In the **Supporting product documentation** column, hyperlink the documentation name to the same URL shown in the URL column.
   - In the **URL** column, show the URL in plain text using angle brackets.
   - Example:

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs) | <https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs> | Supports log data platform design, Log Analytics workspaces, and KQL-based querying. |
| [Monitoring and health](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/) | <https://learn.microsoft.com/en-us/entra/identity/monitoring-health/> | Supports identity audit logs, sign-in logs, workbooks, recommendations, and identity health monitoring. |

7. PDF naming rule:
   - Do not create a separate PDF filename column.
   - The implied PDF filename is the value in the **Supporting product documentation** column plus `.pdf`.
   - Example:
     - `Azure Monitor` → `Azure Monitor.pdf`
     - `Monitoring and health` → `Monitoring and health.pdf`
     - `Azure Cosmos DB` → `Azure Cosmos DB.pdf`

8. Avoid duplicate documentation sets within the same task where possible.
   - If several deep articles under the same documentation set support the same task, prefer the most relevant URL and keep the parent documentation set name.
   - If multiple URLs from the same documentation set are necessary because they support meaningfully different concepts, repeat the same Supporting product documentation name but use different URLs.
   - Example:
     - `Azure Monitor` can appear more than once if one URL supports logs and another supports diagnostic settings.
     - Do not rename those rows to `Azure Monitor Logs`, `Azure Monitor Alerts`, or `Azure Monitor Diagnostic Settings` unless those are actually separate top-level documentation sets.

9. Organize the output by the AZ-305 hierarchy.
   - Domain
   - Skill
   - Task
   - Supporting Microsoft documentation links

10. For each task, include only documentation that is directly relevant to that task.
    - It is acceptable for a documentation source to appear under multiple tasks if it supports each task.
    - Avoid broad catch-all links unless they are genuinely useful for grounding that task.

11. Validate each link.
    - Confirm that each URL resolves to an official Microsoft Learn page.
    - Prefer stable, canonical Microsoft Learn URLs.
    - Prefer documentation roots or high-value overview pages when they are sufficient.
    - Use deeper article URLs only when they better support the specific exam task.

12. Output format:

## Domain: <domain name>

### Skill: <skill name>

#### Task: <task name>

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/) | <https://learn.microsoft.com/en-us/azure/azure-monitor/> | Supports monitoring, metrics, logs, alerts, and observability design decisions. |

13. At the end of each domain, include a short “Coverage notes” section:
    - Mention any tasks where Microsoft documentation is fragmented across several products.
    - Mention any tasks where the best source is architecture guidance rather than a single product documentation root.
    - Mention any documentation sets that appear repeatedly and are worth downloading first.

14. Do not include internal citation marker strings in the final output.
    - Do not output citation tokens such as ``.
    - Use normal Markdown hyperlinks only.

Deliverable:
A complete AZ-305 documentation map that I can use to download PDFs from Microsoft Learn. The Supporting product documentation name should correspond to the Microsoft Learn documentation set/PDF name, while the URL should identify the specific Microsoft Learn page that best supports the exam task.
