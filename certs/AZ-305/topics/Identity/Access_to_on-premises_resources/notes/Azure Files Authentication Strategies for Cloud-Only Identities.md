# Azure Files Authentication Strategies for Cloud-Only Identities

Great job on selecting the correct answer! This question tests your understanding of the different identity sources supported by Azure Files for SMB access and how to map them to specific organizational constraints.

Here is a detailed breakdown of why **Microsoft Entra Kerberos** is the exact right answer for this scenario, and why the other options fail the requirements:

**1. Why On-premises AD DS is incorrect**
While you can use traditional on-premises Active Directory Domain Services (AD DS) to authenticate to Azure file shares, it requires two things this organization lacks:
*   Identities must be synced from on-premises to Microsoft Entra ID (hybrid identities), which violates the "cloud-only users" requirement [1].
*   Client devices must have unimpeded network connectivity (line-of-sight) to the on-premises domain controllers to request Kerberos tickets [1, 2].

**2. Why Microsoft Entra Domain Services is incorrect**
Microsoft Entra Domain Services provides managed domain services in the cloud, which is a great bridge for "lift-and-shift" scenarios where legacy applications need AD features [3, 4]. However, this service works by spinning up two Microsoft-managed domain controllers in your Azure virtual network [5]. Because the scenario explicitly states you must accomplish this *without* deploying managed domain controllers in Azure, this option is eliminated [6].

**3. Why Microsoft Entra Kerberos is correct**
Microsoft Entra Kerberos is designed specifically to overcome the limitations of legacy Active Directory infrastructure. 
*   **Cloud-only support:** It natively supports cloud-only identities, meaning no on-premises Active Directory or hybrid sync tools are required [7, 8].
*   **No domain controllers needed:** Instead of relying on a traditional domain controller, Microsoft Entra ID itself issues the Kerberos tickets required to access the file share via the SMB protocol [9, 10]. 
*   **No line-of-sight needed:** Because Entra ID handles the authentication and ticket granting directly, end users can access the Azure file shares securely over the internet from Microsoft Entra-joined VMs without ever needing network connectivity to a domain controller [9-11].

**Architectural Takeaway for the AZ-305 Exam:**
When designing identity-based authentication for Azure Files, memorize these three boundaries:
*   Use **On-premises AD DS** if the organization has an existing on-premises domain, hybrid users, and clients have network line-of-sight to the on-premises domain controllers [12].
*   Use **Microsoft Entra Domain Services** if you are lifting and shifting legacy applications that require traditional domain-join, but you do not want to manage the domain controllers yourself [3, 13].
*   Use **Microsoft Entra Kerberos** if you want to authenticate cloud-only users, eliminate reliance on domain controllers, and allow users to access file shares securely from anywhere [11, 13].