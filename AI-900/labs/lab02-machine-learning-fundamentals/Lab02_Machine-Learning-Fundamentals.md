# Lab 02: Machine Learning Fundamentals

**Duration:** 60–90 minutes  
**Difficulty:** Beginner to Intermediate

---

## 🎯 Objectives

By the end of this lab, you will be able to:

- Identify regression, classification, and clustering scenarios
- Understand core machine learning concepts (features, labels, training, validation)
- Use Azure Machine Learning automated ML to train and deploy a model
- Understand deep learning and Transformer architecture concepts

---

## 📋 Prerequisites

- Azure subscription with access to create Azure Machine Learning workspaces
- Completion of Lab 01 (recommended)
- Basic understanding of data and statistics (helpful but not required)

---

## 🧪 Lab Exercises

### Exercise 1: Understand Machine Learning Techniques

**Objective:** Learn to identify different types of machine learning problems.

**1. Regression (Predict a Numeric Value)**

- **Goal:** Predict a continuous numeric value
- **Examples:**
  - Predict house prices based on size, location, bedrooms
  - Forecast sales revenue based on marketing spend
  - Estimate patient recovery time based on treatment and demographics
- **Output:** A number (e.g., $250,000, 15 days, 42.5 units)

**2. Classification (Predict a Category)**

- **Goal:** Predict which category or class something belongs to
- **Examples:**
  - Is this email spam or not spam? (binary classification)
  - Which animal is in this image: cat, dog, or bird? (multi-class classification)
  - Will a customer churn? (yes/no)
- **Output:** A category or label (e.g., "spam", "cat", "yes")

**3. Clustering (Group Similar Items)**

- **Goal:** Find groups of similar items without predefined labels (unsupervised learning)
- **Examples:**
  - Customer segmentation based on purchase behavior
  - Group similar articles or documents
  - Anomaly detection (items that don't fit any cluster)
- **Output:** Cluster assignments (e.g., Cluster 1, Cluster 2, Cluster 3)

**Activity:**

For each scenario below, identify if it's regression, classification, or clustering:

1. Predict tomorrow's temperature
2. Group customers by purchasing patterns
3. Determine if a transaction is fraudulent
4. Estimate delivery time for a package
5. Segment website visitors into personas

---

### Exercise 2: Core Machine Learning Concepts

**Objective:** Understand the fundamental concepts used in machine learning.

**Key Concepts:**

- **Features:** Input variables (columns) used to make predictions (e.g., square footage, bedrooms, location)
- **Labels:** The target variable you want to predict (e.g., house price) — only in supervised learning
- **Training dataset:** Data used to teach the model (typically 70-80% of total data)
- **Validation dataset:** Data used to tune and evaluate the model during training (10-15%)
- **Test dataset:** Held-out data used for final performance evaluation (10-15%)
- **Model:** The mathematical representation learned from data
- **Inference:** Using the trained model to make predictions on new data

**Activity:**

Given a dataset of house sales with columns: `SquareFeet`, `Bedrooms`, `Bathrooms`, `Location`, `YearBuilt`, `SalePrice`:

1. Which columns are features?
2. Which column is the label?
3. Is this a regression or classification problem?
4. How would you split the data for training, validation, and testing?

---

### Exercise 3: Use Azure Machine Learning Automated ML

**Objective:** Train a machine learning model using Azure ML's no-code automated ML capability.

**Steps:**

1. **Create an Azure Machine Learning Workspace:**
   - Navigate to Azure Portal
   - Create a new resource: "Machine Learning"
   - Fill in resource group, workspace name, region
   - Create the workspace (takes a few minutes)

2. **Launch Azure ML Studio:**
   - Once created, click "Launch studio"
   - This opens the Azure ML Studio web interface

3. **Create a Dataset:**
   - Navigate to "Data" → "Create"
   - Upload a sample dataset (e.g., diabetes regression dataset, Titanic classification dataset)
   - Or use a built-in sample dataset

4. **Run Automated ML:**
   - Navigate to "Automated ML" → "New Automated ML job"
   - Select your dataset
   - Choose task type: Regression, Classification, or Time Series Forecasting
   - Select target column (label)
   - Configure settings:
     - Primary metric (e.g., accuracy for classification, R² for regression)
     - Training time limit (shorter for labs, e.g., 15 minutes)
   - Submit the job

5. **Review Results:**
   - Once complete, review the best model
   - Examine metrics (accuracy, precision, recall, F1 score, etc.)
   - Review feature importance

6. **Deploy the Model (Optional):**
   - Deploy the best model as a web service endpoint
   - Test the endpoint with sample data

**Deliverables:**

- Screenshot of best model and metrics
- Description of which algorithm performed best
- Explanation of top 3 most important features

---

### Exercise 4: Understand Deep Learning and Transformers

**Objective:** Learn about advanced machine learning techniques.

**Deep Learning:**

- Uses neural networks with multiple layers (hence "deep")
- Excels at image, speech, and text processing
- **Convolutional Neural Networks (CNNs):** Specialized for images
- **Recurrent Neural Networks (RNNs):** Specialized for sequences (text, time series)
- Requires large amounts of data and computational power

**Transformer Architecture:**

- Modern architecture that revolutionized NLP
- Uses "attention mechanisms" to understand context
- Foundation for models like BERT, GPT, T5
- Powers Azure OpenAI Service models

**Activity:**

1. Research one real-world application of CNNs
2. Research one real-world application of Transformers
3. Explain why Transformers are well-suited for language understanding

---

## 🧠 Knowledge Check

1. What is the difference between regression and classification?
2. Is clustering supervised or unsupervised learning?
3. What is the purpose of a validation dataset?
4. What does AutoML do?
5. Name two types of deep learning architectures.
6. What is the Transformer architecture used for?

---

## 📚 Additional Resources

- [Azure Machine Learning Documentation](https://learn.microsoft.com/en-us/azure/machine-learning/)
- [Automated ML Overview](https://learn.microsoft.com/en-us/azure/machine-learning/concept-automated-ml)
- [Deep Learning Fundamentals](https://learn.microsoft.com/en-us/training/modules/intro-to-deep-learning/)

---

## ✅ Lab Completion

You have successfully completed Lab 02. You should now understand:

- The difference between regression, classification, and clustering
- Core ML concepts: features, labels, training/validation/test datasets
- How to use Azure ML Automated ML
- Deep learning and Transformer architecture basics

**Next Steps:** Proceed to [Lab 03: Computer Vision on Azure](../lab03-computer-vision/)

---

**Last updated:** 2025-10-16
