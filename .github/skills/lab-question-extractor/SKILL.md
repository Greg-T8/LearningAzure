---
name: lab-question-extractor
description: "Extract exam questions from screenshot images or text and return structured title/prompt/answer markdown. Used by Lab Orchestrator workflows."
user-invokable: true
---

# Lab Question Extractor

Extracts exam question content from screenshot images or text and returns structured markdown (title, prompt, answer only). Used by the Lab Orchestrator agent for lab creation workflows.

---

## Critical Vision Requirement

Text extraction **must always come from screenshot image(s) attached or pasted into the current chat**.

If an image is not attached in the active chat context, image extraction cannot occur. If the question is provided as text, parse it directly.

---

## Critical Rule — No Answer Reasoning

Your **only** job is to reproduce the question exactly as stated with full fidelity.

- Do **not** evaluate, filter, or select correct answers.
- Do **not** reason about which options are right or wrong.
- Reproduce **every** answer option exactly as shown in the source — no omissions, no reordering, no commentary.

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
   - Drag-and-Drop Sequencing
   - Case Study (Solution Evaluation)
   - Drag-and-Drop Matching
3. Format Title, Prompt, and Answer.
4. Return markdown output directly.

---

## Output Structure

### Title

Create a concise exam-appropriate title (3–10 words).

Immediately below the title, render the detected question type in italics.

```markdown
### <Title Extracted From Image>

*<Question Type>*
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

* Replace each dropdown with a numbered blank token in this exact style:

```
___[1]___
___[2]___
```

* In tables, preserve layout and replace each dropdown cell with the matching blank token:

```markdown
| Column | Setting |
|--------|---------|
| Item A | ___[1]___ |
| Item B | ___[2]___ |
```

* Inline dropdowns remain inline and use the same blank token style.

**Answer Format:**  

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

## Output Formatting

Apply the following formatting rules to the entire response.

### Title

Render the question title as a markdown level 3 header:

```markdown
### <Title>
```

### Response Wrapper

Surround the entire response with horizontal rule lines. Include two blank lines before and after each horizontal rule:

```markdown

---


### <Title>

*<Question Type>*

<Prompt>

<Answer>


---

```
