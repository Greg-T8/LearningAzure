# Module 3: Introduction to machine learning concepts

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/fundamentals-machine-learning/)

---

## Machine learning models

[Module Reference](https://learn.microsoft.com/training/modules/intro-to-machine-learning-concepts/)

**Definition of a Machine Learning Model**

* A **machine learning model** is a **software application** that encapsulates a **function** used to calculate an output value from one or more input values.
* Defining this function is called **training**.
* Using the trained function to predict new values is called **inferencing**.

**Training and Inferencing Overview**

* **Training phase**

  * Uses historical data to define the function that maps inputs to outputs.
* **Inferencing phase**

  * Uses the trained model to predict outputs for new, unseen inputs.

**Training Data Components**

* **Observations** consist of:

  * **Features (x)**: observed attributes of the entity being analyzed.
  * **Label (y)**: the known value the model is trained to predict.
* An observation typically includes **multiple features**, so **x is a vector**:

  * Example format: `[x1, x2, x3, …]`

<img src='.img/2026-01-18-06-51-31.png' width=600>

**Features and Labels in Examples**

* **Ice cream sales scenario**

  * Features (x): weather measurements (temperature, rainfall, windspeed, etc.)
  * Label (y): number of ice creams sold
* **Medical scenario**

  * Features (x): patient measurements (weight, blood glucose level, etc.)
  * Label (y): diabetes risk indicator (for example, 1 = at risk, 0 = not at risk)
* **Antarctic penguin scenario**

  * Features (x): physical attributes (flipper length, bill width, etc.)
  * Label (y): penguin species (for example, 0 = Adelie, 1 = Gentoo, 2 = Chinstrap)

**Role of the Algorithm**

* An **algorithm** analyzes the training data to determine a relationship between:

  * Features (x)
  * Label (y)
* The algorithm generalizes this relationship into a **calculation**.
* The choice of algorithm depends on the **type of predictive problem** being solved.
* The objective is to **fit the data to a function** that calculates y from x.

**The Model Function**

* The output of training is a **model** that encapsulates a function:

  * Mathematical form: **y = f(x)**

**Inferencing Output**

* During inferencing:

  * Feature values are input into the model.
  * The model outputs a **predicted label**.
* Predicted output is often written as **ŷ (“y-hat”)** to indicate it is a prediction, not an observed value.

**Key Facts to Remember**

* **Training** defines the function; **inferencing** uses it for prediction.
* **Features (x)** are inputs; **labels (y)** are known outputs during training.
* **x is a vector** when multiple features are used.
* A trained model represents a function: **y = f(x)**.
* Predicted values are denoted as **ŷ**, not y.

---

## Types of machine learning model

[Module Reference](https://learn.microsoft.com/training/modules/introduction-machine-learning-concepts/)

**Overview**

* There are multiple **types of machine learning**, and the correct type depends on **what you are trying to predict**
* Common categories:

  * **Supervised machine learning**
  * **Unsupervised machine learning**

<img src='.img/2026-01-18-06-54-31.png' width=700>

**Supervised machine learning**

* Training data includes:

  * **Feature values**
  * **Known label values**
* Models learn the relationship between **features and labels**
* Used to predict **unknown labels** for future data

**Regression (Supervised)**

* Predicted label is a **numeric value**
* Example use cases:

  * Predicting **number of ice creams sold** based on weather conditions
  * Predicting **property selling price** based on size, bedrooms, and location metrics
  * Predicting **fuel efficiency (MPG)** based on vehicle dimensions and engine size

**Classification (Supervised)**

* Predicted label represents a **category (class)**

**Binary classification**

* Predicts **one of two mutually exclusive outcomes**
* Examples:

  * Whether a patient **is or is not** at risk for diabetes
  * Whether a customer **will or will not** default on a loan
  * Whether a customer **will or will not** respond to a marketing offer
* Output represents **true/false** or **positive/negative** for a single class

**Multiclass classification**

* Predicts **one of multiple possible classes**
* Examples:

  * Penguin species (**Adelie, Gentoo, Chinstrap**)
  * Movie genre (**comedy, horror, romance, adventure, science fiction**)
* Typically predicts **mutually exclusive labels**
* Some algorithms support **multilabel classification**

  * More than one valid label per observation
  * Example: a movie classified as **science fiction and comedy**

**Unsupervised machine learning**

* Training data contains:

  * **Feature values only**
  * **No known labels**
* Models discover **patterns and relationships** within the data

**Clustering (Unsupervised)**

* Groups observations into **discrete clusters** based on feature similarity
* Examples:

  * Grouping flowers by size, leaves, and petals
  * Segmenting customers by demographics and purchasing behavior
* Key differences from classification:

  * **No predefined labels**
  * Groups are formed **purely by feature similarity**
* Can be used as a **precursor to classification**

  * Identify clusters
  * Analyze and assign labels
  * Use labeled results to train a classification model

**Key Facts to Remember**

* **Supervised learning** requires labeled data
* **Regression** predicts numeric values
* **Classification** predicts categorical labels
* **Binary classification** predicts two outcomes
* **Multiclass classification** predicts one of many classes
* **Unsupervised learning** has no labels
* **Clustering** groups data based on similarity alone

---


*Last updated: 2026-01-16*
