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



*Last updated: 2026-01-16*
