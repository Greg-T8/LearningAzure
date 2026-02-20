---
name: exam-question-extractor
description: 'Extract exam questions from pasted screenshot images and format them as structured markdown. Use when asked to extract a question from an image, format an exam question, or replace an image tag with formatted question content.'
user-invokable: true
argument-hint: '[image or selection]'
---

# Question Formatter

Extracts exam question content from pasted screenshot images and formats it as structured markdown for practice exam files.

## When to Use

- Extracting text from a pasted exam question screenshot
- Formatting an exam question into the standard markdown structure

## Process

1. Extract all text and content from the pasted screenshot image
2. Identify the question type (Yes/No, Multiple Choice, or Multiple Drop-Down)
3. Format using the output structure below, applying the correct answer section for the type
4. Call `replace_string_in_file` with the selected `<img>` line as `oldString` and the formatted output as `newString`

## Output Structure

### Title

Generate a concise title (3–10 words, Title Case, exam-appropriate):

```markdown
### <Title Extracted From Image>
```

### Prompt Section

Transcribe the full question prompt exactly as shown in the image. Preserve paragraph breaks and formatting.

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

If only the main question screenshot is provided (no expanded-dropdown screenshots), output the placeholder markers in the prompt and omit the options list. Add a comment so the user knows to supply them:

```markdown
<!-- Dropdown options not yet provided. Paste screenshots of each expanded drop-down to populate. -->
```

Reference the following example for a complete Multiple Drop-Down question with all screenshots provided:  [Example - Multiple Drop-Down](Example%20-%20Multiple-Drop-Down.md)

---

### Screenshot Block (collapsed)

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

### Explanation Placeholder (open, empty)

```html
<details open>
<summary>💡 Click to expand explanation</summary>

</details>
```

Leave completely empty — no content inside.

### Related Lab Line

```markdown
▶ Related Lab: []()
```

Always include. Leave link empty for manual completion.

## Rules

- Extract content **ONLY** from the pasted screenshot image(s)
- Only replace the selected `<img>` line — do **NOT** modify any other content in the file
- Use ☐ (unchecked boxes) for Yes/No tables
- Use ○ (open circles) for Multiple Drop-Down option lists
- Do **NOT** infer, solve, or explain answers
- Preserve exact wording from image
- Do not separate sections with horizontal lines or any formatting beyond what is specified above
- For Multiple Drop-Down questions, number the `[Select ▼]` placeholders sequentially to match them with their option lists
