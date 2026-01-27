## VMs

### VMs Intro

**Timestamp**: 04:02:22 – 04:05:15

**Key Concepts**  
- Azure Virtual Machines (VMs) provide customizable virtual servers with selectable OS, compute, memory, and storage.  
- VMs run on virtualization technology, eliminating the need for physical hardware management.  
- Users are responsible for managing the software layer: OS patches and configuration.  
- VM size is determined by the Azure image, which defines the combination of vCPUs, memory, and storage capacity.  
- Azure subscription limits VM instances to 20 per region by default.  
- Azure VMs are billed hourly.  
- Availability depends on disk type and deployment:  
  - Single instance with premium disk offers 99.9% availability.  
  - To achieve 99.95% availability, deploy 2 instances in an availability set.  
- Multiple managed disks can be attached to a VM.  
- Launching a VM automatically creates or associates several networking components grouped in a resource group.  

**Definitions**  
- **Azure Virtual Machine (VM)**: A highly configurable virtual server running on Azure’s virtualization platform, allowing users to run an OS and applications without managing physical hardware.  
- **VM Size**: The specification of a VM’s compute resources (vCPUs, memory, storage) defined by the selected Azure image.  
- **Network Security Group (NSG)**: A virtual firewall attached to the VM’s network interface that controls inbound and outbound traffic via port and protocol rules.  
- **Network Interface**: The component that handles IP protocols, enabling the VM to communicate over the internet or internal networks.  
- **Virtual Network (VNet)**: The isolated network environment in which the VM is launched, either pre-existing or created during VM setup.  
- **Public IP Address**: The internet-facing IP assigned to a VM instance allowing external access.  

**Key Facts**  
- Default limit: 20 VMs per region per subscription.  
- Single VM with premium disk: 99.9% availability.  
- Two VMs in an availability set: 99.95% availability.  
- VM launch process creates multiple components (NSG, network interface, public IP, VNet) often grouped in a resource group.  

**Examples**  
- None explicitly mentioned beyond general VM setup and component creation.  

**Key Takeaways 🎯**  
- Understand that Azure VMs are virtualized servers requiring user management at the OS/software level.  
- Know the VM size is tied to the Azure image, which bundles CPU, memory, and storage specs.  
- Remember the default VM limit per region and billing is hourly.  
- Availability improves with premium disks and deploying multiple instances in availability sets.  
- Be familiar with the networking components created with a VM: NSG (firewall), network interface, public IP, and VNet.  
- During the exam, expect questions on VM architecture, availability SLAs, and networking components associated with VMs.

---

### Operation Systems

**Timestamp**: 04:05:15 – 04:07:01

**Key Concepts**  
- Operating System (OS) for an Azure VM is determined by the image selected during VM creation.  
- Azure Marketplace offers a wide variety of OS images, including those optimized and updated for Azure.  
- Users can bring their own Linux OS by packaging it into a VHD (Virtual Hard Disk) format.  
- Azure supports only the VHD format, not the newer VHDX format.  
- Cloud Init is a multi-distribution, cross-platform cloud instance initialization tool supported by major cloud providers (Azure, AWS, GCP).

**Definitions**  
- **Operating System (OS)**: The program that manages all other programs on a computer.  
- **VHD (Virtual Hard Disk)**: A virtual hard disk file format used to package an OS for deployment in Azure VMs.  
- **Cloud Init**: An industry-standard tool for initializing cloud instances across multiple distributions and cloud platforms.

**Key Facts**  
- Common OS examples: Windows, Mac OS, Linux.  
- Supported/partnered Linux distributions on Azure include: SUSE, Red Hat, Ubuntu, Debian, FreeBSD, Flatcar Container Linux, RancherOS (for containerization), Bitnami (preloaded software images), Mesosphere, Docker-enabled images, Jenkins.  
- Azure does not support the VHDX format; only VHD is supported for custom OS images.

**Examples**  
- Bitnami WordPress image (preloaded software).  
- RancherOS for containerization.  
- Bringing your own Linux OS by creating a VHD using Hyper-V on Windows.

**Key Takeaways 🎯**  
- When creating an Azure VM, the OS is selected via the image from the Azure Marketplace or a custom VHD.  
- Know the difference between VHD and VHDX formats; only VHD is supported in Azure.  
- Familiarize yourself with the variety of Linux distributions supported natively or via partnerships on Azure.  
- Cloud Init is not on the exam but is important industry knowledge for cloud instance initialization across platforms.

---

### Cloud Init

**Timestamp**: 04:07:01 – 04:08:55

**Key Concepts**  
- Cloud Init is a multi-distribution, cross-platform cloud instance initialization method.  
- It is supported across all major public cloud providers (Azure, AWS, GCP), private cloud provisioning systems, and bare metal installations.  
- Cloud instance initialization is the process of preparing a cloud instance with configuration data for the OS and runtime environment.  
- Initialization uses a base VM image plus instance data such as metadata, user data, and vendor data.  
- The primary data used in practice is **user data**, which is a script run when the instance first boots.  
- Cloud Init mainly works with Linux distributions and is not typically used for Windows VMs.  
- In Azure, user data is less explicitly labeled but is used under the hood when deploying via ARM templates (infrastructure as code).  

**Definitions**  
- **Cloud Init**: A standardized method to initialize cloud instances across multiple Linux distributions and cloud platforms by applying configuration data at first boot.  
- **User Data**: A script or set of instructions provided to a cloud instance that runs during its initial boot to configure the OS and environment.  

**Key Facts**  
- Cloud Init is industry standard and supported by Azure, AWS, GCP, private clouds, and bare metal installs.  
- Azure does not explicitly call it "user data" in the portal but uses Cloud Init functionality when deploying Linux VMs programmatically.  
- Cloud Init is primarily Linux-focused; Windows VMs generally do not use Cloud Init.  

**Examples**  
- AWS instance launch wizard includes a "user data" box where you can input scripts to run at first boot.  
- Azure ARM templates use Cloud Init behind the scenes for Linux VM provisioning.  

**Key Takeaways 🎯**  
- Know that Cloud Init is the standard for Linux VM initialization across clouds.  
- Understand that "user data" scripts are the main mechanism to customize instances at first boot.  
- Remember Cloud Init is not typically used for Windows VMs.  
- In exam scenarios, associate "user data" with Cloud Init, especially when dealing with Linux VM provisioning.  
- Although not explicitly tested, familiarity with Cloud Init is valuable for real-world cloud deployments and infrastructure as code.  

---

### Sizes

**Timestamp**: 04:08:55 – 04:12:15

**Key Concepts**  
- Azure Virtual Machines (VMs) come in various **sizes** (also called series or SKU families) optimized for different workloads.  
- Sizes are grouped into **types** based on CPU-to-memory ratio and intended use cases.  
- Azure Compute Units (ACUs) provide a standardized way to compare CPU performance across VM sizes.

**Definitions**  
- **Sizes / Series / SKU families**: Different categories of Azure VMs optimized for specific workloads; terms used interchangeably in Azure documentation.  
- **General Purpose**: Balanced CPU-to-memory ratio, suitable for testing, development, small to medium databases, and low to medium traffic web servers.  
- **Compute Optimized**: High CPU-to-memory ratio, ideal for medium traffic web servers, network appliances, batch processes, and app servers.  
- **Memory Optimized**: High memory-to-CPU ratio, good for relational databases, large caches, and in-memory analytics.  
- **Storage Optimized**: High disk throughput and IOPS, designed for big data, SQL/NoSQL databases, data warehousing, and large transactional databases.  
- **GPU Optimized**: Specialized VMs with single or multiple GPUs for graphic rendering, video editing, and deep learning tasks.  
- **High Performance Compute (HPC)**: Fastest and most powerful CPUs with optional high throughput networking for demanding compute workloads.  
- **Azure Compute Units (ACUs)**: A performance metric to compare CPU power across VM sizes, standardized against the older A1 VM size (value = 100).

**Key Facts**  
- The most commonly used general purpose VM size is **B1**, noted for being very cost-effective and frequently used for Linux VMs in labs and demos.  
- Compute optimized popular size: **F series (FSv2)**.  
- Storage optimized popular size: **LSv2**.  
- Pricing and available sizes depend on the chosen VM image; not all sizes are available for every image.  
- Azure portal allows filtering VM sizes by cost and other parameters, making it easy to find the most cost-effective option.  
- ACU values are relative and based on a benchmark against the older A1 VM size, which is no longer commonly used.

**Examples**  
- Using the **B1 series** VM for Linux machines due to its low cost (~CAD $9.72).  
- Compute optimized VM example: **FSv2 (F series)** for CPU-intensive workloads.  
- Storage optimized VM example: **LSv2** for big data and database workloads.

**Key Takeaways 🎯**  
- Remember that **sizes**, **series**, and **SKU families** all refer to the same concept of VM categorization in Azure.  
- Choose VM size based on workload needs: balanced (general purpose), CPU-heavy (compute optimized), memory-heavy, storage-heavy, GPU, or HPC.  
- The **B1 size** is a common, cost-effective choice for general Linux VM deployments.  
- Use Azure Compute Units (ACUs) to compare CPU performance across VM sizes when selecting the right VM.  
- Not all VM sizes are available for every OS image; availability depends on the image selected.  
- Utilize Azure portal filters to find the best VM size for your budget and requirements.

---

### ACUs

**Timestamp**: 04:12:15 – 04:13:48

**Key Concepts**  
- Azure Compute Units (ACUs) provide a standardized way to compare CPU performance across different Azure VM SKUs (sizes/series).  
- ACU values are benchmark-based relative performance scores.  
- The baseline for ACUs is the Standard A1 VM SKU, which is assigned a value of 100 ACUs.  
- Other VM SKUs have ACU values representing how much faster they perform compared to the A1 baseline.

**Definitions**  
- **Azure Compute Units (ACUs)**: A metric used by Azure to compare the compute (CPU) performance of different VM SKUs by assigning a relative performance score.  
- **SKU (Stock Keeping Unit)**: Refers to VM sizes or series in Azure.

**Key Facts**  
- The Standard A1 VM SKU is the baseline with an ACU value of 100.  
- The A1 series is an older series and generally not recommended for new deployments.  
- The D-series VMs (D1 to D14) have ACU values ranging from approximately 160 to 250.  
- This means D-series VMs can be roughly 60% to 150% more performant than the A1 baseline.  
- The ratio of vCPUs to cores in A1 is 1:1.

**Examples**  
- Comparison example:  
  - A1 VM = 100 ACUs (baseline)  
  - D1-D14 VMs = 160 to 250 ACUs (60% to 150% faster than A1)  

**Key Takeaways 🎯**  
- Understand that ACUs are a relative performance metric to help compare VM CPU capabilities across Azure SKUs.  
- Always consider ACU values when selecting VM sizes for performance needs.  
- The A1 VM SKU is the baseline for ACU scoring but is generally outdated.  
- D-series VMs offer significantly better CPU performance compared to A-series based on ACU scores.  
- ACUs simplify VM performance comparison without needing to understand the underlying hardware details.

---

### MobileApp

**Timestamp**: 04:13:48 – 04:14:38

**Key Concepts**  
- Azure Mobile App integration with Azure Virtual Machines  
- Monitoring and managing VMs remotely via mobile app  
- QR code usage for quick connection to VMs (optional)  
- Access to Cloud Shell through the mobile app  

**Definitions**  
- **Azure Mobile App**: A mobile application available on Android and iOS that allows users to connect to their Azure account, monitor virtual machines, and perform basic management tasks remotely.  

**Key Facts**  
- The Azure Mobile App can scan a QR code displayed on Azure Virtual Machines for quick access, but scanning is not mandatory if logged in.  
- Users can check VM performance and take basic actions directly from their phone.  
- The app supports Cloud Shell access, enabling command-line management on the go.  
- Available on both Android and iOS platforms (confirmed on Android).  

**Examples**  
- Scanning the QR code on a VM to connect via the Azure Mobile App.  
- Logging into the Azure Mobile App to monitor VM performance without scanning.  

**Key Takeaways 🎯**  
- Remember to install the Azure Mobile App on your phone for convenient VM monitoring and management.  
- You do not need to scan the QR code if you are already logged into your Azure account on the app.  
- The app provides access to Cloud Shell, enhancing remote management capabilities.  
- Useful for quick checks and basic VM actions when away from a desktop.  

---

### VM Generations

**Timestamp**: 04:14:38 – 04:17:26

**Key Concepts**  
- Hyper-V is Microsoft’s hardware virtualization platform that allows creation and running of virtual machines (VMs).  
- Hyper-V supports two VM generations: Generation 1 and Generation 2.  
- Azure also supports Gen 1 and Gen 2 VMs, but Azure’s implementation is not exactly the same as Hyper-V’s.  
- The main difference between Gen 1 and Gen 2 VMs is their boot architecture: Gen 1 uses BIOS-based boot, Gen 2 uses UEFI-based boot.  
- UEFI offers advanced features such as secure boot and support for larger boot volumes.

**Definitions**  
- **Hyper-V**: Microsoft’s virtualization technology that creates software-based virtual machines acting like complete computers.  
- **Generation 1 VM**: A VM using BIOS-based boot architecture, supporting most guest operating systems.  
- **Generation 2 VM**: A VM using UEFI-based boot architecture, supporting most 64-bit Windows versions and newer Linux/FreeBSD OSes.  
- **BIOS (Basic Input/Output System)**: Traditional firmware interface for booting computers.  
- **UEFI (Unified Extensible Firmware Interface)**: Modern firmware interface replacing BIOS, providing features like secure boot and larger boot volume support.  
- **Secure Boot**: A UEFI feature that verifies the bootloader is signed by a trusted authority to enhance security.  
- **VHD / VHDX**: Virtual hard disk file formats used to package Hyper-V virtual machines.

**Key Facts**  
- Generation 1 VMs support most guest OSes; Generation 2 supports most 64-bit Windows and newer Linux/FreeBSD OSes.  
- Azure Gen 1 and Gen 2 VMs are not exactly the same as Hyper-V Gen 1 and Gen 2 VMs; do not rely solely on Hyper-V documentation for Azure VM generation features.  
- Gen 1 uses BIOS-based boot architecture; Gen 2 uses UEFI-based boot architecture.  
- UEFI supports secure boot and boot volumes up to 64 terabytes.  
- Hyper-V VMs are packaged as VHD or VHDX files.

**Examples**  
- None specifically mentioned beyond general references to Windows and Linux OS compatibility with VM generations.

**Key Takeaways 🎯**  
- Understand that VM generations differ mainly by boot architecture: BIOS (Gen 1) vs UEFI (Gen 2).  
- Know that Gen 2 VMs provide enhanced features like secure boot and support for larger boot volumes.  
- Remember that Azure VM generations are similar but not identical to Hyper-V generations—do not assume feature parity.  
- Be familiar with VHD and VHDX as virtual disk formats for Hyper-V VMs.  
- When choosing VM generation, consider OS compatibility and required features rather than always defaulting to Gen 2.

---

### 3 Ways To Connect

**Timestamp**: 04:17:26 – 04:19:29

**Key Concepts**  
- There are three main ways to connect to Azure virtual machines: SSH, RDP, and Bastion.  
- Each connection method serves different use cases and protocols.  
- SSH is primarily used for secure terminal access, especially on Linux VMs.  
- RDP provides a graphical interface for remote desktop access, mainly for Windows VMs.  
- Azure Bastion allows browser-based VM access through the Azure portal without needing client software.

**Definitions**  
- **SSH (Secure Shell)**: A protocol to establish a secure, encrypted connection between a client and server, commonly used for remote terminal access to VMs.  
- **RDP (Remote Desktop Protocol)**: A Microsoft proprietary protocol that provides a graphical interface to remotely control another computer over a network.  
- **Azure Bastion**: An Azure service that enables secure RDP/SSH connectivity to VMs directly through a web browser via the Azure portal.

**Key Facts**  
- SSH uses TCP port **22**.  
- SSH authentication is typically done using an RSA key pair rather than username/password.  
- RDP uses TCP and UDP port **3389**.  
- Azure Bastion eliminates the need to install SSH or RDP clients on your local machine.  
- SSH key pairs are generated using the command: `ssh-keygen -t rsa`.

**Examples**  
- Using SSH to remotely connect to an Azure VM terminal via port 22.  
- Using RDP to open a remote Windows desktop session on a VM via port 3389.  
- Using Azure Bastion to connect to a VM from a Google Chrome OS device that lacks native SSH or RDP clients.

**Key Takeaways 🎯**  
- Remember **port 22** for SSH and **port 3389** for RDP—these are critical exam facts.  
- SSH key pair authentication is the preferred and more secure method over username/password.  
- Azure Bastion is useful when client software installation is not possible or practical, enabling browser-based VM access.  
- Memorize the SSH key generation command `ssh-keygen -t rsa` as it is commonly used in practice and exams.

---

### SSH

**Timestamp**: 04:19:29 – 04:20:41

**Key Concepts**  
- SSH (Secure Shell) is commonly used to access and authenticate to virtual machines (VMs).  
- Authentication is typically done using an SSH key pair (public and private keys).  
- The private key remains on the local system and must be kept secure.  
- The public key is stored on the VM to allow authentication.  
- SSH key pairs are generated using the command `ssh-keygen -t rsa`.  
- When connecting via SSH, the private key is provided to match against the public key on the VM.  
- Public key files have a `.pub` extension.

**Definitions**  
- **SSH key pair**: A pair of cryptographic keys (private and public) used to securely authenticate a user to a remote system without using passwords.  
- **Private key**: The secret key kept on the user's local machine, never shared.  
- **Public key**: The key stored on the remote VM that corresponds to the private key for authentication.

**Key Facts**  
- The SSH key generation command to memorize is: `ssh-keygen -t rsa`.  
- The private key should never be shared or exposed outside the local system.  
- The public key file ends with `.pub`.  
- SSH authentication works by matching the private key provided during connection with the public key stored on the VM.

**Examples**  
- Using SSH to connect: `ssh -i [private_key_file] [username]@[server_address]` where the `.pub` file is the public key stored on the VM.

**Key Takeaways 🎯**  
- Memorize the SSH key generation command: `ssh-keygen -t rsa`.  
- Understand the difference between private and public keys and their roles in authentication.  
- Always keep your private key secure and never share it.  
- Recognize `.pub` files as public keys used on the VM side.  
- Know how to use the private key with the SSH command to access your VM.

---

### RDP

**Timestamp**: 04:20:41 – 04:21:25

**Key Concepts**  
- Remote Desktop Protocol (RDP) connection process to a virtual machine (VM)  
- Use of an RDP file to initiate the connection  
- Authentication via username and password specified during VM creation  
- Platform-specific availability of RDP clients  

**Definitions**  
- **RDP file**: A file with an `.rdp` extension used to initiate a Remote Desktop connection to a VM.  
- **RDP Client**: Software used to connect to a remote machine using the Remote Desktop Protocol.  

**Key Facts**  
- To connect via RDP, first download the `.rdp` file associated with the VM.  
- Double-clicking the `.rdp` file prompts for username and password authentication.  
- The username and password are those set when the VM was created.  
- On Windows, the RDP client is pre-installed—no additional installation required.  
- On Mac, the Remote Desktop Client must be installed from the Apple Store.  

**Examples**  
- None mentioned specifically for RDP beyond the general process of downloading and opening the `.rdp` file and entering credentials.  

**Key Takeaways 🎯**  
- Always download and use the `.rdp` file to connect to your VM via RDP.  
- Remember the username and password you configured during VM setup—they are required for login.  
- Know your platform: Windows has built-in RDP client; Mac users need to install it from the Apple Store.  
- This process is essential for accessing Windows-based VMs or any VM configured for RDP access.  

---

### Bastion

**Timestamp**: 04:21:25 – 04:23:57

**Key Concepts**  
- Azure Bastion is a managed, hardened intermediate instance that enables secure RDP and SSH connectivity to virtual machines directly through the Azure portal.  
- Bastion provides a web-based RDP client or SSH terminal, eliminating the need for local clients.  
- It is especially useful for devices that lack native SSH or RDP clients, such as Google Chromebooks or restricted Windows environments.  
- Bastion enhances security by providing a controlled and auditable access point to VMs without exposing them via public IP addresses.  
- To deploy Azure Bastion, you must create or use a subnet named **AzureBastionSubnet** with a minimum size of **/27 (32 IP addresses)** in your virtual network (VNet).  

**Definitions**  
- **Azure Bastion**: A managed PaaS service that provides secure and seamless RDP/SSH connectivity to VMs over SSL directly through the Azure portal without exposing the VM to the public internet.  

**Key Facts**  
- Azure Bastion requires a dedicated subnet with an address space such as 10.0.1.0/24.  
- Bastion setup now includes a wizard that simplifies creating required resources (subnet, network security group, etc.), which previously had to be done manually.  
- Bastion connections run entirely in the browser, eliminating the need for external RDP/SSH clients.  
- Bastion supports both RDP (for Windows VMs) and SSH (for Linux VMs).  
- For SSH connections, Bastion supports authentication via username/password or SSH private key (.pem file), with private key authentication recommended.  

**Examples**  
- Connecting to a Windows VM via Bastion: Select "Connect with Azure Bastion," enter username and password, and access the VM through the browser-based RDP client.  
- Connecting to a Linux VM via Bastion: Enter username, switch to SSH private key authentication, upload the .pem private key file, and connect via the browser-based SSH terminal.  
- Use case: Users on Google Chromebooks (which only have browsers) can connect to Azure VMs without needing to install any client software.  

**Key Takeaways 🎯**  
- Remember the **AzureBastionSubnet** naming requirement and subnet size (/27) when deploying Bastion.  
- Bastion is ideal for secure, clientless RDP/SSH access, especially from devices without native clients.  
- Use SSH private key authentication for Linux VMs when connecting via Bastion for better security.  
- Bastion helps avoid exposing VMs to the public internet and provides auditing capabilities for access control.  
- Understand the difference between traditional RDP/SSH client usage and Bastion’s browser-based approach.  

---

### Windows Vs Linux

**Timestamp**: 04:23:57 – 04:26:34

**Key Concepts**  
- Azure supports running both Windows and Linux virtual machines (VMs).  
- Windows VMs require a license to run but launching without one results in an unactivated state, not immediate charges.  
- Windows VMs typically require larger instance sizes due to running a full desktop environment.  
- Linux VMs generally do not require licenses (except some distributions like Red Hat if support is needed).  
- Linux VMs can run on smaller instance sizes since they usually operate in a terminal-based environment without a full desktop.  
- Access methods differ: Windows uses RDP with username/password; Linux uses SSH with username/password or SSH key pairs.  
- Update management can automate OS patching for both Windows and Linux VMs across Azure, on-premises, and other clouds.

**Definitions**  
- **Hybrid License**: A licensing option where enterprises bring their own existing Windows licenses to Azure VMs instead of using Azure-provided licenses.  
- **Update Management**: A service that automates the installation of operating system updates and patches on virtual machines regardless of their location.

**Key Facts**  
- Windows Server requires a license but launching without one only shows "Windows is unactivated" and requires manual activation.  
- Windows VMs need larger instance types (e.g., B2) compared to Linux VMs (e.g., B1) due to the full desktop environment.  
- Linux VMs typically do not have licensing fees unless using enterprise distributions like Red Hat with support.  
- Windows VMs are accessed via Remote Desktop Protocol (RDP) using username and password.  
- Linux VMs are accessed via SSH using username/password or SSH private key (.pem file).  
- Update management supports patching for both Windows and Linux VMs on Azure, on-premises, and other cloud providers.

**Examples**  
- Windows VM requires a B2 instance size (larger and more expensive) because it runs a full desktop environment.  
- Linux VM can run on smaller instance sizes like B1 since it is terminal-based and does not run a full desktop environment.

**Key Takeaways 🎯**  
- Do not worry about immediate licensing fees when launching Windows VMs; manual activation is required later.  
- Use SSH private keys for Linux VM access for better security; Windows VMs require username/password for RDP.  
- Linux VMs are generally more cost-effective for learning and certification purposes due to smaller instance requirements and no licensing fees.  
- Understand the difference in access methods and resource requirements between Windows and Linux VMs.  
- Use update management to automate patching and updates across both Windows and Linux environments, including hybrid and multi-cloud setups.

---

### Update Management

**Timestamp**: 04:26:34 – 04:28:25

**Key Concepts**  
- Update Management automates installation of OS updates and patches for both Windows and Linux virtual machines.  
- It supports VMs running on Azure, on-premises environments, and other cloud providers.  
- Update Management is accessed via the Operations tab under "guest + host updates" in the Azure portal.  
- Although it appears as a standalone service, Update Management runs on top of Azure Automation.  
- The Microsoft Monitoring Agent (MMA) must be installed on each machine to enable update management.  
- Compliance scans for updates run automatically: every 12 hours on Windows VMs and every 3 hours on Linux VMs.  
- Dashboard data reflecting update compliance can take from 30 minutes up to 6 hours to refresh after scans.  
- Azure Automation offers additional features beyond update management, such as change tracking, inventory, and VM start/stop scheduling.  
- These features depend on linking a Log Analytics workspace with an Automation account.

**Definitions**  
- **Update Management**: A service that automates the deployment of operating system updates and patches across Windows and Linux virtual machines in Azure, on-premises, or other clouds.  
- **Microsoft Monitoring Agent (MMA)**: The agent installed on VMs that enables communication with Azure Automation for update management and monitoring.  
- **Azure Automation**: A broader Azure service that underpins Update Management and provides automation capabilities like patching, change tracking, and VM scheduling.  
- **Log Analytics Workspace**: A workspace required to collect and analyze monitoring data, which must be linked to the Automation account for update management features to work.

**Key Facts**  
- Compliance scans frequency:  
  - Windows: every 12 hours  
  - Linux: every 3 hours  
- Dashboard update latency: 30 minutes to 6 hours after scan completion.  
- Update Management supports multi-environment patching: Azure, on-premises, other clouds.  
- Dependency on Log Analytics workspace linked to Automation account for full functionality.

**Examples**  
- None specifically mentioned beyond general usage scenarios.

**Key Takeaways 🎯**  
- Remember that Update Management requires the Microsoft Monitoring Agent installed on each VM.  
- Know the scan intervals for Windows (12 hours) and Linux (3 hours) machines.  
- Understand that Update Management is part of Azure Automation and depends on linking a Log Analytics workspace.  
- Update Management can be used beyond Azure VMs, including on-premises and other cloud environments.  
- Be aware of the potential delay (up to 6 hours) before update compliance data appears in the dashboard.  
- Azure Automation offers multiple server management features beyond patching—know these for broader exam context.

---

### Create a Bastion

**Timestamp**: 04:28:25 – 04:33:23

**Key Concepts**  
- Azure Bastion Service allows secure RDP/SSH connectivity to virtual machines directly through the Azure portal without exposing public IP addresses.  
- Bastion requires a dedicated subnet with a specific address space within the virtual network.  
- Bastion setup can be done either directly from the Bastions blade or after creating a virtual machine (VM).  
- Bastion connections run entirely in the browser, eliminating the need for external RDP/SSH clients.  
- Bastion is useful for devices or OS environments where native RDP/SSH clients are unavailable or difficult to install (e.g., Chromebooks, Linux).  

**Definitions**  
- **Azure Bastion**: A managed PaaS service that provides secure and seamless RDP/SSH connectivity to VMs directly through the Azure portal over SSL, without exposing public IPs.  
- **Address Space (Subnet)**: A CIDR block (e.g., 10.0.1.0/24) allocated specifically for the Bastion subnet within the virtual network.  

**Key Facts**  
- Bastion requires creating a new subnet with an address space such as 10.0.1.0/24.  
- Bastion setup now includes a wizard that simplifies creating required resources (subnet, network security group, etc.), which previously had to be done manually.  
- Bastion provisioning can take some time to complete.  
- Bastion connections use the Azure portal web interface for RDP/SSH access.  
- Pricing for Bastion is not detailed but noted to have a cost, so resources should be cleaned up after use to avoid charges.  

**Examples**  
- Created a Windows Server VM in a new resource group called "Enterprise."  
- Used username "Azure user" and password "Testing123456" for VM login.  
- Connected to the VM first via traditional RDP by downloading the RDP file to verify connectivity.  
- Created a Bastion subnet with address space 10.0.1.0/24 and deployed Bastion in the same resource group.  
- Connected to the VM using Bastion through the Azure portal by entering username and password directly in the browser.  

**Key Takeaways 🎯**  
- Know how to create and configure Azure Bastion, including the requirement for a dedicated subnet with a specific address space.  
- Understand that Bastion enables secure, browser-based RDP/SSH without exposing VM public IPs or requiring external clients.  
- Remember Bastion provisioning can take several minutes—plan accordingly.  
- Be aware of Bastion’s pricing implications and the importance of cleaning up resources after use.  
- Bastion is especially useful for users on platforms where native RDP/SSH clients are unavailable or inconvenient.

---

### Create a Windows VM and RDP

**Timestamp**: 04:33:23 – 04:38:53

**Key Concepts**  
- Creating a Windows virtual machine (VM) in Azure via the portal  
- Selecting appropriate VM size for Windows OS  
- Setting up inbound port rules for Remote Desktop Protocol (RDP) access  
- Using RDP client to connect to the Windows VM  
- Managing VM lifecycle: deployment and deletion  
- Licensing considerations for Windows VMs in Azure  

**Definitions**  
- **Virtual Machine (VM)**: A software emulation of a physical computer that runs an operating system and applications just like a physical computer.  
- **RDP (Remote Desktop Protocol)**: A protocol that allows users to connect to another computer over a network connection using a graphical interface.  
- **Inbound Port 3389**: The default port used by RDP to allow remote desktop connections.  
- **Resource Group**: A container in Azure that holds related resources for an Azure solution.  

**Key Facts**  
- Windows 10 Pro is used as the example OS for the VM (preferred for ease of learning).  
- VM size must be at least B2S to run Windows Server/Windows 10 Pro; smaller sizes like B1LS are insufficient.  
- Password example used: Username = Cardassia, Password = Cardassia123 (with capital letters).  
- Inbound port 3389 must be allowed for RDP access.  
- Standard SSD is selected for the disk type.  
- Azure automatically creates a new Virtual Network (VNet) and Network Security Group (NSG) when creating the VM.  
- Windows license activation is not required for learning/testing purposes; unactivated Windows will still run but with limitations.  
- RDP client is built-in on Windows; Mac users can download the Microsoft Remote Desktop app from the App Store.  
- After use, delete the VM and resource group to avoid unnecessary charges.  

**Examples**  
- Creating a resource group named "Cardassia" and a VM also named "Cardassia."  
- Setting password as "Cardassia123" with capitalization.  
- Connecting to the VM via RDP by downloading the RDP file and entering credentials.  
- Observing that Windows 10 Pro loads without activation but is usable for learning.  
- Deleting the resource group "Cardassia" to clean up resources.  

**Key Takeaways 🎯**  
- Always select a VM size that supports Windows OS (B2S or larger).  
- Remember to open inbound port 3389 for RDP access when creating the VM.  
- Use meaningful resource group and VM names for easy management.  
- Windows VMs can be used without license activation for testing, but expect some limitations.  
- Use the built-in RDP client on Windows or download the Microsoft Remote Desktop app on Mac.  
- Always delete VMs and associated resource groups after use to avoid unnecessary costs.  
- Azure automates network setup (VNet and NSG) during VM creation, simplifying deployment.

---

### Create a Linux VM and SSH

**Timestamp**: 04:38:53 – 04:53:15

**Key Concepts**  
- Creating a Linux virtual machine (VM) in Azure via the portal  
- Selecting subscription, resource group, region, and availability zone  
- Choosing VM image (Ubuntu 18.04 used in example)  
- Selecting VM size based on cost and resource needs (e.g., B1LS with 0.5 GB RAM)  
- Authentication options: SSH public key (preferred) vs password  
- Generating and downloading SSH key pairs for secure access  
- Configuring inbound port rules (SSH port 22 and HTTP port 80) via Network Security Group (NSG)  
- Disk options: standard HDD vs premium SSD (cost vs performance considerations)  
- Networking setup: automatic creation of virtual network (vNet), subnet, NIC, NSG, and public IP  
- Azure Bastion service for secure browser-based SSH access without needing external clients like PuTTY  
- Requirement to create a special subnet named "AzureBastionSubnet" with prefix /27 for Bastion deployment  
- Connecting to Linux VM via Bastion using SSH private key authentication  
- Installing Apache web server on Ubuntu VM using `apt-get install apache2`  
- Verifying Apache service is running and accessible via VM’s public IP on port 80  
- Cleaning up resources by deleting the resource group to remove all associated resources including VM, NIC, NSG, vNet, and public IP  
- Importance of double-checking that all resources, especially public IP addresses, are deleted to avoid unexpected charges  

**Definitions**  
- **Virtual Machine (VM)**: A software emulation of a physical computer running an operating system and applications.  
- **SSH (Secure Shell)**: A protocol for securely connecting to remote machines, typically used for Linux VM access.  
- **Network Security Group (NSG)**: A set of inbound and outbound security rules applied to network interfaces or subnets to control traffic.  
- **Azure Bastion**: A managed PaaS service that provides secure and seamless RDP/SSH connectivity to VMs directly through the Azure portal without exposing public IPs.  
- **Resource Group**: A container that holds related Azure resources for management and billing purposes.  

**Key Facts**  
- VM size example: B1LS with 0.5 GB RAM, cost-effective for lightweight workloads  
- SSH port: 22 must be open for SSH access  
- HTTP port: 80 must be open to serve web traffic (e.g., Apache server)  
- Azure Bastion requires a subnet named exactly `AzureBastionSubnet` with at least a /27 prefix  
- Disk types: Standard HDD (cost-effective), Premium SSD (better performance, recommended for production workloads)  
- Apache installation command on Ubuntu: `apt-get install apache2`  
- After VM creation, Azure automatically creates associated resources: NIC, NSG, vNet, public IP  
- Public IP addresses can incur significant costs if not deleted (warning about $700 yearly cost if left allocated)  

**Examples**  
- Created a Linux VM named "Bajour" in the US East region with Ubuntu 18.04 image  
- Selected B1LS VM size for cost efficiency  
- Generated SSH key pair named "Bajour" for authentication  
- Opened inbound ports 22 (SSH) and 80 (HTTP) in NSG  
- Created Azure Bastion by adding a subnet `AzureBastionSubnet` with /27 prefix  
- Connected to the VM via Bastion using SSH private key authentication  
- Installed Apache web server and accessed the default Apache page via the VM’s public IP address  
- Deleted the resource group "Bajour" to clean up all resources  

**Key Takeaways 🎯**  
- Always choose the appropriate VM size balancing cost and performance; B1LS is a good low-cost option for testing  
- Use SSH public key authentication over passwords for better security  
- Ensure inbound NSG rules allow port 22 for SSH and port 80 for web traffic if running a web server  
- Azure Bastion simplifies secure access to VMs without exposing public IP or needing external SSH clients  
- Remember to create the `AzureBastionSubnet` with correct prefix before deploying Bastion  
- After deployment, verify all associated resources (especially public IPs) are deleted during cleanup to avoid unexpected charges  
- Practice connecting to Linux VMs via Bastion and installing basic services like Apache to confirm setup  
- Use resource groups to logically group and easily delete all related resources in one operation  

---

### VM Monitoring

**Timestamp**: 04:53:15 – 05:27:55

**Key Concepts**  
- Monitoring Azure Virtual Machines (VMs) involves checking performance and diagnostics.  
- Important Azure services for VM monitoring: Automation Accounts, Log Analytics, Metrics, and Alerts.  
- Resource providers for alerts management and insights must be registered/enabled in the subscription.  
- Guest OS diagnostics/metrics require the Azure Monitoring Agent (WAG agent) installed on the VM.  
- Log Analytics Workspace acts as a centralized data lake for collecting and querying logs from multiple resources.  
- Automation Accounts manage configuration and update management for VMs, including patching and running automated scripts (runbooks).  
- Diagnostic settings enable collection of guest metrics such as memory, disk, network, and CPU usage.  
- Host metrics are collected by default (CPU, etc.), but guest metrics (memory, disk space) require explicit enabling.  
- Alerts can be created based on log queries or metric thresholds to notify on VM health or performance issues.  
- Performance counters on Windows VMs must be enabled to send guest metrics.  
- Stress testing tools (e.g., StressNG on Linux) can be used to generate load and test monitoring data collection.  
- Azure Monitor Logs use Kusto Query Language (KQL) for querying collected data.  

**Definitions**  
- **Automation Account**: Azure service for managing VM configurations, updates, and running automated tasks (runbooks).  
- **Log Analytics Workspace**: A centralized repository (data lake) for collecting, storing, and querying logs and metrics from Azure resources.  
- **Guest Metrics**: Performance and diagnostic data collected from inside the VM OS (memory usage, disk space, network stats).  
- **Host Metrics**: Performance data collected from the VM host infrastructure (CPU usage, basic metrics).  
- **Runbook**: A set of automated tasks or scripts executed via Azure Automation to manage VMs or other resources.  
- **WAG Agent (Windows Azure Guest Agent)**: Agent installed on VMs to enable diagnostics and monitoring data collection.  
- **Diagnostic Settings**: Configuration on a VM to send guest metrics and logs to Azure Monitor or storage accounts.  
- **Heartbeat**: A periodic signal sent by a VM to indicate it is alive and responsive.  

**Key Facts**  
- Resource providers to enable:  
  - `alertsmanagement` (for alerts)  
  - `insights` (for monitoring and diagnostics)  
- Minimal Linux installs may lack the WAG agent, preventing guest metrics collection unless manually installed.  
- Windows Server VMs require at least DS2v2 or DS2v3 size for proper monitoring support (due to CPU/memory requirements).  
- Diagnostic data is stored in Azure Storage accounts created automatically or manually linked.  
- Automation Accounts require an Azure Run As Account with contributor permissions to manage resources.  
- Log Analytics workspace can be created manually or via Automation Account setup for better integration.  
- Performance counters on Windows need to be started manually to begin sending guest metrics.  
- Guest metrics include memory, network, disk, and storage usage; these are not collected by default.  
- Alerts can be created based on log queries with customizable thresholds and incur monthly costs.  
- Azure Monitor Logs use Kusto Query Language (KQL) for querying logs and metrics.  
- VM monitoring data may take some time to appear after enabling diagnostics and generating load.  
- StressNG is a Linux tool used to simulate high memory usage for testing monitoring setups.  

**Examples**  
- Created three VMs for demonstration:  
  - Ubuntu minimal install (no guest metrics agent by default)  
  - Ubuntu LTS with guest metrics enabled (WAG agent installed)  
  - Windows Server VM (DS2v3 size, guest metrics enabled, performance counters started manually)  
- Installed StressNG on Ubuntu VM to generate 90% memory usage to produce monitoring data.  
- Created Automation Account named "DAX Automation" linked to resource group "DAX" for update management and runbooks.  
- Created Log Analytics workspace manually and linked VMs to it for centralized log collection.  
- Ran sample Kusto queries in Log Analytics to check VM availability via heartbeat logs.  
- Created alert rules based on log queries with threshold values.  

**Key Takeaways 🎯**  
- Always ensure the required resource providers (`alertsmanagement` and `insights`) are registered before enabling monitoring features.  
- Guest OS diagnostics require the Azure Monitoring Agent (WAG agent); minimal Linux installs may need manual installation.  
- Use Automation Accounts for patch management and running automated scripts on VMs.  
- Create and link a Log Analytics workspace to collect and query VM logs and metrics effectively.  
- Enable diagnostic settings on VMs to collect guest metrics like memory and disk usage, which are not collected by default.  
- On Windows VMs, start performance counters manually to enable guest metrics collection.  
- Use tools like StressNG to generate load and verify monitoring data collection during exams or practicals.  
- Familiarize yourself with Kusto Query Language (KQL) for querying Azure Monitor Logs.  
- Alerts can be configured based on log queries or metrics to proactively monitor VM health and performance.  
- Be aware that monitoring data may take time to appear after setup; patience is required during troubleshooting.  
- Always clean up resources (resource groups) after practice to avoid unnecessary costs.  

---

### VM CheatSheets

**Timestamp**: 05:27:55 – 05:31:25

**Key Concepts**  
- Azure Virtual Machines (VMs) support both Linux and Windows OS.  
- VM size is determined by the image, which defines vCPUs, memory, and storage capacity.  
- Default VM limit per subscription: 20 VMs per region.  
- VM billing is hourly.  
- Availability: Single instance VM with all premium storage disks offers 99.9% SLA. Two VMs in an availability set also provide 99.9% SLA.  
- Multiple managed disks can be attached to a VM.  
- Networking components (NSGs, NICs, IPs, VNets) are created or associated when a VM is launched.  
- Bring your own Linux by creating a custom virtual hard disk.  
- Azure Compute Unit (ACU) benchmarks CPU performance relative to Standard A1 SKU.  
- Hyper-V virtualization: two generations (Gen 1 supports most OS, Gen 2 supports most 64-bit Windows and modern Linux/FreeBSD).  
- Connection methods to VMs: SSH (port 22), RDP (port 3389), and Azure Bastion (browser-based SSH/RDP).  
- Update Management: manages OS updates/patches for Windows and Linux VMs across Azure, on-premises, or other clouds. Compliance scans run every 12 hours (Windows) or 3 hours (Linux).  

**Definitions**  
- **Azure Virtual Machine (VM)**: A software emulation of a physical computer running an OS, created and managed in Azure.  
- **Image**: A template defining the VM’s OS, vCPU count, memory, and storage configuration.  
- **Availability Set**: A grouping of VMs to ensure higher availability and redundancy.  
- **Azure Compute Unit (ACU)**: A relative measure of CPU performance across Azure VM SKUs benchmarked against Standard A1.  
- **Hyper-V**: Microsoft’s virtualization technology to create and run virtual machines.  
- **SSH (Secure Shell)**: A protocol for secure command-line access to Linux VMs, using port 22 and RSA key pairs.  
- **RDP (Remote Desktop Protocol)**: A graphical protocol to connect remotely to Windows VMs, using port 3389 TCP/UDP.  
- **Azure Bastion**: A managed PaaS service that provides secure browser-based SSH and RDP access to VMs without exposing public IPs or requiring client software.  
- **Update Management**: Azure service to scan and apply OS updates and patches on VMs across environments, with compliance scan intervals.  

**Key Facts**  
- VM limit: 20 per region per subscription.  
- Single VM SLA with premium disks: 99.9%.  
- Two VMs in availability set SLA: 99.9%.  
- SSH uses port 22; RDP uses port 3389 (TCP/UDP).  
- Update compliance scans: every 12 hours for Windows, every 3 hours for Linux.  
- Update dashboard data latency: 30 minutes to 6 hours.  

**Examples**  
- None explicitly mentioned beyond general use cases (Linux and Windows VMs, custom Linux VHD).  

**Key Takeaways 🎯**  
- Remember the VM limit per region (20).  
- Know the SLA differences: single VM with premium disks vs. availability set.  
- Understand the ports and protocols for VM access: SSH (22), RDP (3389).  
- Azure Bastion is important for secure, browser-based VM access without client software.  
- Update Management is critical for maintaining VM OS compliance and patching across environments.  
- ACU helps compare CPU performance across VM SKUs—Standard A1 is the baseline.  
- Distinguish Hyper-V generations and their OS support, but note Azure Hyper-V differs from on-prem Hyper-V.