# Task 10 Playbook — Consensus aggregator + top-500 ranking + final 4 picks

**Owner:** M1 (lead). **Compute:** 4-core CPU. **Wall-clock:** 5–10 min per run.

## Scientific goal

Gathers all upstream JSONs (task2-9), normalizes scores, computes weighted composite, applies Tier-A filter, ranks ALL compounds top-to-bottom, exports a 100-500 ranked CSV (the on-day Onepot filter buffer), and shortlists final 4 picks honoring the **diversity rule** (≥ 2 sites, ≥ 1 generative, ≥ 1 enumerated, no T-box-promiscuous).

**Your contribution to winning:** this script IS the win. Top 4 SMILES come out of here. Top 500 is the on-day insurance.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task10.sh
```

Re-runnable any time — pulls whatever upstream JSONs exist and produces the best consensus the available signals support. Lead reruns this **after every** upstream task completion.

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | Consumes ≥ 3 of {task2, task4, task5, task9}; produces 4-pick CSV; produces top-500 ranked CSV |
| **TARGET** | MIN AND consumes ≥ 5 signals; final 4 picks span 2+ sites; ≥ 50% of top-500 have non-null `cnn_pose_mean` and `qsar_pkd` |
| **STRETCH** | TARGET AND post-MMGBSA refinement (consume task8 output) replaces top 4 if FEP changes ranks |

## Hard upload deadline

- T-1d 11 pm: trial 1 result (initial top-500 + provisional 4 picks) uploaded to Drive
- T-12h: trial 2 (after late-arriving stretch trials integrated) uploaded
- T-2h on event day: final picks locked

## Stretch ladder

| Rank | Action | Trial | Cost |
|---:|---|---|---|
| 1 | Re-weight composite to favor Boltz over Vina (test alt scoring) | `--trial 2` | 5 min |
| 2 | Add MMGBSA ΔG as 7th signal (gates on task8) | `--trial 3` | 5 min |
| 3 | Outlier removal: drop compounds where any signal is > 3σ from cluster | `--trial 4` | 5 min |
| 4 | Per-cluster top-1 picks: 4-pick rule = best from 4 distinct chemotype clusters | `--trial 5` | 10 min |

## On-day usage of top-500

When organizers reveal Onepot library list in the morning of May 9:

```bash
# Filter top-500 against onepot library
python TBXT/experiment_scripts/onepot_filter.py \
    --top500 data/task10/trial1/top500_consensus_ranked.csv \
    --onepot <onepot_library.csv> \
    --output report/onepot_survivors.csv \
    --topn 4
```

If onepot has Z-tranche only: pick top 4 surviving Z-prefixes.
If onepot is small molecule library: pick top 4 with valid InChIKey match.
If we get < 4 survivors: relax tier-A to include cnn_pose ≥ 0.4 (one tier down).

## Escalation

This is lead-owned. Lead manages all consensus reruns and final-pick selection.

## What you produce

- `report/task10_trial<T>.json` — meta + final 4 picks
- `data/task10/trial<T>/final_picks.csv` — 4 SMILES + IDs + composite scores
- `data/task10/trial<T>/top500_consensus_ranked.csv` — full ranked list (for on-day filter)
