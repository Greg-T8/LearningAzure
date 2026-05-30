You are helping me prepare for the AZ-305: Designing Microsoft Azure Infrastructure Solutions exam.

Source study guide:
<https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305>

Goal:
Analyze the official AZ-305 study guide and produce a documentation map organized by the study guide hierarchy:

<domain> → <skill> → <task>

For each exam task, identify 5–15 relevant links to official Microsoft product documentation that would be useful for grounding study tools.

Important requirements:

1. Use only official Microsoft sources.
   - Prefer Microsoft Learn product documentation under `https://learn.microsoft.com/en-us/azure/`
   - Include Microsoft Azure, Entra, Azure Architecture Center, Cloud Adoption Framework, Well-Architected Framework, and Microsoft Defender documentation only when directly relevant.
   - Do not include third-party sites, blogs, exam dumps, unofficial notes, or forum answers.

2. Prioritize root product documentation pages.
   - Prefer documentation landing pages that have a “Download PDF” button.
   - Example:
     - Azure Monitor Documentation → <https://learn.microsoft.com/en-us/azure/azure-monitor/>
     - Azure Cosmos DB Documentation → <https://learn.microsoft.com/en-us/azure/cosmos-db/overview>
   - Avoid overly narrow article links unless the task clearly requires a specific feature page.

3. For each documentation link, provide:
   - The official supporting product documentation name as a hyperlink.
   - The friendly URL.
   - A short reason why the documentation supports the exam task.

4. Official supporting production documentation name rule:
   - Use the official Microsoft documentation name.
   - Remove generic words like “Documentation” from the filename.
   - Keep the product or service name intact.
   - Examples:
     - “Azure Monitor Documentation” → `Azure Monitor`
     - “Azure Cosmos DB Documentation” → `Azure Cosmos DB`
     - “Azure Virtual Network Documentation” → `Azure Virtual Network`

5. Organize the output by the AZ-305 hierarchy.
   - Domain
   - Skill
   - Task
   - Supporting Microsoft documentation links

6. For each task, include only documentation that is directly relevant to that task.
   - It is acceptable for a documentation source to appear under multiple tasks if it supports each task.
   - Avoid broad “catch-all” links unless they are genuinely useful for grounding that task.

7. Validate each link.
   - Confirm that each URL resolves to an official Microsoft Learn page.
   - Prefer URLs that are stable, friendly, and close to the root of the product documentation set.
   - Do not use redirected, localized, or tracking URLs.

8. Output format:
   Use this structure:

## Domain: <domain name>

### Skill: <skill name>

#### Task: <task name>

| Supporting product documentation | Friendly URL |  Why this supports the task |
|---|---|---|
| [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/) | <https://learn.microsoft.com/en-us/azure/azure-monitor/> | Azure Monitor.pdf | Supports monitoring, metrics, logs, alerts, and observability design decisions. |

9. At the end of each domain, include a short “Coverage notes” section:
   - Mention any tasks where Microsoft documentation is fragmented across several products.
   - Mention any tasks where the best source is architecture guidance rather than a single product documentation root.
   - Mention any documentation sets that appear repeatedly and are worth downloading first.

10. Do not include internal citation marker strings in the final output.
    - Do not output citation tokens such as ``.
    - Use normal Markdown hyperlinks only.

Deliverable:
A complete AZ-305 documentation map that I can use to download PDFs from Microsoft Learn and rename them consistently for study-tool grounding.
