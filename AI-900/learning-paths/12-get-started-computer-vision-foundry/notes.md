# Module 12: Get started with computer vision in Microsoft Foundry

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/get-started-computer-vision-azure/)

---

## Understand Foundry Tools for computer vision

[Module Reference](https://learn.microsoft.com/training/modules/get-started-with-computer-vision-in-microsoft-foundry/)

**Overview**

* **Azure AI** provides cloud-based AI services, including computer vision.
* **Azure Vision** delivers prebuilt and customizable computer vision models based on deep learning.
* Azure Vision supports **off-the-shelf** scenarios and **custom models** trained with your own images.

**Azure Vision Products**

* **Azure Vision Image Analysis**

  * Detects common objects in images
  * Tags visual features
  * Generates image captions
  * Supports **optical character recognition (OCR)**

<img src='.img/2026-01-21-04-48-51.png' width=700>


* **Azure AI Face**

  * Detects, recognizes, and analyzes human faces in images
  * Provides facial analysis models beyond standard image analysis

<img src='.img/2026-01-21-04-49-09.png' width=500>

**Common Use Cases**

* **Search engine optimization**

  * Image tagging and captioning to improve search ranking
* **Content moderation**

  * Image detection to monitor image safety
* **Security**

  * Facial recognition for building security and device unlocking
* **Social media**

  * Automatic tagging of known people in photos
* **Missing persons**

  * Facial recognition used with public camera systems
* **Identity validation**

  * Entry kiosks where users present special permits
* **Museum archive management**

  * OCR to preserve text from paper documents

**Related Vision Capabilities**

* Many vision solutions combine multiple services.
* **Azure AI Video Indexer**

  * Supports video analysis
  * Built on Foundry Tools including:

    * Face
    * Translator
    * Image Analysis
    * Speech

**Key Facts to Remember**

* **Azure Vision** offers both prebuilt and custom computer vision models.
* **Image Analysis** handles objects, tags, captions, and OCR.
* **Azure AI Face** specializes in advanced facial detection and analysis.
* **Azure AI Video Indexer** integrates multiple Foundry Tools for video scenarios.

---

## Understand Azure Vision Image Analysis Capabilities

[Module Reference](https://learn.microsoft.com/training/modules/get-started-with-computer-vision/)

**Image Analysis Capabilities (No Customization Required)**

* **Image captions**: Analyze an image and generate a **human-readable description** of its contents.
* **Object detection**: Identify **thousands of common objects** in images.
* **Image tagging**: Generate **metadata tags** that summarize visual attributes.
* **Optical character recognition (OCR)**: Detect and extract **printed text** from images.

**Describing an Image with Captions**

* Azure Vision evaluates objects within an image and generates a **natural language caption**.
* Example output: *“A person jumping on a skateboard”*

<img src='.img/2026-01-21-04-50-55.png' width=500>

**Detecting Common Objects in an Image**

* Identifies objects and returns:

  * **Object labels**
  * **Confidence scores** (percentage likelihood)
  * **Bounding box coordinates**:

    * Top
    * Left
    * Width
    * Height
* Example detections:

  * **Person (95.5%)**
  * **Skateboard (90.40%)**

<img src='.img/2026-01-21-04-51-12.png' width=500>

**Tagging Visual Features**

* Generates **descriptive tags** with confidence scores.
* Tags are stored as **image metadata**.
* Useful for:

  * Indexing images
  * Enabling search scenarios
* Example tag characteristics:

  * Environment (outdoor)
  * Activity (skateboarding, jumping)
  * Objects (skateboard, clothing)
  * Concepts (balance, extreme sport)

**Optical Character Recognition (OCR)**

* Detects and extracts **text content from images**.
* Common use cases:

  * Labels
  * Signs
  * Printed documents
* Example extracted content:

  * Nutrition facts
  * Serving sizes
  * Calories and ingredients

<img src='.img/2026-01-21-04-51-42.png' width=500>

**Training Custom Models**

* Used when built-in models **do not meet requirements**.
* Custom models are trained on a **pre-trained foundation model**.
* Requires **relatively few training images**.

**Image Classification**

* Predicts a **single category or class** for an image.
* Example use case:

  * Classifying fruit images (Apple, Banana, Orange)

<img src='.img/2026-01-21-04-51-59.png' width=500>

**Object Detection (Custom Models)**

* Detects **multiple objects** in an image.
* Returns:

  * Object classification
  * Bounding box coordinates
* Can be trained using **custom image datasets**.

<img src='.img/2026-01-21-04-52-14.png' width=500>

**Key Facts to Remember**

* Azure Vision supports **captioning, object detection, tagging, and OCR without customization**.
* Object detection outputs include **confidence scores and bounding box coordinates**.
* Tags are used as **searchable metadata**.
* OCR extracts **printed text from images**.
* Custom models extend image classification and object detection using **foundation models**.

---
