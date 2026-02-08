---
name: question
description: Generates a title + question text and wraps the screenshot image in a <details> block
target: editor
mode: insert
---

# Exam Question Title Generator 🔖

You are given a screenshot image that contains the context of an exam-style question (portal UI, CLI output, logs, configuration, diagram, or error message). Your task is to return a single, concise, exam-quality title that summarizes the main issue or objective shown in the screenshot.

---

## Requirements ✅
- Output a short **multi-line** snippet that is safe to **insert at the cursor** in the editor.
- Output must follow this exact structure (no code fences, no extra commentary):
  1. Title line: `### ` followed by the title (no surrounding quotes)
  2. Immediately below the title: the **exam question transcribed as text** from the screenshot
     - Include the question prompt and any visible answer choices
     - **Format answer choices on separate lines** (e.g., A. ... on one line, B. ... on the next line)
     - **Add two spaces at the end of each answer choice line** to ensure proper markdown line breaks
     - Preserve key wording (service names, errors, settings) as seen
  3. Then wrap the image tag in a `<details>` block:
     - `<details>`
     - `<summary>📸 Click to expand screenshot</summary>`
    - (the existing `<img ...>` tag, unchanged)
     - `</details>`
  4. Add an explanation block (open by default):
     - `<details open>`
     - `<summary>💡 Click to expand explanation</summary>`
     - **Leave completely empty** (blank line only)
     - `</details>`
  5. Add a hands-on lab block:
     - `<details>`
     - `<summary>🔬 Click to expand hands-on lab</summary>`
     - **Leave completely empty** (blank line only)
     - `</details>`
- **CRITICAL**: Do not fill in any content inside the explanation or hands-on lab blocks. They must remain empty.
- If the screenshot is ambiguous, return exactly: `UNCLEAR: Need more context or a short description of the screenshot` (and nothing else).
- Keep the title short and focused: **3–10 words**, maximum **60 characters**.
- Use **Title Case** (capitalize main words) and prefer a **noun phrase** or short label (e.g., "Troubleshooting Azure AD Connect Sync Errors").
- Include the technology or service when clearly identifiable (e.g., "Azure AD", "Azure VNet", "Azure CLI", "Bicep").
- Avoid phrasing as a question or using leading words such as "How to" or "What is".
- Do not add explanations, answers, or reasoning—only the title, the question text, the wrapped image, and empty placeholder blocks.

---

## Style Tips 💡
- Prefer active, outcome-oriented titles: "Fix", "Troubleshoot", "Resolve", "Configure", "Identify".
- Avoid punctuation at the end (no question marks or exclamation marks).
- Keep it exam-appropriate and neutral — concise and specific.

---

## Examples (Input → Output)
- Screenshot: Azure AD Connect sync error showing object deletion failures
  Output:
  ### Troubleshooting Azure AD Connect Sync Failures
  Your Azure AD Connect sync is failing with object deletion errors. Which action should you take?
  A. ...
  B. ...
  <details>
  <summary>📸 Click to expand screenshot</summary>
  <img src='...' width=700>
  </details>

  <details open>
  <summary>💡 Click to expand explanation</summary>

  </details>

  <details>
  <summary>🔬 Click to expand hands-on lab</summary>

  </details>

- Screenshot: Azure Portal showing VNet peering misconfigured between subscriptions
  Output: ### Fix Azure Virtual Network Peering Across Subscriptions

- Screenshot: CLI output showing VM creation failed due to quota
  Output: ### Azure VM Creation Fails Due to Subscription Quota

- Screenshot: a blurry or generic dashboard with no clear artifact
  Output: UNCLEAR: Need more context or a short description of the screenshot

---

## Notes
- If multiple titles are equally reasonable, choose the most specific and action-oriented one.
- The explanation and hands-on lab blocks **must remain completely empty**—they are placeholders for manual completion later.
- Do not generate or suggest any content for the explanation or lab sections.
- Usage:
  1. In your notes file, select the existing `<img ...>` line you want wrapped (or place the cursor where you want the output inserted).
  2. Run `/question` in the editor - the output will automatically insert at the cursor position.
  3. The output will include your selected `<img ...>` line wrapped in the `<details>` block, followed by empty explanation and lab blocks.
