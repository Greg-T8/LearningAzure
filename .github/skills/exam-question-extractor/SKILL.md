---
name: exam-question-extractor
description: "Extract exam questions from pasted screenshot images and format them as structured markdown. Replaces selected img tag(s) in a markdown file with the fully formatted question."
user-invokable: true
argument-hint: "[image attachment and/or selection]"
---

# Question Formatter

Extracts exam question content from screenshot images and formats it as structured markdown for practice exam files.

---

## ⛔ MANDATORY — Single-Edit Scope (Read First)

This is the highest-priority rule. It overrides all other formatting instincts.

**You must make exactly ONE edit to the file.** That single edit replaces the selected `<img>` tag line(s) — and nothing else.

### Prohibited actions

- Do **not** touch, reformat, rewrite, or insert content on any other line in the file.
- Do **not** fix typos, adjust whitespace, normalize headings, or "clean up" existing questions.
- Do **not** modify any text above or below the selected line(s).
- Do **not** make multiple edits or batch unrelated changes.

### How to construct the edit

- **`oldString`** = the exact `<img …>` line(s) currently selected — copy them verbatim, nothing more.
- **`newString`** = the fully formatted question output (Title → Exam Metadata → Prompt → Answer → Screenshot Block → Explanation Placeholder → Related Lab Line).
- If the edit tool requires surrounding context lines for uniqueness, include the minimum necessary context but do **not** alter those context lines in `newString`.

> **Self-check before submitting:** Does your edit change anything outside the selected `<img>` line(s)? If yes, discard and redo.

---

## Critical Vision Requirement

Text extraction **must always come from screenshot image(s) attached or pasted into the current chat**.

If an image is not attached in the active chat context, image extraction cannot occur.

---

## Critical Rule — No Answer Reasoning

Your **only** job is to reproduce the question exactly as stated with full fidelity.

- Do **not** evaluate, filter, or select correct answers.
- Do **not** reason about which options are right or wrong.
- Reproduce **every** answer option exactly as shown in the source — no omissions, no reordering, no commentary.

---

## Output

Include:

- Title  
- Exam Metadata (Domain / Skill / Task)  
- Prompt  
- Answer  
- Screenshot Block  
- Explanation Placeholder  
- Related Lab Line

## Action

Make a **single** edit that replaces the selected `<img>` line(s) with the fully formatted question markdown. Do not modify any other line in the file. Re-read the **Single-Edit Scope** rule above before executing.

---

## Process

1. From the attached screenshot image(s), extract all visible text.
2. **Detect answer state:** Inspect the screenshot for signs that the question has already been submitted and graded — for example, a selected answer highlighted in green or red, a ✓ / ✗ icon, or an "Correct" / "Incorrect" banner. Mark the question as **answered** if any such indicator is present; otherwise mark it as **blank**.
3. **Identify exam metadata:** Determine the practice-exam file's parent exam (e.g., AZ-104, AI-102, AI-900). Read the corresponding exam README (e.g., `AZ-104/README.md`) to locate the domain/skill/task hierarchy. Match the question to the most specific domain, skill, and task(s) using best-effort reasoning.
4. Identify question type:
   - Yes / No
   - Multiple Choice
   - Multiple Drop-Down
   - Drag-and-Drop Sequencing
   - Case Study (Solution Evaluation)
   - Drag-and-Drop Matching
5. Format Title, Exam Metadata, Prompt, and Answer.
6. Append Screenshot Block.
7. Append Explanation Placeholder (see rule below).
8. Append Related Lab Line.
9. Replace **only** the selected `<img>` line(s) with the assembled output. Make exactly one edit. Do not touch any other part of the file.

### Explanation Block Rule

- If the question is **blank** (no answer selected), append the empty explanation placeholder.
- If the question is **answered** (correct or incorrect indicator visible), invoke the **exam-question-explainer** skill using the same screenshot(s) to generate the explanation, then insert that explanation inside the `<details>` block instead of leaving it empty.

---

## Output Structure

### Title

Create a concise exam-appropriate title (3–10 words).

```markdown
#### <Title Extracted From Image>
```

---

### Exam Metadata

Identify the question's domain, skill, and task(s) from the exam's README coverage table. Place this block immediately after the title, before the prompt text.

```markdown
**Domain:** <domain name (omit weight)>
**Skill:** <skill name>
**Task:** <task>
```

Rules:

* **Source of truth:** Read the exam's README (e.g., `AZ-104/README.md`) and use its domain → skill → task hierarchy. Domain names are the `### Domain N: …` headings (omit the weight percentage). Skill names are the `####` sub-headings. Tasks are the table rows under each skill.
* Use exact wording from the README for domain and skill names.
* For tasks, use the most specific task wording. Apply best-effort reasoning when the question spans topics — pick the closest match(es).
* If a question maps to a single task, place it inline on the header line: `**Task:** <task>`.
* If a question maps to multiple tasks (even across different skills), use a header plus bullets:

    `**Task:**`

    `- <task 1>`

    `- <task 2>`
* Insert a blank line after the metadata block before the prompt text begins.

Example:

```markdown
**Domain:** Manage Azure Identities and Governance
**Skill:** Manage Azure subscriptions and governance
**Task:** Apply and manage tags on resources
```

```markdown
**Domain:** Manage Azure Identities and Governance
**Skill:** Manage Azure subscriptions and governance
**Task:**
- Apply and manage tags on resources
- Manage costs by using alerts, budgets, and Azure Advisor recommendations
```

---

### Prompt

Transcribe the question exactly as shown.

Rules:

* Preserve wording and paragraph breaks.
* Maintain layout fidelity.
* If the prompt contains a PowerShell script or command block, enclose it in a fenced code block with `powershell` syntax:

````markdown
```powershell
Get-AzSomething -Parameter value
```
````

* Long PowerShell commands over 80 characters may wrap using backticks:

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

> **Cohesion reminder:** When a code block contains blank placeholders, output the scenario text → code block → options table as one continuous flow with no horizontal rules or extra headings between them. The options table is part of the same question and must directly follow the code block.

* Replace each dropdown with a numbered blank token in this exact style:

```
___[1]___
___[2]___
```

* Preserve tables if present and replace each dropdown cell with the matching blank token:

```markdown
| Column | Setting |
|--------|---------|
| Item A | ___[1]___ |
| Item B | ___[2]___ |
```

* Inline dropdowns remain inline and use the same blank token style.

##### Answer Format

If dropdown option screenshots exist, list choices in a single table exactly like this:

```markdown
Drop-Down Options:

| Blank | Options |
|-------|---------|
| [1] | Option A / Option B / Option C |
| [2] | Option A / Option B / Option C |
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

#### Type 4 — Drag-and-Drop Sequencing (Ordering)

Used when the UI shows **Available options** and **Selected options** panels, and the question asks the user to select and arrange actions **in sequence** or **in the correct order**.

* List all available options with letter labels.
* Include an ordering table with the number of steps the question requires.

**Prompt format:**

Transcribe the scenario text exactly, then list every available option:

```markdown
A. <Option text>  
B. <Option text>  
C. <Option text>  
D. <Option text>  
E. <Option text>  
```

(two trailing spaces per line required)

**Answer format:**

```markdown
Select and order <N>:

| Step | Action |
|------|--------|
| 1 | |
| 2 | |
| 3 | |
```

Replace `<N>` with the number of actions to select (e.g., "Select and order 3"). Add or remove rows to match the required count.

---

#### Type 5 — Case Study (Solution Evaluation)

Used when the UI shows a **Case Study** with a **Solution Evaluation** section. Multiple screenshots are provided — one per sub-question — each presenting the same scenario with a different proposed solution and asking **"Does this meet the goal?"**

Key indicators:

* "Case Study" header in the UI.
* "Solution Evaluation" section label.
* Instructions stating the case study contains a series of questions that present the same scenario.
* Each sub-question shares the same scenario but proposes a unique solution.
* Binary Yes / No answer per sub-question.

**Prompt format:**

State the case study preamble once, then transcribe the shared scenario exactly. Do **not** repeat the scenario for each sub-question.

```markdown
*Case Study — Solution Evaluation*

This case study contains a series of questions that present the same scenario. Each question in the series contains a unique solution that might meet the stated goals. Some question sets might have more than one correct solution, while others might not have a correct solution.

<Shared scenario text>

Does this meet the goal?
```

**Answer format:**

List each solution in the order the sub-questions appear (one row per screenshot):

```markdown
| Solution | Yes | No |
|----------|-----|----|
| 1. <Solution text from Question 1> | ☐ | ☐ |
| 2. <Solution text from Question 2> | ☐ | ☐ |
| 3. <Solution text from Question 3> | ☐ | ☐ |
```

Add or remove rows to match the number of sub-questions provided.

---

#### Type 6 — Drag-and-Drop Matching (Mapping)

Used when the UI shows **Available options** at the bottom and a list of **descriptions or scenarios** each paired with an empty drop target. The question asks the user to **match** (map) each description to the correct option. Unlike Type 4, there is no sequencing — each description independently maps to one option.

Key indicators:

* "Available options" panel with named options (not numbered steps).
* A list of descriptions, each with a blank target box.
* Instructions stating an option **may be used once, more than once, or not at all**.

**Prompt format:**

Transcribe the scenario text exactly, then present the descriptions and available options.

```markdown
| Description | Answer |
|-------------|--------|
| <Description 1> | |
| <Description 2> | |
| <Description 3> | |
```

Available options:

```markdown
Available Options:

- Option A
- Option B
- Option C
```

Add or remove rows/options to match the question.

---

## Appendices

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

### Explanation Placeholder (Open)

```html
<details open>
<summary>💡 Click to expand explanation</summary>

</details>
```

**Blank questions:** Leave the block completely empty (no content between the tags).

**Answered questions:** Invoke the **exam-question-explainer** skill with the same screenshot(s) and insert its output between the opening and closing tags. Do not leave the block empty when an answer state is detected.

---

### Related Lab Line

```markdown
▶ Related Lab: []()
```
