# Lab Orchestrator Guidance

## Target end state

Create a **Lab Orchestrator** custom agent that delegates to **context-isolated subagents** for (1) planning, (2) code generation, and (3) governance/README review—similar to the conductor-delegate pattern used by Copilot Atlas. ([GitHub][1])

This matches your current single-prompt workflow, but splits it into smaller, verifiable steps while keeping your main chat context clean (subagents run in isolated contexts and can run in parallel). ([Visual Studio Code][2])

---

## Recommended workspace layout

Use the standard VS Code locations for prompt files, agents, and skills:

```
.github/
  prompts/
    lab.prompt.md                      # your entry command (keep as the “one thing” you run)
  agents/
    Lab-Orchestrator.agent.md          # main conductor
    Lab-Planner.agent.md               # plan + architecture + module breakdown
    Terraform-Builder-subagent.agent.md
    Bicep-Builder-subagent.agent.md
    Lab-Reviewer-subagent.agent.md     # governance + README compliance gates
  skills/
    azure-lab-governance/
      SKILL.md
      Governance-Lab.md                # copy or reference your authoritative policy
      templates/README.template.md
      templates/terraform-module.stub/
      templates/bicep-module.stub/
      scripts/Confirm-LabSubscription.ps1
```

VS Code discovers prompt files in `.github/prompts` and custom agents in `.github/agents`. ([Visual Studio Code][3])
Skills live under `.github/skills/<skill>/SKILL.md` and can auto-load when relevant. ([Visual Studio Code][4])

---

## Convert your existing assets into “portable context”

### 1) Governance becomes a Skill (auto-load, not copy/paste)

Your governance doc is large and stable (naming, tags, regions, module guidance, purge/soft-delete rules). Keep it authoritative and make it load on demand via a skill, instead of re-injecting it into every prompt.  ([Visual Studio Code][4])

Suggested approach:

* Put a condensed “how to apply governance” in `SKILL.md`
* Keep the full `Governance-Lab.md` in the skill folder as the long reference

### 2) Your `lab.prompt.md` stayst

Keep your current prompt as the one slash command you run. It already encodes your required workflow (deployment method decision, README ordering, folder structure, validation sequences).

Update only the frontmatter so it runs through your orchestrator and can delegate:

* set `agent: Lab-Orchestrator`
* ensure tools include `agent` or `runSubagent` so it can spawn subagents from the prompt invocation ([Visual Studio Code][3])

---

## Agent/subagent design (minimal seiately)

### A) Lab-Orchestrator (main custom agent)

Purpose: keep the “conversation contract” with you, and delegate everything else.

Key behaviors to encode:

* Always treat `Governance-Lab.md` as source of truth
* Enforce your method selection rule: **IaaC > Scripted > Manual**; if IaaC, **ask user Terraform vs Bicep** (do not auto-select)
* Use subagents for long tasks (planning, generation, reviews) to preserve main context ([Visual Studio Code][2])
* Gate each phase with a user decision (via **handoffs** buttons) ([Visual Studio Code][5])

Implementationt frontmatter, restrict which subagents it can invoke via the `agents:` list and enable the `agent` tool. ([Visual Studio Code][5])ner (planner agent or subagent)
Inputs: exam question text + chosen deployment method (or “pending choice”).

Outputs (structured):

* extracted: exam/domain/topic
* target RG name(s) per your pattern
* architecture summary + mermaid requirement decision
* module breakdown (thin root + modules when 2+ resource types)
* concrete file list consistent with your lab prompt’s required structure

Add a **handoff**: “Build (Terraform)” / “Build (Bicep)” to move into the correct builder. ([Visual Studio Code][5])

### C) Terraform-Builder-subagent and Bicep-Builder-subagent

These do the heavy file creation in isolation and return:

* generated files (code + README + validation scripts)
* a “what I changed/created” summary

Make these **subagent-only** (`user-invokable: false`) so they don’t clutter your agent dropdown. ([Visual Studio Code][2])

### D) Lab-Reviewer-subagent (governanis is the biggest reliability win. It should check (and report as PASS/FAILg patterns, required tags (including static `DateCreated`), region rules

* README sections in the exact required order
* required Terraform/Bicep validation sequence presence (validate → capacity test → plan)
* purge/soft-delete considerations are addressed where relevant

---

## Orchestration workflow (what happens when you run `/lab`)

1. **Intake (Orchestrator)**

* Reads question
* Calls subagent: “Exam parse + constraints extraction”
* Produces a short, structured scenario summary

2. **Method selection (Orchestrator)**

* Applies your decision policy; if IaaC, asks Terraform vs Bicep

3. **Plan (Lab-Planner)**

* Generates architecture + module plan + file tree
* Emits handoff button: “Start Bui([Visual Studio Code][5])

4. **Build (Terraform/Bicep Builder subagent)files

* Adds headers in code files, keeps secrets out, aligns provider/version expectations

5. **Review (Lab-Reviewer subagent + README compliance checks and returns a clear PASS/FAIL and diffs/fix list

6. **Finalize (Orchestrator)**

* Presents:

  * Deployment Method Decision
  * Lab Summary
  * File List
  * Validation Results
  * README Compliance Confirmation
  * Governance Compliance Confirmation

---

## Migration plan-risk)

### Iteration 1 (1–2 labs)

* Create only 4 files:

  * `Lab-Orchestrator.agent.md`
  * `Lab-Planner.agent.md`
  * `Terraform-Builder-subagent.agent.md`
  * `Lab-Reviewer-subagent.agent.md`
* Update `lab.prompt.md` frontmatter to run through `Lab-Orchestrator` and allow delegation from prompt execution ([Visual Studio Code][3])

Goal: prove planning → build → review gav## Iteration 2

* Add Bicep builder subagent
* Move governance into a skill folder so it’s loaded on-demand (less prompt bloat) ([Visual Studio Code][4])

### Iteration 3

* Add specialized “micro-subagents” only if they pay rent:

  * “Region/Capacity validator” (generates the exact CLI checks for the services in the scenario)
  * “Purge/Soft-d Key Vault/CogSvc etc. cleanup pitfalls)
  * “Mermaid diagram builder” (only when needed)

---

## Practical VS Code knobs to use while you iterate

* Use the Chat “Diagnostics” view to confirm your prompt files, agents, and skills load correctly and to catch frontmatter/schema mistakes early. ([Visual Studio Code][5])
* Keep subagents narrowly scoped and require structured outputs; the main orchestrator should only ingest summaries/results (not entire work logs). This matches how VS Code positions subagents for context isolation. ([Visual Studio Code][2])

[1]: https://github.com/bigguy345/Github-Copilot-Atlas "GitHub - bigguy345/Github-Copilot-Atlas"
[2]: https://code.visualstudio.com/docs/copilot/agents/subagents "Subagents in Visual Studio Code"
[3]: https://code.visualstudio.com/docs/copilot/customization/prompt-files "Use prompt files in VS Code"
[4]: https://code.visualstudio.com/docs/copilot/customization/agent-skills "Use Agent Skills in VS Code"
[5]: https://code.visualstudio.com/docs/copilot/customization/custom-agents "Custom agents in VS Code"
