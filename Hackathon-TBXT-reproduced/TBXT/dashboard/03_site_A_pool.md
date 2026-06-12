# Task 3 — Site-A GNINA pool dock (site diversification)

**Owner:** CPU-1 (or any GPU). **Compute:** A100 OR 28-core CPU. **Effort:** ~1 h. **Depends on:** Task 0.

## What you're solving

Currently, **all 40 of our Tier-A picks are at site F.** We have zero site-A picks. This is a single-site bet — if we lose at site F, we lose. Site A is the second TEP-recommended pocket (at the dimerization interface). Adding 5–10 site-A picks gives us a hedge.

## What you produce

`data/full_pool_gnina_A/dock_results_gnina.csv` — same schema as the existing site-F file, scored against site A.

## How to run

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

# Re-uses the existing dock_gnina.py, just with --site A
python scripts/dock_gnina.py \
    --smiles-csv data/full_pool_input.csv \
    --site A \
    --out-dir data/full_pool_gnina_A \
    --exhaustiveness 8

# ~5 sec/compound × 570 = ~50 min on A100. (~3 sec/compound on 28-core CPU = ~30 min.)
```

## Success criteria

- File exists with ≥ 560 rows.
- 3 CF Labs hits all score < –6 kcal/mol (sanity).
- 3 site-F TEP fragments score weaker at site A than site F (we already validated this).
- Some compounds are Tier-A at site A (CNN pose ≥ 0.5 + CNN pKd ≥ 4.5 + Vina ≤ –6.0 + QSAR pKd ≥ 4.0).

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Owner>  STATUS=done
RESULT: 568/570 scored; <N> Tier-A at site A (vs 40 at site F); top picks: <ids>
DELIVERABLE: data/full_pool_gnina_A/dock_results_gnina.csv
GOTCHAS: <anything>
NEXT: pass to Task 10 for combined Tier-A
```

## Notes

- This is the **fastest, simplest task**. Do it first if your task slot is short.
- Site-A picks may have completely different chemotype distribution than site-F picks — that's actually good for diversity.
