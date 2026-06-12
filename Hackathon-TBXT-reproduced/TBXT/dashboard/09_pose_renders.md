# Task 9 — Pose renders + slide deck

**Owner:** Slides (1 person, can be the presenter). **Compute:** laptop with PyMOL. **Effort:** ~6 h. **Depends on:** Task 0 + (preview availability of Task 10's top 4).

## What you're solving

The judging prize is **scored on rationale + presentation quality**, not just SMILES. Even a Tier-1-locked submission can lose if the demo is rough. This task builds publication-quality:

1. **PyMOL renders** of each top pick in site F, with anchor residues highlighted (Y88, D177, R174, M181, T183 in stick form; ligand in colored sticks; H-bonds dashed).
2. **2D structure images** of each pick (RDKit).
3. **Filled slide deck** from `data/slides/SLIDES.md` template.
4. **Demo dry-run** at T-12h.

## What you produce

- `data/slides/renders/pick_<N>_pose_3d.png` — PyMOL 3D render per pick (8 if including the top 4 + 4 backups)
- `data/slides/renders/pick_<N>_2d.png` — RDKit 2D structure per pick
- `data/slides/renders/site_F_overview.png` — broad view of pocket with all 4 picks overlaid
- `data/slides/SLIDES_FILLED.md` — slide deck with all `<PLACEHOLDER>` markers replaced
- `data/slides/SLIDES.pptx` (or `.pdf`) — exportable for the demo

## How to run

```bash
cd ~/tbxt
source ~/miniconda3/envs/tbxt/bin/activate
conda install -y -c conda-forge pymol-open-source biotite

# Step 1: generate PyMOL renders for top 4 (and 4 backups)
python scripts/team/render_poses.py \
    --top-4 data/tier_a/tier_a_candidates.csv \
    --pose-dir data/full_pool_gnina_F/poses \
    --receptor data/dock/receptor/6F59_apo.pdb \
    --out-dir data/slides/renders \
    --highlight-residues Y88,D177,L42,R174,M181,T183

# Step 2: 2D structures via RDKit
python scripts/team/render_2d.py \
    --top-4 data/tier_a/tier_a_candidates.csv \
    --out-dir data/slides/renders

# Step 3: fill slide template (manual; opens SLIDES.md, replaces placeholders)
cp data/slides/SLIDES.md data/slides/SLIDES_FILLED.md
$EDITOR data/slides/SLIDES_FILLED.md
# - Insert top-4 numbers from data/tier_a/tier_a_candidates.csv
# - Insert image paths from data/slides/renders/
# - Write 1-2 sentence binding hypothesis per pick
# - Reference selectivity-dock numbers from data/selectivity/dock_offtarget.csv

# Step 4: convert to PPTX or PDF for the demo
pandoc data/slides/SLIDES_FILLED.md -o data/slides/SLIDES.pptx
# or
pandoc data/slides/SLIDES_FILLED.md -o data/slides/SLIDES.pdf
```

## Demo dry-run protocol (T-12h)

1. Open `SLIDES.pptx` in actual presentation tool (Keynote / PowerPoint / Google Slides).
2. Time the run: target **4 minutes** (judges typically want 3–5 min).
3. Identify weak slides: any slide where you can't articulate "why this matters" in 30 seconds.
4. **Have a chemist present at the dry-run** to flag any rationale that doesn't survive a tough question.
5. Iterate 2–3 times until smooth.

## Success criteria

- All 4 picks have professional 3D + 2D renders.
- Slide deck has zero `<PLACEHOLDER>` text remaining.
- Dry-run completes in 4–5 min.
- Each pick has a 1-paragraph binding hypothesis grounded in actual contact-residue numbers (from `pose_contacts_summary.csv`).
- Selectivity slide has actual numbers (TBR1 -X kcal/mol, TBX2 -Y kcal/mol, TBXT -Z kcal/mol).

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Owner>  STATUS=done
RESULT: 8 picks rendered; SLIDES_FILLED.md complete; PPTX exported; dry-run = 4:32
DELIVERABLE: data/slides/SLIDES.pptx + data/slides/renders/
GOTCHAS: <e.g., one pick's 3D render had unclear contacts; redrew with specific cutoff>
NEXT: hand to presenter for final practice; lock at T-1h on event day
```

## PyMOL render command snippet (for the script)

```python
# scripts/team/render_poses.py — key PyMOL command sequence
def render_pose(receptor_pdb, ligand_pdbqt, output_png, highlight_residues=("Y88", "D177", "L42")):
    """Generate a publication-quality PyMOL render of the pose with anchor residues highlighted."""
    import subprocess, tempfile
    pml = f"""
    load {receptor_pdb}, receptor
    load {ligand_pdbqt}, ligand
    bg_color white
    hide everything
    show cartoon, receptor and chain A
    color grey80, receptor and chain A

    # Highlight anchor residues
    show sticks, receptor and (resi 88+177+42+174+181+183)
    color cyan, receptor and (resi 88+177+42+174+181+183) and name C*
    color blue, receptor and resi 174 and name N*  # arg
    color red, receptor and resi 177 and name O*  # asp/var

    # Show ligand
    show sticks, ligand
    color magenta, ligand and name C*

    # H-bonds
    distance hbonds, ligand, receptor and (resi 88+177) and name N+O*, 3.5
    hide labels, hbonds

    # Camera
    zoom ligand, 8
    orient ligand
    ray 2400, 1800
    png {output_png}, dpi=300
    """
    with tempfile.NamedTemporaryFile(suffix=".pml", delete=False, mode="w") as f:
        f.write(pml); pml_path = f.name
    subprocess.run(["pymol", "-cq", pml_path], check=True, timeout=120)
```

## If something goes wrong

| Issue | Fix |
|---|---|
| PyMOL render shows hydrogens explicitly (cluttered) | Add `hide everything, hydro` before `show sticks` |
| Camera angle is bad | Add `set_view (...)` from a manually-positioned PyMOL session |
| H-bond distances wrong | Tweak `set h_bond_max_distance, 3.5` |
| Ligand colors clash with anchor residues | Change ligand to green via `color green, ligand and name C*` |
| Rendering takes > 30s per pose | Lower ray resolution: `ray 1200, 900` |

## Notes

- **Your slide is the team's mouth.** Even a B+ submission with an A+ slide deck wins over an A submission with a B- deck.
- **Don't over-design.** Judges have seen 50 decks. Clear typography, one idea per slide, real numbers.
- **The selectivity slide is the highest-leverage one** — that's where TBXT-specific reasoning lives, and it's the one piece of ammunition the field has been begging for.
