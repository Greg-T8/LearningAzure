# Implementing Scoped Feature Management in Blazor Server

It is very common to default to `services.AddFeatureManagement()` because it is the standard method used to register feature management services across most .NET applications. However, this question tests a specific architectural constraint when dealing with HTTP context in Blazor server applications.

Here is a detailed breakdown of why your answer was incorrect and the specific registration method you must remember for the AZ-305 exam:

**1. The Singleton Limitation (Why your answer was incorrect)**
Feature filters are often designed to evaluate a feature flag based on the specific properties of an incoming HTTP request [1]. In a standard ASP.NET Core application, this is usually accomplished by inspecting the `HttpContext` through the singleton `IHttpContextAccessor` pattern [1]. However, **this singleton pattern does not work for Blazor server applications** [1]. If you use the standard `AddFeatureManagement()` method, it registers the feature manager as a singleton, which will fail when trying to reliably access request-specific context in a Blazor server architecture.

**2. The Scoped Service Requirement (Why the correct answer is right)**
Because Blazor server applications maintain a persistent connection and handle HTTP context differently, they strictly require **scoped services** for this type of evaluation [1]. To solve this, the `Microsoft.FeatureManagement` library (starting with version 3.1.0) allows you to run feature management services, including feature filters, as scoped services [2]. To achieve this compatibility in Blazor, you must explicitly replace the standard registration call in your code with `services.AddScopedFeatureManagement()` [1, 2]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing feature management in .NET applications using Azure App Configuration, remember these dependency injection boundaries:
*   **Standard .NET Applications:** Use `services.AddFeatureManagement()` for the vast majority of web applications where standard singleton evaluation is acceptable.
*   **Blazor Server Applications:** You **must** use `services.AddScopedFeatureManagement()` when your application requires scoped services to evaluate feature filters based on HTTP request properties [1, 2].