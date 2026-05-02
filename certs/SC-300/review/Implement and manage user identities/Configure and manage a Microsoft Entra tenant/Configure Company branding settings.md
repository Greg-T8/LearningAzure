# Exhausive SC-300 Study Guide: Microsoft Entra ID Sign-In Customization

## 1. The Core Architecture of Microsoft Entra ID Branding

Microsoft Entra ID utilizes a strict, three-tiered fallback hierarchy to govern how customized visuals are rendered during the authentication process. This modular design saves administrators from having to configure every visual property from scratch for every specific scenario.

### The Three-Tiered Fallback Mechanism

1. **Neutral Branding (Lowest Precedence):** This is the baseline, out-of-the-box Microsoft branding applied to a tenant before any custom settings are configured. Neutral branding acts as the final safety net for any properties not defined in your default branding. For instance, if you never update the custom banner logo property, the system will explicitly display the standard Microsoft logo instead of rendering your organization's tenant name in plain text.
2. **Default Branding / Company Branding (Middle Precedence):** This represents your tenant-wide customizations. It applies universally across all applications in your organization and explicitly overrides the neutral baseline branding.
3. **Branding Themes (Highest Precedence):** These are highly specialized visual customizations applied only to individual, specific applications. Any property explicitly defined within a Branding Theme completely overrides both Default and Neutral branding for that specific app.

### How the Fallback Logic Operates in Practice

Because Branding Themes are built directly on top of Default and Neutral branding, all branding elements within the configuration menus are completely optional.

* If you create a Branding Theme for a partner application but only change the custom banner logo, the system will render that unique logo but seamlessly pull the background image from your tenant-wide Default Branding.
* If a property is undefined in both the theme and the default branding, it falls back to the Neutral layer.

### Strict Limitations on Branding Themes

Microsoft enforces rigid service limits on how these themes can be deployed:

* An administrator can create a maximum of **10 branding themes per tenant**.
* You **cannot use the exact name "Default theme"** when naming your configurations, as this string is strictly reserved by the system architecture.
* Any custom text modifications made within a branding theme are currently restricted exclusively to the sign-in page.

---

## 2. Licensing Requirements and Role-Based Access Control (RBAC)

### Granular Licensing Nuances

Microsoft considers custom company branding a premium feature, meaning it is not natively included in the baseline Microsoft Entra ID Free tier alone.

* **Base Branding Requirements:** To simply upload custom visuals (logos, background images, and colors) for your tenant's Default Branding, the organization must possess at least **SharePoint (Plan 1)**, **Microsoft 365 Business Standard**, or **Microsoft Entra ID P1 or P2**. If a tenant lacks these, administrators are locked into the standard Microsoft UI.
* **App-Specific Theme Requirements:** Standard workforce tenants require a **Microsoft Entra ID P1 or P2 license** to utilize app-specific branding themes (a feature currently in PREVIEW for workforce tenants).
* **External Tenants Exception:** External tenants (Microsoft Entra External ID) have **no specific license requirement** to use branding themes. In these consumer-facing environments, the feature is considered Generally Available and can be used freely without purchasing P1/P2 licenses.

### Principle of Least Privilege: Administrator Roles

To securely delegate the management of sign-in screens to marketing or HR teams without granting sweeping Global Administrator powers, Microsoft utilizes distinct roles:

* **Organizational Branding Administrator:** This is the minimum role required to manage organizational branding, adhering to the principle of least privilege. This role can configure default tenant-wide branding, create app-specific themes, and define browser language customizations. The underlying permission driving this access is `microsoft.directory/loginOrganizationBranding/allProperties/allTasks`.
* **Application Administrator:** Creating a Branding Theme is only the first step; it must then be explicitly assigned to a target application. Because an Organizational Branding Administrator cannot modify enterprise application settings, a user must also possess the **Application Administrator** role (or be explicitly assigned as the "Owner" of that single application) to link the theme to the app.

---

## 3. Image Specifications, UI Layouts, and Visual Fallbacks

### Background Image Scaling and Device Responsiveness

* **Single Image Upload:** Administrators do not upload separate background images for mobile and desktop views. You provide a single background image (recommended size: 1920x1080 pixels, max 300 KB).
* **Dynamic Cropping:** The Entra ID system automatically scales and crops this single image to completely fill the browser window, dynamically adapting to whether the user is on a smartphone or a widescreen desktop monitor.

### Sign-In Box Layout Templates

Because dynamic scaling and the sign-in prompt itself can obscure parts of your background image, Microsoft provides two distinct visual layout templates configured via the **Layout** tab:

* **Full-screen background layout:** The background image fills the entire window, and the sign-in box is **center-aligned** directly in the middle of the screen. Because it sits in the center, it may block the focal point of your custom image.
* **Partial-screen background layout:** Often called the vertical split or ADFS template, this layout **aligns the sign-in box to the right side of the screen**. This is the recommended choice if your background image contains critical visual information that must remain visible and uncovered.

### The Page Background Color Fallback

* **The Problem:** If a user accesses your customized portal over a slow network connection or high-latency environment, the heavy background image may take several seconds to load, or fail entirely.
* **The Solution:** The system immediately displays your configured **Page background color** in the space behind the sign-in box as a reliable, fast-loading fallback.
* **Design Best Practice:** Microsoft highly recommends choosing a Page background color that closely matches the primary colors of your uploaded background image. This ensures a smooth, less jarring visual transition for the user as the full image eventually renders.

### Favicon Specifications

* The Favicon (the small logo displayed in the web browser's tab) is subject to strict constraints to ensure instantaneous loading. It must be exactly **$32 \times 32$ pixels** and cannot exceed a file size of **5 KB**.
* While JPGs are permitted, **PNG is explicitly the preferred format**. If omitted, it falls back to the default Microsoft logo.

---

## 4. Text Limitations, Markdown Formatting, and Custom Hyperlinks

### The Sign-in Page Text (Display Message Box)

Located at the bottom of the sign-in screen, the **Sign-in page text** is used to provide legal statements, help desk information, or instructions.

* **Character Limits:** It has a strict maximum limit of **1024 characters**. As a security best practice, sensitive organizational data should never be placed here, as the page is entirely public.
* **Rich Text Formatting:** Unlike other areas of the page, this specific box supports Markdown syntax. You can use `**bold**` for bolding, `*italics*` for italics, and `++underlines++` for underlining text.
* **Clickable Hyperlinks:** You can create active, clickable external links using the syntax `[text](link)`.
* **Native App Exception:** If users view this sign-in page within an embedded native environment (such as a thick desktop app or a mobile app webview), these formatted hyperlinks will automatically revert to rendering strictly as unclickable plain text.

### Footer Links Limitations

* Administrators can hide the default Microsoft footer links and provide custom URLs for the organization's 'Privacy & Cookies' or 'Terms of Use' policies.
* **Strictly Plain Text:** External URLs placed in the footer sections are explicitly displayed as static text and **are not clickable**. Users must manually highlight, copy, and paste the URL into their browser to navigate to it.

### Username Hint Text (External Tenants)

* For External Tenants (Entra External ID), administrators can customize the "Username hint text" within the **"Sign-in form"** tab.
* This text guides users on what to enter (e.g., "Member ID", "Customer ID", or "Email address"). This tab also houses the banner logo and square logos for light/dark themes.
* **Best Practice Constraint:** If your configuration allows standard guest users to authenticate on this exact same page, utilizing the username hint text is explicitly **not recommended**, as it can confuse external guests who do not possess a specialized Member ID.

---

## 5. Global Scaling, Localization, and Language Customizations

### Scaling Geographically with Browser Language Customizations

Instead of provisioning separate tenants for different geographic regions, organizations can configure **Browser language customizations**.

* **Detection:** The system automatically reads the language preference set in the user's web browser.
* **Override Logic:** If a customization exists for that language (e.g., French), the regional configuration explicitly **overrides the default, tenant-wide company branding**.
* **Fallback Logic:** If the French customization includes a translated banner logo but leaves the background image blank, the system dynamically pulls the background image from the Default branding layer.
* **RTL Support:** Microsoft Entra ID natively supports Right-to-Left (RTL) reading formats (like Arabic or Hebrew), automatically adjusting the visual layout of the sign-in page to accommodate the region.

### The Loss of Automatic Localization for Custom Text

Microsoft natively translates its default authentication prompts into dozens of supported languages. However, **defining custom text within a branding theme overrides the defaults, breaking the automatic localization**.

* If you type custom English text in a theme, a user with a Japanese browser will still see your English text.
* **The Fix:** An Organizational Branding Administrator must manually select "Add a language" to the theme and explicitly provide manual translations for those specific custom text strings to ensure a fully localized user experience.

---

## 6. Specialized Scenarios: B2B Authentication, MSAs, and Home Realm Discovery

### B2B Cross-Tenant Authentication Prioritization

When a B2B guest user from an external organization (e.g., Contoso) signs into an application hosted by a different organization (e.g., Fabrikam), you might assume Fabrikam's branding will show. This is incorrect.

* **Home Tenant Priority:** Microsoft Entra ID routes the authentication prompt back to the user's origin. Therefore, **the user's home tenant branding always takes precedence over the resource tenant's branding**.
* If the user's home tenant (Contoso) never configured custom branding, the user will see the default, unbranded Microsoft experience, entirely bypassing Fabrikam's customized visuals.

### Explicit Exclusion of Personal Microsoft Accounts (MSAs)

While B2B cross-tenant sign-ins respect the *home* organization's branding, **personal Microsoft accounts (MSAs) are explicitly excluded from this rule**.

* If a guest authenticates using an Xbox, Live, or Hotmail account, your organization's custom branding settings are bypassed.
* These MSA users will always be presented with the standard, unbranded Microsoft sign-in experience, regardless of whether they have typed in their email address.

### Bypassing Generic Screens with the WHR Parameter

* When a user visits a generic multitenant portal (like `https://myapps.microsoft.com`), the system displays a default Microsoft screen because it does not yet know which tenant they belong to. It only loads branding *after* the email is entered.
* **Home Realm Discovery (HRD):** Administrators can bypass this generic screen entirely by appending the **`whr`** (Home Realm) query string parameter to the URL.
* **Implementation:** By directing users to `https://myapps.microsoft.com/?whr=contoso.com`, you preemptively supply the domain hint. The system immediately pulls and renders your company's custom branding on the very first screen before the user touches their keyboard.

---

## 7. Advanced Extensibility: Graph API, Custom HTML, and Native Auth

### Automating Branding via Microsoft Graph API

For large-scale deployments, administrators do not need to click through the Azure Portal manually. They can completely automate visual customization using the Microsoft Graph API.

* **Resource Type:** Automation scripts must target the **`organizationalBranding`** resource type.
* **Endpoints:** The service can be accessed via the `/beta` endpoint, or administrators can query specific localized branding directly via the `/v1.0` endpoint (e.g., `https://graph.microsoft.com/v1.0/organization/`).
* **Capabilities:** Through these programmatic API calls, developers can automatically upload custom background images, modify the sign-in page color palette, and inject custom banner logos.

### Custom HTML Templates and Data Attribute Injection

In fully customized scenarios (like Azure AD B2C or External ID custom page layouts), developers provide a base HTML file where the core Microsoft authentication controls are dynamically injected into a mandatory `<div id="api"></div>` element.

* To pull previously uploaded Azure portal branding assets into this completely custom HTML structure, you must inject proprietary HTML data attributes anywhere *outside* of the `div id="api"` container.
* **Background Image:** `<img data-tenant-branding-background="true" />`
* **Banner Logo:** `<img data-tenant-branding-logo="true" />`
At runtime, Entra ID detects these specific attributes and automatically replaces them with the actual image files hosted in your tenant.

### Branding Themes vs. Native Authentication

For mobile applications, there is a fundamental architectural choice regarding how branding is applied.

* **Branding Themes (Browser-Delegated):** Applying a theme to a mobile app forces the app to temporarily redirect the user out of the native application interface and into a system browser to sign in on a Microsoft-hosted web page. You remain constrained by Microsoft's layouts.
* **Native Authentication (API-Centric):** Available in External ID, Native Authentication allows developers to build authentication screens directly into the mobile app's native UI using SDKs, with zero browser redirects. This empowers development teams to achieve stunning, **"pixel-perfect"** design with absolute, absolute control over the UX.

---

## 8. Configuration Tools and Service Constraints

### Live Preview Limitations

The Microsoft Entra admin center includes a "Live Preview" button to help administrators visualize their theme creations before deploying them to live applications. However, this feature has strict constraints to memorize for the exam:

* **Scope:** It provides visualization exclusively for the **Sign in page**. It does not provide an interactive simulation of other flows like sign-up, one-time code entry, or attribute collection pages.
* **Text Constraint:** The live preview is strictly designed to preview structural layout choices and style changes (e.g., background colors, logos, and box alignment). Critically, **it does not show custom text overrides**. If you have manually localized text strings or updated the display message box, you will not see those changes in the Live Preview; you must assign the theme to a live app and test it in a real browser session to verify text configurations.
