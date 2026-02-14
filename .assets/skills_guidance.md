## How Copilot Atlas “uses skills” (in that repo)

Copilot Atlas is primarily a **custom-agent prompt pack** (Atlas + subagents) that uses a conductor/delegate pattern: a main orchestrator agent delegates planning/implementation/review work to specialized subagents. ([GitHub][1])

It **does not use “Agent Skills” (the Copilot feature) as a first-class dependency mechanism**. Instead, the repo’s setup is “copy these `.agent.md` files into your VS Code prompts/agents location and use them.” ([GitHub][1])

So if you add `skills:` to an **agent profile frontmatter**, you’re mixing two different customization systems:

* **Custom agents**: defined via `.agent.md` with supported YAML frontmatter fields
* **Agent Skills**: discovered from skill folders (like `.github/skills/.../SKILL.md`) and loaded on-demand

## Why you get: `skills is not a supported attribute`

In the supported custom agent frontmatter schema, there is **no `skills` property**. The GitHub Docs compatibility table lists supported properties (for agent profiles) such as `name`, `description`, `target`, `tools`, `infer`, `mcp-servers`, `metadata`—and explicitly calls out other fields (like `model`, `argument-hint`, `handoffs`) as VS Code/IDE-specific. No `skills` field exists. ([GitHub Docs][2])

That’s why VS Code flags `skills:` as unsupported.

## How “Agent Skills” are supposed to work (Copilot feature)

Agent Skills are **folders** containing a required `SKILL.md` plus optional scripts/resources. VS Code looks for them in standard locations like:

* `.github/skills/<skill-name>/SKILL.md`
* `.claude/skills/<skill-name>/SKILL.md`
* `.agents/skills/<skill-name>/SKILL.md`

…and personal locations like `~/.copilot/skills/...` ([Visual Studio Code][3])

Copilot decides to use a skill based on the **skill’s `description`**. When relevant, it injects the `SKILL.md` body into context; resources are accessed only as needed. ([Visual Studio Code][3])

## Fix options (pick the behavior you want)

### Option A — Use Agent Skills properly (recommended if you want “load on demand”)

1. **Remove** `skills:` from your `.agent.md` frontmatter.
2. Put your skill under a supported location, e.g.:

   * `.github/skills/azure-lab-governance/SKILL.md` ([Visual Studio Code][3])
3. If you insist on keeping a nonstandard `skills/` folder at repo root, add it via `chat.agentSkillsLocations` (VS Code supports adding extra search locations). ([Visual Studio Code][3])
4. Make sure the skill frontmatter has at least:

   * `name:` (lowercase, hyphens)
   * `description:` (include the keywords Copilot should match on) ([Visual Studio Code][3])

**Key point:** you don’t “attach” a skill to an agent via YAML. Skills are discovered globally and loaded when relevant. ([Visual Studio Code][3])

### Option B — If you need deterministic enforcement, make it a subagent (fits your orchestration model)

If your goal is “the orchestrator must always apply governance,” a **review/governance subagent** is more reliable than hoping the model auto-loads a skill. Atlas-style systems already lean on subagents + handoffs/tooling. ([GitHub][1])

In that case:

* Keep governance rules in `Governance-lab.md`
* In your Lab-Orchestrator instructions: “Always run Lab-Reviewer-subagent against Governance-lab.md before generating output”
* Have the reviewer agent `read` that file directly (or link it in the agent body; VS Code supports referencing other files via markdown links) ([Visual Studio Code][4])

## Minimal concrete change to your agent file

In `Lab-Orchestrator.agent.md`, change frontmatter from:

```yaml
tools:
  - agent
skills:
  - azure-lab-governance
```

to:

```yaml
tools:
  - agent
```

Then either:

* rely on the skill auto-loading (Option A), or
* explicitly delegate governance checks to your reviewer subagent (Option B).

If you want, paste your `SKILL.md` header + description text and I’ll rewrite the description so it reliably triggers on “naming/tagging/region/cost/governance” lab tasks.

[1]: https://github.com/bigguy345/Github-Copilot-Atlas "GitHub - bigguy345/Github-Copilot-Atlas"
[2]: https://docs.github.com/en/copilot/reference/custom-agents-configuration "Custom agents configuration - GitHub Docs"
[3]: https://code.visualstudio.com/docs/copilot/customization/agent-skills "Use Agent Skills in VS Code"
[4]: https://code.visualstudio.com/docs/copilot/customization/custom-agents "Custom agents in VS Code"
