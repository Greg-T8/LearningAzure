---
name: Update-Lab-References
description: Updates hands-on-lab README files to reflect the latest labs in the repository, including related practice exam question links
---

# Hands-on Lab README Updater

Update the hands-on-labs README.md files to accurately reflect all labs in the repository.

Also update individual lab README files to include a dedicated related practice exam question links section near the bottom (next to Related Labs).

Uses the `lab-catalog-updater` skill for the full scanning, updating, and validation workflow.

## Scope

- `AI-102/hands-on-labs/README.md`
- `AZ-104/hands-on-labs/README.md`
- `AI-900/hands-on-labs/README.md` (if present)

## Practice Exam README Fix

- Search all practice exam question README files (for example under any `practice-exams` folders and individual assessment MDs such as `Microsoft_Assessment_*.md`, `TutorialsDojo_*.md`, etc.) and ensure any `<details>` blocks that include the `open` attribute (for example `<details open>`) are changed to plain `<details>` so explanations are collapsed by default.
- Include this check as part of the updater run so individual exam README files have their explanation blocks collapsed when rendered.

## Invocation Examples

- "Update the hands-on-labs README files"
- "Update AI-102 hands-on-labs README with latest labs"
- "Refresh the lab catalog in AZ-104"
- "Update Related Labs sections across all labs"
- "Add Related Practice Exam Questions sections across all labs"
