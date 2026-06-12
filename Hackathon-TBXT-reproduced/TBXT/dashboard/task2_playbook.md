# Task 2 Playbook — Multi-seed GNINA on full 570 pool at site F

**Owner:** M2. **Compute:** A100 + 28-core CPU. **Wall-clock:** 6–8 h base trial.

## Scientific goal

CNN pose score has run-to-run variance (±0.2 on borderline compounds). A single GNINA run over-promotes false-positive Vina-traps and under-promotes real binders. Multi-seed averaging (10 seeds) cuts the noise to ±0.05 — the difference between a confident Tier-A pick and a Vina trap.

**Your contribution to winning:** every downstream consensus pick depends on this CNN-pose filter. Without robust multi-seed scores, the top-500 ranking is a coin flip on borderline compounds.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task2.sh
```

The script: 570 compounds × 10 seeds × exhaustiveness 8, ~6-8 h on A100. Self-checkpoints (resume-on-restart works).

## Done criteria

| Level | Criterion (check `report/task2_trial1.json`) |
|---|---|
| **MIN** | `metrics.processed.n_ok ≥ 540` (allows 30 fail) |
| **TARGET** | MIN AND `metrics.summary_stats.n_tier_a ≥ 30` AND CF Labs reference compounds (Z795991852, Z979336988) reproduce `cnn_pose_mean ≥ 0.4` |
| **STRETCH** | TARGET AND at least 1 stretch trial with stricter parameters complete |

## Hard upload deadline

**T-1d 11 pm** — `report/task2_trial1.json` MUST be in Drive even if stretch trials still running.

## Stretch ladder (ranked by impact-per-GPU-hour)

If base run finishes by T-1d 4 pm, work down this list:

| Rank | Action | Trial tag | Cost |
|---:|---|---|---|
| 1 | Exhaustiveness 8 → 16 (more thorough sampling per seed) | `--trial 2` | ~12 h |
| 2 | Add 10 more seeds (20 total) for top-100 by trial-1 ranking | `--trial 3` | ~3 h |
| 3 | Run on multi-receptor ensemble (3 confs from `data/dock/receptor/ensemble/`) | `--trial 4` | ~18 h — only if you have 2 days |
| 4 | Targeted re-dock of compounds with `cnn_pose_stdev > 0.15` at exh 32 | `--trial 5` | ~4 h |
| 5 | Same pool at site B (TEP-secondary site) | `--trial 6` | ~6 h |

For each stretch, **edit `experiment_scripts/task2.sh`** to set the new param, then `bash TBXT/experiment_scripts/task2.sh --trial N --restart`. The base trial JSON stays untouched.

## What to do if blocked > 1 h

| Symptom | Fix |
|---|---|
| GNINA OOM | Lower exhaustiveness from 8 → 4; restart |
| GPU hung / process won't die | `nvidia-smi --gpu-reset` then `kill -9 <pid>`; restart with `--trial 1 --restart` (auto-backs-up partial) |
| Specific compound crashes Meeko (`prep_failed`) | Skip — script logs and moves on; expected for ~1% of compounds |
| Run > 12 h on first trial | Shard input CSV across 2 GPUs: `--start-idx 0 --end-idx 285` and `--start-idx 285 --end-idx 570` |

Anything else > 1 h → 🚨 BLOCKED in chat.

## What to post in chat

```
▶ STARTING: task2 trial1 base run, ETA T+8h
✅ DONE: task2 trial1 (n_ok=565, n_tier_a=38, mean cnn_pose=0.42)
▶ STRETCH: task2 trial2 (exhaustiveness 16) starting
✅ DONE: task2 trial2 (n_ok=560, top picks reshuffled — sent to lead)
```

## What you produce

`report/task2_trial<T>.json` — every trial. Lead pulls these and runs `task10` consensus aggregator.
