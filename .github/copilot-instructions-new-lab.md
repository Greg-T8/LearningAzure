# GitHub Copilot Instructions: Creating New Labs

Use these instructions when creating new lab exercises for the LearningAzure repository.

---

## Lab Structure Requirements

### Directory Organization

Create labs with the following structure:

```text
{EXAM-CODE}/labs/lab{##}-{descriptive-name}/
├── Lab{##}_{Title-With-Hyphens}.md
├── images/
├── README.md (optional for complex labs)
├── bicep/ (if applicable)
├── cli/ (if applicable)
├── powershell/ (if applicable)
├── terraform/ (if applicable)
├── datasets/ (for AI/ML labs if applicable)
├── sample-images/ (for Computer Vision labs if applicable)
├── sample-text/ (for NLP labs if applicable)
└── prompts/ (for Generative AI labs if applicable)
```

### File Naming Conventions

- **Lab markdown file:** `Lab{##}_{Title-With-Hyphens}.md`
  - Example: `Lab01_Setup-Identity-Baseline.md`
  - Example: `Lab02_Machine-Learning-Fundamentals.md`
- **Directory name:** `lab{##}-{descriptive-name-lowercase}`
  - Example: `lab01-setup-identity-baseline`
  - Example: `lab02-machine-learning-fundamentals`
- **Images:** Store in `images/` subdirectory with descriptive names
- **Code samples:** Organize by tool/language (bicep/, cli/, powershell/, terraform/)

---

## Lab Document Structure

### Required Sections (in order)

1. **Title and Metadata**
   ```markdown
   # Lab {##}: {Title}
   
   **Duration:** {X–Y minutes}  
   **Difficulty:** {Beginner | Intermediate | Advanced}
   **Domain:** {exam domain if applicable}
   **Dependencies:** {prerequisite labs or requirements}
   ```

2. **Table of Contents** (for longer labs)
   ```markdown
   <!-- omit in toc -->
   ## 🧾 Contents
   
   * [section links]
   ```

3. **🎯 Objectives**
   - Use bullet points starting with "By the end of this lab, you will be able to:"
   - List 3-6 specific, measurable learning outcomes
   - Use action verbs (create, configure, understand, implement, etc.)

4. **📋 Prerequisites**
   - Azure subscription requirements
   - Prior lab completion requirements
   - Required knowledge or tools
   - Access requirements (permissions, licenses, etc.)

5. **🧱 Skills Measured** (for exam-focused labs)
   - List specific exam objectives covered
   - Reference official exam outline

6. **🧠 Scenario** (optional but recommended)
   - Provide real-world context for the lab
   - Explain the business problem being solved

7. **⚙️ Environment Setup** (if needed)
   - Initial setup steps
   - Resource creation prerequisites

8. **🧪 Lab Exercises** (main content)
   - Number exercises sequentially
   - Use clear exercise titles with objectives
   - Include step-by-step instructions
   - Provide multiple implementation methods where applicable (Portal, CLI, PowerShell, Bicep, Terraform)
   - Add screenshots with `<img src='images/filename.png' width=700>`
   - Include verification steps after each major task
   - Add "Exam Insights" sections for exam-focused content

9. **🧭 Reflection & Readiness** (for exam labs)
   - Review questions
   - Key takeaways
   - Common pitfalls

10. **📚 References**
    - Microsoft Learn modules
    - Microsoft documentation links
    - Related resources

---

## Content Guidelines

### Microsoft Learn Module References

**CRITICAL:** In the lab exercises, reference as many applicable Microsoft Learn modules as possible.

- Link to specific Microsoft Learn modules relevant to each exercise
- Format: `[Module Title](https://learn.microsoft.com/training/modules/...)`
- Include modules for:
  - Conceptual understanding
  - Step-by-step procedures
  - Best practices
  - Related technologies
- Add a dedicated "📚 References" section at the end with all Microsoft Learn modules cited

### Writing Style

- Use clear, concise language
- Write in second person ("you will," "you can")
- Use active voice
- Break complex tasks into smaller steps
- Number sequential steps (1., 2., 3.)
- Use bullet points for non-sequential items

### Code Samples

- Provide working, tested code examples
- Include comments explaining key parameters
- Show both imperative and declarative approaches where applicable
- Format with proper syntax highlighting:
  ````markdown
  ```powershell
  # PowerShell example
  ```
  
  ```bash
  # Azure CLI example
  ```
  
  ```bicep
  // Bicep example
  ```
  
  ```hcl
  # Terraform example
  ```
  ````

### Visual Elements

- Use emojis for section headers (🎯, 📋, 🧪, 🔹, etc.) for visual clarity
- Include screenshots for:
  - Azure Portal navigation steps
  - Complex configurations
  - Expected outputs
  - Validation results
- Keep images at consistent width (typically 700px for readability)
- Use descriptive alt text for accessibility

### Exam-Specific Content

For certification exam labs (AI-900, AZ-104, etc.):

- Include "**Exam Insights**" callouts after relevant exercises
- Highlight common exam scenarios
- Explain the "why" behind configurations
- Note feature differences across license tiers or service tiers
- Include comparison tables where helpful
- Add real-world context for exam questions

### Best Practices and Tips

- Use callout boxes for important notes:
  ```markdown
  > **Note:** Important information here
  
  > **Warning:** Critical caution here
  
  > **Tip:** Helpful suggestion here
  ```
- Include troubleshooting sections for common issues
- Provide cleanup instructions at the end if resources were created
- Add estimated time for each exercise
- Include validation/verification steps

---

## Quality Checklist

Before finalizing a new lab, verify:

- [ ] All sections follow the required structure
- [ ] Microsoft Learn modules are referenced throughout
- [ ] Code samples are tested and working
- [ ] Screenshots are clear and properly sized
- [ ] All links are valid and working
- [ ] File and directory naming conventions are followed
- [ ] Images are stored in the `images/` subdirectory
- [ ] Code samples are organized by tool type
- [ ] Prerequisites are clearly stated
- [ ] Objectives are specific and measurable
- [ ] Each exercise has a clear objective
- [ ] Verification steps are included after major tasks
- [ ] Cleanup instructions are provided if needed
- [ ] Duration estimate is realistic
- [ ] Difficulty level is appropriate
- [ ] Table of contents is generated (for long labs)

---

## Example Templates

### AI-900 Lab Template

```markdown
# Lab {##}: {Title}

**Duration:** 60–90 minutes  
**Difficulty:** Beginner to Intermediate

---

## 🎯 Objectives

By the end of this lab, you will be able to:

- [Objective 1]
- [Objective 2]
- [Objective 3]

---

## 📋 Prerequisites

- Azure subscription with access to [required services]
- Completion of Lab {##} (recommended)
- [Other prerequisites]

---

## 🧪 Lab Exercises

### Exercise 1: {Exercise Title}

**Objective:** {Clear statement of what this exercise accomplishes}

{Exercise content with Microsoft Learn references}

---

## 📚 References

- [Microsoft Learn Module Title](URL)
- [Azure Documentation](URL)
```

### AZ-104 Lab Template

```markdown
# Lab {##} – {Title}

**Domain:** {Exam domain area}  
**Difficulty:** {Level} (≈{X–Y} hrs)  
**Dependencies:** {Prerequisites or "None"}

---

<!-- omit in toc -->
## 🧾 Contents

* [section links]

## 🎯 Lab Objective

{Overall goal statement}

You will:
* {Task 1}
* {Task 2}
* {Task 3}

---

## 🧱 Skills Measured (Exam Outline)

* {Exam objective 1}
* {Exam objective 2}

---

## 🧠 Scenario

{Real-world context and business problem}

---

## ⚙️ Environment Setup

{Initial setup requirements}

---

## 🔹 Exercise 1 – {Exercise Title}

{Exercise content with multiple implementation methods}

### Using Azure Portal

{Portal steps}

### Using `Az` CLI

{CLI commands with explanations}

### Using PowerShell

{PowerShell commands with explanations}

### Using Bicep

{Bicep template}

### Using Terraform

{Terraform configuration}

### Exam Insights

{Exam-specific guidance}

---

## 🧭 Reflection & Readiness

{Review questions and key takeaways}

---

## 📚 References

- [Microsoft Learn Module](URL)
- [Microsoft Documentation](URL)
```

---

## Additional Resources

- Review existing labs in the repository for consistent style and formatting
- Consult Microsoft Learn for official training content alignment
- Test all commands and code samples before publishing
- Use consistent terminology with Microsoft documentation
- Keep language accessible for the target skill level

---

**Remember:** The goal is to create engaging, practical, hands-on labs that prepare learners for real-world Azure scenarios and certification exams while heavily leveraging Microsoft Learn as the authoritative source of knowledge.
