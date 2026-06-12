# Task 4 — Boltz-2 co-folding on full 570 pool

**Owner:** GPU-2. **Compute:** A100 (40+ GB VRAM). **Effort:** ~4 h wall-clock, ~10 GPU-hours. **Depends on:** Task 0.

## What you're solving

Boltz-2 is the **strongest independent affinity signal** we have — it predicted CF Labs hit Z795991852 at 1.7 µM (real 10 µM; 6× over) vs GNINA's 1.4 µM (7× over) and Vina alone gives no Kd at all. More importantly, Boltz-2's `prob_binder` cleanly classifies binders (0.49–0.56) vs fragments (0.19–0.32). Running it on the full 570 pool gives us a 4th orthogonal signal for every compound.

## What you produce

`data/boltz/full_pool_summary.csv` with all the same columns as the reference-set summary:
- `cid, smiles, status`
- `pLDDT, pTM, ipTM, ipTM_best, lig_iptm, confidence`
- `affinity_log_kd_uM, affinity_kd_uM, affinity_pkd, affinity_prob_binder`

## How to run

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate
export CC=$CONDA_PREFIX/bin/gcc CXX=$CONDA_PREFIX/bin/g++
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/python3.12/site-packages/nvidia/cu13/lib:$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

# Re-uses scripts/run_boltz.py with the 570-compound pool
python scripts/run_boltz.py \
    --smiles-csv data/full_pool_input.csv \
    --out-dir data/boltz/full_pool_runs

# After completion, the summary is at data/boltz/boltz_summary.csv (script writes there)
# Copy it to a stable name to preserve:
cp data/boltz/boltz_summary.csv data/boltz/full_pool_summary.csv
```

**Speedup option (2 GPUs):** the existing script processes one compound at a time. Shard by editing the input CSV in half, running each half on a separate GPU, then concatenating outputs.

## Success criteria

- ≥ 560 of 570 compounds successfully processed (some may fail RDKit embedding for exotic stereo).
- Mean elapsed time: ~1 min per compound on A100, ~2 min on RTX 5050 — verify your hardware matches.
- For our reference compounds (Z795991852, Z979336988, D203-0031): predictions match the existing `data/boltz/boltz_summary.csv` ± 5% (sanity).
- Top-50 compounds by Boltz `affinity_pkd` significantly overlap (Spearman ρ > 0.5) with top-50 by GNINA `cnn_pkd` — orthogonal but correlated.

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Owner>  STATUS=done
RESULT: 565/570 scored; mean affinity_kd 25 µM; 18 compounds with prob_binder>=0.5 AND ipTM>=0.65; top: <ids>
DELIVERABLE: data/boltz/full_pool_summary.csv
GOTCHAS: <e.g., compound X failed RDKit Embed>
NEXT: pass to Task 10 (consensus aggregation)
```

## If something goes wrong

| Error | Fix |
|---|---|
| `cuequivariance not found` | `pip install cuequivariance-torch cuequivariance-ops-torch-cu12 cuequivariance` |
| `libnvrtc-builtins.so.13.0 missing` | `pip install nvidia-cuda-nvrtc-cu13` and ensure LD_LIBRARY_PATH includes the nvidia/cu13/lib dir |
| `Failed to find C compiler` | `export CC=$CONDA_PREFIX/bin/gcc; export CXX=$CONDA_PREFIX/bin/g++` |
| OOM on a particular compound | Skip it, it's > 50 atoms and may need more VRAM |
| Run takes 2× expected | The first compound triggers checkpoint download (~10 GB); subsequent are fast |

## Notes

- **First run downloads Boltz weights** (~10 GB) into `~/.boltz/`. Pre-download once on the team's first machine, then rsync to others to save bandwidth.
- The 3-diffusion-sample default is fine; running 5 samples per compound (`--diffusion_samples 5`) is more stable but doubles wall-clock.
- A100 is 5× faster than RTX 5050 — expect ~10 min for the 6 reference compounds (vs 12 min on 5050).
