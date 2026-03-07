---
name: Start-StudySession
description: Start a study session and log the start time to the exam's StudyLog.md
---

# Start Study Session

Log the start of a study session for a certification exam.

## Instructions

Run the `Start-StudySession.ps1` script located in `.assets/scripts/` to append a new entry to the exam's `StudyLog.md`.

If the user specified an exam name, use it. Otherwise, ask:

> Which exam are you studying for?
>
> 1. **AI-102** — Azure AI Engineer Associate
> 2. **AZ-104** — Microsoft Azure Administrator

Once the exam is known, change to the scripts folder and run:

```powershell
Set-Location ".assets/scripts"
.\Start-StudySession.ps1 -ExamName "<exam>"
```

Replace `<exam>` with the selected value (`AI-102` or `AZ-104`).

## Variables

- `exam` — The exam name provided by the user or selected interactively. Valid values: `AI-102`, `AZ-104`.
