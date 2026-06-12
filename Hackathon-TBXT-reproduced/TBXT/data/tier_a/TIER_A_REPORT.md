# Tier-A Report — Pre-Event Frontrunners

**As of 2026-05-07 01:34 (T-2 days).** GNINA full-pool docking + Tier-A merge complete.

## Numbers

| | Count |
|---|---:|
| Combined pool (analogs + generative) | 570 |
| GNINA-scored | 569 / 570 (1 prep failure) |
| **Tier-A (all 4 hard signals pass)** | **40** |
| Tier-B (relaxed) | 51 |
| Vina-traps caught + downweighted | 73 |
| Failed all signals (dropped) | ~410 |

**Tier-A scoring rule (all four required):**
- GNINA `cnn_pose ≥ 0.5` AND `cnn_pKd ≥ 4.5` AND `vina ≤ –6.0`
- QSAR `pKd ≥ 4.0`

## Top 10 Tier-A picks

| Rank | ID | Source | CNN pose | CNN pKd | QSAR pKd | Vina | GNINA Kd | QSAR Kd | T-naar |
|:---:|---|---|---:|---:|---:|---:|---:|---:|---:|
| 1 | `gen_0004` | generative | **0.70** | 6.45 | 4.64 | -7.91 | **0.35 µM** | 23 µM | 0.30 |
| 2 | `gen_0025` | generative | 0.69 | 6.29 | 4.32 | -7.46 | 0.51 µM | 48 µM | 0.39 |
| 3 | `gen_0007` | generative | 0.68 | 6.11 | 4.56 | -7.37 | 0.79 µM | 27 µM | 0.32 |
| 4 | `Z795991852_analog_0011` | analog | 0.70 | 5.92 | 4.11 | -7.39 | 1.22 µM | 78 µM | 0.65 |
| 5 | `Z795991852_analog_0087` | analog | 0.64 | 6.05 | 4.30 | -8.04 | 0.89 µM | 50 µM | 0.55 |
| 6 | `Z795991852_analog_0001` | analog | 0.67 | 5.92 | 4.18 | -7.61 | 1.21 µM | 66 µM | 0.64 |
| 7 | `Z795991852_analog_0053` | analog | 0.60 | 6.09 | 4.54 | -7.78 | 0.81 µM | 29 µM | 0.47 |
| 8 | `gen_0002` | generative | 0.56 | 6.20 | 4.69 | -7.85 | 0.63 µM | 20 µM | 0.33 |
| 9 | `Z795991852_analog_0059` | analog | 0.60 | 6.41 | 4.51 | -7.05 | 0.39 µM | 31 µM | 0.51 |
| 10 | `Z795991852_analog_0051` | analog | 0.70 | 5.54 | 4.27 | -6.71 | 2.90 µM | 53 µM | 0.49 |

## Pick distribution

| Source | Tier-A count |
|---|---:|
| Generative proposals (BRICS+QSAR) | 14 |
| Z795991852 analogs (BRICS recombination) | 26 |
| FM001580 / FM001452 / FM002150 analogs | **0** |

**FM001580/FM001452/FM002150 fragment-derived analogs DO NOT make Tier-A** — their QSAR pKd is too low because the parents are weak fragments (Kd predicted ~500-1500 µM by QSAR). The fragment-elaboration strategy doesn't reach the Tier-A bar even with strong CNN pose scores. **For the 4-pick, lean on Z795991852 chemistry + generative pyrimidobicyclic chemistry.**

## Top SMILES (clipboard-ready)

```
gen_0004                COc1cc2nc(-c3cccc(N)c3)nc(Cn3nc4ccccn4c3=O)c2cc1N
gen_0025                COc1cc2nc(-c3cccc(N)c3)nc(NS(=O)(=O)c3ccc(C)cc3)c2cc1N
gen_0007                COc1cc2nc(-c3cccc(N)c3)nc(-n3nc4ccccn4c3=O)c2cc1N
Z795991852_analog_0011  Cn1c(=O)c2ccccc2n2c(CNC(=O)C3Cc4ccccc4O3)nnc12
Z795991852_analog_0087  Cn1c(=O)c2ccccc2n2c(COc3cccc(C4Cc5ccccc5O4)c3)nnc12
Z795991852_analog_0001  Cn1c(=O)c2ccccc2n2c(NC(=O)C3Cc4ccccc4O3)nnc12
Z795991852_analog_0053  Cn1c(=O)c2ccccc2n2c(-c3cccc(CNC4Cc5ccccc5O4)c3)nnc12
gen_0002                COc1cc2nc(-c3cccc(N)c3)nc(CN3C(=O)c4ccccc4C3=O)c2cc1N
Z795991852_analog_0059  Cn1c(=O)c2ccccc2n2c(Oc3cccc(NC4Cc5ccccc5O4)c3)nnc12
Z795991852_analog_0051  Cn1c(=O)c2ccccc2n2c(NC3Cc4ccccc4O3)nnc12
```

## Recommended 4-pick composition (for the team to refine on the day)

The 4 picks should span ≥ 2 chemotypes for diversity. Suggested:

| Slot | Pick | Rationale |
|:---:|---|---|
| 1 | **`gen_0004`** | Most novel (T_naar 0.30); top CNN pose; distinct pyrimidobicyclic+triazolopyridazinone chemotype not in disclosed set |
| 2 | **`Z795991852_analog_0087`** | Z795991852 chemotype preserved (quinazolinone-triazole core); novel right-half (chromene-aniline ether); strong Vina (-8.04) |
| 3 | **`gen_0025`** | Sulfonamide attachment — ortholog to gen_0004's amide attachment; chemotype diversity within the generative cluster |
| 4 | **`Z795991852_analog_0051`** | Simplest Z795991852 derivative — direct N-chromene-amine; highest CNN pose (0.70); compact MW for synthesis |

This composition gives **2 chemotypes × 2 each**:
- **Pyrimidobicyclic head** (gen_0004, gen_0025) — novel, scaffold-hops away from disclosed
- **Methylquinazolinone-triazole head** (Z795991852_analog_0087, _0051) — validated chemotype, novel R-groups

**On-day verification before submission:**
1. Onepot library membership for all 4 — gating filter
2. Boltz-2 co-fold for all 4 — confidence + binding-mode validation (~10 min total)
3. Anchor-contact analysis for selectivity narrative (Y88, D177, R174, M181, T183 contacts)
4. PAINS + property final check

## Caveats

1. **CNN pose has run-to-run variance**. Some compounds (e.g. Z795991852_analog_0024) flagged as Vina-trap in earlier smoke test (CNN pose 0.29) but pass Tier-A here (CNN pose 0.52). Vina's stochastic sampling produces different poses on different runs. **For final picks, run GNINA at exhaustiveness 16 with multiple seeds and average.**
2. **QSAR over-rates Z795991852 analogs** because Z795991852 is in training. The Z795991852 analogs may not actually outperform the parent in CF Labs SPR (parent already at 10 µM). Generative pyrimidobicyclic compounds are more genuinely novel.
3. **Onepot membership unverified** — most likely a fraction of the 40 Tier-A will fail onepot synthesis check. Have backups in Tier-B (51 compounds).
4. **No site-A picks in Tier-A** — all 40 picks are site F geometry. Diversification across binding sites isn't possible from the current pool. Consider running GNINA at site A on the same 570 to surface site-A Tier-A candidates if time on the day.

## Files

```
data/full_pool_input.csv             570-compound combined pool
data/full_pool_gnina_F/              full-pool GNINA scoring at site F
data/tier_a/
├── all_signals.csv                  every compound × every signal
├── tier_a_candidates.csv            40 Tier-A compounds, ranked
├── tier_b_candidates.csv            51 Tier-B compounds, ranked
└── TIER_A_REPORT.md                 this file
```

## Reproduce

```bash
source /home/anandsahu/miniconda3/etc/profile.d/conda.sh && conda activate tbxt
cd ~/Hackathon/TBXT
python scripts/dock_gnina.py --smiles-csv data/full_pool_input.csv \
    --site F --out-dir data/full_pool_gnina_F --exhaustiveness 8
python scripts/merge_signals.py
```
