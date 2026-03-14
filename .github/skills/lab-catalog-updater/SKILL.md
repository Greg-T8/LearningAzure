---
name: lab-catalog-updater
description: 'Scan and update hands-on-labs README.md files with accurate lab catalogs, statistics, and cross-references. Use when asked to update lab README, refresh lab catalog, update lab statistics, or update Related Labs and Related Practice Exam Questions sections for AI-102, AZ-104, or AI-900.'
user-invokable: false
argument-hint: '[exam] [scope]'
---

# Lab Catalog Updater

Scans hands-on-labs directories and updates README.md files with accurate lab catalogs, statistics, and cross-references.

## When to Use

- Updating hands-on-labs README files after adding or removing labs
- Refreshing lab statistics and counts
- Updating Related Labs cross-references in individual lab READMEs
- Updating Related Practice Exam Questions links in individual lab READMEs
- Auditing lab catalog accuracy

## Scope

This skill applies to exam-specific hands-on-labs directories:

- `certs/AI-102/hands-on-labs/README.md`
- `certs/AZ-104/hands-on-labs/README.md`
- `certs/AI-900/hands-on-labs/README.md` (if present)

## Filesystem-First Fidelity Rule

> **CRITICAL — Every lab entry, link, and cross-reference written to any README MUST correspond to a directory and file that has been verified to exist on the filesystem using a directory listing or file-read tool call.** Do NOT infer, guess, or fabricate lab folder names, titles, descriptions, or paths. If a directory listing does not return a lab folder, that lab does not exist and MUST NOT appear in any output.

Violations of this rule produce broken links and inaccurate catalogs. The scanning step below exists precisely to establish a verified inventory — all downstream steps operate exclusively on that inventory.

## Update Process

### Step 1: Scan for Labs (Filesystem Verification)

For each exam's hands-on-labs directory:

1. **Use a directory-listing tool** to enumerate all subdirectories under each domain folder (e.g., `storage/`, `compute/`, `generative-ai/`)
2. Identify lab folders (typically named `lab-*`) — only folders **actually returned by the listing tool** qualify
3. For each verified lab folder, **read its README.md** to extract:
   - Lab title (from the `# Lab:` heading)
   - Brief description (from context or "Solution Architecture" section)
   - Current Related Labs section (if present)
   - Current Related Practice Exam Questions section (if present)
   - Core concepts and topics covered
4. Build a catalog containing **only verified labs** with their domains, titles, and key concepts
5. **Do NOT add any lab to the catalog that was not found on the filesystem** — no placeholders, no examples, no assumed names

### Step 2: Update the Main README.md

Sections must appear in this order:

**1. Title and Description** — Keep existing title and introductory text unchanged

**2. Lab Statistics Section (`## 📈 Lab Statistics`)**

- Update `Total Labs` count
- Update individual domain counts
- List domains in this order:
  - AI-102: Generative AI, Agentic, Computer Vision, Natural Language Processing, Knowledge Mining
  - AZ-104: Storage, Compute, Monitoring, Identity & Governance, Networking

**3. Labs Section (`## 🧪 Labs`)**

- Organize labs by domain
- Format: `- **[Lab Title](domain/lab-folder/README.md)** - Brief description`
- The `Lab Title` and `lab-folder` values MUST come from the verified scan — never invented or paraphrased
- The brief description MUST be derived from the lab's own README content
- Keep labs within each domain in alphabetical order
- **Omit any domain heading that contains zero verified labs**

**4. Governance & Standards Section (`## 📋 Governance & Standards`)** — Keep unchanged

### Step 3: Update Related Labs Sections

For each individual lab's README.md:

1. Locate the "Related Labs" section (typically near the end)
2. Identify related labs based on:
   - **Same domain** — Labs in the same domain folder
   - **Similar concepts** — Labs testing related Azure features
   - **Complementary topics** — Labs that provide context or prerequisites
3. Update with 0–2 related lab links
4. Format: `▶ Related Lab: [lab-folder-name](../../domain/lab-folder-name/README.md)`

**Related Labs Guidelines:**

- Limit to 2 most relevant labs maximum
- Prefer labs within the same domain
- Use relative paths from the current lab location
- Maintain the `▶` arrow prefix

### Step 4: Update Related Practice Exam Questions Sections

For each individual lab's README.md:

1. Locate the "Related Practice Exam Questions" section near the end of the file (adjacent to Related Labs)
2. If the section does not exist, add it near the bottom next to the Related Labs section
3. Identify 1–3 relevant practice exam questions based on matching services, skills, and objectives
4. Add links using repository-relative paths to the applicable practice exam markdown location
5. Format each entry as: `▶ Practice Question: [Question Title](relative/path/to/question.md)`

**Related Practice Exam Questions Guidelines:**

- Keep links tightly aligned to the lab's primary objectives
- Prefer question links from the same exam track (AI-102, AZ-104, AI-900)
- Limit to 3 question links maximum
- Use relative paths from the current lab location
- Maintain the `▶` arrow prefix

### Step 5: Protected Sections

Do NOT modify:

- Title and description
- `## 📋 Governance & Standards` section
- Any custom notes or commentary

## Validation

After updating:

1. **Path-existence check** — For every link written (lab links, Related Labs, Related Practice Exam Questions), confirm the target file exists on the filesystem using a tool call. Remove or do not write any link whose target does not exist
2. Confirm lab counts match actual labs present (recount from the verified scan)
3. Ensure consistent formatting across all lab entries
4. Check that no labs are duplicated or missing relative to the verified scan
5. Verify Related Labs sections reference only labs that appear in the verified scan
6. Confirm all relative paths in Related Labs sections resolve correctly
7. Verify Related Practice Exam Questions sections are present and correctly placed near Related Labs
8. Confirm all practice question links resolve to existing markdown files
9. **If any link fails validation, remove it rather than leaving a broken reference**

## Output Summary

After completing updates, report:

1. **Summary of Changes** — Labs added/removed, updated statistics, Related Labs changes
2. **File List** — All README.md files updated
3. **Lab Inventory** — Complete list of labs found
4. **Related Labs Summary** — Labs with new or updated cross-references
5. **Practice Question Summary** — Labs with new or updated Related Practice Exam Questions links
