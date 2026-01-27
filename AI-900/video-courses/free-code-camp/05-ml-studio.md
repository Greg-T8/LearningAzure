# ML Studio

**Channel:** freeCodeCamp.org 
**Duration:** 4:23:51 
**URL:** https://www.youtube.com/watch?v=hHjmr_YOqnU 

---

## Azure Machine Learning Service

**Timestamp**: 01:26:45 – 01:28:10

**Key Concepts**  
- Azure Machine Learning Service is the modern, preferred service for running AI/ML workloads on Azure.  
- There is a classic version of the service, but it has severe limitations and is not transferable to the new service; it should be avoided for exam purposes.  
- Azure Machine Learning Studio refers to the new service’s interface for building and managing ML workflows.  
- Supports building flexible automated ML pipelines using Python or R.  
- Supports deep learning workloads, including TensorFlow.  
- Allows creation and use of Jupyter Notebooks for building and documenting ML models.  
- Azure Machine Learning SDK for Python enables interaction with the service and supports ML Ops (end-to-end automation of ML pipelines including CI/CD, training, and inference).  
- Azure Machine Learning Designer provides a drag-and-drop interface to visually build, test, and deploy ML models/pipelines.  
- Includes a data labeling service to assemble human teams for labeling training data.  
- Responsible machine learning features include model fairness metrics and mitigation of unfairness, though these features are still developing.  

**Definitions**  
- **Azure Machine Learning Service**: A cloud service that simplifies running AI and ML workloads, enabling automated ML pipelines, deep learning, and collaboration.  
- **Azure Machine Learning Studio**: The web-based interface for the new Azure Machine Learning Service used to create and manage ML experiments and pipelines.  
- **Azure Machine Learning SDK for Python**: A software development kit designed to interact programmatically with Azure Machine Learning Service, supporting ML Ops.  
- **Azure Machine Learning Designer**: A drag-and-drop visual tool to build, test, and deploy ML pipelines without extensive coding.  
- **Responsible Machine Learning**: Practices and tools aimed at ensuring model fairness and reducing bias through disparity metrics and mitigation techniques.  

**Key Facts**  
- The classic Azure Machine Learning Service is still accessible but has severe limitations and no migration path to the new service.  
- Automated ML pipelines can be built using Python or R.  
- Deep learning frameworks like TensorFlow are supported.  
- Jupyter Notebooks can be created and used within the service for model development and documentation.  
- ML Ops capabilities include automation of training, inference, and CI/CD pipelines.  
- The data labeling service allows human-in-the-loop labeling for training data.  
- Responsible AI features are integrated but still in early stages at the time of recording.  

**Examples**  
- None specifically mentioned in this section.  

**Key Takeaways 🎯**  
- Focus on the new Azure Machine Learning Service and avoid the classic version for exam relevance.  
- Understand the components: Studio (UI), SDK for Python (programmatic access), Designer (visual pipeline building), and data labeling service.  
- Know that the service supports automated ML pipelines, deep learning, and ML Ops for end-to-end model lifecycle management.  
- Be aware of responsible machine learning concepts as part of Microsoft’s AI ethics initiatives, even if still evolving.

---

## Studio Overview

**Timestamp**: 01:28:10 – 01:29:39

**Key Concepts**  
- Azure Machine Learning Studio provides a drag-and-drop interface to build, test, and deploy machine learning models and pipelines.  
- Studio integrates tools for responsible machine learning, including fairness metrics and mitigation of bias.  
- The Studio interface includes a left-hand navigation bar with multiple components for authoring, managing, and deploying ML workflows.  
- Authoring tools include notebooks (Jupyter), AutoML, and a visual designer for ML pipelines.  
- Data management includes datasets, data labeling (human + ML-assisted), and data stores.  
- Model management includes a model registry and deployment endpoints accessible via REST API or SDK.  
- Compute resources are categorized into compute instances, compute clusters, deployment targets, and attached compute resources.  

**Definitions**  
- **Notebooks**: Jupyter notebooks or IDEs used to write Python code for building ML models within the Studio.  
- **AutoML**: Automated machine learning process that builds and trains ML models with minimal user input; limited to three model types.  
- **Designer**: Visual drag-and-drop tool to create end-to-end ML pipelines.  
- **Datasets**: Uploaded data used for training and experiments.  
- **Pipelines**: ML workflows created or used in the designer.  
- **Model Registry**: Repository of trained models ready for deployment.  
- **Endpoints**: Hosted deployment of models accessible via REST API or SDK for inference.  
- **Compute Instances**: Development workstations for data scientists to work on data and models.  
- **Compute Clusters**: Scalable clusters of VMs for on-demand processing and experimentation.  
- **Attached Compute**: Links to existing Azure compute resources like VMs or Databricks clusters.  
- **Data Labeling**: Human-in-the-loop ML-assisted labeling service for supervised learning datasets.  

**Key Facts**  
- AutoML currently supports only three types of models.  
- Compute instances can be accessed directly within the Studio using Jupyter Labs, VS Code, RStudio, or Terminal.  
- Model endpoints enable access to deployed models via REST API or SDK.  
- Data labeling combines human effort with ML assistance to improve training data quality.  
- Studio integrates with external services such as Azure Synapse Analytics.  

**Examples**  
- Using notebooks to write Python code for ML model development.  
- Using the visual designer to drag-and-drop components to build ML pipelines.  
- Deploying models to endpoints for real-time inference.  
- Managing compute resources for development, training, and deployment within the Studio.  

**Key Takeaways 🎯**  
- Understand the main components of Azure ML Studio: authoring (notebooks, AutoML, designer), data management, model registry, endpoints, and compute resources.  
- Remember that AutoML is automated but limited in model types.  
- Know that compute instances and clusters support development and scalable processing, accessible directly in Studio.  
- Data labeling is a hybrid human + ML process critical for supervised learning.  
- Model deployment creates endpoints accessible via REST API or SDK for inference tasks.  
- Familiarize yourself with the Studio’s left-hand navigation bar structure as it organizes these components.

---

## Studio Compute

**Timestamp**: 01:29:39 – 01:30:48

**Key Concepts**  
- Types of compute available in Azure Machine Learning Studio  
- Compute instances as development workstations for data scientists  
- Compute clusters as scalable VM clusters for on-demand processing  
- Deployment targets for predictive services using trained models  
- Attaching existing Azure compute resources (e.g., Azure VMs, Azure Databricks clusters)  
- Integration with development environments like Jupyter Labs, VS Code, RStudio, and Terminal  

**Definitions**  
- **Compute Instances**: Development workstations in Azure ML Studio used by data scientists to work with data and models interactively.  
- **Compute Clusters**: Scalable clusters of virtual machines (VMs) used for running experiments and processing workloads on demand.  
- **Attach Compute**: Linking existing Azure compute resources (such as Azure VMs or Azure Databricks clusters) to the Azure ML workspace for use in experiments and deployments.  

**Key Facts**  
- Four main compute categories in Azure ML Studio:  
  1. Compute Instances  
  2. Compute Clusters  
  3. Deployment Targets (for predictive services)  
  4. Attached Compute (existing Azure resources)  
- Compute instances can be accessed directly within Azure ML Studio using Jupyter Labs, Jupyter Notebooks, VS Code, RStudio, or Terminal.  
- For inference (making predictions), Azure Kubernetes Service (AKS) or Azure Container Instances (ACI) are typically used, though their exact location in the studio interface was uncertain.  

**Examples**  
- Using compute instances as development workstations directly in Azure ML Studio with Jupyter or VS Code.  
- Attaching Azure Databricks clusters as compute resources for experimentation or deployment.  

**Key Takeaways 🎯**  
- Understand the four types of compute in Azure ML Studio and their purposes.  
- Remember that compute instances serve as interactive development environments for data scientists.  
- Compute clusters provide scalable resources for running experiments and training.  
- Deployment targets are used to host predictive services based on trained models.  
- Attached compute allows leveraging existing Azure compute resources within the ML workspace.  
- Familiarize yourself with the integration of compute instances with common IDEs and notebooks inside the studio.  
- Know that inference workloads typically use AKS or ACI, even if not explicitly shown in the compute list.

---

## Studio Data Labeling

**Timestamp**: 01:30:48 – 01:31:45

**Key Concepts**  
- Data labeling in Azure Machine Learning Studio is used to prepare ground truth for supervised learning.  
- Two main data labeling options:  
  - Human-in-the-loop labeling (manual human annotation)  
  - Machine learning assisted data labeling (automated labeling with ML assistance)  
- Labeled data can be exported anytime for machine learning experimentation.  
- Common export format for image labels is COCO format, which integrates well with Azure ML datasets.  
- Labeling tasks are performed via a UI where users click buttons to apply labels.

**Definitions**  
- **Human-in-the-loop labeling**: A process where human annotators manually label data to create ground truth.  
- **Machine learning assisted data labeling**: Using ML models to assist or automate the labeling process, speeding up annotation.  
- **COCO format**: A standardized dataset format for image labeling that is compatible with Azure ML training workflows.

**Key Facts**  
- Users often export labeled data multiple times to train different models without waiting for the entire dataset to be labeled.  
- COCO format is preferred for image label exports in Azure ML Studio.  

**Examples**  
- None specifically mentioned beyond the general use of UI buttons for labeling tasks.

**Key Takeaways 🎯**  
- Understand the two labeling approaches and when to use each (human vs ML-assisted).  
- Remember that labeled data can be exported repeatedly during model development.  
- Know that COCO format is the standard for image label exports in Azure ML Studio.  
- Familiarize yourself with the labeling UI concept for practical application.

---

## Data Stores

**Timestamp**: 01:31:45 – 01:32:34

**Key Concepts**  
- Azure ML Data Store securely connects Azure Machine Learning to various Azure storage services without exposing authentication credentials or risking data integrity.  
- Multiple types of data stores are available in Azure ML Studio to support different data storage needs.  
- Azure ML datasets facilitate easy registration, versioning, and integration of datasets for ML workloads.

**Definitions**  
- **Azure ML Data Store**: A secure connection interface in Azure Machine Learning that links to Azure storage services while protecting authentication credentials and data integrity.  
- **Azure Blob Storage**: Object storage distributed across many machines, suitable for unstructured data.  
- **Azure File Share**: A mountable file share accessible via SMB and NFS protocols.  
- **Azure Data Lake Storage Gen2**: Blob storage optimized for large-scale big data analytics.  
- **Azure SQL**: Fully managed relational SQL database service.  
- **Azure Postgres Database**: Open source relational database, often considered object-relational, favored by developers.  
- **Azure MySQL**: Popular open source relational database, considered a pure relational database.

**Key Facts**  
- Azure ML Data Store protects authentication credentials and maintains the integrity of the original data source.  
- Azure ML datasets support metadata association and dataset versioning (current and latest versions).  
- Sample code is available via the Azure ML SDK to import datasets into Jupyter Notebooks, facilitating quick startup.

**Examples**  
- Azure Blob Storage, Azure File Share, Azure Data Lake Storage Gen2, Azure SQL, Azure Postgres, and Azure MySQL are all examples of data stores accessible through Azure ML Data Store.

**Key Takeaways 🎯**  
- Remember that Azure ML Data Store acts as a secure gateway to Azure storage services without exposing credentials.  
- Know the different types of Azure data stores and their typical use cases (object storage, file shares, big data analytics, relational databases).  
- Azure ML datasets enable easy dataset registration, metadata management, and version control, which is critical for reproducible ML workflows.  
- Utilize provided sample code in Azure ML SDK to streamline dataset loading into notebooks for experimentation and training.

---

## Datasets

**Timestamp**: 01:32:34 – 01:33:44

**Key Concepts**  
- Azure ML datasets simplify registering and managing datasets for machine learning workloads.  
- Datasets can have metadata and support multiple versions (current and latest).  
- Sample code is available in the Azure ML SDK for easy integration into Jupyter Notebooks.  
- Dataset profiling generates summary statistics and data distributions, requiring a compute instance.  
- Open datasets are publicly hosted, curated datasets useful for learning and quick experimentation.  

**Definitions**  
- **Azure ML Dataset**: A registered dataset in Azure Machine Learning that includes metadata and versioning to facilitate ML workflows.  
- **Dataset Profile**: A generated summary report of a dataset’s statistics and distributions, stored typically in Blob Storage.  
- **Open Datasets**: Publicly available datasets curated by Azure, designed for learning and experimenting with ML models.  

**Key Facts**  
- Multiple versions of datasets can be maintained (e.g., current version vs. latest version).  
- Dataset profiles require a compute instance to generate.  
- Open datasets are integrated into Azure ML for easy addition to data stores.  
- Common open datasets mentioned include MNIST and COCO, widely used for ML learning.  

**Examples**  
- MNIST and COCO datasets are cited as common open datasets used for learning ML.  

**Key Takeaways 🎯**  
- Know how Azure ML datasets support versioning and metadata to manage data effectively.  
- Remember that dataset profiling is a useful feature for understanding data but requires compute resources.  
- Open datasets provide a quick way to start ML projects without needing to source your own data.  
- Familiarity with common datasets like MNIST and COCO can be beneficial for exam scenarios involving dataset examples.

---

## Experiments

**Timestamp**: 01:33:44 – 01:34:16

**Key Concepts**  
- Azure ML Experiments are logical groupings of runs.  
- A run represents executing an ML task on a virtual machine or container.  
- Runs can include various ML tasks such as scripts for preprocessing, AutoML, or training pipelines.  
- Inference (model predictions after deployment) is not tracked as part of experiments/runs.

**Definitions**  
- **Azure ML Experiment**: A container or logical grouping that organizes multiple runs of machine learning tasks.  
- **Run**: The execution instance of an ML task on compute resources like VMs or containers.

**Key Facts**  
- Experiments track runs related to training and preprocessing but exclude inference calls after deployment.  
- Runs can be of different types but are unified under the experiment for organization.

**Examples**  
- None mentioned specifically in this time range.

**Key Takeaways 🎯**  
- Remember that Azure ML Experiments group runs, which are executions of ML tasks.  
- Runs include preprocessing, AutoML, and training, but not inference requests after deployment.  
- Understanding the distinction between runs (training/preprocessing) and inference (post-deployment predictions) is important for exam scenarios.

---

## Pipelines

**Timestamp**: 01:34:16 – 01:35:23

**Key Concepts**  
- Azure ML Pipelines represent an executable workflow for a complete machine learning task.  
- Pipelines consist of a series of independent steps, allowing parallel work and efficient resource use.  
- Steps can be run on different compute types/sizes tailored to their needs.  
- When rerunning pipelines, only updated or changed steps are executed; unchanged steps are skipped.  
- Published pipelines can be triggered via REST endpoints from any platform or stack.  
- Pipelines can be built either visually using Azure ML Designer or programmatically via the Azure ML Python SDK.  

**Definitions**  
- **Azure ML Pipelines**: Executable workflows that encapsulate a complete machine learning task as a series of steps.  
- **Step**: An independent subtask within a pipeline that can be run separately and on different compute resources.  
- **Azure ML Designer**: A visual drag-and-drop interface to build ML pipelines without coding.  

**Key Facts**  
- Azure ML Pipelines are distinct from Azure DevOps Pipelines and Data Factory Pipelines.  
- Independent steps enable multiple data scientists to collaborate without overloading compute resources.  
- REST endpoints allow rerunning pipelines remotely after publishing.  
- Two main ways to build pipelines:  
  1. Azure ML Designer (no code, visual)  
  2. Azure ML Python SDK (programmatic)  

**Examples**  
- Code example mentioned (not detailed) showing creation of steps and assembling them into a pipeline using Python SDK.  
- Azure ML Designer interface shows a visual pipeline with drag-and-drop pre-built assets.  

**Key Takeaways 🎯**  
- Understand the difference between Azure ML Pipelines and other Azure pipeline services (Azure DevOps, Data Factory).  
- Remember that pipelines are modular workflows made of independent steps that optimize compute usage and collaboration.  
- Know that rerunning pipelines only executes changed steps, saving time and resources.  
- Be familiar with the two pipeline building approaches: visual (Designer) and code-based (Python SDK).  
- After publishing, pipelines can be triggered via REST endpoints, enabling integration with other platforms.  
- Azure ML Designer requires a solid understanding of ML pipelines to use effectively despite its no-code approach.

---

## ML Designer

**Timestamp**: 01:35:23 – 01:36:07

**Key Concepts**  
- Azure Machine Learning Designer enables building ML pipelines visually without coding.  
- The Designer provides a drag-and-drop interface with pre-built assets for pipeline creation.  
- It requires a good understanding of ML pipelines to use effectively.  
- After training, you can create inference pipelines and choose between real-time or batch inference, with the option to toggle later.

**Definitions**  
- **Azure ML Designer**: A visual tool in Azure Machine Learning for quickly building ML pipelines without writing code.  
- **Inference Pipeline**: A pipeline created after training that is used for deploying models for real-time or batch predictions.

**Key Facts**  
- The Designer interface shows a visual pipeline and a left-hand pane with pre-built assets to drag into the pipeline.  
- You can toggle inference pipeline modes between real-time and batch after creation.  
- For the AI-900 exam, deep technical details of Azure ML Designer are not required.

**Examples**  
- None mentioned specifically for ML Designer beyond the description of the drag-and-drop interface.

**Key Takeaways 🎯**  
- Know that Azure ML Designer is a no-code, visual pipeline builder in Azure ML.  
- Understand that it supports building both training and inference pipelines.  
- Remember the ability to toggle inference pipeline modes (real-time vs batch).  
- Focus on conceptual understanding rather than deep technical details for the AI-900 exam.

---

## Model Registry

**Timestamp**: 01:36:07 – 01:36:34

**Key Concepts**  
- Azure Machine Learning Model Registry is used to create, manage, and track registered models.  
- Models can be registered under the same name with incremental versioning.  
- Metadata tags can be added to models to facilitate searching.  
- The registry simplifies sharing, deploying, and downloading models.

**Definitions**  
- **Model Registry**: A service in Azure ML that allows version control and management of machine learning models by registering them with names and versions, along with metadata tagging.

**Key Facts**  
- Registering a model with an existing name automatically creates a new version.  
- Tags can be used to organize and search models efficiently.  

**Examples**  
- None mentioned specifically for Model Registry in this segment.

**Key Takeaways 🎯**  
- Understand that the Model Registry supports versioning by name, which is critical for managing model lifecycle.  
- Remember to use metadata tags for easier model discovery.  
- The Model Registry is essential for sharing and deploying models in Azure ML workflows.

---

## Endpoints

**Timestamp**: 01:36:34 – 01:37:50

**Key Concepts**  
- Azure ML endpoints enable deployment of machine learning models as web services.  
- Two main types of endpoints:  
  - Real-time endpoints for invoking ML models remotely.  
  - Pipeline endpoints for invoking ML pipelines remotely with parameterization for batch scoring and retraining.  
- Real-time endpoints run on Azure Kubernetes Service (AKS) or Azure Container Instance (ACI).  
- Pipeline endpoints support managed repeatability in batch and retraining scenarios.  
- Deployed endpoints appear under AKS or ACI in the Azure portal, not consolidated in Azure ML Studio.  
- Testing real-time endpoints can be done by sending single or batch requests (e.g., CSV format).  

**Definitions**  
- **Azure ML Endpoint**: A web service interface that allows remote access to deployed machine learning models or pipelines.  
- **Real-time Endpoint**: An endpoint providing immediate, remote access to invoke a machine learning model hosted on AKS or ACI.  
- **Pipeline Endpoint**: An endpoint that allows remote invocation of an ML pipeline, supporting parameterization for batch processing and retraining workflows.  
- **Azure Kubernetes Service (AKS)**: A managed container orchestration service used to host real-time ML endpoints.  
- **Azure Container Instance (ACI)**: A lightweight container hosting service used for deploying real-time ML endpoints.  

**Key Facts**  
- Workflow for deploying models includes: registering the model, preparing an entry script, preparing inference configuration, deploying locally, choosing compute target, deploying to cloud, and testing the web service.  
- Real-time endpoints can be tested with single or batch requests via a form interface in Azure.  
- Endpoints deployed to AKS or ACI are visible under those services in the Azure portal, not directly under Azure ML Studio.  

**Examples**  
- Testing a real-time endpoint by sending a single request or a batch request in CSV format through a built-in form.  

**Key Takeaways 🎯**  
- Understand the difference between real-time and pipeline endpoints and their use cases.  
- Remember that real-time endpoints run on AKS or ACI and are managed outside of Azure ML Studio in the Azure portal.  
- Know the deployment workflow steps for ML models before creating endpoints.  
- Be familiar with testing endpoints using single or batch requests to validate deployment.

---

## Notebooks

**Timestamp**: 01:37:50 – 01:38:41

**Key Concepts**  
- Azure provides a built-in Jupyter-like notebook editor within Azure Machine Learning Studio.  
- Compute instances are chosen to run notebooks in Azure ML.  
- Users select a kernel, which includes preloaded programming languages and libraries tailored for different use cases (Jupyter kernel concept).  
- Notebooks can be opened and edited in more familiar environments such as VS Code, Jupyter Notebook Classic, or Jupyter.  
- The VS Code experience is identical to the Azure ML Studio notebook editor.  

**Definitions**  
- **Kernel**: A preloaded programming language environment with libraries that supports running code in notebooks (Jupyter kernel concept).  

**Key Facts**  
- Azure ML Studio’s notebook editor is built-in but may not be preferred by all users.  
- Alternative notebook environments (VS Code, Jupyter Classic) can be used seamlessly with Azure ML notebooks.  

**Examples**  
- None specifically mentioned beyond the general use of notebooks and opening them in VS Code or Jupyter.  

**Key Takeaways 🎯**  
- Understand that Azure ML Studio includes a built-in Jupyter-like notebook editor but you are not limited to it.  
- Know how to select compute instances and kernels to run notebooks in Azure ML.  
- Be aware that you can open Azure ML notebooks in familiar IDEs like VS Code or Jupyter for a better user experience.  
- The VS Code notebook experience mirrors the Azure ML Studio notebook editor exactly.  
- For exams, focus on the flexibility of notebook environments and the kernel concept within Azure ML.
