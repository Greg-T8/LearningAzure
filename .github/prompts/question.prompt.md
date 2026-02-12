---
name: question
description: Generates a title + question text and wraps the screenshot image in a <details> block
---

# **Inline Chat Instructions (Single Screenshot, Structured Questions)**

**Goal:**
When an image is pasted into chat, analyze it and generate structured, exam-style output. The screenshot must appear **only once**, inside a collapsible section.

---

## **Required Behavior**

1. **Analyze the image pasted into chat** (this image is the only source of truth).
2. **Extract all visible content** (prompt text, instructions, tables, labels).
3. **Generate output strictly from what is visible in the image**.
4. **Re-emit the image exactly once**, inside the screenshot `<details>` block.
5. **Do not include the original inline image outside the `<details>` block.**

---

## **Output Format (exact order, no extra text)**

### **1. Title**

```
### <Concise Title>
```

* 3–10 words
* Title Case
* ≤60 characters
* Neutral, exam-appropriate

---

### **2. Question Prompt**

* Transcribe the full prompt exactly as shown
* Preserve paragraph breaks
* Do **not** add interpretation or explanation

---

### **3. Question Structure**

#### **A. Yes / No Statements**

If the question evaluates multiple statements as **Yes / No**, format as:

```markdown
| Statement | Yes | No |
|----------|-----|----|
| <Statement text exactly as shown> | ☐ | ☐ |
| <Statement text exactly as shown> | ☐ | ☐ |
| <Statement text exactly as shown> | ☐ | ☐ |
```

Rules:

* One row per statement
* Use ☐ (unchecked boxes)
* Do not preselect answers
* Preserve wording exactly

#### **B. Multiple Choice**

If the question uses labeled options (A, B, C, D):

* One choice per line
* Preserve labels and wording
* Add **two spaces at the end of each line**

---

### **4. Screenshot (collapsed — only image allowed)**

```html
<details>
<summary>📸 Click to expand screenshot</summary>

<img src="[RE-EMIT PASTED CHAT IMAGE]" width=700>

</details>
```

---

### **5. Explanation Placeholder (open, empty)**

```html
<details open>
<summary>💡 Click to expand explanation</summary>

</details>
```

* Leave completely empty
* Do not add content of any kind

---

### **6. Related Lab Line**

Immediately below the explanation `</details>` tag, add **exactly**:

```
▶ Related Lab: []()
```

Rules:

* Always include the line
* Do not insert or guess a link
* Leave `<insert link>` unchanged for manual completion

---

## **Strict Rules**

* Use **only** what is visible in the pasted image
* Do **not** infer, solve, or explain
* Do **not** repeat or leave the original inline image
* Do **not** add extra headings or commentary
* If no image is visible:

  ```
  ERROR: No image pasted to analyze.
  ```

* If the image content is ambiguous:

  ```
  UNCLEAR: Need more context or a clearer image.
  ```

---
