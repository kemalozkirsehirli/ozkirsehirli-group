# Task 4 Playbook — Boltz-2 co-fold on full 570 pool

**Owner:** M3. **Compute:** A100 (40+ GB VRAM strongly preferred). **Wall-clock:** ~10 GPU-h base.

## Scientific goal

Boltz-2 is the **strongest independent affinity signal** we have (within 6-8× of CF Labs Kd vs GNINA's 7-25×). Critically, `prob_binder` cleanly classifies binders (0.49–0.56) vs fragments (0.19–0.32) — a 4th orthogonal signal that the consensus aggregator weights.

**Your contribution to winning:** Boltz's prob_binder is the cleanest binder/non-binder filter we have. Without it, the top-500 consensus weights only docking-style scores.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task4.sh
```

The script: 570 compounds × 3 diffusion samples × ~1 min per compound on A100 = ~10 h wall-clock. Self-checkpoints (Boltz writes per-compound output dirs).

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | `metrics.processed.n_ok ≥ 500` (allow 70 fail — exotic stereo, RDKit embed errors) |
| **TARGET** | MIN AND `metrics.summary_stats.n_predicted_binders ≥ 50` AND CF Labs hits all show `affinity_kd_uM < 5` |
| **STRETCH** | TARGET AND 1+ stretch trial complete |

## Hard upload deadline

T-1d 11 pm.

## Stretch ladder

| Rank | Action | Trial | Cost |
|---:|---|---|---|
| 1 | 5 diffusion samples instead of 3 (better ipTM stability) | `--trial 2` | ~17 h — only if you have 2 days |
| 2 | Boltz on top 100 from task2 multi-seed at higher recycling steps (3 → 6) | `--trial 3` | ~3 h |
| 3 | Boltz against site-A subset of receptor (alternative pose hypothesis) | `--trial 4` | ~10 h |

## What to do if blocked > 1 h

| Symptom | Fix |
|---|---|
| `cuequivariance` import fails | `pip install cuequivariance-torch cuequivariance-ops-torch-cu12 cuequivariance` |
| `libnvrtc-builtins.so.13.0 missing` | `pip install nvidia-cuda-nvrtc-cu13`; ensure `LD_LIBRARY_PATH` includes nvidia/cu13/lib |
| `Failed to find C compiler` | `export CC=$CONDA_PREFIX/bin/gcc; export CXX=$CONDA_PREFIX/bin/g++` |
| `torchvision: partially initialized module` | `pip install --force-reinstall torchvision` (matching torch version); restart |
| First compound takes 30 min | Boltz weights download (~10 GB) on first run; subsequent compounds ~1 min |

> If GPU compatibility kills Boltz on M3's hardware: **fall back to using existing reference-set Boltz numbers from `data/boltz/boltz_summary.csv`** (6 compounds, validated) and report PARTIAL.

## What you produce

`report/task4_trial<T>.json` with full per-compound Boltz scores: pLDDT, ipTM, affinity_kd_uM, prob_binder.
