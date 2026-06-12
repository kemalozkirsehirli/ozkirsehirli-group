# Generative Chemistry — Strategy 7 Complete

**67 novel pocket-relevant proposals** generated via BRICS-recombination of the prior-art reservoir, scored with our TBXT-specific QSAR.

## Why BRICS-recombination

REINVENT4 / Pocket2Mol / DiffSBDD are the typical pocket-conditioned generative tools. None install cleanly without external GitHub clone + pretrained-checkpoint download (blocked by user's hooks). BRICS recombination is a recognized chemoinformatic generative method — bond-rule-constrained, RDKit-only, target-agnostic but cheap. Combined with our TBXT-specific QSAR scoring, it delivers the value of "search chemistry-space we haven't enumerated" while staying inside our toolchain.

## Pipeline

```
Seed reservoir (180 compounds):
  42 TEP fragments (crystallographically bound at sites A-G)
  135 Naar Sheet disclosed compounds (curated TBXT screen set)
  4  priority scaffolds (Z795991852, Z979336988, FM001580, FM001452, FM002150)
        ↓
  BRICS.BRICSDecompose → unique fragments (synthesizable bond breakages)
        ↓
  BRICS.BRICSBuild (scrambleReagents=True, maxDepth=5)
        → 30,000 unique novel SMILES in 65 seconds
        ↓
  Filter funnel:
    • Validity + sanitization                   (29,940 → 30,000)
    • Chordoma hard rule + relaxed lead-like:    (285 / 30,000)
      MW ≤ 600, LogP ≤ 6, HBD ≤ 6, HBA ≤ 12,
      HA ≤ 35, rings ≤ 6, fused ≤ 2, no PAINS
    • Tanimoto < 0.85 to all 2,274 known:        (283 / 285)
    • QSAR predicted pKd ≥ 4.0:                  ( 67 / 283)
        ↓
  Final: 67 novel proposals
```

## Headline numbers

- **30,000 raw SMILES in 65s** — BRICS recombination is fast
- **0.95% property pass-through** — most BRICSBuild outputs exceed MW 600 (cap at 5 fragments stacks heavy)
- **99% novelty** — almost all property-passers are dissimilar to known compounds
- **24% QSAR pass** — 67/283 predicted to bind in µM range
- **Predicted Kd range of survivors: 19–37 µM** — moderate, between TEP fragments (>500 µM) and CF Labs hits (1-4 µM in QSAR)

## Top 10 proposals

| ID | QSAR pKd | Pred Kd | T_known | HA | Rings | SMILES head |
|---|---:|---:|---:|---:|---:|---|
| gen_0001 | 4.72 | 19 µM | 0.34 | 30 | 5 | `COc1cc2nc(-c3cccc(N)c3)nc(N3CCOC[C@]34CCOC4)c2cc1N` |
| gen_0002 | 4.69 | 21 µM | 0.33 | 32 | 5 | `COc1cc2nc(...)nc(CN3C(=O)c4ccccc4C3=O)c2cc1N` |
| gen_0003 | 4.65 | 23 µM | 0.35 | 31 | 5 | `COc1cc2nc(...)nc(N3C(=O)c4ccccc4C3=O)c2cc1N` |
| gen_0004 | 4.64 | 23 µM | 0.30 | 31 | 5 | `COc1cc2nc(...)nc(Cn3nc4ccccn4c3=O)c2cc1N` |
| gen_0005 | 4.64 | 23 µM | 0.32 | 30 | 5 | `COc1cc2nc(...)nc(-c3nnc4n3CCCCC4)c2cc1N` |
| gen_0006 | 4.62 | 24 µM | 0.36 | 33 | 5 | `COc1cc2nc(...)nc(NCc3ccc4c(c3)C(=O)NCC4)c2cc1N` |
| gen_0007 | 4.56 | 27 µM | 0.32 | 30 | 5 | `COc1cc2nc(...)nc(-n3nc4ccccn4c3=O)c2cc1N` |
| gen_0008 | 4.49 | 33 µM | 0.34 | 31 | 5 | `COc1cc2nc(...)nc(-c3cnc4[nH]c(=O)n(C)c4c3)c2cc1N` |
| gen_0009 | 4.46 | 35 µM | 0.32 | 32 | 5 | `COc1cc2nc(...)nc(N3C(=O)c4ccc(C)cc4C3=O)c2cc1N` |
| gen_0010 | 4.43 | 37 µM | 0.37 | 30 | 4 | `COc1cc2nc(...)nc(NS(=O)(=O)N3CCNCC3)c2cc1N` |

The top scaffold is a **dimethoxyquinazoline / pyrimidine-fused-bicyclic** core inherited from the disclosed CF-* / D203-* compounds, decorated with diverse R-groups. The scaffold itself is well-explored (CF-10-045 etc.) but the **R-group combinations are novel** (T-known 0.30-0.37 means substantially different from any disclosed compound).

## What this adds to the candidate pool

| Source | Compounds |
|---|---:|
| Enumerated analogs (Strategy 1+2 from analog enumeration) | 503 |
| **Generative proposals (Strategy 7)** | **67** |
| Combined pre-event candidate pool | **570** |

The 67 generative proposals **explore different chemistry** than the 503 analogs:
- Enumerated analogs share scaffolds with one of {Z795991852, FM001580, FM001452, FM002150}
- Generative proposals span the full BRICS-fragment combinatorial space, weighted toward Naar-disclosed scaffolds (not just our 4 priority parents)

## On-day deployment

These 67 proposals go into the on-day funnel alongside the 503 analogs. Same filtering pipeline:
1. Onepot library membership check (gating filter)
2. GNINA dock at site F + A
3. QSAR re-score (already done; included in CSV)
4. Boltz-2 co-fold for top picks
5. Manual chemistry curation

## Caveats

- **Not pocket-conditioned**: no 3D pocket geometry was used in generation. The QSAR scoring is target-specific (TBXT) but ligand-based. Pocket2Mol / DiffSBDD would do better here, but require GitHub-checkpoint installs we couldn't do automatically.
- **Heavy bias toward existing scaffolds**: BRICS recombination starts from existing fragments, so the proposals tend to resemble combinations of disclosed motifs, not radical novelty. Tanimoto 0.30-0.37 is in the "scaffold-hopping" regime, not "totally new chemotype."
- **QSAR scores must be cross-validated with GNINA + Boltz-2 on-day**. The 67 proposals are scored only with QSAR; they haven't been docked yet.
- **PAINS filter is the strict Baell 2010 catalog**. More aggressive PAINS catalogs (Brenk, NIH) might remove a few more.
- **Onepot membership is unverified** until on-day. Most likely a fraction of the 67 will fail Onepot synthesis check.

## Files

```
scripts/generate_proposals.py            # full pipeline
data/generative/
├── generative_proposals.csv             # 67 proposals × scores + descriptors
└── GENERATIVE_VALIDATION.md             # this file
```
