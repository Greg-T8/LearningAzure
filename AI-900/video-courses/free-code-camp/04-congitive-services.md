# Congitive Services

**Channel:** freeCodeCamp.org
**Duration:** 4:23:51
**URL:** https://www.youtube.com/watch?v=hHjmr_YOqnU

---

## Azure Cognitive Services

**Timestamp**: 00:57:33 – 00:59:41

**Key Concepts**  
- Azure Cognitive Services is a comprehensive family of AI services and cognitive APIs designed to help build intelligent applications.  
- Services include customizable pre-trained models that can be deployed from cloud to edge using containers.  
- No machine learning expertise is strictly required to get started, but some background knowledge is beneficial.  
- Microsoft emphasizes responsible AI with strict ethical standards and industry-leading tools and guidelines.  
- Cognitive Services are grouped into categories: Decision, Language, Speech, and Vision.  
- Access to these services is managed via an AI key and API endpoint generated when creating a Cognitive Service resource.

**Definitions**  
- **Azure Cognitive Services**: A suite of AI services and APIs that enable developers to add intelligent features to their apps without deep AI or ML expertise.  
- **Decision Services**: AI tools that help make decisions, e.g., anomaly detection, content moderation, and personalization.  
- **Language Services**: APIs for natural language understanding, sentiment analysis, translation, and Q&A layers.  
- **Speech Services**: Convert speech to text, text to speech, real-time speech translation, and speaker recognition.  
- **Vision Services**: Analyze images and videos, customize image recognition, detect faces and emotions.  
- **AI Key and Endpoint**: Credentials generated when creating a Cognitive Service resource, used for authenticating API calls.

**Key Facts**  
- Cognitive Services can be deployed anywhere from cloud to edge using containers.  
- Language services support over 90 languages for translation.  
- Speech services include speech-to-text, text-to-speech, speech translation, and speaker recognition.  
- Vision services include computer vision, custom vision, and face detection with emotion recognition.  
- Creating a Cognitive Service resource generates two keys and an endpoint for authentication.  
- Knowledge mining is an AI discipline that uses multiple intelligent services to extract insights from large data sets.

**Examples**  
- Decision: Anomaly Detector (detect potential problems early), Content Moderator (detect offensive content), Personalizer (create personalized experiences).  
- Language: LUIS (Language Understanding Intelligent Service), Q&A Maker, Text Analytics (sentiment detection).  
- Speech: Speech-to-text transcription, Text-to-speech conversion, Real-time speech translation, Speaker recognition.  
- Vision: Computer Vision (analyze images/videos), Custom Vision (custom image recognition), Face detection and emotion recognition.

**Key Takeaways 🎯**  
- Know the four main categories of Azure Cognitive Services: Decision, Language, Speech, Vision.  
- Understand that Cognitive Services provide pre-built AI models accessible via API with minimal ML expertise required.  
- Remember that authentication uses keys and endpoints generated per Cognitive Service resource.  
- Be aware of the ethical and responsible AI emphasis by Microsoft in these services.  
- Recognize common use cases like anomaly detection, content moderation, sentiment analysis, translation, speech transcription, and image analysis.  
- Knowledge mining leverages these services collectively to extract insights from large datasets—important for exam scenarios involving AI data exploration.

---

## Congitive API Key and Endpoint

**Timestamp**: 00:59:41 – 01:00:08

**Key Concepts**  
- Azure Cognitive Services acts as an umbrella AI service providing access to multiple AI capabilities.  
- Authentication to these AI services is done using an API key and an endpoint.  
- When you create a new Cognitive Service resource, two keys and one endpoint are generated automatically.  
- These keys and endpoint are essential for programmatic access and authentication to the AI services.

**Definitions**  
- **Azure Cognitive Services**: A collection of AI services accessible via a single API key and endpoint that enable various AI functionalities such as vision, speech, language, and decision-making.  
- **API Key**: A security token used to authenticate requests to Azure Cognitive Services.  
- **Endpoint**: The URL or address where the Cognitive Service API can be accessed.

**Key Facts**  
- Creating a new Cognitive Service resource generates:  
  - Two API keys  
  - One API endpoint  
- These credentials are required for authenticating and using the AI services programmatically.

**Examples**  
- None mentioned explicitly in this segment.

**Key Takeaways 🎯**  
- Always remember that to use Azure Cognitive Services, you must create a Cognitive Service resource first.  
- The resource creation process provides you with two keys and an endpoint—these are mandatory for authentication.  
- Keep your API keys secure as they grant access to the AI services.  
- Understanding the role of the API key and endpoint is critical for integrating AI capabilities into applications.

---

## Knowledge Mining

**Timestamp**: 01:00:08 – 01:04:42

**Key Concepts**  
- Knowledge mining is an AI discipline that combines intelligent services to quickly learn from vast amounts of information.  
- It enables organizations to deeply understand, explore, and uncover hidden insights, relationships, and patterns at scale.  
- The knowledge mining process involves three main steps:  
  1. **Ingest** – Collect content from a variety of sources (structured, semi-structured, unstructured).  
  2. **Enrich** – Use AI capabilities (cognitive services) to extract information, find patterns, and deepen understanding.  
  3. **Explore** – Access and analyze the enriched data via search indexes, bots, applications, and visualizations.  

**Definitions**  
- **Knowledge Mining**: The process of using AI and cognitive services to ingest, enrich, and explore large volumes of data to extract meaningful insights and patterns.  
- **Cognitive Services**: Prebuilt AI services in Azure that provide vision, language, speech, decision, and search capabilities to enrich data.  
- **Search Index**: A structured repository of enriched data that enables fast and relevant search queries and exploration.  

**Key Facts**  
- Azure Cognitive Services provides two keys and an endpoint for authentication to access AI services programmatically.  
- Data sources for ingestion include:  
  - Structured data (e.g., databases, CSV files)  
  - Unstructured data (e.g., PDFs, videos, images, audio)  
- Enrichment can include AI tasks such as printed text recognition, key phrase extraction, clause extraction, language detection, and automated translation.  
- Enriched data can be integrated into business applications, CRM systems, Power BI dashboards, or Word plug-ins for further use.  

**Examples**  
- **Content Research**: Employees use knowledge mining to quickly review dense technical documents by extracting key phrases and technical keywords, making research more efficient.  
- **Audit, Risk, and Compliance Management**: Attorneys use knowledge mining to identify important entities and clauses in discovery documents, flagging GDPR risks and other compliance issues.  
- **Business Process Management**: Companies use knowledge mining to process drilling and completion reports with AI document processors and custom models, enabling intelligent automation and analytics.  
- **Customer Support and Feedback Analysis**: Customer support teams leverage knowledge mining to find answers quickly and assess customer sentiment at scale using enriched documents and search indexes.  
- **Digital Asset Management**: Organizations tag and extract metadata from images (e.g., geo points, biographical data, object detection) to create searchable art explorers.  
- **Contract Management**: Knowledge mining helps companies analyze thousands of pages of RFPs and contracts by extracting risk, key phrases, organizational data, and engineering standards to create accurate bids.  

**Key Takeaways 🎯**  
- Remember the three core steps of knowledge mining: ingest, enrich, and explore.  
- Know that Azure Cognitive Services provide the AI capabilities needed for enrichment, including vision, language, speech, decision, and search.  
- Understand that knowledge mining is used across multiple industries and scenarios such as research, compliance, business processes, customer support, digital asset management, and contract management.  
- Be familiar with the types of data ingested (structured, semi-structured, unstructured) and common enrichment techniques (text recognition, key phrase extraction, clause classification).  
- Search indexes are critical for enabling fast, scalable exploration and integration into business tools and analytics platforms.  
- Practical use cases often combine prebuilt cognitive skills with custom AI models and human validation for accuracy and automation.

---

## Face Service

**Timestamp**: 01:04:42 – 01:06:30

**Key Concepts**  
- Azure Face Service uses AI algorithms to detect, recognize, and analyze human faces in images.  
- It can identify faces, face landmarks, attributes, and match faces across a gallery.  
- Provides detailed facial analysis including emotions, accessories, and image quality factors.  

**Definitions**  
- **Face Service**: An Azure AI service that detects and analyzes human faces in images, providing identification, attributes, and landmark data.  
- **Face Landmarks**: Specific predefined points on a face (up to 27) used to identify facial components like eyes, nose, mouth, etc.  
- **Face Attributes**: Characteristics detected on a face such as age, gender, facial hair, accessories, emotions, and image quality indicators (blur, noise, occlusion).  

**Key Facts**  
- Each detected face in an image is assigned a unique identifier string.  
- Up to 27 predefined face landmarks can be detected per face.  
- Attributes detected include:  
  - Accessories (earrings, lip rings)  
  - Age estimation  
  - Blurriness of the image  
  - Emotion detection  
  - Exposure and contrast of the image  
  - Facial hair presence  
  - Gender  
  - Glasses  
  - Hair details  
  - Head pose  
  - Makeup (limited to eye and lip makeup)  
  - Mask wearing detection  
  - Noise/artifacts and occlusion (objects blocking parts of the face)  
  - Boolean smiling detection (smiling or not)  

**Examples**  
- An image processed by Face Service shows bounding boxes around detected faces with unique IDs.  
- Face landmarks highlight specific facial points for detailed analysis.  
- Attribute detection can identify if a person is smiling, wearing glasses, or has makeup.  

**Key Takeaways 🎯**  
- Remember that Face Service provides unique IDs for faces to track them across images or galleries.  
- Up to 27 face landmarks can be used for detailed facial feature analysis.  
- Face attributes cover a wide range of characteristics including emotions and image quality factors—important for nuanced face recognition tasks.  
- Smiling detection is a simple Boolean attribute but commonly used.  
- Makeup detection is limited, mainly to eye and lip makeup.  
- Occlusion and noise detection help assess image quality and reliability of face recognition.  
- Useful for applications requiring detailed face analysis beyond simple detection, such as security, marketing, or user experience personalization.

---

## Speech and Translate Service

**Timestamp**: 01:06:30 – 01:08:04

**Key Concepts**  
- Azure Translate Service: translates text between languages and dialects  
- Neural Machine Translation (NMT) vs Statistical Machine Translation (SMT)  
- Custom Translator: extend translation service for domain-specific language  
- Azure Speech Service: includes speech-to-text, text-to-speech, and speech translation  
- Speech synthesis markup language used for text-to-speech customization  
- Voice assistant integration with Bot Framework SDK  
- Speaker verification and identification features  

**Definitions**  
- **Neural Machine Translation (NMT)**: A modern translation approach using neural networks for higher accuracy, replacing older statistical methods.  
- **Statistical Machine Translation (SMT)**: Legacy translation method based on classical machine learning and statistical models.  
- **Custom Translator**: A feature allowing customization of translation models to better handle specific business domain terminology or phrases.  
- **Speech Synthesis Markup Language (SSML)**: A markup language used to format text input for speech synthesis, enabling voice customization.  

**Key Facts**  
- Azure Translate supports translation of 90 languages and dialects, including Klingon.  
- NMT replaced SMT for improved translation accuracy.  
- Azure Speech Service supports:  
  - Real-time speech-to-text  
  - Batch transcription  
  - Multi-device conversation transcription  
  - Custom speech models  
  - Text-to-speech with custom voices  
  - Voice assistant integration with Bot Framework SDK  
  - Speaker verification and identification  

**Examples**  
- Translation into Klingon highlighted as an interesting fact.  
- Speech-to-text can be used for real-time transcription and multi-device conversations.  
- Text-to-speech uses SSML for voice customization.  

**Key Takeaways 🎯**  
- Remember Azure Translate uses Neural Machine Translation (NMT) for better accuracy over older SMT.  
- Azure Translate supports a wide range of languages (90+), including niche ones like Klingon.  
- Custom Translator is important for adapting translations to specific business domains or technical language.  
- Azure Speech Service is comprehensive: supports speech-to-text, text-to-speech, and speech translation with customization options.  
- SSML is key for customizing text-to-speech output.  
- Integration with Bot Framework SDK enables voice assistants with speaker verification and identification features.  
- Focus on understanding the capabilities and customization options of both Translate and Speech services for exam scenarios.

---

## Text Analytics

**Timestamp**: 01:08:04 – 01:11:02

**Key Concepts**  
- Text Analytics is an NLP (Natural Language Processing) service for text mining and analysis.  
- Performs sentiment analysis to determine opinions about brands or topics.  
- Opinion mining provides aspect-based sentiment analysis for granular opinion details.  
- Key phrase extraction identifies main concepts within larger text.  
- Language detection identifies the language of input text.  
- Named Entity Recognition (NER) detects and categorizes entities such as people, places, objects, quantities.  
- Personally Identifiable Information (PII) detection is a subset of NER.  

**Definitions**  
- **Sentiment Analysis**: Assigns sentiment labels (negative, neutral, positive) and confidence scores to text at sentence and document levels.  
- **Opinion Mining**: Aspect-based sentiment analysis that breaks down opinions by subject and sentiment, providing more detailed insights than general sentiment analysis.  
- **Key Phrase Extraction**: Extracts main concepts or important phrases from larger bodies of text.  
- **Named Entity Recognition (NER)**: Identifies and categorizes entities in unstructured text into semantic types like person, location, diagnosis, medication, etc.  
- **Personally Identifiable Information (PII)**: Sensitive information that can identify an individual, detected as part of NER.  

**Key Facts**  
- Key phrase extraction works best on larger text inputs (up to 5,000 characters per document).  
- Sentiment analysis performs better on smaller text inputs.  
- You can process up to 1,000 items per collection for key phrase extraction.  
- Sentiment labels include: negative, positive, neutral, mixed.  
- Confidence scores for sentiment range from 0 to 1.  
- NER semantic types vary by domain, with generic and health-specific types available.  

**Examples**  
- Key phrase extraction example: From a movie review, phrases like "Borg ship," "enterprise," "surface," "travels" were extracted.  
- NER example: Medical text where words/phrases are tagged as diagnosis, medication class, age, location, person, etc.  
- Sentiment vs. Opinion Mining example: A review where overall sentiment is negative, but opinion mining shows "room was great" (positive) and "staff was unfriendly" (negative), illustrating granular sentiment breakdown.  

**Key Takeaways 🎯**  
- Remember the difference between sentiment analysis (broad, document/sentence level) and opinion mining (granular, aspect-based).  
- Use key phrase extraction for larger documents to identify main concepts quickly.  
- NER is useful for extracting structured data from unstructured text, especially for domain-specific entities.  
- Confidence scores are important to gauge the reliability of sentiment labels.  
- Opinion mining can reveal mixed sentiments within the same text, which basic sentiment analysis might miss.

---

## OCR Computer Vision

**Timestamp**: 01:11:02 – 01:12:22

**Key Concepts**  
- Optical Character Recognition (OCR) is the process of extracting printed or handwritten text into a digital, editable format.  
- OCR can be applied to various sources such as photos of street signs, products, documents, invoices, bills, financial reports, and articles.  
- Azure provides two main OCR-related APIs: the OCR API and the Read API.  

**Definitions**  
- **OCR (Optical Character Recognition)**: Technology that converts different types of text images (printed or handwritten) into machine-encoded text.  
- **OCR API**: An older Azure OCR model that supports only images, executes synchronously, and is easier to implement.  
- **Read API**: A newer Azure OCR model that supports images and PDFs, executes asynchronously, processes text line-by-line for faster results, and is suited for large amounts of text.  

**Key Facts**  
- OCR API:  
  - Uses an older recognition model  
  - Supports images only  
  - Executes synchronously (returns immediately)  
  - Suited for less text  
  - Supports more languages  
  - Easier to implement  
- Read API:  
  - Updated recognition model  
  - Supports images and PDFs  
  - Executes asynchronously  
  - Processes tasks in parallel per line for speed  
  - Suited for large volumes of text  
  - Supports fewer languages  
  - More complex to implement  
- Both APIs are accessed via the Computer Vision SDK.  

**Examples**  
- Extracting nutritional data (nutritional facts) from the back of a food product label.  

**Key Takeaways 🎯**  
- Know the difference between the OCR API and the Read API in Azure Computer Vision, especially their capabilities, execution style (sync vs async), and use cases (small vs large text).  
- Remember that OCR converts images of text into editable digital text, useful for automating data extraction from various document types.  
- The Read API is preferred for larger documents and PDFs due to asynchronous and parallel processing.  
- Implementation complexity and language support differ between the two APIs—OCR API is simpler and supports more languages; Read API is more advanced but supports fewer languages.  
- Use the Computer Vision SDK to interact with these OCR services.

---

## Form Recognizer

**Timestamp**: 01:12:22 – 01:14:48

**Key Concepts**  
- Form Recognizer is a specialized OCR service designed to translate printed text into digital, editable content while preserving the structure and relationships of form-like data.  
- It automates data entry and enhances document search capabilities by identifying key-value pairs, selection marks, and table structures.  
- Outputs include original file relationships, bounding boxes, and confidence scores.  
- Composed of custom document processing models and pre-built models for common document types (invoices, receipts, IDs, business cards).  
- The layout model extracts text, selection marks, and table structures with row and column information using high-definition optical character enhancement.  
- Custom models can be trained with as few as 5 sample forms to tailor extraction to specific form types.  

**Definitions**  
- **Form Recognizer**: A specialized OCR service that converts printed text into editable digital content while preserving the structure and relationships inherent in form-like documents.  
- **Custom Document Processing Models**: Models trained on your own sample forms to extract text, key-value pairs, selection marks, and tabular data specific to your documents.  
- **Pre-built Models**: Ready-to-use models designed for common document types such as invoices, receipts, IDs, and business cards.  
- **Layout Model**: Extracts text, selection marks, and table structures along with bounding box coordinates and row/column data from documents.  

**Key Facts**  
- Form Recognizer supports extraction of:  
  - Key-value pairs  
  - Selection marks  
  - Table structures (with row and column numbers)  
- Outputs include bounding boxes and confidence scores for extracted data.  
- Custom models require only 5 sample input forms to start training.  
- After training, models can be tested, retrained, and used reliably for automated data extraction.  

**Examples**  
- None explicitly mentioned beyond general document types (invoices, receipts, IDs, business cards).  

**Key Takeaways 🎯**  
- Remember that Form Recognizer preserves the structure and relationships in forms, unlike basic OCR.  
- It is ideal for automating data entry and enriching document search by extracting structured data.  
- Custom models allow tailored extraction with minimal training data (5 samples).  
- Outputs include detailed metadata such as bounding boxes and confidence scores, useful for validation.  
- Know the difference between pre-built and custom models and when to use each.  
- The layout model is foundational for extracting text and table structures with spatial context.

---

## Form Recognizer Custom Models

**Timestamp**: 01:14:48 – 01:15:34

**Key Concepts**  
- Custom models in Form Recognizer enable extraction of text, key-value pairs, selection marks, and tabular data from forms.  
- These models are trained specifically with your own data, making them tailored to your form types.  
- Training requires only a small number of sample forms (minimum 5).  
- The output includes structured data preserving relationships from the original document.  
- After training, models can be tested, retrained, and used reliably for automated data extraction.  
- Two learning approaches are available:  
  - Unsupervised learning: Understands layout and relationships between fields without labeled data.  
  - Supervised learning: Uses labeled forms to extract specific values of interest.

**Definitions**  
- **Custom Models**: User-trained Form Recognizer models designed to extract structured data from specific form types using sample input forms.  
- **Unsupervised Learning**: A training method where the model learns layout and field relationships without labeled data.  
- **Supervised Learning**: A training method where the model learns to extract specific data points using labeled examples.

**Key Facts**  
- Minimum of 5 sample forms needed to train a custom model.  
- Custom models output structured data including original document relationships.  
- Two learning options: unsupervised and supervised learning.

**Examples**  
- None specifically mentioned within this time range for custom models.

**Key Takeaways 🎯**  
- Remember that custom models require minimal training data (only 5 samples) to get started.  
- Understand the difference between unsupervised (layout-focused) and supervised (value extraction) learning approaches.  
- Custom models are essential when pre-built models do not fit your specific form types or data extraction needs.  
- After training, always test and retrain your model to improve accuracy before deployment.

---

## Form Recognizer Prebuilt Models

**Timestamp**: 01:15:34 – 01:17:33

**Key Concepts**  
- Form Recognizer offers multiple prebuilt models designed to extract structured data from common document types.  
- These models automatically extract key fields without needing custom training.  
- Prebuilt models cover receipts, business cards, invoices, line items, and IDs.  
- Each model extracts specific fields relevant to the document type.  
- Custom models are used when additional or missing fields need to be extracted beyond what prebuilt models provide.

**Definitions**  
- **Prebuilt Models**: Ready-to-use models in Form Recognizer that extract structured data from common document types without requiring training.  
- **Receipts Model**: Extracts sales receipt data including merchant info, transaction details, and itemized purchases.  
- **Business Cards Model**: Extracts contact information from English business cards.  
- **Invoices Model**: Extracts invoice-related fields such as customer/vendor info, dates, amounts, and addresses.  
- **Line Items Model**: Extracts detailed item-level data like description, quantity, price, and tax.  
- **IDs Model**: Extracts identity document fields such as name, nationality, dates, and document type.

**Key Facts**  
- Receipts model supports receipts from Australia, Canada, Great Britain, India, and the United States.  
- Business cards model supports only English language cards.  
- Minimum of 5 sample forms needed to train a custom model (mentioned just before this section).  
- Important fields extracted by each model include:  
  - **Receipts**: receipt type, merchant name/phone/address, transaction date/time, total, subtotal, tax, tip, items (name, quantity, price, total price).  
  - **Business Cards**: contact names, company, department, job title, emails, websites, multiple phone types, addresses.  
  - **Invoices**: customer/vendor names and addresses, purchase order, invoice ID/date, due date, subtotal, tax, total, amount due, service and remittance addresses, previous unpaid balance.  
  - **Line Items**: item description, quantity, unit price, product code, tax, date.  
  - **IDs**: country, region, date of birth, expiration date, document name, first/last name, nationality, sex, machine readable zone, document type, address, region.

**Examples**  
- Receipts from multiple countries (Australia, Canada, Great Britain, India, US).  
- English business cards extraction.  
- Various invoice formats with detailed billing and shipping info.  
- Identity documents including passports and US driver licenses.

**Key Takeaways 🎯**  
- Know the types of prebuilt models available in Form Recognizer and their primary use cases.  
- Remember the key fields each prebuilt model extracts by default.  
- Prebuilt models save time by eliminating the need for custom training on common document types.  
- Custom models are necessary when you need to extract fields not covered by prebuilt models.  
- Business cards model is limited to English only.  
- Receipts model supports multiple countries, important for exam scenarios involving international data.  
- Minimum 5 sample forms needed to train custom models (context from just before this section).  
- Understanding these models helps in choosing the right approach for document data extraction tasks in Azure Form Recognizer.

---

## LUIS

**Timestamp**: 01:17:33 – 01:19:58

**Key Concepts**  
- LUIS (Language Understanding Intelligent Service) is a no-code machine learning service to build natural language understanding into apps, bots, and IoT devices.  
- It enables quick creation of enterprise-ready custom models that continuously improve.  
- LUIS focuses on understanding user intentions and extracting relevant information from user input.  
- The service is accessed via its own isolated domain at **luis.ai**.  
- LUIS applications are composed of a schema that defines intents, entities, and utterances.  
- Intents represent what the user wants (classification of user input).  
- Entities extract specific data from the user input related to the intent.  
- Utterances are example user inputs labeled with intents and entities used to train the ML model.  
- Every LUIS app contains a special **none** intent to explicitly train the model to ignore irrelevant or out-of-scope utterances.  

**Definitions**  
- **Intent**: The goal or purpose behind a user’s utterance; what the user is asking for.  
- **Entity**: Specific pieces of information extracted from the utterance that help fulfill the intent.  
- **Utterance**: An example phrase or sentence from a user that is labeled with an intent and entities for training the model.  
- **None Intent**: A built-in intent used to classify utterances that do not match any defined intent, effectively telling the model to ignore them.  

**Key Facts**  
- Recommended number of example utterances per intent: **15 to 30** for effective training.  
- The schema for a LUIS app is auto-generated via the LUIS AI web interface; manual schema writing is not typical.  
- LUIS uses NLP (Natural Language Processing) and NLU (Natural Language Understanding) to transform linguistic statements into machine-understandable representations.  

**Examples**  
- Example utterance: "These would be the identities. So we have two in Toronto."  
  - Intent: Classification of what the user wants (not explicitly named in transcript).  
  - Entities: Identified keywords or phrases within the utterance that help determine the answer.  

**Key Takeaways 🎯**  
- Understand the difference between intents (what the user wants) and entities (data extracted from the utterance).  
- Always include a **none** intent in your LUIS app to handle irrelevant or out-of-scope inputs.  
- Provide sufficient example utterances (15-30) per intent to train the model effectively.  
- LUIS is designed to be used via its web interface, which auto-generates the schema, making it accessible even without deep programming skills.  
- Focus on the classification nature of intents and the extraction role of entities for the AI-900 exam.  
- No need to dive deeply into advanced features beyond intents, entities, and utterances for the exam.

---

## QnA Maker

**Timestamp**: 01:19:58 – 01:24:19

**Key Concepts**  
- QnA Maker is a cloud-based NLP service that creates a natural conversational layer over custom data.  
- It helps find the most appropriate answer from a custom knowledge base.  
- Commonly used for building conversational clients like chatbots, social apps, and speech-enabled desktop apps.  
- Customer data is stored only in the region where dependent services are deployed; QnA Maker itself does not store customer data.  
- Knowledge bases are built from documents (PDF, DOCX), URLs, or manuals containing question-answer pairs.  
- Metadata tags (e.g., chit chat, content type, format, freshness) help filter and refine answers.  
- Supports multi-turn conversations with follow-up prompts to manage dialog flow.  
- Uses layered ranking: Azure Search provides initial ranking, followed by QnA Maker’s NLP re-ranking for final results and confidence scores.  
- Active learning helps improve the knowledge base by suggesting edits based on user queries.  
- Chit chat feature provides pre-populated conversational responses for casual or off-topic user inputs.

**Definitions**  
- **QnA Maker**: A cloud-hosted service (at QnAMaker.ai) that builds a conversational question-answer layer over custom data using NLP and machine learning.  
- **Knowledge Base (KB)**: A collection of question and answer pairs created from documents, URLs, or manuals to serve as the source of answers.  
- **Multi-turn Conversation**: A dialog feature where the bot manages follow-up questions and context to handle complex interactions beyond a single question-answer exchange.  
- **Chit Chat**: Pre-built conversational content that handles casual or small talk queries with canned responses.  
- **Layered Ranking**: A two-step ranking process where Azure Search first ranks results, then QnA Maker’s NLP model re-ranks to produce final answers with confidence scores.  
- **Active Learning**: A process where the system learns from user interactions to suggest improvements to the knowledge base.

**Key Facts**  
- QnA Maker is hosted on its own isolated domain: QnAMaker.ai.  
- Knowledge bases can be built from DOCX files with headings and text, PDFs, URLs, or manuals.  
- Metadata tags include chit chat, content type, format, content purpose, and content freshness.  
- The chit chat dataset includes about 100 scenarios with multiple personas’ voices.  
- Azure Search is used as the first ranking layer in the answer retrieval process.  
- Multi-turn conversations enable follow-up prompts to refine answers when a single-turn answer is insufficient.

**Examples**  
- Importing a DOCX document with headings and text to automatically extract question-answer pairs.  
- Multi-turn conversation example: A user asks a generic question, then follows up with “Are you talking about AWS or Azure?” to clarify intent.  
- Chit chat responses to casual questions like “How are you doing?” or “What’s the weather today?” with canned answers.

**Key Takeaways 🎯**  
- Understand that QnA Maker builds a custom knowledge base from various document types to answer user questions conversationally.  
- Remember the layered ranking approach: Azure Search + NLP re-ranking for accurate results.  
- Know the importance of metadata tags for filtering and enhancing answer relevance.  
- Multi-turn conversations are essential for handling complex dialogs with follow-up prompts.  
- Chit chat is useful for handling casual or off-topic user inputs with pre-built responses.  
- Active learning improves the knowledge base over time by analyzing user queries and suggesting edits.  
- QnA Maker does not store customer data outside the deployed region, ensuring data residency compliance.  
- The QnA Maker chat box or integration with Azure Bot Service allows testing and interacting with the knowledge base.

---

## Azure Bot Service

**Timestamp**: 01:24:19 – 01:26:45

**Key Concepts**  
- Azure Bot Service is an intelligent, serverless bot service that scales on-demand.  
- It is used for creating, publishing, and managing bots via the Azure portal.  
- Bots can be integrated with multiple channels including Azure, Microsoft, and third-party services.  
- The Bot Framework SDK (version 4) is an open-source SDK for building sophisticated conversational bots.  
- Bot Framework Composer is an open-source IDE built on top of the Bot Framework SDK for authoring, testing, provisioning, and managing bots.  

**Definitions**  
- **Azure Bot Service**: A scalable, serverless platform in Azure for creating, publishing, and managing bots.  
- **Bot Framework SDK**: An open-source software development kit (currently version 4) that enables developers to build complex conversational bots with natural language understanding and speech capabilities.  
- **Bot Framework Composer**: An open-source integrated development environment (IDE) for building conversational experiences, supporting bot authoring, testing, and deployment.  

**Key Facts**  
- Azure Bot Service supports integration with channels such as Direct Line, Alexa, Office 365, Facebook, Keek, Line, Microsoft Teams, Skype, Twilio, and more.  
- Bot Framework SDK version 4 is the current version used for bot development.  
- Bot Framework Composer is available on Windows, macOS, and Linux.  
- Bots can be developed using C# or Node.js.  
- Deployment options include Azure Web Apps and Azure Functions.  
- Composer provides templates for various bot types: QnA Maker Bot, Enterprise or Personal Assistant Bot, Language Bot, Calendar Bot, People Bot.  
- Testing and debugging can be done using the Bot Framework Emulator.  
- Composer includes a built-in package manager.  

**Examples**  
- Examples of bots include Azure Health Bot, Azure Bot, and Web App Bot (a generic bot).  
- Integration examples: connecting bots to Microsoft Teams, Facebook, Alexa, and Twilio channels.  

**Key Takeaways 🎯**  
- Understand that Azure Bot Service is a scalable, serverless platform for bot management and deployment.  
- Know the role of the Bot Framework SDK (v4) as the core development kit for building bots.  
- Remember Bot Framework Composer as the visual IDE tool that simplifies bot creation and management.  
- Be familiar with supported programming languages (C# and Node.js) and deployment targets (Azure Web Apps, Azure Functions).  
- Recognize the importance of channel integration to connect bots with various communication platforms.  
- For the AI-900 exam, focus on the high-level concepts of Azure Bot Service, Bot Framework SDK, and Bot Framework Composer without needing deep technical details.
