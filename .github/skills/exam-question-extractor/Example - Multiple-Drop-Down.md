Here is an example output of a multiple drop-down question extracted from a practice exam, following the formatting guidelines in the SKILL.md file:

---

### Configure Azure DNS Round-Robin

You are asked to configure Azure DNS records for the root domain company1.com and add two records to that zone for independently hosted websites on different servers but using the same alias of “www”. These servers will round-robin the DNS requests for high availability of the service. The time to live for the records must also be set to one hour.

You need to configure Azure DNS to support the requirements.

How should you complete the Azure PowerShell script? To answer, select the appropriate options from the drop-down menus.

```powershell
[Select 1 ▼] -Name "@" -RecordType A -ZoneName "company1.com"
-ResourceGroupName "MyResourceGroup" -Ttl [Select 2 ▼] -DnsRecords `
[Select 3 ▼] -Ipv4Address "1.2.3.4"
$aRecords = @()
$aRecords += [Select 4 ▼] -Ipv4Address "2.3.4.5"
$aRecords += [Select 5 ▼] -Ipv4Address "3.4.5.6"
[Select 6 ▼] -Name "www" -ZoneName "company1.com"
-ResourceGroupName MyResourceGroup -Ttl [Select 7 ▼] -RecordType A -DnsRecords $aRecords
```

**Select 1 options:**  
○ New-AzDnsRecordConfig  
○ New-AzDnsRecordSet  
○ New-AzDnsZone  

**Select 2 options:**  
○ 1  
○ 60  
○ 3600  

**Select 3 options:**  
○ New-AzDnsRecordConfig  
○ New-AzDnsRecordSet  
○ Set-AzDnsRecordConfig  

**Select 4 options:**  
○ New-AzDnsRecordConfig  
○ New-AzDnsRecordSet  
○ Set-AzDnsRecordConfig  

**Select 5 options:**  
○ New-AzDnsRecordConfig  
○ New-AzDnsRecordSet  
○ Set-AzDnsRecordConfig  

**Select 6 options:**  
○ New-AzDnsRecordConfig  
○ New-AzDnsRecordSet  
○ Set-AzDnsRecordConfig  

**Select 7 options:**  
○ 1  
○ 60  
○ 3600  

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-20-11-16-41.png' width=700>

</details>

<details open>
<summary>💡 Click to expand explanation</summary>

</details>

▶ Related Lab: []()
