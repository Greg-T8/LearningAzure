---
name: question-formatter
description: 'Extract exam questions from pasted screenshot images and format them as structured markdown. Use when asked to extract a question from an image, format an exam question, or replace an image tag with formatted question content.'
user-invokable: false
argument-hint: '[image or selection]'
---

# Question Formatter

Extracts exam question content from pasted screenshot images and formats it as structured markdown for practice exam files.

## When to Use

- Extracting text from a pasted exam question screenshot
- Formatting an exam question into the standard markdown structure
- Replacing an `<img>` line in a practice exam file with formatted content

## Process

1. Extract all text and content from the pasted screenshot image
2. Format using the output structure below
3. Replace the selected `<img>` line using `replace_string_in_file` with the formatted output

**Do NOT** read or modify other parts of the file. Only replace the selected image tag.

## Output Structure

### Title

Generate a concise title (3–10 words, Title Case, exam-appropriate):

```markdown
### <Title Extracted From Image>
```

### Prompt Section

Transcribe the full question prompt exactly as shown in the image. Preserve paragraph breaks and formatting.

### Answer Section

**For Yes/No format:**

```markdown
| Statement | Yes | No |
|----------|-----|----|
| <Statement text from image> | ☐ | ☐ |
| <Statement text from image> | ☐ | ☐ |
```

**For Multiple Choice (A, B, C, D):**

List each option on a separate line with label. Add two spaces at end of each line for line breaks.

### Screenshot Block (collapsed)

```html
<details>
<summary>📸 Click to expand screenshot</summary>

<img src="<path from selected line>" width=700>

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

- Extract content **ONLY** from the pasted screenshot image
- Use ☐ (unchecked boxes) for Yes/No tables
- Do **NOT** infer, solve, or explain answers
- Do **NOT** modify existing content in the document
- Preserve exact wording from image
