# TBXT Analog Candidate Pool — Day 2 Output

**Built 2026-05-06 (T-3 days). 503 candidates ready for on-day docking.**

This is the **wide candidate pool** — input to the on-day filter funnel, NOT a final 4-pick. The on-day workflow will filter by Onepot library membership, dock against site F + A, MD-validate the top picks, then the team selects 4.

## Per-scaffold pools

| Parent scaffold | Method | Raw | Property-fail | Naar-dup | Too-distant | Survivors | **Capped** |
|---|---|---:|---:|---:|---:|---:|---:|
| Z795991852 (CF Labs hit, site F, 10 µM) | BRICS | 306 | 161 | 0 | 49 | 96 | **96** |
| FM001580 (TEP fragment, 2-OCF₃ benzoic acid) | GROW | 124 | 1 | 1 | 1 | 120 | **120** |
| FM001452 (TEP fragment, 3-benzyloxy aniline) | GROW | 218 | 4 | 1 | 9 | 201 | **200** |
| FM002150 (TEP fragment, benzyloxyacetic acid) | GROW | 89 | 2 | 0 | 0 | 87 | **87** |
| **Total** | | **737** | **168** | **2** | **59** | **504** | **503** |

## Filter funnel

Each candidate had to satisfy:

1. **Valid sanitized SMILES** after RDKit canonicalization
2. **Chordoma hard rule**: LogP ≤ 6, HBD ≤ 6, HBA ≤ 12, MW ≤ 600
3. **Relaxed lead-like**: HA ≤ 35, rings ≤ 6, fused rings ≤ 2, no PAINS (Baell 2010)
4. **Tanimoto < 0.85** to all 2232 Naar compounds (avoid duplication)
5. **Tanimoto > 0.40** to parent scaffold (preserve binding signal)
6. After filtering, **per-scaffold cap of 200** with sort priority: lowest Naar-similarity first (most novel), tie-break on highest parent-similarity (best preserves binding hypothesis)

## Pool characteristics

- **Heavy atom range:** 12 – 35
- **MW range:** 166.2 – 466.5
- **Ring count range:** 1 – 6
- **LogP range:** -0.06 – 5.97 (one near the upper bound; all under cap)
- **Tanimoto-to-Naar range:** 0.32 – 0.79 (all comfortably below the 0.85 dup threshold)
- **Tanimoto-to-parent range:** 0.41 – 0.82 (all above the 0.40 floor)

## Smoke test

Sampled 16 candidates (4 from each scaffold: 1 most-novel + 1 closest-to-parent + 2 random) and docked at site F at exhaustiveness 8.

- **16/16 docked successfully** — no pipeline failures (no embed errors, no Meeko writer errors, no Vina failures)
- **Average time:** 2.5 sec/compound at exh 8
- **Full-pool projection:** ~21 min per pocket at exh 8, ~50 min per pocket at exh 16

### Sample top scores from smoke test (site F, exh 8)

| Compound | Score (kcal/mol) | T-to-parent | T-to-Naar | Notes |
|---|---:|---:|---:|---|
| Z795991852_analog_0008 | -8.64 | 0.41 | 0.41 | BRICS: dual chromene-amide, no quinazolinone head. Better-scoring than the parent — needs interpretation. |
| Z795991852_analog_0024 | -7.11 | 0.61 | 0.61 | BRICS: keeps quinazolinone-triazole, NH-amide linker swap |
| Z795991852_analog_0040 | -6.79 | 0.73 | 0.73 | BRICS: simplified right-half, retains parent backbone |
| FM002150_analog_0029 | -6.02 | 0.45 | 0.32 | Benzyloxyacetic acid + piperidine — site F fragment grown to ring-bearing |
| FM001580_analog_0048 | -5.80 | — | — | OCF₃ benzoic acid + methylcarbamoyl — fragment grown |

The Z795991852_analog_0008 case is a **classic Vina-trap**: a BRICS recombination produced a more "extended" molecule that scores well because of contact area, not because of any defensible binding hypothesis. The on-day team must apply chemical judgment when evaluating high-scoring candidates from BRICS recombination.

## Files

```
data/analogs/
├── Z795991852_candidates.csv     # 96 BRICS analogs of the CF Labs hit
├── FM001580_candidates.csv       # 120 grow analogs of the OCF3 benzoic acid
├── FM001452_candidates.csv       # 200 grow analogs of the benzyloxy aniline
├── FM002150_candidates.csv       # 87 grow analogs of the benzyloxyacetic acid
├── all_candidates.csv            # ⭐ master pool, 503 rows, all columns
├── smoke_test_input.csv          # 16-compound sample
├── smoke_test_F/                 # smoke-test docking output
├── enumeration_log.md            # provenance + per-scaffold counts
└── ANALOG_POOL.md                # this file
```

## Per-row schema (all_candidates.csv)

| Column | Description |
|---|---|
| id | Unique generated ID, format `<parent>_analog_NNNN` |
| smiles | Canonical SMILES |
| parent_id | Scaffold parent (one of: Z795991852, FM001580, FM001452, FM002150) |
| parent_smiles | Canonical SMILES of the parent |
| method | Generation method (`brics`, `grow_aromCH_<R>`, `<bioisostere_rule>`, `grow_aniline_<R>`) |
| ha, mw, hbd, hba, logp, tpsa, rotb, rings, fused_rings | RDKit descriptors |
| tanimoto_to_parent | Morgan FP (r=2, 2048 bits) Tanimoto to parent |
| max_tanimoto_to_naar | Max Tanimoto across all 2232 Naar compounds |
| naar_neighbor | Naar ID of the closest Naar neighbor |

## On-day usage

```bash
source /home/anandsahu/miniconda3/etc/profile.d/conda.sh && conda activate tbxt
cd ~/Hackathon/TBXT

# Step 1 (on-day): filter by Onepot library membership
#   This produces data/analogs/onepot_pool.csv — the survivors after Onepot lookup
#   (TBD interface; placeholder for now)

# Step 2: dock the Onepot-filtered pool at sites F and A in parallel
python scripts/dock.py --smiles-csv data/analogs/onepot_pool.csv \
    --site F --out-dir data/analogs/dock_F --exhaustiveness 16
python scripts/dock.py --smiles-csv data/analogs/onepot_pool.csv \
    --site A --out-dir data/analogs/dock_A --exhaustiveness 16

# Step 3: pose contact analysis to identify which compounds hit anchor residues
python scripts/analyze_poses.py --validation-dirs data/analogs/dock_F data/analogs/dock_A

# Step 4: combined ranking — to be written on the day with the team
#   priority: anchor-contact count, Vina score, T-to-CF-Labs-hit, chemistry sanity
```

## Known limitations

1. **BRICS over-shuffles.** The Z795991852 BRICS pool contains analogs that have lost the parent's head group entirely (e.g., analog_0008 is a dual chromene-amide compound with no quinazolinone). These may not bind site F — they're geometric matches, not pharmacophoric. **The on-day team should manually inspect the top BRICS hits and downweight any that lack a defensible anchor.**
2. **Aromatic-CH growing produces some chemically odd compounds.** Substituting an aromatic H with `OCCO` creates a hydroxyethoxy that may not be tolerated synthetically — Onepot lookup will catch most of these.
3. **No 3D conformer-based design.** All enumeration is topology-only. Designs that "should" point a substituent at D177 may not actually do so in 3D.
4. **No retrosynthetic check against the 7 onepot reactions** beyond the implicit bias of using BRICS / SMARTS rules. The on-day Onepot lookup is the authoritative filter.
5. **Stereochemistry**: BRICS may produce racemic outputs where the parent had defined stereo (Z795991852_analog_0008 lacks the parent's chiral C in the chromene). RDKit ETKDG embedding will pick one stereoisomer at docking time.
