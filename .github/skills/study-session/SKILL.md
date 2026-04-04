---
name: study-session
description: "Start, stop, or end a certification study session by invoking Invoke-AzStudySession.ps1. Parses natural language to extract parameters and prompts for any that are missing. Use when asked to begin/start/stop/end a study session, start studying, track study time, or log study activity."
user-invokable: true
argument-hint: "[e.g. 'Begin AZ-305 study session, deep research']"
---

# Study Session

Invoke `Invoke-AzStudySession.ps1` to start, stop, or end a certification study session. Parse the user's natural language request to extract parameters and interactively prompt for any required values that are missing or ambiguous.

## When to Use

- Starting a new study session (e.g., "Begin AZ-305 study session, deep research")
- Stopping or ending the current study session (e.g., "End study session", "Stop studying")
- Any request involving study session tracking or logging study time

## Script Location

```
.assets/scripts/Invoke-AzStudySession.ps1
```

The script must be invoked from the workspace root (`c:\Users\gregt\LocalCode\Learning\LearningAzure`).

## Parameters

| Parameter | Type       | Required                                  | Default | Description                              |
| --------- | ---------- | ----------------------------------------- | ------- | ---------------------------------------- |
| `Action`  | String     | No                                        | Start   | `Start`, `Stop`, or `End`                |
| `Exam`    | String     | Yes (Start); optional (Stop/End)          | —       | Exam code (e.g., `AZ-305`, `AI-102`)     |
| `Mode`    | String     | Yes (Start, non-WorkflowDevelopment)      | —       | Study mode (see table below)             |
| `Skill`   | String     | Yes (Start, non-WorkflowDevelopment)      | —       | Skill name from the exam's Skills.psd1   |
| `Notes`   | String     | No                                        | —       | Free-text session notes                  |

### Mode Values and Natural Language Aliases

| Mode                    | Aliases (case-insensitive)                                        |
| ----------------------- | ----------------------------------------------------------------- |
| `PracticeQuestion`      | practice question, practice, quiz, questions                      |
| `MSLearn`               | ms learn, mslearn, learning path, learn, module                   |
| `DeepResearch`          | deep research, research, deep learning, deep dive                 |
| `Lab`                   | lab, hands-on, hands on, hands on lab                             |
| `WorkflowDevelopment`   | workflow, workflow development, dev, tooling                      |

### Action Aliases

| Action  | Aliases (case-insensitive)                       |
| ------- | ------------------------------------------------ |
| `Start` | start, begin, open, new                          |
| `Stop`  | stop, end, finish, done, close, wrap up          |

## Procedure

### Step 1 — Parse the User's Request

Extract as many parameters as possible from the natural language input:

1. **Action**: Look for action keywords. Default to `Start` if no action word is found but study context is clear.
2. **Exam**: Look for exam codes like `AZ-305`, `AI-102`, `AZ-104`, `AI-103`, `AI-900`. Also accept `WorkflowDevelopment` or aliases.
3. **Mode**: Match against the alias table above. Map to the canonical value.
4. **Skill**: If the user provides a skill name or partial match, capture it. This will be validated in Step 2.
5. **Notes**: Any remaining descriptive text that doesn't map to other parameters.

### Step 2 — Prompt for Missing Required Parameters

For a **Start** action on a non-WorkflowDevelopment exam, all of `Exam`, `Mode`, and `Skill` are required.

**If Exam is missing**, use `vscode_askQuestions` to ask:

- Present active exams as options. Active exams can be discovered by running:

  ```powershell
  & .assets/scripts/Get-ActiveExam.ps1
  ```

  Also include `WorkflowDevelopment` as an option.

**If Mode is missing** (and Exam is not `WorkflowDevelopment`), use `vscode_askQuestions` to ask:

- Present the five mode values as options: `PracticeQuestion`, `MSLearn`, `DeepResearch`, `Lab`, `WorkflowDevelopment`.

**If Skill is missing** (and Exam is not `WorkflowDevelopment`):

1. **Recommend from StudyLog** — Read the exam's study log at `certs/<Exam>/StudyLog.md`. Find the first data row (the most recent session) and extract the value from the **Skill** column. This is the recommended skill.
2. **Load all valid skills** — Read `certs/<Exam>/Skills.psd1` and parse skill names from the `Domains[].Skills[].Name` hierarchy.
3. **Prompt with recommendation** — Use `vscode_askQuestions` to present the skill list as options. Mark the skill from the latest StudyLog entry as `recommended: true`. If the StudyLog is empty or the file does not exist, do not mark any option as recommended.

For a **Stop/End** action, no additional parameters are strictly required (the script auto-detects the active session). However, if `Exam` is provided, pass it through. Optionally ask for `Notes`.

Ask all missing parameters in a **single** `vscode_askQuestions` call when possible.

### Step 3 — Execute the Command

Build and run the PowerShell command:

```powershell
& .assets/scripts/Invoke-AzStudySession.ps1 -Action <Action> -Exam <Exam> [-Mode <Mode>] [-Skill '<Skill>'] [-Notes '<Notes>']
```

- Quote the `-Skill` value (skill names contain spaces).
- Quote the `-Notes` value if provided.
- Run from the workspace root directory.

### Step 4 — Report the Result

- If the command succeeds, confirm the action briefly (e.g., "Study session #12 started for AZ-305").
- If the command fails, show the error and suggest corrective action.

## Examples

### Example 1: Full input

> "Begin AZ-305 study session, deep research, Design governance"

Parsed: Action=Start, Exam=AZ-305, Mode=DeepResearch, Skill=Design governance

```powershell
& .assets/scripts/Invoke-AzStudySession.ps1 -Action Start -Exam AZ-305 -Mode DeepResearch -Skill 'Design governance'
```

### Example 2: Partial input

> "Start studying AZ-104"

Parsed: Action=Start, Exam=AZ-104, Mode=?, Skill=?

→ Prompt for Mode and Skill using `vscode_askQuestions`. The Skill picker reads the latest row from `certs/AZ-104/StudyLog.md` and marks that skill as the recommended default.

### Example 3: Stop session

> "End study session"

Parsed: Action=Stop

```powershell
& .assets/scripts/Invoke-AzStudySession.ps1 -Action Stop
```

### Example 4: WorkflowDevelopment

> "Start workflow development session"

Parsed: Action=Start, Exam=WorkflowDevelopment

```powershell
& .assets/scripts/Invoke-AzStudySession.ps1 -Action Start -Exam WorkflowDevelopment
```

No Mode or Skill required.
