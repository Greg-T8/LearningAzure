The names are confusing because all three provide hardware-backed cryptographic key protection, but they expose very different **administrative and integration models**:

* **Managed HSM:** Azure manages the HSM platform; you manage keys and permissions.
* **Cloud HSM:** Azure manages the cluster infrastructure; you administer the HSM itself.
* **Dedicated HSM:** You administer an entire physical HSM appliance and most of its operations.

## Comparison

| Characteristic                  | Key Vault Managed HSM                                     | Azure Cloud HSM                                                 | Azure Dedicated HSM                                            |
| ------------------------------- | --------------------------------------------------------- | --------------------------------------------------------------- | -------------------------------------------------------------- |
| Basic model                     | Azure-native managed key service                          | Customer-administered HSM cluster as a service                  | Dedicated physical HSM appliance hosted in Azure               |
| Isolation boundary              | Customer-specific HSM partitions and security domain      | Customer-specific three-node HSM cluster and security domain    | Entire physical appliance dedicated to one customer            |
| Underlying hardware             | Marvell LiquidSecurity HSM partitions                     | Marvell LiquidSecurity HSM nodes                                | Thales Luna 7 A790 appliance                                   |
| Certification                   | FIPS 140-3 Level 3                                        | FIPS 140-3 Level 3                                              | FIPS 140-2 Level 3                                             |
| Customer administration         | Keys, policies and RBAC                                   | HSM users, credentials, keys and cryptographic policies         | Entire appliance, partitions, users, firmware and keys         |
| Microsoft responsibility        | Provisioning, configuration, patching, HA and maintenance | Cluster HA, firmware, patching, maintenance and hardware health | Datacenter hosting, physical hardware and network connectivity |
| Primary interface               | Key Vault REST API, SDKs, CLI and PowerShell              | PKCS#11, OpenSSL, JCE, KSP and CNG                              | Thales PKCS#11, JCA/JCE, CAPI/CNG and OpenSSL                  |
| Azure PaaS/SaaS CMK integration | Yes, for supported Azure and Microsoft services           | No                                                              | No                                                             |
| Typical workload                | Azure-native encryption and customer-managed keys         | Traditional HSM-integrated applications running in Azure        | Existing legacy Thales Luna deployments                        |
| Current status                  | Strategic service                                         | Strategic successor to Dedicated HSM                            | Retiring; unavailable to new customers                         |

## 1. Azure Key Vault Managed HSM

Managed HSM is best understood as **a single-tenant version of Azure’s managed key service**.

You do not log in to an HSM appliance, create appliance partitions, maintain firmware, or build an HSM high-availability group. Microsoft handles provisioning, configuration, patching, maintenance and hardware availability. You interact with the service through Microsoft Entra authentication, Managed HSM RBAC, the Key Vault REST API and related SDKs. ([Microsoft Learn][1])

Its single-tenant isolation is **cryptographic rather than necessarily physical**:

```text
Shared Azure HSM hardware fleet
└── Customer A Managed HSM
    ├── Isolated HSM partitions
    └── Customer A security domain
```

A Managed HSM instance has its own security domain and is cryptographically isolated from other Managed HSM instances, even though the underlying HSM hardware can be shared. ([Microsoft Learn][2])

### Primary advantage

Managed HSM integrates with supported Azure and Microsoft services that consume customer-managed keys, including scenarios involving Azure Storage, Azure SQL and Microsoft 365 Customer Key. ([Microsoft Learn][1])

Use it when the requirement sounds like:

> “Azure services must encrypt data with keys that we control in a single-tenant, FIPS 140-3 Level 3 HSM.”

### Important limitation

Managed HSM stores **cryptographic keys only**. It does not store Key Vault secret objects such as passwords, API tokens or connection strings, and it does not provide the normal Key Vault certificate-management service. ([Microsoft Learn][3])

---

## 2. Azure Cloud HSM

Azure Cloud HSM sits between Managed HSM and Dedicated HSM.

Microsoft provides a highly available cluster containing **three HSM nodes**, automatically synchronizes the cluster and handles hardware, firmware, patching and maintenance. However, the customer receives direct administrative control over the HSM environment, including HSM users, credentials, keys and cryptographic policies. ([Microsoft Learn][4])

```text
Azure-managed three-node cluster
├── HSM node 1
├── HSM node 2
└── HSM node 3

Customer:
  Administers HSM users, keys and policies

Microsoft:
  Maintains hardware, firmware, HA and service health
```

Microsoft retains a limited appliance role for health monitoring, maintenance, encrypted backup and audit-log handling, but that role cannot access customer keys or perform cryptographic operations with them. ([Microsoft Learn][5])

### Primary advantage

Cloud HSM supports conventional HSM interfaces:

* PKCS#11
* OpenSSL
* Java Cryptography Extension
* Windows KSP
* Windows CNG

That makes it appropriate for existing applications and commercial software designed to communicate directly with an HSM. ([Microsoft Learn][5])

Common examples include:

* Active Directory Certificate Services
* SQL Server or Oracle TDE
* TLS private-key offload
* Code and document signing
* Java applications built around JCE
* Applications migrating from on-premises HSMs

### Important limitation

Cloud HSM is not an Azure Key Vault endpoint. Azure Storage, Azure SQL Database, Microsoft Purview Customer Key and similar services cannot directly use Cloud HSM as their customer-managed-key provider. It is primarily intended for applications that can communicate with the HSM through its SDK and private network connectivity. ([Microsoft Learn][4])

Use it when the requirement sounds like:

> “Our application expects PKCS#11 or another native HSM interface, and we need HSM administrative control without maintaining the physical cluster.”

---

## 3. Azure Dedicated HSM

Dedicated HSM is the most traditional appliance model. Microsoft leases the customer an entire **physical Thales Luna 7 A790 network HSM** located in an Azure datacenter and connected directly to the customer’s virtual network. Only that customer has administrative and cryptographic control of the appliance. ([Microsoft Learn][6])

The customer is responsible for substantially more:

* Appliance initialization
* HSM users and roles
* Partitions
* Firmware and software updates
* High-availability configuration
* Backup and recovery
* Syslog and SNMP configuration
* Thales client software

Microsoft provides the physical facility, hardware hosting and network connectivity, with limited monitoring of hardware conditions such as power, temperature and fan health. Customers must perform their own HSM patching and configure HA through the Thales client software. ([Microsoft Learn][7])

### Primary advantage

Dedicated HSM provided the closest Azure equivalent to moving an existing physical Thales Luna appliance into an Azure datacenter, including broad Thales-compatible interfaces and the ability to integrate with compatible on-premises Luna devices.

### Current status

**Azure Dedicated HSM is being retired.** Microsoft is not accepting new customer onboardings and will support existing customers only until **July 31, 2028**. Azure Cloud HSM is Microsoft’s designated successor. ([Microsoft Learn][6])

It should therefore not be selected for a new architecture.

## Practical decision

```text
Does an Azure or Microsoft service need to consume the key?
│
├── Yes
│   └── Key Vault Managed HSM
│
└── No
    │
    ├── Does the application require PKCS#11, JCE, KSP/CNG,
    │   direct HSM users, or appliance-style administration?
    │
    │   └── Yes → Azure Cloud HSM
    │
    └── Existing Azure Dedicated HSM deployment?
        └── Plan migration to Cloud HSM or Managed HSM
```

For new deployments, the meaningful choice is generally:

* **Managed HSM** for Azure-native customer-managed-key integration.
* **Cloud HSM** for traditional or third-party applications requiring native HSM interfaces and direct HSM administration.
* **Standard or Premium Key Vault** for passwords, API tokens, connection strings, certificates and other general secrets.

[1]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/overview?utm_source=chatgpt.com "Azure Key Vault Managed HSM Overview"
[2]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys?utm_source=chatgpt.com "About keys - Azure Key Vault Managed HSM | Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts?utm_source=chatgpt.com "What is Azure Key Vault? | Microsoft Learn"
[4]: https://learn.microsoft.com/en-us/azure/cloud-hsm/overview?utm_source=chatgpt.com "Overview of Azure Cloud HSM | Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/azure/cloud-hsm/faq?utm_source=chatgpt.com "Frequently Asked Questions (FAQ) About Azure Cloud HSM"
[6]: https://learn.microsoft.com/en-us/azure/dedicated-hsm/overview "What is Dedicated HSM? - Azure Dedicated HSM | Microsoft Learn"
[7]: https://learn.microsoft.com/en-us/azure/dedicated-hsm/faq "Frequently asked questions - Azure Dedicated HSM | Microsoft Learn"
