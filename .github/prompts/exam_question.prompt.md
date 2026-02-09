---
name: question
description: Generates a title + question text and wraps the screenshot image in a <details> block
---

# Exam Question Title Generator 🔖

## ⚠️ CRITICAL SCREENSHOT REQUIREMENT ⚠️

### MANDATORY WORKFLOW - FOLLOW THESE STEPS IN ORDER:

1. **ANALYZE THE ATTACHED IMAGE**: Look at the image that is attached/visible in the current context (this contains the screenshot you need to analyze)
2. **READ THE EDITOR**: Examine the editor content that appears BELOW the current cursor position
3. **FIND THE IMAGE TAG**: Locate the FIRST `<img>` tag below the cursor and extract its `src` attribute path
4. **READ IMAGE CONTENTS**: Read all text, UI elements, error messages, configurations, diagrams visible in the attached/visible screenshot
5. **GENERATE FROM IMAGE**: Create the title and question text based ONLY on what you actually see in the screenshot
6. **REUSE THE PATH**: Use the image path from step 3 (found below cursor) in your output's `<img>` tag

### CRITICAL RULES:

- **ANALYZE** the screenshot image that you can actually see/view in the current context
- **REUSE THE PATH** from the `<img>` tag found below the cursor in the editor
- **DO NOT** hallucinate, make up content, or reuse text from other questions in the file
- **DO NOT** guess at image contents - only describe what you actually see in the visible screenshot
- If you cannot view any screenshot image, output: `ERROR: No screenshot image is visible. Please ensure the image is available to analyze.`

---

You are given a screenshot image that contains the context of an exam-style question (portal UI, CLI output, logs, configuration, diagram, or error message). Your task is to return a single, concise, exam-quality title that summarizes the main issue or objective shown in the screenshot.

---

## Requirements ✅

### IMAGE ANALYSIS WORKFLOW (MANDATORY):

1. **Analyze Visible Screenshot**: Look at the screenshot image that is visible/attached in the current context - THIS is what you analyze
2. **Read Editor Content**: Look at the content in the editor that appears BELOW the cursor position
3. **Extract Image Path**: Find the FIRST `<img src='...'` tag below cursor and extract the file path from the `src` attribute
4. **Read Screenshot Contents**: Read all text, UI elements, error messages, configurations, diagrams visible in the screenshot you can see
5. **Generate Title**: Create a title based on what you actually saw in the screenshot
6. **Transcribe Question**: Write out the exam question text and answer choices exactly as shown in the screenshot
7. **Reuse Path**: Use the image path from step 3 (from editor) in your output's `<img>` tag

### OUTPUT FORMAT:

- **ANALYZE**: The screenshot image that is visible/attached in your context
- **REUSE PATH**: The image path from the `<img>` tag found below the cursor
- **DO NOT** hallucinate or make up content - only describe what you actually see in the visible screenshot
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
  - **CRITICAL: Create an `<img>` tag using the SAME path from the screenshot below the cursor** (format: `<img src='PATH_FROM_CURSOR_IMAGE' width=700>`)
  - **DO NOT change the image path—reuse the exact path from the img tag below the cursor**
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
- **CRITICAL**: The screenshot image path MUST come from the img tag found BELOW the cursor. Do not use images from other locations.
- **CRITICAL**: Only analyze and reference the FIRST img tag that appears BELOW the cursor position. Ignore all img tags above the cursor.
- **CRITICAL**: Analyze the screenshot image that is visible in your context. Get the file path from the editor below the cursor. Content = from screenshot you can see; Path = from editor.
- **VERIFICATION**: Before generating output, internally confirm: "I can see a screenshot showing [brief description]. I found the img path [path] below the cursor. I will use this path in my output." If you cannot see a screenshot, output `ERROR: No screenshot image is visible to analyze`.
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

### COMPLETE WORKFLOW EXAMPLE:

**What I can see:** A screenshot image showing a question titled "Identifying Machine Learning Model Deployment Options" asking which Azure service to use to host a trained ML model as a web service endpoint. Answer choices visible are: A. Azure Machine Learning designer, B. Azure Machine Learning Endpoints, C. Azure Synapse Analytics, D. Azure Data Factory

**Editor content below cursor shows:**

```
<img src='.img/2026-02-08-ml-deployment.png' width=700>
```

**Workflow:**

- **Step 1**: I can SEE a screenshot about ML model deployment options
- **Step 2**: Read editor below cursor
- **Step 3**: Found img path: `.img/2026-02-08-ml-deployment.png`
- **Step 4**: The screenshot shows: Question about deploying ML models with 4 Azure service options
- **Step 5**: Generate title based on what I see: "Identifying Machine Learning Model Deployment Options"
- **Step 6**: Transcribe the question and answers from the screenshot
- **Step 7**: Use the path from step 3 in output

**Output:**

```
### Identifying Machine Learning Model Deployment Options
You need to deploy a trained machine learning model to production so that client applications can consume predictions in real-time. Which Azure service should you use to host the model and expose it as a web service endpoint?
A. Azure Machine Learning designer
B. Azure Machine Learning Endpoints
C. Azure Synapse Analytics
D. Azure Data Factory

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-08-ml-deployment.png' width=700>

</details>

<details open>
<summary>💡 Click to expand explanation</summary>

</details>

<details>
<summary>🔬 Click to expand hands-on lab</summary>

</details>
```

---

### MORE EXAMPLES:

- Screenshot: Azure AD Connect sync error showing object deletion failures
  Output:

  ### Troubleshooting Azure AD Connect Sync Failures

  Your Azure AD Connect sync is failing with object deletion errors. Which action should you take?
  A. ...
  B. ...
  <details>
  <summary>📸 Click to expand screenshot</summary>

  <img src='[SAME PATH FROM IMG TAG BELOW CURSOR]' width=700>

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

**NOTE**: In the examples above, `[SAME PATH FROM IMG TAG BELOW CURSOR]` means you should reuse the exact path from the img tag found below the cursor position.

---

## Notes

- **MANDATORY IMAGE VIEWING**: You absolutely MUST analyze the visible screenshot image before generating any output. If you generate content without viewing the screenshot, your output will be wrong.
- Before generating, ask yourself: "Have I actually seen the screenshot image and analyzed what's in it?" If no, stop - you cannot proceed.
- **TWO-PART PROCESS**: (1) Analyze the screenshot you can see, (2) Get the file path from the editor below cursor, (3) Use that path in output.
- If multiple titles are equally reasonable, choose the most specific and action-oriented one.
- The explanation and hands-on lab blocks **must remain completely empty**—they are placeholders for manual completion later.
- Do not generate or suggest any content for the explanation or lab sections.
- **SCREENSHOT REMINDER**: Analyze the screenshot image that is visible in your context. Extract the image PATH from the `<img>` tag below the cursor, then use that path in your output. The content comes from the visible screenshot; the path comes from the editor.
- Usage:
  1. In your notes file, paste the screenshot image below where you want the question to be inserted.
  2. Place the cursor ABOVE the screenshot image (the image must be visible below the cursor).
  3. Run `/question` in the editor (or inline chat) - the AI will:
     - Analyze the screenshot image that it can see
     - Find the `<img>` tag below the cursor to get the file path
     - Generate content based on the screenshot it analyzed
     - Use the path from the editor in the output
  4. The output will include the screenshot image PATH from the img tag found below the cursor, wrapped in the `<details>` block, followed by empty explanation and lab blocks.
