# Containers

## ACI

**Timestamp**: 08:31:10 – 08:41:42

**Key Concepts**  
- Azure Container Instances (ACI) allow packaging, deploying, and managing cloud applications using containers.  
- ACI is a fully managed Docker-as-a-service, removing the need to manage underlying VMs.  
- Containers can be provisioned in seconds vs. minutes for VMs.  
- Containers are billed per second; VMs are billed per hour.  
- Containers support granular/custom sizing of vCPU, memory, and GPUs; VM sizes are fixed.  
- ACI supports both Windows and Linux containers.  
- Persistent storage in ACI is achieved by mounting external volumes, commonly Azure Files.  
- Containers are stateless by default; state persistence requires external volume mounts.  
- Container groups are collections of containers scheduled on the same host, sharing lifecycle, network, and storage resources.  
- Container groups are similar to Kubernetes pods but are not the same.  
- Multi-container groups currently support only Linux containers.  
- Deployment of multi-container groups can be done via ARM templates (for complex deployments) or YAML files (for container-only deployments).  
- Container restart policies: **Always**, **Never**, and **OnFailure**.  
- Environment variables (including secured environment variables) can be passed to containers via portal, CLI, or PowerShell.  
- CLI commands for troubleshooting: `az container logs`, `az container attach`, `az container exec`, and `az monitor metrics list`.  

**Definitions**  
- **Azure Container Instances (ACI)**: A service to launch containers in Azure without managing underlying VMs, designed for isolated containers running simple apps, task automation, or build jobs.  
- **Container Group**: A set of containers deployed on the same host machine that share lifecycle, network, and storage resources.  
- **Restart Policies**: Rules defining when a container should restart:  
  - **Always**: Restart container regardless of exit status (ideal for services/web servers).  
  - **Never**: Run container once and do not restart (ideal for background jobs/tasks).  
  - **OnFailure**: Restart container only if it exits with an error.  
- **Environment Variables (nVars)**: Key-value pairs passed to containers for configuration; can be secured to avoid exposure of sensitive data.  

**Key Facts**  
- Containers start in seconds; VMs take minutes.  
- Billing is per second for containers, per hour for VMs.  
- Multi-container groups only support Linux containers currently.  
- Persistent storage options include Azure Files, Secret Volumes, Empty Directory, Cloud Git Repo.  
- Mounting external volumes requires CLI or PowerShell; not supported via portal UI.  
- Containers accessed via fully qualified domain names (FQDN).  

**Examples**  
- Deploying a simple "Hello World" container instance using Azure’s quick start image.  
- Creating a container group named "Banana" with a Linux container in East US 2 region.  
- Mounting Azure Files to containers to persist data across container restarts.  
- Using CLI commands to fetch logs (`az container logs`), attach to container (`az container attach`), execute commands inside container (`az container exec`), and retrieve metrics (`az monitor metrics list`).  

**Key Takeaways 🎯**  
- Know the benefits of containers over VMs: faster provisioning, per-second billing, and flexible sizing.  
- Understand container groups and their similarity to Kubernetes pods but recognize they are not identical.  
- Remember multi-container groups only support Linux containers at this time.  
- Be familiar with the three container restart policies and their use cases.  
- Containers are stateless by default; always plan to mount external storage for persistence.  
- Know how to pass environment variables securely to containers, especially secrets.  
- Be comfortable with Azure CLI commands for troubleshooting containers, as these may appear on the exam.  
- Remember that mounting external volumes cannot be done through the portal; use CLI or PowerShell.  
- ACI containers are accessible via fully qualified domain names, which is common in Azure services.

---

## ACR

**Timestamp**: 08:41:42 – 08:45:19

**Key Concepts**  
- Azure Container Registry (ACR) is a managed private Docker registry service based on Docker Registry 2.0.  
- ACR integrates with existing container development and deployment pipelines.  
- ACR Tasks enable automated building and patching of container images in Azure.  
- Container images stored in ACR can be pulled to various deployment targets such as Kubernetes, DCOS, Docker Swarm, and multiple Azure services (AKS, Azure App Service, Azure Batch, Azure Service Fabric).  
- ACR supports multiple ways to interact: Azure CLI, PowerShell, Portal, SDK, and Docker Extension for Visual Studio Code.  
- ACR Tasks can be triggered on demand, by source code updates, base image updates, or on a schedule.  
- Multi-step ACR Tasks allow complex build workflows.  
- Each ACR Task has an associated source code context (location of source files for building images).  
- Run variables in ACR Tasks enable reuse of task definitions and standardized tagging.

**Definitions**  
- **Azure Container Registry (ACR)**: A managed private Docker registry service in Azure for storing and managing private container images and related artifacts.  
- **ACR Tasks**: Automated workflows in ACR to build, patch, and manage container images, supporting triggers and multi-step processes.  
- **Source Code Context**: The location of source files used by an ACR Task to build container images or artifacts.  
- **Run Variables**: Variables used in ACR Tasks to reuse task definitions and standardize image tagging.

**Key Facts**  
- ACR is based on open source Docker Registry 2.0.  
- Supports integration with container orchestrators and Azure services like AKS, Azure App Service, Azure Batch, and Azure Service Fabric.  
- Developers can push images to ACR using Azure Pipelines, Jenkins, CLI, PowerShell, Portal, SDK, or Docker Extension for VS Code.  
- ACR Tasks do not require a local Docker Engine installation to push images.  
- Triggers for ACR Tasks include source code changes, base image updates, and scheduled timers.  
- Multi-step tasks allow complex build sequences.  
- Run variables help standardize and reuse task definitions.

**Examples**  
- Using ACR Tasks to automate OS and framework patching for Docker containers.  
- Triggering automated builds when source code or base images are updated.  
- Pulling container images from ACR to Kubernetes, DCOS, or Docker Swarm clusters.  
- Using Docker Extension for Visual Studio Code to work with ACR.

**Key Takeaways 🎯**  
- Know that ACR is a managed private Docker registry service tightly integrated with Azure and container orchestration platforms.  
- Understand the purpose and capabilities of ACR Tasks for automating container image builds and patching.  
- Remember that ACR Tasks support multiple trigger types and multi-step workflows.  
- Be familiar with the concept of source code context and run variables in ACR Tasks.  
- Recognize the various ways to interact with ACR, including CLI, PowerShell, Portal, SDK, and VS Code Docker Extension.  
- For the exam, focus on ACR’s role in container image management and automation within Azure DevOps pipelines and deployment workflows.

---

## AKS

**Timestamp**: 08:45:19 – 09:13:36

**Key Concepts**  
- Azure Kubernetes Service (AKS) is a fully managed Kubernetes as a Service offering by Azure.  
- AKS manages the Kubernetes master components (control plane), health monitoring, and maintenance.  
- Users are responsible only for managing the agent nodes (worker nodes).  
- AKS service itself is free; you only pay for the agent nodes.  
- AKS supports advanced features during deployment such as advanced networking, Azure AD integration (RBAC), monitoring, and Windows Server containers.  
- AKS is suitable when full container orchestration is needed: service discovery, automatic scaling, coordinated application upgrades.  
- Bridge to Kubernetes is a Visual Studio/Visual Studio Code extension that allows developers to debug microservices locally while connected to an AKS cluster.  
- Kubernetes clusters in Azure require registration of the Kubernetes resource provider before use.  
- Azure CLI (`az`) and `kubectl` are primary tools for managing AKS clusters and Kubernetes resources.  
- Deployments can be created using pre-built container images (e.g., NGINX, HTTPD/Apache).  
- Pods can be scaled using `kubectl scale` to increase replicas.  
- Node pools can be scaled using `az aks scale` to increase the number of nodes.  
- Kubernetes resources and cluster management can be done via Azure Portal, CLI, or YAML/JSON configuration files.  
- Cleaning up involves deleting deployments, pods, and the AKS cluster to avoid unnecessary costs.

**Definitions**  
- **AKS (Azure Kubernetes Service)**: A managed Kubernetes service in Azure where the control plane is managed by Azure and users manage only the agent nodes.  
- **Agent Nodes**: Worker nodes in the Kubernetes cluster that run containerized applications.  
- **Bridge to Kubernetes**: A Visual Studio/VS Code extension that enables local development and debugging of microservices connected to an AKS cluster by proxying traffic.  
- **kubectl**: Kubernetes command-line tool used to interact with Kubernetes clusters.  
- **Node Pool**: A group of nodes within an AKS cluster that share the same configuration.  
- **Load Balancer Service**: A Kubernetes service type that exposes an application externally using a cloud provider’s load balancer.

**Key Facts**  
- AKS control plane (masters) is free; only agent nodes incur cost.  
- Recommended node count for production: 3 nodes; for development: 1 node.  
- Minimum node VM size requirements: at least 2 cores and 4 GB memory.  
- Default node size DS2 v2 costs approximately $136/month; smaller sizes cost less but may not meet minimum requirements.  
- Scaling pods example: increasing replicas from 1 to 3 using `kubectl scale deployment <name> --replicas=3`.  
- Scaling nodes example: increasing node count to 3 using `az aks scale --resource-group <rg> --name <cluster> --node-count 3`.  
- After deployment, services can be exposed with type LoadBalancer to get an external IP address for public access.  
- Azure Portal may have delays or inconsistencies in reflecting real-time cluster status; CLI verification is recommended.

**Examples**  
- Creating an AKS cluster named "Borg" in resource group "Borg" with 1 node for development.  
- Deploying NGINX using: `kubectl create deployment nginx --image=nginx`  
- Exposing NGINX deployment with: `kubectl expose deployment nginx --port=80 --type=LoadBalancer`  
- Deploying Apache HTTPD using: `kubectl create deployment httpd --image=httpd`  
- Scaling HTTPD deployment to 3 pods: `kubectl scale deployment httpd --replicas=3`  
- Scaling AKS node pool to 3 nodes: `az aks scale --resource-group Borg --name Borg --node-count 3`  
- Cleaning up by deleting deployments (`kubectl delete deployment nginx` and `kubectl delete deployment httpd`) and deleting the AKS cluster from Azure Portal or CLI.

**Key Takeaways 🎯**  
- Remember AKS control plane is free; cost is only for agent nodes.  
- Always register the Kubernetes resource provider before creating AKS clusters.  
- Use Azure CLI (`az aks`) and `kubectl` commands for cluster and workload management.  
- Know how to deploy container images, expose services, and scale pods and nodes.  
- Use Bridge to Kubernetes extension for efficient local debugging of microservices within AKS.  
- Verify cluster and node status via CLI due to possible Azure Portal delays.  
- Clean up resources after use to avoid unnecessary charges.  
- Understand the difference between pod scaling (replicas) and node scaling (worker nodes).  
- For exam scenarios, focus on AKS architecture, cost model, deployment basics, and scaling commands.

---
