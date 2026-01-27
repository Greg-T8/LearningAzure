## Scale Sets

---

### Intro to Scale Sets

**Timestamp**: 06:13:20 – 06:14:18

**Key Concepts**  
- Azure Scale Sets automatically increase or decrease virtual machine (VM) capacity based on demand.  
- Scale policies use host metrics (e.g., CPU utilization, network in) to trigger scaling actions.  
- Health checks and repair policies help maintain VM instance health by replacing unhealthy instances.  
- Load balancers can be associated with scale sets to distribute traffic evenly across VMs and availability zones.  
- Scale sets support scaling up to hundreds or thousands of VMs (e.g., 100 to 1,000 VMs).  

**Definitions**  
- **Azure Scale Sets**: A service that allows automatic scaling of identical VMs to match workload demand, improving availability and cost efficiency.  
- **Scale Policies**: Rules that define when and how to add or remove VM instances based on monitored metrics.  
- **Repair Policy**: Configuration that automatically replaces unhealthy VM instances within a scale set.  
- **Load Balancer**: A service that distributes incoming traffic evenly across multiple VMs to ensure high availability and reliability.  

**Key Facts**  
- Scale sets can scale to 100 or even 1,000 VMs.  
- Associating a load balancer with a scale set helps distribute VMs across multiple availability zones (AZs) for high availability.  
- Recommended practice: run application workloads in scale sets behind load balancers.  
- Running 3 VMs across 3 availability zones is a common pattern to achieve high availability.  
- Load balancer probe checks provide more robust health monitoring than scale set health checks alone.  

**Examples**  
- Example scenario: A web application behind an application load balancer experiences increased traffic, triggering the scale set to add more identical VMs automatically. When traffic decreases, VMs are removed to save costs.  

**Key Takeaways 🎯**  
- Understand that Azure Scale Sets enable automatic VM scaling based on real-time metrics to handle variable workloads efficiently.  
- Always associate scale sets with load balancers to ensure even traffic distribution and high availability across availability zones.  
- Know that scale sets support large-scale deployments (up to thousands of VMs).  
- Remember to configure health checks and repair policies to maintain VM health and availability.  
- For exam scenarios, expect questions on how scale sets integrate with load balancers and availability zones to provide scalable and resilient infrastructure.

---

### Associate a Load Balancer

**Timestamp**: 06:14:18 – 06:15:24

**Key Concepts**  
- Associating a load balancer with Azure scale sets helps distribute virtual machines (VMs) evenly across availability zones.  
- Load balancers improve high availability by spreading VMs across multiple zones (e.g., 3 VMs across 3 availability zones).  
- Load balancer health probes provide more robust health checks than scale set health checks.  
- Two main types of Azure load balancers:  
  - Application Gateway: for HTTP/HTTPS (web traffic) load balancing.  
  - Azure Load Balancer: supports TCP and UDP network traffic.  
- Choice of load balancer depends on the OSI layer and traffic type you need to manage.

**Definitions**  
- **Load Balancer**: A service that distributes incoming network traffic across multiple VMs to ensure reliability and availability.  
- **Application Gateway**: A layer 7 load balancer designed for web traffic (HTTP/HTTPS).  
- **Azure Load Balancer**: A layer 4 load balancer that handles TCP and UDP traffic.

**Key Facts**  
- Scale sets can scale up to 100 or even 1,000 VMs.  
- Best practice is to run application workloads in scale sets behind a load balancer for high availability.  
- Load balancer probes offer enhanced health monitoring compared to scale set health checks.  
- Distributing VMs across multiple availability zones (e.g., 3 VMs in 3 AZs) is recommended for high availability.

**Examples**  
- None explicitly mentioned beyond the general recommendation to run 3 VMs across 3 availability zones behind a load balancer.

**Key Takeaways 🎯**  
- Always associate a load balancer with scale sets to ensure even VM distribution and high availability.  
- Understand the difference between Application Gateway (web traffic) and Azure Load Balancer (network traffic) to choose the correct load balancer type.  
- Use load balancer health probes for more reliable health checks than scale set defaults.  
- Designing for high availability means deploying VMs across multiple availability zones behind a load balancer.

---

### Scaling Policy

**Timestamp**: 06:15:24 – 06:18:51

**Key Concepts**  
- Scaling policies determine when to add (scale out) or remove (scale in) virtual machines in a scale set to meet demand.  
- Scaling out increases capacity by adding VM instances; scaling in decreases capacity by removing VM instances.  
- Metrics drive scaling decisions, commonly CPU usage, network in/out, disk read/write.  
- Aggregates and operators (e.g., greater than, greater than or equal to) refine when scaling triggers occur.  
- Actions specify how many VMs to add or remove, either by fixed count or percentage.  
- Scale-in policies define which VM instance to remove when scaling in (e.g., highest instance ID, newest VM, oldest VM), considering availability zones.  
- Update policies control how VM instances are updated to the latest scale set model: automatic, manual, or rolling updates.  
- Automatic OS upgrades can be enabled to safely update OS disks across instances.  

**Definitions**  
- **Scaling Out**: Adding VM instances to a scale set to increase capacity.  
- **Scaling In**: Removing VM instances from a scale set to decrease capacity.  
- **Scale-in Policy**: Rules that determine which VM instance is removed during scale-in operations.  
- **Update Policy**: Defines how VM instances receive updates to the scale set model (automatic, manual, rolling).  

**Key Facts**  
- Initial scaling policy setup uses a simple wizard focusing on CPU threshold as the metric.  
- More advanced scaling policies allow selection from built-in host metrics: CPU, network in/out, disk read/write.  
- Scaling actions can be specified as a fixed number of VMs or as a percentage increase/decrease (e.g., increase by 30% adds 3 VMs if you have 10).  
- Scale-in options include deleting the VM with the highest instance ID (default), newest VM, or oldest VM, all balancing across availability zones.  
- Update policies include:  
  - Automatic: upgrades start immediately, randomly or in order.  
  - Manual: requires manual upgrade of instances.  
  - Rolling: upgrades in batches with optional pauses.  
- Automatic OS upgrades can be enabled to ease update management by safely upgrading OS disks for all instances.  

**Examples**  
- Increasing load by 30% on 10 servers results in adding 3 additional servers.  
- Scale-in policy default deletes the VM with the highest instance ID while balancing across availability zones.  

**Key Takeaways 🎯**  
- Understand the difference between scaling out (adding VMs) and scaling in (removing VMs).  
- Know the common metrics used to trigger scaling actions and how aggregates and operators refine these triggers.  
- Remember scale-in policies affect which VM is removed and can impact availability zone balancing.  
- Be familiar with update policies and the benefits of automatic OS upgrades for scale sets.  
- Scaling policies start simple but become highly customizable after initial creation—know both basic and advanced options.

---

### Health Monitoring

**Timestamp**: 06:18:51 – 06:20:18

**Key Concepts**  
- Health monitoring determines if a virtual machine instance is healthy or unhealthy.  
- Health monitoring can be enabled or disabled based on needs.  
- Two modes of health monitoring: Application Health Extension and Load Balancer Probe.  
- Automatic repair policy can replace unhealthy instances by terminating and relaunching them.  

**Definitions**  
- **Health Monitoring**: A feature that checks the health status of VM instances to ensure they are functioning properly.  
- **Application Health Extension**: A mode where an HTTP/HTTPS request is sent to a specific path on the VM, expecting a specific status code (e.g., 200) to confirm health.  
- **Load Balancer Probe**: A health check mode that uses TCP, UDP, or HTTP requests through an associated load balancer to determine instance health.  

**Key Facts**  
- Application Health Extension expects a specific HTTP status code (commonly 200) to mark an instance as healthy.  
- Load Balancer Probe requires an associated load balancer and is generally more robust than the Application Health Extension.  
- Automatic repair policy is **not enabled by default**; it must be explicitly turned on.  
- When automatic repair detects an unhealthy instance, it terminates and replaces it with a new instance.  

**Examples**  
- Using a custom health check page (e.g., a dedicated “health check” endpoint) to verify instance health via Application Health Extension.  
- Load Balancer Probe checking health via TCP, UDP, or HTTP requests when a load balancer is present.  

**Key Takeaways 🎯**  
- Always consider enabling health monitoring to maintain VM instance reliability.  
- Prefer Load Balancer Probe mode if you have a load balancer, as it provides a more robust health check.  
- Use custom health check pages for more precise application-level health validation.  
- Remember to explicitly enable the automatic repair policy if you want unhealthy instances to be automatically replaced.  
- Health monitoring helps maintain availability and stability in scale sets by detecting and handling unhealthy instances promptly.

---

### Advanced Features

**Timestamp**: 06:20:18 – 06:21:22

**Key Concepts**  
- Allocation policy for scale sets to manage instance placement beyond default limits  
- Proximity placement groups to physically group Azure resources closer together within the same region  
- Single vs multiple placement groups affecting scale set size and VM distribution  

**Definitions**  
- **Allocation Policy**: A setting that allows scale sets to exceed the default limit of 100 instances, enabling scaling up to 1000 instances by managing VM placement.  
- **Proximity Placement Group**: A feature that groups Azure resources physically closer in the same region to reduce latency and improve performance, especially important for high-performance computing (HPC) workloads.  
- **Placement Group**: A logical grouping of VMs within a scale set. By default, a scale set uses a single placement group that can hold up to 100 VMs. Setting `singlePlacementGroup` to false allows multiple placement groups and scaling up to 1000 VMs.  

**Key Facts**  
- Default scale set limit: 100 instances per single placement group  
- Maximum scale set size with multiple placement groups: up to 1000 instances  
- Proximity placement groups improve latency by physically locating VMs closer together in the same Azure region  
- To scale beyond 100 VMs, allocation policy and multiple placement groups must be enabled  

**Examples**  
- None mentioned explicitly, but HPC workloads are cited as a use case for proximity placement groups due to latency sensitivity  

**Key Takeaways 🎯**  
- Remember that scale sets default to a single placement group limited to 100 VMs; to scale beyond this, you must disable single placement group mode and use allocation policies.  
- Use proximity placement groups when low latency and physical proximity of VMs matter, such as in HPC scenarios.  
- Understanding placement groups and allocation policies is critical for managing large-scale VM deployments in Azure.

---

### Scale Sets CheatSheet

**Timestamp**: 06:21:22 – 06:23:06

**Key Concepts**  
- Azure Scale Sets allow automatic scaling of VM capacity (scale out and scale in).  
- Load balancers can be associated with scale sets to evenly distribute VMs across multiple Availability Zones (AZs) for high availability.  
- Scaling policies control when VMs are added or removed based on demand.  
- Scale in policies determine which VMs are removed (default, newest VM, oldest VM).  
- Update policies control how VM instances are updated to the latest scale set model (automatic, manual, rolling).  
- Health monitoring can be enabled to check VM health using application health extensions or load balancer probes.  
- Automatic repair policy can delete and replace unhealthy VM instances.

**Definitions**  
- **Scale Out**: Adding VM instances to increase capacity.  
- **Scale In**: Removing VM instances to decrease capacity.  
- **Application Health Extension**: Health monitoring method that sends HTTP requests to a specific path expecting a status 200 response.  
- **Load Balancer Probe**: Health check method using TCP, UDP, or HTTP requests to verify VM health.  
- **Automatic Repair Policy**: Automatically deletes and replaces unhealthy VM instances.

**Key Facts**  
- By default, a scale set uses a single placement group supporting up to 100 VMs.  
- Setting the scale set property `singlePlacementGroup` to false allows multiple placement groups and scaling up to 1000 VMs.  
- Load balancers help evenly distribute traffic and perform robust health checks.  
- Scale in policies options: default, newest VM, oldest VM.  
- Update policies options: automatic, manual, rolling.  
- Health monitoring modes: application health extension and load balancer probe.

**Examples**  
- None specifically mentioned beyond general usage scenarios (e.g., distributing VMs across AZs for high availability).

**Key Takeaways 🎯**  
- Remember the difference between scale out (add VMs) and scale in (remove VMs).  
- Know the default VM limit per placement group (100) and how to scale beyond that (up to 1000 with multiple placement groups).  
- Understand the importance of load balancers for distributing traffic and performing health probes.  
- Be familiar with scale in policies and update policies options.  
- Health monitoring and automatic repair policies are critical for maintaining VM health and availability.

---