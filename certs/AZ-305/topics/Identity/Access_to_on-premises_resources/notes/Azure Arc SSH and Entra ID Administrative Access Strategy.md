# Azure Arc SSH and Entra ID Administrative Access Strategy

Great job on selecting the correct answer! This scenario tests your ability to provide secure, administrative infrastructure access without exposing your on-premises network.

Here is a detailed breakdown of why **Azure Arc-enabled servers with Entra ID authentication** is the exact right answer, how it avoids traditional network exposure, and the specific limitations you should remember for the AZ-305 exam:

**1. Eliminating VPNs and Inbound Ports**
Historically, accessing an on-premises server required opening inbound SSH firewall ports (port 22) or requiring administrators to connect to a VPN. **Azure Arc SSH bypasses these requirements entirely** [1, 2]. The Azure Connected Machine agent running on the server maintains an outbound connection to Azure. When an administrator initiates an SSH session, the traffic is securely tunneled through the Azure Arc connectivity platform [1, 3]. This means you never have to expose a public IP address or open any inbound firewall rules on your on-premises network [1, 2].

**2. Centralizing Authorization with Azure RBAC and Entra ID**
Instead of manually managing local Linux accounts or distributing SSH keys, you can authorize SSH access centrally using Microsoft Entra ID and Azure RBAC [3, 4]. 
To grant a user the ability to sign in to the operating system, you assign them one of two specific Azure data-plane roles:
*   **Virtual Machine Administrator Login:** Grants root/administrator privileges [5, 6].
*   **Virtual Machine User Login:** Grants standard, regular user privileges [5, 6].

**3. The "Two Gates" of Authorization**
It is important to remember that there are two separate authorization gates for Arc SSH. A user with the `Owner` or `Contributor` role on the Arc resource is authorized to *create the SSH connection* across the control plane, but this does not automatically grant them the right to actually log into the operating system [1, 5, 7]. You must explicitly assign the specific VM Login roles mentioned above to allow the Entra ID OS login, which intentionally separates who can manage the Azure resource from who can access the server's data plane [1, 5, 7]. 

**Architectural Takeaways for the AZ-305 Exam:**
When designing remote administrative access, memorize these strict boundaries:
*   **The OS Limitation:** Entra ID OS login over Arc SSH is **Linux-only** and requires the `AADSSHLoginForLinux` extension package [1, 8]. While you can use Arc SSH to securely connect to Windows servers, the OS login for Windows Arc SSH currently only supports local-user authentication [1, 8].
*   **Server Admin vs. App Access:** Choose **Azure Arc SSH** when the target is the server itself and the requirement is strictly administrative access [7]. If the requirement is to publish a web application or provide per-app access to end-users rather than administering the server, you must choose **Microsoft Entra application proxy** or **Microsoft Entra Private Access** instead [7].