# Module 13: Introduction to AI-powered information extraction concepts

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/introduction-information-extraction/)
* [Introduction to AI-powered information extraction concepts](#introduction-to-ai-powered-information-extraction-concepts)
* [Overview of information extraction](#overview-of-information-extraction)
* [Optical character recognition (OCR)](#optical-character-recognition-ocr)
* [Field extraction and mapping](#field-extraction-and-mapping)

---

## Introduction to AI-powered information extraction concepts

[Module Reference](https://learn.microsoft.com/en-us/training/modules/introduction-information-extraction/1-introduction?pivots=text)

**Introduction**

* AI information extraction solutions are used to extract **structured data fields** from **unstructured media**
* Supported media includes:

  * **Documents**
  * **Images**
  * Emerging support for **videos** and **audio recordings**
* The module focuses on **documents and images**, while acknowledging broader AI capabilities


**Information Extraction Scenarios**

* Scenarios range from **simple applications** to **complex business workflow automation systems**
* Example spectrum:

  * Reading contact information from a **photograph of a business card**
  * Processing **financial and legal documents** in automated workflows

<img src='.img/2026-01-21-04-59-14.png' width=400>

**Financial Document Processing**

* **Invoice processing** can extract:

  * **Vendor information**: company names, addresses, contact details
  * **Transaction details**: invoice numbers, dates, payment terms
  * **Line items**: product descriptions, quantities, unit prices, totals
  * **Tax information**: tax rates, amounts, exempt items
* **Receipt processing** can extract:

  * **Merchant details**: store names, locations, transaction IDs
  * **Purchase information**: items purchased, prices, discounts
  * **Payment details**: payment methods, change amounts, loyalty points
* **Financial statements** can extract:

  * **Account information**: account numbers, balances, transaction histories
  * **Performance metrics**: revenue, expenses, profit margins
  * **Compliance data**: regulatory reporting fields, audit trail information

**Legal and Compliance Documents**

* **Contract processing** can extract:

  * **Party information**: contracting parties, signatories, witnesses
  * **Terms and conditions**: effective dates, renewal terms, termination clauses
  * **Financial terms**: payment schedules, penalties, insurance requirements
* **Regulatory forms** can include:

  * **Tax documents**: W-2s, 1099s, other tax forms
  * **Insurance forms**: policy numbers, claim amounts, incident details
  * **Government forms**: application data, certification requirements

**Healthcare Documentation**

* **Medical records** can be processed to extract:

  * **Patient information**: demographics, medical record numbers, insurance details
  * **Clinical data**: diagnoses, treatments, medication lists, vital signs
  * **Administrative data**: appointment schedules, billing codes, provider information

**Supply Chain and Logistics**

* **Shipping documents** can extract:

  * **Shipment details**: tracking numbers, weights, dimensions
  * **Address information**: sender and recipient details, delivery instructions
  * **Customs documentation**: commodity codes, values, geographical origin
* **Purchase Orders** can extract:

  * **Vendor information**: supplier details, contact information
  * **Product specifications**: item codes, descriptions, quantities
  * **Delivery requirements**: schedules, locations, special instructions

**Learning Format Notes**

* The module supports **video-based** and **text-based** learning formats
* **Text content** provides **greater detail** and may supplement videos

**Key Facts to Remember**

* Information extraction converts **unstructured content** into **structured data**
* Common source media includes **documents** and **images**
* Use cases span **finance, legal, healthcare, and logistics**
* Information extraction is foundational for **workload automation systems**

---

## Overview of information extraction

[Module Reference](https://learn.microsoft.com/training/modules/intro-ai-powered-information-extraction-concepts/)

**Information Extraction Overview**

* **Information extraction** is a workload that combines multiple AI techniques to extract data from content, often digital documents.
* A comprehensive solution typically combines:

  * **Computer vision** to detect text in image-based data.
  * **Machine learning or generative AI** to semantically map extracted text to specific data fields.

**Information Extraction Process**

* **Text detection and extraction** from images using **optical character recognition (OCR)**.
* **Value identification and mapping** from OCR results to predefined data fields.

**Example Use Case**

* AI-powered expense claim processing:

  * Automatically extracts relevant fields from receipts.
  * Improves efficiency in processing claims.
* Example extracted fields:

  * **Vendor**
  * **Date**
  * **Subtotal**
  * **Tax**
  * **Total claim**

**Choosing the Right Approach**

* **Document characteristics**

  * **Layout consistency**:

    * Standardized forms favor template-based approaches.
    * Multiple formats and layouts may require machine learning–based solutions.
  * **Volume requirements**:

    * High-volume processing benefits from automated machine learning models on optimized hardware.
  * **Accuracy requirements**:

    * Critical applications may require **human-in-the-loop validation**.

* **Technical infrastructure requirements and constraints**

  * **Security and privacy**:

    * Documents may contain sensitive or confidential data.
    * Solutions must secure access and comply with industry requirements.
  * **Processing power**:

    * Deep learning and generative AI models require significant computational resources.
  * **Latency requirements**:

    * Real-time processing can limit model complexity.
  * **Scalability needs**:

    * Cloud-based solutions provide better scalability for variable workloads.
  * **Integration complexity**:

    * Consider API compatibility and data format requirements.

**Platform-Based Solutions**

* Information extraction solutions can be built using software services such as:

  * **Azure Document Intelligence** in Microsoft Foundry Tools.
  * **Azure Content Understanding** in Microsoft Foundry Tools.
* Using these services:

  * Reduces development effort.
  * Provides scalable, industry-proven performance.
  * Improves accuracy and integration capabilities.

**Key Facts to Remember**

* Information extraction combines **OCR**, **computer vision**, and **machine learning or generative AI**.
* OCR is responsible for **text detection and extraction**.
* Value mapping links extracted text to **specific data fields**.
* Layout consistency, volume, and accuracy drive solution design.
* Cloud-based services improve **scalability**, **performance**, and **integration**.

---

## Optical character recognition (OCR)

[Module Reference](https://learn.microsoft.com/training/modules/introduction-to-ai-powered-information-extraction-concepts/)

**Definition**

* **Optical Character Recognition (OCR)** automatically converts **visual text in images** into **editable, searchable text data**
* Eliminates manual transcription

**Common OCR Input Sources**

* Scanned invoices and receipts
* Digital photographs of documents
* PDF files containing images of text
* Screenshots and captured content
* Forms and handwritten notes

**OCR Pipeline Overview**

* The OCR pipeline consists of **five essential stages** that transform visual information into text data:

  1. Image acquisition and input
  2. Preprocessing and image enhancement
  3. Text region detection
  4. Character recognition and classification
  5. Output generation and post-processing

**Stage 1: Image Acquisition and Input**

* Image enters the OCR system from:

  * Smartphone camera photographs
  * Flatbed or document scanners
  * Video stream frames
  * PDF pages rendered as images
* **Image quality at this stage significantly impacts final accuracy**

**Stage 2: Preprocessing and Image Enhancement**

* **Noise reduction**

  * Removes artifacts and imperfections
  * Techniques:

    * Gaussian filters, median filters, morphological operations
    * Denoising autoencoders and CNNs
* **Contrast adjustment**

  * Improves distinction between text and background
  * Techniques:

    * Histogram equalization, adaptive thresholding, gamma correction
    * Deep learning models for adaptive enhancement
* **Skew correction**

  * Aligns text horizontally
  * Techniques:

    * Hough transform, projection profiles, connected component analysis
    * Regression CNNs predicting rotation angles
* **Resolution optimization**

  * Adjusts image to optimal resolution for recognition
  * Techniques:

    * Bicubic, bilinear, Lanczos interpolation
    * Super-resolution models (GANs, residual networks)

**Stage 3: Text Region Detection**

* **Layout analysis**

  * Differentiates text, images, graphics, and whitespace
  * Techniques:

    * Connected component analysis, run-length encoding
    * U-Net, Mask R-CNN, LayoutLM, PubLayNet-trained models
* **Text block identification**

  * Groups characters into words, lines, and paragraphs
  * Techniques:

    * Distance-based clustering, whitespace analysis
    * Graph neural networks and transformer models
* **Reading order determination**

  * Establishes correct reading sequence
  * Techniques:

    * Geometric rule-based systems
    * Sequence prediction and graph-based ML models
* **Region classification**

  * Identifies headers, body text, captions, tables
  * Techniques:

    * SVMs using font size, position, formatting
    * CNNs and vision transformers

**Stage 4: Character Recognition and Classification**

* **Feature extraction**

  * Analyzes shape, size, and character structure
  * Techniques:

    * Moments, Fourier descriptors, structural features
    * CNN-based automatic feature learning
* **Pattern matching**

  * Matches features against trained character models
  * Techniques:

    * Template matching
    * HMMs, SVMs, k-nearest neighbors
    * MLPs, CNNs, LeNet
    * ResNet, DenseNet, EfficientNet
* **Context analysis**

  * Improves accuracy using surrounding text
  * Techniques:

    * N-gram language models
    * Dictionary-based correction with edit distance
    * LSTM and transformer-based language models
    * Attention mechanisms
* **Confidence scoring**

  * Assigns probability to recognized characters
  * Techniques:

    * Bayesian models
    * Softmax probability outputs
    * Ensemble methods

**Stage 5: Output Generation and Post-Processing**

* **Text compilation**

  * Combines characters into words and sentences
  * Techniques:

    * Rule-based assembly
    * RNNs and LSTMs
    * Transformer-based sequence models
* **Format preservation**

  * Maintains paragraphs, spacing, and line breaks
  * Techniques:

    * Bounding-box geometry and whitespace analysis
    * Graph neural networks and document AI models
    * Multi-modal transformers (for example, LayoutLM)
* **Coordinate mapping**

  * Records exact position of text in the image
  * Techniques:

    * Pixel-to-document coordinate transformations
    * R-trees and quad-trees
    * Neural regression models
* **Quality validation**

  * Detects spelling and grammar errors
  * Techniques:

    * Dictionary-based validation
    * N-gram and probabilistic language models
    * Pre-trained neural models fine-tuned for OCR correction
    * Ensemble validation approaches

**Key Facts to Remember**

* **OCR converts visual text into machine-readable text**
* The OCR pipeline has **five mandatory stages**
* **Preprocessing directly impacts recognition accuracy**
* **Deep learning models are used across all pipeline stages**
* Output includes **text content, structure, coordinates, and confidence scores**

---

## Field extraction and mapping

[Module Reference](https://learn.microsoft.com/training/modules/introduction-to-ai-powered-information-extraction-concepts/)

**Field Extraction Overview**

* **Field extraction** maps OCR text output to **labeled data fields** that represent meaningful business information.
* **OCR** identifies *what text exists*; **field extraction** determines *what the text means* and *where it belongs* in business systems.
* Field extraction relies heavily on **text position and layout**, not just text content.

**Field Extraction Pipeline**

* The pipeline transforms OCR output into structured data through defined stages:

  1. OCR output ingestion
  2. Field detection and candidate identification
  3. Field mapping and association
  4. Data normalization and standardization
  5. Integration with business processes and systems

<img src='.img/2026-01-21-05-04-03.png' width=500>

**Stage 1: OCR Output Ingestion**

* Input consists of structured OCR output, including:

  * **Raw text content**: Extracted characters and words
  * **Positional metadata**: Bounding boxes, page location, reading order
  * **Confidence scores**: OCR confidence per text element
  * **Layout information**: Lines, paragraphs, document structure
* Field extraction depends on **where text appears**, not only the text value itself.

**Stage 2: Field Detection and Candidate Identification**

* Identifies potential field values within OCR output.

* Multiple approaches can be used independently or together.

* **Template-Based Detection**

  * Uses rule-based pattern matching:

    * Predefined layouts with known field positions and anchor keywords
    * Label-value pairs (for example, *Invoice Number:*, *Date:*)
    * Regular expressions and string matching
  * **Advantages**:

    * High accuracy for known document types
    * Fast processing
    * Explainable results
  * **Limitations**:

    * Manual template creation required
    * Sensitive to layout variation and naming inconsistencies

* **Machine Learning–Based Detection**

  * Models learn field relationships from example documents.
  * Transformer-based models use contextual cues.
  * Training approaches include:

    * **Supervised learning** with labeled datasets
    * **Self-supervised learning** on large document corpora
    * **Multi-modal learning** combining text, visual, and positional features
  * Advanced architectures include:

    * **Graph Neural Networks (GNNs)** for spatial relationships
    * **Attention mechanisms** for region-focused prediction
    * **Sequence-to-sequence models** for structured output generation

* **Generative AI for Schema-Based Extraction**

  * Uses large language models (LLMs) for field detection:

    * **Prompt-based extraction** using document text and schema definitions
    * **Few-shot learning** with minimal examples
    * **Chain-of-thought reasoning** for step-by-step field identification

**Stage 3: Field Mapping and Association**

* Candidate values are mapped to specific schema fields.

* **Key-Value Pairing Techniques**

  * **Proximity analysis**:

    * Spatial clustering
    * Reading order analysis
    * Geometric relationships (alignment, indentation, position)
  * **Linguistic pattern recognition**:

    * Named entity recognition (NER)
    * Part-of-speech tagging
    * Dependency parsing

* **Table and Structured Content Processing**

  * Tables may contain line items or structured data.
  * Table detection techniques include:

    * CNN-based table recognition
    * Object detection for table cells
    * Graph-based table parsing
  * Table value mapping techniques include:

    * Row-column association
    * Header detection
    * Hierarchical processing for nested tables and subtotals

* **Confidence Scoring and Validation**

  * Accuracy evaluation techniques include:

    * OCR confidence inheritance
    * Pattern-matching confidence
    * Context validation
    * Cross-field validation (for example, subtotals matching totals)

**Stage 4: Data Normalization and Standardization**

* Extracted values are converted into consistent formats and validated.

* **Format Standardization**

  * **Date normalization**:

    * Format detection
    * Parsing to standardized formats
    * Ambiguity resolution
  * **Currency and numeric processing**:

    * Currency symbol recognition
    * Decimal normalization
    * Unit conversion
  * **Text standardization**:

    * Case normalization
    * Encoding standardization
    * Abbreviation expansion

* **Data Validation and Quality Assurance**

  * **Rule-based validation**:

    * Format checking
    * Range validation
    * Required field verification
  * **Statistical validation**:

    * Outlier detection
    * Distribution analysis
    * Cross-document consistency checks

**Stage 5: Integration with Business Processes and Systems**

* Extracted data is integrated into downstream systems.

* **Schema Mapping**

  * Maps extracted fields to target systems such as:

    * Database schemas
    * API payloads
    * Message queues
  * Transformations can include:

    * Field renaming
    * Data type conversion
    * Conditional business logic

* **Quality Metrics and Reporting**

  * Post-extraction evaluation may include:

    * Field-level confidence scores
    * Document-level quality metrics
    * Error categorization by type and cause

**Key Facts to Remember**

* **Field extraction** adds semantic meaning to OCR output.
* **Position and layout** are critical for accurate field identification.
* **Multiple detection approaches** (template, ML, generative AI) can be combined.
* **Normalization and validation** ensure consistency and reliability before integration.
* **Integration** aligns extracted data with downstream business systems.

---
