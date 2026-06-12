# Task 6 Playbook — Selectivity scan vs T-box paralogs

**Owner:** M4 (secondary). **Compute:** 28-core CPU (no GPU needed). **Wall-clock:** ~1.5 h base.

## Scientific goal

A potent TBXT binder that also binds T-box paralogs (TBX5, TBX21) is a development liability — chordoma is the only non-essential T-box use case. Selectivity scoring filters out promiscuous binders before submission.

**Your contribution to winning:** if 4 picks include a TBX5-promiscuous compound, judges will flag it as bad design. Selectivity is a tiebreaker for top picks.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task6.sh
```

The script: re-dock 570 against TBX5 (PDB 2X6V) and TBX21 (PDB 1H6F) Vina, compute ΔΔG = ΔG_TBXT − ΔG_paralog. ~1.5 h on 28 cores.

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | `metrics.processed.n_ok ≥ 540` for both paralogs |
| **TARGET** | MIN AND ≥ 30 compounds show `selectivity_TBX5 ≤ −1.0` (1 kcal/mol selective for TBXT) |
| **STRETCH** | TARGET AND TBX2 (1MUG) added |

## Hard upload deadline

T-1d 11 pm.

## Stretch ladder

| Rank | Action | Trial | Cost |
|---:|---|---|---|
| 1 | Add TBX2 (1MUG) | `--trial 2` | ~45 min |
| 2 | GNINA-CNN against paralogs (top 100 only) for richer selectivity | `--trial 3` | ~2 h |
| 3 | Boltz against TBX5 for top 50 | `--trial 4` | ~3 h |

## What to do if blocked > 1 h

| Symptom | Fix |
|---|---|
| Vina segfaults on TBX5 | Re-prepare receptor with `prepare_receptor4.py -A hydrogens`; verify grid box centered on Y76/D165/L33 (TBX5 site F homolog) |
| Grid coords off | Use `data/dock/paralog_grids.json` precomputed coords |

## What you produce

`report/task6_trial<T>.json` with `selectivity_TBX5`, `selectivity_TBX21` per compound. Lead consumes for tiebreaker.
