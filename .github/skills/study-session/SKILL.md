---
name: study-session
description: "Start or stop a certification or Applied Skill study session by invoking Invoke-StudySession from .assets/scripts/Invoke-StudySession.ps1. Parses natural language, distinguishes exams from Applied Skills, and prompts for required values. Use when asked to begin/start/stop a study session, start studying, track study time, or log study activity."
user-invokable: true
argument-hint: "[e.g. 'Begin AZ-305 research' or 'Start studying ALZ']"
---

# Study Session

Invoke `Invoke-StudySession` to track a certification exam or Applied Skill session. Exams use structured modes and optional scope. Applied Skills use free-text notes without modes or scope.

## Script Location

```text
.assets/scripts/Invoke-StudySession.ps1
```

Run from the workspace root.

## Parameters

| Parameter | Availability | Required | Description |
|:----------|:-------------|:---------|:------------|
| `Action` | All parameter sets | No; defaults to `Start` | `Start` or `Stop` |
| `Exam` | Exam only | Exam Start | Active certification code such as `AZ-305` |
| `AppliedSkill` | Applied Skill only | Applied Skill Start | Topic folder such as `ALZ` or `AMBA` |
| `Mode` | Exam only | Exam Start | `Prepare`, `Research`, `Practice`, or `Review` |
| `Task` | Exam only | No | Task from the certification `Skills.psd1` |
| `Domain` | Exam only | No | Domain from the certification `Skills.psd1` |
| `Skill` | Exam only | No | Skill from the certification `Skills.psd1` |
| `Notes` | Both track types | No | Free-text session notes |

`Exam` and `AppliedSkill` are mutually exclusive. For exams, `Task`, `Domain`, and `Skill` are also mutually exclusive. `Mode` and all scope parameters are invalid with `AppliedSkill`.

### Mode Aliases for Exams

| Mode | Aliases |
|:-----|:--------|
| `Prepare` | prepare, prep, setup, planning |
| `Research` | research, study, docs, reading |
| `Practice` | practice, hands-on, lab, drill |
| `Review` | review, recap, revise |

### Action Aliases

| Action | Aliases |
|:-------|:--------|
| `Start` | start, begin, open, new |
| `Stop` | stop, end, finish, done, close, wrap up |

## Procedure

### 1. Parse the Request

1. Detect `Start` or `Stop`; default to `Start` when study intent is clear.
2. Determine whether the target is an Exam or Applied Skill.
3. Capture the matching identifier in `Exam` or `AppliedSkill`, never both.
4. For exams only, map a mode alias and capture at most one optional scope value.
5. Treat remaining descriptive text as `Notes`. For Applied Skills, exploration details always belong in `Notes`.

If the track type is missing or ambiguous, ask the user to choose Exam or Applied Skill before asking for an identifier.

### 2. Discover and Prompt for Missing Values

For exams, discover active options with:

```powershell
& .assets/scripts/Get-ActiveExam.ps1
```

An Exam Start requires `Exam` and `Mode`. Ask for all missing required values together. Scope is optional; detect the log's `Task`, `Skill`, or `Domain` column and, when useful, offer values from `certs/<Exam>/Skills.psd1` plus a Skip option. Validate supplied scope values exactly, case-insensitively.

For Applied Skills, discover folders containing a study log:

```powershell
Get-ChildItem applied-skills -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName 'StudyLog.md') } |
    Select-Object -ExpandProperty Name
```

An Applied Skill Start requires only `AppliedSkill`. Do not prompt for Mode or structured scope. Notes are optional and may be provided at Start, Stop, or both.

A Stop requires no identifier because the script can detect the active session. If the user names a target, pass it through using the correct parameter.

### 3. Execute

Load the function once when needed:

```powershell
if (-not (Get-Command -Name 'Invoke-StudySession' -ErrorAction SilentlyContinue)) {
  . .assets/scripts/Invoke-StudySession.ps1
}
```

Exam example:

```powershell
Invoke-StudySession -Action Start -Exam AZ-305 -Mode Research -Task 'Recommend a logging solution' -Notes 'Compare workspace designs'
```

Applied Skill example:

```powershell
Invoke-StudySession -Action Start -AppliedSkill ALZ -Notes 'Explore bootstrap subscription requirements'
```

Stop examples:

```powershell
Invoke-StudySession -Action Stop
Invoke-StudySession -Action Stop -AppliedSkill ALZ -Notes 'Continue with Terraform bootstrap next time'
```

Quote scope and Notes values when they contain spaces. Run commands from the workspace root.

### 4. Report the Result

Confirm the action and session number briefly. If execution fails, show the error and the corrective action.

## Behavioral Examples

- “Begin AZ-305 research on Recommend a logging solution” → Exam Start; parse Mode and Task.
- “Start studying ALZ and explore bootstrap permissions” → Applied Skill Start; put the exploration text in Notes and do not ask for Mode.
- “End study session” → Stop with automatic active-session detection.
- An identifier that exists as both an exam and an Applied Skill → ask which track type the user means.
