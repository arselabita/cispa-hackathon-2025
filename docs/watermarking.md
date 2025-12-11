
# Learning Guide: BitMark – Watermarking for Autoregressive Image Models

*Based on the paper: “Watermarks for Image Generative Models: A Robust and Radioactive Approach”*

This guide explains BitMark in simple, intuitive terms.
It’s meant for learning and understanding — not for formal documentation.

---

# 1. What Problem Is BitMark Solving?

Modern image models generate millions of AI images that flood the internet.
Some problems follow:

* These images get scraped into new datasets
* New models unknowingly train on AI-made images
* Models begin *training on their own output*
* This leads to **model collapse** (quality degradation)
* Companies can’t tell which images came from AI
* Models can be stolen and reused without detection

So we need a way to:

> **Mark AI-generated images with an invisible, hard-to-remove, statistically detectable signal.**

That signal is called a **watermark**.

BitMark is a watermarking method designed specifically for **Infinity**, a bit-wise autoregressive image generator.

---

# 2. What Makes Infinity Special?

Most image models (Stable Diffusion, DALL·E) work by turning noise → image.
Infinity is different:

> **It generates images *bit by bit*, like a language model predicting bits instead of words.**

This bit-based structure is the key idea behind BitMark.

---

# 3. What Is BitMark?

BitMark is a watermarking scheme built on three insights:

### **1. Tokens are unstable — bits are stable.**

If you encode→decode→re-encode an image using typical models, the tokens change a lot.
Bits don’t.

### **2. You can subtly bias the model to prefer certain bit patterns.**

During generation, BitMark encourages the next bit to belong to a secret “green list” of patterns.

No pixel changes.
No visible artifacts.
Just tiny probability nudges.

### **3. These biased patterns survive editing and reconstruction.**

Even after:

* resizing
* cropping
* noise
* blur
* JPEG
* compression
* recoloring
* diffusion-based reconstruction

…the statistical pattern remains detectable.

---

# 4. How BitMark Works (Beginner Explanation)

### **Step 1 — Define two secret sets**

* **Green list** → preferred bit sequences
* **Red list** → non-preferred sequences

### **Step 2 — During generation, push bits toward the green list**

When the model predicts a bit, BitMark adds a tiny bias in its probability:

* If generating a green sequence → slightly boost
* If generating a red sequence → slightly lower

This does *not* change the image visually.

### **Step 3 — After generation, detect the watermark**

Given a generated image:

1. Turn it back into bit sequences
2. Count how many green patterns appear
3. Compare against expected randomness
4. If significantly more → the image is watermarked

This is pure statistics.
No need for the original model or data.

---

# 5. What Makes This Watermark Special?

### **A. Robustness**

BitMark survives:

* JPEG compression
* Gaussian noise
* Cropping
* Rotation
* Color shifts
* Model reconstruction attacks

This is because it lives in the *bit structure*, not the pixel values.

---

### **B. Radioactivity (the coolest part)**

If someone trains a new model on watermarked images:

> **That new model will also produce watermarked images.**

So even if your dataset is stolen, or your outputs are reused:

* the watermark spreads
* you can still trace ownership
* you can detect training-source contamination

This is called **radioactive watermarking**.

It’s extremely hard to remove without destroying image quality.
