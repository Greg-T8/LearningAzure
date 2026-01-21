# Module 14: Get started with AI-powered information extraction in Microsoft Foundry

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/ai-information-extraction/)

---

## Introduction

[Module Reference](https://learn.microsoft.com/training/modules/get-started-ai-powered-information-extraction-microsoft-foundry/)

**Overview**

* **AI-powered information extraction and analysis** enables organizations to gain actionable insights from data that is otherwise locked in:

  * Documents
  * Images
  * Audio files
  * Other digital assets

**Common Information Extraction Scenarios**

* **Expense processing**

  * Extract expense descriptions and amounts from scanned receipts
* **Customer support analysis**

  * Analyze recorded support calls to identify common problems and resolutions
* **Historical data digitization**

  * Extract and store data from scanned census records and historical documents
* **Tourism analytics**

  * Analyze video footage and images to estimate visitor volumes and improve capacity planning
* **Accounts payable automation**

  * Route centrally received invoices to appropriate departments for payment
* **Marketing content analysis**

  * Extract and index data from large volumes of digital images and documents for searchability

**Azure AI Capabilities**

* Azure AI provides **multiple services** that can be used:

  * Individually
  * In combination
* These services support a wide range of **information extraction and analysis scenarios**

**Module Scope**

* The module explores Azure AI services and their capabilities for:

  * Extracting information
  * Analyzing unstructured and semi-structured data

**Key Facts to Remember**

* AI-powered information extraction targets **unstructured data sources**
* Scenarios span **documents, images, audio, and video**
* Azure AI services can be **combined** to solve complex extraction needs
* The goal is to unlock **actionable insights** from previously inaccessible data

---

## Azure AI services for information extraction

[Module Reference](https://learn.microsoft.com/training/modules/get-started-ai-powered-information-extraction-microsoft-foundry/azure-ai-services-information-extraction)

**Overview**

* Azure AI provides cloud-based services to **extract and analyze information** from digital content.
* These services can be used **individually or combined** to build end-to-end information extraction solutions.

**Core Azure AI Services for Information Extraction**

* **Azure Vision Image Analysis**

  * Extracts insights from images
  * Detects and identifies **common objects**
  * Generates **captions and tags**
  * Extracts **text from images**

* **Azure Content Understanding**

  * **Generative AI–based multimodal analysis** service
  * Extracts insights from:

    * Structured documents
    * Images
    * Audio
    * Video

* **Azure Document Intelligence**

  * Extracts **fields and values** from digital or digitized forms
  * Common examples include:

    * Invoices
    * Receipts
    * Purchase orders

* **Azure AI Search**

  * Performs **AI-assisted indexing**
  * Uses a pipeline of **AI skills**
  * Extracts and indexes information from:

    * Structured content
    * Unstructured content

**Common Information Extraction Solutions**

* **Data capture**

  * Scans images to capture and store data values
  * Example: Extracting contact details from a business card image

* **Business process automation**

  * Reads data from forms to trigger workflows
  * Example: Extracting billing details from invoices and routing them for accounts payable processing

* **Meeting summarization and analysis**

  * Analyzes recorded phone calls or video meetings
  * Example: Automating meeting notes and action items

* **Digital asset management (DAM)**

  * Automatically tags and indexes images or videos
  * Example: Creating a searchable library of stock photos

* **Knowledge mining**

  * Extracts information from structured and unstructured data
  * Example: Compiling census data from scanned records into a database

**Key Facts to Remember**

* **Azure Vision Image Analysis** focuses on image-based insights and OCR
* **Azure Content Understanding** supports multimodal, generative AI analysis
* **Azure Document Intelligence** is optimized for structured forms and documents
* **Azure AI Search** enables AI-powered indexing and knowledge mining
* Services can be **combined** to support complex, end-to-end information extraction scenarios

---

## Extract information with Azure Vision

[Module Reference](https://learn.microsoft.com/training/modules/get-started-ai-powered-information-extraction-microsoft-foundry/)

**Azure Vision Image Analysis – Use Cases**

* Used to extract insights from **photographs** and **small scanned documents**
* Suitable examples:

  * Business cards
  * Menus
  * Simple scanned documents

**Automated Caption and Tag Generation**

* Azure Vision Image Analysis can analyze an image and generate:

  * **A caption** that describes the overall image
  * **Dense captions** that describe key objects within the image
  * **Tags** that categorize the image content

* Example outputs include:

  * Caption: *A man walking a dog on a leash*
  * Dense captions identifying:

    * People
    * Objects (cars, booths, animals)
    * Context (street, city)
  * Tags such as:

    * outdoor, vehicle, road, person, dog, city, walking, yellow

**Object Detection**

* Detects **common objects and people** in images
* Identifies:

  * **Object types**
  * **Object locations** within the image
* Example:

  * Detects and highlights an **apple**, **banana**, and **orange** in a photo

**Optical Character Recognition (OCR)**

* Extracts **printed or handwritten text** from images

* Determines:

  * Location of each line of text
  * Individual words within the image

* Useful for:

  * Reading text for further processing
  * Translating text (for example, menus in mobile apps)
  * Extracting small volumes of free-form text from simple documents

* Example use case:

  * Extracting contact details from a **business card**
  * Sample extracted fields:

    * Company name
    * Person name
    * Job title
    * Email address
    * Phone number

**Key Facts to Remember**

* **Azure Vision Image Analysis** supports captions, dense captions, tags, object detection, and OCR
* **OCR** works with both printed and handwritten text
* Best suited for **images and small, simple documents**, not large or complex documents
* Common scenarios include **business cards, menus, and photos**

---

## Extract multimodal information with Azure Content Understanding

[Module Reference](https://learn.microsoft.com/training/modules/extract-multimodal-information-azure-content-understanding)

**Overview**

* **Azure Content Understanding** uses state-of-the-art AI models to analyze content across multiple formats.
* Supported content types:

  * **Text-based forms and documents**
  * **Audio**
  * **Images**
  * **Video**

**Analyzing Forms and Documents**

* Document analysis goes beyond basic OCR.
* Uses **schema-based extraction** to identify fields and their values.
* Schemas define expected fields, even if:

  * Field labels differ
  * Fields are unlabeled
* Example invoice schema fields:

  * **Vendor name**
  * **Invoice number**
  * **Invoice date**
  * **Customer name**
  * **Custom address**
  * **Items**

    * Item description
    * Unit price
    * Quantity ordered
    * Line item total
  * **Invoice subtotal**
  * **Tax**
  * **Shipping charge**
  * **Invoice total**
* Extracted values are returned per field based on the schema.

**Analyzing Audio**

* Supports analysis of **audio files**.
* Capabilities include:

  * **Transcriptions**
  * **Summaries**
  * **Key insight extraction**
* Uses a predefined schema to extract structured insights.
* Example audio schema fields:

  * **Caller**
  * **Message summary**
  * **Requested actions**
  * **Callback number**
  * **Alternative contact details**
* Extracts structured results from unstructured voice recordings.

**Analyzing Images and Video**

* Supports analysis of **images** and **video** using a custom schema.
* Can extract contextual and numerical information.
* Example image schema fields:

  * **Location**
  * **In-person attendees**
  * **Remote attendees**
  * **Total attendees**
* Video analysis schemas can include:

  * Attendance counts over time
  * Speaker identification
  * Spoken content
  * Discussion summaries
  * Assigned actions

**Key Facts to Remember**

* Azure Content Understanding supports **text, audio, image, and video** analysis.
* Uses **custom schemas** to extract structured information.
* Schema-based extraction works even with inconsistent or missing labels.
* Audio analysis can return **summaries, actions, and contact details**.
* Image and video analysis can extract **counts, context, and activity details**.

---
