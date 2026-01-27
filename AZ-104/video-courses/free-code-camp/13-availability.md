# Availability Follow Along

---

## Backup VM using Images

**Timestamp**: 07:16:53 – 07:23:27

**Key Concepts**  
- Creating managed images from virtual machines (VMs) to back them up or replicate them.  
- Using snapshots to capture the state of a VM for image creation.  
- Two main ways to create images:  
  - Managed images (standalone)  
  - Shared Image Gallery (SIG) images with versioning and replication features.  
- Importance of stopping the VM during image capture to avoid inconsistent states.  
- Zone resilience option for images to enable deployment across availability zones.  
- Differences between general and specialized images in SIG.  
- Using images to quickly create new VMs with pre-configured settings.  

**Definitions**  
- **Managed Image**: A snapshot-based image of a VM that can be used to create new VMs; created by capturing the VM’s disk state.  
- **Shared Image Gallery (SIG)**: A service that stores and manages VM images with versioning, replication, and sharing capabilities across regions and subscriptions.  
- **Zone Resilience**: A feature that allows an image to be deployed across multiple availability zones for higher availability.  
- **Generalized Image**: An image prepared for reuse where the VM has been generalized (e.g., using sysprep on Windows or waagent -deprovision on Linux), requiring a new hostname and configuration on deployment.  
- **Specialized Image**: An image capturing the VM exactly as is, including machine-specific information; no need for reconfiguration on deployment.  

**Key Facts**  
- VM must be stopped to create a managed image to ensure consistency.  
- Zone resilience should be enabled on images if you want to deploy VMs in any availability zone.  
- Creating an image from a VM can be done via the Azure portal’s “Capture” option.  
- Shared Image Gallery images require an image definition and versioning (e.g., version 0.0.1).  
- Shared Image Gallery is the preferred method for image management due to version control and replication.  
- Creating a VM from an image is straightforward: select the image and Azure pre-populates the VM creation form.  
- Images can be created with or without placing them in a shared image gallery.  

**Examples**  
- Created a Linux VM named “Wolf” running Ubuntu 18.04 LTS with Apache installed via custom data (bash script).  
- Captured an image of the “Wolf” VM twice: once as a standalone managed image (not in SIG) and once in the Shared Image Gallery.  
- Demonstrated creating a VM from both types of images.  

**Key Takeaways 🎯**  
- Always stop the VM before capturing an image to avoid inconsistent snapshots.  
- Use Shared Image Gallery for better image management, including versioning and replication across regions.  
- Enable zone resilience on images if you want to deploy VMs across availability zones.  
- Understand the difference between generalized and specialized images and when to use each.  
- Creating a VM from an image is simple and useful for backups, scaling, or disaster recovery.  
- Remember that images can be created via the VM “Capture” button or directly through the Images or Shared Image Gallery services.  
- For exam scenarios, expect questions on image creation, image types, and benefits of using Shared Image Gallery.  

---

## Review Availability Sets

**Timestamp**: 07:23:27 – 07:26:03

**Key Concepts**  
- Availability Sets are critical for ensuring high availability of VMs by distributing them across fault domains and update domains.  
- Fault domains represent physical hardware racks that can fail independently.  
- Update domains represent groups of VMs that can be updated or rebooted at the same time without affecting others.  
- Availability Sets help maintain service uptime during planned maintenance or hardware failures.  
- Availability Zones physically separate resources within an Azure region for higher availability.  
- Virtual Machine Scale Sets (VMSS) relate to availability but have automatic scaling and default fault/update domain settings.

**Definitions**  
- **Availability Set**: A logical grouping of VMs that ensures VMs are distributed across multiple fault domains and update domains to avoid single points of failure.  
- **Fault Domain**: A physical unit of failure, such as a rack of servers, where hardware failures can affect all VMs in that domain.  
- **Update Domain**: A group of VMs that can be updated or rebooted simultaneously during planned maintenance without impacting other update domains.  
- **Availability Zone**: Physically separate locations within an Azure region to increase fault tolerance.  
- **Virtual Machine Scale Set (VMSS)**: A group of identical, load-balanced VMs with automatic scaling capabilities, typically defaulting to 5 fault domains and 5 update domains.

**Key Facts**  
- Availability Sets require specifying the number of fault domains and update domains when created.  
- Scale Sets default to 5 fault domains and 5 update domains.  
- Availability Sets do not support automatic scaling; all VMs are identical in the set.  
- Availability Zones provide physical separation within a region, enhancing availability beyond fault/update domains.  
- Exam questions may ask how to achieve specific SLA percentages (e.g., 99.5%) using combinations of availability sets, scale sets, and zones.

**Examples**  
- None explicitly demonstrated; the instructor references a graphic showing racks (fault domains) and update domains to illustrate VM distribution and update scheduling.

**Key Takeaways 🎯**  
- Understand how fault domains and update domains work together in Availability Sets to maintain uptime.  
- Know the difference between Availability Sets and Scale Sets, especially regarding scaling and default domain counts.  
- Be familiar with Availability Zones as a higher-level physical separation option within regions.  
- Be prepared for exam questions on SLAs requiring knowledge of how to combine these availability features to meet uptime requirements.  
- When creating an Availability Set, you must specify fault and update domains; for Scale Sets, these are defaulted.  
- Availability Sets are foundational knowledge for AZ-900 and essential for administrator-level exams.

---

## Create a Scale Sets

**Timestamp**: 07:26:03 – 07:31:07

**Key Concepts**  
- Virtual Machine Scale Sets (VMSS) allow you to deploy and manage a set of identical VMs.  
- Scale sets support automatic scaling and availability across multiple availability zones.  
- Scale sets can be created from existing images, such as those in a Shared Image Gallery.  
- Scaling policies can be manual or automatic based on metrics like CPU usage.  
- Health monitoring and automatic repair can be enabled to maintain instance health.  
- Upgrade policies and over-provisioning settings control how scale sets update and manage instances.  

**Definitions**  
- **Virtual Machine Scale Set (VMSS)**: A group of identical, load-balanced VMs that can automatically scale to meet demand.  
- **Availability Zones**: Physically separate locations within an Azure region to increase availability and fault tolerance.  
- **Scaling Policy**: Rules that determine how and when the number of VM instances in a scale set increases or decreases.  
- **Health Monitoring**: A feature that checks the health of VM instances and can trigger automatic repairs.  
- **Over-provisioning**: Creating more VM instances than requested initially to speed up deployment, which can be controlled to avoid unexpected billing.  

**Key Facts**  
- Default availability zones for scale sets are typically set to 3 for enterprise-grade availability.  
- Initial VM instance count can be set manually; example used was 3 instances matching 3 availability zones.  
- Scaling policies can be set to manual or based on metrics such as average CPU percentage.  
- Health monitoring can be configured on specific ports (e.g., port 80 for web servers).  
- Automatic repair replaces unhealthy instances after a configurable grace period (example: 10 minutes).  
- Upgrade policies control how and when VM instances are updated or replaced.  
- Over-provisioning is enabled by default but can be turned off to prevent unexpected charges.  

**Examples**  
- Created a scale set named "Wolf Scale Set" using an image from the Shared Image Gallery.  
- Set the scale set to use 3 availability zones and an initial instance count of 3.  
- Used manual scaling to increase instances from 1 to 3.  
- Enabled health monitoring on port 80 and automatic repair with a 10-minute grace period.  

**Key Takeaways 🎯**  
- Always use 3 availability zones for enterprise-scale VM scale sets to ensure high availability.  
- Use Shared Image Gallery images to simplify scale set creation.  
- Understand the difference between manual and automatic scaling policies; automatic scaling can be based on CPU or other metrics.  
- Enable health monitoring and automatic repair to maintain VM instance health and availability.  
- Be aware of upgrade policies and over-provisioning settings to control costs and update behavior.  
- Manual scaling is straightforward for exam scenarios, but know how to configure auto scaling rules as well.  
- Remember that scale sets integrate with load balancers or application gateways for traffic distribution (covered in next sections).

---

## Create an Application Gateway

**Timestamp**: 07:31:07 – 07:37:36

**Key Concepts**  
- Application Gateway is a type of load balancer operating at Layer 7 (application layer).  
- Azure Load Balancers operate at Layer 4 (transport layer - TCP/UDP).  
- Application Gateway is suitable for web applications requiring HTTP/HTTPS routing and advanced traffic management.  
- Setting up an Application Gateway involves configuring frontend IP, backend pools, listeners, HTTP settings, and routing rules.  
- Subnets must be dedicated for the Application Gateway within the virtual network.  
- Backend pools can include virtual machine scale sets, but they must be in the same virtual network.  
- After adding a scale set to the backend pool, the scale set instances may require an upgrade for changes to take effect.  
- Health probes can be configured to monitor backend instance health via custom paths (e.g., /healthcheck).

**Definitions**  
- **Application Gateway**: A Layer 7 load balancer in Azure that manages web traffic by routing HTTP/HTTPS requests based on URL paths, host headers, and other application-level information.  
- **Load Balancer (Azure Load Balancer)**: A Layer 4 load balancer that distributes traffic based on TCP/UDP protocols without inspecting application-level data.  
- **Backend Pool**: A group of backend servers (VMs or scale sets) that receive traffic from the Application Gateway.  
- **Listener**: A configuration that listens for incoming traffic on a specified frontend IP and port.  
- **HTTP Settings**: Configuration that defines how the Application Gateway communicates with backend servers, including port, cookie-based affinity, and connection draining.  
- **Health Probe**: A mechanism to monitor the health of backend instances by periodically sending requests to a specified path.

**Key Facts**  
- Application Gateway requires a dedicated subnet within the virtual network (e.g., subnet named "VGW" with address range 10.0.2.0/24).  
- Recommended to have at least three instances for availability (rule of three).  
- Frontend IP can be public or private; in this example, a public IP named "Wolf VGW" was created.  
- Backend pool was linked to a virtual machine scale set named "Wolf skill set."  
- Listener configured for HTTP on port 80 with a single frontend IP.  
- HTTP settings used port 80, no cookie-based affinity or connection draining enabled for this simple app.  
- Scale set instances must be upgraded after adding them to the backend pool for the changes to apply.  
- Health probes can be customized to check specific URLs like "/healthcheck" for backend health monitoring.

**Examples**  
- Web application: Simple Apache page served via Application Gateway.  
- Virtual network used: "WolfVNet 499" with a dedicated subnet "VGW" created for the Application Gateway.  
- Backend pool linked to a VM scale set named "Wolf skill set."  
- Listener named "mylistener" configured for HTTP port 80 on public frontend IP.  
- HTTP settings named "my HTTP settings" with default port 80 and no advanced options enabled.

**Key Takeaways 🎯**  
- Understand the difference between Azure Load Balancer (Layer 4) and Application Gateway (Layer 7) and when to use each.  
- Always create a dedicated subnet for the Application Gateway within the virtual network.  
- Ensure backend pools and Application Gateway are in the same virtual network to avoid configuration issues.  
- Remember to upgrade VM scale set instances after adding them to the backend pool to activate changes.  
- Configure listeners and HTTP settings carefully to match your application requirements (e.g., port, protocol, cookie affinity).  
- Use health probes to monitor backend health and improve application availability.  
- For exam scenarios, be prepared to identify components of Application Gateway and troubleshoot common issues like subnet conflicts or scale set upgrades.

---
