# AutoML

**Channel:** freeCodeCamp.org
**Duration:** 11:16:25
**URL:** https://www.youtube.com/watch?v=10PbGbTUSAg

---

## Introduction to AutoML

**Timestamp**: 01:38:41 – 01:41:15

**Key Concepts**  
- Azure Automated Machine Learning (AutoML) automates the process of creating ML models.  
- AutoML workflow: supply a dataset → choose a task type → AutoML trains and tunes the model automatically.  
- Main task types supported by AutoML:  
  - Classification (binary and multi-class)  
  - Regression  
  - Time series forecasting  
- Classification and regression are types of supervised learning.  
- Time series forecasting is treated as a multivariate regression problem with additional contextual variables.  
- AutoML includes built-in data guardrails to ensure high-quality input data during automatic featurization.

**Definitions**  
- **AutoML**: A system that automates the training and tuning of machine learning models based on user-provided data and task type.  
- **Classification**: Supervised learning task where the model predicts discrete categories/classes for new data based on training data.  
- **Binary Classification**: Classification with two possible labels (e.g., true/false, 0/1).  
- **Multi-class Classification**: Classification with more than two possible labels (e.g., happy, sad, mad, rad).  
- **Regression**: Supervised learning task where the model predicts continuous numerical values.  
- **Time Series Forecasting**: Predicting future values based on past time-dependent data, treated as a multivariate regression problem incorporating multiple contextual variables.  
- **Data Guardrails**: Automated checks run by AutoML during featurization to ensure data quality, such as validation split handling, missing value imputation, and high cardinality feature detection.  
- **High Cardinality Feature**: A feature with many unique values/dimensions, which can make data processing difficult.

**Key Facts**  
- Deep learning can be enabled in classification tasks; recommended to use GPU compute instances for deep learning workloads.  
- Time series forecasting supports advanced configurations like holiday detection, deep learning neural networks, auto ARIMA, profit forecast TCN, grouping, rolling origin cross-validation, and configurable lags.  
- AutoML automatically handles missing feature values and detects high cardinality features to maintain data quality.  
- Validation split handling is applied automatically to improve model performance.

**Examples**  
- Binary classification example: label is either true/false or 0/1.  
- Multi-class classification example: labels like happy, sad, mad, rad (noting a spelling correction from "mad" to "mad" was mentioned).  
- Time series forecasting use cases: forecasting revenue, inventory, sales, or customer demand.

**Key Takeaways 🎯**  
- Understand the three main AutoML task types and their differences: classification, regression, and time series forecasting.  
- Remember that classification and regression are supervised learning tasks, with classification predicting categories and regression predicting continuous values.  
- Time series forecasting is a specialized regression problem that incorporates multiple contextual variables and advanced modeling techniques.  
- AutoML automates many data preparation steps, including validation splitting, missing value imputation, and detecting problematic features like high cardinality.  
- Enabling deep learning requires appropriate compute resources (GPU).  
- Be familiar with the concept of data guardrails as a quality control mechanism within AutoML.

---

## Data Guard Rails

**Timestamp**: 01:41:15 – 01:42:01

**Key Concepts**  
- Data Guard Rails are a sequence of automated checks run by AutoML during training when automatic featurization is enabled.  
- Their purpose is to ensure high-quality input data is used for model training.  
- These checks include validation split handling, missing feature value imputation, and high cardinality feature detection.

**Definitions**  
- **Data Guard Rails**: Automated validation steps within AutoML that verify the quality and suitability of input data before and during model training.  
- **High Cardinality Feature**: A feature with a very large number of unique values or dimensions, which can make data processing difficult or inefficient.

**Key Facts**  
- Validation split handling ensures input data is properly split for validation to improve model performance.  
- Missing feature value imputation detects and handles any missing values in training data; in the example, no missing values were found.  
- High cardinality feature detection analyzes inputs to identify features that may be too complex or dense; no high cardinality features were detected in the example.

**Examples**  
- None specifically mentioned beyond the checks themselves (e.g., no missing values found, no high cardinality features detected).

**Key Takeaways 🎯**  
- Remember that Data Guard Rails are integral to AutoML’s automatic featurization process and help maintain data quality.  
- Be familiar with the types of checks performed: validation splits, missing value imputation, and high cardinality detection.  
- Understanding what high cardinality means and why it matters is important for exam questions related to data preprocessing and feature engineering.  
- These guardrails help prevent common data issues that could degrade model performance or cause training failures.

---

## Automatic Featurization

**Timestamp**: 01:42:01 – 01:43:53

**Key Concepts**  
- Automatic featurization in AutoML involves applying various scaling, normalization, and dimensionality reduction techniques automatically during model training.  
- Dimension reduction helps manage complex data with many features or categories by reducing the number of dimensions to avoid overwhelming the model.  
- Different scalers and transformers are used depending on the data characteristics, including standard scaling, min/max scaling, max absolute scaling, robust scaling, PCA, truncated SVD, and sparse normalization.

**Definitions**  
- **StandardScaler**: Standardizes features by removing the mean and scaling to unit variance.  
- **MinMaxScaler**: Scales features by transforming each feature to a given range based on the column’s minimum and maximum values.  
- **MaxAbsScaler**: Scales each feature by its maximum absolute value.  
- **RobustScaler**: Scales features using statistics that are robust to outliers, based on quantile ranges.  
- **PCA (Principal Component Analysis)**: A linear dimensionality reduction technique using singular value decomposition to project data into a lower-dimensional space.  
- **Truncated SVD (Singular Value Decomposition)**: Performs linear dimensionality reduction without centering data, allowing efficient processing of sparse matrices.  
- **Sparse Normalization**: Normalizes each sample (row) independently, using norms like L1 or L2.

**Key Facts**  
- PCA is useful when data has many labels or categories (e.g., 20, 30, 40 labels) to reduce complexity.  
- Truncated SVD differs from PCA by not centering the data before decomposition, making it suitable for sparse data.  
- AutoML automates all these preprocessing steps, saving users from manual feature scaling and dimensionality reduction.  
- Although detailed knowledge of each scaler or transformer might not be tested, understanding that AutoML handles these processes is important.

**Examples**  
- None specifically mentioned beyond general references to data with many labels/categories requiring dimension reduction.

**Key Takeaways 🎯**  
- Remember that Azure AutoML automatically applies appropriate feature scaling and dimensionality reduction techniques during training.  
- Know the purpose of common scalers (StandardScaler, MinMaxScaler, MaxAbsScaler, RobustScaler) and dimension reduction methods (PCA, Truncated SVD).  
- Understand that dimension reduction is critical when dealing with datasets having many categories or features to prevent model overwhelm.  
- Exam questions may not focus on the detailed mechanics of each scaler but expect awareness of AutoML’s automatic preprocessing capabilities.

---

## Model Selection

**Timestamp**: 01:43:53 – 01:44:57

**Key Concepts**  
- Model Selection is the process of choosing the best statistical model from a set of candidate models.  
- Azure AutoML automates model selection by testing many different machine learning algorithms and recommending the best performing model(s).  
- Ensemble models, such as Voting Ensemble, combine multiple weaker models to create a stronger predictive model.  
- Model explainability (Machine Learning Explainability - MXL) helps interpret and understand model behavior and performance.

**Definitions**  
- **Model Selection**: The task of selecting a statistical model from a set of candidate models based on performance.  
- **Voting Ensemble**: An ensemble algorithm that combines two or more weak ML models to form a stronger model.  
- **Machine Learning Explainability (MXL)**: The process of explaining and interpreting machine learning or deep learning models to better understand their behavior and decisions.

**Key Facts**  
- Azure AutoML can evaluate a large number of models (example given: 53 models across 3 pages).  
- The primary metric shown in Azure AutoML results indicates model performance; the highest value usually points to the best model to use.  
- After selecting the top candidate model, Azure AutoML provides explanations such as aggregate and individual feature importance, model performance, and dataset exploration.

**Examples**  
- The top candidate model chosen by Azure AutoML in the example was a Voting Ensemble model.

**Key Takeaways 🎯**  
- On the exam, understand that Model Selection involves choosing the best model from many candidates based on performance metrics.  
- Azure AutoML simplifies this by automating model testing and selection.  
- Ensemble models like Voting Ensemble are important to know as they combine weaker models to improve accuracy.  
- Use the primary metric to identify the best model.  
- Machine Learning Explainability (MXL) is crucial for interpreting model results and understanding feature importance.  
- If unsure, go with the top recommended model from AutoML rather than manually tweaking models unless you have expertise.

---

## Explanation

**Timestamp**: 01:44:57 – 01:45:51

**Key Concepts**  
- Explainability (also called Machine Learning Explainability or MLX) is the process of interpreting and understanding ML or deep learning models.  
- MLX helps developers understand model behavior and the factors influencing model outcomes.  
- After selecting a top candidate model (e.g., via Azure AutoML), explanations can be generated to explore model internals such as feature importance and model performance.  
- Aggregate feature importance shows which features most influence the model’s predictions.

**Definitions**  
- **Explainability (MLX)**: The process of explaining and interpreting machine learning or deep learning models to better understand their behavior and decision-making.  
- **Aggregate Feature Importance**: A summary measure indicating which features have the greatest overall impact on the model’s predictions.

**Key Facts**  
- Explainability is available after selecting the top candidate model in Azure AutoML.  
- Explanation tools can show dataset exploration, model performance, aggregate and individual feature importance.  
- Example dataset referenced: Diabetes dataset, where BMI is a highly influential feature.  
- The primary metric is the parameter used during model training to optimize and select the best model.

**Examples**  
- Diabetes dataset: BMI identified as a major factor influencing the model outcome.

**Key Takeaways 🎯**  
- Understand that explainability (MLX) is crucial for interpreting why a model makes certain predictions.  
- Use explanation features in Azure AutoML to validate and trust your model by reviewing feature importance and model internals.  
- Remember that the primary metric guides model optimization and selection.  
- Practical exam scenarios may involve interpreting feature importance or explaining model behavior using MLX tools.

---

## Primary Metrics

**Timestamp**: 01:45:51 – 01:47:43

**Key Concepts**  
- Primary metric is the parameter used during model training to optimize model performance.  
- Different primary metrics are suited for different ML task types: classification, regression, and time series.  
- Primary metric can be auto-detected by Azure AutoML or manually overridden.  
- Choice of primary metric depends on dataset characteristics such as size and balance.  

**Definitions**  
- **Primary Metric**: The metric selected to guide model training optimization, influencing how the model evaluates performance during training.  
- **Well-balanced dataset**: A dataset where class labels are evenly distributed (e.g., 100 samples of class A and 100 of class B).  
- **Imbalanced dataset**: A dataset where one class label significantly outnumbers another (e.g., 10 samples of class A and 500 of class B).  

**Key Facts**  
- For classification tasks with well-balanced datasets, metrics like Accuracy, Average Precision Score Weighted, and Norm Macro Recall are suitable.  
- For classification tasks with imbalanced datasets, metrics like AUC Weighted are preferred.  
- Regression metrics vary by range of target values:  
  - Wide range: Spearman correlation, R2 score (used in airline delay, salary estimation, bug resolution).  
  - Smaller range: Normalized Root Mean Square Error (RMSE), Normalized Mean Absolute Error (MAE) (used in price predictions, review tip score predictions).  
- Time series forecasting uses similar metrics adapted to the time series context.  

**Examples**  
- Classification with well-balanced data: Image classification, sentiment analysis, churn prediction.  
- Classification with imbalanced data: Fraud detection, anomaly detection, spam detection.  
- Regression with wide range targets: Airline delay prediction, salary estimation.  
- Regression with smaller range targets: Price prediction, review tip score prediction.  

**Key Takeaways 🎯**  
- Understand the importance of selecting the correct primary metric based on task type and dataset balance.  
- Know that Azure AutoML can auto-detect the primary metric but manual override is possible and sometimes necessary.  
- Recognize common primary metrics used for classification (accuracy, AUC), regression (R2, RMSE), and time series forecasting.  
- Be able to identify when to use metrics suited for balanced vs. imbalanced datasets.  
- Remember practical examples linked to metric choices to help contextualize exam questions.

---

## Validation Type

**Timestamp**: 01:47:43 – 01:48:14

**Key Concepts**  
- Model validation compares training dataset results to test dataset results.  
- Validation occurs after the model has been trained.  
- Different validation types can be selected when setting up an ML model.

**Definitions**  
- **Model Validation**: The process of evaluating a trained model by comparing its performance on training data versus test data to assess generalization.  
- **Validation Types**: Methods used to split and evaluate data during model validation, including options like auto, K-fold cross-validation, Monte Carlo cross-validation, and train-validation split.

**Key Facts**  
- Common validation options include:  
  - Auto  
  - K-fold cross-validation  
  - Monte Carlo cross-validation  
  - Train-validation split  
- The speaker notes that detailed understanding of these validation types is likely not required for the AI-900 exam, but awareness of their existence is important.

**Examples**  
- None mentioned specifically for validation types.

**Key Takeaways 🎯**  
- Understand that model validation is a post-training evaluation step comparing training and test results.  
- Be aware of common validation methods (K-fold, Monte Carlo, train-validation split), even if deep details are not required.  
- For AI-900 exam, focus on the concept of validation rather than the intricate mechanics of each validation type.
