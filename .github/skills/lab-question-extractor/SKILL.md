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

---

## Metadata Extraction

After formatting the question, also extract and return these fields:

| Field          | How to Determine                                                                          |
| -------------- | ----------------------------------------------------------------------------------------- |
| exam           | From surrounding context, or infer: Azure admin topics → AZ-104, AI/ML topics → AI-102   |
| domain         | Map primary topic to Azure domain: Networking, Storage, Compute, Identity & Governance, Monitoring, Generative AI, Computer Vision, NLP, Knowledge Mining, Agentic |
| topic          | Create a hyphenated lowercase slug from the specific skill tested (e.g., `vnet-peering`, `blob-versioning`, `dalle-image-gen`) |
| correct_answer | Identify the correct option using Azure technical knowledge                               |
| key_services   | List all Azure services that must be deployed to demonstrate the concept                  |
