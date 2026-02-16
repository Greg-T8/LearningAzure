---
name: CreateLab
description: Calls the Lab Orchestrator to generate a complete hands-on lab from an exam question or scenario.
agent: Lab-Orchestrator
tools:
  - agent
---

# Create Lab

Generate a complete hands-on lab from an exam question or scenario.

Paste your exam scenario below and the Lab Orchestrator will guide you through:

1. **Planning** — Extract metadata and design architecture
2. **Method Selection** — Choose Terraform, Bicep, Scripted, or Manual
3. **Code Generation** — Build all files with governance compliance
4. **Quality Review** — Validate naming, tags, README structure, and standards
5. **Delivery** — Receive the complete lab with deployment instructions

All standards enforced by the `azure-lab-governance` skill.
