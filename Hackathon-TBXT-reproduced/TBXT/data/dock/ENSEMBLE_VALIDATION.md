# Ensemble Docking Validation — Strategy 5 Complete

**6 receptor conformations, 16 reference compounds, validation at site F.**

## Receptor ensemble

| Conformation | Source | State | Use |
|---|---|---|---|
| 6F59_A | 6F59 chain A | G177D + DNA, primary monomer | Default for all earlier docking |
| 6F59_B | 6F59 chain B | G177D + DNA, dimer partner | Tests dimer-interface variant |
| 6F58_A | 6F58 chain A | WT (G177) + DNA | Sanity vs G177D |
| 5QS9_A | 5QS9 chain A | G177D apo, sites A-E fragment-bound | Apo conformation |
| 5QSA_A | 5QSA chain A | WT apo, FM001580 (K2P) bound at site F | Best site-F geometry |
| 5QSI_A | 5QSI chain A | WT apo, FM001452 (O1D) bound at site F | Site-F variant |

All 6 receptors have site F + site A grids (10–11 anchor residues found in each). Site F grid centers cluster around (6, –13, –6) Å for the apo conformations and (–0.6, –13, –6) for 6F59_A — a ~7 Å shift due to dimer/DNA-induced conformation differences.

## Reference set ensemble docking at site F

| Compound | Mean | Median | Best | Worst | Stdev | pos ≤ –6 / 6 | Note |
|---|---:|---:|---:|---:|---:|:---:|---|
| Z795991852 (CF: 10 µM) | **-7.85** | -7.99 | -9.41 | -6.40 | 1.06 | **6/6** | Most variant: stdev 1.06 |
| Z979336988 (CF: 30 µM) | -7.68 | -7.81 | -8.94 | -6.00 | 0.99 | **6/6** | Robust |
| D203-0031 (CF: 17 µM) | -7.43 | -7.54 | -8.03 | -6.78 | **0.56** | **6/6** | Most consistent (lowest stdev) |
| FM001452 (TEP frag) | -5.26 | -5.35 | -5.72 | -4.79 | 0.38 | 0/6 | Fragment-grade, consistent |
| FM001580 (TEP frag) | -5.11 | -5.11 | -5.93 | -4.33 | 0.52 | 0/6 | Fragment-grade |
| FM002150 (TEP frag) | -4.80 | -4.96 | -5.34 | -4.06 | 0.46 | 0/6 | Smallest fragment, weakest |

**Headline:** Ensemble dramatically separates classes. CF Labs hits = 6/6 ≤ -6 with mean -7.4 to -7.9; TEP fragments = 0/6 ≤ -6 with mean -4.8 to -5.3. **The 6/6 vs 0/6 split is a powerful classifier.**

## Analog smoke test ensemble docking

Top 5 by ensemble mean:

| Compound | Ens mean | Stdev | pos ≤ –6 | Cross-check (GNINA + QSAR) |
|---|---:|---:|:---:|---|
| Z795991852_analog_0008 | -8.27 | 0.51 | **6/6** | GNINA CNN pose 0.63, QSAR 3.94 — moderate signals |
| **Z795991852_analog_0024** | -8.27 | 0.56 | **6/6** | **VINA-TRAP** (CNN pose 0.29) — ensemble does NOT catch this |
| Z795991852_analog_0040 | -7.35 | 1.05 | 6/6 | CNN pose 0.49, QSAR 4.64 |
| Z795991852_analog_0090 | -6.84 | 0.57 | 6/6 | CNN pose 0.41, QSAR 4.01 |
| FM001452_analog_0120 | -5.96 | 0.67 | 3/6 | Mid-tier |

**Key finding: ensemble does NOT catch Vina-traps.** `Z795991852_analog_0024` scores at -8.27 across all 6 conformations because its problem is a scoring-function bias (contact maximization with non-native geometry), not receptor-conformation-dependent. **CNN pose score remains essential as the geometry-validity check.**

## What ensemble docking adds vs single-receptor

1. **Robustness signal**: a compound that scores ≤ -6 on 6/6 receptors is more credible than one that scores -10 on a single conformation but -3 on others. CF Labs hits all clear this bar.
2. **Conformer-dependence detection**: high stdev across receptors = compound exploits a single-conformation geometry. Z795991852 (stdev 1.06) is more conformer-dependent than D203-0031 (stdev 0.56).
3. **Apo vs DNA-bound discrimination**: 5QSA_A (apo) and 6F59_A (DNA-bound) have different site F geometries (~7 Å center shift). Compounds that score well on both are likely binders in either state.
4. **Dimer interface effect**: 6F59_B (dimer partner) tests whether site F geometry differs at the partner protomer. CF Labs hits score well on 6F59_B too — site F is bilaterally accessible.

## What ensemble docking does NOT solve

1. **Scoring function noise.** Vina's empirical score still over-rewards contacts. CNN pose score (GNINA) is required to filter Vina-traps.
2. **Pharmacophore signal.** Ensemble agrees on geometric fit but doesn't know whether compound's pharmacophore matches known TBXT binders. QSAR is required for that.
3. **Induced fit.** All 6 receptors are rigid in their respective crystal poses. Compounds requiring induced-fit beyond what's captured in these 6 snapshots will be missed.

## Updated combined scoring rule (revision 3)

Tier-A picks must satisfy **all four** orthogonal signals:

- **Vina ensemble**: pos ≤ –6 on **≥ 4 of 6 receptors**, mean ≤ –6.5
- **GNINA**: CNN pose ≥ 0.5 AND CNN pKd ≥ 4.5
- **QSAR**: predicted pKd ≥ 4.0
- **Selectivity** (rationale): docked pose contacts ≥ 2 of {G/D177, R174, M181, T183} (TBXT-unique residues)

A compound failing any signal is downweighted; failing 2+ is dropped.

## Performance

- 6 reference compounds × 6 receptors at exhaustiveness 8 = 36 docks in **3 min** wall-clock
- 16 analogs × 6 receptors = 96 docks in **4.7 min**
- Per-compound, per-receptor: ~3 sec at exh 8
- **Full 503 pool × 6 receptors at site F + A** projected: ~50 min on this 16-CPU machine; ~10–15 min on HPC GPU.

## Files

```
scripts/prep_ensemble.py            # builds 6 receptor PDBQTs + grids
scripts/dock_ensemble.py            # ensemble docking + consensus
data/dock/receptor/ensemble/        # 6 PDBQT files + apo PDBs + ensemble_grids.json
data/dock/ensemble_F/               # validation set ensemble results
data/analogs/ensemble_smoke_F/      # smoke-test ensemble results
data/dock/ENSEMBLE_VALIDATION.md    # this file
```

## Caveats

- **Ensemble grids drift**: site F center varies from (–0.6, –13, –6) on 6F59_A to (6, –13, –6) on 5QSA_A — a 7 Å shift. The 22 Å box covers both, but compounds that score in different sub-pockets per receptor are hard to interpret.
- **6 conformations are still few**. A "true ensemble" approach uses 50-100 MD-generated conformations. We're approximating.
- **Apo and DNA-bound mix**. Including 6F58/6F59 (DNA-bound) and 5QS9/5QSA/5QSI (apo) tests both states, but the "right" state for ligand binding is debated. CF Labs SPR uses biotinylated TBXT in solution = no DNA = closer to apo. Weight apo conformations higher in the consensus if drift is excessive.
