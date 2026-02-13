---
name: question
description: Replace selected image line with formatted question from pasted screenshot
---

# Question Extraction Prompt

**TASK: Replace the selected `<img>` line with formatted question structure.**

1. Extract all text and content from the pasted screenshot image
2. Format it using the structure below
3. Call `replace_string_in_file` with the selected image line as oldString and formatted output as newString

DO NOT read/modify other parts of the file. Only replace the selected image tag.

---

## Output Structure

### Title (3-10 words, Title Case, exam-appropriate)

`### <Title Extracted From Image>`

---

### Prompt Section

Transcribe the full question prompt exactly as shown in the image. Preserve paragraph breaks and formatting.

---

### Answer Section

**For Yes/No format:**

```markdown
| Statement | Yes | No |
|----------|-----|----|
| <Statement text from image> | ☐ | ☐ |
| <Statement text from image> | ☐ | ☐ |
```

**For Multiple Choice (A, B, C, D):**

List each option on a separate line with label. Add two spaces at line end.

---

### Screenshot Block (collapsed)

```html
<details>
<summary>📸 Click to expand screenshot</summary>

<img src="<path from selected line>" width=700>

</details>
```

---

### Explanation Placeholder (open, empty)

```html
<details open>
<summary>💡 Click to expand explanation</summary>

</details>
```

Leave completely empty - no content.

---

### Related Lab Line

`▶ Related Lab: []()`

Always include. Leave link empty for manual completion.

---

## Rules

* Extract content ONLY from the pasted screenshot image
* Use ☐ (unchecked boxes) for Yes/No tables
* Do NOT infer, solve, or explain answers
* Do NOT modify existing content in the document
* Preserve exact wording from image

---
