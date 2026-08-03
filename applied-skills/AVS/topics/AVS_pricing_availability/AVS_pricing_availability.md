# Azure VMware Solution: Node Pricing and US SKU Availability

## 1. Executive summary

Azure VMware Solution pricing is calculated **per dedicated physical host**, not per VM, vCPU, or amount of consumed storage. A standard AVS private cloud requires at least **three hosts**, so the practical entry cost is three times the published single-node price. Microsoft also recommends designing for **N+1 redundancy**, meaning the three-node minimum should not automatically be treated as the ideal production configuration. ([Microsoft Learn][1])

The main planning conclusions are:

* **AV36P** is the lowest-cost actively priced Gen 1 host.
* **AV48** has attractive hardware and reservation pricing, but its documented US Gen 1 deployment region is currently **West US 2**, despite the Azure Pricing Calculator allowing an East US estimate.
* **AV52** is available only in **East US 2** and **South Central US** within the United States.
* **AV64 Gen 1** is generally an expansion host requiring an existing seed cluster.
* **AV64 Gen 2** can be deployed directly as a minimum three-host cluster and is the documented option for a net-new Gen 2 deployment.
* Pricing includes the Azure infrastructure and managed AVS service, but excludes the required portable **VMware Cloud Foundation subscription from Broadcom**.
* Published prices and calculator results are budgetary estimates rather than contractual quotes. ([Microsoft Azure][2])

---

# 2. Pricing assumptions

The calculations below use:

* **Currency:** USD
* **Monthly usage:** 730 hours
* **Annual usage:** 8,760 hours
* **Minimum deployment:** 3 nodes
* **AV48 region:** East US, based on the supplied Azure Pricing Calculator screenshots
* **Reservation payment option:** Monthly, where shown in the screenshot
* **VCF licensing:** Not included
* **Networking, public IPv4, storage extensions, backup, replication and other Azure services:** Not included

Microsoft states that prices vary based on agreement type, purchase date, currency and applicable program or offer. The Azure Pricing Calculator should therefore be used for the customer’s actual billing scope before reservations are purchased. ([Microsoft Azure][2])

---

# 3. AVS host specifications

The public pricing and architecture documentation describes the following host configurations. AVS clusters use hosts of the same type within a private cloud. ([Microsoft Learn][1])

| SKU            | Physical cores | Logical cores/vCPUs |    RAM | Published all-flash capacity | vSAN architecture |
| -------------- | -------------: | ------------------: | -----: | ---------------------------: | ----------------- |
| **AV36**       |             36 |                  72 | 576 GB |                      18.6 TB | OSA               |
| **AV36P**      |             36 |                  72 | 768 GB |                 20.7 TB NVMe | OSA               |
| **AV48**       |             48 |                  96 |   1 TB |                 25.6 TB NVMe | ESA               |
| **AV52**       |             52 |                 104 | 1.5 TB |                   40 TB NVMe | OSA               |
| **AV64 Gen 1** |             64 |                 128 |   1 TB |                 19.2 TB NVMe | OSA               |
| **AV64 Gen 2** |             64 |                 128 |   1 TB |   Approximately 19.2 TB NVMe | ESA               |

The AV48 calculator description specifically shows:

> 48 cores, 96 vCPUs, 1 TB RAM and 25.6 TB of vSAN capacity.

---

# 4. Per-node pricing

The AV36P, AV52 and AV64 figures below are the public rates surfaced by the Azure pricing table. The AV48 pay-as-you-go and three-year figures are calculated directly from the supplied East US calculator screenshots. ([Microsoft Azure][3])

## Monthly cost per node

| SKU                |           Pay as you go |             1-year reserved | 3-year reserved |             5-year reserved |
| ------------------ | ----------------------: | --------------------------: | --------------: | --------------------------: |
| **AV36 VCF BYOL**  | Not currently published |                         N/A |             N/A |                         N/A |
| **AV36P VCF BYOL** |           **$5,986.00** |               **$4,036.90** |   **$2,606.10** |                         N/A |
| **AV48 VCF BYOL**  |           **$7,978.90** | Approximately **$5,425.65** |   **$3,498.58** | Approximately **$3,510.72** |
| **AV52 VCF BYOL**  |           **$8,343.90** |               **$5,548.00** |   **$3,496.70** |                         N/A |
| **AV64 VCF BYOL**  |           **$8,343.90** |               **$5,548.00** |   **$3,496.70** |                         N/A |

## Effective hourly rate per node

| SKU       | Pay as you go |     1-year reserved | 3-year reserved |     5-year reserved |
| --------- | ------------: | ------------------: | --------------: | ------------------: |
| **AV36P** |         $8.20 |               $5.53 |           $3.57 |                 N/A |
| **AV48**  |        $10.93 | Approximately $7.43 |     **$4.7926** | Approximately $4.81 |
| **AV52**  |        $11.43 |               $7.60 |           $4.79 |                 N/A |
| **AV64**  |        $11.43 |               $7.60 |           $4.79 |                 N/A |

## Annualized cost per node

| SKU       | Pay as you go |          1-year reserved | 3-year annual equivalent |
| --------- | ------------: | -----------------------: | -----------------------: |
| **AV36P** |    $71,832.00 |               $48,442.80 |               $31,273.20 |
| **AV48**  |    $95,746.80 | Approximately $65,107.82 |           **$41,983.00** |
| **AV52**  |   $100,126.80 |               $66,576.00 |               $41,960.40 |
| **AV64**  |   $100,126.80 |               $66,576.00 |               $41,960.40 |

### AV48 approximation note

The AV48 calculator screenshots provide:

* The exact pay-as-you-go total
* The exact three-year reserved total
* An approximate **32% discount** for one year
* An approximate **56% discount** for five years

The one- and five-year figures above are therefore estimates calculated from the displayed discount percentages. They are not exact calculator totals.

---

# 5. Minimum three-node private-cloud costs

AVS requires a minimum initial deployment of three hosts. Published pricing is per node, so a valid initial private-cloud estimate must multiply the per-node amount by three. ([Microsoft Azure][2])

## Three-node monthly cost

| SKU           |  Pay as you go |              1-year reserved | 3-year reserved |
| ------------- | -------------: | ---------------------------: | --------------: |
| **3 × AV36P** | **$17,958.00** |               **$12,110.70** |   **$7,818.30** |
| **3 × AV48**  | **$23,936.70** | Approximately **$16,276.96** |  **$10,495.75** |
| **3 × AV52**  | **$25,031.70** |               **$16,644.00** |  **$10,490.10** |
| **3 × AV64**  | **$25,031.70** |               **$16,644.00** |  **$10,490.10** |

## Three-node annualized cost

| SKU           |   Pay as you go |           1-year reserved | 3-year annual equivalent |
| ------------- | --------------: | ------------------------: | -----------------------: |
| **3 × AV36P** |     $215,496.00 |               $145,328.40 |               $93,819.60 |
| **3 × AV48**  | **$287,240.40** | Approximately $195,323.47 |          **$125,949.00** |
| **3 × AV52**  |     $300,380.40 |               $199,728.00 |              $125,881.20 |
| **3 × AV64**  |     $300,380.40 |               $199,728.00 |              $125,881.20 |

The “three-year annual equivalent” is the average yearly cost during the reservation term, not the total three-year commitment.

---

# 6. Detailed AV48 estimate from the screenshots

The Azure Pricing Calculator was configured with:

* Region: **East US**
* Instance: **AV48 VCF BYOL**
* Quantity: **3 nodes**
* Usage: **730 hours per month**
* Payment: Monthly
* VCF licensing: Excluded

## AV48 pay as you go

| Measure               | Three-node cluster |       Per node |
| --------------------- | -----------------: | -------------: |
| Effective hourly rate |             $32.79 |     **$10.93** |
| Monthly cost          |     **$23,936.70** |  **$7,978.90** |
| Annual cost           |    **$287,240.40** | **$95,746.80** |
| Upfront payment       |                 $0 |             $0 |

## AV48 three-year reservation

| Measure                             |   Three-node cluster |        Per node |
| ----------------------------------- | -------------------: | --------------: |
| Effective hourly rate               | Approximately $14.38 |     **$4.7926** |
| Monthly payment                     |       **$10,495.75** |   **$3,498.58** |
| Annualized cost                     |      **$125,949.00** |  **$41,983.00** |
| Three-year total                    |      **$377,847.00** | **$125,949.00** |
| Upfront payment with monthly option |                   $0 |              $0 |

## AV48 three-year savings

| Savings measure    |          Amount |
| ------------------ | --------------: |
| Monthly savings    |  **$13,440.95** |
| Annualized savings | **$161,291.40** |
| Three-year savings | **$483,874.20** |
| Effective discount |      **56.15%** |

The calculator labels the three-year discount as approximately 56%; the exact displayed totals produce an effective discount of approximately 56.15%.

---

# 7. Pricing observations

## AV36P

AV36P has the lowest current published price:

* $5,986 per node per month on pay as you go
* $2,606.10 per node per month with a three-year reservation

It also has the broadest useful Gen 1 regional availability among currently priced seed-cluster SKUs.

## AV48

AV48 costs less than AV52 and AV64 on pay as you go:

* AV48: $7,978.90 per node per month
* AV52/AV64: $8,343.90 per node per month

However, under the three-year reservation, the prices become nearly identical:

* AV48: $3,498.58 per node per month
* AV52/AV64: $3,496.70 per node per month

The difference is less than $2 per node per month based on the displayed and rounded rates.

## AV52

AV52 provides:

* 52 physical cores
* 1.5 TB of RAM
* Approximately 40 TB of all-flash capacity

At the listed three-year rate, it costs essentially the same as AV48 and AV64. Its major limitation is regional availability: it is documented only in **East US 2** and **South Central US** in the United States.

## AV64

AV64 provides the most physical cores but less RAM than AV52:

* 64 physical cores
* 1 TB RAM
* Approximately 19.2 TB storage

The primary reason to select it may be its Gen 2 support and regional availability rather than storage density.

---

# 8. Gen 1 versus Gen 2 deployment model

## Gen 1

Gen 1 AVS uses an **ExpressRoute-based network attachment model**.

Supported host patterns are:

* AV36
* AV36P
* AV48
* AV52
* AV64 as an expansion host after establishing an eligible seed cluster

Microsoft’s architecture and Gen 2 introduction documentation state that a Gen 1 AV64 expansion can follow a seed cluster of at least three AV36, AV36P, AV48 or AV52 hosts. The pricing page currently omits AV36 from its AV64 prerequisite statement. Because the documents are inconsistent and AV36 pricing is no longer published, AV36-based expansion should be confirmed with Microsoft before relying on it. ([Microsoft Learn][1])

## Gen 2

Gen 2 AVS:

* Supports **AV64 only**
* Allows direct deployment of a minimum three-node AV64 cluster
* Does not require an AV36P, AV48 or AV52 seed cluster
* Is deployed inside an Azure virtual network
* Uses a VNet-based network attachment model rather than the Gen 1 ExpressRoute attachment
* Uses vSAN ESA
* Allows the availability zone to be selected during deployment when zonal alignment is required ([Microsoft Learn][4])

---

# 9. US regional availability summary

The following table combines the current Gen 1 host mapping and Gen 2 regional-availability documentation. ([Microsoft Learn][1])

| US region            | Gen 1 documented host types | Gen 2                |
| -------------------- | --------------------------- | -------------------- |
| **Central US**       | AV36, AV36P, AV64           | AV64                 |
| **East US**          | AV36, AV36P, AV64           | AV64                 |
| **East US 2**        | AV36, AV36P, AV52, AV64     | AV64                 |
| **North Central US** | AV36, AV36P, AV64           | AV64                 |
| **South Central US** | AV36, AV36P, AV52, AV64     | AV64                 |
| **West US**          | AV36, AV36P, AV64           | Not currently listed |
| **West US 2**        | AV36, AV36P, AV48, AV64     | AV64                 |
| **West US 3**        | AV36P, AV64                 | Not currently listed |

The six currently documented US Gen 2 regions are:

* Central US
* East US
* East US 2
* North Central US
* South Central US
* West US 2

Microsoft notes that Gen 2 might also be available in regions not yet included in the published list, but such availability must be confirmed through the Microsoft account team or Support. ([Microsoft Learn][4])

---

# 10. Gen 1 availability-zone mapping in US regions

Gen 1 host availability is tied to a physical availability zone. Customers normally select the region, while Azure automatically assigns the zone. A specific-zone requirement requires a Microsoft support request for a special placement policy. ([Microsoft Learn][1])

| Region               | Availability zone | Documented host types   |
| -------------------- | ----------------- | ----------------------- |
| **Central US**       | AZ01              | AV36P, AV64             |
|                      | AZ02              | AV36, AV64              |
|                      | AZ03              | AV36P, AV64             |
| **East US**          | AZ01              | AV36P, AV64             |
|                      | AZ02              | AV36P, AV64             |
|                      | AZ03              | AV36, AV36P, AV64       |
| **East US 2**        | AZ01              | AV36, AV64              |
|                      | AZ02              | AV36P, AV52, AV64       |
|                      | AZ03              | AV36P, AV64             |
| **North Central US** | AZ01              | AV36, AV64              |
|                      | AZ02              | AV36P, AV64             |
| **South Central US** | AZ01              | AV36, AV64              |
|                      | AZ02              | AV36, AV36P, AV52, AV64 |
| **West US**          | AZ01              | AV36, AV36P, AV64       |
| **West US 2**        | AZ01              | AV36, AV64              |
|                      | AZ02              | AV36P, AV64             |
|                      | AZ03              | AV48                    |
| **West US 3**        | AZ01              | AV36P, AV64             |

This mapping has direct architectural implications:

* AV48 is isolated to **West US 2 AZ03** in the documented US Gen 1 table.
* AV52 is isolated to **East US 2 AZ02** and **South Central US AZ02**.
* AV36P has the broadest coverage across the listed US regions.
* AV64 is broadly mapped but follows different deployment rules for Gen 1 and Gen 2.

---

# 11. SKU-specific US deployment guidance

| SKU       | Gen 1 US availability                                                                  | Gen 2 support | Planning guidance                                                                                                  |
| --------- | -------------------------------------------------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------ |
| **AV36**  | Central US, East US, East US 2, North Central US, South Central US, West US, West US 2 | No            | Legacy Gen 1 SKU; no current public price is shown. Confirm new capacity and lifecycle suitability.                |
| **AV36P** | All eight listed US AVS regions                                                        | No            | Best-covered currently priced Gen 1 seed-host SKU.                                                                 |
| **AV48**  | West US 2 only                                                                         | No            | Documented in West US 2 AZ03. Treat East US calculator pricing as budgetary until deployment support is confirmed. |
| **AV52**  | East US 2 and South Central US                                                         | No            | High-memory and high-storage Gen 1 option, but only in two US regions.                                             |
| **AV64**  | All eight listed US regions, generally as a Gen 1 expansion host                       | Yes           | Direct three-node deployment is supported with Gen 2 in the six listed US Gen 2 regions.                           |

---

# 12. East US AV48 pricing-versus-availability conflict

The supplied calculator screenshot shows that Azure permits an estimate with:

* Region: **East US**
* SKU: **AV48 VCF BYOL**
* Three-node pay-as-you-go cost: **$23,936.70 per month**
* Three-node three-year reserved cost: **$10,495.75 per month**

However:

* The Gen 1 region-to-host mapping does **not** list AV48 in East US.
* It lists AV48 only in **West US 2 AZ03** within the United States.
* Gen 2 supports only AV64, so the East US AV48 calculator entry cannot represent a documented Gen 2 deployment. ([Microsoft Learn][1])

The safest interpretation is:

> **The East US AV48 calculator output is a budgetary pricing reference and should not be considered proof that AV48 capacity can be provisioned in East US.**

Before using AV48 in an East US design, obtain confirmation through an AVS quota request, Microsoft account team or Microsoft Support.

---

# 13. Quota and capacity requirements

Documented regional availability does not guarantee that physical hosts are immediately available.

Before deployment, submit an AVS quota request containing:

* Subscription
* Requested Azure region
* Requested SKU
* Total number of nodes required

Microsoft states that host allocation can take up to **five business days**, depending on the requested quantity. Unused quota normally expires after 30 days, although quota corresponding to AVS reserved instances does not expire under the same rule. ([Microsoft Learn][5])

For a specific availability-zone requirement:

1. Obtain the regional host quota.
2. Open a technical support request before provisioning.
3. Request the required region, zone and host type.

This can be important when AVS must align with zonal services such as Azure NetApp Files or other zone-sensitive infrastructure. ([Microsoft Learn][1])

---

# 14. Licensing and excluded charges

AVS pricing includes:

* Dedicated Azure bare-metal infrastructure
* The managed Azure VMware Solution service
* Operation of the underlying VMware environment by Microsoft

AVS pricing does not include:

* The portable VMware Cloud Foundation subscription required from Broadcom
* Public IPv4 prefixes or addresses
* Azure networking services
* ExpressRoute or virtual WAN gateways
* Azure Firewall or third-party NVAs
* Azure NetApp Files
* Azure Elastic SAN
* Backup and disaster-recovery products
* JetStream, Zerto or other third-party software
* Data-transfer and egress charges
* Additional monitoring or security services

Microsoft currently requires customers to provide portable VCF licenses for new AVS deployments and add-on capacity. Public IPv4 resources consumed directly by AVS are billed separately using Azure public IPv4 pricing. ([Microsoft Azure][2])

---

# 15. Recommended interpretation for an East US DR design

For a net-new private cloud intended for **East US**:

## Preferred Gen 2 option

Use **AV64 Gen 2** when:

* A direct three-node AV64 deployment is acceptable
* VNet-native connectivity is preferred
* vSAN ESA is desired
* The design benefits from selecting the availability zone
* AV64 compute and storage characteristics meet the workload requirements

## Gen 1 option

Use **AV36P Gen 1** when:

* A lower-cost entry point is required
* The traditional Gen 1 ExpressRoute attachment model is acceptable
* AV36P capacity is confirmed in the required East US availability zone

AV64 can potentially be added later as expansion capacity, subject to the current seed-cluster rules and quota confirmation.

## AV48

Do not treat the East US AV48 calculator estimate as a deployable design until Microsoft confirms availability.

The documented US region for AV48 is West US 2.

## AV52

AV52 is not currently documented for East US.

The nearest documented eastern option is **East US 2 AZ02**.

---

# 16. Bottom line

For cost planning:

* **Lowest-priced Gen 1:** AV36P
* **Best AV48 three-node three-year estimate:** $10,495.75 per month
* **AV52 and AV64 three-year pricing:** Approximately the same as AV48
* **Direct Gen 2 deployment:** AV64 only
* **Documented East US options:** AV36, AV36P and AV64 for Gen 1; AV64 for Gen 2
* **Documented AV48 US region:** West US 2 only
* **Documented AV52 US regions:** East US 2 and South Central US
* **Required initial size:** Minimum three nodes
* **Production design recommendation:** Consider N+1 rather than relying solely on the three-node minimum
* **VCF licensing:** Customer-provided and excluded from Azure node pricing
* **Final action before commitment:** Confirm SKU, region, zone and physical capacity through the AVS quota process before purchasing reservations.

[1]: https://learn.microsoft.com/en-us/azure/azure-vmware/architecture-private-clouds "Architecture for Private Clouds and Clusters - Azure VMware Solution | Microsoft Learn"
[2]: https://azure.microsoft.com/en-us/pricing/details/azure-vmware/ "Pricing - Azure VMware Solution | Microsoft Azure"
[3]: https://azure.microsoft.com/en-us/pricing/details/azure-vmware/?utm_source=chatgpt.com "Azure VMware Solution pricing"
[4]: https://learn.microsoft.com/en-us/azure/azure-vmware/native-introduction "Introduction to Azure VMware Solution Generation 2 Private Clouds - Azure VMware Solution | Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/azure/azure-vmware/request-host-quota-azure-vmware-solution "Request host quota for Azure VMware Solution - Azure VMware Solution | Microsoft Learn"
