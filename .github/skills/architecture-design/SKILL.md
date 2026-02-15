---
name: architecture-design
description: Procedures for producing architecture summaries, Mermaid diagrams, module breakdowns, and file trees from extracted metadata.
---

# Architecture Design

Procedures for designing Azure lab architectures from extracted metadata. Used by the Lab-Designer agent (Phase 2).

## When to Use

- Designing a lab architecture after metadata extraction
- Creating Mermaid diagrams for lab documentation
- Planning module structure for IaC implementations
- Generating file trees for lab folders

---

## R-110: Architecture Summary Procedure

Given metadata (exam, domain, topic, key_services):

1. Identify the primary learning objective from the exam question.
2. Determine which Azure services demonstrate the concept.
3. Map service dependencies (e.g., VM requires VNet → Subnet → NSG).
4. Write 2–4 sentences covering:
   - What services are deployed and why
   - How they connect/interact
   - What the lab participant will observe or validate

---

## R-111: Mermaid Diagram Procedure

Apply criteria from `shared-contract` R-013.

If diagram is required (2+ interconnected resources):

1. Choose layout: `graph TD` (top-down) for hierarchical, `graph LR` (left-right) for pipeline/flow.
2. Use governance-compliant resource names (`shared-contract` R-001 / R-002 / R-003).
3. Show resource group as the root container.
4. Draw lines for dependencies (network containment, access paths, data flow).
5. Use subgraphs for logical groupings (e.g., subnets within a VNet).

Common topology patterns:

- **Hub-spoke**: Subgraphs for hub and spoke VNets.
- **Multi-tier**: Top-down flow from frontend to backend.
- **AI pipeline**: Left-right flow from data source through processing to output.

---

## R-112: Module Breakdown Procedure

Apply `shared-contract` R-022 (module rule).

1. List all Azure resources from the architecture.
2. Group by domain concern:
   - **Networking**: VNet, Subnet, NSG, Route Table, Peering
   - **Compute**: VM, NIC, Disk, Availability Set
   - **Storage**: Storage Account, Containers, RBAC
   - **AI**: Cognitive Services, OpenAI, Deployments
   - **Monitoring**: Log Analytics, App Insights, Diagnostic Settings
3. Create one module per domain group (only if 2+ resource types in that group).
4. Define inputs: resource group name, location, tags, cross-module references.
5. Define outputs: resource IDs, endpoints, principal IDs (for RBAC wiring).

---

## R-113: File Tree Procedure

Apply `shared-contract` R-010 (lab folder structure).

1. Select the matching structure template for the deployment method.
2. Replace `<EXAM>`, `<domain>`, `<topic>` with actual values (lowercase).
3. Add module subfolders matching the module breakdown from R-112.
4. Add validation script file(s).
5. Verify the tree is complete: README, all code files, validation.

---

## R-114: When-to-Use Criteria

Use this skill when:

- Metadata extraction is complete and architecture design is needed
- A Mermaid diagram needs to be generated
- Module structure needs to be planned
- A file tree needs to be generated for a new lab
