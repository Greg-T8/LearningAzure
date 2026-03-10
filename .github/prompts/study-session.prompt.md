---
name: Invoke-AzStudySession
description: Start a study session and log the start time to the exam's StudyLog.md
---

# Invoke Az Study Session

Log the start or end of a study session for a certification exam.

## Instructions

Run the `Invoke-AzStudySession.ps1` script located in `.assets/scripts/` to update the target log file.

Determine `action` from user input:

- If the user input includes `end` (for example: `end 104`, `end az-104`, `stop ai-102`), set `action` to `End`.
- Otherwise, set `action` to `Start`.

Determine `mode` from user input using these aliases:

- `AI-102` aliases: `ai-102`, `ai102`, `102`
- `AZ-104` aliases: `az-104`, `az104`, `104`
- `WorkflowDevelopment` aliases: `workflow`, `workflowdevelopment`, `other`

If the user specified a mode, use it. Otherwise, ask:

> Which mode do you want to track?
>
> 1. **AI-102** — Azure AI Engineer Associate
> 2. **AZ-104** — Microsoft Azure Administrator
> 3. **WorkflowDevelopment** — Workflow and lab buildout optimization

Once the mode is known, change to the scripts folder and run:

```powershell
Set-Location ".assets/scripts"
.\Invoke-AzStudySession.ps1 -Action "<action>" -Mode "<mode>"
```

Replace `<action>` with `Start` or `End` and `<mode>` with `AI-102`, `AZ-104`, or `WorkflowDevelopment`.

Examples:

```text
end 104      => -Action "End"   -Mode "AZ-104"
start 102    => -Action "Start" -Mode "AI-102"
workflow     => -Action "Start" -Mode "WorkflowDevelopment"
```

## Variables

- `action` — Session action inferred from user input. Valid values: `Start`, `End`.
- `mode` — The tracking mode provided by the user or selected interactively. Valid values: `AI-102`, `AZ-104`, `WorkflowDevelopment`.
