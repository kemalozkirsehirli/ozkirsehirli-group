# Task 5 — Fix MMGBSA energy decomposition + run on top 50

**Owner:** GPU-3 (chemistry-Python literate). **Compute:** A100 + 28-core CPU. **Effort:** ~4 h wall-clock (1-2 h fix + 2 h run). **Depends on:** Task 0.

## What you're solving

The current `scripts/run_mmgbsa.py` has a bug: it tries to compute `E_protein` and `E_ligand` by zeroing nonbonded terms on the "ghost" atoms while keeping bonded terms intact. Because intramolecular bond/angle/torsion energies of the ghosts get included, the resulting ΔE_bind comes out at –7500 kcal/mol — physically absurd. **See `data/mmgbsa/MMGBSA_STATUS.md` for the full diagnosis.**

The proper fix: build **three separate OpenMM systems** (complex / apo-protein / ligand-only) and compute energies on each. The ΔE_bind is then `E_complex − E_protein_alone − E_ligand_alone` with each computed against its own physically-valid system.

## What you produce

1. A fixed `scripts/team/run_mmgbsa_fixed.py` that produces physically-meaningful ΔG_bind estimates.
2. `data/mmgbsa/top50_results.csv` — MMGBSA ΔG for the top 50 picks from current Tier-A.
3. Updated MMGBSA validation note showing reference-set Spearman ρ vs CF Labs Kd.

## Algorithm to implement

```python
# Pseudo-code outline
def mmgbsa_one(rdkit_mol, receptor_pdb_path, gnina_pose_pdb):
    # 1. Build COMPLEX system: protein + ligand + GBn2
    system_complex, top_complex, pos_complex = build_complex(rdkit_mol, receptor_pdb_path, gnina_pose_pdb)

    # 2. Build APO system: protein only + GBn2
    system_apo, top_apo, pos_apo = build_apo(receptor_pdb_path)

    # 3. Build LIGAND-ONLY system: ligand alone + GBn2
    system_lig, top_lig, pos_lig = build_ligand_only(rdkit_mol)

    # 4. Minimize each (independently, to its own optimum)
    pos_complex_min, e_complex = minimize(system_complex, top_complex, pos_complex, n_steps=200)
    pos_apo_min, e_apo = minimize(system_apo, top_apo, pos_apo, n_steps=200)
    pos_lig_min, e_lig = minimize(system_lig, top_lig, pos_lig, n_steps=200)

    # 5. Compute ΔG_bind in 2 flavors:
    delta_g_minimized = e_complex - e_apo - e_lig
    # (For "single-snapshot MMGBSA" without conformational sampling)

    # OPTIONAL: a 1 ns MD run on the complex, then average ΔE over snapshots
    # — much more accurate but ~10 min per compound; only do for top picks if budget allows

    return {"delta_g_bind_kcal": delta_g_minimized, "e_complex": e_complex,
            "e_apo": e_apo, "e_lig": e_lig}
```

Key implementation detail: when building the apo system, **don't include the ligand atoms at all** in the topology — just the protein residues. Same for ligand-only — don't include any protein. That way, bonded internal energies are computed only over real atoms, with no leftover ghost contributions.

## How to run

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate

# Step 1: implement the fix
$EDITOR scripts/team/run_mmgbsa_fixed.py
# Use scripts/run_mmgbsa.py as a starting point; replace mmgbsa_one() with the 3-system approach

# Step 2: validate on the reference set first
python scripts/team/run_mmgbsa_fixed.py \
    --smiles-csv data/dock/validation_input.csv \
    --pose-dir data/dock/validation_F_gnina/poses \
    --out-csv data/mmgbsa/reference_set_fixed.csv

# Sanity check: CF Labs hits should give ΔG_bind ≈ –10 to –15 kcal/mol (binders),
# fragments should give ΔG_bind ≈ –4 to –7 kcal/mol (weak binders).
# If you get ΔG ~ 0 or > –50, something is wrong.

# Step 3: get top 50 picks from current Tier-A
head -51 data/tier_a/tier_a_candidates.csv > /tmp/top50_input.csv

# Step 4: run on top 50
python scripts/team/run_mmgbsa_fixed.py \
    --smiles-csv /tmp/top50_input.csv \
    --pose-dir data/full_pool_gnina_F/poses \
    --out-csv data/mmgbsa/top50_results.csv
```

## Success criteria

- Reference-set ΔG_bind values are in the physically-plausible range:
  - CF Labs hits: –10 to –15 kcal/mol
  - TEP fragments: –4 to –8 kcal/mol
- Spearman ρ between MMGBSA ΔG_bind and CF Labs Kd (3 hits) is > 0 (correctly orders strong > weak).
- Top 50 results CSV exists with all columns populated.
- ΔG_bind correlates positively with GNINA CNN pKd on the top 50 (sanity).

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Owner>  STATUS=done
RESULT: MMGBSA fixed; reference-set ΔG_bind range -8 to -14 kcal/mol; ρ vs CF Kd = +X; top 50 scored
DELIVERABLE: scripts/team/run_mmgbsa_fixed.py + data/mmgbsa/top50_results.csv
GOTCHAS: <e.g., 2 compounds with charged groups had problems with GBSA; documented in script>
NEXT: pass to Task 10 (consensus aggregation)
```

## If something goes wrong

| Error | Fix |
|---|---|
| ΔG_bind still ~0 or absurd | The bonded terms are still leaking; verify each system has only its real atoms in the topology |
| `ForceField.createSystem fails for ligand-only` | Use `app.NoCutoff` and a separate FF without protein force field for the ligand-only run |
| Charged ligand fails GBSA | Add `app.HBonds` constraints; use GBn (non-implicit-charged) variant if needed |
| Run too slow | Reduce minimize iterations from 200 → 100; should still converge for sensible starts |

## Stretch (if budget permits)

After the single-snapshot version works, do MD-averaged MMGBSA: 1 ns of Langevin dynamics on the complex, then compute ΔG_bind as the mean over 100 snapshots. This is the gold-standard MMGBSA. ~20 min/compound but much less noisy.

```bash
python scripts/team/run_mmgbsa_fixed.py --md-average --md-ns 1 \
    --smiles-csv /tmp/top50_input.csv --out-csv data/mmgbsa/top50_md_averaged.csv
```

## Notes

- **The fix is ~30–50 lines of code.** Don't overthink it. The hardest part is correctly building three separate systems with their own topologies.
- **MMGBSA is approximate.** Expect 2–4 kcal/mol noise per compound. Use it for ranking, not absolute Kd.
- **Compounds with significant induced-fit needs** (e.g. metal coordination) will mis-rank with MMGBSA. Treat extreme values with skepticism.
