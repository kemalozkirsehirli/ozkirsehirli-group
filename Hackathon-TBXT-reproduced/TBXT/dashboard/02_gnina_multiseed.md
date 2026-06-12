# Task 2 — Multi-seed GNINA on full 570 pool (CNN pose noise reduction)

**Owner:** GPU-1. **Compute:** A100. **Effort:** ~2 h wall-clock, ~5 GPU-hours. **Depends on:** Task 0.

## What you're solving

CNN pose score has documented run-to-run variance. We saw `Z795991852_analog_0024` flagged as Vina-trap (CNN pose 0.29) on one run, then Tier-A (CNN pose 0.52) on another. **A single GNINA run is not enough to trust the pose-score filter.**

This task runs GNINA at 10 different random seeds and averages the per-pose CNN scores. Compounds with reproducibly high CNN pose are robust; ones whose scores swing > 0.2 between seeds are flagged as "noisy" (lower confidence).

## What you produce

`data/full_pool_gnina_F_multiseed/dock_results_multiseed.csv` with columns:

| Column | Meaning |
|---|---|
| id | compound id |
| smiles | canonical SMILES |
| cnn_pose_mean | mean CNN pose across 10 seeds |
| cnn_pose_stdev | stdev across seeds (= robustness signal) |
| cnn_pose_min, cnn_pose_max | range |
| vina_kcal_mean | mean Vina best across seeds |
| cnn_pkd_mean | mean CNN pKd |
| n_seeds | should be 10 |

## How to run

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

# Already-wired script in scripts/team/dock_gnina_multiseed.py
python scripts/team/dock_gnina_multiseed.py \
    --smiles-csv data/full_pool_input.csv \
    --site F \
    --out-dir data/full_pool_gnina_F_multiseed \
    --seeds 10 \
    --exhaustiveness 8

# ~5 sec/compound × 570 compounds × 10 seeds = ~7-8 hours on a single GPU
# To parallelize across 2 GPUs: split the input into 2 halves and run in parallel
```

**Speedup option (2-3 GPUs):** split compound list into chunks, run each chunk on a different GPU. The script supports `--start-idx N --end-idx M` for sharding.

## Success criteria

- File `dock_results_multiseed.csv` exists with **at least 560 rows** (some prep failures expected; we want >98% complete).
- Spearman ρ between `cnn_pose_mean` and our existing single-seed CNN pose ≥ 0.80 (sanity).
- For the 3 CF Labs hits: `cnn_pose_stdev < 0.15` (they're well-behaved).
- For Z795991852_analog_0024 (the suspect Vina-trap): the multi-seed result resolves the ambiguity.

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Owner>  STATUS=done
RESULT: 568/570 compounds successfully scored across 10 seeds; mean stdev=<X>; <N> compounds with stdev>0.2 demoted to Tier-B
DELIVERABLE: data/full_pool_gnina_F_multiseed/dock_results_multiseed.csv
GOTCHAS: <e.g., 2 compounds failed Meeko prep — they were the largest analogs with weird stereochem>
NEXT: pass to Task 10 (consensus aggregation) for re-ranking
```

## If something goes wrong

| Error | Fix |
|---|---|
| GNINA crashes on a specific compound | Skip that compound (log it); continue with the rest |
| GPU runs out of memory | Lower exhaustiveness from 8 to 4 |
| Run takes longer than 8 h on single GPU | Shard with `--start-idx`/`--end-idx` across multiple GPUs in the team |

## Notes

- **Why 10 seeds, not 5 or 20?** Empirically, CNN pose score stabilizes around 8–12 averaged seeds on hard targets. 10 is a round number; std-error of the mean is ~stdev/√10 ≈ 0.05 — small enough that small differences in mean become significant.
- **Why not increase exhaustiveness instead of seeds?** Both help, but cnn_pose stochasticity comes from the diffusion-model inference, which doesn't change with exhaustiveness. Seeds is the right axis.
- **Scaling beyond 10 seeds (stretch):** if compute allows after the baseline pass, run another 10 seeds for the top 100 compounds and average all 20 — gives stdev/√20 ≈ 0.035 precision.

## What this changes for the Tier-A list

Compounds that pass the Tier-A threshold (CNN pose ≥ 0.5) **on average across 10 seeds** are far more credible than ones that passed on a single run. Expected outcome:
- Some "Tier-A by single seed" get demoted (their CNN pose was a fluke)
- Some "Tier-B by single seed" get promoted (their CNN pose was unluckily low)
- The new Tier-A list is the basis for Task 10's consensus.
