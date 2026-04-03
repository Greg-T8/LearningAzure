---
name: mslearn-reference-builder
description: 'Build structured reference link trees from Microsoft Learn learning paths or modules. Extracts modules, units, and inline documentation links into nested markdown for references pages. Use when building references, extracting learning path links, creating study reference documentation, or populating a references.md file.'
user-invocable: true
disable-model-invocation: true
argument-hint: '[learning path or module URL]'
---

# MS Learn Reference Builder

Extracts modules, units, and documentation links from Microsoft Learn training content and formats them as a nested markdown reference tree for insertion into reference documentation files.

## When to Use

- Building or extending a references page for a certification exam
- Extracting all documentation links from a Learning Path or Module
- Creating structured study reference material from Microsoft Learn content

## Input

The user provides one of:

- A **learning path URL** (`https://learn.microsoft.com/en-us/training/paths/...`) — all modules are extracted and processed
- A **module URL** (`https://learn.microsoft.com/en-us/training/modules/...`) — only that module is processed

## Exemplar

See `certs/AZ-305/references.md` for the complete output format. The "Design solutions for logging and monitoring" section demonstrates the exact nesting and display-text conventions.

## Output Format

Three indent levels using 2-space indentation per level:

```markdown
- [Microsoft Learn Module: <Module Title>](<module URL>)
  - [Unit N - <Unit Title>](<clean unit URL>)
    - [<Doc Area Title> - <Page Title>](<documentation URL>)
```

Where:

- **Module line**: Top-level bullet. Display text is `Microsoft Learn Module: <Title>`.
- **Unit line**: 2-space indent. Display text is `Unit N - <Title>` where N is the unit number.
- **Doc link line**: 4-space indent. Display text format is `<Doc Area Title> - <Page Title>`. See [formatting rules](./references/formatting-rules.md) for how to determine each component.

---

## Procedure

### Step 1: Detect Input Type

Examine the URL path:

- `/training/paths/` → learning path — proceed to Step 2
- `/training/modules/` → single module — skip to Step 3 with this module as the only entry

### Step 2: Extract Modules from Learning Path

Fetch the learning path page. Locate the "Modules in this learning path" section. Extract each module's:

- **Title** — the module heading text
- **URL** — the module link (e.g., `https://learn.microsoft.com/en-us/training/modules/<slug>/`)

Record modules in the order they appear on the page.

### Step 3: Extract Units per Module

For each module, fetch the module page. In the "Modules in this learning path" or unit listing section, extract each unit's:

- **Number** — sequential position (1, 2, 3, ...)
- **Title** — the unit heading text
- **URL** — the clean unit link

**URL cleaning**: Strip query parameters like `?ns-enrollment-type=learningpath&ns-enrollment-id=...` from unit URLs. The clean URL format is: `https://learn.microsoft.com/en-us/training/modules/<module-slug>/<unit-slug>`

### Step 4: Extract Documentation Links per Unit

For each unit, fetch the unit page. Extract all inline hyperlinks from the **body content** whose href points to official Microsoft documentation:

**Include** links whose path starts with:

- `/en-us/azure/`
- `/en-us/kusto/`
- `/en-us/entra/`
- `/en-us/microsoft-365/`
- `/en-us/windows-server/`
- `/en-us/powershell/`

**Exclude**:

- Image links (pointing to `.png`, `.jpg`, `.svg`, etc.)
- Training links (`/training/`)
- Navigation, footer, and sidebar links
- Anchor-only links (`#...`)
- Duplicate links within the same unit (keep first occurrence only)

Preserve the order links appear in the body content. Record both the link **href** and the **inline link text** (used as fallback for page title).

**Batching**: Fetch multiple unit pages per `fetch_webpage` call where possible (the tool accepts an array of URLs). Process 2–3 unit pages per call to balance throughput and output readability.

### Step 5: Resolve Display Text per Documentation Link

For each documentation link, determine two components:

1. **Doc Area Title** — the documentation area name (e.g., "Azure Monitor", "Azure Policy")
2. **Page Title** — the H1 heading of the target documentation page

#### 5a: Determine Doc Area Title

First, check the [known documentation area mappings](./references/formatting-rules.md#known-documentation-area-mappings) table. Match the URL path against the table entries (longest prefix match wins).

If the URL is not in the known-mappings table:

1. Fetch the documentation page
2. Look for the breadcrumb trail in the page navigation (often visible in the "Additional Links" section at the bottom as a series of links showing the documentation hierarchy)
3. Use the **most specific documentation area** from the breadcrumb (typically the service-level name, not the top-level category)
4. If "Documentation" appears as a suffix, drop it (e.g., "Azure Monitor Documentation" → "Azure Monitor")

If breadcrumb is not available, apply the [URL-based fallback](./references/formatting-rules.md#url-based-fallback) rules.

#### 5b: Determine Page Title

The page title is the **H1 heading** of the target documentation page. To obtain it:

1. **Preferred**: Fetch the documentation page and extract the H1 heading
2. **Fallback**: If the page cannot be fetched, use the inline link text from the unit page — but note this is often abbreviated or paraphrased and may not match the actual H1

**Batching**: Fetch multiple documentation pages per `fetch_webpage` call (up to 3 URLs per call). Focus the query on extracting the H1 page title.

**Deduplication**: If the same documentation URL appears in multiple units, reuse the previously resolved display text — do not re-fetch.

### Step 6: Assemble Output

Build the nested markdown tree:

1. For each module, emit the module line
2. For each unit within the module, emit the unit line (2-space indent)
3. For each documentation link within the unit, emit the doc link line (4-space indent)
4. Units with zero documentation links still appear (just no indented children)

If multiple modules were extracted from a learning path:

- Separate each module's block with a blank line for readability
- Output modules in learning-path order

### Step 7: Insert into Active File

Insert the assembled markdown into the user's active file at the current cursor position. If the user specifies a target section (e.g., a specific `###` heading), insert below that heading.

If the learning path spans multiple exam skill sections, inform the user which module maps to which section and let them confirm placement before inserting.

---

## Edge Cases

- **Redirected URLs**: Use the URL as extracted from the unit page. Do not attempt to resolve redirects.
- **Query parameters on doc links**: Preserve `?toc=`, `?view=`, `?preserve-view=`, and `?tabs=` parameters on documentation URLs. These affect breadcrumb context and page rendering.
- **`?toc=` context override**: When a documentation URL has a `?toc=` parameter, the doc area title should reflect the toc context, not the URL path. For example, a Storage page with `?toc=/azure/azure-monitor/toc.json` belongs under "Azure Monitor."
- **Duplicate doc links across units**: The same documentation link may appear under different units. Include it each time — do not deduplicate across units.
- **Knowledge check / assessment units**: These typically have zero documentation links. List the unit line with no children.
- **Introduction units**: These often have zero or few documentation links. Process them the same as other units.
- **Learning path with modules spanning multiple exam skills**: Output all modules and note which `###` section heading each might belong under. Let the user place them.

---

## Rate Limiting

Microsoft Learn pages are public and generally responsive, but be mindful of fetch volume:

- Batch unit page fetches (2–3 per call)
- Batch documentation page fetches (up to 3 per call)
- Reuse doc page titles across units when the same URL appears
- For a typical module with 7–11 units and 3–6 doc links per unit, expect roughly 10–20 total fetch calls
