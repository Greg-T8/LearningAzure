---
name: lab-catalog-updater
description: 'Scan and update hands-on-labs README.md files with accurate lab catalogs, statistics, and cross-references. Use when asked to update lab README, refresh lab catalog, update lab statistics, or update Related Labs sections for AI-102, AZ-104, or AI-900.'
user-invokable: false
argument-hint: '[exam] [scope]'
---

# Lab Catalog Updater

Scans hands-on-labs directories and updates README.md files with accurate lab catalogs, statistics, and cross-references.

## When to Use

- Updating hands-on-labs README files after adding or removing labs
- Refreshing lab statistics and counts
- Updating Related Labs cross-references in individual lab READMEs
- Auditing lab catalog accuracy

## Scope

This skill applies to exam-specific hands-on-labs directories:

- `AI-102/hands-on-labs/README.md`
- `AZ-104/hands-on-labs/README.md`
- `AI-900/hands-on-labs/README.md` (if present)

## Update Process

### Step 1: Scan for Labs

For each exam's hands-on-labs directory:

1. List all subdirectories under each domain folder (e.g., `storage/`, `compute/`, `generative-ai/`)
2. Identify lab folders (typically named `lab-*`)
3. Read the README.md within each lab folder to extract:
   - Lab title (from the `# Lab:` heading)
   - Brief description (from context or "Solution Architecture" section)
   - Current Related Labs section (if present)
   - Core concepts and topics covered
4. Build a catalog of all labs with their domains, titles, and key concepts

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
- Keep labs within each domain in alphabetical order

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

### Step 4: Protected Sections

Do NOT modify:

- Title and description
- `## 📋 Governance & Standards` section
- Any custom notes or commentary

## Validation

After updating:

1. Verify all lab links are valid (check paths exist)
2. Confirm lab counts match actual labs present
3. Ensure consistent formatting across all lab entries
4. Check that no labs are duplicated or missing
5. Verify Related Labs sections contain appropriate cross-references
6. Confirm all relative paths in Related Labs sections are correct

## Output Summary

After completing updates, report:

1. **Summary of Changes** — Labs added/removed, updated statistics, Related Labs changes
2. **File List** — All README.md files updated
3. **Lab Inventory** — Complete list of labs found
4. **Related Labs Summary** — Labs with new or updated cross-references
