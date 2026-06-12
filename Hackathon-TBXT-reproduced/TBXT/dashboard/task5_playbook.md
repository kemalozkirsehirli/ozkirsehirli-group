# Task 5 Playbook — TBXT-specific QSAR retrain on full pool

**Owner:** M4. **Compute:** 8-core CPU (no GPU needed). **Wall-clock:** 15 min base.

## Scientific goal

The reference QSAR is generic-affinity (DEKOIS), Spearman ρ ≈ 0.49 against TBXT CF Labs Kd. A TBXT-specific Random Forest trained on CF Labs reference compounds + their analogs should boost ρ to 0.6+ and produces an independent affinity rank for the full 570 pool.

**Your contribution to winning:** the only *learned-on-TBXT* signal in the consensus. Without it, all 4 other signals are off-target proxies. This is what closes the train-test gap.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task5.sh
```

The script: load CF Labs binders + non-binders, fit RF on Morgan2-2048 + RDKit descriptors, 5-fold CV, predict for all 570. ~15 min.

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | `metrics.cv.spearman_rho ≥ 0.45` (worse than that = model failed) |
| **TARGET** | MIN AND `metrics.processed.n_ok = 570` AND held-out CF Labs hits rank in top 30% |
| **STRETCH** | TARGET AND XGBoost/LightGBM ablation matches/beats RF |

## Hard upload deadline

T-1d 11 pm.

## Stretch ladder

| Rank | Action | Trial | Cost |
|---:|---|---|---|
| 1 | XGBoost ablation with same features | `--trial 2` | ~10 min |
| 2 | Augmented training set: include 200 ChEMBL TBXT-related (transcription-factor inhibitors) | `--trial 3` | ~30 min |
| 3 | Add MOE 2D physchem descriptors | `--trial 4` | ~25 min |
| 4 | Stacked ensemble (RF + XGBoost + LightGBM) | `--trial 5` | ~25 min |
| 5 | Distill-from-Boltz: train RF on full Boltz-2 prob_binder labels (only after task4 done) | `--trial 6` | ~15 min |

## What to do if blocked > 1 h

| Symptom | Fix |
|---|---|
| `sklearn` import errors | `conda env should be tbxt-hit; sanity-check with python -c "import sklearn"` |
| ρ < 0.4 (model failed) | Drop generative compounds from train (they're synthetic-novel — distribution shift); re-fit on CF Labs only |
| Out of memory on Morgan fingerprints | Drop fp_radius from 2 to 1 (Morgan1-1024) |

## What you produce

`report/task5_trial<T>.json` with per-compound `qsar_pkd` for all 570 pool members. Lead consumes this in task10 consensus.
