# The Linux Identity Broker Migration Guide

Great job on selecting the correct answer! This question tests your knowledge of the specific architectural changes and operational requirements involved in updating the **Microsoft Identity Broker for Linux**.

Here is a detailed breakdown of why this architectural shift requires users to re-register and re-enroll, and what happens under the hood during this upgrade:

**1. The Major Architectural Shift (Java to C++)**
Beginning with version 2.0.2, the Microsoft Identity Broker for Linux underwent a massive underlying change, moving away from its previous Java-based implementation to a newly rewritten C++ broker [1, 2]. Because this is a fundamental rewrite rather than a simple in-place update, migrating from an older version (like 2.0.1) to the new C++ version will cause authentication failures if the old state is left intact [3]. 

To fix this, a complete uninstall and clean reinstall are required: administrators must remove all previous broker state, install the new version, and then users must re-register the device [3].

**2. A New Trust Model: Registration vs. Join**
The new C++ broker fundamentally changes how Linux devices establish trust with Microsoft Entra ID. Previously, configuring single sign-on resulted in a **Microsoft Entra registration**, which only creates a trust boundary within the specific user's profile [2, 4]. 

With the new broker, the device performs a **Microsoft Entra join** instead, which establishes a trust with the *entire device* [2, 4]. This transition to a device-wide join is a critical prerequisite step for enabling future features like platform SSO [2, 4].

**3. Storage and Cryptographic Changes**
The location and handling of cryptographic materials have also been heavily modified in the new architecture:
*   **Certificate Storage:** Device certificates are no longer stored in the user's Keychain. Instead, they are moved to the system-level `/etc/ssl/private` directory [2, 4]. 
*   **Key Material:** Within that private directory, the new broker generates a device certificate per tenant, a session transport key per tenant, and a deviceless key [2, 4].
*   **User Data:** Other user-specific data, such as access tokens and refresh tokens, remain stored in the Keychain and are accessed via the Microsoft Authentication Library (MSAL) [2, 4].

**4. Service Component Restructuring**
The backend services that run the broker were also restructured. The device broker service was renamed to `microsoft-identity-devicebroker`, and the user broker (previously a service named `microsoft-identity-broker`) is now an executable that is invoked over a D-Bus connection [2, 4].

**Architectural Takeaway for the AZ-305 Exam:**
When planning a deployment or migration involving Linux endpoints, you must account for this hard boundary. You cannot seamlessly perform an in-place upgrade from the Java broker to the C++ broker. Your migration plan must include a step to clear the old broker state and explicitly prompt your Linux users to **re-register and re-enroll** their devices to establish the new device-wide Microsoft Entra join trust [1, 3, 4].