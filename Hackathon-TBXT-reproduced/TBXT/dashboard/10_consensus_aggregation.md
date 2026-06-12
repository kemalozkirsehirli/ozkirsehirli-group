# Task 10 — Consensus aggregation + final 4-pick selection

**Owner:** Coordinator + Chemist-1. **Compute:** laptop. **Effort:** ~2 h. **Depends on:** Tasks 2, 3, 4, 5, 6, 8 (all signal-producing tasks).

## What you're solving

After Tasks 2–8, we have **6+ orthogonal signals per compound** scored across 570+ candidates. We need to merge these into a single Tier-A list and select the final 4 picks following the locked-in rule from `TEAM_HANDOFF.md` § 7.

## What you produce

- `data/tier_a/final_tier_a.csv` — top compounds passing all hard requirements + sorted by composite score
- `data/tier_a/FINAL_4_PICKS.md` — narrative justification for the 4 chosen compounds, ready to plug into the slide deck
- A presentation of the picks at the **convergence meeting** (T-12h)

## Hard requirements (all must pass)

1. Compound is a Tier-A passer on multi-seed GNINA (CNN pose ≥ 0.5 averaged across ≥ 8 seeds, CNN pKd ≥ 4.5)
2. QSAR pKd ≥ 4.0
3. Vina best ≤ –6.0 (single-seed) or mean ≤ –6.5 (multi-seed)
4. Tanimoto < 0.85 to all 2 274 known compounds
5. PAINS-clean

## Soft signals (use to break ties + rank)

6. Boltz-2 prob_binder ≥ 0.4 AND ipTM ≥ 0.65
7. MMGBSA ΔG ≤ –10 kcal/mol (after fix)
8. FEP relative ΔΔG within ±2 kcal/mol of best (only if compound was in top 8 for FEP)
9. Selectivity-dock: scores ≥ 1 kcal/mol weaker against ≥ 1 T-box paralog

## Composite score formula

```python
# Each signal normalized to 0-1 then weighted
composite = (
    0.25 * (cnn_pose_mean)                    # robust pose validity
    + 0.20 * normalize(qsar_pkd, 4.0, 5.5)     # target-specific affinity
    + 0.15 * normalize(cnn_pkd_mean, 4.5, 6.5) # off-the-shelf affinity
    + 0.15 * normalize(boltz_prob_binder, 0.3, 0.7)  # generative confidence
    + 0.15 * normalize(-mmgbsa_dg, 10, 25)     # thermodynamic estimate (post-fix)
    + 0.10 * normalize(-fep_dd_g, -2, +2)      # FEP if available, else 0.5
)
```

## Diversity rule (the 4 must collectively)

- **≥ 2 distinct chemotypes** (e.g., quinazolinone-triazole vs pyrimidobicyclic). Murcko-scaffold each pick; require ≥ 2 unique scaffolds.
- **≥ 2 binding sites** (F + A) IF site-A picks survive Tier-A. If no site-A pick reaches Tier-A, this rule lapses.
- **Cover the predicted-Kd range**: at least 1 pick in each of:
  - "best signal" (predicted < 1 µM)
  - "moderate" (predicted 1–10 µM)
  - "insurance" (predicted > 10 µM but with strongest pose validation)

## Tiebreaker

Prefer compounds whose retrosynthesis decomposes into ≤ 4 of onepot's 7 supported reactions (amide coupling, Suzuki, Buchwald, urea, thiourea, N-alkylation, O-alkylation). Use heuristics or have a chemist eyeball.

## How to run

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate

# Step 1: aggregate all signals into one master CSV
python scripts/team/aggregate_consensus.py \
    --multiseed-csv data/full_pool_gnina_F_multiseed/dock_results_multiseed.csv \
    --site-a-csv data/full_pool_gnina_A/dock_results_gnina.csv \
    --boltz-csv data/boltz/full_pool_summary.csv \
    --mmgbsa-csv data/mmgbsa/top50_results.csv \
    --selectivity-csv data/selectivity/dock_offtarget.csv \
    --fep-csv data/fep/relative_dg_table.csv \
    --qsar-csv data/qsar/predictions_analogs.csv \
    --pool data/full_pool_input.csv \
    --out-csv data/tier_a/final_tier_a.csv

# Output should have ~30-60 hard-requirement passers, ranked by composite score.

# Step 2: human review with the team
$EDITOR data/tier_a/final_tier_a.csv
# Discuss top 10 with chemists, narrow to top 4 + 4 backups.

# Step 3: write the FINAL_4_PICKS.md narrative
$EDITOR data/tier_a/FINAL_4_PICKS.md
# For each pick: SMILES, scaffold name, predicted Kd consensus, binding hypothesis (1-2 sentences),
# selectivity statement, and a sentence about why this one over the others.
```

## Convergence meeting agenda (T-12h, ~2 h)

1. **(15 min) Coordinator presents** the top 10 by composite score from `final_tier_a.csv`.
2. **(30 min) Chemists eyeball each top-10:**
   - Anything weird about the structure (PAINS missed, weird stereo, reactive groups)?
   - Any near-twins to disclosed compounds we missed?
   - Synthesizability concerns?
3. **(15 min) Diversity check.** Top 4 satisfies:
   - ≥ 2 distinct Murcko scaffolds?
   - ≥ 2 binding sites if available?
   - Predicted Kd range spans?
4. **(15 min) Soft-signal disagreements.** Any compound where Boltz says high, MMGBSA says low, FEP says different? → either resolve or skip in favor of a more agreed-on candidate.
5. **(30 min) Pick the 4 + 4 backups.** Write the FINAL_4_PICKS.md.
6. **(15 min) Slide owner takes over** to plug picks into the deck.

## Success criteria

- `final_tier_a.csv` has ≥ 20 hard-requirement passers.
- 4 final picks chosen by team consensus.
- 4 backups identified (in case onepot rejects a pick on the day).
- `FINAL_4_PICKS.md` written and reviewed by chemists.

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Coordinator>  STATUS=done
RESULT: 32 hard-passers; final 4 picks: <id1>, <id2>, <id3>, <id4>; 4 backups identified
DELIVERABLE: data/tier_a/final_tier_a.csv + data/tier_a/FINAL_4_PICKS.md
GOTCHAS: <e.g., one pick had MMGBSA disagreeing with FEP — chose anyway because rationale was strongest>
NEXT: Slides owner takes over for slide-fill (Task 9); on-day playbook (Task 11) verifies onepot membership
```

## If something goes wrong

| Issue | Fix |
|---|---|
| Fewer than 4 hard-requirement passers | Relax CNN pose ≥ 0.5 → ≥ 0.45 OR widen Tanimoto-to-known < 0.85 → < 0.90 |
| Top 4 are all the same Murcko scaffold | Pick 1 from the dominant scaffold + 3 from next-best chemotypes (relaxes diversity vs ranking) |
| Onepot membership unverified at this stage | List the picks anyway; verify on the day. Have backups for each. |
| Chemist veto on a pick | Move to next-best in composite; document the veto reason in `FINAL_4_PICKS.md` |

## The Final 4 — required content

For each pick, the FINAL_4_PICKS.md entry must include:

```
## Pick N: <compound_id>

**SMILES:** <smiles>
**Scaffold name (informal):** <e.g., methylquinazolinone-triazole-amide>
**Site:** F (or A)
**Predicted Kd consensus:** <X> µM
  - GNINA Kd (multi-seed mean): <X> µM
  - QSAR Kd: <X> µM
  - Boltz-2 Kd: <X> µM
  - MMGBSA ΔG: <X> kcal/mol
  - FEP ΔΔG vs Z795991852: <X> kcal/mol (if applicable)
**Confidence flags:** ✅ all 5 signals agree (or noted disagreement)
**Binding hypothesis (1 paragraph):** [Specific. Cite anchor-residue distances. e.g., "The carboxylate H-bonds to D177 (3.0 Å) and Y88 OH (2.9 Å). The trifluoromethoxy occupies the L42/I172 hydrophobic shelf. Pose stable across X-of-Y receptor conformations."]
**Selectivity:** Predicted ≥ X× weaker against TBR1 / TBX2 / TBX21.
**Tanimoto-to-Naar:** <X> (= novel; closest neighbor: <id>)
**Synthesizability flag:** Reasonable / Some concern (note); how many of onepot's 7 reactions needed: <N>.
```

## Notes

- **The hardest part is not the math, it's the chemistry judgment.** Trust the chemists when their gut says "this scaffold won't work in SPR."
- **Don't optimize for a single signal.** A compound that maxes out cnn_pkd but fails Boltz prob_binder is a partial Vina-trap — at best uncertain.
- **The 4 backups matter.** On the day, if onepot rejects a pick, you swap from the backup list with no debate. Fast.
