# Task 3 Playbook — Site-A GNINA pool dock

**Owner:** M2 (secondary). **Compute:** A100 OR 28-core CPU. **Wall-clock:** 50 min – 1.5 h base.

## Scientific goal

All 40 current Tier-A picks are at site F. **Without site A picks we have a single-site bet.** Site A is the second TEP-recommended pocket (dimerization interface). 5–20 site-A picks would diversify the 4-final composition (rule: ≥ 2 sites if available).

**Your contribution to winning:** hedge against site-F-specific failure. If onepot-survivors at site F end up < 4, site-A picks fill the gap.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task3.sh
```

Single-seed GNINA at site A, exhaustiveness 8, all 570 compounds. ~50 min on A100, ~1.5 h on CPU.

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | `metrics.processed.n_ok ≥ 540` |
| **TARGET** | MIN AND `metrics.summary_stats.n_tier_a_at_A ≥ 5` |
| **STRETCH** | TARGET AND multi-seed averaging on top 100 by trial-1 |

## Hard upload deadline

T-1d 11 pm.

## Stretch ladder

| Rank | Action | Trial | Cost |
|---:|---|---|---|
| 1 | Multi-seed averaging on top 100 (10 seeds) | `--trial 2` | ~2 h |
| 2 | Exhaustiveness 16 on top 50 | `--trial 3` | ~1 h |
| 3 | Site-A dock on multi-receptor ensemble (top 20) | `--trial 4` | ~30 min |

## What to do if blocked > 1 h

| Symptom | Fix |
|---|---|
| Same compound failures as task2 | Already skipped in task2; rerun with `--restart` |
| Grid mis-defined | Site A grid is at (-2.80, -22.30, -11.25); verify in `data/dock/grid_definitions.json` |

## What you produce

`report/task3_trial<T>.json` with full ranked list of 570 at site A.
