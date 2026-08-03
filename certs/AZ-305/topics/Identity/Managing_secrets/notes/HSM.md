The names are confusing because all three provide hardware-backed cryptographic key protection, but they expose very different **administrative and integration models**. Managed HSM also offers an external key management option that changes where the key material resides without changing the Azure-facing integration model:

* **Managed HSM:** Azure manages the HSM platform; you manage keys and permissions.
* **Managed HSM external key management (preview):** Managed HSM remains the authorization and customer-managed-key endpoint, but the Key Encryption Key (KEK) remains in a customer-owned, customer-operated HSM outside Microsoft infrastructure.
* **Cloud HSM:** Azure manages the cluster infrastructure; you administer the HSM itself.
* **Dedicated HSM:** You administer an entire physical HSM appliance and most of its operations.

## Comparison

| Characteristic                  | Key Vault Managed HSM                                      | Managed HSM External Key Management (preview)                                                                 | Azure Cloud HSM                                                 | Azure Dedicated HSM                                            |
| ------------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- | -------------------------------------------------------------- |
| Basic model                     | Azure-native managed key service                           | Managed HSM remains the Azure authorization and CMK endpoint, while the KEK stays in an externally operated HSM | Customer-administered HSM cluster as a service                  | Dedicated physical HSM appliance hosted in Azure               |
| Isolation boundary              | Customer-specific HSM partitions and security domain       | Managed HSM security domain plus a separately operated EKM Proxy and external HSM trust boundary              | Customer-specific three-node HSM cluster and security domain    | Entire physical appliance dedicated to one customer            |
| Key material location           | Azure Managed HSM partitions                               | Outside Microsoft infrastructure in a customer- or vendor-operated external HSM                               | Customer-administered Azure Cloud HSM cluster                   | Customer's dedicated physical appliance in Azure               |
| Underlying hardware             | Marvell LiquidSecurity HSM partitions                      | Customer- or vendor-selected external HSM; Managed HSM stores only the external key reference                 | Marvell LiquidSecurity HSM nodes                                | Thales Luna 7 A790 appliance                                   |
| Certification                   | FIPS 140-3 Level 3                                         | Managed HSM is FIPS 140-3 Level 3; external-HSM certification depends on the selected product or provider     | FIPS 140-3 Level 3                                              | FIPS 140-2 Level 3                                             |
| Customer administration         | Keys, policies and RBAC                                    | Managed HSM policies and RBAC, plus the proxy, external HSM, keys, certificates, networking, monitoring and HA/DR | HSM users, credentials, keys and cryptographic policies         | Entire appliance, partitions, users, firmware and keys         |
| Microsoft responsibility        | Provisioning, configuration, patching, HA and maintenance  | Managed HSM authentication, authorization and request forwarding within Microsoft's service boundary         | Cluster HA, firmware, patching, maintenance and hardware health | Datacenter hosting, physical hardware and network connectivity |
| Primary interface               | Key Vault REST API, SDKs, CLI and PowerShell               | Azure clients use the normal Managed HSM API; Managed HSM reaches the EKM Proxy through mTLS HTTP+JSON         | PKCS#11, OpenSSL, JCE, KSP and CNG                              | Thales PKCS#11, JCA/JCE, CAPI/CNG and OpenSSL                  |
| Azure PaaS/SaaS CMK integration | Yes, for supported Azure and Microsoft services            | Yes; supported Azure services continue to use the Managed HSM key URI                                         | No                                                              | No                                                             |
| Typical workload                | Azure-native encryption and customer-managed keys          | Azure-native CMK integration where legal, regulatory or sovereignty requirements mandate external KEK custody | Traditional HSM-integrated applications running in Azure        | Existing legacy Thales Luna deployments                        |
| Current status                  | Strategic service                                          | Gated public preview with customer-operated availability and performance dependencies                          | Strategic successor to Dedicated HSM                            | Retiring; unavailable to new customers                         |

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

### Managed HSM external key management (preview)

External key management is **not a separate Azure HSM service**. It is an extension of Managed HSM for organizations that must keep the actual KEK in an HSM they or their HSM vendor operate entirely outside Microsoft infrastructure. Managed HSM stores an external key identifier instead of the key material, continues to enforce Microsoft Entra authentication and Managed HSM local RBAC, and remains the key URI that supported Azure services consume. ([Microsoft Learn][8]) ([Architecture][9])

The request path is:

```text
Azure service using CMK
└── Key Vault Managed HSM
    ├── Authenticates and authorizes the caller
    ├── Stores the external key reference
    └── Sends wrap/unwrap request over mTLS
        └── Customer-operated EKM Proxy
            └── Customer-operated external HSM
                └── KEK performs the cryptographic operation
```

A typical operation works as follows:

1. An Azure service, such as Azure Storage, calls the same Managed HSM key URI it would use for a normal Managed HSM key.
2. Managed HSM authenticates and authorizes the caller and recognizes that the key version contains an external key identifier.
3. Managed HSM connects to the customer-operated EKM Proxy using mutual TLS (mTLS).
4. The proxy translates the request into the external HSM vendor's protocol.
5. The external HSM performs the key wrap or unwrap operation without the KEK leaving the HSM.
6. The result returns through the proxy and Managed HSM to the Azure service. ([Architecture][9])

The EKM Proxy is a stateless HTTP+JSON service implemented by the customer, an HSM vendor or another designated operator. Microsoft publishes the EKM Proxy API specification but does not provide or operate the proxy. During the initial preview, Managed HSM reaches the proxy through a publicly resolvable FQDN over the public internet, with the connection protected by mTLS. ([Architecture][9])

#### Primary advantage

External key management allows an Azure service to retain the normal Managed HSM CMK integration model while satisfying a legal, contractual, regulatory or digital-sovereignty requirement that the KEK must never physically reside in or transit Microsoft infrastructure. The customer can also disable cryptographic operations by disconnecting the external HSM. ([Microsoft Learn][8])

Use it when the requirement sounds like:

> “An Azure service must use customer-managed keys, but our legal or sovereignty requirements mandate that the KEK remain in an HSM physically controlled outside Microsoft infrastructure.”

#### Operations and key types

During the preview, external keys support only:

* `wrapKey`
* `unwrapKey`

Supported algorithms are `RSA-OAEP`, `RSA-OAEP-256`, `A256KW` and `A256KWP`. Supported key material includes RSA 2048-, 3072- and 4096-bit keys and AES-256 keys. Signing, verification, direct encryption and decryption, Secure Key Release and Confidential VM launch scenarios are not supported for external keys. ([FAQ][11])

#### Availability and operational tradeoffs

External key management deliberately trades availability, performance and operational simplicity for physical custody of the KEK:

* There is **no SLA for the external key, EKM Proxy or external HSM**. The Managed HSM SLA applies only within Microsoft's service boundary.
* Each proxy round trip must complete within **250 milliseconds** or Managed HSM returns an error.
* The customer or designated HSM operator is responsible for the proxy and external HSM, including deployment, patching, scaling, network availability, mTLS certificates, monitoring, capacity, high availability and disaster recovery.
* Managed HSM emits `EkmProxyOperation` audit events, but proxy-side and HSM-side logging are the customer's responsibility.
* Proxy or external-HSM failures cause wrap and unwrap operations for external keys to fail; normal Managed HSM keys are unaffected.
* Standard Managed HSM pricing still applies. Microsoft does not add an EKM surcharge, but the customer pays for proxy infrastructure and external HSM products or services. ([Shared responsibility][10])

For most workloads, normal Managed HSM keys are the better choice because they support the full cryptographic operation set, have lower latency and are covered by the Managed HSM SLA.

#### External-key lifecycle limitations

External keys have several lifecycle constraints:

* The external key identifier is immutable for a key version. Rotation requires a new key version with a new external key identifier.
* A key cannot be converted between an external key and a normal Managed HSM key. Moving a workload between the two models requires a new key URI and reconfiguration of the consuming Azure service.
* Managed HSM backup and restore is not supported for external keys during the preview. The customer is responsible for backup and recovery of the external key material. ([Microsoft Learn][8]) ([FAQ][11])

#### Preview scope and access

At preview launch, external key management is available in Azure public regions but not Azure Government or Azure China. Access is gated and must be enabled at the subscription level by the Microsoft account team. The current preview onboarding requirements include an assigned Microsoft account manager and at least **USD 10 million in annual committed Azure revenue**. ([Microsoft Learn][8])

Microsoft currently lists EKM Proxy support from Entrust, Eviden, Fortanix, Futurex, Securosys, Thales and Utimaco. Customers can also implement their own proxy against Microsoft's public API specification. Vendor inclusion is informational; the vendor remains responsible for its implementation and support. ([Microsoft Learn][8])

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
Does an Azure or Microsoft service need to consume the key through CMK?
│
├── Yes
│   │
│   ├── Must the KEK physically remain outside Microsoft infrastructure
│   │   because of a strict legal, contractual or sovereignty mandate?
│   │
│   │   ├── Yes → Managed HSM external key management (preview)
│   │   │         Only for supported wrap/unwrap CMK scenarios
│   │   │
│   │   └── No  → Key Vault Managed HSM
│   │
│   └── The consuming Azure service continues to use a Managed HSM key URI
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

* **Managed HSM** for Azure-native customer-managed-key integration and the best Azure-managed availability and operational model.
* **Managed HSM external key management** only when an Azure CMK workload has a strict requirement for physical KEK custody outside Microsoft infrastructure and the organization can operate the proxy and external HSM.
* **Cloud HSM** for traditional or third-party applications requiring native HSM interfaces and direct HSM administration.
* **Standard or Premium Key Vault** for passwords, API tokens, connection strings, certificates and other general secrets.

[1]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/overview "Azure Key Vault Managed HSM Overview"
[2]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys "About keys - Azure Key Vault Managed HSM | Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts "What is Azure Key Vault? | Microsoft Learn"
[4]: https://learn.microsoft.com/en-us/azure/cloud-hsm/overview "Overview of Azure Cloud HSM | Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/azure/cloud-hsm/faq "Frequently Asked Questions (FAQ) About Azure Cloud HSM"
[6]: https://learn.microsoft.com/en-us/azure/dedicated-hsm/overview "What is Dedicated HSM? - Azure Dedicated HSM | Microsoft Learn"
[7]: https://learn.microsoft.com/en-us/azure/dedicated-hsm/faq "Frequently asked questions - Azure Dedicated HSM | Microsoft Learn"
[8]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/external-key-management-overview "What is Managed HSM external key management? (preview)"
[9]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/external-key-management-architecture "Managed HSM external key management architecture (preview)"
[10]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/external-key-management-shared-responsibility "SLA and shared responsibility for Managed HSM external key management (preview)"
[11]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/external-key-management-faq "Managed HSM external key management FAQ (preview)"
