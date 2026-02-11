# MeasureUp Practice Exam for AI-102

## Wrong and Unsure Answers Review

### Azure OpenAI Image Generation and DALL-E Configuration

You are an AI Engineer. You are developing an application that uses Azure OpenAI to generate images from natural language prompts.

You test the functionality of the DALL-E model in Azure AI Foundry as shown in the exhibit.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

| Statement | Yes | No |
|----------|-----|----|
| Prefilled Python code reflecting your settings is available | ☐ | ☐ |
| You can set the size of the generated images to 1024x1024. | ☐ | ☐ |
| You can save generated images in JPEG format. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-10-05-46-11.png' width=700>

</details>

<details>
<summary>💡 Click to expand explanation</summary>

**Why the statements are correct**

**Prefilled Python code reflecting your settings is available — Yes**

The Azure AI Foundry DALL·E playground generates prefilled Python code based on the configuration you select in the UI. This allows you to copy code that already includes your prompt, image size, and other generation settings. This is designed to simplify moving from testing in the playground to application integration.

**You can set the size of the generated images to 1024x1024 — Yes**

The DALL·E model supports specific image sizes, including 1024x1024. The explanation confirms that the model supports 1024x1024, 1024x1792, and 1792x1024. These can be configured in the playground settings.

**You can save generated images in JPEG format — No**

At the time described, DALL·E in Azure AI Foundry supports only PNG output. JPEG is not supported directly from the model output, so this statement is false.

**Key takeaway**

The question tests knowledge of:

* Playground-to-code integration capability
* Supported image sizes
* Supported output formats

For exam purposes, remember:

* Prefilled SDK code is available in Azure AI Foundry.
* 1024x1024 is a valid supported size.
* PNG is supported; JPEG is not.

**References**

* [https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/dall-e](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/dall-e)
* [https://learn.microsoft.com/en-us/azure/ai-services/openai/quickstart?pivots=programming-language-python&tabs=command-line%2Cpython-new](https://learn.microsoft.com/en-us/azure/ai-services/openai/quickstart?pivots=programming-language-python&tabs=command-line%2Cpython-new)

</details>

▶ Related Lab: [lab-dalle-image-gen](/AI-102/hands-on-labs/generative-ai/lab-dalle-image-gen/README.md)

---

### Azure AI Search Query Performance Optimization

You use Azure AI Search to index your organization's documents and data.

Users report that some queries are slow. You repeat the users' queries when there is no load on the service and the queries are still slow.

What should you do to improve performance of slow-running queries?

| Statement | Yes | No |
|----------|-----|----|
| Add fields to the index. | ☐ | ☐ |
| Add replicas. | ☐ | ☐ |
| Add partitions. | ☐ | ☐ |
| Convert fields to complex types. | ☐ | ☐ |

<details>
<summary>📸 Click to expand screenshot</summary>

<img src='.img/2026-02-11-06-31-10.png' width=700>

</details>

<details open>
<summary>💡 Click to expand explanation</summary>

</details>

▶ Related Lab: [lab-search-query-perf](../../hands-on-labs/knowledge-mining/lab-search-query-perf/README.md)

---
