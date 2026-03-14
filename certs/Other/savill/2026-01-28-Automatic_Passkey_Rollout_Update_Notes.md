# Automatic Passkey Rollout Update - Exam Notes

**Video:** [https://www.youtube.com/watch?v=hAm_DcqH0nY](https://www.youtube.com/watch?v=hAm_DcqH0nY)  
**Published:** 2026-01-28  
**Duration:** 10:43  

*Generated on 2026-01-28 06:11*

---

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Introduction](#introduction)
* [Benefits of passkeys](#benefits-of-passkeys)
* [Synced and device-bound](#synced-and-device-bound)
* [Authorization layer](#authorization-layer)
* [What is changing](#what-is-changing)
* [Registration campaign change](#registration-campaign-change)
* [Summary](#summary)
* [Close](#close)

## Introduction

**Timestamp**: 00:00:00 – 00:00:13

**Key Concepts**

- Phishing resistance in authentication methods
- Requirement of proximity for authentication

**Definitions**

- **Phishing resistant**: Authentication methods that prevent attackers from tricking users into revealing credentials.
- **Proximity requirement**: The need for the authenticating device to be physically near the device requesting authentication.

**Key Facts**

- Authentication requires the passkey device to be within range via Bluetooth, NFC, or USB.

**Examples**

- Using a passkey stored on a phone that must be near the authenticating device.

**Key Takeaways 🎯**

- Passkey-based authentication enhances security by requiring physical proximity.
- This proximity requirement helps prevent phishing attacks by ensuring the authenticating device is nearby.

---

## Benefits of passkeys

**Timestamp**: 00:00:13 – 00:01:39

**Key Concepts**

- Passkeys provide phishing resistance.
- Passkeys require physical proximity between devices for authentication.
- Passkeys validate the domain name to prevent misuse on fraudulent sites.
- Passkeys enable fast and strong authentication.

**Definitions**

- **Passkey**: A credential stored on a device (such as a phone) used for authentication that requires proximity and domain validation to enhance security.

<img src='.img/2026-01-29-05-13-01.png' width=200>

**Key Facts**

- Authentication requires the passkey device to be within range via Bluetooth, NFC, or USB.
- Passkeys prevent users from being tricked into authenticating to bad actors posing as legitimate entities.
- Passkeys verify that the domain name matches exactly (e.g., Microsoft.com vs. microfiveof.com) to avoid credential theft.
- Passkeys provide strong protection against phishing attacks.
- Authentication with passkeys is very fast.

**Examples**

- Using a passkey stored on a phone that must be near the authenticating device.
- Preventing authentication on a fake domain like "microfiveof.com" instead of "Microsoft.com."

**Key Takeaways 🎯**

- Passkeys significantly reduce phishing risks by requiring device proximity and domain validation.
- They ensure credentials cannot be stolen or misused on fraudulent websites.
- Passkeys combine strong security with fast authentication, improving user experience and protection.

---

## Synced and device-bound

**Timestamp**: 00:01:39 – 00:03:52

**Key Concepts**

- Difference between device-bound passkeys and synced passkeys  
- Device-bound passkeys are stored on a single device and can use attestation  
- Synced passkeys are shared across multiple devices within the same ecosystem but do not support attestation  
- Synced passkeys improve user convenience by being available on multiple devices  
- Passkeys focus on strong authentication (AuthN), while authorization (AuthZ) is handled separately (e.g., via conditional access)

<img src='.img/2026-01-29-05-14-31.png' width=400>

**Definitions**

- **Device-bound passkey**: A passkey stored on a specific device (e.g., USB dongle, authenticator app on a phone) that does not sync to other devices and can be cryptographically attested via hardware.  
- **Synced passkey**: A passkey that is synchronized across multiple devices within the same ecosystem (e.g., Apple devices, Android devices) allowing use on all those devices but lacking attestation due to no standard for cross-device hardware verification.

**Key Facts**

- Device-bound passkeys can be attested cryptographically through hardware and a root signing certificate from FIDO2.  
- Synced passkeys sync only within a single ecosystem (Apple, Android, Chrome) and do not sync across different ecosystems.  
- Multiple passkeys can be created on different ecosystems (e.g., one on Apple, one on Android).  
- Synced passkeys are more user-friendly and reduce the risk of losing access since they are not tied to a single device.  
- **Attestation is not possible with synced passkeys because there is no agreed standard for attestation across multiple hardware devices.**

**Examples**

- Device-bound passkey example: Passkey stored on a USB dongle or authenticator app on a phone.  
- Synced passkey example: A passkey created once on an Apple device that syncs across iPhones, iPads, and Macs within the Apple ecosystem.  
- Another example: Passkeys syncing across Android devices or available in Chrome browser within that ecosystem.

**Key Takeaways 🎯**

- Synced passkeys enhance usability by allowing a single passkey to be used across multiple devices in the same ecosystem.  
- Device-bound passkeys provide stronger hardware-backed attestation but are limited to one device.  
- Lack of attestation in synced passkeys is a trade-off for convenience and cross-device availability.  
- Passkeys are focused on authentication (proving identity), while authorization policies (like conditional access) still control access permissions and device management.  
- Users can maintain multiple passkeys across different ecosystems for flexibility.

---

## Authorization layer

**Timestamp**: 00:03:52 – 00:04:43

**Key Concepts**

- Distinction between authentication (authN) and authorization (authZ)
- Passkeys focus on strong authentication (authN)
- Authorization involves additional checks beyond authentication, such as device management and health status
- Conditional Access policies can enforce authorization requirements even when strong authentication is present

<img src='.img/2026-01-29-05-15-28.png' width=400>

**Definitions**

- **Authentication (AuthN)**: The process of proving identity, i.e., confirming "I am who I say I am."
- **Authorization (AuthZ)**: The process of determining what an authenticated user is allowed to do or access.
- **Conditional Access**: A policy framework (e.g., in Microsoft Entra) that evaluates conditions like device compliance and credential strength before granting access.

**Key Facts**

- Passkeys provide strong authentication but do not inherently control authorization.
- Conditional Access can require that a device be managed (e.g., by Intune) and healthy before allowing access.
- Even if a passkey is synced across multiple devices, authorization policies can restrict usage to compliant devices only.

**Examples**

- Conditional Access policy requiring a managed device (managed by Intune) and device health in addition to a strong credential (passkey).

**Key Takeaways 🎯**

- Passkeys enhance authentication security but are only one factor in access control.
- Authorization layers like Conditional Access are essential to enforce device compliance and other security requirements.
- Strong authentication does not automatically grant access; authorization policies must also be satisfied.
- Organizations can combine passkey authentication with device management policies to strengthen overall security posture.

---

## What is changing

**Timestamp**: 00:04:43 – 00:08:24

**Key Concepts**

- Transition from preview to default passkey profile management in Azure AD authentication methods.
- Passkey profiles control whether passkeys are device bound or synced, and whether attestation is required.
- Existing FIDO2 authentication method settings influence the new default passkey profile configuration.
- Attestation requirement restricts passkeys to device bound only; without attestation, both device bound and synced passkeys are allowed.
- Targeting and assignment of passkey profiles will honor existing group assignments and configurations.
- Multiple passkey profiles can be created and targeted to different user groups.
- Registration campaigns will shift from SMS/phone call methods to passkey-based authentication.

<img src='.img/2026-01-29-05-16-36.png' width=700>

<img src='.img/2026-01-29-05-16-48.png' width=700>

<img src='.img/2026-01-29-05-17-27.png' width=700>

<img src='.img/2026-01-29-05-17-58.png' width=700>

<img src='.img/2026-01-29-05-18-24.png' width=700>

**Definitions**

- **Passkey Profile**: A configuration profile that defines how passkeys are managed, including options for device binding, syncing, and attestation requirements.
- **Attestation**: A security feature that verifies the authenticity of a security key or credential; when required, synced passkeys are not allowed.
- **Device Bound Passkey**: A passkey that is tied to a single device and cannot be synced across devices.
- **Synced Passkey**: A passkey that can be synchronized across multiple devices for user convenience.
- **Registration Campaign**: A process or policy that encourages or requires users to register authentication methods, now evolving to support passkeys instead of traditional SMS or phone call methods.

**Key Facts**

- The default passkey profile will be automatically created based on current FIDO2 authentication method settings.
- Timeline for rollout:
  - Worldwide: Preview in March; automatic enablement April through May.
  - GCC, GCC High, DoD: Enablement in April; automatic rollout in June.
- If attestation is enabled, only device bound passkeys are allowed.
- If attestation is disabled, both device bound and synced passkeys are allowed.
- Existing targeting (group assignments) will be applied to the new default passkey profile.
- The enablement toggle for passkeys will disappear once fully enabled for all users.

**Examples**

- An organization with attestation enabled will have a default passkey profile allowing only device bound passkeys.
- Another organization without attestation enabled will have a default profile allowing both device bound and synced passkeys.
- A synced passkey profile can be targeted to specific groups, while device bound passkeys are enabled for everyone.
- Registration campaigns that previously targeted SMS or phone calls will now use passkeys, leveraging Microsoft Authenticator for device bound and synced passkeys.

**Key Takeaways 🎯**

- The new default passkey profile simplifies management by basing settings on existing FIDO2 configurations.
- Attestation setting is a critical factor determining whether synced passkeys are permitted.
- Organizations can create multiple passkey profiles to tailor authentication experiences for different user groups.
- The shift in registration campaigns to passkeys reflects a move toward stronger, passwordless authentication methods.
- Administrators should review current FIDO2 attestation settings to understand how the new default passkey profile will be configured.
- Early creation and refinement of passkey profiles are possible once the feature is enabled in the tenant.

---

## Registration campaign change

**Timestamp**: 00:08:24 – 00:09:54

**Key Concepts**

- Registration campaign method targeting is changing from SMS/phone calls to passkeys.
- Different passkey types: device bound vs. synced passkeys.
- Passkeys provide superior security compared to previous methods.
- Configuration changes maintain existing settings but add flexibility for targeting different user groups.
- Ability to enable device bound passkeys for sensitive users and synced passkeys for general users.

<img src='.img/2026-01-29-05-19-23.png' width=700>

**Definitions**

- **Registration campaign**: A process that targets users to register authentication methods, previously via SMS or phone calls, now shifting to passkeys.
- **Device bound passkeys**: Passkeys stored locally on a device, typically used with Microsoft Authenticator.
- **Synced passkeys**: Passkeys that are synchronized across devices and targeted to specific user groups.

**Key Facts**

- If only device bound passkeys are used, the registration campaign will use Microsoft Authenticator.
- If synced passkeys are available, the registration campaign will use passkeys accordingly.
- If the registration campaign is disabled, no changes occur.
- Existing configurations are preserved; enabling passkeys does not override attestation requirements.
- Admins can refine and customize passkey profiles after enabling them for the tenant.

**Examples**

- Device bound passkeys targeted to sensitive users.
- Synced passkeys enabled for general or task-based workers.

**Key Takeaways 🎯**

- The registration campaign now promotes passkeys instead of SMS or phone calls.
- Passkeys enhance security and are being rolled out as an option for all users.
- Existing configurations remain intact; admins have granular control over which users get device bound vs. synced passkeys.
- It’s important to review and adjust passkey profiles after enabling to align with organizational needs.
- Documentation is available in the message center for further details.

---

## Summary

**Timestamp**: 00:09:54 – 00:10:23

**Key Concepts**

- Passkeys offer superior security compared to previous methods.
- Passkeys will be enabled as an option for all users while maintaining existing configurations.
- Administrators can configure passkey settings with granularity based on user needs.
- Device-bound passkeys can be assigned to sensitive users.
- Synced passkeys can be enabled for general or task-based workers.

**Definitions**

- **Passkeys**: A secure authentication method that improves security over traditional credentials.
- **Device-bound passkeys**: Passkeys tied specifically to a user’s device, enhancing security for sensitive users.
- **Synced passkeys**: Passkeys that are synchronized across devices, suitable for general or task-based users.

**Key Facts**

- Enabling passkeys will not override existing attestation configurations.
- If attestation is not enabled, synced passkeys will be enabled by default.
- Administrators have the ability to review and tweak passkey configurations once enabled.
- Full documentation is available in the message center for further details.

**Examples**

- Assigning device-bound passkeys to sensitive users.
- Enabling synced passkeys for general or task-based workers.

**Key Takeaways 🎯**

- Passkeys enhance security and are now available as an optional feature.
- Existing configurations remain intact; enabling passkeys does not disrupt current setups.
- Administrators can apply granular controls to decide which users get device-bound versus synced passkeys.
- Review the message center documentation to understand and manage passkey settings effectively.

---

## Close

**Timestamp**: 00:10:23 – unknown

**Key Concepts**

- Configuration flexibility for passkey attestation and sync
- Granular control over device-bound and synced passkeys per user group
- Importance of reviewing and tweaking tenant settings after feature enablement

**Definitions**

- **Attestation**: A process that, when enabled, restricts sync passkeys unless attestation is performed.
- **Sync Passkeys**: Passkeys that are synchronized across devices for user convenience.

**Key Facts**

- Enabling attestation currently prevents automatic enabling of sync passkeys.
- Without attestation, sync passkeys are enabled by default.
- Administrators can configure settings to have device-bound passkeys for sensitive users and synced passkeys for general or task-based workers.
- Full documentation is available in the message center for detailed configuration guidance.

**Examples**

- Device-bound passkeys can be assigned to sensitive users.
- Sync passkeys can be enabled for general or task-based workers.

**Key Takeaways 🎯**

- After enabling the feature for your tenant, review and adjust configurations to suit different user groups.
- Use the granular controls to balance security (device-bound) and convenience (sync) based on user roles.
- Refer to the official documentation in the message center for comprehensive setup instructions.
- This approach helps maintain security posture while providing flexibility in passkey management.
