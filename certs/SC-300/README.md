# SC-300: Microsoft Identity and Access Administrator — Study Guide

**Objective:** Achieve the **Microsoft Certified: Identity and Access Administrator Associate** certification using NotebookLM-generated practice quizzes and practice exams.

- **Certification Page:** [Microsoft Certified: Identity and Access Administrator Associate](https://learn.microsoft.com/en-us/credentials/certifications/identity-and-access-administrator/)
- **Official Study Guide:** [SC-300 Study Guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-300)
- **Deep Research Study Guide:** [Deep Research Study Guide](./research/SC-300-Study-Guide-Task-to-Documentation-Map.md)
- **Study Log:** [Session-by-session study time tracker](./StudyLog.md)

<!-- STUDY_SUMMARY -->
**Hours Committed:** 55.2h · **Days Studied:** 23
<!-- /STUDY_SUMMARY -->



---

## 📊 Exam Coverage

Skill-level coverage based on [Per-Skill Progress](#per-skill-progress) completion.

<!-- BEGIN COVERAGE DASHBOARD -->

| Domain | Weight | Skills | Skills Covered | Status |
| :----- | :----- | -----: | :------------- | :----: |
| [1. User Identities](#domain-1) | 20–25% | 4 | 0 / 4 (0%) | 🔴 |
| [2. Authentication & Access Management](#domain-2) | 25–30% | 4 | 1 / 4 (25%) | 🔴 |
| [3. Workload Identities](#domain-3) | 20–25% | 4 | 0 / 4 (0%) | 🔴 |
| [4. Identity Governance](#domain-4) | 20–25% | 4 | 1 / 4 (25%) | 🔴 |

**Totals:** 2 / 16 skills completed

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
| 2 | 5 | 5.1% |
| 3 | 36 | 36.7% |
| 4 | 20 | 20.4% |
| 5 | 37 | 37.8% |

| # | Domain | Skill | Task | Rank |
| -: | :----- | :---- | :--- | -: |
| 1 | Plan and implement workload identities | Plan, implement, and monitor the integration of enterprise applications | Design and implement integration for software as a service (SaaS) apps | 2 |
| 2 | Plan and implement workload identities | Plan, implement, and monitor the integration of enterprise applications | Assign, classify, and manage users, groups, and app roles for enterprise applications | 2 |
| 3 | Plan and implement workload identities | Plan and implement app registrations | Create app roles | 2 |
| 4 | Plan and automate identity governance | Plan, implement, and manage access reviews in Microsoft Entra | Manually respond to access review activity | 2 |
| 5 | Plan and automate identity governance | Monitor identity activity by using logs, workbooks, and reports | Monitor and improve the security posture by using Identity Secure Score | 2 |
| 6 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Configure tenant properties, user settings, group settings, and device settings | 3 |
| 7 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Automate bulk operations by using the Microsoft Entra admin center and PowerShell | 3 |
| 8 | Implement and manage user identities | Implement and manage identities for external users and tenants | Manage External collaboration settings in Microsoft Entra ID | 3 |
| 9 | Implement and manage user identities | Implement and manage identities for external users and tenants | Manage external user accounts in Microsoft Entra ID | 3 |
| 10 | Implement and manage user identities | Implement and manage identities for external users and tenants | Implement Cross-tenant access settings | 3 |
| 11 | Implement and manage user identities | Implement and manage identities for external users and tenants | Implement and manage cross-tenant synchronization | 3 |
| 12 | Implement and manage user identities | Implement and manage hybrid identity | Implement and manage Microsoft Entra Connect Sync | 3 |
| 13 | Implement and manage user identities | Implement and manage hybrid identity | Implement and manage password hash synchronization | 3 |
| 14 | Implement and manage user identities | Implement and manage hybrid identity | Implement and manage pass-through authentication | 3 |
| 15 | Implement and manage user identities | Implement and manage hybrid identity | Implement and manage seamless single sign-on (SSO) | 3 |
| 16 | Implement and manage user identities | Implement and manage hybrid identity | Implement and manage Microsoft Entra Connect Health | 3 |
| 17 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra user authentication | Plan for authentication | 3 |
| 18 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra user authentication | Implement and manage authentication methods, including certificate-based authentication, Temporary Access Pass, OAuth 2.0 tokens, Microsoft Authenticator, and passkeys (FIDO2) | 3 |
| 19 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra user authentication | Implement and manage Windows Hello for Business | 3 |
| 20 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra user authentication | Implement and manage Microsoft Entra password protection | 3 |
| 21 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Plan Conditional Access policies | 3 |
| 22 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Implement Conditional Access policy assignments | 3 |
| 23 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Implement Conditional Access policy controls | 3 |
| 24 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Create a Conditional Access policy from a template | 3 |
| 25 | Implement authentication and access management | Manage risk by using Microsoft Entra ID Protection | Implement and manage multifactor authentication registration by using authentication methods and registration campaigns | 3 |
| 26 | Plan and implement workload identities | Plan and implement identities for applications and Azure workloads | Select appropriate identities for applications and Azure workloads, including managed identities, service principals, user accounts, and managed service accounts | 3 |
| 27 | Plan and implement workload identities | Plan and implement identities for applications and Azure workloads | Assign a managed identity to an Azure resource | 3 |
| 28 | Plan and implement workload identities | Plan, implement, and monitor the integration of enterprise applications | Plan and implement settings for enterprise applications, including application-level and tenant-level settings | 3 |
| 29 | Plan and implement workload identities | Plan, implement, and monitor the integration of enterprise applications | Assign appropriate Microsoft Entra roles to users to manage enterprise applications | 3 |
| 30 | Plan and implement workload identities | Plan and implement app registrations | Plan for app registrations | 3 |
| 31 | Plan and implement workload identities | Plan and implement app registrations | Create app registrations | 3 |
| 32 | Plan and implement workload identities | Plan and implement app registrations | Configure app authentication | 3 |
| 33 | Plan and implement workload identities | Plan and implement app registrations | Configure API permissions | 3 |
| 34 | Plan and automate identity governance | Plan and implement entitlement management in Microsoft Entra | Configure and manage connected organizations | 3 |
| 35 | Plan and automate identity governance | Plan, implement, and manage access reviews in Microsoft Entra | Plan for access reviews | 3 |
| 36 | Plan and automate identity governance | Plan, implement, and manage access reviews in Microsoft Entra | Create and configure access reviews | 3 |
| 37 | Plan and automate identity governance | Plan, implement, and manage access reviews in Microsoft Entra | Monitor access review activity | 3 |
| 38 | Plan and automate identity governance | Plan and implement privileged access | Analyze PIM audit history and reports | 3 |
| 39 | Plan and automate identity governance | Plan and implement privileged access | Create and manage break-glass accounts | 3 |
| 40 | Plan and automate identity governance | Monitor identity activity by using logs, workbooks, and reports | Review and analyze sign-in, audit, and provisioning logs by using the Microsoft Entra admin center | 3 |
| 41 | Plan and automate identity governance | Monitor identity activity by using logs, workbooks, and reports | Analyze Microsoft Entra ID by using workbooks and reporting | 3 |
| 42 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Configure and manage domains in Microsoft Entra ID and Microsoft 365 | 4 |
| 43 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Create, configure, and manage users | 4 |
| 44 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Create, configure, and manage groups | 4 |
| 45 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Assign, modify, and report on licenses | 4 |
| 46 | Implement and manage user identities | Implement and manage identities for external users and tenants | Invite external users, individually or in bulk | 4 |
| 47 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra user authentication | Implement and manage tenant-wide multifactor authentication (MFA) settings | 4 |
| 48 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra user authentication | Configure and deploy self-service password reset (SSPR) | 4 |
| 49 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra user authentication | Disable accounts and revoke user sessions | 4 |
| 50 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Implement protected actions | 4 |
| 51 | Implement authentication and access management | Manage risk by using Microsoft Entra ID Protection | Implement and manage user risk by using Microsoft Entra ID Protection or Conditional Access policies | 4 |
| 52 | Implement authentication and access management | Manage risk by using Microsoft Entra ID Protection | Implement and manage sign-in risk by using Microsoft Entra ID Protection or Conditional Access policies | 4 |
| 53 | Implement authentication and access management | Manage risk by using Microsoft Entra ID Protection | Monitor, investigate and remediate risky users and risky sign-ins | 4 |
| 54 | Plan and implement workload identities | Plan, implement, and monitor the integration of enterprise applications | Design and implement integration for on-premises apps by using Microsoft Entra Application Proxy | 4 |
| 55 | Plan and automate identity governance | Plan and implement entitlement management in Microsoft Entra | Manage the lifecycle of external users | 4 |
| 56 | Plan and automate identity governance | Plan and implement privileged access | Plan and manage Microsoft Entra roles in Microsoft Entra Privileged Identity Management (PIM), including settings and assignments | 4 |
| 57 | Plan and automate identity governance | Plan and implement privileged access | Plan and manage Azure resources in PIM, including settings and assignments | 4 |
| 58 | Plan and automate identity governance | Plan and implement privileged access | Plan and configure PIM for Groups | 4 |
| 59 | Plan and automate identity governance | Plan and implement privileged access | Manage the PIM request and approval process | 4 |
| 60 | Plan and automate identity governance | Monitor identity activity by using logs, workbooks, and reports | Configure diagnostic settings, including configuring destinations such as Log Analytics workspaces, storage accounts, and Azure Event Hubs | 4 |
| 61 | Plan and automate identity governance | Monitor identity activity by using logs, workbooks, and reports | Monitor Microsoft Entra ID by using KQL queries in Log Analytics | 4 |
| 62 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Configure and manage built-in and custom Microsoft Entra roles | 5 |
| 63 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Recommend when to use administrative units | 5 |
| 64 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Configure and manage administrative units | 5 |
| 65 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Evaluate effective permissions for Microsoft Entra roles | 5 |
| 66 | Implement and manage user identities | Configure and manage a Microsoft Entra tenant | Configure Company branding settings | 5 |
| 67 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Manage custom security attributes | 5 |
| 68 | Implement and manage user identities | Create, configure, and manage Microsoft Entra identities | Manage device join and device registration in Microsoft Entra ID | 5 |
| 69 | Implement and manage user identities | Implement and manage identities for external users and tenants | Configure external identity providers, including protocols such as SAML and WS-Fed | 5 |
| 70 | Implement and manage user identities | Implement and manage hybrid identity | Implement and manage Microsoft Entra Cloud Sync | 5 |
| 71 | Implement and manage user identities | Implement and manage hybrid identity | Migrate from AD FS to other authentication and authorization mechanisms | 5 |
| 72 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra user authentication | Enable Microsoft Entra Kerberos authentication for hybrid identities | 5 |
| 73 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Test and troubleshoot Conditional Access policies | 5 |
| 74 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Implement session management | 5 |
| 75 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Implement device-enforced restrictions | 5 |
| 76 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Implement continuous access evaluation | 5 |
| 77 | Implement authentication and access management | Plan, implement, and manage Microsoft Entra Conditional Access | Configure authentication context | 5 |
| 78 | Implement authentication and access management | Manage risk by using Microsoft Entra ID Protection | Monitor, investigate, and remediate risky workload identities | 5 |
| 79 | Implement authentication and access management | Implement Global Secure Access | Deploy Global Secure Access clients | 5 |
| 80 | Implement authentication and access management | Implement Global Secure Access | Deploy and manage Private Access | 5 |

<!-- END FOCUS LIST -->

---

## 📚 Progress Tracker

**Goal:** Pass SC-300 by ~Jun 1, 2026 · **Pace:** 2.5 hrs/day, 7 days/week

### Per-Skill Progress

| # | Domain | Skill | Tasks | NB | PQ | Hours | Progress |
| -: | :----- | :---- | ----: | :-: | :-: | ----: | :------- |
| 1 | User Identities | Configure and manage a Microsoft Entra tenant | 7 | ⏳ 6.3h | 🔲 | 6.3h | ⏳ |
| 2 | User Identities | Create, configure, and manage Microsoft Entra identities | 6 | ⏳ 3.4h | 🔲 | 3.4h | ⏳ |
| 3 | User Identities | Implement and manage identities for external users and tenants | 6 | ⏳ 2.4h | 🔲 | 2.4h | ⏳ |
| 4 | User Identities | Implement and manage hybrid identity | 7 | ⏳ 1.3h | 🔲 | 1.3h | ⏳ |
| 5 | Authentication & Access Management | Plan, implement, and manage Microsoft Entra user authentication | 8 | ⏳ 1.1h | 🔲 | 1.1h | ⏳ |
| 6 | Authentication & Access Management | Plan, implement, and manage Microsoft Entra Conditional Access | 10 | ⏳ 8.7h | 🔲 | 8.7h | ⏳ |
| 7 | Authentication & Access Management | Manage risk by using Microsoft Entra ID Protection | 5 | ⏳ 1.0h | 🔲 | 1.0h | ⏳ |
| 8 | Authentication & Access Management | Implement Global Secure Access | 4 | ✅ 8.6h | ✅ | 8.6h | ✅ |
| 9 | Workload Identities | Plan and implement identities for applications and Azure workloads | 4 | ⏳ 2.5h | 🔲 | 2.5h | ⏳ |
| 10 | Workload Identities | Plan, implement, and monitor the integration of enterprise applications | 7 | ⏳ 3.1h | 🔲 | 3.1h | ⏳ |
| 11 | Workload Identities | Plan and implement app registrations | 5 | 🔲 | 🔲 | 0.0h | 🔲 |
| 12 | Workload Identities | Manage and monitor app access by using Microsoft Defender for Cloud Apps | 7 | ⏳ 8.7h | 🔲 | 8.7h | ✅ |
| 13 | Identity Governance | Plan and implement entitlement management in Microsoft Entra | 7 | ✅ 7.9h | 🔲 | 7.9h | ✅ |
| 14 | Identity Governance | Plan, implement, and manage access reviews in Microsoft Entra | 4 | 🔲 | 🔲 | 0.0h | 🔲 |
| 15 | Identity Governance | Plan and implement privileged access | 6 | 🔲 | 🔲 | 0.0h | 🔲 |
| 16 | Identity Governance | Monitor identity activity by using logs, workbooks, and reports | 5 | 🔲 | 🔲 | 0.0h | 🔲 |

**Modalities:**

- **NB** (NotebookLM) — Generated practice quizzes based on Microsoft Documentation sources
- **PQ** (PracticeQuestion) — Practice questions from MeasureUp or Microsoft assessment

---