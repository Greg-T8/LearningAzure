# Study Log — ALZ: Azure Landing Zone

This log tracks individual study sessions for the **ALZ** applied skill. Use **Notes** to capture whatever you explored, learned, or want to continue next.

---

## Session History

| # | Date | Start | End | Duration | Notes |
|:--|:-----|:------|:----|:---------|:------|
| 27 | 8/14/26 | 4:39 AM |  |  |  |
| 26 | 8/13/26 | 2:30 AM | 5:08 AM | 2h 38m | Refined techniques in deploying Azure vWAN using ALZ |
| 25 | 8/12/26 | 2:53 AM | 7:00 AM | 4h 7m | Refined ALZ pipeline; developed new pipeline support of custom deployments; created CostManagement PowerShell module |
| 24 | 8/11/26 | 2:54 AM | 5:30 AM | 2h 36m | Refined finops PowerShell commands; refined deployment templates in support of ALZ pipeline stages |
| 23 | 8/10/26 | 2:56 AM | 5:13 AM | 2h 17m | Refined finops PowerShell commands; refined deployment templates in support of ALZ pipeline stages |
| 22 | 8/9/26 | 3:03 AM | 8:27 AM | 5h 24m | Refine techniques in using the ALZ accelerator to deploy a two-virtual hub vWAN landing zone; develop scripts for configuring cost anomaly and budget alerts |
| 21 | 8/8/26 | 2:44 AM | 7:02 AM | 4h 18m | Refine techniques in using the ALZ accelerator to deploy a two-virtual hub vWAN landing zone |
| 20 | 8/7/26 | 5:09 AM | 6:28 AM | 1h 19m | Troubleshooting ALZ deployment; investigated use of cost management API to create cost allocation rules. For next session, pick up on the API cost management setup |
| 19 | 8/6/26 | 5:14 AM | 6:58 AM | 1h 44m | Successfully used the IaC Accelerator to deploy a hub and spoke setup; next pick up at troubleshooting lingering issues, e.g. long time to create management groups |
| 18 | 8/5/26 | 5:30 AM | 6:50 AM | 1h 20m | For next session, pick up on concurrency issue w/ Terraform destroy operation for ALZ deployment |
| 17 | 8/4/26 | 5:57 AM | 6:27 AM | 0h 30m | Deployed patched ALZ bootstrap environment. For next session, pick up at understanding ci vs cd workflows |
| 16 | 8/3/26 | 5:23 AM | 6:47 AM | 1h 24m | Created bootstrap script. Next session pick up at making changes using pull request |
| 15 | 8/2/26 | 5:48 AM | 7:30 AM | 1h 42m | Deep dive into terraform code used by ALZ. For next session, (1) store PATs in Key Vault and (2) pick up with using the CI GitHub action flow to bring in changes via pull request |
| 14 | 7/31/26 | 5:34 AM | 6:25 AM | 0h 51m | Pick up at understanding built-in replacements in platform-landing-zone.auto.tfvars |
| 13 | 7/30/26 | 5:27 AM | 6:30 AM | 1h 3m | Pick up at understanding the bootstrap process. Continue with exploring pull requests instead of pushing to main branch |
| 12 | 7/29/26 | 5:49 AM | 6:41 AM | 0h 52m | A couple of paths to pick up next: (1) investigate var.repositoryname or (2) revisit branch policy/pull request. |
| 11 | 7/28/26 | 5:18 AM | 6:43 AM | 1h 25m | Continue investigation failure of ALZ management group scenario |
| 10 | 7/27/26 | 5:35 AM | 7:01 AM | 1h 26m | Troubleshooting deployment of management group landing zone |
| 9 | 7/24/26 | 5:12 AM | 6:12 AM | 1h 0m | Troubleshoot failed bootstratp deployments for ALZ solution due to regional constraints and capacity issues |
| 8 | 7/23/26 | 5:45 AM | 6:30 AM | 0h 45m | Investigated and found root cause of error--related to single subscription usage; redeploy w/ revised config and switch from private to public to save cost |
| 7 | 7/21/26 | 5:16 AM | 6:19 AM | 1h 3m | Resolved pipeline error with OIDC trust mismatch; enountered new error regarding permissions for policy role assignment; pick up here next session |
| 6 | 7/20/26 | 5:31 AM | 6:29 AM | 0h 58m | Troubleshooting GitHub Actions pipeline error w/ terraform plan |
| 5 | 7/19/26 | 7:55 AM | 9:23 AM | 1h 28m | Tested deployment of bootstrap resources for ALZ.  Attempted to deploy platform scenario for management groups by hit an error with federated identity credential |
| 4 | 7/18/26 | 6:20 AM | 7:51 AM | 1h 31m | Research — Understand the ALZ Terraform Accelerator — Completed prerequisites; move towards deploying bootstrap resources |
| 3 | 7/17/26 | 5:11 AM | 6:17 AM | 1h 06m | Research — Understand the ALZ Terraform Accelerator — Working through issue provisioning ALZ Azure subscriptions with my personal billing account; submitted Microsoft Support ticket |
| 2 | 7/16/26 | 5:07 AM | 7:00 AM | 1h 53m | Research — Understand the ALZ Terraform Accelerator — Work towards setup of multiple Azure subscriptions/billing profile in support of landing zone architecture |
| 1 | 7/14/26 | 5:30 AM | 6:01 AM | 0h 31m | Research — Understand the ALZ Terraform Accelerator — Completed overview reading of ALZ accelerator; pick up at Phase 2 - Bootstrap |
