# Task 9 Playbook — Vina ensemble dock (multi-receptor)

**Owner:** M1 (lead). **Compute:** 28-core CPU. **Wall-clock:** ~3 h.

## Scientific goal

Single-receptor Vina misses entropy-driven pocket plasticity. Docking the 570 pool against 3 conformations (apo + holo + AlphaFold2) and taking min-ΔG smooths receptor-side noise — adds a 6th orthogonal score to consensus.

**Your contribution to winning:** ensures Tier-A picks are robust to receptor conformation, not just one snapshot. Judges will ask "did you account for protein flexibility?" — this is the answer.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task9.sh
```

The script: 570 × 3 conformations × Vina exhaustiveness 8. Reports `vina_min` (best across receptors) and `vina_mean`.

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | `metrics.processed.n_ok ≥ 540` for primary receptor |
| **TARGET** | MIN AND all 3 receptors complete with `n_ok ≥ 540` each |
| **STRETCH** | TARGET AND ensemble adds ≥ 5 new compounds to Tier-A list |

## Hard upload deadline

T-1d 11 pm.

## Stretch ladder

| Rank | Action | Trial | Cost |
|---:|---|---|---|
| 1 | Add 2 more conformations (5 total: apo, holo, AF2, MD-frame-1, MD-frame-2) | `--trial 2` | ~2 h |
| 2 | GNINA-CNN on ensemble for top 100 | `--trial 3` | ~3 h |
| 3 | Boltz-2 with each receptor conformation as alt template (top 30) | `--trial 4` | ~5 h |

## What to do if blocked > 1 h

| Symptom | Fix |
|---|---|
| AF2 receptor missing | Skip; report only with apo+holo (still better than single) |
| Specific compounds fail across all receptors | Skip — their `prep_failed` flag is set |

## What you produce

`report/task9_trial<T>.json` with `vina_min`, `vina_mean`, `vina_stdev` per compound.
