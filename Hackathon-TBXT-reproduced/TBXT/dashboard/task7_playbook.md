# Task 7 Playbook — Pharmacophore-guided generative expansion

**Owner:** M5. **Compute:** A100 (REINVENT) OR 8-core CPU (template-fragment). **Wall-clock:** 4–8 h base.

## Scientific goal

We have 67 generative compounds. Goal: expand to 200+ that respect the **task2 top-50 pharmacophore** (Y88-pi-stack + D177-H-bond + L42-hydrophobic), keeping synthesizability ≥ 0.5 (RDKit SAS) and MW ≤ 500.

**Your contribution to winning:** novelty drives 2 of the 4 final picks (gen_0004, gen_0025). Without pharmacophore-guided generation we ship Z-analogs only and concede the novelty narrative.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task7.sh
```

The script: extract 3-feature pharmacophore from top-50 site-F poses → REINVENT scoring with pharmacophore + QSAR + Vina docking surrogate → 200 candidates → RDKit filter (Lipinski, PAINS, SAS) → output ~150 unique novel SMILES. Self-checkpoints every 50 generated.

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | `metrics.processed.n_unique_filtered ≥ 100` |
| **TARGET** | MIN AND ≥ 30 of those have predicted `qsar_pkd ≥ 4.0` AND `vina ≤ −5.5` |
| **STRETCH** | TARGET AND ≥ 10 new picks pass tier-A criteria when re-docked through task2 |

## Hard upload deadline

T-1d 11 pm.

## Stretch ladder

| Rank | Action | Trial | Cost |
|---:|---|---|---|
| 1 | Run new generation through task2 (multi-seed GNINA) | trigger M2 | ~3 h |
| 2 | DiffDock-PP for top 30 generated (alternative pose sampler) | `--trial 2` | ~6 h |
| 3 | Bigger generation budget (1000 → 5000) | `--trial 3` | ~12 h — only if time |
| 4 | Add T-box selectivity to generation reward | `--trial 4` | ~10 h |

## What to do if blocked > 1 h

| Symptom | Fix |
|---|---|
| REINVENT can't find weights | `bash data/scripts/download_reinvent_weights.sh` |
| Pharmacophore extraction fails | Fallback to template-based fragment growing from top 5 site-F poses (script flag `--mode template`) |
| All generated SMILES fail PAINS filter | Loosen REINVENT prior to keep more drug-like; or relax PAINS (we filter again at task10 anyway) |
| < 50 unique generated | Reduce diversity penalty in REINVENT scoring |

## What you produce

`report/task7_trial<T>.json` with new SMILES + ID like `gen_v2_NNNN`. Lead pulls these into the master pool for re-scoring through tasks 2-6.
