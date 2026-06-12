# Task 8 — FEP (free-energy perturbation) on top 8 picks

**Owner:** GPU-3 (Task 5 owner — they have the OpenMM toolchain warm). **Compute:** A100. **Effort:** ~12 h wall-clock, ~40 GPU-hours. **Depends on:** Task 0 + Task 5 (MMGBSA toolchain proves).

## What you're solving

FEP is the **gold-standard relative binding-affinity prediction**. While Vina/GNINA/Boltz/QSAR/MMGBSA all over-predict by 6–25× in absolute units, FEP can predict **relative ΔΔG between two compounds within ±1 kcal/mol** of experiment — i.e., 3× in Kd. That's the precision we need to choose between top picks.

We're not running FEP on all 570 — that'd be ~80 GPU-days. We run it on **pairs of similar compounds among our top 8 candidates**, perturbing one into another and measuring the ΔG difference. This gives us a **reliable ranking among the top picks** with which to make the final 4-pick.

## What you produce

`data/fep/relative_dg_table.csv` — a lower-triangular matrix of ΔΔG values between pairs:

| Pair | ΔΔG_FEP (kcal/mol) | error_kcal | n_lambda | runtime |
|---|---|---|---|---|
| compound_A → compound_B | –1.3 | 0.4 | 12 | 6 GPU-h |
| compound_A → compound_C | +0.5 | 0.5 | 12 | 6 GPU-h |
| ... | ... | ... | ... | ... |

Plus a summary: a single ranked list of the top 8 with **relative ΔG values to a reference (Z795991852)** as the anchor.

## Setup

We use **OpenFE** (https://github.com/OpenFreeEnergy/openfe) — an open-source FEP framework that's well-maintained and works with our existing OpenFF + OpenMM toolchain.

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate
conda install -y --override-channels -c conda-forge openfe perses

# Smoke test
python -c "import openfe; print('openfe:', openfe.__version__)"
```

## Run

The script `scripts/team/run_fep.py` is **the most non-trivial script in the team handoff** — it constructs the perturbation pairs, runs the alchemical MD, parses the BAR (Bennett acceptance ratio) results.

```bash
# Step 1: pick the top 8 candidates from current Tier-A multi-seed list
head -9 data/tier_a/tier_a_candidates.csv > /tmp/top8_input.csv

# Step 2: run pairwise FEP. The pairs are constructed by Tanimoto-similarity (closest pairs first)
python scripts/team/run_fep.py \
    --candidates /tmp/top8_input.csv \
    --reference Z795991852 \
    --receptor-pdb data/dock/receptor/6F59_apo.pdb \
    --pose-dir data/full_pool_gnina_F/poses \
    --out-dir data/fep \
    --n-lambda 12 \
    --md-ns 5

# Pairs to run: top8 × Z795991852 (reference) = 8 perturbations
# Each: 12 lambda windows × 5 ns each = ~5-6 GPU-hours
# Total: 8 × ~6 h = ~50 h of compute. Distribute across team's GPUs.
```

**Sharding across team GPUs (recommended):**
- Each top-8 compound gets its own GPU.
- Run them all in parallel.
- 12 lambda windows each, 5 ns × 12 = 60 ns of MD per pair.
- Wall-clock: ~6 h per GPU.

```bash
# On GPU 1
python scripts/team/run_fep.py --pairs Z795991852+gen_0004 --out-dir data/fep/runs/01

# On GPU 2
python scripts/team/run_fep.py --pairs Z795991852+gen_0025 --out-dir data/fep/runs/02

# ... etc.
```

## Success criteria

- All 8 perturbations complete with BAR errors < 1 kcal/mol per leg.
- Reference compound Z795991852 has ΔΔG = 0 (sanity).
- For Z795991852 vs Z979336988 (where we know real Kd ratio = 30/10 = 3×, so ΔΔG_real ≈ 0.65 kcal/mol):
  - FEP predicts ΔΔG within ±1 kcal/mol of 0.65 → method is calibrated for our system.
- Top 8 ranked by FEP-derived absolute ΔG (anchored to Z795991852's known 10 µM).

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Owner>  STATUS=done
RESULT: 8/8 perturbations converged; mean BAR error = 0.5 kcal/mol; ranking: <gen_0004 best, then gen_0025, ...>
DELIVERABLE: data/fep/relative_dg_table.csv + data/fep/ranked_top8.csv
GOTCHAS: <e.g., gen_0004→Z795991852 had high variance, ran extra 2 ns to converge>
NEXT: pass to Task 10 (consensus); these 8 are the definitive ranking
```

## If something goes wrong

| Issue | Fix |
|---|---|
| OpenFE install fails | Try `pip install openfe-quickstart` instead; or use Perses directly |
| Lambda window crashes (energy explodes) | Re-run with smaller alchemical step size (`--soft-core`); add restraints during the alchemical transformation |
| BAR error > 1 kcal/mol | Need more lambda windows (12 → 24) or longer MD per window (5 ns → 10 ns); compute cost doubles |
| One compound has very different chemistry | Skip it from FEP; rank via consensus of other signals only |
| GPU OOM on lambda window | Smaller box; lower MD step from 4 fs → 2 fs |

## Stretch (if budget permits)

Run **double-decoupling** style FEP (alchemical decoupling of ligand from protein + from water) for absolute ΔG_bind. Much more expensive (~3× per compound) but gives absolute Kd estimates, not just relative.

## Notes

- **FEP is the most expensive task in the plan** but also the most powerful. Don't skip it for the top 4 final candidates.
- **Lambda window count matters.** 12 is a baseline; 24 is "publishable." Tune based on convergence.
- **Reference compound choice:** Z795991852 because (a) it's a confirmed CF Labs binder at 10 µM, (b) it's structurally similar to many Tier-A picks (analog parent), so the perturbation is small.
- **Realistic precision:** ±1 kcal/mol = 6× in Kd — i.e., FEP can confidently distinguish 5 µM from 30 µM but probably not 5 µM from 10 µM.
