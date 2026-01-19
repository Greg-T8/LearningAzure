# Module 4: Get started with machine learning in Azure

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/design-machine-learning-model-training-solution/)

---

## Introduction

[Module Reference](https://learn.microsoft.com/training/modules/get-started-with-machine-learning-in-azure/)

**Purpose of the Module**

* **Machine learning solutions** underpin modern AI applications such as predictive analytics and personalized recommendations.
* These solutions use **existing data to generate new insights**.
* **Design decisions by data scientists** directly impact:

  * **Cost**
  * **Speed**
  * **Quality**
  * **Longevity** of the solution.

**Enterprise Machine Learning in Azure**

* The module focuses on designing an **end-to-end machine learning solution** using **Microsoft Azure**.
* Emphasis is on **planning, training, deployment, and monitoring** in an enterprise context.

**Six-Step Machine Learning Framework**

1. **Define the problem**

   * Decide **what the model should predict**
   * Define **what success looks like**
2. **Get the data**

   * Identify **data sources**
   * Obtain **access to data**
3. **Prepare the data**

   * **Explore** the data
   * **Clean and transform** data based on model requirements
4. **Train the model**

   * Choose an **algorithm**
   * Select **hyperparameter values** through **trial and error**
5. **Integrate the model**

   * **Deploy the model** to an endpoint
   * Use it to **generate predictions**
6. **Monitor the model**

   * **Track model performance** over time

**Process Characteristics**

* The machine learning process is **iterative and continuous**.
* Monitoring results may lead to **retraining the model**.

**Next Unit**

* **Define the problem**

**Key Facts to Remember**

* Machine learning design choices affect **cost, speed, quality, and longevity**.
* The Azure machine learning lifecycle is framed as **six steps**.
* **Monitoring can trigger retraining**, making the process continuous.

---

## Define the problem

[Module Reference](https://learn.microsoft.com/training/modules/get-started-with-machine-learning-in-azure/)

**Purpose of defining the problem**

* Clarify **what the model’s output should be**
* Determine **what type of machine learning task** is required
* Define **criteria that make the model successful**

**Machine learning task selection**

* The **type of task** depends on:

  * The **data available**
  * The **expected output**
* The chosen task determines:

  * Which **algorithms** can be used
  * Which **evaluation metrics** are appropriate

**Common machine learning tasks**

* **Classification** – Predict a **categorical value**
* **Regression** – Predict a **numerical value**
* **Time-series forecasting** – Predict **future numerical values** based on time-series data
* **Computer vision** – **Classify images** or **detect objects** in images
* **Natural language processing (NLP)** – **Extract insights from text**

**Model training and evaluation**

* Models are trained using **algorithms** appropriate to the selected task
* Models are evaluated using **performance metrics** (for example, **accuracy** or **precision**)
* Available metrics depend on the **machine learning task**
* Metrics help determine whether the model is **successful**

**Example: Diabetes prediction**

* Goal: Determine whether a patient **has diabetes or does not**
* Output type: **Categorical**
* Selected task: **Classification**
* Input data: Other **health-related data points** from patients

**End-to-end model training process**

1. **Load data** – Import and inspect the dataset
2. **Preprocess data** – Normalize and clean data for consistency
3. **Split data** – Separate data into **training** and **test** sets
4. **Choose model** – Select and configure an algorithm
5. **Train model** – Learn patterns from training data
6. **Score model** – Generate predictions on test data
7. **Evaluate** – Calculate performance metrics

<img src='.img/2026-01-19-04-29-07.png' width=700>

**Iterative nature of training**

* Training a model is an **iterative process**
* Steps are often repeated to achieve the **best-performing model**

**Key Facts to Remember**

* The **problem definition** drives task selection, algorithms, and metrics
* **Task type** determines valid outputs and evaluation methods
* **Classification** is used for categorical outcomes; **regression** for numerical outcomes
* Model training typically follows **seven structured steps**
* Iteration is expected to improve model performance

---

## Get and prepare data

[Module Reference](https://learn.microsoft.com/training/modules/get-started-machine-learning-azure/)

**Overview**

* **Data is the foundation of machine learning**

  * Both **data quantity** and **data quality** directly affect model accuracy.
* Before training a model, you must:

  * **Identify data source and format**
  * **Choose how to serve data**
  * **Design a data ingestion solution**

**Identify data source and format**

* **Data source**

  * Examples include:

    * **Customer Relationship Management (CRM) systems**
    * **Transactional databases** (for example, SQL databases)
    * **Internet of Things (IoT) devices**
* **Data format**

  * **Structured (tabular) data**
  * **Semi-structured data**
  * **Unstructured data**
* You must decide:

  * What data is required to train the model
  * The format in which the data should be served to the model

**Design a data ingestion solution**

* Best practice is to:

  * **Extract data from its source**
  * **Transform the data**
  * **Load it into a serving layer**
* This process is known as:

  * **ETL** (Extract, Transform, Load)
  * **ELT** (Extract, Load, Transform)
* The **serving layer** makes data available for:

  * Training machine learning models
  * Making predictions
* Data ingestion pipelines:

  * Are a **sequence of tasks** that move and transform data
  * Can be **manually triggered** or **scheduled**
  * Can be built using:

    * Azure Synapse Analytics
    * Azure Databricks
    * Azure Machine Learning

**Common data ingestion approach**

1. **Extract** raw data from the source (for example, CRM system or IoT device)
2. **Copy and transform** data using Azure Synapse Analytics
3. **Store** prepared data in Azure Blob Storage
4. **Train** the model using Azure Machine Learning

**Example: Weather forecasting scenario**

* Goal:

  * One table containing **temperature measurements per minute**
  * Aggregated data showing **average temperature per hour**
* Source data:

  * **Semi-structured JSON data** from IoT temperature sensors
* Transformation steps:

  1. Extract temperature measurements as **JSON objects**
  2. Convert JSON objects into a **tabular format**
  3. Transform data to calculate **temperature per machine per minute**

<img src='.img/2026-01-19-04-31-31.png' width=700>

**Key Facts to Remember**

* **Data quality and quantity** both impact model accuracy
* Machine learning data preparation requires:

  * Identifying **source**
  * Understanding **format**
  * Designing an **ingestion pipeline**
* **ETL/ELT pipelines** are standard for preparing data
* **Serving layers** make prepared data available for model training
* Semi-structured data (like JSON) often must be **converted to tabular data** before training

---

## Train the model

[Module Reference](https://learn.microsoft.com/training/modules/get-started-machine-learning-azure/)

**Factors that influence which training service to use**

* **Type of model** required
* **Level of control** needed over model training
* **Time investment** available for training
* **Existing services** already used in the organization
* **Programming language** familiarity

**Azure services for training machine learning models**

* **Azure Machine Learning**

  * Multiple training and management options
  * UI-based experience with Studio
  * Code-first experience using **Python SDK** or **CLI**
* **Azure Databricks**

  * Data analytics platform for data engineering and data science
  * Uses **distributed Apache Spark** compute
  * Can train models directly or integrate with Azure Machine Learning
* **Microsoft Fabric**

  * Integrated analytics platform for analysts, engineers, and data scientists
  * Supports:

    * Data preparation
    * Model training
    * Generating predictions
    * Visualization in **Power BI**
* **Foundry Tools**

  * Collection of **prebuilt machine learning models**
  * Exposed through **APIs**
  * Supports common tasks (for example, object detection)
  * Some models allow **customization with your own training data**

**Azure Machine Learning overview**

* Cloud service for **training, deploying, and managing** machine learning models
* Designed for:

  * Data scientists
  * Software engineers
  * DevOps professionals
  * Other ML practitioners
* Supports **end-to-end machine learning lifecycle management**

**Tasks supported by Azure Machine Learning**

* Exploring and preparing data for modeling
* Training and evaluating machine learning models
* Registering and managing trained models
* Deploying models for application and service consumption
* Reviewing and applying **responsible AI principles**

**Key features and capabilities of Azure Machine Learning**

* Centralized storage and management of **datasets**
* **On-demand compute resources** for training jobs
* **Automated Machine Learning (AutoML)**

  * Runs multiple training jobs
  * Uses different algorithms and parameters
  * Identifies the best-performing model
* **Visual pipeline tools**

  * Define orchestrated workflows for training and inferencing
* Integration with common ML frameworks (for example, **MLflow**)
* Built-in tools for **responsible AI evaluation**

  * Model explainability
  * Fairness assessment
  * Other responsible AI metrics

**Key Facts to Remember**

* Azure provides **multiple services** for training ML models, each optimized for different needs.
* **Azure Machine Learning** is the primary service for full lifecycle ML management.
* **AutoML** simplifies model selection by testing multiple algorithms automatically.
* Responsible AI evaluation is **built into Azure Machine Learning**.

---

## Use Azure Machine Learning studio

[Module Reference](https://learn.microsoft.com/training/modules/get-started-machine-learning-azure/)

**Azure Machine Learning studio overview**

* **Azure Machine Learning studio** is a **browser-based portal** for managing machine learning resources and jobs.
* Capabilities available in the studio include:

  * Importing and exploring data
  * Creating and using compute resources
  * Running code in notebooks
  * Using visual tools to create jobs and pipelines
  * Using **automated machine learning (AutoML)** to train models
  * Viewing trained model details, including:

    * Evaluation metrics
    * Responsible AI information
    * Training parameters
  * Deploying trained models for:

    * On-request inferencing
    * Batch inferencing
  * Importing and managing models from a model catalog

<img src='.img/2026-01-19-04-35-33.png' width=700> 

**Provisioning Azure Machine Learning resources**

* The **primary required resource** is an **Azure Machine Learning workspace**.
* The workspace is provisioned in an **Azure subscription**.
* Supporting resources are **created automatically as needed**, including:

  * Storage accounts
  * Container registries
  * Virtual machines
* The workspace can be created in the **Azure portal**.

**Decide between compute options**

* **Compute** refers to the computational resources used to train a model.
* For every training run, you should:

  * Monitor training duration
  * Monitor compute utilization
* Monitoring compute usage helps determine whether to **scale up or down**.
* Using Azure compute provides **scalable and cost-effective** alternatives to local training.

**Compute options and considerations**

* **CPU vs GPU**

  * CPU:

    * Sufficient and cost-effective for **smaller tabular datasets**
  * GPU:

    * More powerful and efficient for **unstructured data** (images or text)
    * Can be used for **larger tabular datasets** if CPU is insufficient
* **General purpose vs memory optimized**

  * General purpose:

    * Balanced CPU-to-memory ratio
    * Ideal for testing and development with smaller datasets
  * Memory optimized:

    * High memory-to-CPU ratio
    * Suitable for **in-memory analytics**
    * Ideal for larger datasets or notebook-based workloads
* Selecting compute is often **trial and error**.
* If training takes too long:

  * Switch from CPU to GPU
  * Or distribute training using **Spark compute** (requires rewriting training scripts)

**Azure Automated Machine Learning**

* **Automated machine learning (AutoML)** automatically assigns compute.
* AutoML automates **iterative and time-consuming tasks** of model development.
* In Azure Machine Learning studio, AutoML:

  * Uses a **step-by-step wizard**
  * Does **not require writing code**
* Supported machine learning tasks include:

  * Regression
  * Time-series forecasting
  * Classification
  * Computer vision
  * Natural language processing
* AutoML provides access to:

  * Your own datasets
* Trained models can be **deployed as services**.

**Key Facts to Remember**

* **Azure Machine Learning workspace** is the core required resource.
* Supporting resources are **automatically created**.
* **Compute selection** impacts cost and training performance.
* **CPUs** are best for small tabular data; **GPUs** for unstructured or large workloads.
* **General purpose** compute is balanced; **memory optimized** is best for in-memory analytics.
* **AutoML** assigns compute automatically and supports multiple ML task types.
* AutoML training can be completed **without writing code**.

---

## Integrate a model

[Module Reference](https://learn.microsoft.com/training/modules/get-started-machine-learning-azure/)

**Deploy a model to an endpoint**

* To integrate a model into an application, deploy it to an **endpoint**
* An endpoint is a **web address** an application calls to receive predictions
* Two deployment options:

  * **Real-time predictions**
  * **Batch predictions**

**Real-time predictions**

* Used when predictions are needed **immediately** as new data arrives
* Common for **websites and mobile applications**
* Predictions must be returned within the time it takes the app or page to load
* Example use case:

  * Customer selects a product on a website
  * Model instantly recommends related products
  * Recommendations are displayed alongside the selected product

**Batch predictions**

* Used when scoring data **in groups over time**
* Results are saved to a **file or database**
* Suitable when predictions are consumed periodically, not instantly
* Example use case:

  * Weekly sales forecasting (e.g., orange juice demand)
  * Historical and forecasted data combined in reports
* A **batch** is a collection of data points processed together

**Decide between real-time or batch deployment**

* Consider:

  * **How often** predictions should be generated
  * **How soon** results are needed
  * Whether predictions are **individual or batch-based**
  * **Compute requirements and cost**

**Identify the necessary frequency of scoring**

* New data can be collected:

  * Continuously (e.g., IoT data every minute)
  * Transactionally (e.g., each customer purchase)
  * Periodically (e.g., quarterly financial data)
* Two main scenarios:

  * Score data **as soon as it arrives**
  * Score data **on a schedule or trigger**
* Choice depends on **when predictions are needed**, not how often data is collected

**Decide on the number of predictions**

* **Individual predictions**

  * Model receives a single data record
  * Returns one prediction
* **Batch predictions**

  * Model receives multiple records at once
  * Returns predictions for all records
* Applies to tabular data and files (e.g., single image vs. batch of images)

**Consider the cost of compute**

* **Real-time endpoints**

  * Require compute that is **always available**
  * Use container-based compute
  * Compute is **always on**, resulting in continuous cost
* **Batch endpoints**

  * Use compute clusters for **parallel processing**
  * Compute is **provisioned on demand**
  * Scales down to **0 nodes when idle**, reducing cost

**Key Facts to Remember**

* **Endpoints** are required to integrate models into applications
* **Real-time predictions** are for immediate results
* **Batch predictions** are for scheduled or periodic scoring
* Deployment choice depends on **latency needs, volume, and cost**
* **Real-time compute runs continuously**
* **Batch compute scales down when not in use**

---



*Last updated: 2026-01-16*
