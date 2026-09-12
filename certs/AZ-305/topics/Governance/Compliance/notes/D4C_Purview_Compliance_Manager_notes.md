# Defender for Cloud / Purview Compliance Manager — ISO 27001 Notes

## 1. Enabling ISO 27001 in Defender for Cloud

**Question:**
In Defender for Cloud, I have enabled Defender CSPM for an Azure subscription. This is supposed to give me regulatory compliance. How do I introduce ISO 27001 compliance standard?

**Answer:**
With **Defender CSPM enabled**, additional regulatory standards can be added beyond the default **Microsoft Cloud Security Benchmark (MCSB)**.

For a current implementation, use **ISO/IEC 27001:2022**.

In the Azure portal:

1. Open **Microsoft Defender for Cloud**.
2. Go to **Regulatory compliance**.
3. Select **Manage compliance policies**.
4. Select the Azure subscription or management group.
5. Open **Security policies**.
6. Locate **ISO IEC 27001:2022**.
7. Turn it **On**.
8. Configure any requested parameters and save.

For an Azure Landing Zone environment, assigning the standard at the appropriate **management-group level** is preferable when multiple subscriptions should inherit it.

The standard is backed by Azure Policy assessments and then surfaced through the Defender for Cloud Regulatory Compliance experience.

Important distinction:

> Enabling ISO 27001 in Defender for Cloud does not make the organization ISO 27001 certified.

Defender evaluates technical Azure controls that can be assessed automatically. ISO 27001 also contains organizational, procedural, personnel, physical-security, ISMS, and other controls that Defender cannot automatically evaluate.

For new implementations, **ISO/IEC 27001:2022** should generally be preferred over the older **2013** framework.

---

## 2. How long until the standard appears?

**Question:**
I just enabled the ISO 27001 standard for a subscription. How long does it take for it to appear as a standard under the Regulatory Compliance section?

**Answer:**
Allow approximately **12 hours** for Defender for Cloud's compliance assessment cycle.

A reasonable troubleshooting timeline is:

* **0–12 hours:** normal propagation/evaluation period.
* **After 12 hours:** verify the standard is still enabled under the subscription's security/compliance policies.
* **After ~24 hours:** investigate the policy assignment and Defender assessment state if it still does not appear.

The standard may appear before all individual controls have completed evaluation.

A standard might also not appear if there are no resources in the subscription relevant to its assessments.

---

## 3. Can regulatory standards be enabled without Defender CSPM?

**Question:**
Can I enable these compliance standards for subscriptions that don't have a paid Defender plan, e.g. Defender CSPM?

**Answer:**
Defender CSPM specifically is **not necessarily required**, but the Defender for Cloud Regulatory Compliance experience for additional standards generally requires a qualifying paid Defender plan.

Conceptually:

| Defender configuration                    | Regulatory Compliance                                  |
| ----------------------------------------- | ------------------------------------------------------ |
| Free/foundational posture management only | MCSB                                                   |
| Qualifying paid Defender plan             | Additional regulatory standards can be available       |
| Defender CSPM                             | Additional standards plus the broader CSPM feature set |

Therefore, Defender CSPM does not necessarily need to be licensed solely for the purpose of displaying additional regulatory standards if another qualifying Defender plan provides the entitlement.

---

## 4. Management-group ISO assignment without paid Defender

**Question:**
Let's say that I do not have any paid Defender plans. Can I still enable ISO 27001 at the management group level?

**Answer:**
Yes, but there are two separate concepts:

### Azure Policy

You can assign Microsoft's built-in **ISO/IEC 27001:2022 Azure Policy initiative** at a management-group scope.

That assignment can inherit down to subscriptions regardless of whether those subscriptions have Defender CSPM.

Example:

```text
Management Group
│
├── ISO/IEC 27001:2022 Azure Policy initiative
│
├── Subscription A
│   └── No paid Defender plan
│       └── Azure Policy compliance available
│
├── Subscription B
│   └── No paid Defender plan
│       └── Azure Policy compliance available
│
└── Subscription C
    └── Defender CSPM
        ├── Azure Policy compliance
        └── Defender Regulatory Compliance experience
```

### Defender for Cloud

Assigning the Azure Policy initiative at the management group does **not bypass Defender licensing requirements** for Defender for Cloud's Regulatory Compliance dashboard.

Therefore:

> If the objective is governance and technical Azure compliance, Azure Policy can be used independently of Defender CSPM.

Again, Azure Policy compliance against the built-in initiative does not equal organizational ISO certification.

---

# Purview Compliance Manager

## 5. Does Defender CSPM include the Purview ISO 27001 regulation?

**Question:**
Let's say that I want to use Purview Compliance Manager to evaluate ISO 27001 compliance. Do I need to purchase the ISO 27001 compliance pack if I have purchased Defender CSPM?

**Answer:**
**Defender CSPM and Microsoft Purview Compliance Manager are separate licensing models.**

Buying Defender CSPM does **not** license the ISO 27001 regulation in Purview Compliance Manager.

ISO/IEC 27001:2022 is treated as a **premium regulation** in Compliance Manager.

The licensing relationship is approximately:

```text
Azure
└── Defender CSPM
    └── Defender for Cloud Regulatory Compliance
        └── ISO/IEC 27001:2022

Microsoft Purview
└── Compliance Manager
    └── ISO/IEC 27001:2022
        └── Separate Compliance Manager entitlement
```

Depending on the organization's Microsoft 365/Purview licensing, some premium regulations may already be included.

For qualifying licensing that provides **three premium regulations**, ISO 27001 can consume one of those three entitlements instead of requiring a separate purchase.

Thus:

> Defender CSPM entitlement does not determine whether ISO 27001 is licensed in Purview.

---

# ISO 27001:2022 and Azure in Purview

## 6. ISO 27001:2022 does not appear under the Azure service filter

**Question:**
For the Azure service, I don't see ISO 27001:2022 as an option.

The first screenshot showed:

### Sub-Service Compliance Readiness

* PCI DSS v4.0
* System and Organization Controls (SOC) 2
* ISO/IEC 27001:2013
* NIST 800-53 rev.4

These entries showed **Azure** as the service.

### Premium templates

Several premium templates appeared, including **ISO/IEC 27001:2013**, but ISO 27001:2022 did not appear while filtering specifically for Azure.

**Answer:**
The important distinction is that Purview Compliance Manager contains **ISO/IEC 27001:2022**, but it does not currently expose an Azure-specific 2022 template in the same way it does for ISO/IEC 27001:2013.

For an Azure-focused ISO 27001:2022 implementation:

```text
ISO/IEC 27001:2022
│
├── Purview Compliance Manager
│   └── Organizational compliance management
│
└── Azure
    ├── Defender for Cloud
    │   └── ISO IEC 27001:2022
    │
    └── Azure Policy
        └── ISO/IEC 27001:2022 initiative
```

The older **2013** standard has deeper Azure-specific integration in Compliance Manager.

---

## 7. Removing the Azure filter reveals ISO 27001:2022

**Question / Screenshot:**
After removing the Azure filter and searching for `27001`, the following appeared:

### Sub-Service Compliance Readiness

**ISO/IEC 27001:2013**

* Availability: Pre-Deployment
* Activation: Active
* Services: Azure

### Premium templates

**ISO/IEC 27001:2022**

* Status: Ready to use
* Availability: Premium
* Activation: Active
* Services: **Microsoft 365, Universal**

**ISO/IEC 27001:2013**

* Availability: Premium
* Services including:

  * Azure
  * Salesforce
  * Universal
  * Microsoft 365
  * Google Cloud Platform
  * Zoom

The page also showed:

```text
Free regulation licenses used:       0 / 0
Purchased regulation licenses used:  1 / 3
```

**Answer:**
This confirms the version-specific distinction.

### ISO/IEC 27001:2022

Purview currently exposes it for:

```text
Microsoft 365
Universal
```

It does **not** show Azure as a service.

### ISO/IEC 27001:2013

Purview exposes Azure-specific content for this older version.

Therefore the practical division is:

| Requirement                                          | Tool                                     |
| ---------------------------------------------------- | ---------------------------------------- |
| Assess Azure configuration against ISO 27001:2022    | Defender for Cloud                       |
| Audit/enforce Azure technical controls               | Azure Policy                             |
| Track broad ISO 27001:2022 organizational compliance | Purview Compliance Manager Universal     |
| Assess Microsoft 365 against ISO 27001:2022          | Purview Compliance Manager Microsoft 365 |

The **Universal** template is important because it allows the organization to track the overall ISO program even when Purview cannot automatically assess a particular cloud platform.

Universal assessments generally require more manual implementation, evidence gathering, testing, and attestation.

---

# Activating and deactivating Purview regulations

## 8. How is a regulation activated?

**Question:**
How can I activate and deactivate a regulation in Purview Compliance Manager?

**Answer:**
There generally isn't an independent **Activate/Deactivate** toggle for a normal regulation.

Activation is driven by whether the regulation is being used by an assessment.

### Activate

Create an assessment based on the regulation:

```text
Compliance Manager
   ↓
Assessments
   ↓
Add assessment
   ↓
Select regulation
   ↓
Select service/template
   ↓
Create
```

Once an assessment uses that regulation, its activation state becomes **Active**.

For a premium regulation, this can also consume one of the organization's premium regulation entitlements.

### Deactivate

Remove/delete all assessments using that regulation.

Once nothing is using the regulation, it should become **Inactive**.

However:

> Making a regulation inactive in Compliance Manager does not necessarily cancel a separately purchased subscription or licensing commitment.

Licensing and assessment usage are related but are not identical concepts.

---

# Pre-Deployment / Sub-Service Compliance Readiness

## 9. What does "Pre-Deployment" mean?

**Question / Screenshot:**
Filtering the Regulations page to **Activation: Active** showed seven items.

### Sub-Service Compliance Readiness

All had:

```text
Availability: Pre-Deployment
Activation: Active
Services: Azure
```

The entries were:

* PCI DSS v4.0
* System and Organization Controls (SOC) 2
* ISO/IEC 27001:2013
* NIST 800-53 rev.4

### Included templates

* Data Protection Baseline
* AI Baseline

### Premium templates

* ISO/IEC 27001:2022

The page still showed:

```text
Free regulation licenses used:       0 / 0
Purchased regulation licenses used:  1 / 3
```

**Question:**
What does a regulation in pre-deployment mean? How can I manage that?

**Answer:**
**Pre-Deployment** represents Microsoft's **Sub-Service Compliance Readiness** capability.

It is different from a normal Compliance Manager assessment.

Its purpose is to help determine how Azure services and configurations support a compliance framework **before deploying or assessing a specific production environment**.

Think of it as:

```text
Compliance Readiness
│
├── What controls does Microsoft handle?
├── What controls does the customer handle?
├── Which Azure services are relevant?
├── Which technical configurations are required?
└── Which Azure policies or controls support the requirement?
```

It is **not** equivalent to:

```text
Subscription XYZ
│
└── ISO 27001 compliance score = 82%
```

That type of resource-specific technical assessment belongs more naturally in Defender for Cloud and Azure Policy.

---

## 10. What can be done with Pre-Deployment content?

The readiness content can be used to review:

* Customer responsibilities
* Microsoft responsibilities
* Regulatory control mappings
* Azure service applicability
* Technical implementation guidance
* Microsoft Cloud Security Benchmark relationships
* Relevant Azure Policy controls
* Implementation evidence and guidance

It can also serve as planning material when designing an Azure environment before workloads are deployed.

The currently exposed frameworks include:

* ISO/IEC 27001:2013
* NIST 800-53 rev.4
* PCI DSS v4.0
* SOC 2

---

## 11. Does "Active" on a Pre-Deployment item consume a license?

No.

This is an important UI distinction.

Even though the Pre-Deployment rows show:

```text
Activation: Active
```

they are not normal regulation assessments and do not consume premium regulation licenses in the same way.

The screenshot demonstrates this:

```text
Four Pre-Deployment regulations: Active
Two included templates: Active
One Premium template: Active

Purchased regulation licenses used: 1 / 3
```

If every "Active" item represented a purchased regulation entitlement, the counter would be much higher.

Therefore:

> "Active" for Sub-Service Compliance Readiness should not be interpreted the same way as "Active" for a premium assessment template.

The Pre-Deployment content is Microsoft-provided readiness/reference content.

---

# Recommended ISO 27001:2022 architecture

For an organization using Azure and pursuing **ISO/IEC 27001:2022**, the tools have complementary roles:

```text
                     ISO/IEC 27001:2022
                              │
            ┌─────────────────┴─────────────────┐
            │                                   │
    Organizational program                 Azure controls
            │                                   │
            ▼                                   ▼
 Purview Compliance Manager           Defender for Cloud
    Universal Assessment             Regulatory Compliance
            │                                   │
     Policies / Evidence                  ISO 27001:2022
     Ownership / Testing                         │
     Manual controls                             │
     ISMS processes                              ▼
                                         Azure Policy
                                      ISO 27001:2022
                                          Initiative
```

### Purview Compliance Manager

Use for:

* Overall ISO program
* Control ownership
* Evidence
* Manual testing
* Organizational processes
* Policies and documentation
* Improvement actions
* Microsoft 365 controls where supported

### Defender for Cloud

Use for:

* Azure-specific technical posture
* Automated security assessments
* ISO 27001:2022 regulatory mappings
* Compliance dashboard
* Resource-level remediation

### Azure Policy

Use for:

* Continuous Azure configuration assessment
* Audit
* Deny
* DeployIfNotExists
* Modify
* Management-group governance
* ISO 27001:2022 initiative assignment

---

# Key conclusions

1. **Defender CSPM supports ISO/IEC 27001:2022 regulatory compliance for Azure.**

2. Allow approximately **12 hours** after enabling a standard for Defender for Cloud to evaluate and surface it.

3. **Azure Policy can assess ISO 27001 controls without Defender CSPM licensing.**

4. The ISO 27001:2022 Azure Policy initiative can be assigned at a **management group** and inherited by subscriptions.

5. **Defender CSPM and Purview Compliance Manager are separately licensed.**

6. Purchasing Defender CSPM does **not** grant a Purview ISO 27001 premium regulation entitlement.

7. Purview currently exposes **ISO/IEC 27001:2022** for:

   * Microsoft 365
   * Universal

8. Purview currently exposes deeper Azure-specific integration for **ISO/IEC 27001:2013**, including **Sub-Service Compliance Readiness**.

9. For Azure ISO 27001:2022 technical assessment, use:

   * **Defender for Cloud**
   * **Azure Policy**

10. For the broader organization's ISO 27001:2022 compliance program, use:

    * **Purview Compliance Manager Universal**

11. A normal Purview regulation becomes **Active** when an assessment uses it.

12. **Pre-Deployment** regulations are Microsoft-provided readiness content and should not be interpreted as normal licensed assessments.

13. Pre-Deployment entries can show **Active** without consuming premium regulation licenses.

14. The combined approach is:

```text
Purview Compliance Manager
        +
Defender for Cloud
        +
Azure Policy
        =
Broad organizational + Azure technical
ISO/IEC 27001:2022 compliance management
```
