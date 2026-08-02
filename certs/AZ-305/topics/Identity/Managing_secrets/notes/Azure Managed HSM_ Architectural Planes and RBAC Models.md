# Azure Managed HSM: Architectural Planes and RBAC Models

Great job getting this right! This is a core architectural and security concept for the AZ-305 exam. It tests your understanding of the strict isolation boundaries required for highly sensitive cryptographic workloads. 

Here is a detailed breakdown of how these two planes differ, why they use separate authorization models, and what you must remember:

**1. The Control Plane (Managed by Azure RBAC)**
The control plane is where you manage the Managed HSM appliance itself as an Azure resource [1, 2]. 
*   **Operations:** This includes high-level management actions such as creating or deleting the Managed HSM resource, moving it, and updating its tags or properties [2, 3].
*   **Authorization Model:** These requests are handled by Azure Resource Manager, so authorization is strictly governed by standard **Azure role-based access control (Azure RBAC)** [4, 5]. 

**2. The Data Plane (Managed by Managed HSM Local RBAC)**
The data plane is where you interact with the actual cryptographic data stored *inside* the Managed HSM [1, 2]. 
*   **Operations:** This includes adding, modifying, or deleting the HSM-backed encryption keys; performing cryptographic operations (like encrypt, decrypt, sign, verify, wrap, and unwrap); creating full HSM backups; and managing the highly sensitive Security Domain [2, 3]. 
*   **Authorization Model:** Data plane operations are enforced directly by the Managed HSM appliance itself, using an isolated authorization system known as **Managed HSM local RBAC** [4, 6]. 

**3. Why the separation matters (Separation of Duties)**
While both planes use Microsoft Entra ID to authenticate *who* you are, they use these completely separate systems to authorize *what* you can do [4, 7]. 

This hard separation is by design to prevent the inadvertent expansion of privileges [6]. **Granting control-plane access to a user does not grant them data-plane access** [6]. 

For example, if an IT Administrator is assigned the "Owner" or "Contributor" Azure RBAC role at the Subscription level, they have the power to delete the Managed HSM entirely (a control-plane action). However, because they lack Managed HSM Local RBAC roles, they cannot read, use, or manage a single cryptographic key inside the vault [6, 8]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing highly secure key management architectures, memorize these boundaries for Managed HSM:
*   **Zero Implicit Access:** Because of this dual-plane model, subscription, resource group, or management group administrators cannot override data-plane access [7, 9]. Only designated Managed HSM Administrators have complete control over the HSM pool's keys and data-plane role assignments [7]. 
*   **Local RBAC Roles:** Memorize that the data plane relies on specific local roles, such as the `Managed HSM Administrator` (for security domain, backups, and role management) and the `Managed HSM Crypto Officer` or `Crypto User` (for actual key cryptographic operations) [10, 11].
*   **Bootstrapping the HSM:** When a Managed HSM is first created, the creator must explicitly provide a list of data-plane administrators. Only these specified administrators can initially access the data plane to perform key operations or assign Managed HSM local RBAC roles to other users and applications [4].