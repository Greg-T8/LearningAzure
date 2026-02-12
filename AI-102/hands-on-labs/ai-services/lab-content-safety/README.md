# Azure AI Content Safety - Text and Image Moderation

## Exam Question Scenario

You are an AI developer at a social media company. Your company wants to use AI solutions to improve aspects of user-generated content management. You are exploring the capabilities of Azure AI Content Safety. You need to identify which features are currently available in Azure AI Content Safety Studio.

**Which two features should you identify? Each correct answer presents a complete solution.**

- A. Creating trails and highlighting reels
- B. Search for exact moments in videos
- C. Hunting for security threats with search-and-query tools
- D. Moderating image content
- E. Moderating text content

---

## Solution Architecture

This lab deploys an Azure AI Content Safety resource so you can explore both **text moderation** and **image moderation** capabilities through the Content Safety Studio and REST API. The Content Safety service scans text and images for sexual content, violence, hate, and self-harm with multi-severity levels.

| Component | Resource | Purpose |
|-----------|----------|---------|
| Content Safety | `cog-content-safety-*` | AI-powered text and image moderation |
| Content Safety Studio | Web UI | Interactive portal for testing moderation |

---

## Lab Objectives

1. Deploy an Azure AI Content Safety resource using Terraform
2. Use Content Safety Studio to moderate text content with severity levels
3. Use Content Safety Studio to moderate image content with severity levels
4. Test the Content Safety REST API for text and image analysis
5. Understand which features are available in Content Safety Studio vs. other Azure services

---

## Lab Structure

```
lab-content-safety/
├── README.md
├── terraform/
│   ├── main.tf              # Resource group + Content Safety account
│   ├── variables.tf          # Input variable declarations
│   ├── outputs.tf            # Endpoint, keys, studio URL
│   ├── providers.tf          # AzureRM + Random providers
│   └── terraform.tfvars      # Lab subscription ID and defaults
└── validation/
    └── test-content-safety.ps1  # API validation script
```

---

## Prerequisites

- Azure subscription with Contributor access
- Azure CLI installed and authenticated
- Terraform >= 1.0 installed
- PowerShell 7+ (for validation script)
- `Az` PowerShell module with `Use-AzProfile` configured

---

## Deployment

```bash
cd AI-102/hands-on-labs/ai-services/lab-content-safety/terraform
Use-AzProfile Lab
terraform init
terraform plan
terraform apply -auto-approve
```

---

## Testing the Solution

### 1. Open Content Safety Studio

Navigate to [Content Safety Studio](https://contentsafety.cognitive.azure.com) and sign in with your Azure credentials. Select your deployed Content Safety resource.

### 2. Test Text Moderation

1. In Content Safety Studio, select **Moderate text content**
2. Enter sample text (e.g., a social media comment with potentially harmful content)
3. Click **Run test**
4. Review the severity levels for each harm category: Violence, Hate, Sexual, Self-Harm
5. Adjust **Configure filters** to set allowed/prohibited severity levels
6. Use **View Code** to export the API call

### 3. Test Image Moderation

1. In Content Safety Studio, select **Moderate image content**
2. Select a sample image or upload your own
3. Click **Run test**
4. Review the severity levels: 0-Safe, 2-Low, 4-Medium, 6-High
5. Check the **Accepted/Rejected** result based on your filter configuration

### 4. Test via REST API

Retrieve endpoint and key:

```bash
terraform output content_safety_endpoint
terraform output -raw content_safety_primary_key
```

Test text moderation API:

```bash
ENDPOINT=$(terraform output -raw content_safety_endpoint)
KEY=$(terraform output -raw content_safety_primary_key)

curl -X POST "${ENDPOINT}/contentsafety/text:analyze?api-version=2024-09-01" \
  -H "Ocp-Apim-Subscription-Key: ${KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "This is a sample text for content safety analysis.",
    "categories": ["Hate", "SelfHarm", "Sexual", "Violence"]
  }'
```

### 5. Run Validation Script (Optional)

```powershell
cd ../validation
.\test-content-safety.ps1
```

---

## Cleanup

```bash
cd AI-102/hands-on-labs/ai-services/lab-content-safety/terraform
terraform destroy -auto-approve
```

---

## Scenario Analysis

### Correct Answers: D (Moderating image content) and E (Moderating text content)

Azure AI Content Safety Studio provides the following core features:

- **Moderate text content** — Scans text for harmful content (sexual, violence, hate, self-harm) with multi-severity levels. Users can configure filters, test content, and export API code.
- **Moderate image content** — Scans images for the same harm categories with severity scoring (0-Safe, 2-Low, 4-Medium, 6-High) and Accepted/Rejected results based on configured filters.
- **Monitor online activity** — Tracks moderation API usage, trends, and response details.

### Why Other Options Are Wrong

| Option | Why It's Wrong |
|--------|---------------|
| **A. Creating trails and highlighting reels** | This is an Azure Video Indexer feature, not Content Safety. Video Indexer analyzes video content to create highlights and trails. |
| **B. Search for exact moments in videos** | This is also an Azure Video Indexer capability. Video Indexer indexes media files and provides search across visual/audio content. |
| **C. Hunting for security threats with search-and-query tools** | This is a Microsoft Sentinel / Microsoft Defender feature. Threat hunting uses KQL queries to find security incidents, which is unrelated to content moderation. |

---

## Key Learning Points

1. **Azure AI Content Safety** is the successor to Azure Content Moderator (deprecated Feb 2024, retiring March 2027)
2. **Content Safety Studio** provides interactive testing for text and image moderation with configurable severity filters
3. Content Safety scans for four harm categories: **Sexual, Violence, Hate, and Self-Harm** with multi-severity levels (0, 2, 4, 6)
4. The service uses `kind = "ContentSafety"` when provisioned as a Cognitive Services account
5. Content Safety supports **100+ languages** and is specifically trained on English, German, Japanese, Spanish, French, Italian, Portuguese, and Chinese
6. **Custom blocklists** can be created to flag domain-specific harmful content beyond the built-in categories
7. Additional advanced features include **Prompt Shields** (jailbreak detection), **Groundedness Detection**, and **Protected Material Detection**
8. Content Safety is distinct from Video Indexer (video analysis) and Microsoft Sentinel (security threat hunting)

---

## Related AI-102 Exam Objectives

- **Implement content moderation solutions (10-15%)**
  - Analyze text content for safety using Azure AI Content Safety
  - Analyze image content for safety using Azure AI Content Safety
  - Configure content filters and severity thresholds
- **Implement Azure AI services (15-20%)**
  - Create and configure Azure AI service resources
  - Manage authentication keys and endpoints

---

## Additional Resources

- [What is Azure AI Content Safety?](https://learn.microsoft.com/azure/ai-services/content-safety/overview)
- [Content Safety Studio](https://contentsafety.cognitive.azure.com)
- [Quickstart: Analyze text content](https://learn.microsoft.com/azure/ai-services/content-safety/quickstart-text)
- [Quickstart: Analyze image content](https://learn.microsoft.com/azure/ai-services/content-safety/quickstart-image)
- [Harm categories concept guide](https://learn.microsoft.com/azure/ai-services/content-safety/concepts/harm-categories)
- [Content Safety FAQ](https://learn.microsoft.com/azure/ai-services/content-safety/faq)

---

## Related Labs

▶ Related Lab: [lab-dalle-image-gen](../../generative-ai/lab-dalle-image-gen/README.md)
