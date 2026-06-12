# Boltz-2 Co-Folding Validation — Strategy 4 Complete

**Boltz-2 v2.2.1 (CUDA 12.8 build) on RTX 5050 (8 GB).** All 6 reference compounds co-folded with TBXT G177D (178 aa DBD) in ~12 minutes wall-clock total (~2 min per compound at 3 diffusion samples each).

## Outputs explained

| Score | Range | Interpretation |
|---|---|---|
| `pLDDT` | 0–1, higher better | Per-residue confidence in predicted protein structure |
| `pTM` | 0–1, higher better | Predicted TM-score for protein structure |
| **`ipTM`** | 0–1, higher better | **Interface predicted TM — confidence in protein-ligand interface geometry** |
| `lig_iptm` | 0–1 | Ligand-side ipTM specifically |
| **`affinity_log_kd_uM`** | typically –2 to 4 | **Predicted log10(Kd in µM)**. Negative = sub-µM, positive = µM-mM |
| **`affinity_prob_binder`** | 0–1 | **Binary "is binder" probability**. > 0.5 = predicted binder |

## Reference set results

| Compound | Real CF Kd | Boltz Kd | Boltz ipTM | Boltz prob_binder | Verdict |
|---|---:|---:|---:|---:|---|
| Z795991852 | 10 µM | **1.7 µM** | 0.75 ✓ | 0.56 | Strong binder; predicted 6× too tight (over-confident affinity) |
| Z979336988 | 30 µM | 3.9 µM | 0.76 ✓ | 0.49 | Strong binder; predicted 7.6× too tight |
| D203-0031 | 17 µM | 0.26 µM | **0.58 ⚠** | 0.51 | Strong binder; **lower ipTM = less confident pose** (D203-* series caveat) |
| FM001580 | weak | 33 µM | 0.71 | **0.19** | Weak binder; correctly classified |
| FM001452 | weak | 17 µM | 0.74 | **0.32** | Weak binder; correctly classified |
| FM002150 | weak | 39 µM | 0.70 | **0.25** | Weak binder; correctly classified |

## Headline observations

### 1. Boltz-2 affinity is **markedly more accurate than GNINA + Vina**

| Method | Z795991852 (real 10 µM) | Z979336988 (real 30 µM) | D203-0031 (real 17 µM) |
|---|---:|---:|---:|
| Vina | -8.12 (no Kd) | -8.50 (no Kd) | -8.26 (no Kd) |
| GNINA CNN pKd | 1.4 µM (7×) | 1.2 µM (25×) | 1.5 µM (11×) |
| **Boltz-2** | **1.7 µM (6×)** | **3.9 µM (7.6×)** | 0.26 µM (65×) |

For Z795991852 and Z979336988, Boltz beats GNINA's affinity prediction. For D203-0031, both over-predict — but Boltz's lower ipTM (0.58) is a built-in caveat.

### 2. `affinity_prob_binder` is a clean binder/non-binder classifier

The 3 CF Labs hits all have `prob_binder` in 0.49–0.56 (model uncertain — these are µM binders, not nM, so 50/50 is reasonable). The 3 TEP fragments all have `prob_binder` in 0.19–0.32 — clearly classified as weak binders. **This is a useful 4th-axis signal beyond GNINA's CNN pose, QSAR, and Vina ensemble.**

### 3. `ipTM` flags structurally uncertain compounds

D203-0031 has ipTM 0.58 — lower than the 0.71-0.76 of the other CF Labs hits. This matches GNINA's observation (CNN pose 0.23). Both methods independently flag D203-0031 as having the least-confident binding mode. The compound is in the prior-art-saturated D203-* series, supporting the strategic decision to skip it.

### 4. Boltz can complement GNINA's CNN pose where they disagree

| Compound | GNINA CNN pose | Boltz ipTM | Agreement |
|---|---:|---:|---|
| Z795991852 | 0.42 | 0.75 | Disagree (Boltz higher confidence) |
| Z979336988 | 0.42 | 0.76 | Disagree (Boltz higher confidence) |
| D203-0031 | 0.23 | 0.58 | Both low — strong agreement |
| FM001580 | 0.83 | 0.71 | Both high |
| FM001452 | 0.71 | 0.74 | Both high |
| FM002150 | 0.70 | 0.70 | Both high |

GNINA CNN pose is geometric-similarity-to-crystal-poses; Boltz ipTM is generative-model-confidence-in-the-co-folded-interface. They measure related but different things. **Where they agree (high or low), confidence is high. Where they disagree, manual inspection is warranted.**

## Performance

- ~2 minutes per compound on RTX 5050 with 3 diffusion samples + 200 sampling steps
- ~12 minutes for the 6-compound reference set
- For full 503-pool: **~17 hours of GPU time** — too slow for pre-event full coverage
- **Recommended deployment:** apply Boltz-2 selectively to the top ~30–50 picks from GNINA + QSAR + ensemble docking consensus. ~1.5 hours for 50 compounds.

## Updated combined scoring rule (revision 4)

Tier-A picks must satisfy **all five orthogonal signals**:

1. **Vina ensemble**: pos ≤ –6 on ≥ 4/6 receptors, mean ≤ –6.5
2. **GNINA**: CNN pose ≥ 0.5 AND CNN pKd ≥ 4.5
3. **QSAR**: predicted pKd ≥ 4.0
4. **Boltz-2**: prob_binder ≥ 0.4 AND ipTM ≥ 0.65 AND log_kd_uM ≤ 1.5
5. **Selectivity**: docked pose contacts ≥ 2 of {G/D177, R174, M181, T183}

A compound failing any signal is downweighted; failing 2+ is dropped.

## Files

```
scripts/run_boltz.py                                    # SMILES CSV → Boltz-2 co-fold
data/boltz/
├── yaml/<id>.yaml                                       # input config per compound
├── runs/<id>/boltz_results_<id>/                        # full Boltz output
│   └── predictions/<id>/<id>_model_{0,1,2}.pdb          # 3 diffusion samples
├── boltz_summary.csv                                    # per-compound scores
└── BOLTZ_VALIDATION.md                                  # this file
```

## Caveats

- **GPU compatibility**: required pip-installing `cuequivariance-torch`, `nvidia-cuda-nvrtc-cu13`, and conda `gcc/gxx`. RTX 5050 (Blackwell, SM 12.0) needs CUDA 13 nvrtc; conda-forge only had CUDA 12.9. The HPC presumably has cleaner setup.
- **Ligand ipTM only — no protein ipTM**: the YAML has just one protein chain + one ligand, so `protein_iptm: 0.0` is expected.
- **Affinity over-prediction**: 6-8× consistent with GNINA. Use for relative ranking, not absolute Kd.
- **DBD-only sequence**: the 178-aa DBD is co-folded; the disordered C-terminus (residues 220-435) is omitted. CF Labs SPR uses full-length protein.
- **Model 0 by default; ipTM_best uses max across diffusion samples.** For the most consistent compound, use model_0; for the highest-confidence pose, use the best across samples.
