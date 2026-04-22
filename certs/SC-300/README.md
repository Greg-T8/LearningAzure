# SC-300: Microsoft Identity and Access Administrator — Study Guide

**Objective:** Achieve the **Microsoft Certified: Identity and Access Administrator Associate** certification using NotebookLM-generated practice quizzes and practice exams.

- **Certification Page:** [Microsoft Certified: Identity and Access Administrator Associate](https://learn.microsoft.com/en-us/credentials/certifications/identity-and-access-administrator/)
- **Official Study Guide:** [SC-300 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-300)
- **Deep Research Study Guide:** [Deep Research Study Guide](./research/SC-300-Study-Guide-Task-to-Documentation-Map.md)
- **Study Log:** [Session-by-session study time tracker](./StudyLog.md)

<!-- STUDY_SUMMARY -->
**Hours Committed:** 0h · **Days Studied:** 0
<!-- /STUDY_SUMMARY -->

---

## 📊 Exam Coverage

Skill-level coverage based on [Per-Skill Progress](#per-skill-progress) completion.

<!-- BEGIN COVERAGE DASHBOARD -->

| Domain | Weight | Skills | Skills Covered | Status |
| :----- | :----- | -----: | :------------- | :----: |
| [1. User Identities](#domain-1) | 20–25% | 4 | 0 / 4 (0%) | 🔴 |
| [2. Authentication & Access Management](#domain-2) | 25–30% | 4 | 0 / 4 (0%) | 🔴 |
| [3. Workload Identities](#domain-3) | 20–25% | 4 | 0 / 4 (0%) | 🔴 |
| [4. Identity Governance](#domain-4) | 20–25% | 4 | 0 / 4 (0%) | 🔴 |

**Totals:** 0 / 16 skills completed

**Legend:** 🟢 Strong (≥66%) · 🟡 Partial (33–65%) · 🔴 Low (<33%) — "Covered" = skill completed in Per-Skill Progress

<!-- END COVERAGE DASHBOARD -->

<!-- BEGIN COVERAGE TABLE -->

<a id="domain-1"></a>
<details>
<summary><b>Domain 1: Implement and manage user identities (20–25%)</b> — 26 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Configure and manage a Microsoft Entra tenant | Configure and manage built-in and custom Microsoft Entra roles |
|  | Recommend when to use administrative units |
|  | Configure and manage administrative units |
|  | Evaluate effective permissions for Microsoft Entra roles |
|  | Configure and manage domains in Microsoft Entra ID and Microsoft 365 |
|  | Configure Company branding settings |
|  | Configure tenant properties, user settings, group settings, and device settings |
| Create, configure, and manage Microsoft Entra identities | Create, configure, and manage users |
|  | Create, configure, and manage groups |
|  | Manage custom security attributes |
|  | Automate bulk operations by using the Microsoft Entra admin center and PowerShell |
|  | Manage device join and device registration in Microsoft Entra ID |
|  | Assign, modify, and report on licenses |
| Implement and manage identities for external users and tenants | Manage External collaboration settings in Microsoft Entra ID |
|  | Invite external users, individually or in bulk |
|  | Manage external user accounts in Microsoft Entra ID |
|  | Implement Cross-tenant access settings |
|  | Implement and manage cross-tenant synchronization |
|  | Configure external identity providers, including protocols such as SAML and WS-Fed |
| Implement and manage hybrid identity | Implement and manage Microsoft Entra Connect Sync |
|  | Implement and manage Microsoft Entra Cloud Sync |
|  | Implement and manage password hash synchronization |
|  | Implement and manage pass-through authentication |
|  | Implement and manage seamless single sign-on (SSO) |
|  | Migrate from AD FS to other authentication and authorization mechanisms |
|  | Implement and manage Microsoft Entra Connect Health |

</details>

<a id="domain-2"></a>
<details>
<summary><b>Domain 2: Implement authentication and access management (25–30%)</b> — 27 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Plan, implement, and manage Microsoft Entra user authentication | Plan for authentication |
|  | Implement and manage authentication methods, including certificate-based authentication, Temporary Access Pass, OAuth 2.0 tokens, Microsoft Authenticator, and passkeys (FIDO2) |
|  | Implement and manage tenant-wide multifactor authentication (MFA) settings |
|  | Configure and deploy self-service password reset (SSPR) |
|  | Implement and manage Windows Hello for Business |
|  | Disable accounts and revoke user sessions |
|  | Implement and manage Microsoft Entra password protection |
|  | Enable Microsoft Entra Kerberos authentication for hybrid identities |
| Plan, implement, and manage Microsoft Entra Conditional Access | Plan Conditional Access policies |
|  | Implement Conditional Access policy assignments |
|  | Implement Conditional Access policy controls |
|  | Test and troubleshoot Conditional Access policies |
|  | Implement session management |
|  | Implement device-enforced restrictions |
|  | Implement continuous access evaluation |
|  | Configure authentication context |
|  | Implement protected actions |
|  | Create a Conditional Access policy from a template |
| Manage risk by using Microsoft Entra ID Protection | Implement and manage user risk by using Microsoft Entra ID Protection or Conditional Access policies |
|  | Implement and manage sign-in risk by using Microsoft Entra ID Protection or Conditional Access policies |
|  | Implement and manage multifactor authentication registration by using authentication methods and registration campaigns |
|  | Monitor, investigate and remediate risky users and risky sign-ins |
|  | Monitor, investigate, and remediate risky workload identities |
| Implement Global Secure Access | Deploy Global Secure Access clients |
|  | Deploy and manage Private Access |
|  | Deploy and manage Internet Access |
|  | Deploy and manage Internet Access for Microsoft 365 |

</details>

<a id="domain-3"></a>
<details>
<summary><b>Domain 3: Plan and implement workload identities (20–25%)</b> — 23 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Plan and implement identities for applications and Azure workloads | Select appropriate identities for applications and Azure workloads, including managed identities, service principals, user accounts, and managed service accounts |
|  | Create managed identities |
|  | Assign a managed identity to an Azure resource |
|  | Use a managed identity assigned to an Azure resource to access other Azure resources |
| Plan, implement, and monitor the integration of enterprise applications | Plan and implement settings for enterprise applications, including application-level and tenant-level settings |
|  | Assign appropriate Microsoft Entra roles to users to manage enterprise applications |
|  | Design and implement integration for on-premises apps by using Microsoft Entra Application Proxy |
|  | Design and implement integration for software as a service (SaaS) apps |
|  | Assign, classify, and manage users, groups, and app roles for enterprise applications |
|  | Configure and manage user and admin consent |
|  | Create and manage application collections |
| Plan and implement app registrations | Plan for app registrations |
|  | Create app registrations |
|  | Configure app authentication |
|  | Configure API permissions |
|  | Create app roles |
| Manage and monitor app access by using Microsoft Defender for Cloud Apps | Configure and analyze cloud discovery results by using Defender for Cloud Apps |
|  | Configure connected apps |
|  | Implement application-enforced restrictions |
|  | Configure Conditional Access app control |
|  | Create access and session policies in Defender for Cloud Apps |
|  | Implement and manage policies for OAuth apps |
|  | Manage the Cloud app catalog |

</details>

<a id="domain-4"></a>
<details>
<summary><b>Domain 4: Plan and automate identity governance (20–25%)</b> — 22 tasks</summary>

| Skill | Task |
| :--- | :--- |
| Plan and implement entitlement management in Microsoft Entra | Plan entitlements |
|  | Create and configure catalogs |
|  | Create and configure access packages |
|  | Manage access requests |
|  | Implement and manage terms of use (ToU) |
|  | Manage the lifecycle of external users |
|  | Configure and manage connected organizations |
| Plan, implement, and manage access reviews in Microsoft Entra | Plan for access reviews |
|  | Create and configure access reviews |
|  | Monitor access review activity |
|  | Manually respond to access review activity |
| Plan and implement privileged access | Plan and manage Microsoft Entra roles in Microsoft Entra Privileged Identity Management (PIM), including settings and assignments |
|  | Plan and manage Azure resources in PIM, including settings and assignments |
|  | Plan and configure PIM for Groups |
|  | Manage the PIM request and approval process |
|  | Analyze PIM audit history and reports |
|  | Create and manage break-glass accounts |
| Monitor identity activity by using logs, workbooks, and reports | Review and analyze sign-in, audit, and provisioning logs by using the Microsoft Entra admin center |
|  | Configure diagnostic settings, including configuring destinations such as Log Analytics workspaces, storage accounts, and Azure Event Hubs |
|  | Monitor Microsoft Entra ID by using KQL queries in Log Analytics |
|  | Analyze Microsoft Entra ID by using workbooks and reporting |
|  | Monitor and improve the security posture by using Identity Secure Score |

</details>

<!-- END COVERAGE TABLE -->

---

## 🎯 Focus List — Lowest-Skill Tasks

Priority tasks ranked from [SkillRanking.md](./SkillRanking.md). Lower rank means higher skill deficiency and therefore higher priority.

<!-- BEGIN FOCUS LIST -->

### Ranking Breakdown

| Ranking | Tasks | Percentage |
| :------ | ----: | ---------: |
| Unassessed (blank) | 0 | 0.0% |
| 1 | 10 | 10.2% |
| 2 | 29 | 29.6% |
| 3 | 38 | 38.8% |
| 4 | 21 | 21.4% |
| 5 | 0 | 0.0% |

| # | Domain | Skill | Task | Rank |
| -: | :----- | :---- | :--- | -: |
| 1 | Implement authentication and access management | Implement Global Secure Access | Deploy Global Secure Access clients | 1 |
| 2 | Implement authentication and access management | Implement Global Secure Access | Deploy and manage Private Access | 1 |
| 3 | Implement authentication and access management | Implement Global Secure Access | Deploy and manage Internet Access | 1 |
| 4 | Implement authentication and access management | Implement Global Secure Access | Deploy and manage Internet Access for Microsoft 365 | 1 |
| 5 | Plan and implement workload identities | Plan, implement, and monitor the integration of enterprise applications | Configure and manage user and admin consent | 1 |
| 6 | Plan and implement workload identities | Plan, implement, and monitor the integration of enterprise applications | Create and manage application collections | 1 |
| 7 | Plan and automate identity governance | Plan and implement entitlement management in Microsoft Entra | Plan entitlements | 1 |
| 8 | Plan and automate identity governance | Plan and implement entitlement management in Microsoft Entra | Create and configure catalogs | 1 |
| 9 | Plan and automate identity governance | Plan and implement entitlement management in Microsoft Entra | Manage access requests | 1 |
| 10 | Plan and automate identity governance | Plan and implement entitlement management in Microsoft Entra | Implement and manage terms of use (ToU) | 1 |

*Run `.assets/scripts/Update-FocusList.ps1 -Exam SC-300` to refresh.*

<!-- END FOCUS LIST -->

---

## 📚 Progress Tracker

**Goal:** Pass SC-300 by ~Jun 1, 2026 · **Pace:** 2.5 hrs/day, 7 days/week

### Per-Skill Progress

| # | Domain | Skill | Tasks | NB | PQ | Hours | Progress |
| -: | :----- | :---- | ----: | :-: | :-: | ----: | :------- |
| 1 | User Identities | Configure and manage a Microsoft Entra tenant | 7 | 🔲 | 🔲 | 0.0h | 🔲 |
| 2 | User Identities | Create, configure, and manage Microsoft Entra identities | 6 | 🔲 | 🔲 | 0.0h | 🔲 |
| 3 | User Identities | Implement and manage identities for external users and tenants | 6 | 🔲 | 🔲 | 0.0h | 🔲 |
| 4 | User Identities | Implement and manage hybrid identity | 7 | 🔲 | 🔲 | 0.0h | 🔲 |
| 5 | Authentication & Access Management | Plan, implement, and manage Microsoft Entra user authentication | 8 | 🔲 | 🔲 | 0.0h | 🔲 |
| 6 | Authentication & Access Management | Plan, implement, and manage Microsoft Entra Conditional Access | 10 | 🔲 | 🔲 | 0.0h | 🔲 |
| 7 | Authentication & Access Management | Manage risk by using Microsoft Entra ID Protection | 5 | 🔲 | 🔲 | 0.0h | 🔲 |
| 8 | Authentication & Access Management | Implement Global Secure Access | 4 | 🔲 | 🔲 | 0.0h | 🔲 |
| 9 | Workload Identities | Plan and implement identities for applications and Azure workloads | 4 | 🔲 | 🔲 | 0.0h | 🔲 |
| 10 | Workload Identities | Plan, implement, and monitor the integration of enterprise applications | 7 | 🔲 | 🔲 | 0.0h | 🔲 |
| 11 | Workload Identities | Plan and implement app registrations | 5 | 🔲 | 🔲 | 0.0h | 🔲 |
| 12 | Workload Identities | Manage and monitor app access by using Microsoft Defender for Cloud Apps | 7 | 🔲 | 🔲 | 0.0h | 🔲 |
| 13 | Identity Governance | Plan and implement entitlement management in Microsoft Entra | 7 | 🔲 | 🔲 | 0.0h | 🔲 |
| 14 | Identity Governance | Plan, implement, and manage access reviews in Microsoft Entra | 4 | 🔲 | 🔲 | 0.0h | 🔲 |
| 15 | Identity Governance | Plan and implement privileged access | 6 | 🔲 | 🔲 | 0.0h | 🔲 |
| 16 | Identity Governance | Monitor identity activity by using logs, workbooks, and reports | 5 | 🔲 | 🔲 | 0.0h | 🔲 |

**Modalities:**

- **NB** (NotebookLM) — Generated practice quizzes based on Microsoft Documentation sources
- **PQ** (PracticeQuestion) — Practice questions from MeasureUp or Microsoft assessment

---
