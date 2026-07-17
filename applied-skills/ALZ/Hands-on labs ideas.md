## Hands-On Labs Ideas

### Lab 1: ALZ Terraform Accelerator File Map

**Goal:** Know what the platform landing zone template is deploying before you run anything.

Tasks:

- Open the `platform_landing_zone` template and map `terraform.tf`, `main.management.groups.tf`, `main.management.resources.tf`, connectivity files, variable files, and examples.
- Identify the AVM platform landing zone module responsibilities.
- Record required subscriptions: management, connectivity, and identity.
- Decide whether you are using hub-and-spoke, Virtual WAN, or a lower-cost management/policy-only route first.

### Lab 2: Platform Landing Zone Plan

**Goal:** Produce a Terraform plan for a landing zone baseline.

Tasks:

- Create or adapt `terraform.tfvars` with lab subscription IDs and locations.
- Run `terraform init`.
- Run `terraform validate`.
- Run `terraform plan`.
- Review management group, policy, role, Log Analytics, Automation, networking, DDoS, and private DNS changes.

Apply only when the plan, permissions, and cost profile are acceptable.
