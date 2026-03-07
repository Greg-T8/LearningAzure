---
name: Start-StudySession
description: Start a study session and log the start time to the exam's StudyLog.md
---

# Start Study Session

Log the start or end of a study session for a certification exam.

## Instructions

Run the `Start-StudySession.ps1` script located in `.assets/scripts/` to update the exam's `StudyLog.md`.

Determine `action` from user input:

- If the user input includes `end` (for example: `end 104`, `end az-104`, `stop ai-102`), set `action` to `End`.
- Otherwise, set `action` to `Start`.

Determine `exam` from user input using these aliases:

- `AI-102` aliases: `ai-102`, `ai102`, `102`
- `AZ-104` aliases: `az-104`, `az104`, `104`

If the user specified an exam name, use it. Otherwise, ask:

> Which exam are you studying for?
>
> 1. **AI-102** — Azure AI Engineer Associate
> 2. **AZ-104** — Microsoft Azure Administrator

Once the exam is known, change to the scripts folder and run:

```powershell
Set-Location ".assets/scripts"
.\Start-StudySession.ps1 -Action "<action>" -ExamName "<exam>"
```

Replace `<action>` with `Start` or `End` and `<exam>` with `AI-102` or `AZ-104`.

Examples:

```text
end 104    => -Action "End"   -ExamName "AZ-104"
start 102  => -Action "Start" -ExamName "AI-102"
104        => -Action "Start" -ExamName "AZ-104"
```

## Variables

- `action` — Session action inferred from user input. Valid values: `Start`, `End`.
- `exam` — The exam name provided by the user or selected interactively. Valid values: `AI-102`, `AZ-104`.
