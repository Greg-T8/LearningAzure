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
   * Current Related Labs section (if present)
   * Core concepts and topics covered
4. Build a catalog of all labs with their domains, titles, and key concepts

### 2. Update the README.md

For the main hands-on-labs README.md, sections must appear in this order:

**1. Title and Description**

* Keep the existing title and introductory text unchanged

**2. Lab Statistics Section (`## 📈 Lab Statistics`)**

* Update `Total Labs` count
* Update individual domain counts
* List domains in this order:
  * For AI-102: Generative AI, Agentic, Computer Vision, Natural Language Processing, Knowledge Mining
  * For AZ-104: Storage, Compute, Monitoring, Identity & Governance, Networking

**3. Labs Section (`## 🧪 Labs`)**

* Organize labs by domain (Storage, Compute, Monitoring, Generative AI, etc.)
* List each lab with a markdown link to its README
* Format: `- **[Lab Title](domain/lab-folder/README.md)** - Brief description`
* Keep labs within each domain in alphabetical order

**4. Governance & Standards Section (`## 📋 Governance & Standards`)**

* Keep the existing governance section unchanged

### 3. Update Related Labs sections

For each individual lab's README.md:

1. Locate the "Related Labs" section (typically near the end, after "Additional Resources")
2. Identify related labs based on:
   * **Same domain** - Labs in the same domain folder (e.g., all storage labs)
   * **Similar concepts** - Labs testing related Azure features or scenarios
   * **Complementary topics** - Labs that provide context or prerequisites
3. Update with 0-2 related lab links
4. Format: `▶ Related Lab: [lab-folder-name](../../domain/lab-folder-name/README.md)`
5. If no strongly related labs exist, the section may be omitted or left with placeholder text

**Related Labs Guidelines:**

* Limit to 2 most relevant labs maximum
* Prefer labs within the same domain
* For cross-domain relationships, choose labs with clear conceptual overlap
* Use relative paths from the current lab location
* Maintain the `▶` arrow prefix for consistency

### 4. Required Sections (do not modify)

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
5. Verify Related Labs sections contain appropriate cross-references
6. Confirm all relative paths in Related Labs sections are correct

## Output Format

Provide:

1. **Summary of Changes**
   * Number of labs added to main README
   * Number of labs removed from main README (if any)
   * Updated statistics
   * Number of lab READMEs with updated Related Labs sections
2. **File List**
   * List all README.md files updated (main and individual labs)
3. **Lab Inventory**
   * Complete list of labs found and cataloged
4. **Related Labs Summary**
   * List of labs with new or updated Related Labs cross-references

## Invocation Examples

* "Update the hands-on-labs README files"
* "Update AI-102 hands-on-labs README with latest labs"
* "Refresh the lab catalog in AZ-104"
* "Update Related Labs sections across all labs"
* "Update hands-on-labs README and Related Labs cross-references"
