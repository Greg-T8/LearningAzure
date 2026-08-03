**Both Azure Key Vault Managed HSM and Azure Key Vault Premium support customer-managed keys (CMKs).**

| Capability                             | Managed HSM  | Key Vault Premium                      |
| -------------------------------------- | ------------ | -------------------------------------- |
| Store and manage CMKs                  | Yes          | Yes                                    |
| Use CMKs with supported Azure services | Yes          | Yes                                    |
| HSM-protected keys                     | Always       | Optional—select an HSM-backed key type |
| Software-protected keys                | No           | Yes                                    |
| Import/BYOK                            | Yes          | Yes                                    |
| Store secrets and certificates         | No—keys only | Yes                                    |

### Managed HSM

Managed HSM is the stronger option when you need:

* A **single-tenant HSM pool**
* All keys protected by **FIPS 140-3 Level 3 validated hardware**
* A customer-owned security domain
* Strict separation of duties and HSM-level administrative controls

You can generate keys inside Managed HSM or securely import keys from an external HSM. These keys can serve as CMKs for supported Azure services. ([Microsoft Learn][1])

### Key Vault Premium

Key Vault Premium also supports CMKs, including:

* Software-protected keys
* HSM-protected `RSA-HSM` and `EC-HSM` keys
* Imported or generated HSM keys
* Secrets and certificates in the same vault

For a CMK that must be hardware-protected, make sure the key itself is created as an **HSM-protected key**. Simply using the Premium tier does not automatically make every key HSM-backed. ([Microsoft Learn][2])

### Important limitation

CMK compatibility ultimately depends on the **Azure service being encrypted**. Some services support keys stored in both Key Vault and Managed HSM, while others support only Key Vault. Microsoft maintains a service-by-service compatibility matrix. ([Microsoft Learn][3])

For most standard Azure CMK implementations, **Key Vault Premium is sufficient**. Choose **Managed HSM** when dedicated single-tenant HSM boundaries, stronger administrative isolation, or specific compliance requirements justify the additional cost and complexity.

[1]: https://learn.microsoft.com/nb-no/azure/key-vault/managed-hsm/about-keys?utm_source=chatgpt.com "About keys - Azure Key Vault Managed HSM"
[2]: https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys?utm_source=chatgpt.com "About keys - Azure Key Vault"
[3]: https://learn.microsoft.com/en-us/azure/security/fundamentals/encryption-customer-managed-keys-support?utm_source=chatgpt.com "Services that support customer managed keys (CMKs) in ..."
