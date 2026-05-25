# SC-300: Microsoft Identity and Access Administrator — Study Guide

**Objective:** Achieve the **Microsoft Certified: Identity and Access Administrator Associate** certification using NotebookLM-generated practice quizzes and practice exams.

- **Certification Page:** [Microsoft Certified: Identity and Access Administrator Associate](https://learn.microsoft.com/en-us/credentials/certifications/identity-and-access-administrator/)
- **Official Study Guide:** [SC-300 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-300)
- **Deep Research Study Guide:** [Deep Research Study Guide](./research/SC-300-Study-Guide-Task-to-Documentation-Map.md)
- **Study Log:** [Session-by-session study time tracker](./StudyLog.md)

<!-- STUDY_SUMMARY -->
**Hours Committed:** 75.8h · **Days Studied:** 32
<!-- /STUDY_SUMMARY -->



---

## 📊 Exam Coverage

Skill-level coverage based on [Per-Skill Progress](#per-skill-progress) completion.

<!-- BEGIN COVERAGE DASHBOARD -->

| Domain | Weight | Skills | Skills Covered | Status |
| :----- | :----- | -----: | :------------- | :----: |
| [1. User Identities](#domain-1) | 20–25% | 4 | 4 / 4 (100%) | 🟢 |
| [2. Authentication & Access Management](#domain-2) | 25–30% | 4 | 4 / 4 (100%) | 🟢 |
| [3. Workload Identities](#domain-3) | 20–25% | 4 | 4 / 4 (100%) | 🟢 |
| [4. Identity Governance](#domain-4) | 20–25% | 4 | 4 / 4 (100%) | 🟢 |

**Totals:** 16 / 16 skills completed

**Legend:** 🟢 Strong (≥66%) · 🟡 Partial (33–65%) · 🔴 Low (<33%) — "Covered" = skill completed in Per-Skill Progress

<!-- END COVERAGE DASHBOARD -->

<!-- BEGIN COVERAGE TABLE -->

<a id="domain-1"></a>
<details>
<summary><b>Domain 1: Implement and manage user identities (20–25%)</b> — 28 tasks</summary>

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
<summary><b>Domain 2: Implement authentication and access management (25–30%)</b> — 29 tasks</summary>

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
<summary><b>Domain 3: Plan and implement workload identities (20–25%)</b> — 25 tasks</summary>

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
<summary><b>Domain 4: Plan and automate identity governance (20–25%)</b> — 24 tasks</summary>

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
| 1 | 0 | 0.0% |
| 2 | 0 | 0.0% |
| 3 | 0 | 0.0% |
| 4 | 61 | 62.2% |
| 5 | 37 | 37.8% |

| # | Domain | Skill | Task | Rank |
| -: | :----- | :---- | :--- | -: |
| 1 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Configure and manage domains in Microsoft Entra ID and Microsoft 365 | 4 |
| 2 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Configure tenant properties, user settings, group settings, and device settings | 4 |
| 3 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Create, configure, and manage users | 4 |
| 4 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Create, configure, and manage groups | 4 |
| 5 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Automate bulk operations by using the Microsoft Entra admin center and PowerShell | 4 |
| 6 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Assign, modify, and report on licenses | 4 |
| 7 | Implement and manage user identities | Implement and manage identities for external users and tenants | Manage External collaboration settings in Microsoft Entra ID | 4 |
| 8 | Implement and manage user identities | Implement and manage identities for external users and tenants | Invite external users, individually or in bulk | 4 |
| 9 | Implement and manage user identities | Implement and manage identities for external users and tenants | Manage external user accounts in Microsoft Entra ID | 4 |
| 10 | Implement and manage user identities | Implement and manage identities for external users and tenants | Implement Cross-tenant access settings | 4 |

<!-- END FOCUS LIST -->

---

## 📚 Progress Tracker

**Goal:** Pass SC-300 by ~Jun 1, 2026 · **Pace:** 2.5 hrs/day, 7 days/week

### Per-Skill Progress

| # | Domain | Skill | Tasks | NB | PQ | Hours | Progress |
| -: | :----- | :---- | ----: | :-: | :-: | ----: | :------- |
| 1 | User Identities | Configure and manage a Microsoft Entra tenant | 7 | ✅ 6.3h | ✅ | 6.3h | ✅ |
| 2 | User Identities | Create, configure, and manage Microsoft Entra identities | 6 | ✅ 4.4h | ✅ | 4.4h | ✅ |
| 3 | User Identities | Implement and manage identities for external users and tenants | 6 | ✅ 3.8h | ✅ | 3.8h | ✅ |
| 4 | User Identities | Implement and manage hybrid identity | 7 | ✅ 2.1h | ✅ | 2.1h | ✅ |
| 5 | Authentication & Access Management | Plan, implement, and manage Microsoft Entra user authentication | 8 | ✅ 2.6h | ✅ | 2.6h | ✅ |
| 6 | Authentication & Access Management | Plan, implement, and manage Microsoft Entra Conditional Access | 10 | ✅ 11.0h | ✅ | 11.0h | ✅ |
| 7 | Authentication & Access Management | Manage risk by using Microsoft Entra ID Protection | 5 | ✅ 1.0h | ✅ | 1.0h | ✅ |
| 8 | Authentication & Access Management | Implement Global Secure Access | 4 | ✅ 8.6h | ✅ | 8.6h | ✅ |
| 9 | Workload Identities | Plan and implement identities for applications and Azure workloads | 4 | ✅ 4.7h | ✅ | 4.7h | ✅ |
| 10 | Workload Identities | Plan, implement, and monitor the integration of enterprise applications | 7 | ✅ 3.1h | ✅ | 3.1h | ✅ |
| 11 | Workload Identities | Plan and implement app registrations | 5 | ⏳ 1.6h | ✅ | 1.6h | ✅ |
| 12 | Workload Identities | Manage and monitor app access by using Microsoft Defender for Cloud Apps | 7 | ✅ 11.1h | ✅ | 11.1h | ✅ |
| 13 | Identity Governance | Plan and implement entitlement management in Microsoft Entra | 7 | ✅ 7.9h | ✅ | 7.9h | ✅ |
| 14 | Identity Governance | Plan, implement, and manage access reviews in Microsoft Entra | 4 | ⏳ 2.7h | ✅ | 2.7h | ✅ |
| 15 | Identity Governance | Plan and implement privileged access | 6 | ✅ 0.8h | ✅ | 0.8h | ✅ |
| 16 | Identity Governance | Monitor identity activity by using logs, workbooks, and reports | 5 | ✅ 1.1h | ✅ | 1.1h | ✅ |

**Modalities:**

- **NB** (NotebookLM) — Generated practice quizzes based on Microsoft Documentation sources
- **PQ** (PracticeQuestion) — Practice questions from MeasureUp or Microsoft assessment

---