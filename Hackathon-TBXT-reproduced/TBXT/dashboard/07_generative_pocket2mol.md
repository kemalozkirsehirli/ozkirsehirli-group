# Task 7 — Pocket-conditioned generative chemistry (Pocket2Mol / DiffSBDD)

**Owner:** GPU-4. **Compute:** A100. **Effort:** ~8 h wall-clock, ~30 GPU-hours. **Depends on:** Task 0.

## What you're solving

Our current generative output (67 BRICS-recombination proposals) is **not pocket-conditioned** — it samples chemical space without using site F's 3D geometry. A pocket-conditioned model (Pocket2Mol or DiffSBDD) generates compounds explicitly fit to the pocket atoms. These have a much higher hit rate when ranking by structure-aware score.

This is the **highest-novelty source we have** — generated compounds are not just unenumerated; they're not in any catalog, period.

## What you produce

`data/generative_pocket/proposals.csv` — 200 high-quality novel compounds:
- `id, smiles`
- Already passed: validity, Chordoma hard rule, lead-like, Tanimoto < 0.85 to all 2 274 known, QSAR pKd ≥ 4.0
- Sorted by QSAR pKd

These feed into the consensus pool (Task 10) alongside the existing 503 enumerated + 67 BRICS = 570 → expanded to ~770.

## Setup (the challenging step)

Pocket-conditioned generative models are research code, not pip-installed libraries. You need to clone + install + download checkpoints. Try in priority order:

### Option A: DiffSBDD (recommended — simpler install)

```bash
cd ~/tbxt
git clone https://github.com/arneschneuing/DiffSBDD.git ~/diffsbdd
cd ~/diffsbdd

# Install in our existing env
pip install -r requirements.txt

# Download pretrained checkpoint (~1 GB)
mkdir -p checkpoints
wget https://zenodo.org/record/8183747/files/crossdocked_fullatom_cond.ckpt -P checkpoints/

# Quick smoke test
python generate_ligands.py \
    --pdbfile ~/tbxt/data/dock/receptor/6F59_apo.pdb \
    --outdir /tmp/test_diffsbdd \
    --n_samples 10 \
    --resi_list_id A:42,A:88,A:177  # site F anchors
```

### Option B: Pocket2Mol (if DiffSBDD doesn't work)

```bash
git clone https://github.com/pengxingang/Pocket2Mol.git ~/pocket2mol
cd ~/pocket2mol
pip install -r requirements.txt
# Download checkpoint per their README
```

### Option C: Skip if both options have install issues > 2 hours

Fall back to running the existing `scripts/generate_proposals.py` (BRICS) at 100K samples (vs the current 30K) to get more diversity. This produces more proposals but they're not pocket-conditioned.

```bash
# Edit MAX_GENERATE = 100_000 in scripts/generate_proposals.py, then:
python scripts/generate_proposals.py
```

## Run (assuming DiffSBDD)

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate

# Generate ~10 000 candidates conditioned on site F pocket
python ~/diffsbdd/generate_ligands.py \
    --pdbfile data/dock/receptor/6F59_apo.pdb \
    --outdir data/generative_pocket/raw \
    --n_samples 10000 \
    --resi_list_id A:42,A:88,A:177,A:81,A:82,A:83,A:172,A:174,A:181,A:183 \
    --batch_size 64

# Filter via existing pipeline (validity + property + Tanimoto + QSAR)
python scripts/team/filter_generative.py \
    --raw data/generative_pocket/raw \
    --known data/prior_art_canonical.csv \
    --qsar-models data/qsar/ \
    --out data/generative_pocket/proposals.csv \
    --top-n 200
```

## Success criteria

- 10K raw samples generated.
- After filtering, ≥ 100 survivors (we want 200; if fewer, expand sample count).
- Top-50 by QSAR pKd: at least 50% have at least one structural feature consistent with TBXT-pharmacophore (carboxylate / aniline / aryl-amide near sites where Y88/D177 would interact).
- Tanimoto-to-known of all survivors < 0.85, mean ≈ 0.30–0.45.

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Owner>  STATUS=done
RESULT: 10K raw → <N> survivors → top 200 by QSAR; mean T_known = <X>; top picks: <ids>
DELIVERABLE: data/generative_pocket/proposals.csv
GOTCHAS: <which tool worked, install caveats, hardware requirements>
NEXT: pass to Task 10 (consensus pool); also feed top 50 to Task 4 (Boltz) and Task 2 (multi-seed GNINA)
```

## If something goes wrong

| Issue | Fix |
|---|---|
| DiffSBDD install fails on dependencies | Try Pocket2Mol; if both fail, fall back to BRICS @ 100K |
| Generated SMILES are mostly invalid (>50%) | Use higher temperature in sampling; or filter aggressively for chemically plausible compounds before QSAR |
| GPU OOM | Lower batch_size from 64 → 16 |
| Generated compounds are all very small (HA < 12) | Adjust the size-conditioning parameter; aim for HA in [15, 30] |

## Notes

- **Realistic novelty:** pocket-conditioned generative models produce compounds with ~30–50% chemically plausible. After filters, expect 1–5% survival to top-200. So 10K raw → ~100–500 viable.
- **Don't expect generative compounds to dominate Tier-A.** They're an *additional* source of diversity, not a replacement for the validated chemistry. Even if they all fail Tier-A, the *attempt* is part of the rationale ("we explored pocket-conditioned generative space and the best survivors are X").
