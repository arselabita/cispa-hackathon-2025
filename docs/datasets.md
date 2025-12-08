## Model Stealing Threats: Access Levels and Attack Strategies

Machine learning models represent valuable intellectual property due to high training costs in data and computation, such as GPT-3 estimated at over $4 million, yet they are often exposed via APIs for services like image recognition, enabling theft.      Model stealing includes **model extraction** where adversaries query prediction vectors or labels to train a cheaper copy, using the victim model as a labeling oracle on unlabeled data, or gaining direct dataset access for distillation or training from scratch, or full model access for fine-tuning or data-free distillation.        

- **Query Access (A_Q)**: Adversary queries victim model f_V; (1.a) logit-query minimizes KL divergence on public data; (1.b) label-query uses confident labels as pseudo-labels.        
- **Model Access (A_M)**: Full access to f_V without data; (2.a) fine-tuning on public data; (2.b) zero-shot data-free distillation using synthetic non-semantic queries.        
- **Data Access (A_D)**: Full private dataset S_V; (3.a) distillation via queries; (3.b) different architecture or learning scheme from scratch.        
- **Control**: Independent model I trained on separate data; source model f_V as upper bound.     

Prior defenses like watermarking embed unique signals but require retraining, degrade accuracy, and fail against adaptive attacks like distillation or extraction that alter decision surfaces.         **Dataset inference (DI)** flips this by exploiting the victim's access to original training data S_V, detecting if suspect model f_{A^*} incorporates knowledge from S_V, as all theft methods embed this knowledge directly or indirectly.     

> **Definition 1 (Dataset Inferring Victim V(f, α, m))**: Victim V with private S_V ⊆ K_V (K_V: private knowledge) proves subset K ⊂ K_V used in f with Type-I error (FPR) < α using ≤ m samples from S_V, or returns inconclusive ∅.  

> **Definition 2 (Dataset Inference Experiment Exp^{DI}(V, m, α, S_V, D))**: Random b ∈ {0,1}; if b=1, f_{A^*} ∼ F_V (trained on S_V ∼ D), else f ∼ F (any classifier); returns 1 if V(f_{A^*}, α, m)=1 and b=1.     

DI succeeds even without overfitting, unlike membership inference (MI), by aggregating over multiple points.     

## Theoretical Foundations: Prediction Margins in Linear Models

DI relies on **prediction margin**—confidence as distance y · f(x) from decision boundary—higher for training points as models maximize margins on them (see Figure 1: training points push boundaries away).        

**Setup**: Binary classification; x = (x_1 = y u ∈ ℝ^K, x_2 ∼ 𝒩(0, σ²I) ∈ ℝ^D), u fixed separable vector; S ∼ D, |S|=m training set; linear f(x) = w_1 · x_1 + w_2 · x_2, sgn(f(x)) decision; trained via GD (α=1, one pass): $$w_1 = \frac{1}{m} \sum y^{(i)} x_1^{(i)} = u$$, $$w_2 = \sum y^{(i)} x_2^{(i)}$$.           -  

**Theorem 1 (Train-Test Margin)**: $$𝔼_{(x,y)∼S} [y · f(x)] - 𝔼_{(x,y)∼D} [y · f(x)] = D σ^2$$, as training points gain extra $$D σ^2$$ from noise correlation.   Proof: For (x,y)∼S^+, margin = c + 𝔼[(x_2^{(j)})^2] = c + D σ^2 (χ² expectation); for D^+, 𝔼= c (independent).  -   This holds for overparameterized DNNs due to memorization.      **Why it matters**: Quantifies train-test disparity exploited by DI, independent of m.  

**MI Failure (Theorem 2)**: Adversary M(x,f) predicts single-point membership from D knowledge; optimal: 1 if (y f(x) - c) ≥ t. P[M(x,f)=b] = $$1 - Φ\left(-\frac{D}{2\sqrt{m}}\right)$$, →0.5 as m→∞ (overfitting ↓).  -   Proof: High variance; for D^+, z_2 · x_2 ∼ 𝒩(0, m D σ^4); S^+, u ∼ 𝒩(D σ^2, m D σ^4); γ=u-r ∼ 𝒩(D σ^2, 2 m D σ^4), CDF at 0 yields result.        -   **Example**: m=50K, K=100, D=900: MI=0.526, useless singly.  

**DI Success (Theorem 3)**: Victim aggregates; ψ_V=1 if mean margin t_V > t_0 + λ on S_V, S_0∼D. P[ψ= b] = $$1 - Φ\left(-\frac{\sqrt{D}}{2\sqrt{2}}\right)$$, →1 as D→∞, independent of m.  -   Proof: t_V - t_0 ∼ 𝒩(D σ^2, 2 D σ^4 / m), optimal λ= μ/2.  -   **Connection**: MI fails per-point (high var), DI aggregates (CLT reduces var by √m).      **Analogy**: Single poll noisy; aggregate reliable.  

## Dataset Inference Mechanism: Embeddings from Prediction Margins

Victim generates embeddings capturing f_{A^*}'s margin on private/public points, trains regressor g_V on own f_V, tests on f_{A^*} (Fig. 2).   Intuition: Stolen f_{A^*} positions S_V far from boundaries.  

### White-Box Embedding: MinGD
Full access (e.g., court); for (x,y), minimize distance Δ(x, x+δ) s.t. f(x+δ)=t ≠y, t neighbor; features: Δ_{ℓ1,ℓ2,ℓ∞} per t (30 dims for CIFAR10).   Opt: GD, max 500 steps, α={0.1,0.01,0.001}.  -   **Think of it like**: Probing nearest class boundary precisely.  

### Black-Box Embedding: Blind Walk
Label-only API; from x, sample δ (uniform/Gauss/Laplace), walk k≤50 steps till f(x+kδ)=t≠y; features: 10 Δ_{ℓp} per noise (30 dims).     -   **Superiority**: Averages landscape (stochastic), avoids adversarial pits; outperforms MinGD empirically.     -   **Query efficient**: ~30K for m=100.     

**Confidence Regressor g_V**: 2-layer linear+tanh; train on f_V embeddings: L = -b g_V(emb), b=1 public, -1 private (minimizes on S_V).        

**Ownership Tester**: On f_{A^*}, get equal |c| = |c_V| = m confidence scores (lower on private); T-test H_0: μ_c < μ_{c_V} vs H_a: > (one-sided p-value); reject if p<α (stolen), else inconclusive.         Aggregate 100 tests via harmonic mean p; 99% CI via 40 bootstraps.   **Why aggregate?**: Amplifies weak per-point signal.  

> **ℹ️ Note**: DI post-hoc, no retrain/overfit needed; scales to ImageNet.     

## Experimental Evaluation: Robustness Across Datasets and Attacks

**Setup**: Victim: WRN-28-10 + dropout 0.3 on CIFAR10/100 (50K train); attacks on 500K TinyImages subset; SGD fixed LR decay 0.2 at 0.3/0.6/0.8 epochs; regressor as above.  -         Datasets: CIFAR10/100 (60K 32x32 images, 10/100 classes); SVHN (house digits); ImageNet (large-scale).     -  

**Results (CIFAR10/100, m=10)**: Table 1; DI >99% conf (p<<0.01, Δμ>0) vs all attacks (fine-tune/Distill highest Δμ; label/logit/zero-shot lowest but still detectable); independent ~1 (no claim). Blind Walk ≥ MinGD.     

| Model Stealing Attack | CIFAR10 MinGD Δμ / p | CIFAR10 Blind Walk Δμ / p | CIFAR100 MinGD Δμ / p | CIFAR100 Blind Walk Δμ / p |
|-----------------------|-----------------------|----------------------------|-------------------------|-----------------------------|
| **V Source**         | 0.838 / 10^{-4}      | 1.823 / 10^{-42}          | 1.219 / 10^{-16}       | 1.967 / 10^{-44}           |
| **A_D Distillation** | 0.586 / 10^{-4}      | 0.778 / 10^{-5}           | 0.362 / 10^{-2}        | 1.098 / 10^{-5}            |
| **A_D Diff. Arch.**  | 0.645 / 10^{-4}      | 1.400 / 10^{-10}          | 1.016 / 10^{-6}        | 1.471 / 10^{-14}           |
| **A_M Zero-Shot**    | 0.371 / 10^{-2}      | 0.406 / 10^{-2}           | 0.466 / 10^{-2}        | 0.405 / 10^{-2}            |
| **A_M Fine-tuning**  | 0.832 / 10^{-5}      | 1.839 / 10^{-27}          | 1.047 / 10^{-7}        | 1.423 / 10^{-10}           |
| **A_Q Label-query**  | 0.475 / 10^{-3}      | 1.006 / 10^{-4}           | 0.270 / 10^{-2}        | 0.107 / 10^{-1}            |
| **A_Q Logit-query**  | 0.563 / 10^{-3}      | 1.048 / 10^{-4}           | 0.385 / 10^{-2}        | 0.184 / 10^{-1}            |
| **I Independent**    | 0.103 / 1-           | -0.397 / 0.675-           | -0.242 / 0.545-        | -1.793 / 1                  |  -  

**Few Samples Suffice**: m=20-40 for α=0.01 (Fig. 3); embedding size 10 equiv to 30 (Fig. 4, Appendix D).        

**SVHN (Blind Walk, m=10)**: Table 2; similar, resilient to random-query.  -  

| Attack | Δμ / p-value |
|--------|--------------|
| **V Source** | 0.950 / 10^{-8} |
| **A_D Distill** | 0.537 / 10^{-3} |
| **A_D Diff. Arch.** | 0.450 / 10^{-2} |
| **A_M Zero-Shot** | 0.512 / 10^{-3} |
| **A_M Fine-tune** | 0.581 / 10^{-4} |
| **A_Q Label** | 0.513 / 10^{-3} |
| **A_Q Logit** | 0.515 / 10^{-2} |
| **A_Q Random** | 0.475 / 10^{-2} |
| **I Indep.** | -0.322 / 10^{-1} |  -  

**ImageNet (Blind Walk, m=10, data theft)**: Table 3; detects AlexNet/InceptionV3 trained on same data as WRN-50-2 (p<10^{-3}).  -  

**Partial Overlap**: Detects λ≥0.3 overlap (Table 4, Fig. 5); effect size ↑ with λ.  -  

> **💡 Key Insight**: DI robust (even zero-shot/random), query-efficient, no retrain; degrades gracefully with adversary effort (fine-tune harder to obfuscate).        

## Broader Implications and Limitations

DI resolves ownership without model changes, applies to ethical checks (e.g., unintended features like ethnicity in gender models).      Future: Combine with DP (likely compatible, as DI amplifies signal).   **Misconception**: Not reliant on overfitting (works on ImageNet); black-box viable.      **Code**: github.com/cleverhans-lab/dataset-inference.