# Lab: {{Lab Title}}

**Domain:** {{Exam Domain}}  
**Subskill(s):** {{Exact bullet(s) from the official AZ-104 outline}}  
**Difficulty:** 🟠 Medium | 🔴 Hard  
**Estimated Duration:** 1.5–2 hours  
**Status:** ☐ Not Started  
**Start Date:** YYYY-MM-DD  
**Completion Date:** —  
**Modalities:** Portal • CLI • PowerShell • Bicep • Terraform

---

## 🎯 Scenario

{{Provide a brief business or operational scenario that drives this lab.  
Explain *why* the skill matters (e.g., compliance, security, automation).  
Example: "You have been tasked with creating secure access to Azure Storage for  
a distributed app using SAS and Azure AD-based access."}}

---

## 🧩 Learning Objectives

By the end of this lab, you will be able to:

1. {{Objective 1}}  
2. {{Objective 2}}  
3. {{Objective 3}}

---

## 🧱 Lab Architecture

```text
{{Optional ASCII diagram or high-level architecture}}
```

---

## 🧰 Prerequisites

- Active Azure subscription with **Contributor** or higher privileges  
- Latest versions of:  
  - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
  - [Az PowerShell Module](https://learn.microsoft.com/en-us/powershell/azure/install-az-ps)  
- Optional:  
  - Visual Studio Code with Bicep and Terraform extensions  
  - Azure Storage Explorer / AzCopy (if relevant)

---

## ⚙️ Part 1 – Portal Steps

1. Navigate to **{{Azure service}}** in the Portal.  
2. {{Describe key configuration steps.}}  
3. Take screenshots of:  
   - Configuration page  
   - Resource overview  
   - Verification screen

📂 Save in: `./artifacts/screenshots/`

---

## 💻 Part 2 – Azure CLI

```bash
# Example
az group create --name LabRG01 --location eastus

{{Add CLI commands relevant to this lab.}}
```

📂 Save CLI output logs to: `./artifacts/logs/cli_output.log`

---

## 💻 Part 3 – PowerShell

```powershell
# Example
New-AzResourceGroup -Name "LabRG01" -Location "EastUS"

{{Add PowerShell equivalents for the CLI actions.}}
```

📂 Save PowerShell session transcript:

```powershell
Start-Transcript -Path "./artifacts/logs/powershell_transcript.txt"
```

---

## 🧱 Part 4 – Infrastructure as Code (Bicep)

```bicep
// Example
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'LabRG01'
  location: 'eastus'
}
```

Deploy:

```bash
az deployment sub create --location eastus --template-file ./bicep/main.bicep
```

📂 Files live in: `./bicep/`

---

## 🌍 Part 5 – Infrastructure as Code (Terraform)

```hcl
# Example
resource "azurerm_resource_group" "lab" {
  name     = "LabRG01"
  location = "East US"
}
```

Commands:

```bash
terraform init
terraform plan
terraform apply
```

📂 Files live in: `./terraform/`

---

## 🧪 Part 6 – Verification and Validation

| Verification Step | Method / Command | Expected Result |
|-------------------|------------------|-----------------|
| {{Check 1}} | {{CLI/Portal step}} | {{Expected output}} |
| {{Check 2}} | {{PowerShell command}} | {{Expected output}} |
| {{Check 3}} | {{Portal view}} | {{Expected configuration}} |

📂 Save evidence (screenshots, logs, exports) in `./artifacts/exports/`

---

## 🧹 Part 7 – Cleanup

### CLI

```bash
az group delete --name LabRG01 --yes --no-wait
```

### PowerShell

```powershell
Remove-AzResourceGroup -Name "LabRG01" -Force
```

---

## 🧠 Reflection

| Question | Your Notes |
|-----------|-------------|
| What concept took the most time to understand? |  |
| Which Azure docs did you consult? |  |
| What command or parameter was new to you? |  |
| What would you automate next time? |  |

---

## 🔗 Documentation References

| Topic | URL |
|-------|-----|
| {{Doc Title 1}} | [https://learn.microsoft.com/en-us/](tbd)... |
| {{Doc Title 2}} | [https://learn.microsoft.com/en-us/](tbd)... |

---

## 📁 Artifact Index

| Category | Folder | Description |
|-----------|---------|-------------|
| Screenshots | `./artifacts/screenshots/` | Key UI captures |
| Logs | `./artifacts/logs/` | CLI/PowerShell transcripts |
| Configs | `./artifacts/configs/` | JSON/YAML exports |
| Outputs | `./artifacts/outputs/` | Deployment results |
| Exports | `./artifacts/exports/` | Downloaded reports |

---

## ✅ Completion Checklist

- [ ] All required steps executed successfully  
- [ ] Validation confirmed expected outcomes  
- [ ] Artifacts uploaded to correct folders  
- [ ] Cleanup completed  
- [ ] Reflection notes written

---

> 💡 **Tip:** Commit and push this lab once complete. Include screenshots and logs in  
> your `artifacts/` subfolder for traceability and later review.
