# Microsoft Entra Device Soft Delete Mechanics and Resource Impact

It is completely understandable why you might guess that soft-deleted devices appear in standard portal lists. In many other systems, deleting an item simply moves it to a visible "Recycle Bin" view within the standard interface. However, the Microsoft Entra device soft delete preview behaves differently.

Here is a detailed breakdown of why your answer was incorrect and how device soft deletion actually works:

**1. Why "appear in standard portal device lists" is incorrect**
When a device is soft deleted, the Azure Device Registration Service (ADRS) moves the device object into a separate, suspended soft-deleted container in the directory [1]. Because it is moved out of the active container, **the device is intentionally hidden from the Azure portal device list, Intune, and standard Microsoft Graph queries** [2]. In fact, if you attempt to run a standard query for the device, it will return an HTTP 404 Not Found error [2, 3]. 

**2. Why "consumes 25% of an active object's directory quota" is correct**
Even though the soft-deleted device is hidden from your portal views, it is not completely purged from the directory. The device retains its unique `DeviceId`, BitLocker recovery keys, and Local Administrator Password Solution (LAPS) passwords so that it can be perfectly restored if needed [1, 2, 4]. Because this "tombstone" object is still being retained in the background, it continues to consume **one-quarter (25%) of an active object's directory quota** [2, 5]. 

**Architectural Takeaway for the AZ-305 Exam:**
When designing device lifecycles and recovery plans, remember these specific boundaries for the device soft delete preview:
*   **Visibility:** Soft-deleted devices are hidden from normal portal lists [3].
*   **Authentication:** The device cannot authenticate or access cloud resources while in this suspended state [2, 5].
*   **Retention:** The device remains in this soft-deleted state for exactly **30 days** before it is automatically permanently (hard) deleted [5, 6]. 
*   **Recovery:** As we covered in a previous question, there is currently no portal-based restore experience during the preview phase; you must use Microsoft Graph or PowerShell to restore them [5, 7].