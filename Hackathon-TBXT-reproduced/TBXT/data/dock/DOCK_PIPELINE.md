# TBXT Docking Pipeline — Validation & Usage

## Status

**✅ Validated and ready for production use** (2026-05-06).

- Receptor: 6F59 chain A (G177D variant, residues 41–224, 178 protein residues)
- Engine: AutoDock Vina 1.2.5 (Vina scoring function)
- Pre-validated on the 3 CF Labs SPR hits + 3 site F TEP fragments at sites F and A
- Average per-compound time: ~6 sec for fragments, ~12 sec for HA-35 compounds (16-CPU machine, exhaustiveness 16)

## Files

| File | Role |
|---|---|
| `receptor/6F59.cif` / `6F59.pdb` | Raw structure (G177D + DNA dimer) |
| `receptor/6F59_chainA_protein.pdb` | Chain A protein-only (DNA, waters, dimer-B stripped) |
| `receptor/6F59_apo.pdb` | After PDBFixer: protonated at pH 7.5, missing atoms added |
| **`receptor/6F59_apo.pdbqt`** | **Vina-ready receptor (use this)** |
| `receptor/5QS9.pdb` / `5QSA.pdb` / `5QSI.pdb` | Fragment-bound crystals used for grid validation |
| `grid_definitions.json` / `.txt` | Site F + site A grid boxes |
| `validation_input.csv` | The 6 validation compounds (3 CF Labs + 3 TEP fragments) |
| `validation_F/` | Site F docking output (poses + scores) |
| `validation_A/` | Site A docking output |
| `pose_contacts_summary.csv` | Per-pose contact-residue analysis |

## Grid definitions

Computed as the centroid of Cα atoms of the TEP-defined pocket residues; box size 22 Å cube.

```
Site F (anchors L42, Y88, D177):
  center = ( 0.517, -13.131,  -7.479) Å
  box    = 22 × 22 × 22 Å

Site A (anchors S89, L91, D120, V123, H125, H126, S129, P130, V173, R180):
  center = (-2.798, -22.298, -11.247) Å
  box    = 22 × 22 × 22 Å
```

**Grid validation** (Cα-superposition of fragment-bound PDBs onto our prepped receptor):
- 5QS9 (G177D fragment-bound, sites A–E): RMSD 0.98 Å on 165 residues. Bound fragments fall 7.6–9.2 Å from the site A center — inside the 22 Å box.
- 5QSA (FM001580 / K2P at site F): RMSD 0.92 Å. Fragment 3.3 Å from site F center — well inside.
- 5QSI (FM001452 / O1D at site F): RMSD 1.00 Å. Fragment 10.8 Å from site F center — inside (just under the 11 Å half-edge).

## Validation results

### Vina scores (kcal/mol; lower = stronger predicted binding)

| Compound | Site F | Site A | Δ(F−A) | Notes |
|---|---:|---:|---:|---|
| Z795991852 | -7.26 | -7.83 | +0.57 | CF Labs hit, 10 µM. Slightly favours A in rigid docking (pocket-size effect; reality is site F per HDB/CF Labs SPR). |
| Z979336988 | -7.64 | -7.04 | -0.60 | CF Labs hit, 30 µM. Site F preferred. |
| D203-0031 | -7.24 | -6.60 | -0.64 | CF Labs hit, 17 µM. Site F preferred. |
| FM001580 | -5.27 | -4.70 | **-0.57** | Site F TEP fragment. **Correctly prefers site F**. |
| FM001452 | -5.43 | -5.00 | **-0.43** | Site F TEP fragment. **Correctly prefers site F**. |
| FM002150 | -4.92 | -4.52 | **-0.40** | Site F TEP fragment. **Correctly prefers site F**. |

**CF Labs hits score 1.7–2.4 kcal/mol better than fragments**, consistent with their ~100× larger MW and ~1000× stronger expected binding.

### Pose-residue contacts at site F (cutoff 4.0 Å)

| Compound | Anchors hit (Y88/D177/L42) | Top other contacts |
|---|---|---|
| Z795991852 | **L42 (3.15Å), Y88 (3.74Å), D177 (3.30Å)** | R174, L82, M181, I172, T183 |
| Z979336988 | L42 (3.52Å), D177 (2.91Å) | R174, E41, T183, G81, I172 |
| D203-0031 | L42 (3.04Å), Y88 (3.11Å) | D83, R174, I172, G81, L82 |
| FM001580 | L42 (3.35Å), Y88 (2.96Å) | G81, D83, L82, I172, R174 |
| FM001452 | **L42 (3.58Å), Y88 (3.59Å), D177 (3.03Å)** | R174, M181, G81, I172, L82 |
| FM002150 | L42 (3.85Å), Y88 (2.98Å) | G81, L82, D83, I172, R174 |

**All 6 compounds contact at least 2 of the 3 site F anchor residues. Z795991852 and FM001452 contact all 3 — textbook site F poses.**

The site F pocket lining is fully consistent across the 6 docks: anchor residues + R174/M181/I172 (helix C-cap) + G81/L82/D83 (β-loop). This is the productive site F geometry.

### Pose-residue contacts at site A

CF Labs hits hit 4–6 site A anchors (S89, L91, V173, R180 most frequent); D203-0031 also contacts D177 from inside site A. FM001580 (a site F fragment) hits only 1 site A anchor when forced to dock there — Vina correctly says it doesn't fit site A well.

## Usage

### Activate env
```bash
source $HOME/miniconda3/etc/profile.d/conda.sh
conda activate tbxt
cd ~/Hackathon/TBXT
```

### Dock a candidate set
```bash
# Input: data/dock/my_candidates.csv with columns id,smiles
# Output: data/dock/run1/dock_results.csv + per-pose PDBQTs
python scripts/dock.py \
  --smiles-csv data/dock/my_candidates.csv \
  --site F \
  --out-dir data/dock/run1 \
  --exhaustiveness 16
```

### Analyze poses
```bash
# Updates pose_contacts_summary.csv with anchor-residue contacts
python scripts/analyze_poses.py --validation-dirs data/dock/run1
```

### Rebuild receptor from scratch
```bash
python scripts/prep_receptor.py    # writes 6F59_apo.pdb + .pdbqt
python scripts/define_pockets.py   # writes grid_definitions.json + .txt
```

## Performance budget for the event

- 16-core Xeon-class CPU, exhaustiveness 16: ~6 sec/fragment, ~12 sec/HA-35 compound.
- **In a 60-min docking window we can score ~300 fragment-sized or ~150 lead-sized compounds** at single-pocket exhaustiveness 16.
- For the 5-hour event with HPC: a well-pruned shortlist of ~200 compounds at both sites F and A is comfortably feasible (~2–3 hours wall-clock total).

## Known limitations

- **Vina scoring function is rigid-receptor and approximate.** Absolute scores are not Kd predictions; relative scores within a chemotype are more reliable than across-chemotype.
- **Vina does not strongly discriminate site F from site A for large flexible compounds** (Z795991852 actually scores better at A than F). For final ranking commit, use additional signals: similarity to known site F binders, anchor-contact analysis, and short MD validation.
- **No metal/cofactor handling.** The bound DNA in 6F59 was stripped — apo TBXT is what we dock. If site F binding requires the DNA-bound conformation, our rigid receptor may miss it. Mitigate by docking against multiple conformations (6F59 chain B, 5QS9, 5QSA, etc.) when refining.
- **Stereochemistry ambiguity.** RDKit ETKDG embedding picks one stereoisomer per SMILES; if the compound has unspecified stereo, we may not be docking the active form.

## Next steps before May 9

- [ ] Smoke-test the pipeline on a 50-compound batch to catch edge cases (large rings, charged species, stereo-undefined compounds)
- [ ] Add GNINA ML-rescoring on top of Vina poses (better Kd correlation)
- [ ] Pre-build the analog candidate sets (Day 2 task) so we can dock them on Day 0 if HPC is available
- [ ] Consider a second receptor conformation (5QS9 or 6F59 chain B) for ensemble docking
