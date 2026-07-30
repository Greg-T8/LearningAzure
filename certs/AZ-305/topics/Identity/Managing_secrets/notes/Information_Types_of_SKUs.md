## At a glance

The most important distinction is:

* **Key Vault Standard and Premium** can store **keys, secrets, and managed certificate objects**.
* **Managed HSM** stores **cryptographic keys only**.
* **Cloud HSM** stores traditional HSM key objects and supports **PKCS#11 certificate objects**, but it is not a general secret store or certificate-lifecycle service. ([Microsoft Learn][1])

| Information or object                      | Key Vault Standard | Key Vault Premium | Key Vault Managed HSM | Azure Cloud HSM |
| ------------------------------------------ | -----------------: | ----------------: | --------------------: | --------------: |
| Passwords                                  |                Yes |               Yes |                    No |              No |
| API keys and tokens                        |                Yes |               Yes |                    No |              No |
| Connection strings                         |                Yes |               Yes |                    No |              No |
| Other small secret values                  |                Yes |               Yes |                    No |              No |
| Software-protected RSA keys                |                Yes |               Yes |                    No |              No |
| Software-protected EC keys                 |                Yes |               Yes |                    No |              No |
| HSM-protected RSA keys                     |                 No |               Yes |                   Yes |             Yes |
| HSM-protected EC keys                      |                 No |               Yes |                   Yes |             Yes |
| HSM-protected AES symmetric keys           |                 No |                No |                   Yes |             Yes |
| Native Key Vault certificate objects       |                Yes |               Yes |                    No |              No |
| Automated certificate renewal policies     |                Yes |               Yes |                    No |              No |
| PKCS#11 X.509 certificate objects          |                 No |                No |                    No |             Yes |
| Documents, databases or bulk business data |                 No |                No |                    No |              No |

## 1. Azure Key Vault Standard

Key Vault Standard stores three primary object types:

### Secrets

Examples include:

* Passwords
* Database connection strings
* API keys
* OAuth client secrets
* Access tokens
* Shared secrets
* Small configuration values that must remain confidential

### Software-protected asymmetric keys

Standard supports:

* RSA keys
* Elliptic-curve keys

The key material is software-protected rather than assigned to a dedicated HSM-protected key object. Standard does not support symmetric AES key objects. ([Microsoft Learn][2])

### Certificates

A Key Vault certificate is more than an uploaded public certificate. Key Vault creates and coordinates:

1. A certificate object containing the certificate metadata and policy.
2. A key object representing the certificate's public/private key pair.
3. A secret object that can contain the certificate data, such as a PFX or PEM representation.

Certificate policies can contain:

* Subject and subject-alternative names
* Key type and size
* Exportability
* Certificate issuer
* Expiration behavior
* Renewal actions
* X.509 key-usage settings

Key Vault can also perform automated renewal when integrated with supported certificate issuers. ([Microsoft Learn][1])

**Typical Standard contents:**

```text
DatabasePassword
ServiceNowApiToken
ApplicationClientSecret
SoftwareRsaSigningKey
WebsiteTlsCertificate
```

## 2. Azure Key Vault Premium

Premium stores the **same categories of information as Standard**:

* Secrets
* RSA and EC keys
* Certificate objects

The difference is that Premium additionally supports **HSM-protected asymmetric keys**:

* RSA-HSM
* EC-HSM

Premium can contain both software-protected and HSM-protected keys. Simply selecting the Premium SKU does not automatically make every key HSM-protected; the key must be created or imported as an HSM key. ([Microsoft Learn][2])

For certificates, Premium can protect the certificate's private key with an HSM-backed RSA or EC key. HSM-backed private keys are non-exportable. ([Microsoft Learn][3])

Premium still does **not** support native symmetric AES key objects. For AES keys, Microsoft directs customers to Managed HSM. ([Microsoft Learn][2])

**Typical Premium contents:**

```text
DatabasePassword
ApplicationClientSecret
SoftwareRsaKey
HsmProtectedRsaKey
HsmProtectedEcKey
TlsCertificateWithHsmPrivateKey
```

## 3. Azure Key Vault Managed HSM

Managed HSM stores **cryptographic keys only**. It does not contain Key Vault secret or certificate object collections. ([Microsoft Learn][1])

Supported key categories include:

* HSM-protected RSA keys
* HSM-protected elliptic-curve keys
* HSM-protected AES symmetric keys

Managed HSM supports AES key sizes of 128, 192 and 256 bits, along with operations such as AES key wrapping, AES-GCM, AES-CBC and HMAC signing and verification. All keys in Managed HSM are HSM-protected. ([Microsoft Learn][4])

It can therefore hold:

* Customer-managed key-encryption keys
* RSA signing keys
* EC signing keys
* AES master keys
* AES key-encryption keys
* Keys used to wrap application data-encryption keys
* Private keys associated with TLS applications

However, it cannot store:

* Passwords
* Connection strings
* API tokens
* Native Key Vault certificate objects
* Certificate renewal policies

For example, Managed HSM can protect the **private key used by a TLS certificate**, but it does not store and manage the full Key Vault certificate object and renewal workflow.

**Typical Managed HSM contents:**

```text
AzureStorageCustomerManagedKey
SqlTdeKeyEncryptionKey
AesApplicationMasterKey
CodeSigningPrivateKey
TlsPrivateKey
```

## 4. Azure Cloud HSM

Azure Cloud HSM behaves more like a traditional enterprise HSM. It stores HSM key objects accessed through interfaces such as:

* PKCS#11
* OpenSSL
* JCA/JCE
* Microsoft CNG/KSP

It supports RSA, EC and AES keys. ([Microsoft Learn][5])

Typical key contents include:

* Active Directory Certificate Services CA private keys
* TLS server private keys
* SQL Server or Oracle TDE keys
* Code-signing keys
* Document-signing keys
* AES application master keys
* Keys used by applications migrated from on-premises HSMs

Cloud HSM is explicitly **not a secret store**. It is not intended for passwords, API tokens or database connection strings. It also does not provide certificate enrollment, renewal or general certificate-lifecycle management. ([Microsoft Learn][6])

### Cloud HSM certificate storage nuance

Cloud HSM supports managing X.509 certificate objects through PKCS#11, but the certificate data is not stored directly inside the HSM hardware.

Instead:

* The certificate objects are stored in a customer-provided Azure Blob Storage container in JWS format.
* A signing key held by Cloud HSM protects the integrity of those certificate objects.
* The associated private cryptographic key remains protected by the HSM. ([Microsoft Learn][7])

Therefore, “Cloud HSM stores certificates” is functionally correct from the PKCS#11 application's perspective, but the underlying architecture is:

```text
Azure Cloud HSM
├── RSA, EC and AES keys
├── Certificate private keys
└── Certificate-storage signing key

Azure Blob Storage
└── PKCS#11 X.509 certificate objects in JWS format
```

## Practical examples

| Requirement                                     | Appropriate service                         |
| ----------------------------------------------- | ------------------------------------------- |
| Store a service-account password                | Key Vault Standard or Premium               |
| Store an application client secret              | Key Vault Standard or Premium               |
| Store and automatically renew a TLS certificate | Key Vault Standard or Premium               |
| Protect a TLS certificate private key in an HSM | Key Vault Premium                           |
| Store an AES-256 master key                     | Managed HSM or Cloud HSM                    |
| Store a customer-managed key for Azure Storage  | Key Vault or Managed HSM                    |
| Protect an AD CS issuing-CA private key         | Cloud HSM                                   |
| Migrate an existing PKCS#11 application         | Cloud HSM                                   |
| Store an Oracle TDE master key through PKCS#11  | Cloud HSM                                   |
| Store passwords alongside HSM keys              | Use Key Vault plus Managed HSM or Cloud HSM |

## Simplified selection rule

```text
Need passwords, tokens or connection strings?
    └── Key Vault Standard or Premium

Need managed certificates and automatic renewal?
    └── Key Vault Standard or Premium

Need an HSM-backed RSA/EC key in a normal Key Vault?
    └── Key Vault Premium

Need symmetric AES keys and Azure PaaS CMK integration?
    └── Key Vault Managed HSM

Need PKCS#11, AD CS, Oracle TDE, CNG/KSP or traditional HSM access?
    └── Azure Cloud HSM
```

The difference between **Standard and Premium is primarily key protection**, not the general object categories they store. The difference between **Key Vault and Managed HSM is object scope**: Key Vault stores keys, secrets and certificates, while Managed HSM stores only cryptographic keys. Cloud HSM provides the broadest traditional HSM application compatibility but does not replace Key Vault as a secret-management or certificate-lifecycle service.

[1]: https://learn.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates "Azure Key Vault Keys, Secrets, and Certificates Overview | Microsoft Learn"
[2]: https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys "About keys - Azure Key Vault | Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates "About Azure Key Vault certificates | Microsoft Learn"
[4]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details "Key types, algorithms, and operations - Azure Key Vault Managed HSM | Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/azure/cloud-hsm/service-limits?utm_source=chatgpt.com "Azure Cloud HSM Service Limits | Microsoft Learn"
[6]: https://learn.microsoft.com/en-us/azure/cloud-hsm/overview "Overview of Azure Cloud HSM | Microsoft Learn"
[7]: https://learn.microsoft.com/en-us/azure/cloud-hsm/tutorial-certificate-storage "Tutorial - Azure Cloud HSM certificate storage | Microsoft Learn"
