The main difference is **how cryptographic keys are protected**:

| Capability                     | Key Vault Standard  | Key Vault Premium                                           |
| ------------------------------ | ------------------- | ----------------------------------------------------------- |
| Secrets                        | Yes                 | Yes                                                         |
| Certificates                   | Yes                 | Yes                                                         |
| Software-protected RSA/EC keys | Yes                 | Yes                                                         |
| **HSM-protected RSA/EC keys**  | No                  | **Yes**                                                     |
| Software-key validation        | FIPS 140-2 Level 1  | FIPS 140-2 Level 1                                          |
| New HSM-key validation         | N/A                 | **FIPS 140-3 Level 3**                                      |
| Tenant isolation               | Multitenant         | Multitenant                                                 |
| Cost                           | Transaction charges | Transaction charges plus charges for actively used HSM keys |

Microsoft describes Standard as supporting secrets, certificates, and software-backed keys, while Premium adds HSM-backed keys. ([Microsoft Learn][1])

## Standard

In the Standard tier, RSA and elliptic-curve keys are protected using a software cryptographic module validated to FIPS 140-2 Level 1. The key material is still managed by Key Vault and cannot normally be exported in plaintext, but cryptographic operations are performed in software rather than inside a dedicated HSM boundary. ([Microsoft Learn][2])

Standard is generally appropriate for:

* Application passwords, tokens, API keys and connection strings
* TLS certificates
* Customer-managed encryption keys where HSM protection is not required
* General-purpose application key management

## Premium

Premium supports everything Standard supports, but it also lets you create or import **HSM-protected keys**, such as:

* `RSA-HSM`: 2,048-, 3,072- and 4,096-bit
* `EC-HSM`: P-256, P-384, P-521 and P-256K

Operations such as signing, decrypting and unwrapping are performed within the HSM boundary, and the HSM-protected key material does not leave that boundary. New Premium HSM keys use Microsoft’s FIPS 140-3 Level 3-validated HSM platform. ([Microsoft Learn][2])

Premium is generally appropriate when:

* A regulation or client requirement explicitly requires HSM-backed keys
* You use customer-managed keys for high-value or regulated workloads
* You need HSM-backed code-signing or certificate private keys
* Your security policy requires FIPS 140-3 Level 3 protection

## Important nuances

**Selecting Premium does not automatically make every key HSM-protected.** Premium can contain both software-backed and HSM-backed keys. You must create the key using an HSM key type such as `RSA-HSM` or `EC-HSM`. Existing software-backed keys do not become HSM-backed merely because the vault uses the Premium SKU. ([Microsoft Learn][1])

**Premium is not single-tenant.** Both Standard and Premium Key Vaults are multitenant services. For single-tenant HSM isolation and customer control of the security domain, the relevant service is **Azure Key Vault Managed HSM**, not Key Vault Premium. ([Microsoft Learn][3])

**Premium costs more only when you use its HSM capability.** Both tiers have transaction-based charges, but actively used HSM-protected keys in Premium also incur per-key charges; each active key version is counted separately for billing. ([Microsoft Azure][4])

### Practical recommendation

Use **Standard** unless a technical, contractual, compliance or security requirement calls for HSM-protected keys. Choose **Premium** when you specifically need `RSA-HSM` or `EC-HSM`; otherwise, Premium offers little practical advantage over Standard.

[1]: https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys "About keys - Azure Key Vault | Microsoft Learn"
[2]: https://learn.microsoft.com/en-us/azure/key-vault/general/overview "Azure Key Vault Overview - Azure Key Vault | Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/mhsm-control-data "Control your cloud data by using Managed HSM | Microsoft Learn"
[4]: https://azure.microsoft.com/en-us/pricing/details/key-vault/ "Pricing - Key Vault | Microsoft Azure"
