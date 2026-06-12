# Task 6 — Selectivity-dock vs T-box paralogs

**Owner:** CPU-1 (or any GPU). **Compute:** A100 OR 28-core CPU. **Effort:** ~3 h. **Depends on:** Task 0.

## What you're solving

Our selectivity narrative (`data/selectivity/SELECTIVITY_RATIONALE.md`) is currently sequence-based only — we showed that G177/M181/T183 are TBXT-unique across the 16-member T-box family, so site F is *intrinsically* selective. But judges will ask: **"have you docked your top picks against off-target paralogs to confirm weaker binding?"**

This task converts the sequence-level argument into a docking-level argument: dock our top 20 Tier-A picks against TBR1 (Q16650), TBX2 (Q13207), and TBX21 (Q9UL17) — the three most therapeutically relevant T-box paralogs. Confirm scores are ≥ 1 kcal/mol weaker than vs TBXT.

## What you produce

`data/selectivity/dock_offtarget.csv` with columns:
- `id, smiles`
- `tbxt_vina, tbxt_cnn_pose, tbxt_cnn_pkd` (from existing site-F pool dock)
- `tbr1_vina, tbr1_cnn_pose, tbr1_cnn_pkd`
- `tbx2_vina, tbx2_cnn_pose, tbx2_cnn_pkd`
- `tbx21_vina, tbx21_cnn_pose, tbx21_cnn_pkd`
- `selectivity_kcal_min` (= min vina across paralogs minus tbxt_vina; positive = TBXT-selective)

## Steps

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate

# Step 1: pull paralog crystal structures
mkdir -p data/selectivity/receptors
cd data/selectivity/receptors

# TBR1 — PDB 6JG2 (with DNA, a la 6F59)
curl -L https://files.rcsb.org/download/6JG2.pdb -o 6JG2.pdb
# TBX2 — PDB 5HKR
curl -L https://files.rcsb.org/download/5HKR.pdb -o 5HKR.pdb
# TBX21 (T-bet) — PDB 1H6F (mouse, but DBD is highly conserved)
curl -L https://files.rcsb.org/download/1H6F.pdb -o 1H6F.pdb

cd ~/tbxt

# Step 2: prep each as PDBQT (re-uses the existing prep_receptor logic, parameterized per file)
python scripts/team/prep_paralog_receptors.py \
    --pdbs data/selectivity/receptors/6JG2.pdb,data/selectivity/receptors/5HKR.pdb,data/selectivity/receptors/1H6F.pdb \
    --out-dir data/selectivity/receptors/prepped

# Each receptor's site-F-equivalent pocket grid is computed by superimposing its DBD on TBXT's
# and projecting our site-F grid center.

# Step 3: dock top 20 Tier-A picks against each paralog
head -21 data/tier_a/tier_a_candidates.csv > /tmp/top20_input.csv
python scripts/team/dock_selectivity.py \
    --smiles-csv /tmp/top20_input.csv \
    --paralog-receptor-dir data/selectivity/receptors/prepped \
    --tbxt-receptor data/dock/receptor/6F59_apo.pdbqt \
    --out-csv data/selectivity/dock_offtarget.csv
```

## Success criteria

- All 20 top picks docked against all 3 paralogs (60 docks total).
- For each pick: `tbxt_vina < paralog_vina` (more negative = stronger binding to TBXT).
- Mean selectivity gap across our top 4 final picks: ≥ 1.0 kcal/mol (= ~5× weaker on paralogs in Vina-units).
- We have a defensible per-pick selectivity number for the slide deck.

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Owner>  STATUS=done
RESULT: 20 picks × 3 paralogs docked; <N> picks selectivity gap ≥ 1 kcal/mol; mean gap = <X>
DELIVERABLE: data/selectivity/dock_offtarget.csv
GOTCHAS: <e.g., TBX21 PDB has incomplete DBD; substituted with AlphaFold>
NEXT: feed to Task 9 (slide rationale) and Task 10 (consensus)
```

## If something goes wrong

| Error | Fix |
|---|---|
| Paralog PDB has multi-chain confusing structure | Use PyMOL to extract a clean monomer; save as `.pdb` |
| Pocket grid center doesn't superimpose well | Use the paralog's own residue-equivalent positions (per `data/selectivity/site_F_residue_matrix.csv`) and compute centroid directly |
| One paralog has very different fold | Skip it; use the other two |

## Notes

- **Why these 3 paralogs?** TBR1 (most therapeutically annoying off-target — neuronal differentiation), TBX2 (cancer driver, structurally most similar at site F at 6/10 identity), TBX21 (T-bet, immune-cell fate, drug already exists).
- TBX19 is the highest-risk off-target by sequence (8/10 identity at site F) but its PDB structures are scarce; if you can find an AlphaFold model, dock against that too.
- **A small selectivity gap is fine** — if Vina says TBXT is –7.5 and TBR1 is –6.3, that's still a 1.2 kcal/mol gap = ~7× preference, which is good.
