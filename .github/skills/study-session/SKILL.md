---
name: study-session
description: "Start or stop a certification study session by invoking Invoke-StudySession from .assets/scripts/Invoke-StudySession.ps1. Parses natural language to extract parameters and prompts for any that are missing. Use when asked to begin/start/stop a study session, start studying, track study time, or log study activity."
user-invokable: true
argument-hint: "[e.g. 'Begin AZ-305 study session, Research']"
---

# Study Session

Invoke `Invoke-StudySession` to start or stop a certification study session. Parse the user's natural language request to extract parameters and interactively prompt for any required values that are missing or ambiguous.

## When to Use

- Starting a new study session (e.g., "Begin AZ-305 study session, Research")
- Stopping the current study session (e.g., "Stop studying", "End study session")
- Any request involving study session tracking or logging study time

## Script Location

```
.assets/scripts/Invoke-StudySession.ps1
```

Run from the workspace root (`c:\Users\gregt\LocalCode\Learning\LearningAzure`).

## Parameters

| Parameter | Type   | Required                     | Default | Description |
| --------- | ------ | ---------------------------- | ------- | ----------- |
| `Action`  | String | No                           | Start   | `Start` or `Stop` |
| `Exam`    | String | Yes (Start); optional (Stop) | —       | Exam code or applied-skill topic (e.g., `AZ-305`, `AMBA`) |
| `Mode`    | String | Yes (Start)                  | —       | Study mode (see table below) |
| `Task`    | String | No                           | —       | Task value from `Skills.psd1` (mutually exclusive with `Domain` and `Skill`) |
| `Domain`  | String | No                           | —       | Domain name from `Skills.psd1` (mutually exclusive with `Task` and `Skill`) |
| `Skill`   | String | No                           | —       | Skill name from `Skills.psd1` (mutually exclusive with `Task` and `Domain`) |
| `Notes`   | String | No                           | —       | Free-text session notes |

Scope values are optional, but when provided only one of `Task`, `Domain`, or `Skill` may be supplied.

### Mode Values and Natural Language Aliases

| Mode       | Aliases (case-insensitive) |
| ---------- | -------------------------- |
| `Prepare`  | prepare, prep, setup, planning |
| `Research` | research, study, docs, reading |
| `Practice` | practice, hands-on, lab, drill |
| `Review`   | review, recap, revise |

### Action Aliases

| Action  | Aliases (case-insensitive)              |
| ------- | --------------------------------------- |
| `Start` | start, begin, open, new                 |
| `Stop`  | stop, end, finish, done, close, wrap up |

## Procedure

### Step 1 — Parse the User's Request

Extract as many parameters as possible from the natural language input:

1. **Action**: Look for action keywords. Default to `Start` if no action word is found but study context is clear.
2. **Exam**: Look for exam codes like `AZ-305`, `AI-102`, `AZ-104`, `AI-103`, `AI-900`, or applied-skill topics like `AMBA`.
3. **Mode**: Match against the alias table above. Map to the canonical value.
4. **Scope**: Capture only one optional scope field (`Task`, `Domain`, or `Skill`).
5. **Notes**: Any remaining descriptive text that doesn't map to other parameters.

### Step 2 — Prompt for Missing Required Parameters

For a **Start** action, both `Exam` and `Mode` are required.

**If Exam is missing**, use `vscode_askQuestions` to ask:

- Present active exams as options. Active exams can be discovered by running:

  ```powershell
  & .assets/scripts/Get-ActiveExam.ps1
  ```

**If Mode is missing**, use `vscode_askQuestions` to ask:

- Present the four mode values as options: `Prepare`, `Research`, `Practice`, `Review`.

**Scope is optional.** Determine whether a scope prompt is needed and which scope type is valid:

- Resolve the study log path for the chosen exam/topic.
- Use `applied-skills/<Exam>/StudyLog.md` if it exists.
- Otherwise use `certs/<Exam>/StudyLog.md`.
- Read the table header row (`| # | ... |`) and detect which scope column exists: `Task`, `Skill`, or `Domain`.
- Enforce header match.
- `Task` header -> only `-Task` is allowed.
- `Skill` header -> only `-Skill` is allowed.
- `Domain` header -> only `-Domain` is allowed.

If no scope value was supplied by the user, offer an optional picker for the detected scope type:

- For `Task`: parse `Domains[].Skills[].Tasks` from `Skills.psd1`.
- For `Skill`: parse `Domains[].Skills[].Name` from `Skills.psd1`.
- For `Domain`: parse `Domains[].Name` from `Skills.psd1`.

Include a `Skip` option so the session can start with no scope value.

If the user supplies more than one of `Task`, `Domain`, and `Skill`, ask them to pick exactly one before execution.

Validate supplied scope values against `Skills.psd1` with exact (case-insensitive) matching.

For a **Stop** action, no additional parameters are strictly required (the script auto-detects the active session). If `Exam` is provided, pass it through. Optionally ask for `Notes`.

Ask all missing parameters in a **single** `vscode_askQuestions` call when possible.

### Step 3 — Execute the Command

Build and run the PowerShell command:

```powershell
if (-not (Get-Command -Name 'Invoke-StudySession' -ErrorAction SilentlyContinue)) {
  . .assets/scripts/Invoke-StudySession.ps1
}

Invoke-StudySession -Action <Action> -Exam <Exam> [-Mode <Mode>] [-Task '<Task>'] [-Domain '<Domain>'] [-Skill '<Skill>'] [-Notes '<Notes>']
```

- Quote `-Task`, `-Domain`, and `-Skill` values when they contain spaces.
- Quote the `-Notes` value if provided.
- Run from the workspace root directory.

### Step 4 — Report the Result

- If the command succeeds, confirm the action briefly (e.g., "Study session #12 started for AZ-305").
- If the command fails, show the error and suggest corrective action.

## Examples

### Example 1: Full input

> "Begin AZ-305 study session, Research, Recommend a logging solution"

Parsed: Action=Start, Exam=AZ-305, Mode=Research, Task=Recommend a logging solution

```powershell
Invoke-StudySession -Action Start -Exam AZ-305 -Mode Research -Task 'Recommend a logging solution'
```

### Example 2: Partial input

> "Start studying AMBA"

Parsed: Action=Start, Exam=AMBA, Mode=?, Domain=?

→ Prompt for Mode and optional Domain based on the AMBA StudyLog header. The Domain picker is sourced from `applied-skills/AMBA/Skills.psd1`. A `Skip` option allows starting without a scope value.

### Example 3: Stop session

> "End study session"

Parsed: Action=Stop

```powershell
Invoke-StudySession -Action Stop
```
