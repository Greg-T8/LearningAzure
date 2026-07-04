**SC-300 Study Review Sheet: Configure Company Branding Settings (Expanded Edition)**

### **1. Core Architecture, Licensing, and RBAC**

* **Exhaustive Licensing Requirements:**
  * **Workforce Tenants:** Custom branding is a premium feature. The tenant must possess at least one of the following licenses: **Microsoft Entra ID P1 or P2**, **Microsoft 365 Business Standard**, or **SharePoint (Plan 1)**.
  * **Exam Trap (Free Tier):** If a tenant only operates on Microsoft Entra ID Free, administrators are explicitly restricted to the default Microsoft branding and cannot upload custom visuals.
  * **External Tenants Exception:** In an external tenant (used for consumer-facing apps), branding themes can be configured without any premium license requirements.
* **Role-Based Access Control (RBAC):**
  * **Least Privilege:** The **Organizational Branding Administrator** is the absolute minimum role required to fully manage the organization's sign-in screens.
  * **Scope of Authority:** This role configures default tenant-wide branding, application-specific branding themes, and browser language customizations.
  * **Exam Trap (Global Admins):** Granting Global Administrator solely for branding tasks violates least privilege by granting sweeping directory access.

### **2. The Hierarchical Fallback Engine**

Microsoft Entra ID applies visuals based on a strict, four-tiered order of precedence. If a property is left undefined, it automatically falls back to the level below it.

| Hierarchy Level | Scope | Rule & Exam Trap |
| :--- | :--- | :--- |
| **1. Branding Themes** | Explicitly targeted to **specific applications**. | Overrides Default Branding for that app. |
| **2. Language Customizations** | Targeted at specific **browser language settings**. | Overrides Default Branding for that specific user region. |
| **3. Default Branding** | Baseline **tenant-wide** experience. | Overrides Neutral Branding. |
| **4. Neutral Branding** | System default (Microsoft standard). | **Exam Trap:** If you omit a custom banner logo, the system will explicitly display the **Microsoft logo**, NOT your tenant name in plain text. |

### **3. Service Limits & Branding Theme Constraints**

* **Tenant-Wide Quotas:** A tenant is strictly limited to a maximum of **10 branding themes**.
* **Naming Constraints:**
  * **Exam Trap (Reserved Names):** You **cannot** use the exact name "Default theme" when creating a new custom theme, as it is a system-reserved name.
* **Localization Blind Spots:**
  * **Exam Trap (Automatic Translation):** Microsoft Entra ID does not automatically translate custom text. Any custom text set for a theme will not localize automatically; administrators must explicitly set custom text for each specific language individually.
  * Custom text changes made within a branding theme are explicitly **limited to the sign-in page only**.

### **4. Visual Elements & Configuration Specifications**

| Visual Element | Specification Limits | Configuration Details & Troubleshooting |
| :--- | :--- | :--- |
| **Favicon** | Exactly **32x32 pixels**; Max **5 KB**. | JPG/JPEG accepted, but **PNG is explicitly preferred**. |
| **Background Image** | Recommended 1920x1080. | **Exam Trap:** Only a single image is uploaded. The system automatically scales/crops it. You **cannot** upload separate files for mobile vs. desktop. |
| **Page Background Color** | Hexadecimal format. | **Troubleshooting Detail:** Displays instantly if network latency prevents the background image from loading. **Best Practice:** Always color-match this to the background image to ensure a smooth visual transition. |

* **Sign-In Box Layout Templates:**
  * **Full-screen background:** Sign-in box is center-aligned. *Risk:* May obscure custom background imagery.
  * **Partial-screen background:** Sign-in box is right-aligned (ADFS style/vertical split). *Use Case:* Keeps critical background image elements visible.

### **5. The "Sign-in Form" Tab & Hint Text Scenarios**

* **Configuration Detail:** The "Sign-in form" tab controls the banner logo, square logos, sign-in page text (at the bottom), and the **Username hint text**.
* **Scenario Example (Username Hint Text):** In an external tenant, you can change the hint text to "Member ID" or "Customer ID" to guide users.
* **Exam Trap (Guest User Conflict):** Microsoft explicitly recommends **against** using username hint text if your tenant allows guest users to sign in using the exact same page.

### **6. Advanced Authentication & External User Scenarios**

* **Home Realm Discovery (HRD) via URLs:**
  * *The Problem:* SaaS apps show a generic Microsoft screen until an email is entered.
  * *Configuration Detail:* Append the **`whr`** query string parameter (e.g., `?whr=contoso.com`) to URLs like the My Apps portal or Self-Service Password Reset. This preemptively identifies the home realm and displays company branding immediately.
* **B2B Cross-Tenant Authentication:**
  * **Exam Trap (The Origin Rule):** The **home tenant's branding always takes precedence** over the resource tenant's branding.
  * *Fallback Logic:* If the user's home tenant lacks custom branding, they will see the default Microsoft branding—not the resource tenant's custom branding.
* **Personal Microsoft Accounts (MSAs):**
  * **Exam Trap (MSA Exception):** If a user authenticates with a personal Microsoft account (Xbox, Live, Hotmail), organizational branding is **explicitly bypassed**; they will see an unbranded Microsoft sign-in page.

### **7. Developer Extensibility: Automation & Custom Interfaces**

* **Graph API Automation:**
  * Administrators can automate visual deployments using the **`organizationalBranding`** resource type via Microsoft Graph API.
  * Queries can use the `/beta` endpoint or the `/v1.0` endpoint (e.g., `https://graph.microsoft.com/v1.0/organization/`).
* **Data Attribute Injection (Custom HTML):**
  * When using custom HTML templates (e.g., B2C/External ID), proprietary data attributes must be added outside the `<div>` container to dynamically pull Azure portal assets.
  * *Background image:* `<img data-tenant-branding-background="true"/>`.
  * *Banner logo:* `<img data-tenant-branding-logo="true"/>`.
* **Mobile Application Design Constraints:**

| Authentication Model | Implementation | Design Control & Exam Keywords |
| :--- | :--- | :--- |
| **Branding Themes** | Browser-delegated authentication. | Forces a redirect to a Microsoft-hosted web page. Constrained by MS templates. |
| **Native Authentication** | APIs and SDKs built directly into the app. | **Exam Traps:** Look for "API-centric", "pixel-perfect", "no browser redirects", or "native UI". |
