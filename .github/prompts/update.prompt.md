---
name: Update
description: Updates hands-on-lab README files to reflect the latest labs in the repository
---

# Hands-on Lab README Updater

Update the hands-on-labs README.md files in the repository to accurately reflect all labs currently present in the directory structure.

## Scope

This prompt applies to exam-specific hands-on-labs directories:

* `AI-102/hands-on-labs/README.md`
* `AZ-104/hands-on-labs/README.md`
* `AI-900/hands-on-labs/README.md` (if present)

## Update Process

### 1. Scan for labs

For each exam's hands-on-labs directory:

1. List all subdirectories under each domain folder (e.g., `storage/`, `compute/`, `generative-ai/`, etc.)
2. Identify lab folders (typically named `lab-*`)
3. Read the README.md file within each lab folder to extract:
   * Lab title (from the `# Lab:` heading)
   * Brief description (from context or "Solution Architecture" section)

### 2. Update the README.md

For the main hands-on-labs README.md:

**Labs Section (`## 🧪 Labs`)**

* Organize labs by domain (Storage, Compute, Monitoring, Generative AI, etc.)
* List each lab with a markdown link to its README
* Format: `[Lab Title](domain/lab-folder/README.md) - Brief description`
* Keep labs within each domain in alphabetical order

**Lab Statistics Section (`## 📈 Lab Statistics`)**

* Update `Total Labs` count
* Update individual domain counts
* List domains in this order:
  * For AI-102: Generative AI, Agentic, Computer Vision, Natural Language Processing, Knowledge Mining
  * For AZ-104: Storage, Compute, Monitoring, Identity & Governance, Networking

**Last Updated Date**

* Update to current date in format: `*Last updated: February 11, 2026*`

### 3. Required Sections (do not modify)

Do not modify these sections:

* Title and description
* `## 📋 Governance & Standards` section
* Any custom notes or commentary

## Validation

After updating:

1. Verify all lab links are valid (check paths)
2. Confirm lab counts match actual labs present
3. Ensure consistent formatting across all lab entries
4. Check that no labs are duplicated or missing

## Output Format

Provide:

1. **Summary of Changes**
   * Number of labs added
   * Number of labs removed (if any)
   * Updated statistics
2. **File List**
   * List all README.md files updated
3. **Lab Inventory**
   * Complete list of labs found and cataloged

## Invocation Examples

* "Update the hands-on-labs README files"
* "Update AI-102 hands-on-labs README with latest labs"
* "Refresh the lab catalog in AZ-104"
