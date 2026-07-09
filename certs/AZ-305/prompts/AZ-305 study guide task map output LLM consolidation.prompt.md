# Markdown Consolidation Prompt — AZ-305 Documentation Map Results

## Role

You are consolidating multiple Markdown outputs created by different LLMs for the same AZ-305 documentation map task.

The inputs are separate Markdown files that should represent the same exam task, but they may differ in:

- Number of table rows
- Duplicate or near-duplicate documentation links
- URL formatting
- Documentation set naming
- Rationale wording
- Product lists
- Forum-discovery notes
- Coverage notes
- Extra preambles, citations, footnotes, or source-specific artifacts

Your job is to produce **one clean consolidated Markdown file** that preserves the intended output structure and formatting while removing duplicates and retaining the strongest content.

---

## Inputs I will provide

I will provide:

1. The original prompt or required output format, when available.
2. Two or more Markdown outputs from different LLMs for the same task.

Treat the original prompt or required output format as the formatting authority.

Treat the LLM-generated Markdown files as candidate content sources.

---

## Primary goal

Create a single consolidated Markdown file that:

- Keeps the same heading hierarchy and overall structure as the original required format.
- Keeps the same table structure and column names.
- Removes duplicate and near-duplicate rows.
- Preserves the strongest unique rows from all inputs.
- Merges overlapping explanations into concise, specific wording.
- Merges product lists, forum-discovery notes, and coverage notes without repetition.
- Removes LLM-specific preambles, process notes, citations, footnotes, and irrelevant commentary.
- Produces clean Markdown only.

Do not create a comparison report.  
Do not explain how you consolidated the files.  
Do not include source names such as Claude, ChatGPT, Gemini, or any other LLM in the final output.

---

## Formatting authority

Use the original required format when provided.

If no original required format is provided, use the most complete and clean Markdown structure found across the input files.

For AZ-305 documentation maps, prefer this structure:

```markdown
## Domain: <domain name>

### Skill: <skill name>

#### Task: <task name>

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|
| [Documentation set name](https://learn.microsoft.com/en-us/...) | <https://learn.microsoft.com/en-us/...> | Concise explanation of why this source supports the task. |

Potentially relevant products considered: Product 1, Product 2, Product 3.

Forum-discovery note: One concise paragraph explaining forum/community signals, without including forum links.

Coverage notes:
- Concise coverage note.
- Concise coverage note.
```

---

## Required table format

Use exactly these columns:

| Supporting product documentation | URL | Why this supports the task |
|---|---|---|

Column rules:

1. **Supporting product documentation**
   - Use a Markdown hyperlink.
   - The link target must match the URL shown in the URL column.
   - Use the Microsoft documentation set name where possible.
   - Prefer parent documentation set names over leaf article names unless the original required format explicitly allows the more specific name.

2. **URL**
   - Use the full canonical URL as plain text in angle brackets.
   - Correct format:

     ```markdown
     <https://learn.microsoft.com/en-us/azure/migrate/>
     ```

   - Do not use Markdown link syntax in this column.

3. **Why this supports the task**
   - Keep explanations concise but specific.
   - Merge the best wording from duplicate rows when useful.
   - Focus on design relevance, tradeoffs, service selection, architecture decisions, operational considerations, migration planning, or exam-task relevance.
   - Avoid generic statements that could apply to any Azure service.

---

## URL normalization rules

Normalize URLs before identifying duplicates.

For duplicate detection:

- Treat Markdown-linked URLs and angle-bracket URLs as the same URL.
- Treat trailing slash differences as the same URL.
- Remove tracking parameters such as:
  - `utm_source`
  - `utm_medium`
  - `utm_campaign`
  - `ocid`
- Remove unnecessary query parameters unless they are required for the page to make sense.
- Prefer canonical `https://learn.microsoft.com/en-us/...` URLs.
- Prefer English Microsoft Learn URLs.
- Do not include shortened URLs or redirect URLs.

For the final output:

- Use the clean canonical URL.
- Use angle brackets in the URL column.
- Ensure the hyperlink in the first column points to the same clean canonical URL.

---

## Duplicate-removal rules

Remove exact duplicates and near duplicates.

### Exact duplicates

Rows are exact duplicates when they have the same canonical URL.

When duplicate URLs appear:

- Keep one row.
- Preserve the best documentation set name.
- Merge the strongest parts of the rationale into one concise explanation.
- Do not keep multiple rows solely because the wording differs.

### Near duplicates

Rows are near duplicates when they cover the same documentation set and the same purpose, even if the URL differs slightly.

Examples:

- Product root vs overview page for the same general purpose
- Same article with or without trailing slash
- Same article with query parameters
- Same documentation page shown with different link syntax
- Same product represented by slightly different display names

When near duplicates appear:

- Prefer the most canonical or broadly useful URL.
- Prefer product roots or overview pages for general product coverage.
- Prefer deeper article URLs only when they support a distinct concept better than the product root.
- Do not keep multiple rows that support the same concept with only minor wording differences.

### Legitimate repeated documentation sets

It is acceptable to keep multiple rows from the same documentation set only when each row supports a meaningfully different concept.

Examples:

- One Azure Migrate row for the documentation root and another for web app migration modernization.
- One Azure Architecture Center row for compute selection and another for container service comparison.
- One Cloud Adoption Framework row for migration methodology and another for landing zone readiness.

Do not keep repeated rows simply to inflate coverage.

---

## Row selection and prioritization

When selecting final rows, prioritize:

1. Rows that directly support the provided AZ-305 task.
2. Official Microsoft documentation.
3. Architecture or decision guidance for recommendation-style tasks.
4. Product documentation roots or overview pages for major services.
5. Deeper articles when they address a specific migration, design, comparison, or operational decision.
6. Rows that appear across multiple inputs.
7. Rows that appear in only one input but add a distinct, relevant concept.

For AZ-305 documentation maps, keep the final table focused. Unless the original prompt requires a different range, target **5–15 rows**.

---

## Source filtering rules

The final table must include only official Microsoft sources unless the original prompt explicitly allows otherwise.

Acceptable sources include:

- Microsoft Learn Azure documentation
- Microsoft Entra documentation
- Azure Architecture Center
- Cloud Adoption Framework
- Azure Well-Architected Framework
- Microsoft Defender documentation
- Microsoft Purview documentation
- Microsoft Learn modules
- Microsoft product comparison pages

Do not include these in the final table:

- Reddit links
- Forum links
- Blog links
- Exam dumps
- Braindumps
- Unofficial study guides
- Generic search result pages
- LLM-generated citations
- Footnote reference definitions

Community or forum references may be summarized only in the **Forum-discovery note**, and only as discovery signals, not as authoritative sources.

---

## Heading consolidation rules

Use one unified set of headings.

- Keep the official domain, skill, and task wording if it is consistent across files.
- If the wording differs slightly, choose the wording that best matches the original prompt or official study guide wording.
- Remove preamble text such as:
  - “Here is the completed map”
  - “Using the uploaded prompt as the format anchor”
  - “I searched the web”
  - “Confirmed”
  - Any model-specific process commentary

Do not add extra headings unless they are part of the required format.

---

## Product list consolidation rules

For **Potentially relevant products considered**:

- Merge products from all inputs.
- Remove duplicates and near duplicates.
- Normalize product names.
- Keep a logical order:
  1. Core migration methodology and tooling
  2. Primary target services
  3. Supporting architecture and governance services
  4. Related services that may be adjacent but not central
- Keep the list concise.
- Do not include products that are clearly unrelated to the task.
- Do not include explanatory text in this line unless the original format requires it.

---

## Forum-discovery note consolidation rules

For **Forum-discovery note**:

- Merge overlapping observations from all inputs.
- Keep one concise paragraph.
- Do not include raw forum links.
- Do not cite Reddit, blogs, or forums.
- State that public discussions were used only as discovery signals if that concept appears in the source files or original prompt.
- Remove any claim that sounds like an exam leak or a direct exam-question reference.

---

## Coverage notes consolidation rules

For **Coverage notes**:

- Merge all useful, non-duplicative coverage notes.
- Prefer notes that explain:
  - Whether coverage is concentrated in one documentation set or fragmented across several.
  - Which documentation sets are worth downloading first.
  - Which architecture guidance is especially useful.
  - Which products are likely supporting or adjacent topics.
  - Which items were lightly covered and should not dominate the map.
- Use the bullet style from the original required format.
- Keep each bullet concise.
- Avoid repeating the same idea in different words.

---

## Conflict-resolution rules

When inputs disagree:

1. Prefer the original required format over any generated output.
2. Prefer official Microsoft documentation URLs over unofficial or community links.
3. Prefer canonical URLs over redirected, localized, shortened, or tracking URLs.
4. Prefer task-specific explanations over generic product descriptions.
5. Prefer a row that appears in multiple outputs unless a single-output row adds clear unique value.
6. Preserve a unique high-value row even if it appears in only one output.
7. Remove a row if it is only loosely related to the task and the final table is already strong.

Do not invent new sources or add new documentation links that are not present in the input files unless I explicitly ask you to research and improve the consolidated result.

---

## Final quality checklist

Before producing the final Markdown, verify:

- The output uses one clean Markdown structure.
- The table has exactly the required columns.
- Every table URL is canonical and formatted with angle brackets.
- The first-column hyperlink target matches the URL column.
- Duplicate and near-duplicate rows are removed.
- Repeated documentation sets are kept only when they support distinct concepts.
- The product list is merged and deduplicated.
- The forum-discovery note is one clean paragraph without raw forum links.
- Coverage notes are merged, concise, and non-repetitive.
- No LLM names appear in the final output.
- No citations, footnotes, or reference-link definitions appear in the final output.
- No preamble or postscript appears outside the required Markdown structure.
- The final answer is clean Markdown only.

---

## Deliverable

Produce one consolidated Markdown file.

The final output must contain only the consolidated Markdown content. Do not include commentary before or after it.
