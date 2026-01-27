# Custom Vision

---

## Introduction to Custom Vision

**Timestamp**: 01:48:14 – 01:48:58

**Key Concepts**  
- Custom Vision is a fully managed, no-code service for building custom image classification and object detection ML models quickly.  
- It allows users to upload labeled images or add tags to unlabeled images to train the model.  
- Training involves teaching Custom Vision the concepts you care about using labeled images.  
- The service provides a simple REST API to tag images with the trained custom model for evaluation.

**Definitions**  
- **Custom Vision**: A Microsoft Azure service that enables users to create custom image classification and object detection models without writing code.  
- **Training**: The process of using labeled images to teach the Custom Vision model to recognize specific concepts.  
- **REST API**: An interface provided by Custom Vision to interact programmatically with the trained model for tagging and evaluating images.

**Key Facts**  
- Custom Vision is hosted on its own isolated domain: www.customvision.ai.  
- It supports both bringing your own labeled images and quickly adding tags to unlabeled images.  
- The service is designed for quick model building without requiring coding skills.

**Examples**  
- None explicitly mentioned in this time range.

**Key Takeaways 🎯**  
- Remember that Custom Vision is a no-code, fully managed Azure service for custom image classification and object detection.  
- Know that you can upload labeled images or tag unlabeled images to train your model.  
- Be aware that Custom Vision provides a REST API to use the trained model for image tagging and evaluation.  
- The service is accessible via www.customvision.ai, separate from other Azure services.

---

## Project Types and Domains

**Timestamp**: 01:48:58 – 01:51:54

**Key Concepts**  
- Custom Vision requires creating a project and selecting a project type.  
- Two main project types: **Classification** and **Object Detection**.  
- Classification can be **multi-label** (multiple tags per image) or **multi-class** (only one tag per image).  
- Object Detection involves tagging specific objects within an image using bounding boxes.  
- Choosing a **domain** is essential; domains are Microsoft-managed datasets optimized for different use cases and affect training and inference.  

**Definitions**  
- **Classification (Multi-label)**: Assigning multiple tags to a single image (e.g., image contains both cat and dog).  
- **Classification (Multi-class)**: Assigning only one tag per image (e.g., apple OR banana OR orange).  
- **Object Detection**: Identifying and tagging multiple objects within an image, each with bounding boxes.  
- **Domain**: A Microsoft-managed dataset used to optimize training and inference for specific use cases or data types.  

**Key Facts**  
- Classification domains include:  
  - **General**: Broad range, default if unsure.  
  - **A1**: Better accuracy, longer training time, suited for larger or complex datasets.  
  - **A2**: Good accuracy with faster inference than A1, less training time, recommended for most datasets.  
  - **Food**: Optimized for photographs of dishes or individual fruits/vegetables.  
  - **Landmark**: Optimized for natural/artificial landmarks, works even if slightly obstructed.  
  - **Retail**: Optimized for shopping cart or website images, high precision for apparel categories.  
  - **Compact**: Optimized for real-time classification on edge devices.  

- Object Detection domains include:  
  - **General**: Broad range, default if unsure.  
  - **A1**: Better accuracy and comparable inference time, recommended for larger datasets and difficult scenarios; results may vary ±1% mean average precision.  
  - **Logo**: Optimized for detecting brands and logos.  
  - **Products**: Optimized for detecting and classifying products on shelves.  

- For object detection labeling, Custom Vision can suggest bounding boxes using ML, but manual drawing is also possible.  
- Minimum of **50 images per tag** is required for training.  

**Examples**  
- Multi-label classification example: Image containing both a cat and a dog tagged with both labels.  
- Multi-class classification example: Image tagged as either apple, banana, or orange, but only one tag per image.  
- Object detection example: Drawing bounding boxes around objects in an image, either suggested by ML or manually drawn.  

**Key Takeaways 🎯**  
- Always select the correct project type (classification vs object detection) based on your use case.  
- Understand the difference between multi-label and multi-class classification.  
- Choose the domain that best fits your data and scenario to optimize accuracy and training time.  
- Remember the minimum of 50 images per tag for effective training.  
- Use the ML-assisted bounding box suggestions in object detection to speed up labeling but verify manually.  
- Domains like A1 and A2 balance accuracy and inference time differently—choose based on dataset size and complexity.  
- Retail and food domains provide specialized optimizations for those specific image types.  
- For object detection, expect some variability in results with A1 domain (±1% mean average precision).

---

## Custom Vision Features

**Timestamp**: 01:51:54 – 01:54:32

**Key Concepts**  
- Custom Vision supports image classification and object detection with tagging at image or object level.  
- Minimum of 50 images per tag is required for training.  
- Two training modes: Quick Training (faster, less accurate) and Advanced Training (longer compute time, better accuracy).  
- Evaluation metrics include precision, recall, and mean average precision (mAP).  
- Probability threshold controls when training stops based on evaluation metrics.  
- Smart Labeler (ML-assisted labeling) helps speed up tagging by suggesting labels after some initial training data is loaded.  
- After training, models can be quickly tested with sample images before publishing.  
- Publishing provides a prediction URL for invoking the model.

**Definitions**  
- **Precision**: The accuracy of the model in selecting relevant items (exactness).  
- **Recall**: The sensitivity or true positive rate; how many relevant items are returned.  
- **Mean Average Precision (mAP)**: A combined metric used especially in object detection to evaluate overall model performance.  
- **Smart Labeler (ML-assisted labeling)**: A feature that suggests bounding boxes and labels for unlabeled objects based on learned patterns to accelerate dataset labeling.

**Key Facts**  
- At least 50 images per tag are required to train the model.  
- Quick training is faster but less accurate; advanced training improves accuracy by increasing compute time.  
- Precision and recall metrics vary with each training iteration and guide model improvement.  
- Smart Labeler suggestions are not 100% guaranteed but useful for large datasets.  
- After publishing, a prediction endpoint URL is provided for invoking the model.

**Examples**  
- Upload multiple images and apply single or multiple labels for image classification.  
- For object detection, tags are applied to objects within images using bounding boxes.  
- You can manually draw bounding boxes if automatic detection misses objects.  
- Quick test feature allows uploading an image to see prediction results before publishing.

**Key Takeaways 🎯**  
- Remember the minimum 50 images per tag requirement for training.  
- Understand the difference between quick and advanced training modes and their impact on accuracy and compute time.  
- Know the evaluation metrics: precision, recall, and mean average precision (mAP) — these are likely exam topics.  
- Be familiar with the Smart Labeler feature as an example of ML-assisted labeling to speed up dataset preparation.  
- Know the workflow: upload/tag images → train (quick or advanced) → test → publish → get prediction URL.


