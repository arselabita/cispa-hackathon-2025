# Understanding *A Survey of Large Language Model Attribution*

This repository includes notes and insights derived from the paper **“A Survey of Large Language Models Attribution”**. The goal of this document is to summarize the core ideas, explain the purpose of the paper, and highlight the essential concepts relevant for newcomers in AI, cybersecurity, or research-oriented hackathons.

---

## What the Paper Is About

The survey provides a comprehensive overview of **attribution** in Large Language Models (LLMs).
Attribution refers to the ability of an AI system to:

* Identify where its generated information comes from
* Provide verifiable sources or citations
* Ensure that its answers are grounded in real, checkable evidence

As LLMs become central to search, question answering, and reasoning systems, attribution is crucial for building **trustworthy**, **accurate**, and **auditable** AI.

---

## Why Attribution Matters

Modern LLMs can generate fluent, confident text — but they often:

* Produce incorrect information
* Mix facts with invented details
* Cite non-existent sources

High accuracy alone is not enough. We must ensure that the **information is supported by verifiable evidence**. This is especially important for domains such as security, medicine, scientific research, and any system requiring factual reliability.

Attribution provides a structured way to evaluate and improve this.

---

## What the Paper Wants the Reader to Learn

### **1. The Definition of Attribution**

Understanding how LLMs can trace their output back to:

* Pre-training data
* External documents

and how that connection can be measured.

---

### **2. The Core Challenges**

The paper outlines several limitations in current LLMs:

* Hallucinated references
* Unverifiable statements
* Difficulty tracing model-internal “knowledge”
* Biases in retrieval and citation
* Over-attribution (too many irrelevant sources)
* Under-attribution (insufficient evidence)

---

### **3. The Main Approaches to Attribution**

The survey organizes current methods into three major categories:

#### **A. Direct Generated Attribution**

The model generates citations directly in its answer.
**Issue:** LLMs often invent citations or misquote sources.

#### **B. Retrieval-Then-Generation (RAG)**

The system retrieves relevant real documents first, then generates answers grounded in those documents.
This is currently the most reliable approach.

#### **C. Post-Generation Verification**

After generating an answer, another step checks whether the answer is supported by real evidence.

---

### **4. Sources of Attribution**

The survey explains how evidence is obtained:

* Pre-training datasets
* Fine-tuning data
* Web search and retrieval systems
* Structured databases or knowledge graphs

---

### **5. Benchmarks and Datasets**

The paper lists important datasets used to measure attribution quality, such as:

* **ALCE**
* **CiteBench**
* **EXPERTQA**
* **HAGRID**
* **SEMQA**
* **FActScore**

These datasets help researchers evaluate if a system’s answers are both **correct** and **well-supported**.

---

### **6. Evaluation Techniques**

The paper describes multiple evaluation frameworks designed to measure:

* Factual accuracy
* Faithfulness to retrieved sources
* The quality and relevance of citations

Examples include:

* AttributionScore
* FActScore
* FacTool
* WICE
* BEGIN benchmark

