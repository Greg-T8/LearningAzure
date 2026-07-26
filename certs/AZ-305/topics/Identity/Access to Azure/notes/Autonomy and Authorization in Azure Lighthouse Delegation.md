# Autonomy and Authorization in Azure Lighthouse Delegation

Great job on selecting the correct answer! This question tests your understanding of the Azure Lighthouse lifecycle and the specific authorization controls required for cross-tenant management.

Here is a detailed breakdown of why this role is critical, how delegation removal works, and what you should remember for your AZ-305 exam designs:

**1. The Default Customer-Controlled Boundary**
When a service provider onboards a customer to Azure Lighthouse, two resources are created in the customer's tenant: a registration definition and a registration assignment [1]. By default, only an authorized user in the *customer's* tenant—specifically, someone with `Microsoft.Authorization/roleAssignments/delete` permissions, such as an Owner—has the authority to remove this access [2]. 

**2. The Purpose of the Delete Role**
To ensure the service provider has the autonomy to terminate their own access (for example, when a contract ends), you must explicitly include the **Managed Services Registration Assignment Delete Role** in your authorizations when defining the Azure Lighthouse Azure Resource Manager (ARM) template or Microsoft Marketplace offer [3, 4]. When a user in the managing (service provider) tenant is granted this role, they can directly delete the registration assignment, successfully severing the cross-tenant access [5, 6].

**3. The Consequence of Omitting the Role**
If you forget to include this role during the initial onboarding, no one in the service provider's tenant will be able to remove the delegation [3]. Instead, the service provider will be completely reliant on the customer; they would have to contact the customer and ask them to manually remove the offer from their own Azure portal [5, 7]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing Azure Lighthouse solutions, Microsoft explicitly recommends including the **Managed Services Registration Assignment Delete Role** as a fundamental best practice so you are never locked into a delegation [3, 4, 8]. 

Also, remember that Azure Lighthouse has strict limitations on the built-in roles it supports. It deliberately excludes the `Owner` role, custom roles, and any roles with `DataActions` [8-10]. Therefore, you cannot simply grant the service provider `Owner` access to let them manage their own lifecycle; you must use this specific Managed Services role.