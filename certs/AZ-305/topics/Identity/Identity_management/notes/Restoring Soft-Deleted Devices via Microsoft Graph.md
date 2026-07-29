# Restoring Soft-Deleted Devices via Microsoft Graph

Your choice of "Re-registering the device manually" is a very logical guess because, historically, accidentally deleting a device meant it was permanently destroyed and the only path forward was starting over with a new registration. However, the introduction of the device soft delete feature fundamentally changes this recovery architecture.

Here is a detailed breakdown of why your answer was incorrect and how the new soft delete capability works:

**1. Why you cannot simply re-register the device**
When a device is soft deleted, it is moved to a suspended container rather than being permanently removed [1, 2]. During this suspended state, **the device's unique `DeviceId` remains reserved** [3, 4]. Because this ID is locked to prevent duplicate registrations, **no new device can register with that exact same `DeviceId`** until the soft-deleted object is either fully restored or permanently (hard) deleted [4]. 

**2. Why Microsoft Graph or PowerShell is the correct answer**
Because the device soft delete feature is currently in **Public Preview**, Microsoft has not yet released the graphical portal experience (Azure portal / Microsoft Entra admin center) for viewing or restoring these suspended devices [3, 5]. Until the feature reaches General Availability (GA), the only supported way for an administrator to list and restore soft-deleted devices is programmatically by using **the Microsoft Graph API or the Microsoft Graph PowerShell module** [3, 5]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing a recovery strategy, remember that **soft-deleted devices remain recoverable for exactly 30 days** before they are automatically hard deleted [3, 6]. While in this suspended state, they cannot authenticate to Microsoft Entra ID, and querying them in standard portal lists will return an HTTP 404 Not Found error [3, 4]. 

Despite being hidden, restoring them via Graph or PowerShell is highly preferable to manual re-registration because a soft-delete restore perfectly preserves the device's unique identifiers, **BitLocker recovery keys**, and **Local Administrator Password Solution (LAPS) passwords** [2, 7]. If the device were to be hard deleted and manually re-registered instead, all of that critical data would be permanently lost [8].