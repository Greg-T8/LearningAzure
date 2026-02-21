---
name: lab-question-extractor
description: "Extract exam questions from screenshot images or text and return structured title/prompt/answer markdown. Used by Lab Orchestrator workflows."
user-invokable: false
---

# Lab Question Extractor

Extracts exam question content from screenshot images or text and returns structured markdown (title, prompt, answer only). Used by the Lab Orchestrator and Lab-Intake agent for lab creation workflows.

---

## Critical Vision Requirement

Text extraction **must always come from screenshot image(s) attached or pasted into the current chat**.

If an image is not attached in the active chat context, image extraction cannot occur. If the question is provided as text, parse it directly.

---

## Output

Return **only**:

- Title
- Prompt
- Answer

Do **not** include screenshot blocks, explanation placeholders, or related lab lines.

---

## Process

1. Extract all visible text from attached screenshot image(s) or parse provided text.
2. Identify question type:
   - Yes / No
   - Multiple Choice
   - Multiple Drop-Down
3. Format Title, Prompt, and Answer.
4. Return markdown output directly.

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
* If the question contains a PowerShell command or script, enclose it in a fenced code block tagged `powershell`.
* Long PowerShell commands over 80 characters may wrap using backticks:

```
Get-AzSomething `
    -Parameter value `
    -Another value
```

#### Cohesion — Prevent Visual Segmentation

The title, scenario text, code block (if any), and answer options must render as **one continuous question** — not as separate visual fragments.

* **Do not** wrap the question output in horizontal-rule (`---`) delimiters. Horizontal rules create hard visual breaks that segment the question when rendered.
* **Do not** insert extra headings, horizontal rules, or blank separator lines between the scenario text, the code block, and the answer options (regardless of question type).
* The only horizontal rule allowed is a single `---` followed by two blank lines **after** the answer options to separate the question from any metadata that follows.

---

### Answer Section

Choose format based on detected question type.

> **Important:** After all answer options, add a single horizontal rule (`---`) followed by two blank lines to segment the answers from any metadata that follows.

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

> **Cohesion reminder:** When a code block contains dropdown placeholders, output the scenario text → code block → dropdown options as one continuous flow with no horizontal rules or extra headings between them. The dropdown options list is part of the same question and must directly follow the code block.

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
