# Task 8 Playbook — Free-energy refinement (MMGBSA + alchemical)

**Owner:** M6. **Compute:** A100 (alchemical) OR 28-core CPU (MMGBSA). **Wall-clock:** 1–2 days.

## Scientific goal

Vina/GNINA scores correlate roughly (Spearman ~0.5) with experimental Kd. MMGBSA on a short MD trajectory tightens this for the top 20 candidates by re-scoring with explicit-solvent energetics. Alchemical FEP for top 4 final picks gives ΔΔG accuracy within 1 kcal/mol.

**Your contribution to winning:** the slide that explains why we're confident in 4 specific picks — judges value rigorous FE refinement over pure docking. This is also our experimental-tier-credibility argument.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task8.sh
```

The script:
- Top 20 by task10 consensus (after task10 has run trial1)
- Run 5 ns OpenMM equilibration + MMGBSA on each
- Top 4 final picks → alchemical FEP relative to lead anchor (gen_0004 baseline)
- ~1 day wall-clock for top 20; +1 day for FEP

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | `metrics.processed.n_ok ≥ 15` (some MMGBSA may fail on big macrocycles) |
| **TARGET** | MIN AND `metrics.summary.fep_completed ≥ 3` (top 3 of 4 final picks have FEP ΔΔG) |
| **STRETCH** | TARGET AND second 5-ns replicate confirms ranking |

## Hard upload deadline

T-1d 11 pm — partial OK. T-12h: at least top 4 picks must have MMGBSA ΔG.

## Stretch ladder

| Rank | Action | Trial | Cost |
|---:|---|---|---|
| 1 | Replicate MMGBSA on top 20 (different MD seed) | `--trial 2` | +1 day |
| 2 | Extend MD to 20 ns for top 4 | `--trial 3` | +1 day |
| 3 | TI alchemical FEP (3 windows) for top 4 | `--trial 4` | +18 h |
| 4 | Rerun OpenMM with explicit Mg²⁺ at DNA backbone (TBXT specific) | `--trial 5` | +1 day |

## What to do if blocked > 1 h

| Symptom | Fix |
|---|---|
| OpenMM CUDA mismatch | Force CPU platform in script: `OPENMM_PLATFORM=CPU bash ...` (slower but works) |
| MMGBSA segfaults on charged ligands | Re-parameterize with GAFF2 instead of GAFF; rerun |
| alchemical FEP not converged | Reduce decoupling steps to 50 (default 100); re-run; flag in report |

## What you produce

`report/task8_trial<T>.json` with `mmgbsa_dg` for top 20 and `fep_ddg` for top 4.

> **Lead must run task10 trial 1 BEFORE you start.** Otherwise you don't know the top-20 list. Coordinate explicitly.
