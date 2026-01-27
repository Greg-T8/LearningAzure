## AD Device Management

---

### Intro to Device Management

**Timestamp**: 00:57:31 – 01:00:14

**Key Concepts**  
- Device management in Azure AD involves managing physical devices (phones, tablets, laptops, desktops) that access company resources.  
- Device management helps protect organizational assets, especially in distributed or remote work environments and BYOD scenarios.  
- There are three primary ways to get devices into Azure AD:  
  1. Azure AD Registered  
  2. Azure AD Joined  
  3. Hybrid Azure AD Joined  

**Definitions**  
- **Device Management**: The administration of physical devices granted access to company resources such as printers and cloud services, often controlled via device-based conditional access.  
- **Azure AD Registered Device**: A device personally owned by the user, signed in with a personal Microsoft or local account, typically used for BYOD or mobile devices.  
- **Azure AD Joined Device**: A device owned by the organization, signed in with an Azure AD organizational account, cloud-native, typically Windows 10 or Windows Server 2019 VMs.  
- **Hybrid Azure AD Joined Device**: A device owned by the organization, signed in with an Azure AD Domain Services account, existing both on-premises and in the cloud, supporting older OS versions like Windows 7, 8.1, 10, and Windows Server 2008 or newer.  

**Key Facts**  
- Azure AD Registered devices are primarily personal devices (BYOD) and support Windows 10, iOS, Android, and Mac OS.  
- Azure AD Joined devices are cloud-native and owned by the organization.  
- Hybrid Azure AD Joined devices support both cloud and on-premises environments and older Windows OS versions.  
- Device management is critical for securing organizational resources when employees work remotely or use personal devices.  

**Examples**  
- Devices listed in Azure AD device management can include desktops, laptops, phones, tablets.  
- BYOD scenario: personal mobile devices registered as Azure AD Registered.  
- Organizational laptops running Windows 10 or Windows Server 2019 VMs as Azure AD Joined.  
- On-premises Windows 7 or Windows Server 2008 devices as Hybrid Azure AD Joined.  

**Key Takeaways 🎯**  
- Remember the ownership and sign-in account distinctions:  
  - Azure AD Registered = personal device + personal account  
  - Azure AD Joined = organization-owned + cloud-only account  
  - Hybrid Azure AD Joined = organization-owned + cloud/on-prem account  
- For exam questions about on-premises device management, Hybrid Azure AD Joined is the correct choice.  
- Understand the supported OS types for each join type to select the correct device management approach.  
- Device management is essential for securing resources in distributed and BYOD environments.

---

### AD Registered Devices

**Timestamp**: 01:00:14 – 01:01:57

**Key Concepts**  
- AD Registered Devices represent one of the three ways to get devices into Azure Active Directory.  
- These devices are registered to Azure AD without requiring organizational accounts to sign into the device, meaning they typically use personal accounts.  
- Commonly used in Bring Your Own Device (BYOD) scenarios or mobile devices.  
- Device ownership can be either user-owned or organization-owned, but primarily personal.  
- Supported operating systems include Windows 10, iOS, Android, and Mac OS.  
- Provisioning methods vary by OS: Windows 10 settings, iOS/Android company portal with Microsoft Authenticator app, Mac OS company portal.  
- Device sign-in options include end user local credentials such as password, Windows Hello, and PIN.  
- Device management is done through Mobile Device Management (MDM) like Microsoft Intune and Mobile Application Management (MAM).  
- Key capabilities include Single Sign-On (SSO) to cloud resources, conditional access when enrolled in Intune, app protection policies, and enabling phone sign-in via Microsoft Authenticator app.

**Definitions**  
- **AD Registered Device**: A device registered to Azure AD that does not require an organizational account to sign in, typically using personal accounts.  
- **Windows Hello**: An alternative Windows 10 sign-in method using biometrics such as fingerprint, iris scan, or facial recognition.  
- **Mobile Device Management (MDM)**: A management system (e.g., Microsoft Intune) used to control and secure devices.  
- **Mobile Application Management (MAM)**: Similar to MDM but focuses on managing and protecting apps on devices.

**Key Facts**  
- AD Registered Devices are primarily for personal or BYOD scenarios.  
- Supported OS: Windows 10, iOS, Android, Mac OS.  
- Sign-in options include password, PIN, Windows Hello (biometrics).  
- Management tools include Microsoft Intune for both MDM and MAM.  
- Enables SSO, conditional access, app protection policies, and phone sign-in with Microsoft Authenticator.

**Examples**  
- BYOD or mobile devices using personal accounts registering to Azure AD.  
- Using Windows Hello biometric sign-in on Windows 10 devices.  
- Provisioning iOS or Android devices via company portal and Microsoft Authenticator app.

**Key Takeaways 🎯**  
- Remember AD Registered Devices are primarily for personal accounts and BYOD scenarios.  
- Know the supported operating systems and provisioning methods for these devices.  
- Understand the difference between device sign-in options, especially Windows Hello as a biometric alternative.  
- Be familiar with management capabilities via MDM (Intune) and MAM.  
- Key exam focus: AD Registered Devices enable SSO, conditional access, app protection policies, and phone sign-in with Microsoft Authenticator.  
- Windows Hello may appear on the exam—know it provides biometric sign-in options like fingerprint, iris, or facial recognition.

---

### Windows Hello

**Timestamp**: 01:01:57 – 01:02:31

**Key Concepts**  
- Windows Hello provides alternative authentication methods for Windows 10 users.  
- It enables biometric sign-in options such as fingerprint, iris scan, and facial recognition.  

**Definitions**  
- **Windows Hello**: A Windows 10 feature that allows users to log into their devices and applications using biometric authentication methods instead of traditional passwords.  

**Key Facts**  
- Supports fingerprint, iris scan, and facial recognition as login methods.  
- Designed to offer a more secure and convenient sign-in experience.  

**Examples**  
- Iris scanner mentioned as a biometric option (noted as a cool but potentially costly feature).  

**Key Takeaways 🎯**  
- Remember Windows Hello as an alternative sign-in method using biometrics.  
- Be familiar with the types of biometric authentication Windows Hello supports (fingerprint, iris, face).  
- Expect questions about Windows Hello on exams, especially regarding its purpose and authentication methods.  

---

### MDM and MAM

**Timestamp**: 01:02:31 – 01:04:16

**Key Concepts**  
- Mobile Device Management (MDM) controls the entire device, allowing actions like wiping data and resetting to factory settings.  
- Mobile Application Management (MAM) controls apps individually by publishing, pushing, configuring, securing, monitoring, and updating mobile apps.  
- MDM and MAM are managed under Azure Active Directory (Azure AD) in the "mobility" section.  
- Microsoft Intune is the primary service used to implement MDM and MAM.  
- Microsoft Intune requires Azure AD Premium P2 license.  
- Microsoft Intune is part of Microsoft Endpoint Manager, which itself is part of Microsoft Enterprise Mobility + Security (EMS).  
- EMS is an umbrella platform that includes Azure AD, Microsoft Endpoint Configuration Manager, Microsoft Intune, and other services.  

**Definitions**  
- **Mobile Device Management (MDM)**: A management approach that controls entire devices, enabling actions such as wiping data and factory resetting devices.  
- **Mobile Application Management (MAM)**: A management approach focused on controlling and securing individual mobile applications, including publishing, configuring, and updating apps.  
- **Microsoft Intune**: A cloud-based service used to apply MDM and MAM policies, part of Microsoft Endpoint Manager and EMS.  
- **Enterprise Mobility + Security (EMS)**: Microsoft's intelligent mobility management and security platform that protects organizations and enables flexible work.  

**Key Facts**  
- To use Microsoft Intune, an upgrade to Azure AD Premium P2 is required.  
- Microsoft Intune and Endpoint Manager are often referenced interchangeably or together in the context of device and app management.  
- EMS includes multiple services, but the two most important to remember for MDM/MAM are Microsoft Intune and Azure Active Directory.  
- The naming and bundling of these services can be confusing due to marketing and business reasons.  

**Examples**  
- None mentioned explicitly, but the concept of wiping company devices or managing apps remotely was implied as practical use cases.  

**Key Takeaways 🎯**  
- Remember the distinction: MDM controls the whole device; MAM controls apps individually.  
- Microsoft Intune is the go-to service for implementing both MDM and MAM.  
- Intune requires Azure AD Premium P2 license—know this for exam scenarios involving licensing.  
- EMS is the overarching platform that includes Intune and Azure AD—understand this hierarchy.  
- Don’t get confused by the overlapping names: Microsoft Intune, Endpoint Manager, and EMS are closely related and often discussed together in device/app management contexts.  
- Focus on Intune and Azure AD as the core services for MDM and MAM in Microsoft environments.

---

### EMS

**Timestamp**: 01:04:16 – 01:05:10

**Key Concepts**  
- EMS stands for Enterprise Mobility + Security.  
- EMS is an intelligent mobility management and security platform.  
- EMS protects and secures organizations while enabling flexible work for employees.  
- EMS is an umbrella for multiple Microsoft and Azure services.  
- Key components to remember within EMS are Microsoft Intune and Azure Active Directory (Azure AD).  
- Microsoft Intune is part of Microsoft Endpoint Manager, which itself is part of EMS.  
- EMS relates closely to Mobile Device Management (MDM) and Mobile Application Management (MAM).

**Definitions**  
- **EMS (Enterprise Mobility + Security)**: A Microsoft platform that provides intelligent mobility management and security to protect organizations and empower flexible employee work styles.  
- **Microsoft Intune**: A cloud-based service within EMS used for device and application management (MDM and MAM).  
- **Azure Active Directory (Azure AD)**: A cloud-based identity and access management service, also part of EMS.

**Key Facts**  
- To use Microsoft Intune, an upgrade to Azure AD Premium 2 is required.  
- EMS includes Azure Active Directory, Microsoft Endpoint Configuration Manager, Microsoft Intune, and other services.  
- Microsoft Intune and Azure AD are the two most important EMS components to focus on for exams.  
- EMS components and naming can be confusing due to marketing and business reasons, but they generally revolve around device and identity management.

**Examples**  
- None specifically mentioned in this section.

**Key Takeaways 🎯**  
- Remember EMS as the overarching Microsoft platform for enterprise mobility and security.  
- Focus on Microsoft Intune and Azure Active Directory as the core EMS services relevant for exams.  
- Understand that Intune is part of Microsoft Endpoint Manager, which is under EMS.  
- Be aware that EMS deals with MDM and MAM concepts.  
- Don’t get confused by the overlapping names and marketing terms—EMS bundles these related services.

---

### MS Authenticator App

**Timestamp**: 01:05:10 – 01:05:50

**Key Concepts**  
- Microsoft Authenticator is an app used for secure sign-ins across multiple accounts.  
- Supports multi-factor authentication (MFA).  
- Enables passwordless sign-in or auto-fills passwords.  
- Available on Google Play Store and Apple App Store.  
- Useful for managing registered devices and enhancing security.

**Definitions**  
- **Microsoft Authenticator**: An application that facilitates secure sign-ins using multi-factor authentication, allowing passwordless login or password autofill for registered devices.

**Key Facts**  
- The app supports passwordless authentication, reducing reliance on passwords.  
- It is compatible with both Android and iOS devices.  
- Recommended to install for hands-on experience with its capabilities.

**Examples**  
- None specifically mentioned beyond general use for registered devices and accounts.

**Key Takeaways 🎯**  
- Understand Microsoft Authenticator as a key tool for MFA and passwordless sign-in.  
- Remember it is widely available and supports multiple account types.  
- Installing and using the app is recommended to gain practical familiarity.  
- It plays a role in device management and secure authentication in Azure environments.

---

### AD Joined Devices

**Timestamp**: 01:05:50 – 01:07:35

**Key Concepts**  
- AD Joined Devices are joined only to Azure Active Directory (Azure AD).  
- Require organizational (work or school) accounts to sign into the device, not personal accounts.  
- Suitable for both cloud-only and hybrid organizations (hybrid meaning on-premises + cloud).  
- Device ownership is organizational (company-owned devices).  
- Supported operating systems include Windows 10 Pro (not Windows 10 Home) and Windows Server 2019 (virtual machines in Azure). Server Core is not supported.  
- Provisioning methods include self-service via Windows Out-Of-Box Experience (OOBE), bulk enrollment, and Windows Autopilot.  
- Device sign-in options include organizational accounts with passwords, Windows Hello for Business, and FIDO 2.0 security keys.  
- Device management can be done via Mobile Device Management (MDM), co-management with Microsoft Intune and Microsoft Endpoint Configuration Manager.  
- Key capabilities include Single Sign-On (SSO) to cloud and on-premises resources, conditional access based on MDM enrollment and compliance, self-service password reset, Windows Hello PIN reset on lock screen, and enterprise state roaming across devices.

**Definitions**  
- **AD Joined Device**: A device joined exclusively to Azure AD that requires an organizational account for sign-in.  
- **Windows Autopilot**: A provisioning method for setting up devices (mentioned as upcoming topic).  
- **FIDO 2.0 Security Keys**: Authentication keys based on Fast Identity Online Alliance standards for passwordless or multi-factor authentication.

**Key Facts**  
- Windows 10 Home edition is not supported for AD join; only Windows 10 Pro and above.  
- Windows Server 2019 VMs in Azure are supported; Server Core is not.  
- Sign-in options include passwords, Windows Hello for Business, and FIDO 2.0 security keys.  
- Device management supports MDM and co-management with Intune and Endpoint Configuration Manager.  
- Supports SSO to both cloud and on-premises resources.  
- Conditional access policies rely on MDM enrollment and compliance status.  
- Self-service password reset and Windows Hello PIN reset are available directly on the lock screen.  
- Enterprise state roaming allows user settings and data to roam across devices.

**Examples**  
- None specifically mentioned beyond supported OS and provisioning methods.

**Key Takeaways 🎯**  
- Remember AD Joined devices require organizational accounts and are primarily for company-owned devices.  
- Know the supported OS versions: Windows 10 Pro (not Home) and Windows Server 2019 (no Server Core).  
- Understand provisioning options: Windows OOBE, bulk enrollment, and Autopilot.  
- Be familiar with sign-in options including FIDO 2.0 security keys as a modern authentication method.  
- Device management integrates with MDM and co-management tools like Intune and Endpoint Configuration Manager.  
- Key features such as SSO, conditional access, self-service password reset, and enterprise state roaming are important capabilities to know for exams.

---

### FIDO2 and Security Keys

**Timestamp**: 01:07:35 – 01:09:41

**Key Concepts**  
- FIDO Alliance develops open authentication standards to reduce reliance on passwords.  
- FIDO2 is a combination of protocols and standards enabling stronger, simpler user authentication.  
- Security keys act as a secondary authentication device (second factor) for accessing devices, workstations, or applications.  
- FIDO2 includes specifications such as U2F (Universal 2nd Factor), UAF (Universal Authentication Framework), CTAP (Client to Authenticator Protocol), and WebAuthN.  

**Definitions**  
- **FIDO Alliance**: An open industry association focused on creating authentication standards to reduce password dependency.  
- **FIDO2**: The collective term for FIDO specifications including CTAP and WebAuthN that enable passwordless or second-factor authentication.  
- **Security Key**: A physical secondary device used in multi-factor authentication that generates security tokens when activated (e.g., by touch).  
- **U2F (Universal 2nd Factor)**: A FIDO protocol for second-factor authentication.  
- **UAF (Universal Authentication Framework)**: A FIDO protocol for passwordless authentication.  
- **CTAP (Client to Authenticator Protocol)**: A protocol that works with WebAuthN to enable communication between client devices and authenticators.  
- **WebAuthN**: A web standard for secure authentication, complementary to CTAP.  

**Key Facts**  
- Security keys often look like USB sticks and generate autofill security tokens upon user interaction (e.g., finger touch).  
- A popular brand of security key is the **UbiKey**.  
- UbiKey supports multiple protocols: FIDO2, WebAuthN, U2F.  
- UbiKey features include waterproof and crush resistance, and dual connectors (USB-A and NFC) on a single device.  
- UbiKey works out-of-the-box with services like Gmail and Facebook, plus hundreds more.  
- Cost of a UbiKey is approximately $30 USD, making it an affordable security enhancement.  

**Examples**  
- The instructor personally uses a UbiKey for authenticating to multiple devices.  
- UbiKey compatibility includes Gmail, Facebook, and many other online services.  

**Key Takeaways 🎯**  
- Understand that FIDO2 is a set of open standards aimed at improving authentication security beyond passwords.  
- Know the main protocols involved: U2F, UAF, CTAP, and WebAuthN, and that together they form FIDO2.  
- Recognize what a security key is and how it functions as a second factor in authentication.  
- Remember UbiKey as a practical, widely supported example of a security key device.  
- Be aware of the affordability and ease of use of security keys, making them a recommended security tool.  
- For exam scenarios, expect questions on the purpose of FIDO2, the role of security keys, and the protocols involved.

---

### Hybrid AD Joined Devices

**Timestamp**: 01:09:41 – 01:11:24

**Key Concepts**  
- Hybrid Azure AD Join allows devices to be joined to both on-premises Active Directory (AD) and Azure AD.  
- Requires organizational account sign-in, emphasizing on-premises infrastructure integration.  
- Suitable for hybrid organizations with existing on-premises AD environments.  
- Devices are company-owned and managed.  
- Supports a range of Windows OS versions for joining and provisioning.  
- Device management can be done via Group Policies, Configuration Manager, Intune (standalone or co-management).  
- Provides Single Sign-On (SSO) to both cloud and on-premises resources.  
- Supports conditional access policies through domain join or Intune if co-managed.  
- Enables self-service password reset and Windows Hello PIN reset from the lock screen.  
- Supports enterprise state roaming across devices.

**Definitions**  
- **Hybrid Azure AD Join**: A device join type that connects devices to both on-premises Active Directory and Azure Active Directory, allowing organizational account sign-in and management in hybrid environments.  

**Key Facts**  
- Supported OS for joining: Windows 10, 8.1, Windows 7, Windows Server 2008 R2, 2012, and others.  
- Supported OS for provisioning: Windows 10, Windows Server 2016, 2019.  
- Domain join can be automated via Azure AD Connect or configured with ADFS.  
- Windows Autopilot can be used for domain join (covered in next section).  
- Device sign-in options include password and Windows Hello for Business.  

**Examples**  
- None specifically mentioned for Hybrid AD Join devices in this segment.

**Key Takeaways 🎯**  
- Hybrid Azure AD Join is ideal for organizations with existing on-premises AD infrastructure wanting to leverage Azure AD capabilities.  
- Understand the supported OS versions for joining and provisioning devices.  
- Remember that device management can be done via traditional Group Policies or modern tools like Intune, including co-management scenarios.  
- Key benefits include SSO to cloud and on-premises resources, conditional access, and self-service password and PIN resets.  
- Knowing the difference between join types (Hybrid AD Join vs others) is important for exam scenarios.

---

### Windows Autopilot

**Timestamp**: 01:11:24 – 01:12:19

**Key Concepts**  
- Windows Autopilot is a collection of technologies used to set up and pre-configure new Windows devices.  
- It prepares devices for productive use without needing custom images or drivers for each model.  
- Uses an OEM-optimized version of Windows 10 pre-installed on devices.  
- Instead of re-imaging, existing Windows 10 installations are transformed into a business-ready state.  
- Post-deployment management can be done via Microsoft Intune, Windows Update for Business, Microsoft Endpoint Configuration Manager, and similar tools.

**Definitions**  
- **Windows Autopilot**: A set of technologies designed to simplify the initial deployment and configuration of new Windows devices, enabling them to be business-ready without traditional imaging processes.

**Key Facts**  
- Windows Autopilot leverages an OEM-optimized Windows 10 version pre-installed on devices.  
- No need to maintain custom images or drivers for every device model.  
- Enables transformation of existing Windows 10 installations into a managed, business-ready state.  
- Compatible with management tools like Microsoft Intune and Endpoint Configuration Manager.

**Examples**  
- None mentioned explicitly in this segment.

**Key Takeaways 🎯**  
- Remember that Windows Autopilot streamlines device provisioning by using pre-installed OEM Windows 10, avoiding the need for custom imaging.  
- Focus on the fact that it transforms existing Windows installations rather than wiping and re-imaging devices.  
- Understand that Autopilot integrates with Microsoft Intune and other management tools for ongoing device management.  
- This technology is primarily used during the initial deployment of new Windows devices.

---

### Device Management Cheatsheet

**Timestamp**: 01:12:19 – 01:13:38

**Key Concepts**  
- Device Management enables organizations to manage laptops, desktops, and phones accessing cloud resources.  
- Device Management is accessed via Azure Active Directory (Azure AD).  
- There are three device join types to bring devices into management: Azure Registered, Azure AD Join, and Hybrid Azure AD Join.  
- Mobile Device Management (MDM) controls the entire device, including wiping data and factory resetting.  
- Mobile Application Management (MAM) manages apps at the data layer by publishing, pushing, configuring, securing, monitoring, and updating apps.

**Definitions**  
- **Azure Registered**: Devices personally owned by users (e.g., mobile devices, Windows 10, iOS) signed in with a local personal account.  
- **Azure AD Join**: Devices owned by the organization, signed in with an organizational account; primarily for cloud-native access but can support hybrid scenarios.  
- **Hybrid Azure AD Join**: Devices owned by the organization managed using Active Directory Domain Services (AD DS) in a hybrid environment.  
- **Mobile Device Management (MDM)**: Management approach that controls the entire device, including wiping and resetting it.  
- **Mobile Application Management (MAM)**: Management focused on mobile apps, handling app deployment, configuration, security, monitoring, and updates without controlling the entire device.

**Key Facts**  
- Device Management is found under Azure AD service.  
- MDM allows wiping and factory resetting devices.  
- MAM operates at the data/app layer, not the entire device.  

**Examples**  
- Azure Registered devices include personally owned devices like Windows 10 laptops or iOS phones signed in with personal accounts.  
- Azure AD Join devices are organizationally owned and signed in with corporate accounts.  
- Hybrid Azure AD Join devices use AD DS for management in hybrid setups.

**Key Takeaways 🎯**  
- Understand the three device join types and their ownership/sign-in distinctions.  
- Know the difference between MDM (full device control) and MAM (app-level control).  
- Remember Device Management is integrated with Azure AD for managing cloud resource access.  
- Be able to identify which join type applies based on device ownership and management infrastructure.

---