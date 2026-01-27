# Follow Alongs

**Channel:** freeCodeCamp.org
**Duration:** 11:16:25
**URL:** https://www.youtube.com/watch?v=10PbGbTUSAg

---

## Setup

**Timestamp**: 02:24:04 – 02:35:02

**Key Concepts**  
- Setting up Azure Machine Learning Studio as a workspace for ML projects  
- Creating and managing compute resources in Azure ML (compute instances, clusters, inference clusters, attached compute)  
- Using notebooks within Azure ML Studio backed by compute instances  
- Uploading project files and assets to Azure ML Studio notebooks  
- Setting up Azure Cognitive Services as a unified API endpoint for multiple AI services  
- Managing keys and endpoints for Cognitive Services integration  
- Importance of selecting appropriate compute type (CPU vs GPU) based on cost and workload  
- Launching Jupyter Lab from Azure ML Studio for notebook editing and development  

**Definitions**  
- **Azure Machine Learning Studio**: A cloud-based environment for building, training, and deploying machine learning models.  
- **Compute Instance**: A virtual machine used primarily for running notebooks and lightweight development tasks.  
- **Compute Cluster**: A scalable set of compute resources used for training ML models.  
- **Inference Cluster**: Compute resources dedicated to running inference pipelines.  
- **Attached Compute**: External compute resources like HDInsight or Databricks connected to Azure ML.  
- **Cognitive Services**: A collection of AI services and APIs that provide capabilities like vision, speech, language, and decision-making through a unified key and endpoint.  

**Key Facts**  
- GPU compute instances cost approximately $0.90 per hour and are more expensive than CPU instances.  
- Notebooks in Azure ML Studio require a compute instance to run; no compute means notebooks cannot execute.  
- Azure Cognitive Services can be accessed via a single unified key and API endpoint, simplifying integration.  
- Cognitive Services pricing is usage-based, with free tiers allowing up to 1000 transactions before billing.  
- Azure ML Studio supports multiple notebook editors: Jupyter Lab, Jupyter, VS Code, RStudio, and terminal.  
- Python kernels available include versions 3.6 and 3.8 (version choice is not critical for setup).  

**Examples**  
- Creating a new Azure ML Studio workspace named "my studio" and a workspace named "ML workplace."  
- Creating a new compute instance named "my notebook instance" using CPU for cost efficiency.  
- Uploading project files (e.g., AI 900 repo zipped files) and organizing them into folders like "cognitive services" within the notebook file system.  
- Creating a Cognitive Services resource named "my cog services" in the Azure portal, selecting region (e.g., US East), and standard SKU.  
- Copying Cognitive Services keys and endpoints into notebooks to enable API calls.  

**Key Takeaways 🎯**  
- Always create and attach a compute instance before running notebooks in Azure ML Studio.  
- Choose CPU compute instances for notebook development to save costs unless GPU is specifically needed.  
- Use the unified Cognitive Services key and endpoint to access multiple AI services efficiently.  
- Keep your Cognitive Services keys secure; avoid embedding them directly in notebooks for production.  
- Familiarize yourself with launching and using Jupyter Lab from Azure ML Studio for consistent development experience.  
- Understand the different compute types and their purposes to optimize resource usage and cost.  
- Upload all necessary project files and assets into the Azure ML Studio environment before starting labs or experiments.

---

## Computer Vision

**Timestamp**: 02:35:02 – 02:38:44

**Key Concepts**  
- Computer Vision is an umbrella service in Azure Cognitive Services covering multiple image-related operations.  
- The specific operation discussed is **"describe image in stream"**, which generates human-readable descriptions of images.  
- Descriptions are based on a collection of content tags returned by the operation.  
- The service returns captions with confidence scores indicating the likelihood of accuracy.  
- Images must be loaded and passed as streams to the API.  
- The Azure Cognitive Services Vision Computer Vision SDK is not pre-installed by default and must be installed via pip.  
- Common supporting libraries include `os` (for OS-level operations), `matplotlib` (for image display and drawing), and optionally `numpy`.  
- Credentials (key and endpoint) are required to authenticate and instantiate the Computer Vision client.  

**Definitions**  
- **Describe Image in Stream**: An API operation that analyzes an image stream and returns a human-readable description with complete sentences and associated content tags.  
- **Confidence Score**: A numerical value representing the likelihood that the returned caption or tag accurately describes the image content.  

**Key Facts**  
- The Computer Vision SDK for Python is not included in the Azure Machine Learning SDK by default and must be installed separately (`pip install azure-cognitiveservices-vision-computervision`).  
- Captions returned include a confidence score (e.g., 57.45%) indicating the model’s certainty.  
- The service can identify celebrities if they are in its database but may not recognize contextual or pop culture references (e.g., identifying Brent Spiner as a person but not necessarily as a Star Trek character).  
- Images must be loaded as streams before being sent to the API.  

**Examples**  
- An image (`assets/data.jpg`) was loaded as a stream and passed to the describe image API.  
- The returned caption was: "Brent Spiner looking at a camera" with a confidence score of 57.45%.  
- The system identified people and objects such as "person," "wall," "indoor," "man," and "pointing" as tags.  

**Key Takeaways 🎯**  
- Remember to install the Azure Cognitive Services Vision Computer Vision SDK separately before use.  
- Always load images as streams when calling the describe image API.  
- The describe image operation returns captions with confidence scores and content tags that help interpret the image.  
- Confidence scores provide insight into the reliability of the description but may not reflect perfect accuracy, especially for niche or cultural references.  
- Use supporting libraries like `matplotlib` to visualize images and results inline.  
- Credentials (endpoint and key) are essential to authenticate and create the Computer Vision client.  
- This operation is a foundational step before exploring more advanced services like Custom Vision.

---

## Custom Vision Classification

**Timestamp**: 02:38:44 – 02:45:22

**Key Concepts**  
- Custom Vision service allows for image classification and object detection.  
- Classification identifies what an image contains, either as a single class (one label per image) or multi-label (multiple labels per image).  
- Custom Vision projects can be created via the Azure Marketplace or directly through the customvision.ai website.  
- Projects require creating or linking to an Azure Custom Vision resource (part of Cognitive Services).  
- Domains optimize the model for specific use cases; General A2 domain is optimized for speed and suitable for demos.  
- Tagging images with labels is essential for training the model.  
- Training options include quick training (faster, less accurate) and advanced training (longer, potentially more accurate).  
- Probability threshold sets the minimum confidence score for predictions to be considered valid during evaluation.  
- After training, evaluation metrics such as precision, recall, and average precision indicate model performance.  
- Quick test feature allows uploading local images to test the trained model’s predictions.  
- Models can be published to generate a public endpoint for programmatic access.

**Definitions**  
- **Custom Vision**: An Azure Cognitive Service that enables building, deploying, and improving image classifiers and object detectors.  
- **Classification**: Assigning one or more labels to an entire image to identify what it contains.  
- **Multiclass Classification**: Each image is assigned exactly one label from multiple possible categories.  
- **Multilabel Classification**: Each image can have multiple labels (e.g., dog and cat in the same image).  
- **Domain**: A preset model configuration optimized for specific scenarios (e.g., General A2 for speed).  
- **Probability Threshold**: The minimum confidence score a prediction must meet to be considered valid during precision and recall calculations.  
- **Precision and Recall**: Metrics used to evaluate the accuracy and completeness of the model’s predictions.

**Key Facts**  
- Custom Vision can be accessed via Azure Marketplace or directly at customvision.ai.  
- When creating a resource, options include Free (FO) and Standard (SO) tiers; FO may be blocked or unavailable.  
- General A2 domain is optimized for faster training and inference, suitable for demos.  
- Quick training is faster but less customizable; advanced training allows longer training for potentially better accuracy.  
- Training time can vary but generally takes around 5 to 10 minutes.  
- Evaluation metrics after training include precision, recall, and average precision.  
- Quick test can achieve high confidence scores (e.g., 98.7% match for an image labeled “WARF”).  
- After publishing, a public URL endpoint is available for programmatic predictions.

**Examples**  
- Project named “Star Trek crew” created to classify images of Star Trek characters.  
- Tags created: WARF, data, crusher (Beverly Crusher).  
- Uploaded images tagged accordingly and trained the model.  
- Quick test matched an image of Worf with 98.7% confidence.  
- Additional tests:  
  - Hugh (a Borg) matched mostly to Data.  
  - Martok (a Klingon) matched strongly to Worf.  
  - Pulaski (doctor) matched to Beverly Crusher.  

**Key Takeaways 🎯**  
- Know the difference between classification and object detection in Custom Vision.  
- Understand the difference between multiclass (single label) and multilabel (multiple labels) classification modes.  
- Be familiar with how to create a Custom Vision project, including resource creation and domain selection.  
- Remember that tagging images correctly is crucial for effective training.  
- Quick training is suitable for demos and quick iterations; advanced training can improve accuracy but takes longer.  
- Understand the role of probability threshold in filtering predictions during evaluation.  
- Be able to interpret evaluation metrics like precision and recall to assess model quality.  
- Use the quick test feature to validate model predictions before publishing.  
- Publishing the model creates an endpoint for integration with applications or services.  
- Practical knowledge of uploading images, tagging, training, testing, and publishing is essential for exam scenarios involving Custom Vision.

---

## Custom Vision Object Detection

**Timestamp**: 02:45:22 – 02:51:18

**Key Concepts**  
- Custom Vision Object Detection allows identification and localization of specific objects within images (detecting particular items in a scene).  
- Creating a project involves selecting a domain (e.g., General v1.0) and adding tagged images for training.  
- Tagging involves drawing bounding boxes around objects of interest in images.  
- Training can be done via quick or advanced training options.  
- Model evaluation metrics include precision, recall, and mean average precision (mAP).  
- Threshold settings affect prediction confidence and overlap criteria for bounding boxes.

**Definitions**  
- **Object Detection**: The process of identifying and locating objects within an image by drawing bounding boxes around them.  
- **Precision**: The likelihood that a predicted tag by the model is correct (how many predicted positives are true positives).  
- **Recall**: The percentage of actual tags correctly identified by the model (how many true positives are found out of all actual positives).  
- **Mean Average Precision (mAP)**: A summary metric that measures overall object detector performance across all tags.  
- **Overlap Threshold**: The minimum percentage of overlap between predicted bounding boxes and ground truth boxes required to count as a correct prediction.

**Key Facts**  
- Minimum of 15 images used for training in the example.  
- Tag created was "combat" to detect combat badges.  
- Bounding boxes are manually drawn if automatic detection does not work well.  
- Higher contrast images improve detection accuracy.  
- After training, example model achieved 75% precision and 100% recall.  
- Thresholds can be adjusted to improve detection results (e.g., lowering threshold increases detections but may reduce precision).  
- Overlap threshold helps define how closely predicted bounding boxes must match ground truth to be considered correct.

**Examples**  
- Project created to detect "combat" badges in images.  
- 15 images uploaded and tagged with bounding boxes around combat badges.  
- Some images with low contrast or cluttered backgrounds were harder to detect.  
- Model tested on new images, successfully detecting most badges except some false positives or missed detections.  
- Adjusting the probability threshold affected detection sensitivity.

**Key Takeaways 🎯**  
- Understand the difference between classification and object detection in Custom Vision.  
- Know the importance of tagging images with bounding boxes for object detection training.  
- Remember key evaluation metrics: precision, recall, and mean average precision (mAP).  
- Be aware that image quality (contrast, clarity) impacts detection performance.  
- Threshold settings are crucial for balancing detection sensitivity and accuracy.  
- Manual bounding box annotation may be necessary if automatic detection misses objects.  
- Custom Vision provides an easy-to-use interface for training and testing object detection models.

---

## Face Service

**Timestamp**: 02:51:18 – 02:54:30

**Key Concepts**  
- Face Service is part of the Azure Computer Vision API.  
- Requires installation of the Computer Vision package and use of the Face Client.  
- Authentication is done using Cognitive Service credentials and keys.  
- Detects faces in images and returns face IDs and bounding boxes (face rectangles).  
- Can also return detailed face attributes such as age, emotion, makeup, and gender if the image resolution is sufficient.  
- Attributes are returned as a dictionary and can be iterated over for display or processing.  

**Definitions**  
- **Face Client**: A client object used to interact with the Face Service API for face detection and analysis.  
- **Face ID**: A unique identifier assigned to each detected face in an image.  
- **Face Rectangle**: The bounding box coordinates (top, left, width, height) around a detected face.  
- **Face Attributes**: Additional information about detected faces such as age, emotion, gender, and makeup.  

**Key Facts**  
- The Face Service requires a sufficiently large image to detect detailed attributes; low-resolution images may not process attributes.  
- The bounding box is drawn on the image with a magenta line (line thickness can be adjusted, e.g., to 3).  
- Example detected age was approximately 44 years old.  
- Gender detection is based on presentation; e.g., an android character was detected as male presenting.  
- Makeup detection focuses on lips and eyes; some makeup types (like eyeshadow) may not be detected.  
- Emotion detection can show percentages for emotions such as sadness or neutrality.  

**Examples**  
- Used the same image as in the Computer Vision example to detect one face and draw a bounding box with the face ID annotated.  
- Switched to a higher resolution image to successfully detect face attributes including age, gender, and makeup.  
- Example showed an android character with approximate age 44, male presenting, no detected makeup on lips/eyes, and mostly neutral emotion.  

**Key Takeaways 🎯**  
- Always ensure the image resolution is high enough to detect detailed face attributes; otherwise, only face detection (IDs and rectangles) will work.  
- The Face Service API returns face rectangles and unique face IDs that can be used for annotation and further processing.  
- Face attributes are optional parameters in the detection call and must be explicitly requested.  
- Understanding the structure of returned data (face objects, attributes dictionary) is important for extracting and displaying information.  
- Adjust visualization parameters (like bounding box color and thickness) for clarity when displaying results.

---

## Form Recognizer

**Timestamp**: 02:54:30 – 02:58:01

**Key Concepts**  
- Azure AI Form Recognizer is a cognitive service designed to identify and extract structured data from forms, such as receipts.  
- It converts form content into readable, structured data fields.  
- The service has predefined fields for certain form types (e.g., receipts) like merchant name, phone number, total price, etc.  
- Uses a client with Azure key credential (not the cognitive service credential used by other services).  
- The process involves calling `begin_recognize_receipt` to analyze receipt data.  
- Extracted fields include labels and values, which can be accessed programmatically.  

**Definitions**  
- **Azure AI Form Recognizer**: A specialized Azure cognitive service that extracts key-value pairs and structured data from forms such as receipts, business cards, and invoices.  
- **Predefined fields**: Specific data points that Form Recognizer is trained to extract automatically from certain form types (e.g., merchant name, phone number, total price on receipts).  

**Key Facts**  
- Form Recognizer requires the use of `AzureKeyCredential` for authentication, unlike other cognitive services that use `CognitiveServiceCredential`.  
- The receipt recognition method is `begin_recognize_receipt`.  
- Predefined receipt fields include: receipt type, merchant name, merchant phone number, total price, etc.  
- Some field names may contain spaces (e.g., "total price"), which can cause issues when accessing them programmatically.  
- The service may not always extract every field perfectly; some trial and error may be needed to find the correct field keys.  

**Examples**  
- Extracting merchant name from a receipt: The field "Merchant Name" returned "Alamo Draft Out Cinema".  
- Attempting to extract total price using different keys like "total price", "price", and "total" to find the correct field key. "total" worked in the example.  
- Extracting merchant phone number successfully using the predefined field.  

**Key Takeaways 🎯**  
- Remember that Form Recognizer uses `AzureKeyCredential` for authentication, which differs from other Azure Cognitive Services.  
- Use `begin_recognize_receipt` to analyze receipt images and extract structured data.  
- Predefined fields exist for common form types; familiarize yourself with these to access data correctly.  
- Field names may have spaces or unexpected formatting—test different keys if a field returns `None`.  
- The service is useful but may require some experimentation to get the desired data fields.  
- Always check the returned fields dictionary to understand what data is available and how it is labeled.

---

## OCR

**Timestamp**: 02:58:01 – 03:02:54

**Key Concepts**  
- OCR (Optical Character Recognition) capabilities are part of Azure Computer Vision services.  
- Two main OCR approaches in Azure Computer Vision:  
  - **Recognize Printed Text in Stream**: suitable for simple, smaller amounts of printed text, synchronous processing.  
  - **Read API**: designed for larger amounts of text, asynchronous processing, more efficient and accurate for complex documents.  
- OCR can process both printed and handwritten text, though handwritten text recognition is more challenging and less accurate.  
- Image quality (resolution, font style, artifacts) significantly affects OCR accuracy.

**Definitions**  
- **OCR (Optical Character Recognition)**: Technology that extracts text from images.  
- **Recognize Printed Text in Stream**: A synchronous OCR method for extracting printed text from images.  
- **Read API**: An asynchronous OCR method designed for processing larger or more complex text documents, providing better accuracy and efficiency.

**Key Facts**  
- Poor image quality or unusual fonts (e.g., Star Trek font) reduce OCR accuracy.  
- The Read API processes text line-by-line asynchronously, improving performance on large texts.  
- Handwritten text recognition is possible but often produces imperfect results due to handwriting variability.  
- Example handwritten note by William Shatner was difficult to read manually but OCR provided a better transcription, though still imperfect.

**Examples**  
- Extracting text from images related to Star Trek titles:  
  - First image with low resolution and artifacts returned poor results.  
  - Second image with better quality extracted more text (e.g., "Deep Space Nine," "Nana Visitor," "Tells All").  
- Handwritten note from William Shatner to a fan: OCR was able to transcribe better than human reading despite poor handwriting.

**Key Takeaways 🎯**  
- Understand the difference between the synchronous Recognize Printed Text method and the asynchronous Read API for OCR tasks.  
- Use the Read API for larger documents or when asynchronous processing is needed for better efficiency and accuracy.  
- Image quality and font style are critical factors influencing OCR success—high resolution and clear fonts improve results.  
- Handwritten text recognition is supported but expect lower accuracy; OCR can still outperform manual reading in difficult cases.  
- Be familiar with loading credentials, creating clients, and calling OCR functions in Azure Computer Vision for practical implementation.

---

## Text Analysis

**Timestamp**: 03:02:54 – 03:06:37

**Key Concepts**  
- Using Azure Cognitive Services Language Text Analytics to analyze text data.  
- Sentiment analysis to determine if reviews are positive or negative.  
- Extracting key phrases from text to identify important topics or themes.  
- Loading and processing multiple text files (movie reviews) for analysis.  
- Correlating sentiment scores with actual review content for validation.

**Definitions**  
- **Text Analytics**: A cognitive service that processes natural language text to extract insights such as sentiment, key phrases, and other language features.  
- **Sentiment Analysis**: The process of determining the emotional tone behind a body of text, typically classified as positive, negative, or neutral.  
- **Key Phrases**: Significant words or phrases extracted from text that highlight important topics or concepts within the content.

**Key Facts**  
- Sentiment scores above 5 are considered positive; below 5 are negative.  
- Example sentiment scores mentioned: 9 (very positive), 1 (very negative), 4 (neutral/low).  
- Key phrases extracted included terms like "Borg ship," "Enterprise," "Neutral zone," "Sophisticated Science Fiction," "Wealth of Unrealized Potential."  
- Text Analytics requires setting up credentials and clients similar to other Azure Cognitive Services.  
- Blank or missing text files can cause empty results in analysis.

**Examples**  
- Movie reviews of *Star Trek: First Contact* were analyzed.  
- Key phrases such as "Borg ship," "Enterprise," and "Neutral zone" frequently appeared, indicating important themes.  
- Sentiment analysis was run on multiple reviews, with scores reflecting the reviewers’ opinions (e.g., 9 for very positive, 1 for very negative).  
- Some reviews were synopses rather than opinionated, showing limitations of sentiment analysis without explicit sentiment language.

**Key Takeaways 🎯**  
- Understand how to use Azure Text Analytics to extract sentiment and key phrases from text data.  
- Remember the sentiment scoring threshold: >5 positive, <5 negative.  
- Be aware that not all text inputs will contain sentiment (e.g., synopses or blank files).  
- Key phrase extraction helps identify recurring themes or important concepts in text.  
- Practical use case: analyzing movie reviews to gauge audience sentiment and highlight key discussion points.  
- Always validate sentiment results by reviewing the original text when possible.

---

## QnAMaker

**Timestamp**: 03:06:37 – 03:25:11

**Key Concepts**  
- QnAMaker is a no-code/low-code Azure Cognitive Service to build question-and-answer bots.  
- It uses knowledge bases created from documents or FAQs to provide answers to user queries.  
- QnAMaker service must be created in Azure before building a knowledge base.  
- Knowledge bases can be populated with various document formats following specific formatting guidelines (headings and answers).  
- Supports chit-chat and multi-turn conversational flows using follow-up prompts to link Q&A pairs.  
- Once published, the QnAMaker knowledge base can be integrated with Azure Bot Service for multi-channel deployment.  
- Azure Bot Service allows connecting the QnAMaker bot to multiple channels like Teams, Slack, Web Chat, Facebook, Telegram, and more.  
- Bot source code can be downloaded (Node.js example shown) for further customization or integration.  
- Simple integration can be done via embed code (iframe) with a secret key for authentication.

**Definitions**  
- **QnAMaker**: An Azure Cognitive Service that enables creation of a question-and-answer bot by building a knowledge base from documents or FAQs without heavy coding.  
- **Knowledge Base (KB)**: A collection of question-and-answer pairs that QnAMaker uses to respond to user queries.  
- **Chit-chat**: Predefined casual conversation pairs included in QnAMaker to handle small talk or irrelevant questions.  
- **Follow-up Prompts**: Links between Q&A pairs that enable multi-turn conversations, guiding users through related questions.  
- **Azure Bot Service**: A platform to host, manage, and connect bots to multiple communication channels.

**Key Facts**  
- QnAMaker service creation can take up to 10 minutes to provision and be ready.  
- Free tier available for QnAMaker service and Azure Bot Service (F0 tier).  
- QnAMaker can ingest multiple file types and uses headings to identify questions and answers.  
- Example knowledge base included AWS and Azure certification questions (e.g., number of AWS certifications: 11; Azure fundamental certifications: 4).  
- Multi-turn conversation requires context-aware prompts ("context only" setting).  
- Bot channels supported include Teams, Slack, Skype, Telegram, Facebook, Web Chat, Alexa, Twilio, and more.  
- Bot source code can be downloaded as a zip file, typically in Node.js if selected.  
- Embed code requires replacing a secret key to authenticate the bot in external apps or notebooks.

**Examples**  
- Created a knowledge base with certification-related Q&A:  
  - "How many AWS certifications are there?" → 11  
  - "How many Azure fundamental certifications are there?" → 4 (DP-900, AI-900, AZ-900, SC-900)  
  - "Which is the hardest Azure Associate certification?" → AZ-104 (Azure Administrator)  
  - Comparison question: "Which is harder, AWS or Azure certifications?" → Opinion: Azure certifications are harder due to exact implementation steps.  
- Demonstrated adding follow-up prompts for multi-turn Q&A (e.g., after asking about certifications, user can select AWS or Azure to get specific answers).  
- Tested QnAMaker bot via web chat channel and embedded it in a Jupyter notebook using iframe and secret key.

**Key Takeaways 🎯**  
- Understand that QnAMaker is designed for quick, low-code creation of Q&A bots using knowledge bases.  
- Know the process: create QnAMaker service in Azure → build knowledge base (upload docs or enter Q&A pairs) → train and publish → connect to Azure Bot Service → deploy on channels.  
- Remember the importance of formatting knowledge base documents correctly (headings as questions, text as answers).  
- Multi-turn conversations require follow-up prompts and context-aware settings to guide users through related questions.  
- Azure Bot Service integration expands bot usability across many platforms and supports downloading source code for customization.  
- Free tiers exist for both QnAMaker and Azure Bot Service, useful for learning and small projects.  
- Embedding the bot via iframe is a simple way to integrate QnAMaker into web apps or notebooks, but requires managing secret keys securely.  
- Be aware of some limitations: QnAMaker may infer answers when questions are ambiguous; careful Q&A design improves accuracy.  
- For more advanced natural language understanding beyond QnAMaker, consider using LUIS (Language Understanding Intelligent Service).

---

## LUIS

**Timestamp**: 03:25:11 – 03:30:56

**Key Concepts**  
- LUIS stands for Language Understanding Intelligent Service, a cognitive service for building language understanding into bots.  
- LUIS is accessed via the external domain luis.ai, though it is part of Azure services.  
- LUIS uses intents and entities to interpret user input and extract meaningful data.  
- Intents represent the purpose or goal of a user’s utterance (e.g., booking a flight).  
- Entities represent specific data points within an utterance (e.g., location, date).  
- LUIS models require training with example utterances to improve accuracy.  
- After training, models can be tested and published to production endpoints for integration.  
- LUIS supports different entity types: machine-learned entities and list entities (static lists).  
- Region selection for authoring and cognitive services resource is important to avoid creating duplicate resources.  

**Definitions**  
- **LUIS (Language Understanding Intelligent Service)**: A Microsoft Azure cognitive service that enables developers to build natural language understanding into applications, bots, and IoT devices.  
- **Intent**: The goal or action the user wants to perform, identified from their input.  
- **Entity**: A specific piece of information extracted from the user’s input that provides details related to the intent.  
- **Machine-learned Entity**: An entity type that is identified by the model through training on example utterances.  
- **List Entity**: A predefined list of possible values for an entity that remains static (e.g., list of airports).  

**Key Facts**  
- LUIS requires an Azure Cognitive Services resource for authoring and runtime.  
- The authoring resource must be in a supported region (e.g., West US) to appear in the LUIS portal.  
- Example intent used: "book flight" or "flight booking."  
- Example utterance: "book me a flight to Toronto" or "book me a flight to Seattle."  
- After creating intents and entities, the model must be trained before testing.  
- The LUIS portal provides confidence scores (top scoring intent) when testing utterances.  
- Once satisfied, the model is published to a production slot and an endpoint URL is provided for integration.  

**Examples**  
- Creating an intent named "book flight" with example utterance: "book me a flight to Toronto."  
- Creating an entity named "location" to capture destination information.  
- Using a list entity to represent airports or fixed values.  
- Testing the model with the utterance: "book me a flight to Seattle," which returns the intent "book flight" with a confidence score.  

**Key Takeaways 🎯**  
- Understand the difference between intents and entities and their roles in LUIS.  
- Know how to create and train a simple LUIS model with intents and entities.  
- Remember to select the correct Azure region for your cognitive services resource to avoid duplication.  
- Be able to interpret the confidence score from LUIS testing to evaluate intent recognition.  
- Know the workflow: create intents/entities → train model → test → publish → use endpoint.  
- LUIS is essential for building robust conversational bots that understand natural language inputs.  
- For exam purposes, focus on the basic setup and usage of LUIS rather than complex configurations.

---

## AutoML

**Timestamp**: 03:30:56 – 03:48:13

**Key Concepts**  
- Automated Machine Learning (AutoML) automates the process of building ML pipelines, requiring minimal manual intervention.  
- AutoML selects the appropriate model type (e.g., regression, classification) based on the target variable.  
- AutoML performs automatic featurization, including feature selection and data preprocessing (handling missing data, high cardinality, dimensionality reduction).  
- Training time and primary evaluation metrics can be configured in AutoML experiments.  
- AutoML runs multiple models/algorithms and selects the best performing candidate (e.g., ensemble models).  
- Models created by AutoML can be deployed as endpoints using Azure Kubernetes Service (AKS) or Azure Container Instances (ACI).  
- Compute clusters (dedicated or low priority) are required to run AutoML experiments; GPU compute may speed up deep learning models but is not always necessary.  
- Feature importance and model performance metrics are available post-run to interpret model behavior.  

**Definitions**  
- **AutoML (Automated Machine Learning)**: A process/tool that automatically builds and tunes machine learning models and pipelines with minimal user input.  
- **Compute Cluster**: A set of virtual machines provisioned to run machine learning training jobs in Azure ML.  
- **Primary Metric**: The main evaluation metric AutoML uses to select the best model (e.g., normalized root mean squared error for regression).  
- **Ensemble Model**: A model that combines predictions from multiple weaker models to improve accuracy.  
- **Featurization**: Automatic feature engineering steps including selection, scaling, and handling missing or high cardinality data.  
- **Azure Kubernetes Service (AKS)**: A managed Kubernetes container orchestration service used for deploying scalable ML model endpoints.  
- **Azure Container Instance (ACI)**: A simpler container hosting service for deploying ML models without managing Kubernetes.  

**Key Facts**  
- The diabetes dataset used contains 422 samples with 10 features, commonly used for ML practice.  
- AutoML can automatically detect problem type: regression (continuous numeric target) or classification (binary/multi-class).  
- Training timeout can be set (default example: 3 hours), but actual runs may take about 1 hour on CPU-based compute.  
- Primary metric for regression in this example: normalized root mean squared error (RMSE).  
- AutoML ran about 42 different models in the example.  
- Ensemble models were selected as the best performing candidate in this run.  
- Dedicated compute clusters preferred over low priority for reliability (low priority nodes can be preempted).  
- GPU compute may speed up deep learning models but not necessarily statistical models.  
- Deployment to AKS requires meeting minimum resource quotas (e.g., total cores ≥ 12).  
- Deployment to ACI is simpler and does not require complex quota considerations.  

**Examples**  
- Using the diabetes dataset to predict a numeric outcome (likelihood of diabetes) with AutoML.  
- AutoML automatically choosing regression based on the continuous target variable.  
- Running AutoML on a dedicated CPU cluster, taking about 1 hour to complete.  
- AutoML testing 42 different models and selecting a voting ensemble as the best model.  
- Deploying the best AutoML model to Azure Container Instance (ACI) for inference.  
- Testing the deployed model by inputting sample feature values (e.g., age, BMI, BP, S1-S5) and receiving a prediction result (e.g., 168).  

**Key Takeaways 🎯**  
- Understand that AutoML automates the entire ML pipeline, including model selection, feature engineering, and training.  
- Know the difference between regression and classification and how AutoML detects this automatically.  
- Remember the primary metric used for regression problems in AutoML is often normalized root mean squared error (RMSE).  
- Be aware that AutoML runs multiple models and selects the best performing one, often an ensemble model.  
- Know the difference between compute cluster types (dedicated vs low priority) and their impact on job reliability.  
- Deployment options include AKS (more complex, scalable) and ACI (simpler, easier to deploy).  
- Quotas and resource requirements can affect deployment; ACI is easier for quick deployments without quota issues.  
- Feature importance and model performance insights are available post-training to help interpret models.  
- For exam purposes, focus on the concepts of AutoML automation, model selection, metrics, and deployment options rather than deep ML algorithm details.

---

## Designer

**Timestamp**: 03:48:13 – 03:58:31

**Key Concepts**  
- Azure Machine Learning Designer provides a visual, drag-and-drop interface to build ML pipelines without extensive coding.  
- Designer is useful for users who want more customization than AutoML but prefer a simpler approach than full coding.  
- Pre-built sample pipelines are available for various tasks: binary classification, multi-class classification, text classification, etc.  
- Pipelines typically include data preprocessing (e.g., column selection, cleaning missing data), data splitting (train/test), model training, hyperparameter tuning, scoring, and evaluation.  
- Compute targets must be selected or created to run Designer pipelines.  
- After training, models can be deployed via inference pipelines for real-time or batch scoring.  
- Deployment options include Azure Kubernetes Service (AKS) and Azure Container Instances (ACI), with ACI being simpler and faster to deploy.  
- Endpoints created from deployed models can be tested with sample data to verify scoring outputs.  

**Definitions**  
- **Designer**: A visual drag-and-drop tool in Azure ML for building, training, and deploying machine learning pipelines with minimal coding.  
- **Inference Pipeline**: A pipeline specifically designed for deploying a trained model to perform real-time or batch predictions (scoring).  
- **Compute Target**: The cloud resource (VM or cluster) where training or inference jobs run.  
- **Binary Classification**: A classification task where the output is one of two classes.  
- **SMOTE**: Synthetic Minority Over-sampling Technique, used to handle imbalanced datasets (mentioned as part of sample pipelines).  

**Key Facts**  
- Sample Designer pipeline run took approximately 14 minutes and 22 seconds.  
- Designer pipelines include steps such as:  
  - Select columns (exclude irrelevant features)  
  - Clean missing data (custom substitution values may be used)  
  - Split data into training and testing sets with randomization  
  - Hyperparameter tuning automatically searches for best model parameters  
  - Model training (e.g., two-class decision tree)  
  - Model scoring and evaluation  
- Deployment options:  
  - Azure Kubernetes Service (AKS) – more complex, longer startup time  
  - Azure Container Instance (ACI) – simpler, faster deployment  
- After deployment, endpoints can be tested with pre-loaded sample data, returning scored labels and probabilities.  

**Examples**  
- Using a binary classification sample pipeline that includes feature selection, data cleaning, splitting, model tuning, and evaluation.  
- Creating a new compute target named "binary pipeline" for running the Designer experiment.  
- Deploying the trained model as a real-time inference pipeline using Azure Container Instance.  
- Testing the deployed endpoint with sample input data and receiving scored labels and probabilities as output.  

**Key Takeaways 🎯**  
- Know the purpose and workflow of Azure ML Designer: build, train, tune, evaluate, and deploy ML models visually.  
- Understand the typical pipeline steps: data selection, cleaning, splitting, training, tuning, scoring, and evaluation.  
- Be familiar with deployment options (AKS vs. ACI) and when to use each.  
- Remember that Designer supports both training pipelines and separate inference pipelines for deployment.  
- Recognize that Designer is suitable for users who want more control than AutoML but less complexity than full coding.  
- For the exam, focus on the Designer’s role in the ML lifecycle, pipeline components, and deployment basics rather than deep technical details.  
- Testing endpoints with sample data is a key step to verify deployed models.

---

## MNIST

**Timestamp**: 03:58:31 – 04:18:10

**Key Concepts**  
- MNIST dataset is a popular computer vision dataset for handwritten digit recognition.  
- Training an ML model programmatically using Azure Machine Learning SDK in a Jupyter notebook.  
- Workflow involves connecting to an Azure ML workspace, creating experiments, and provisioning compute clusters.  
- Dataset registration and management in Azure ML workspace for easy retrieval during training.  
- Preparing training scripts, configuring environments, and submitting training jobs to remote compute clusters.  
- Monitoring training jobs via logs and Jupyter widgets.  
- Saving and registering trained models for collaboration and deployment.  
- Deployment involves creating scoring scripts and deploying models to Azure Container Instances (ACI).  
- Confusion matrix as an evaluation tool for classification models (mentioned as exam-relevant).  

**Definitions**  
- **MNIST Dataset**: A dataset of 70,000 grayscale images of handwritten digits (0-9), each image sized 28x28 pixels, used for multi-class classification tasks.  
- **Workspace**: An Azure ML resource that contains experiments, datasets, compute targets, and models.  
- **Experiment**: A logical grouping of runs (training jobs) in Azure ML to track and compare results.  
- **Compute Cluster**: Managed Azure ML compute resource (e.g., CPU cluster with Standard_D2_v2 VMs) used to run training jobs remotely.  
- **ScriptRunConfig**: Configuration object specifying the training script, compute target, environment, and parameters for a training job.  
- **Docker Image**: Container image built to match the Python environment for running training jobs in Azure ML.  
- **Model Registration**: Process of saving a trained model in the Azure ML workspace for versioning and sharing.  
- **Confusion Matrix**: A table used to evaluate the performance of a classification model by showing true vs predicted labels.  

**Key Facts**  
- MNIST dataset contains 70,000 images, each 28x28 pixels, grayscale, digits 0-9.  
- Azure ML SDK version used: 1.28.0 (Python 3.6 environment mentioned).  
- Compute cluster creation takes about 5 minutes; Standard_D2_v2 VM size is commonly used for CPU clusters.  
- Training script uses scikit-learn with logistic regression for multi-class classification.  
- Accuracy metric is used to evaluate model performance (example accuracy ~0.9 reported).  
- Training jobs run inside Docker containers; images are cached for faster subsequent runs.  
- Outputs (e.g., model files) are saved in the run’s outputs directory and accessible via workspace.  
- Model files saved as .pkl (pickle) files when using scikit-learn.  
- Monitoring can be done via Jupyter widgets or Azure ML portal logs.  
- Deployment steps include creating scoring scripts and deploying to Azure Container Instances (ACI).  
- Confusion matrix is an important evaluation tool and may appear on exams.  

**Examples**  
- Running the MNIST training notebook in JupyterLab using Azure ML SDK.  
- Creating a CPU cluster with 0-4 nodes using Standard_D2_v2 VM size.  
- Loading MNIST data from compressed ubyte.gz files, splitting into train/test sets.  
- Training a logistic regression model on MNIST using scikit-learn.  
- Submitting the training job to the remote compute cluster and monitoring progress.  
- Registering the trained model in Azure ML workspace for collaboration.  
- Brief mention of deploying the model to ACI and testing it with a scoring script.  

**Key Takeaways 🎯**  
- Understand the MNIST dataset characteristics and its use case in multi-class image classification.  
- Know the Azure ML workflow: workspace connection → experiment creation → compute provisioning → dataset registration → training script preparation → job submission → monitoring → model registration → deployment.  
- Be familiar with key Azure ML components: workspace, experiment, compute cluster, ScriptRunConfig, environment, and model registry.  
- Remember that training jobs run inside Docker containers, and image creation happens once per environment.  
- Know how to monitor training jobs via logs and Jupyter widgets.  
- Recognize the importance of saving and registering models for reuse and collaboration.  
- Confusion matrix is a critical evaluation metric for classification models and may be tested on exams.  
- Deployment to Azure Container Instances (ACI) involves creating scoring scripts and testing the deployed model.  
- Practical familiarity with scikit-learn logistic regression on MNIST is useful for exam scenarios involving Azure ML SDK.

---

## Data Labeling

**Timestamp**: 04:18:10 – 04:22:38

**Key Concepts**  
- Creating a data labeling project in Azure Machine Learning Studio  
- Choosing the type of labeling task: multi-class, multi-label, bounding box, segmentation  
- Uploading datasets (images or text) for labeling  
- Defining labels/classes for the dataset  
- Manual labeling of data points (images) within the project  
- Exporting labeled datasets in various formats (CSV, COCO, Azure ML dataset)  
- Collaboration by granting access to others for labeling tasks  

**Definitions**  
- **Data Labeling**: The process of annotating data (e.g., images or text) with labels or tags that identify the content, used for supervised machine learning.  
- **Multi-class labeling**: Assigning one label from multiple possible classes to each data point.  
- **Auto-enabled assistant labeler**: An optional feature that can automatically label data points (disabled in the example).  

**Key Facts**  
- Dataset example: 17 image files from a Star Trek-themed dataset  
- Labels used: TNG, DS-9, Voyager, Toss (Star Trek series names)  
- The dataset is periodically checked for new data points which are added as labeling tasks  
- Labeling interface allows adjustments like changing contrast or rotating images for better visibility  
- Export options include CSV, COCO format, and Azure ML dataset format for easy reuse  
- Labeled data appears as a new labeled dataset in Azure ML Studio after export  

**Examples**  
- Created a labeling project named "my labeling project"  
- Selected multi-class classification for labeling Star Trek series images  
- Uploaded 17 image files from a folder named "objects"  
- Manually labeled each image with the appropriate Star Trek series label (e.g., Voyager, TNG, DS9, Toss)  
- Exported the labeled dataset back into Azure ML for further use  

**Key Takeaways 🎯**  
- Understand how to create and configure a data labeling project in Azure ML Studio  
- Know the difference between multi-class and multi-label classification in labeling tasks  
- Be familiar with the process of uploading datasets and defining labels  
- Remember that manual labeling can be supplemented by an auto-labeling assistant (optional)  
- Know how to export labeled data in different formats for downstream ML workflows  
- Recognize that labeled datasets can be reused and shared within Azure ML Studio  
- Practical familiarity with the labeling UI features (contrast, rotate) can improve labeling accuracy  
- Exam may test knowledge of data labeling workflow and export options in Azure ML

---

## Clean up

**Timestamp**: 04:22:38 – unknown

**Key Concepts**  
- Proper resource cleanup after completing Azure Machine Learning projects  
- Manual deletion of compute resources and resource groups to avoid unnecessary charges  
- Verification of all running resources to ensure complete cleanup  

**Definitions**  
- **Compute**: The cloud-based virtual machines or clusters used to run machine learning experiments and jobs.  
- **Resource Group**: A container in Azure that holds related resources for an Azure solution, allowing for easier management and deletion.  
- **Container Registry**: A service in Azure used to store and manage container images, which may be created during ML workflows.  

**Key Facts**  
- After finishing with Azure Machine Learning, compute resources can be manually deleted to free up costs.  
- Deleting the resource group will remove all resources contained within it, including compute and container registries.  
- It is recommended to double-check "All Resources" in the Azure portal to ensure no active resources remain.  

**Examples**  
- Manually deleting compute services before deleting the resource group as a cautious approach.  
- Checking the container registry within the resource group to confirm it is included in the deletion process.  

**Key Takeaways 🎯**  
- Always clean up compute resources and resource groups after completing ML projects to avoid unnecessary charges.  
- Use the Azure portal’s resource group deletion feature to remove all related resources at once.  
- Double-check the "All Resources" view in Azure portal to confirm no resources are left running.  
- Being "paranoid" and manually deleting resources before deleting the resource group is a good practice for thorough cleanup.
