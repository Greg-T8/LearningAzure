---
name: exam-question-extractor
description: "Extract exam questions from pasted screenshot images and format them as structured markdown. Operates in two modes: Image Replacement mode (inline chat, replaces selected img tag) and Extract Only mode (returns title/prompt/answer only)."
user-invokable: true
argument-hint: "[image attachment and/or selection]"
---

# Question Formatter

Extracts exam question content from screenshot images and formats it as structured markdown for practice exam files.

---

## Critical Vision Requirement

Text extraction **must always come from screenshot image(s) attached or pasted into the current chat**.

If an image is not attached in the active chat context, image extraction cannot occur.

---

## Modes of Operation

This skill operates in one of two modes depending on invocation context.

---

### Mode 1: Image Replacement

Mode 1 activates when:

1. The user has selected an `<img>` line inside a markdown file.
2. The corresponding screenshot image(s) are **attached/pasted in the current chat**.

If **either requirement is missing**, automatically **fall back to Mode 2 (Extract Only)**.

#### Output

Include:

- Title  
- Prompt  
- Answer  
- Screenshot Block  
- Explanation Placeholder  
- Related Lab Line

#### Action

Call:

```
replace_string_in_file

```

- `oldString` = exact selected `<img>` line(s)
- `newString` = fully formatted output

Only replace the selected content.

---

### Mode 2: Extract Only

Triggered when:

- Invoked directly via chat, **or**
- Called by Lab Orchestrator workflows.

#### Output

Return **only**:

- Title
- Prompt
- Answer

#### Prohibited Output

The following are **never valid** in Extract Only mode:

- `<details>`
- `<summary>`
- Screenshot Block
- Explanation Placeholder
- `▶ Related Lab:` line

#### Action

Return formatted markdown directly.

Do **not** call `replace_string_in_file`.

---

## Process

1. Determine active mode using the Mode Gate below.

### Mode Gate (Resolve First)

- Selected `<img>` line(s) **AND** screenshot image(s) attached in chat  
  → **Image Replacement Mode**

- Otherwise  
  → **Extract Only Mode**

If Image Replacement requirements are not fully satisfied, automatically downgrade to Extract Only.

---

2. Extract all visible text from attached screenshot image(s).
3. Identify question type:
   - Yes / No
   - Multiple Choice
   - Multiple Drop-Down
4. Format Title, Prompt, and Answer.
5. Image Replacement mode only:
   - Append Screenshot Block
   - Append Explanation Placeholder
   - Append Related Lab Line
6. Image Replacement mode:
   - Call `replace_string_in_file`.
7. Extract Only mode:
   - Return markdown output directly.

---

## Output Structure

### Title

Create a concise exam-appropriate title (3–10 words).

```markdown
### <Title Extracted From Image>
```

---

### Prompt

Transcribe the question exactly as shown.

Rules:

* Preserve wording and paragraph breaks.
* Maintain layout fidelity.
* Long PowerShell commands may wrap using backticks:

```
Get-AzSomething `
    -Parameter value `
    -Another value
```

---

### Answer Section

Choose format based on detected question type.

---

#### Type 1 — Yes / No

```markdown
| Statement | Yes | No |
|----------|-----|----|
| <Statement text> | ☐ | ☐ |
| <Statement text> | ☐ | ☐ |
```

---

#### Type 2 — Multiple Choice

```markdown
A. <Option text>  
B. <Option text>  
C. <Option text>  
D. <Option text>  
```

(two trailing spaces per line required)

---

#### Type 3 — Multiple Drop-Down (Fill-in-the-Blank)

Used when UI shows **Select** or **Select ▼** controls.

##### Prompt Rules

* Replace dropdowns with numbered placeholders:

```
[Select 1 ▼]
[Select 2 ▼]
```

* Preserve tables if present:

```markdown
| Column | Setting |
|--------|---------|
| Item A | [Select 1 ▼] |
| Item B | [Select 2 ▼] |
```

* Inline dropdowns remain inline.

##### Answer Format

If dropdown option screenshots exist:

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

If option screenshots are missing:

```markdown
<!-- Dropdown options not yet provided. Paste screenshots of each expanded drop-down to populate. -->
```

Reference example:

```
Example - Multiple-Drop-Down.md
```

---

## Image Replacement Appendices (Mode 1 Only)

### Screenshot Block (Collapsed)

Include **all selected `<img>` lines** inside one block.

```html
<details>
<summary>📸 Click to expand screenshot</summary>

<img src="<path>" width=700>

</details>
```

Rules:

* Preserve original `src`.
* Keep existing width if present; otherwise normalize to `width=700`.
* Maintain original image order.

---

### Explanation Placeholder (Empty)

```html
<details open>
<summary>💡 Click to expand explanation</summary>

</details>
```

Must remain completely empty.

---

### Related Lab Line

```markdown
▶ Related Lab: []()
```

Always included in Image Replacement mode.

---

## Rules

### Both Modes

* Extract content **ONLY from images attached in chat**.
* Preserve exact wording.
* Do not infer answers.
* Use:
  * ☐ for Yes/No tables
  * ○ for dropdown options
* Do not add formatting beyond defined templates.
* Number dropdown placeholders sequentially.

---

### Image Replacement Mode Only

* Replace **only** the selected `<img>` line(s).
* Preserve indentation of the selection.
* `oldString` must exactly match selected text (including whitespace).

---

### Extract Only Mode

Before responding, verify output contains NONE of:

* `<details>`
* `<summary>`
* Explanation Placeholder
* `▶ Related Lab:` line

If any appear, remove them before sending output.
