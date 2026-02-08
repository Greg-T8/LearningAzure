---
name: question
description: Generates a title + question text and wraps the screenshot image in a <details> block
target: editor
mode: insert
---

# Exam Question Title Generator 🔖

## ⚠️ CRITICAL SCREENSHOT REQUIREMENT ⚠️
**You MUST use ONLY the screenshot image attached to the inline chat prompt.**
**DO NOT use any images from the workspace, notes file, or editor context.**
**IGNORE all image paths you see in the file - use ONLY the attached image.**

---

You are given a screenshot image that contains the context of an exam-style question (portal UI, CLI output, logs, configuration, diagram, or error message). Your task is to return a single, concise, exam-quality title that summarizes the main issue or objective shown in the screenshot.

---

## Requirements ✅
- **SCREENSHOT SOURCE**: The user will attach ONE screenshot to the inline chat. Extract the image path from that attachment ONLY. Do not use any other image paths.
- **DO NOT** reference images from: workspace files, editor context, notes.md, or any `.img/` paths you see in the file.
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
    - Insert a blank line
    - **CRITICAL: Create an `<img>` tag using the path from the screenshot attachment in the inline chat** (format: `<img src='PATH_FROM_ATTACHMENT' width=700>`)
    - **DO NOT use any `.img/` paths from the workspace or notes file**
    - Insert a blank line
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
- **CRITICAL**: The screenshot image path MUST come from the inline chat attachment. Ignore all other image paths from workspace/context.
- **CRITICAL**: If you see image paths like `.img/2026-01-30-*.png` in the editor, DO NOT USE THEM. Use only the attached screenshot.
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

  <img src='[PATH FROM YOUR INLINE CHAT ATTACHMENT]' width=700>

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

**NOTE**: In the examples above, `[PATH FROM YOUR INLINE CHAT ATTACHMENT]` means you should use the actual path from the image attached to the inline chat, NOT any paths visible in the workspace.

---

## Notes
- If multiple titles are equally reasonable, choose the most specific and action-oriented one.
- The explanation and hands-on lab blocks **must remain completely empty**—they are placeholders for manual completion later.
- Do not generate or suggest any content for the explanation or lab sections.
- **SCREENSHOT REMINDER**: Extract the image path ONLY from the inline chat attachment. Do not use workspace images.
- Usage:
  1. In your notes file, place the cursor where you want the question inserted.
  2. **Attach the screenshot image to the inline chat** (this is the ONLY image you should use).
  3. Run `/question` in the editor - the output will automatically insert at the cursor position.
  4. The output will include the screenshot image PATH from your attachment, wrapped in the `<details>` block, followed by empty explanation and lab blocks.
