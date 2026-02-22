Here is an example output of a multiple drop-down question extracted from a practice exam, following the formatting guidelines in the SKILL.md file:

---

### Configure Azure DNS Round-Robin

You are asked to configure Azure DNS records for the root domain company1.com and add two records to that zone for independently hosted websites on different servers but using the same alias of “www”. These servers will round-robin the DNS requests for high availability of the service. The time to live for the records must also be set to one hour.

You need to configure Azure DNS to support the requirements.

How should you complete the Azure PowerShell script? To answer, select the appropriate options from the drop-down menus.

```powershell
___[1]___ -Name "@" -RecordType A -ZoneName "company1.com"
-ResourceGroupName "MyResourceGroup" -Ttl ___[2]___ -DnsRecords `
___[3]___ -Ipv4Address "1.2.3.4"
$aRecords = @()
$aRecords += ___[4]___ -Ipv4Address "2.3.4.5"
$aRecords += ___[5]___ -Ipv4Address "3.4.5.6"
___[6]___ -Name "www" -ZoneName "company1.com"
-ResourceGroupName MyResourceGroup -Ttl ___[7]___ -RecordType A -DnsRecords $aRecords
```

Drop-Down Options:

| Blank | Options |
|-------|---------|
| [1] | New-AzDnsRecordConfig / New-AzDnsRecordSet / New-AzDnsZone |
| [2] | 1 / 60 / 3600 |
| [3] | New-AzDnsRecordConfig / New-AzDnsRecordSet / Set-AzDnsRecordConfig |
| [4] | New-AzDnsRecordConfig / New-AzDnsRecordSet / Set-AzDnsRecordConfig |
| [5] | New-AzDnsRecordConfig / New-AzDnsRecordSet / Set-AzDnsRecordConfig |
| [6] | New-AzDnsRecordConfig / New-AzDnsRecordSet / Set-AzDnsRecordConfig |
| [7] | 1 / 60 / 3600 |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-20-11-16-41.png' width=700>

</details>

<details open>
<summary>💡 Click to expand explanation</summary>

</details>

▶ Related Lab: []()
