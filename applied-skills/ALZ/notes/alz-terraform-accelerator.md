# ALZ Terraform Accelerator Notes

The ALZ Terraform Accelerator builds the delivery machinery used to deploy a platform landing zone. It can create repositories, pipelines or workflows, identities, Terraform state storage, and the configuration used by the landing-zone deployment.

## Accelerator Flow

```text
Planning -> Prerequisites -> Bootstrap -> Run
```

- **Planning:** Decide on IaC tooling, source control, subscriptions, regions, naming, runners, and the landing-zone scenario.
- **Prerequisites:** Prepare tooling, tenant permissions, subscriptions, and source-control access.
- **Bootstrap:** Run `Deploy-Accelerator` to create the delivery environment from `./config/inputs.yaml` and `./config/platform-landing-zone.tfvars`.
- **Run:** Review a Terraform plan, approve it where applicable, and deploy the platform landing zone.

## Questions to Explore

- What does the accelerator provide beyond cloning `platform_landing_zone` and running Terraform directly?
- Which artifacts are created for GitHub, Azure DevOps, and local filesystem output?
- Which permissions are required by the bootstrap identity?
- What is the smallest useful and affordable landing-zone deployment for a study environment?
- Which resources and permissions must be cleaned up when the environment is no longer needed?

## Planning Notes

| Decision | Current Answer |
|:---------|:---------------|
| IaC tooling | Terraform |
| Version control system | |
| Starter module | `platform_landing_zone` |
| Bootstrap region | |
| Platform region(s) | |
| Parent management group | |
| Platform subscriptions | |
| Bootstrap subscription | |
| Resource naming | |
| Agent or runner model | |
| Deployment scenario | |

The platform subscriptions normally cover Management and Connectivity at minimum, with Identity and Security commonly added. For a study environment, consider a management- and policy-focused path before introducing higher-cost networking resources.

## Prerequisite Notes

- PowerShell 7.4+, Azure CLI 2.55.0+, and Git must be available on `PATH`.
- VS Code is recommended but not required.
- Review the platform subscription and permission requirements before bootstrap.
- Hosted source-control paths require the appropriate GitHub or Azure DevOps access.
- The accelerator documentation does not support corporate proxy environments or Azure Cloud Shell; a temporary Azure VM is a possible workaround.

Useful workstation checks:

```powershell
$PSVersionTable.PSVersion
az version
git --version
```

## Bootstrap Notes

- `Deploy-Accelerator` runs an interactive wizard and applies the bootstrap Terraform module.
- `./config/inputs.yaml` contains bootstrap configuration.
- `./config/platform-landing-zone.tfvars` contains platform landing-zone configuration.
- Replace region placeholders and configure a Microsoft Defender for Cloud security contact before deployment.
- Advanced Bootstrap is available when the guided path does not provide enough control.

## Output Path Comparison

| Path | What Bootstrap Creates | Deployment Flow | Considerations |
|:-----|:-----------------------|:----------------|:---------------|
| GitHub | Repository, Actions workflows, environments, OIDC federated credentials | Plan, approval, apply | Useful for an end-to-end GitHub delivery experience; requires an account or organization and bootstrap access. |
| Azure DevOps | Project, repositories, pipelines, service connections, variable groups | Plan, approval, apply | Fits environments already governed through Azure DevOps but introduces more platform artifacts. |
| Local filesystem | Terraform module output in a local folder | `deploy-local.ps1` or direct Terraform commands | Lower-friction for experimentation but does not provide hosted approval gates or pipeline history. |

Questions that can guide the choice:

1. Is CI/CD part of the current exploration, or would it distract from the landing-zone concepts?
2. Will the environment be torn down and bootstrapped repeatedly?
3. Does the tenant permit creating repositories, service connections, federated credentials, and management-group assignments?

## Findings and Next Steps

Use this section for durable findings that are worth keeping outside the chronological [Study Log](../StudyLog.md).

- Chosen output path:
- Reasoning:
- Subscription and billing constraints:
- Open questions:
- Next experiment:

## References

- [ALZ IaC Accelerator overview](https://azure.github.io/Azure-Landing-Zones/accelerator/)
- [Planning](https://azure.github.io/Azure-Landing-Zones/accelerator/0_planning/)
- [Prerequisites](https://azure.github.io/Azure-Landing-Zones/accelerator/1_prerequisites/)
- [Bootstrap](https://azure.github.io/Azure-Landing-Zones/accelerator/2_bootstrap/)
- [Run](https://azure.github.io/Azure-Landing-Zones/accelerator/3_run/)
- [`platform_landing_zone` template](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone)
