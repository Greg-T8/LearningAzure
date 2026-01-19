# Module 5: Introduction to generative AI and agents

**Link:** [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/fundamentals-generative-ai/)

---

## Large language models (LLMs)

[Module Reference](https://learn.microsoft.com/training/modules/introduction-to-generative-ai-and-agents/large-language-models)

**Overview**

* **Large language models (LLMs)** and **small language models (SLMs)** capture linguistic and semantic relationships between words and phrases.
* Models generate **completions from prompts**, similar to predictive text but with deeper understanding of language context.
* Word prediction is based on:

  * A **large vocabulary**
  * Learned **linguistic structures**
  * **Semantic understanding** of concepts and meanings

**Prompt-Based Text Generation**

* A **prompt** starts a sequence of predictions.
* The model predicts the **most probable next token** based on prior context.
* Some words in a sequence carry more predictive weight than others (for example, *heard* and *dog* strongly suggest *bark*).

**Tokenization**

* Models do not process text as whole words.
* Text is broken into **tokens**, which can include:

  * Whole words
  * Sub-words (for example, *un* in *unlikely*)
  * Punctuation
  * Common character sequences
* Each token is assigned a **unique integer ID**.
* Modern LLM vocabularies contain **hundreds of thousands of tokens**.
* Token sets grow as more training data is added.

**Transforming Tokens with a Transformer**

* Each token is represented as a **vector** (array of numeric values).
* Vectors encode linguistic and semantic attributes.
* Through training, vectors become **embeddings**—representations enriched with contextual meaning.
* A **transformer model** is used to generate embeddings.

**Transformer Architecture**

* **Encoder block**

  * Uses **attention** to evaluate how surrounding tokens influence the current token.
  * Uses **multi-head attention** to process multiple aspects of tokens in parallel.
  * Outputs contextual **embedding vectors**.
* **Decoder block**

  * Uses embeddings to predict the **next most probable token**.
  * Applies attention and a feed-forward neural network during prediction.

<img src='.img/2026-01-19-04-42-46.png' width=700> 

**Initial Vectors and Positional Encoding**

* Token vectors start with **random values**.
* **Positional encoding** is added to indicate each token’s position in the sequence.
* Token order matters for meaning and relationships.
* Real-world models use vectors with **thousands of dimensions** (simplified examples use fewer).

**Attention and Embeddings**

* Attention layers:

  * Weight nearby tokens based on relevance.
  * Assign greater influence to contextually important tokens.
* Over time, the model learns:

  * Which tokens frequently appear together
  * How proximity and frequency affect meaning
* Tokens can have **multiple embeddings** if they appear in different contexts (for example, *bark* of a dog vs. *bark* of a tree).
* Embeddings exist in a **multi-dimensional vector space**.
* **Cosine similarity** measures semantic closeness between tokens.

<img src='.img/2026-01-19-04-43-15.png' width=700> 

**Predicting Completions from Prompts**

* The decoder predicts tokens **one at a time**.
* Uses **masked attention** so only prior tokens influence the prediction.
* During training:

  * Predicted tokens are compared to known correct tokens.
  * Errors are used to adjust model weights.
* During inference:

  * The most probable token is selected.
  * The token is appended and prediction repeats.
* Generation stops when the model predicts an **end-of-sequence** token.

**Key Facts to Remember**

* **LLMs generate text by predicting tokens**, not words.
* **Attention** is central to learning context and meaning.
* **Embeddings** encode semantic relationships between tokens.
* Tokens can have **multiple embeddings** depending on context.
* **Masked attention** prevents future tokens from influencing predictions.
* Semantic similarity is measured using **cosine similarity** between embeddings.

---

*Last updated: 2026-01-16*
