# GNINA Validation — Site F + A on Reference Compounds

**2026-05-06 (Day 2 evening). GNINA 1.3.2 (CUDA 12.8) on RTX 5050 (8 GB).**

GNINA = AutoDock Vina + a CNN pose-scoring layer + a CNN affinity-prediction layer (trained on PDBbind). It outputs four signals per pose, of which the CNN scores are the orthogonal-to-Vina signal we need to escape Vina-traps.

## Outputs explained

| Score | Range | Interpretation |
|---|---|---|
| `affinity_kcal` | typically –4 to –10 kcal/mol; lower = better | Vina empirical scoring function. Same as our existing pipeline. |
| `intramol_kcal` | typically 0 to –3 kcal/mol | Intramolecular ligand strain. |
| `cnn_pose_score` | 0 – 1; higher = "more native-like" | CNN's confidence that this geometry resembles a real crystal-structure-style binding pose. **The Vina-trap detector.** |
| `cnn_affinity_pkd` | typically 3 – 8; higher = tighter | CNN's predicted pKd = -log₁₀(Kd in M). Convert to µM via `Kd_uM = 1e6 × 10^(-pKd)`. |

## Validation 1 — 6 reference compounds at site F

| Compound | Real CF Kd | GNINA pKd → Kd | CNN pose | Vina | Notes |
|---|---:|---:|---:|---:|---|
| Z795991852 | **10 µM** | 5.86 → **1.4 µM** | 0.420 | -8.12 | Best CF Labs hit. Predicted 7× tighter than reality. |
| Z979336988 | 30 µM | 5.92 → **1.2 µM** | 0.419 | -8.50 | Worst CF Labs hit. Predicted 25× tighter than reality. |
| D203-0031 | 17 µM | 5.82 → **1.5 µM** | 0.232 | -8.26 | Lowest CNN pose — possibly a poor docked geometry; series is over-explored. |
| FM001580 (TEP frag, has crystal at site F) | (~mM) | 3.83 → 148 µM | **0.827** | -5.37 | High CNN pose ✓ — recognizes crystal-style binding |
| FM001452 (TEP frag, has crystal at site F) | (~mM) | 3.88 → 132 µM | **0.711** | -5.57 | High CNN pose ✓ |
| FM002150 (TEP frag, has crystal at site F) | (~mM) | 4.11 → 78 µM | **0.701** | -5.00 | High CNN pose ✓ |

### Headline observations

1. **GNINA correctly separates the two classes** (CF Labs hits 1–2 µM predicted, TEP fragments 78–150 µM predicted) — a 50–100× spread that mirrors reality.
2. **GNINA over-predicts affinity by 7–25×** for the CF Labs hits. This is consistent with reported CNN-scoring overconfidence on out-of-distribution targets. For *relative* ranking it remains useful; for *absolute* Kd predictions, treat as upper-bound estimates.
3. **CNN pose score correctly identifies which poses match crystallographic geometry.** The 3 site F TEP fragments (which DO have crystal poses at site F) all score 0.70+. The CF Labs hits (no crystal context, docked from scratch) score 0.23–0.42 — i.e., GNINA can't match them to a known binding mode at site F. This may mean: they bind in a different mode, induce conformational changes, or actually bind at a different site.
4. **Vina-only ranking remains anti-correlated with truth** at the µM regime (Vina ranks worst CF Labs hit Z979336988 as best). GNINA pKd is also weakly anti-correlated within the CF Labs hits (spread 0.10 pKd = within noise), but **the CF-hits-vs-fragments separation is dramatic**.

## Validation 2 — same 6 compounds at site A

| Compound | CNN pKd (Site A) | CNN pose (Site A) | Site F → Site A Δ pKd |
|---|---:|---:|---:|
| Z979336988 | 6.21 (0.62 µM) | (high) | +0.29 (favors A) |
| D203-0031 | 5.91 (1.23 µM) | 0.545 | +0.09 (≈ tie) |
| Z795991852 | 5.90 (1.25 µM) | (med) | +0.04 (≈ tie) |
| FM002150 | 4.18 (66 µM) | 0.823 | +0.07 (slight A) |
| FM001452 | 3.99 (103 µM) | 0.841 | +0.11 (slight A) |
| FM001580 | 3.56 (275 µM) | 0.853 | -0.27 (favors F) |

GNINA's site discrimination for large compounds remains weak (CF Labs hits score similarly at F and A), same limitation as Vina. **For site assignment we still need to rely on prior-art context (Naar SPR data shows site F preference) + manual analysis of anchor contacts.**

## Validation 3 — Vina-trap detection on analog candidates

We took 16 candidates from the analog enumeration smoke test and re-ran with GNINA.

### The clearest Vina-trap

**`Z795991852_analog_0024`**: Vina = -7.86 ★, CNN pKd = 6.11 (0.78 µM!) ★, **CNN pose = 0.291** ⚠

By Vina alone, this is the top candidate (-7.86 kcal/mol; pred Kd 0.78 µM via CNN). But the CNN pose score of 0.29 says: "I have low confidence this docked geometry matches a real binding mode." This is a textbook Vina-trap: high contact score at a chemically suspect pose. Without GNINA, we'd have shipped this as a top pick.

### The clearest real binder

**`FM001580_analog_0034`**: Vina = -6.00, CNN pKd = 4.86 (13.8 µM), **CNN pose = 0.602** ✓

A morpholine-substituted analog of FM001580 (parent crystallographic site F binder). Combines moderate Vina, decent CNN affinity, AND high CNN pose confidence — all three signals agree this is a credible site F binder, **predicted ~6× tighter than the parent fragment** (FM001580 alone: 148 µM predicted; with morpholine: 14 µM predicted).

### Top 5 by combined signal (CNN pose ≥ 0.6 AND CNN pKd ≥ 4.5)

| Compound | Vina | CNN pose | CNN pKd | Pred Kd | Hypothesis |
|---|---:|---:|---:|---:|---|
| **FM001580_analog_0033** (piperidine) | -6.03 | 0.689 | 4.73 | **18.6 µM** | Site F frag + saturated amine ring |
| **FM001580_analog_0034** (morpholine) | -6.00 | 0.602 | 4.86 | **13.8 µM** | Site F frag + morpholine; cleanest signal |
| FM001580_analog_0009 (di-acid) | -6.10 | 0.804 | 4.59 | 25.5 µM | OCF₃ benzoic acid + ortho carboxylate |
| FM001452_analog_0196 | -6.11 | 0.680 | 4.44 | 36.2 µM | aniline + isopropyl |
| FM002150_analog_0075 | -5.61 | 0.718 | 4.23 | 58.9 µM | benzyloxyacetic acid + para-CH₂OH |

These 5 are **frontrunners for the on-day shortlist**.

## Performance

| Mode | Per-compound time | Per-pocket time for 503 candidates |
|---|---|---|
| Vina (CPU only) | ~6 s (exh 16) | ~50 min |
| **GNINA (RTX 5050)** | **~5 s (exh 8 + CNN rescore)** | **~42 min** |
| GNINA on HPC GPU | (faster) | (likely under 20 min) |

GNINA on GPU is **faster than Vina on CPU** AND gives 3 orthogonal signals instead of 1. Switching the on-day pipeline to GNINA is a strict win.

## Recommended on-day scoring rule

Combine the three GNINA signals with a tiered filter:

| Tier | Filter | Action |
|---|---|---|
| A (top picks) | CNN pose ≥ 0.5 AND CNN pKd ≥ 5.0 AND Vina ≤ -6.5 | Manual review for the 4-pick |
| B (consider) | CNN pose ≥ 0.5 AND CNN pKd ≥ 4.0 | Backup pool |
| C (Vina-trap) | Vina ≤ -7 AND CNN pose < 0.4 | **Downweight** — likely contact-maximizer |
| D (drop) | CNN pose < 0.3 OR CNN pKd < 3.5 | Drop unless other strong signal |

## Files

```
bin/gnina                              # binary, 2.0 GB (gitignore this)
scripts/dock_gnina.py                  # wrapper: SMILES CSV → GNINA scoring
data/dock/validation_F_gnina/          # ref compounds at site F
data/dock/validation_A_gnina/          # ref compounds at site A
data/analogs/smoke_test_F_gnina/       # 16 analogs at site F (Vina-trap test)
data/dock/GNINA_VALIDATION.md          # this file
```

## Usage

```bash
source $HOME/miniconda3/etc/profile.d/conda.sh && conda activate tbxt
cd ~/Hackathon/TBXT
python scripts/dock_gnina.py --smiles-csv my_pool.csv --site F --out-dir gnina_out --exhaustiveness 8
```

Output `dock_results_gnina.csv` columns: `id, smiles, best_vina_kcal, best_cnn_pose_score, best_cnn_affinity_pkd, best_cnn_affinity_uM, n_modes, all_vina, all_cnn_pose, all_cnn_pkd, status`.

## Caveats

- **CNN trained on PDBbind**, mostly enzyme/receptor systems. TBXT (transcription factor) is out-of-distribution — both pKd and pose scores are noisier on TBXT than they would be on a kinase.
- **CNN pose score interpretation depends on the receptor.** A 0.5 cutoff is calibrated to our reference set; may need adjustment for sites where no crystal-bound fragment exists (sites B/C/D/E).
- **The 7-25× Kd over-prediction on CF Labs hits** suggests applying a +1 pKd "bias correction" if absolute Kd estimates matter. For relative ranking we don't need this.
- **Receptor still rigid.** GNINA does not handle induced-fit. Some compounds may bind only via conformational changes the rigid model can't represent.
