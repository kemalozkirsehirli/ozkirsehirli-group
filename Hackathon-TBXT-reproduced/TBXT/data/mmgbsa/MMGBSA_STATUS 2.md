# MMGBSA Toolchain — Strategy 6 Partial

**Status: scaffolded, NOT validated.** The toolchain (OpenMM + OpenFF + parmed + mdtraj) installs and runs end-to-end on TBXT G177D + ligand systems. Single-snapshot MMGBSA energies are computed, but the energy-decomposition implementation has a known bug (bonded terms of "ghost" atoms not zeroed when computing protein-only or ligand-only energies). The reference-set validation step (Spearman ρ vs CF Labs Kd) was NOT achieved.

## What works

- **Conda toolchain**: `openff-toolkit==0.18.0`, `openmm==8.5.1`, `openmmforcefields`, `parmed==4.3.1`, `mdtraj==1.11.1` all installed and importable.
- **Ligand parameterization** via OpenFF Sage 2.2 (`SMIRNOFFTemplateGenerator(forcefield="openff-2.2.0")`). Z795991852 (HA 37) parameterizes successfully in ~4 min.
- **Receptor protonation** at pH 7.5 via PDBFixer (already done by `prep_receptor.py`).
- **System construction**: AMBER ff14 (protein) + GBn2 implicit solvent + SMIRNOFF (ligand) + GBSA Coulomb cutoff = NoCutoff.
- **Minimization**: 200-step Langevin minimization at 300 K succeeds.
- **Energy evaluation**: full-system potential energy on minimized state succeeds.

## What's broken

The `mmgbsa_one()` energy decomposition tries to compute:
```
E_protein = E_system  with ligand nonbonded set to zero
E_ligand  = E_system  with protein nonbonded set to zero
ΔE_bind   = E_complex - E_protein - E_ligand
```

This yields ΔE ≈ –7500 kcal/mol — physically absurd. The bug: zeroing nonbonded charges + LJ on "ghost" atoms doesn't remove their bonded internal energy (bonds, angles, torsions), so:
- `E_protein` includes the ligand's bonded internal energy (intramolecular bond/angle/torsion potential)
- `E_ligand` includes the protein's bonded internal energy
- Subtracting both from `E_complex` double-counts the *bonded* contributions that are mostly cancelled in ΔΔE

The proper fix is to either:
1. Build three **separate** OpenMM systems (complex / apo / ligand-only) and compute energies on each
2. Zero out **all** force contributions (bonded + nonbonded + GB) for ghost atoms — needs to walk all `Force` objects in the system and rezero ghost-atom parameters per force-type

Both are routine to implement (~1-2 more hours) but blocked progress on closing out the remaining strategies.

## Performance budget (when fixed)

- ~5 min per compound on this 16-core CPU + RTX 5050 (parameterization-dominated for HA-37 ligands; faster for fragments)
- ~30 min for the 6-compound reference set
- ~4-5 hours for the top 50 candidates (top picks from Vina + GNINA + QSAR + Boltz + Selectivity consensus)

For the on-day workflow, this would run as a final-stage filter on ~10-15 picks (1-2 hours) — not a bulk-screen step.

## What we *do* have for free-energy estimation

Without a working MMGBSA, we still have **5 orthogonal binding-relevance signals** that already cover most of the value MMGBSA would add:

| Signal | What it measures | Method |
|---|---|---|
| Vina ensemble | Geometric fit across 6 receptor conformations | Strategy 5 |
| GNINA CNN pose | Native-likeness of the docked geometry | Strategy 4 baseline |
| GNINA CNN pKd | ML affinity prediction trained on PDBbind | Strategy 4 baseline |
| QSAR pKd | TBXT-specific affinity (trained on Naar SPR) | Strategy 1 |
| Boltz-2 affinity + ipTM | Generative co-fold + interface confidence | Strategy 4 |

The combined Tier-A scoring rule (revision 4) uses 4 of these without needing MMGBSA. The on-day decision can defer MMGBSA to post-event refinement on the experimental program (Foundation pipeline).

## Files

```
scripts/run_mmgbsa.py             # scaffolded pipeline; energy decomp bugged
data/mmgbsa/
├── Z795991852_pose.pdb           # docked-pose-converted PDB
├── Z979336988_pose.pdb
├── mmgbsa_summary.csv            # broken numbers; do not use for ranking
└── MMGBSA_STATUS.md              # this file
```

## Recommendation

**Do not use the current MMGBSA results for ranking.** They're physically meaningless until the energy decomposition is fixed. Either:
- Fix the implementation post-event (1-2 hr) and apply MMGBSA as an additional confirmation signal
- Use the existing 5 signals (Vina ensemble / GNINA / QSAR / Boltz / Selectivity) as the final-pick rule on May 9; MMGBSA is a "if time" item on the day
- Or budget HPC time on May 9 to run a properly-implemented MMGBSA on the top 4-pick after lock-down

For on-day use **without** MMGBSA, the 5-signal Tier-A rule gives sufficient orthogonal evidence for confident picks. MMGBSA would have been a 6th signal — useful but not essential.
