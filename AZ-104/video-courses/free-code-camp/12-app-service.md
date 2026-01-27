# App Service

**Channel:** freeCodeCamp.org
**Duration:** 11:16:25
**URL:** https://www.youtube.com/watch?v=10PbGbTUSAg

## Intro to App Service

**Timestamp**: 06:23:06 – 06:25:02

**Key Concepts**  
- Azure App Service is a Platform as a Service (PaaS) for hosting web apps, REST APIs, and mobile backends.  
- Supports multiple programming languages and can run on Windows or Linux environments.  
- Azure App Service manages underlying infrastructure tasks such as OS and language security patches, load balancing, and auto-scaling.  
- Integrations available with Azure DevOps, GitHub, Docker Hub, and package management.  
- Supports easy setup of staging environments, custom domains, and SSL certificates.  
- Pricing is based on Azure App Service plans with multiple tiers (Shared, Basic, Standard, Premium, Isolated).  
- Supports running Docker containers (single or multi-container).  
- When creating an app, a default domain on azurewebsites.net is assigned, which can be overridden with a custom domain.  
- Runtimes in Azure App Service are predefined containers including programming languages, libraries, and web frameworks.

**Definitions**  
- **Azure App Service**: An HTTP-based PaaS for deploying and managing web applications, REST APIs, and mobile backends without managing infrastructure.  
- **Runtime**: Software instructions executed while a program runs, including the programming language, libraries, and frameworks used. In Azure App Service, runtimes are predefined containers with these components installed.

**Key Facts**  
- Azure App Service supports both Windows and Linux environments.  
- Pricing tiers include Shared (free, no Linux support), Basic, Standard, Premium (versions 1, 2, 3), and Isolated.  
- Azure App Service is comparable to Heroku in terms of PaaS functionality.  
- Docker containers (single or multi) can be run on Azure App Service.  
- Default domain format: [appname].azurewebsites.net.

**Examples**  
- Comparison to Heroku as a similar PaaS offering.  
- Integration examples: Azure DevOps, GitHub, Docker Hub.

**Key Takeaways 🎯**  
- Understand Azure App Service as a PaaS that abstracts infrastructure management for web apps and APIs.  
- Know the pricing tiers and that Shared tier does not support Linux.  
- Remember Azure App Service supports multiple languages and runtimes via predefined containers.  
- Be aware that Docker container deployment is supported.  
- Default domain names can be customized with your own domain and SSL certificates.  
- Runtimes define the environment your app runs in, including language and framework support.

---

## Runtimes

**Timestamp**: 06:25:02 – 06:26:32

**Key Concepts**  
- A runtime is the software environment that executes your program while it is running.  
- Runtimes define the programming language, libraries, and frameworks used by your application.  
- Azure App Services provide predefined containerized runtimes with common languages and libraries installed.  
- Multiple versions of runtimes are supported, but older versions may be retired to maintain security and modern standards.  
- If a language is not supported natively, you can deploy a custom Docker container with your desired runtime.

**Definitions**  
- **Runtime**: Software instructions executed during program execution, including the programming language, libraries, and frameworks used.  
- **Azure App Services Runtime**: A predefined container environment in Azure that includes specific programming languages and commonly used libraries/frameworks for web applications.

**Key Facts**  
- Supported runtimes include: .NET, .NET Core, Java, Ruby, Node.js, PHP, Python.  
- Azure App Services supports multiple versions of these runtimes (e.g., Ruby 2.6, 2.7; multiple PHP and Node.js versions).  
- Cloud providers commonly retire older runtime versions to encourage security best practices and modernization.  
- Ruby is supported in Azure App Services, but as of the video date, Application Insights does not support Ruby.  
- Custom runtimes can be created using Docker containers and deployed via Azure Container Registry.

**Examples**  
- Using Ruby 2.6 or 2.7 runtime in Azure App Services.  
- Deploying a custom Docker container with Elixir runtime if the language is not natively supported.

**Key Takeaways 🎯**  
- Understand that runtimes are essential for defining the environment your app runs in, including language and libraries.  
- Always check which runtime versions are supported and be aware that older versions may be deprecated.  
- For unsupported languages or custom dependencies, use Docker containers to create custom runtimes.  
- Remember the limitation that some runtimes (e.g., Ruby) may have partial support in Azure services like Application Insights.  
- Keeping runtimes updated is critical for security and compatibility in cloud environments.

---

## Custom Containers

**Timestamp**: 06:26:32 – 06:27:15

**Key Concepts**  
- Using custom containers allows deployment of applications in languages or environments not natively supported by Azure App Services.  
- Custom containers can be created for both Windows and Linux environments.  
- Docker containers are built locally and then pushed to Azure Container Registry for deployment.  
- Custom containers enable bundling specific packages or dependencies directly into the container image.

**Definitions**  
- **Custom Container**: A Docker container image created by the user that packages an application and its dependencies, which can be deployed to Azure App Services when native support is unavailable or insufficient.

**Key Facts**  
- Azure App Services supports deploying custom container images from Azure Container Registry.  
- Custom containers can be used to run languages not supported by default on Azure App Services (e.g., Elixir).  
- Both Windows and Linux containers are supported for custom container deployment.

**Examples**  
- Deploying an Elixir application by creating a custom Docker container, pushing it to Azure Container Registry, and deploying it to Azure App Service.

**Key Takeaways 🎯**  
- Remember that custom containers provide flexibility to run unsupported languages or include specific dependencies.  
- Know the workflow: create Docker container locally → push to Azure Container Registry → deploy to Azure App Service.  
- Useful for scenarios requiring custom runtime environments or bundled packages beyond Azure’s default offerings.

---

## Deployment Slots

**Timestamp**: 06:27:15 – 06:28:12

**Key Concepts**  
- Deployment slots allow creation of multiple environments for a web app within Azure App Service.  
- Each slot can have its own unique host name.  
- Slots are useful for staging, QA, development, or any custom environment needs.  
- Deployment slots enable quick cloning of the production environment for testing or validation.  
- Swapping deployment slots facilitates blue-green deployment strategies.  

**Definitions**  
- **Deployment Slots**: Separate deployment environments within an Azure App Service that can run different versions of an app simultaneously and have distinct hostnames.  
- **Swapping**: The process of exchanging the content and configuration of one deployment slot with another, typically swapping a staging slot with production to promote a tested version live.  
- **Blue-Green Deployment**: A deployment technique where two identical environments (blue and green) are maintained; one is live while the other is used for testing new releases, then swapped to minimize downtime and risk.  

**Key Facts**  
- Deployment slots provide different hostnames (e.g., app, staging, beta).  
- Swapping allows seamless promotion of a tested slot to production without downtime.  
- This approach supports safer and more controlled app deployments.  

**Examples**  
- Having a “staging” or “beta” slot as a clone of production to deploy and test new app versions before swapping to production.  

**Key Takeaways 🎯**  
- Understand deployment slots as a way to manage multiple app environments within the same Azure App Service.  
- Remember that swapping slots is a core feature enabling blue-green deployment, reducing downtime and deployment risk.  
- Know that each slot has its own hostname, allowing parallel testing and validation.  
- Deployment slots are essential for staging, QA, and developer environments in production workflows.

---

## App Service Environment

**Timestamp**: 06:28:12 – 06:30:49

**Key Concepts**  
- Azure App Service Environment (ASE) provides a fully isolated and dedicated environment for running App Service at high scale.  
- ASE supports hosting web apps (Windows and Linux), Docker containers, mobile apps, and Azure Functions.  
- ASE is designed for workloads requiring high scale, isolation, secure network access, and high memory utilization.  
- ASE can be created multiple times within a single Azure region or across multiple regions for horizontal scaling of stateless app tiers.  
- ASE uses a specific pricing tier called the **Isolated** tier.  
- ASE apps can be secured behind upstream devices like Web Application Firewalls (WAF).  
- ASE supports deployment into availability zones using zone pinning.  
- There are two types of ASE deployments: **External ASE** and **ILB ASE (Internal Load Balancer ASE)**.  

**Definitions**  
- **App Service Environment (ASE)**: A fully isolated and dedicated Azure App Service feature that enables secure, high-scale hosting of web apps, containers, mobile apps, and functions.  
- **Isolated Tier**: The pricing tier associated with ASE, providing dedicated resources and isolation.  
- **External ASE**: ASE deployment exposing apps on an internet-accessible IP address.  
- **ILB ASE (Internal Load Balancer ASE)**: ASE deployment exposing apps only internally within a virtual network via an internal load balancer.  
- **Zone Pinning**: Deployment of ASE into specific availability zones for high availability and fault tolerance (mentioned but not defined in detail).  
- **WAF (Web Application Firewall)**: A security device that can be used upstream to gate access to ASE apps.  

**Key Facts**  
- ASE allows hosting of multiple app types: Windows web apps, Linux web apps, Docker containers, mobile apps, and Azure Functions.  
- Multiple ASEs can be created in one or across multiple Azure regions for horizontal scaling.  
- ASE apps can be connected securely to on-premises networks via site-to-site VPN or ExpressRoute.  
- ASE resides within a customer’s own Virtual Network (VNet) and subnet, allowing direct access to VNet resources without extra configuration.  
- External ASE exposes apps to the internet; ILB ASE restricts access to internal VNet only.  

**Examples**  
- External ASE: App exposed on an internet-accessible IP address.  
- ILB ASE: App accessible only internally within the VNet, suitable for private/internal applications.  
- ASE connected to on-premises networks via site-to-site VPN or ExpressRoute for hybrid connectivity.  

**Key Takeaways 🎯**  
- Remember ASE is designed for enterprise-grade, high-scale, isolated, and secure app hosting beyond typical PaaS offerings.  
- Know the difference between External ASE (internet-facing) and ILB ASE (internal-only).  
- ASE requires the Isolated pricing tier.  
- ASE supports integration with upstream security devices like WAF for enhanced security.  
- ASE can be deployed across availability zones (zone pinning) for resilience.  
- ASE’s placement inside a VNet allows seamless access to other VNet resources and hybrid connectivity options.  
- Useful for exam scenarios involving secure, large-scale app hosting and network isolation in Azure App Service.

---

## Deployment

**Timestamp**: 06:30:49 – 06:34:53

**Key Concepts**  
- Deployment is the process of pushing changes or updates from a local environment or repository to a remote environment.  
- Azure App Services offers a wide variety of deployment options, making it very flexible and powerful.  
- Deployment methods can involve direct file copying, package mounting, continuous integration, FTP, cloud sync, and container-based deployments.  
- The deployment directory for Azure App Services is typically `wwwroot` (on both Windows and Linux).  
- File lock conflicts can occur if files are replaced directly in the `wwwroot` folder during deployment, causing unpredictable app behavior.  
- Using package-based deployment (e.g., zip packages mounted as read-only) can help avoid file lock issues.  
- Kudu is the engine behind many Azure App Service deployments, supporting zip deployments, file cleanup, build processes, deployment scripts, and logs.  
- FTP deployment is supported but considered outdated; it requires credentials and an FTP client.  
- Cloud Sync deployment via Dropbox or OneDrive is possible, syncing files directly to the `wwwroot` folder.  
- Azure App Service pricing depends on the App Service Plan tier chosen, which affects features and cost.

**Definitions**  
- **Deployment**: The action of pushing changes or updates from a local environment or repository into a remote environment.  
- **ILB (Internal Load Balancer)**: Mentioned briefly as a difference in a deployment setup; it stands for Internal Load Balancer.  
- **Kudu**: An open-source engine behind Git deployments and Azure App Services, supporting zip deployments, build processes, deployment scripts, and logs.  
- **wwwroot directory**: The root directory where deployed web app files reside and run from in Azure App Services.

**Key Facts**  
- Deployment methods include:  
  - Run from package (zip mounted read-only)  
  - Zip or RAR deployment using Kudu  
  - FTP deployment  
  - Cloud Sync deployment via Dropbox or OneDrive  
  - Continuous deployment from GitHub, Azure Pipelines, GitHub Actions, ARM templates, Docker Hub, Azure Container Registry, local Git repos (mentioned but not detailed)  
- The `wwwroot` directory is used for app runtime files on both Windows and Linux Azure App Service instances.  
- File lock conflicts can cause deployment failures and unpredictable app behavior if files are replaced directly in `wwwroot`.  
- Kudu supports zip deployments up to 2 GB in size.  
- FTP deployment requires an FTP endpoint, username, and password, and uses an FTP client.  
- Cloud Sync deployment creates a folder in Dropbox or OneDrive that syncs to the app’s `wwwroot`.  
- Azure App Service plans determine pricing and available features (tiers discussed after this section).

**Examples**  
- Running from a package: zip package mounted as read-only instead of copying files to `wwwroot`.  
- Zip deployment using Kudu: supports file deletions, build processes, deployment scripts, logs, and can be done via CLI, REST API, or Azure portal.  
- FTP deployment: old-school method where you connect via FTP client using credentials from the deployment center.  
- Cloud Sync deployment: syncing from Dropbox or OneDrive folders to the app’s `wwwroot` directory.

**Key Takeaways 🎯**  
- Understand the variety of deployment options available in Azure App Services and their use cases.  
- Remember that the `wwwroot` directory is the key folder for app files, and direct file replacement can cause issues.  
- Using package-based deployment (run from package) can help avoid file lock conflicts.  
- Kudu is a critical component for zip-based deployments and continuous integration scenarios.  
- FTP deployment is supported but generally outdated; Cloud Sync via Dropbox/OneDrive is a unique but less common option.  
- Be aware that deployment size limits (e.g., 2 GB for zip deployments) and methods of deployment (CLI, REST, portal) exist.  
- Know that Azure App Service plans control pricing and features, which is important for deployment scalability and cost management.

---

## App Service Plan

**Timestamp**: 06:34:53 – 06:38:11

**Key Concepts**  
- Azure App Service requires an App Service Plan to determine pricing and available features.  
- App Service Plans are divided into tiers that define compute resources, scaling, and SLA.  
- There are three main tiers: Shared, Dedicated, and Isolated.  
- Each tier has sub-levels with varying compute power, memory, disk space, and scaling capabilities.  
- SLA (Service Level Agreement) availability varies by tier.  
- Some tiers have limitations on OS support (e.g., Shared tier not supported on Linux).  

**Definitions**  
- **App Service Plan**: A pricing and resource allocation model in Azure App Service that determines how much you pay and what features/resources are available for your web apps.  
- **Shared Tier**: A low-cost tier where apps share compute resources; includes Free (F1) and Shared options.  
- **Dedicated Tier**: Higher performance tiers with dedicated compute resources; includes Basic, Standard, Premium, and Premium v2/v3.  
- **Isolated Tier**: Highest tier with dedicated Azure Virtual Networks and full network isolation, designed for App Service Environments (ASE).  
- **SLA (Service Level Agreement)**: The guaranteed uptime percentage for the service (e.g., 99.95% for Dedicated and Isolated tiers).  

**Key Facts**  
- **Shared Tier**:  
  - Free (F1): 1 GB disk space, up to 10 apps on shared instance, no SLA, 60 minutes compute quota per app per day.  
  - Shared: Up to 100 apps on shared instance, no SLA, 240 minutes compute quota per app per day.  
  - Not supported on Linux; only Windows.  
- **Dedicated Tier**:  
  - Basic (B1, B2, B3): More disk space, unlimited apps, varying compute/memory/disk.  
  - Standard: Scales out to 3 dedicated instances, SLA 99.95%, 3 levels with varying resources.  
  - Premium: Scales out to 10 dedicated instances, SLA 99.95%, multiple hardware levels.  
- **Isolated Tier**:  
  - Scales to 100 instances, SLA 99.95%, full network isolation via Azure Virtual Networks.  
  - Primarily used for App Service Environments (ASE).  
- Terminology and tier names can be confusing and inconsistent.  

**Examples**  
- None explicitly mentioned for App Service Plan configuration, but the speaker references the tier names and their features.  

**Key Takeaways 🎯**  
- Always associate your Azure App Service with an App Service Plan to define cost and capabilities.  
- Understand the differences between Shared, Dedicated, and Isolated tiers to choose the right plan based on app needs and budget.  
- Shared tiers are limited in compute time and do not have SLA guarantees; suitable for development or testing.  
- Dedicated tiers offer better performance, scaling, and SLA, suitable for production workloads.  
- Isolated tier is for advanced scenarios requiring network isolation and large scale.  
- Shared tier is not available for Linux-based apps; Linux apps require at least Basic tier or higher.  
- Be aware that tier names and pricing can be confusing; review Azure documentation carefully before selecting.  
- SLA of 99.95% is standard for Dedicated and Isolated tiers.  
- The App Service Plan abstracts much of the infrastructure management, making it easier to deploy apps without granular resource management.

---

## WebJobs

**Timestamp**: 06:38:11 – 06:39:37

**Key Concepts**  
- WebJobs allow running background scripts or programs within Azure App Services.  
- WebJobs run at no additional cost on Azure App Services.  
- WebJobs currently support only Windows-based environments (no Linux support yet).  
- Supported file types for WebJobs include: command files, bat files, executables, PowerShell, bash, PHP, Python, JavaScript, and Java files.  
- Two types of WebJobs:  
  - **Continuous**: Runs continuously until stopped; supports debugging.  
  - **Triggered**: Runs only when triggered (e.g., scheduled or manual trigger); does not support debugging.  
- Triggered WebJobs can be scheduled using cron expressions and can expose webhooks for manual triggers.  
- Scaling for WebJobs (continuous only):  
  - **Multi-instance**: Runs the WebJob across all instances of the App Service plan.  
  - **Single-instance**: Runs only one copy of the WebJob regardless of the number of App Service instances.

**Definitions**  
- **WebJobs**: A feature of Azure App Services that allows running background scripts or programs alongside web applications without additional cost.  
- **Continuous WebJob**: A WebJob type that runs continuously until manually stopped and supports debugging.  
- **Triggered WebJob**: A WebJob type that runs only when triggered by a schedule or webhook and does not support debugging.

**Key Facts**  
- WebJobs are free to use with Azure App Services.  
- Linux is not supported for WebJobs as of the time of this content.  
- Supported scripting/programming file types are broad, including common scripting and programming languages.  
- Continuous WebJobs support debugging; triggered WebJobs do not.  
- Triggered WebJobs can be scheduled using cron jobs or triggered manually via webhooks.  
- Scaling options apply only to continuous WebJobs.

**Examples**  
- Running a random script within an Azure App Service using WebJobs.  
- Scheduling a triggered WebJob using a cron expression.  
- Using a webhook to manually trigger a WebJob.

**Key Takeaways 🎯**  
- Remember that WebJobs come at no extra cost and are tightly integrated with Azure App Services.  
- WebJobs currently only support Windows environments; Linux support is not available yet.  
- Choose **continuous** WebJobs if you need ongoing execution and debugging capabilities.  
- Use **triggered** WebJobs for on-demand or scheduled execution but note the lack of debugging support.  
- Understand scaling options for continuous WebJobs to optimize resource usage across App Service instances.  
- Be familiar with supported file types to know what scripts or programs can be run as WebJobs.

---

## Configure and Deploy App Service

**Timestamp**: 06:39:37 – 06:48:52

**Key Concepts**  
- Azure App Service is designed to simplify deployment of web applications, with better synergy for Windows, Python, and .NET stacks compared to others like Ruby on Rails on Linux.  
- Azure App Service requires the appropriate resource provider to be registered before use (under "web and domain registration").  
- App Service plans determine pricing and features; Linux plans do not support the free tier, unlike Windows plans.  
- Deployment slots are an advanced feature available only on paid tiers (e.g., B1 and above).  
- Deployment Center in Azure App Service allows linking to source control repositories (e.g., GitHub) for continuous deployment.  
- GitHub Actions can be used to automate deployment workflows triggered by code changes.  

**Definitions**  
- **Azure App Service**: A platform-as-a-service (PaaS) offering to host web applications, APIs, and mobile backends.  
- **Resource Provider**: A service in Azure that must be registered in a subscription to enable specific resource types (e.g., Microsoft.Web for App Services).  
- **Deployment Slots**: Separate deployment environments (e.g., staging, production) within an App Service to enable zero-downtime deployments.  
- **Deployment Center**: Azure portal feature to configure continuous deployment from source control to App Service.  
- **GitHub Actions**: CI/CD workflows integrated with GitHub repositories to automate build and deployment processes.  

**Key Facts**  
- Azure App Service resource provider is under "web and domain registration" and must be registered to use App Services.  
- App Service plan pricing example: Premium V2 tier costs approximately $0.20 USD per hour (~$146 USD/month), with regional price variations (e.g., Canada East shows CAD pricing).  
- Linux App Service plans do not support the free tier; Windows plans do.  
- Deployment slots require at least a B1 tier plan ($0.20/hr).  
- The example app used is a simple Python Flask "Hello World" app from the Azure samples GitHub repository.  
- GitHub repository branch naming may be "master" instead of "main" in some older samples.  
- Deployment via Deployment Center requires GitHub authorization and linking to a repository; a fork may be needed if the original repo is not accessible.  
- GitHub Actions workflow YAML file defines the deployment steps including checkout, Python setup, and build on Ubuntu-latest runner.  
- Deployment is triggered by code changes; no deployment occurs until a commit is made.  

**Examples**  
- Deploying a Python Flask app from the Azure-samples GitHub repo: `github.com/azuresamples/python/docs/helloworld`  
- Using Deployment Center to connect to GitHub, authorize, fork the sample repo, and configure deployment from the "master" branch.  
- GitHub Actions workflow automates deployment steps on push to the repository.  

**Key Takeaways 🎯**  
- Always verify the Azure App Service resource provider is registered before creating App Services.  
- Understand the pricing and feature differences between Linux and Windows App Service plans, especially regarding free tiers and deployment slots.  
- Deployment Center is the primary Azure portal tool for configuring continuous deployment from GitHub.  
- GitHub Actions is the underlying mechanism for automated deployments; be familiar with the workflow YAML file structure.  
- For exam scenarios, know how to link an App Service to a GitHub repo, authorize access, and trigger deployments via commits.  
- Be aware that some sample repos may use "master" branch naming, which can affect deployment configuration.  
- Deployment slots require a paid tier; free tiers do not support this feature.  
- If authentication issues arise with GitHub, creating a new GitHub account or forking the repo can be a workaround.

---

## Trigger a Deploy via Github Actions

**Timestamp**: 06:48:52 – 06:56:24

**Key Concepts**  
- Deployment via GitHub Actions requires a workflow YAML file in the `.github/workflows` directory specifying build and deployment steps.  
- A deployment is triggered by committing changes to the specified branch (e.g., `main`).  
- GitHub Actions runs on Ubuntu latest environment and includes steps like checkout, Python setup, build, and deploy.  
- After committing a change, the GitHub Actions workflow runs automatically and can be monitored via logs.  
- If the deployed app does not serve correctly, troubleshooting involves SSH into the deployment instance to check running processes and ports.  
- Python apps often run with Gunicorn as the WSGI server; configuration is needed to bind Gunicorn to the correct port (usually port 80).  
- A `startup.txt` file can be added to the repo to configure Gunicorn with commands to bind the app to port 80 and specify worker count.  
- Committing the `startup.txt` triggers a new deployment with the correct startup configuration.  
- To verify deployment success, make a visible code change (e.g., change a string in `app.py`), commit, and confirm the change reflects on the live site.  
- Deployment slots and advanced features require upgrading the Azure App Service plan from Basic to Standard or Premium tiers.

**Definitions**  
- **GitHub Actions**: A CI/CD platform integrated with GitHub that automates workflows such as building, testing, and deploying code based on repository events.  
- **Workflow YAML file**: A configuration file in `.github/workflows` that defines the steps and environment for GitHub Actions to execute.  
- **Gunicorn**: A Python WSGI HTTP server used to serve Python web applications in production.  
- **Startup.txt**: A configuration file containing commands to start the app server correctly (e.g., binding Gunicorn to port 80).  
- **Deployment slots**: Feature in Azure App Service allowing staging and production environments for zero-downtime deployments, requiring a higher service tier.

**Key Facts**  
- GitHub Actions workflow runs on `ubuntu-latest`.  
- Deployment logs show progress and duration (example: 1 minute 29 seconds for a deploy).  
- Default Flask app runs on port 5000, which is not accessible externally in Azure App Service; port 80 must be used.  
- Gunicorn needs explicit configuration to bind to port 80 and specify worker count.  
- Adding or modifying `startup.txt` triggers a new deployment.  
- Upgrading from Basic (B1) to Standard or Premium tier is required to use deployment slots.  
- Standard tier example cost mentioned: approximately $80/month.

**Examples**  
- Making a trivial change (adding a space) to trigger a deployment.  
- Using `ps aux | grep python` via SSH to check running Python/Gunicorn processes.  
- Running `curl localhost` on the instance to verify if the app is responding.  
- Creating a `startup.txt` file with Gunicorn command:  
  ```
  gunicorn --bind=0.0.0.0:80 --workers=4 app:app
  ```  
- Changing a string in `app.py` (e.g., changing displayed text to "Vulkan") to verify deployment success.

**Key Takeaways 🎯**  
- Always ensure your GitHub Actions workflow YAML is correctly configured and present to automate deployments.  
- Deployment is triggered by commits to the specified branch; no manual trigger needed beyond pushing changes.  
- Monitor deployment progress and logs via GitHub Actions interface.  
- If the app does not serve correctly after deployment, SSH into the instance to debug processes and ports.  
- Configure Gunicorn (or your app server) to bind to port 80 to serve the app properly in Azure App Service.  
- Use a `startup.txt` or equivalent startup script committed to the repo to automate app startup configuration.  
- Verify deployments by making visible code changes and confirming updates on the live site.  
- Deployment slots and advanced deployment features require upgrading your Azure App Service plan beyond Basic tier.  
- Remember port 5000 (Flask default) is not accessible externally; always use port 80 for production deployments in Azure App Service.

---

## Create Deployment Slots

**Timestamp**: 06:56:24 – 07:07:44

**Key Concepts**  
- Deployment slots allow running different versions of an app simultaneously (e.g., production and staging).  
- Deployment slots require upgrading the Azure App Service plan from Basic (B1) to Standard or Premium tiers.  
- Each deployment slot has its own deployment configuration and code, even though some settings may be copied.  
- Separate GitHub workflows (e.g., staging.yaml) are created for deployment slots to manage deployments independently.  
- Deployment slots enable zero-downtime swapping of app versions between staging and production.  
- Traffic can be split between slots by specifying percentage traffic routing to each slot.  
- Scaling (scale up and scale out) is related but separate from deployment slots and requires Standard or higher tiers.

**Definitions**  
- **Deployment Slot**: A live app environment within the same App Service that allows testing and staging different versions of an app before swapping to production.  
- **Swap**: The process of exchanging the content and configuration of two deployment slots (e.g., staging and production) with zero downtime.  
- **Scale Up**: Increasing the size or capacity of the App Service instance (e.g., upgrading from B1 to S1).  
- **Scale Out**: Increasing the number of instances running the app to handle more traffic.

**Key Facts**  
- Deployment slots are not available on the Basic (B1) plan; must upgrade to Standard or Premium.  
- Example upgrade cost mentioned: Standard tier at about $80/month (temporarily used for demo).  
- Separate deployment workflows are created for each slot (e.g., staging.yaml for the staging slot).  
- Branches in GitHub can be used to deploy different versions to different slots (e.g., main branch for production, staging branch for staging).  
- Swapping deployment slots is zero downtime and can be done without preview if no configuration changes exist.  
- Traffic routing between slots can be split by percentage (e.g., 50% production, 50% staging).  
- Maximum instance limit mentioned for scaling is 10 instances.

**Examples**  
- Created a staging slot from production branch; initially showed default page because code was not deployed yet.  
- Created a separate GitHub branch called "staging" with different app content ("Hello Klingons") deployed to the staging slot.  
- Swapped staging slot with production slot, resulting in production showing "Hello Klingons" and staging showing previous production content.  
- Adjusted traffic routing to 50% between production and staging slots, verified by refreshing the app URL multiple times.  
- Edited app.py in different branches to demonstrate different app versions deployed to different slots.

**Key Takeaways 🎯**  
- Always upgrade to Standard or Premium tier to use deployment slots.  
- Deployment slots have independent deployment pipelines; code must be deployed separately to each slot.  
- Use separate Git branches to manage different slot deployments effectively.  
- Use the swap feature to promote tested staging versions to production with zero downtime.  
- Traffic splitting allows gradual rollout/testing by directing a percentage of users to staging.  
- Understand the difference between scaling (up/out) and deployment slots; both require Standard or higher plans.  
- Familiarize yourself with managing deployment workflows in GitHub Actions for each slot.  
- Remember that some UI elements (like traffic percentage sliders) may be grayed out if not at the correct management level or during certain views.

---

## Scaling App Service

**Timestamp**: 07:07:44 – 07:14:02

**Key Concepts**  
- Azure App Service scaling is divided into two types: **scale up** and **scale out**.  
- **Scale up** means increasing the size (SKU) of the instance (e.g., from B1 to S1).  
- **Scale out** means increasing the number of instances to handle more load.  
- Auto-scaling can be configured based on metrics such as CPU percentage.  
- Auto-scale rules include setting minimum and maximum instance counts, metric thresholds, duration, and cooldown periods.  
- Monitoring scaling events is done via the **run history** under the monitoring tab.  
- Scaling rules can be adjusted to be more or less aggressive depending on the workload.  
- Scale down actions happen automatically based on configured rules, but may require proper setup of scale out/in rules to function as expected.

**Definitions**  
- **Scale Up**: Increasing the size or capacity of a single instance (e.g., upgrading from a smaller SKU to a larger SKU).  
- **Scale Out**: Increasing the number of instances running the application to handle increased load.  
- **Auto Scale**: Automatic adjustment of the number of instances based on predefined metrics and thresholds.  
- **Cooldown Period**: Time to wait after a scale action before another scaling action can occur, to avoid rapid fluctuations.

**Key Facts**  
- Scaling up requires at least Standard tier or above (Standard, Premium, etc.).  
- Maximum number of instances allowed for scaling out is 10 by default.  
- Auto scale rules can be based on CPU percentage; example thresholds used were 10% for scaling out and 50% for scaling down.  
- Duration for triggering scale actions can be set (e.g., 1 minute for quick response, 5 minutes to avoid transient spikes).  
- Cooldown time is typically set to 5 minutes to prevent rapid scale changes.  
- Monitoring scaling events is done through the **run history** which shows instance counts over time.

**Examples**  
- Configured auto scale to add an instance when CPU usage exceeds 10% for 1 minute, with a max of 2 instances.  
- Adjusted scaling rule duration from 1 minute to 5 minutes to reduce aggressive scaling.  
- Attempted to trigger scale down by setting CPU threshold to 50% and duration to 1 minute.  
- Observed scaling events in run history showing instance count changes.

**Key Takeaways 🎯**  
- Understand the difference between scale up (vertical scaling) and scale out (horizontal scaling).  
- Know that auto scale requires Standard tier or higher.  
- Be able to configure auto scale rules based on metrics like CPU percentage, with appropriate thresholds and durations.  
- Remember to set cooldown periods to avoid rapid scaling fluctuations.  
- Use the monitoring run history to verify scaling events and troubleshoot scaling behavior.  
- Scaling down may require proper scale out/in rule configuration to work correctly.  
- Practical exam scenarios may test your ability to configure and interpret auto scale settings in Azure App Services.  

---

## App Services CheatSheet

**Timestamp**: 07:14:02 – 07:16:53

**Key Concepts**  
- Azure App Services is an HTTP-based platform-as-a-service (PaaS) for hosting web apps, REST APIs, and mobile backends.  
- Supports multiple programming languages and can run on Windows or Linux environments.  
- Provides easy integration with Azure DevOps, GitHub, Docker Hub, and package management.  
- Supports deployment slots for staging environments and blue-green deployments.  
- App Service Environment (ASE) offers fully isolated, dedicated environments for high-scale and secure app hosting.  
- WebJobs allow running background scripts or programs within the same instance as the web app without extra cost.

**Definitions**  
- **Azure App Services**: A PaaS offering by Azure for hosting web applications, REST APIs, and mobile backends with support for multiple languages and environments.  
- **App Service Plan**: Pricing and resource tier model for Azure App Services (Standard, Dedicated, Isolated).  
- **Deployment Slots**: Separate deployment environments within an App Service that can be swapped for zero-downtime deployments (e.g., blue-green deployment).  
- **App Service Environment (ASE)**: A fully isolated and dedicated environment for securely running Azure App Services at high scale, supporting horizontal scaling and high request workloads.  
- **WebJobs**: A feature of Azure App Services that runs background scripts or programs on the same instance as the web app, with no additional cost.

**Key Facts**  
- Azure App Services supports runtimes: .NET, .NET Core, Java, Ruby, Node.js, PHP, Python.  
- App Service Plans have tiers: Standard, Dedicated, and Isolated. The Isolated tier does NOT support Linux.  
- Azure App Services can run Docker containers (single or multi-container) and supports custom containers via Azure Container Registry.  
- ASE can be deployed with two types: External ASE and ILB (Internal Load Balancer) ASE.  
- ASE supports zone pinning for deployment into availability zones.  
- Apps running on ASE can have access controlled by upstream devices like Web Application Firewall (WAF).  
- WebJobs incur no additional cost beyond the App Service plan.

**Examples**  
- Using deployment slots to perform blue-green deployments by swapping environments.  
- Deploying custom Docker containers by uploading to Azure Container Registry and deploying to App Services.  
- ASE used for high-scale, secure, isolated app hosting with multiple ASEs possible in one or multiple Azure regions.

**Key Takeaways 🎯**  
- Remember Azure App Services is Azure’s PaaS equivalent to Heroku or AWS Elastic Beanstalk.  
- Know the supported runtimes and that the Isolated tier does not support Linux.  
- Deployment slots are critical for zero-downtime deployments and staging environments.  
- ASE provides isolation and security for apps requiring high scale and compliance, with options for external or internal load balancer deployment.  
- WebJobs are a cost-effective way to run background tasks alongside your web app.  
- Understand the integration capabilities with CI/CD tools like Azure DevOps and GitHub for streamlined deployments.

---
