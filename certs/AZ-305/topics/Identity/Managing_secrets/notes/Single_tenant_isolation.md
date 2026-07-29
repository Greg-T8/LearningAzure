## What “single-tenant isolation” means

In Azure secrets and key management, **single-tenant isolation means that the security boundary containing your cryptographic material is dedicated to one customer rather than shared with other customers**.

The key idea is not simply that other customers lack permission to your data. It means your instance has a **customer-specific security domain** that cryptographically isolates it from other instances.

### Multi-tenant versus single-tenant

| Model                           | Isolation approach                                                                                                                                                                          |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Standard Azure Key Vault**    | The service infrastructure is shared among Azure customers, while each vault is logically isolated through Microsoft Entra authentication, authorization, encryption, and service controls. |
| **Azure Key Vault Managed HSM** | Each Managed HSM instance is a single-tenant pool with its own customer-specific security domain, cryptographically isolated from other Managed HSM instances. ([Microsoft Learn][1])       |
| **Azure Cloud HSM**             | A dedicated HSM cluster is assigned to one customer, who receives administrative control of the HSMs. ([Microsoft Learn][2])                                                                |

Conceptually:

```text
Standard Key Vault — multitenant service
┌──────────────── Shared Azure service infrastructure ────────────────┐
│ Customer A vault   Customer B vault   Customer C vault              │
│ Logically isolated through identity, authorization and encryption   │
└─────────────────────────────────────────────────────────────────────┘


Managed HSM — single-tenant security domain
┌──────────── Customer A Managed HSM instance ────────────┐
│ Customer A keys and customer-controlled security domain │
└─────────────────────────────────────────────────────────┘

┌──────────── Customer B Managed HSM instance ────────────┐
│ Customer B keys and separate security domain            │
└─────────────────────────────────────────────────────────┘
```

## Important distinction for secrets

Microsoft’s **Managed HSM stores cryptographic keys only**. It does not store ordinary Key Vault secrets such as passwords, API tokens, or connection strings. Standard Key Vault supports secrets, certificates, and both software-protected and HSM-protected keys. ([Microsoft Learn][3])

Therefore, a requirement such as:

> “Passwords and API credentials must use a single-tenant secret store.”

cannot be met merely by moving them to Managed HSM, because Managed HSM is not a general-purpose secret store. You would normally use:

* separate Azure Key Vaults to create stronger application, environment, or customer boundaries;
* tightly scoped Azure RBAC assignments;
* private endpoints and restricted public access;
* separate subscriptions or Entra tenants where organizational isolation requires it;
* Managed HSM for high-value encryption or signing **keys** requiring a dedicated cryptographic security domain.

## What single-tenant does—and does not—guarantee

Single-tenant isolation provides:

* a separate cryptographic security domain;
* reduced exposure to failures or authorization mistakes involving other customers;
* stronger compliance and key-sovereignty positioning;
* dedicated administrative and access-control boundaries.

It does **not necessarily mean that every physical server or HSM chassis is used by only your organization**. With Managed HSM, the customer pool is cryptographically isolated even where underlying hardware may support other isolated instances. Azure Cloud HSM provides the stronger model of a customer-dedicated HSM cluster. ([Microsoft Learn][1])

It is also different from:

* **Microsoft Entra single-tenancy**, which identifies the directory associated with the resource;
* **a private endpoint**, which controls network access;
* **RBAC**, which controls which identities can perform operations;
* **one vault per application**, which is an architectural isolation choice rather than a dedicated service tenancy model.

In practical terms, **standard Key Vault provides strong logical tenant isolation suitable for most secrets**, while **Managed HSM adds single-tenant cryptographic isolation for especially sensitive keys**.

[1]: https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys?utm_source=chatgpt.com "About keys - Azure Key Vault Managed HSM | Microsoft Learn"
[2]: https://learn.microsoft.com/en-us/azure/cloud-hsm/overview?utm_source=chatgpt.com "Overview of Azure Cloud HSM | Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts?utm_source=chatgpt.com "What is Azure Key Vault? | Microsoft Learn"
