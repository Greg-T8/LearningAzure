# Architectural Trade-offs in Azure Platform Management Groups

Your chosen answer was incorrect because it represents a misconception about how **Azure RBAC** evaluates permissions across different scopes, whereas the correct answer points directly to a well-documented architectural warning in the **Microsoft Cloud Adoption Framework (CAF)** regarding divided platform management.

Here is a detailed breakdown of the two options to help you understand this concept for the AZ-305 exam:

---

### 1. Why the Correct Answer is Right: The Complexity of Partial Replication
In a standard enterprise landing zone architecture, a single **Platform** management group contains child management groups for **Connectivity**, **Management**, and **Identity/Security** [1]. Under normal conditions, these are shared across all landing zones to maintain uniform policy and administrative controls [2, 3].

However, in highly regulated environments, local or industry-specific compliance standards may strictly forbid sharing identity, key management, or directory infrastructure across certain business boundaries [4]. 
* **The Divided Approach:** To comply, you can choose to divide the platform management group by keeping **connectivity** and **management** shared, but deploying a separate **identity and security** management group branch associated with *each* individual set of regulations [4].
* **The Disadvantage:** The CAF explicitly warns that this model **"is significantly more complex... because you have to partially replicate the platform management group."** [4] Instead of managing one centralized set of platform baseline policies and role assignments, platform administrators must maintain and synchronize partially duplicated management group branches, vastly increasing operational overhead, change management effort, and the likelihood of configuration drift [4, 5].

---

### 2. Why Your Chosen Answer Was Incorrect
Your chosen answer was: *"Azure RBAC does not support role assignments across multiple platform management groups."*

This is incorrect because **Azure RBAC does natively and fully support role assignments across multiple distinct management groups.** 

* **How Azure RBAC Operates:** Azure RBAC is a global, tenant-wide authorization system [6]. You can assign any supported role to a single user, group, or service principal at any scope in the resource hierarchy—including multiple different management groups [7, 8]. 
* **Additive Permission Model:** Azure RBAC is strictly **additive** [9]. If a security principal is assigned a role on Platform Management Group A and another role on Platform Management Group B, their effective permissions are simply the union (sum) of those assignments [9]. The platform imposes no restriction that limits a principal's roles to a single platform management group branch [9].

---

### 🎯 AZ-305 Architectural Takeaways:
* **The Sharing Standard:** Strive to share the platform management group whenever regulations allow to keep policy management centralized and simple [2, 3].
* **Partial Replication:** Only divide the platform management group (isolating identity/security or connectivity) when regulatory boundaries strictly prohibit sharing those specific shared services [4, 10]. Be prepared to justify the resulting management group replication complexity [4].
* **RBAC Scope Flexibility:** Security principals can receive multiple role assignments at different scopes and hierarchy branches without platform limitations [7, 9].

***

⚙️ Would you like to review how to use **Azure Policy exemptions** at different levels of the management group hierarchy to avoid having to split your platform management groups in the first place?