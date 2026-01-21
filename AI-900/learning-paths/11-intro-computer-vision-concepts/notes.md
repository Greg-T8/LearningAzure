# Module 11: Introduction to computer vision concepts

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/introduction-computer-vision/)

---

## Computer vision tasks and techniques

[Module Reference](https://learn.microsoft.com/training/modules/introduction-computer-vision-concepts/)

**Computer Vision Overview**

* **Computer vision** refers to AI tasks and techniques that process **visual input**.
* Visual input typically comes from **images, videos, or live camera streams**.
* Computer vision is a **well-established field of AI** with techniques that have evolved significantly over time.
* The goal is to **extract meaningful information** from visual data.

**Image Classification**

* One of the **oldest computer vision techniques**.
* A model is trained with a **large number of labeled images**.
* The model predicts a **single text label** that represents the main subject of an image.
* Uses **visual features** of an image to determine its contents.
* Example use case:

  * Identifying types of produce (apple, orange, banana) at a grocery store checkout.
  * Pricing is determined by identifying the item and combining it with its **measured weight**.

<img src='.img/2026-01-21-04-28-06.png' width=700>

**Object Detection**

* Used when **multiple objects** need to be identified in a single image.
* Models analyze **multiple regions** within an image.
* Output includes:

  * **Which objects** were detected.
  * **Where** they appear in the image.
* Object locations are represented by **rectangular bounding boxes** with coordinates.

<img src='.img/2026-01-21-04-28-20.png' width=500>

**Semantic Segmentation**

* A more **precise object detection technique**.
* The model classifies **individual pixels** in the image.
* Each pixel is assigned to a specific object class.
* Produces a **detailed mask** showing exact object boundaries.
* Provides more accurate localization than bounding boxes.

<img src='.img/2026-01-21-04-28-53.png' width=500>

**Contextual Image Analysis**

* Used by **modern multimodal computer vision models**.
* Identifies **relationships between objects** and associated text.
* Enables:

  * Semantic interpretation of images.
  * Understanding of **objects and activities** within an image.
  * Automatic generation of **descriptions** or **relevant tags**.

<img src='.img/2026-01-21-04-29-34.png' width=500>

**Key Facts to Remember**

* **Image classification** outputs a single label per image.
* **Object detection** identifies multiple objects and their locations using bounding boxes.
* **Semantic segmentation** classifies images at the pixel level.
* **Contextual image analysis** connects visual content with semantic meaning and descriptions.
* All techniques rely on **trained models** using labeled visual data.

---
