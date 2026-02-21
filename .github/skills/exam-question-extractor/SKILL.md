---
name: exam-question-extractor
description: 'Extract exam questions from pasted screenshot images and format them as structured markdown. Operates in two modes: Image Replacement mode (inline chat, replaces selected img tag) and Extract Only mode (direct chat or Lab Orchestrator, returns title/prompt/answer only).' 
user-invokable: true
argument-hint: '[image or selection]'
---

# Question Formatter

Extracts exam question content from pasted screenshot images and formats it as structured markdown for practice exam files.

## Modes of Operation

This skill operates in one of two modes depending on how it is invoked.

### Mode 1: Image Replacement

- **Invocation:** User highlights an `<img>` line in a markdown file and invokes this skill from inline chat.
- **Output:** Title + Prompt + Answer + Screenshot Block + Explanation Placeholder + Related Lab Line.
- **Action:** Call `replace_string_in_file` with the selected `<img>` line as `oldString` and the formatted output as `newString`.

### Mode 2: Extract Only

- **Invocation:** Either invoked directly through chat (user pastes a screenshot image and asks to extract the question) **or** called by the Lab Orchestrator as part of a larger workflow. In both cases the image is available in the current chat context — no subagent is used.
- **Input:** The image is available in the chat context. Subagents launched via `runSubagent` or handoff buttons do not receive image attachments and cannot read binary image files, so image extraction must always happen in the active chat context.
- **Output:** Title + Prompt + Answer sections only. Do **not** include the Screenshot Block, Explanation Placeholder, or Related Lab Line.
- **Action:** Format and output the extracted content directly. Do **not** call `replace_string_in_file`.
- ⛔ **Prohibited output:** `<details>`, `<summary>`, Explanation Placeholder, and Related Lab Line are Image Replacement artefacts and are **never valid** in Extract Only output.

## Process

1. Determine the active mode (Image Replacement or Extract Only) based on invocation context — use **Extract Only** when invoked directly in chat with an attached image and no `<img>` line selected, or when called by the Lab Orchestrator

   **Mode gate — resolve this before writing any output:**
   - Selected `<img>` line in an open file → **Image Replacement.** Output: Title + Prompt + Answer + Screenshot Block + Explanation Placeholder + Related Lab Line.
   - Otherwise (direct chat with image, or Lab Orchestrator call) → **Extract Only.** Output: Title + Prompt + Answer **only.** Any `<details>` tag in your output is a mistake — stop and remove it before responding.

2. Extract all text and content from the pasted screenshot image
3. Identify the question type (Yes/No, Multiple Choice, or Multiple Drop-Down)
4. Format using the output structure below, applying the correct answer section for the type
5. **Image Replacement mode only:** Append the Screenshot Block, Explanation Placeholder, and Related Lab Line
6. **Image Replacement mode:** Call `replace_string_in_file` to replace the selected `<img>` line
7. **Extract Only mode:** Return the formatted markdown directly

## Output Structure

### Title

Generate a concise title (3–10 words, Title Case, exam-appropriate):

```markdown
### <Title Extracted From Image>
```

### Prompt Section

Transcribe the full question prompt exactly as shown in the image. Preserve paragraph breaks and formatting.

If the question contains a PowerShell command that is long or difficult to read on a single line, break it across multiple lines using a backtick (`` ` ``) at the end of each continued line. Align continuation lines for readability.

For Multiple Drop-Down questions, see the additional prompt rules in that subsection.

### Answer Section

Format the answer section according to the question type detected in the image.

---

#### Type 1: Yes / No

Use when the image shows a matrix of statements with Yes/No columns.

```markdown
| Statement | Yes | No |
|----------|-----|----|
| <Statement text from image> | ☐ | ☐ |
| <Statement text from image> | ☐ | ☐ |
```

---

#### Type 2: Multiple Choice

Use when the image shows lettered options (A, B, C, D, …).

List each option on a separate line with its label. Add two spaces at end of each line for line breaks.

```markdown
A. <Option text>  
B. <Option text>  
C. <Option text>  
D. <Option text>  
```

---

#### Type 3: Multiple Drop-Down (Fill-in-the-Blank)

Use when the image shows a question with one or more inline drop-down selectors (displayed as **"Select"** or **"Select ▼"** in the UI). The user will supply:

1. A screenshot of the main question (drop-downs shown as "Select")
2. One or more follow-up screenshots showing the expanded options for each drop-down

The number of drop-downs will vary by question. Number the placeholders sequentially in the order they appear in the question, top-to-bottom or left-to-right.

**Prompt rules for this type:**

- Reproduce the question layout as faithfully as possible.
- Replace each drop-down with a numbered placeholder: `[Select 1 ▼]`, `[Select 2 ▼]`, etc., numbered top-to-bottom or left-to-right as they appear in the image.
- If the question uses a table layout, preserve it:

```markdown
| <Column header> | <Column header> |
|-----------------|-----------------|
| <Label text>    | [Select 1 ▼]    |
| <Label text>    | [Select 2 ▼]    |
```

- If the drop-downs are inline within a sentence, keep them inline:

```markdown
You need to configure [Select 1 ▼] so that [Select 2 ▼] can access the resource.
```

**Answer format:**

List the options for each drop-down, extracted from the follow-up screenshots. Use bullet lines with ○ (open circle) for each option.

```markdown
**Select 1 options:**  
○ Option A  
○ Option B  
○ Option C  

**Select 2 options:**  
○ Option A  
○ Option B  
○ Option C  
```

The number of options must match the number of drop-down placeholders in the prompt, and the order of options must match the order of placeholders.

Reference the following example for a complete Multiple Drop-Down question with all screenshots provided:  [Example - Multiple Drop-Down](Example%20-%20Multiple-Drop-Down.md)

If only the main question screenshot is provided (no expanded-dropdown screenshots), output the placeholder markers in the prompt and omit the options list. Add a comment so the user knows to supply them:

```markdown
<!-- Dropdown options not yet provided. Paste screenshots of each expanded drop-down to populate. -->
```

---

### Screenshot Block (collapsed) — Image Replacement Mode Only

```html
<details>
<summary>📸 Click to expand screenshot</summary>

<img src="<path from selected line>" width=700>

</details>
```

For Multiple Drop-Down questions with additional screenshots, include all images inside a single collapsed block:

```html
<details>
<summary>📸 Click to expand screenshot</summary>

<img src="<main question screenshot path>" width=700>
<img src="<dropdown 1 screenshot path>" width=700>
<img src="<dropdown 2 screenshot path>" width=700>

</details>
```

### Explanation Placeholder (open, empty) — Image Replacement Mode Only

```html
<details open>
<summary>💡 Click to expand explanation</summary>

</details>
```

Leave completely empty — no content inside.

### Related Lab Line — Image Replacement Mode Only

```markdown
▶ Related Lab: []()
```

Always include in Image Replacement mode. Leave link empty for manual completion.

## Rules

### Both Modes

- Extract content **ONLY** from the pasted screenshot image(s)
- Use ☐ (unchecked boxes) for Yes/No tables
- Use ○ (open circles) for Multiple Drop-Down option lists
- Do **NOT** infer, solve, or explain answers
- Preserve exact wording from image
- Do not separate sections with horizontal lines or any formatting beyond what is specified above
- For Multiple Drop-Down questions, number the `[Select ▼]` placeholders sequentially to match them with their option lists

### Image Replacement Mode Only

- Only replace the selected `<img>` line — do **NOT** modify any other content in the file
- Include Screenshot Block, Explanation Placeholder, and Related Lab Line after the Answer section

### Extract Only Mode (Direct Chat or Lab Orchestrator)

- Return the formatted markdown (Title + Prompt + Answer) directly — do **not** write to any file
- Do **not** include the Screenshot Block, Explanation Placeholder, or Related Lab Line
- ⛔ Before finalizing output, verify it contains **none** of the following — if any are present, remove them before responding:
  - Any `<details>` or `<summary>` tag
  - The Explanation Placeholder block
  - The `▶ Related Lab:` line
