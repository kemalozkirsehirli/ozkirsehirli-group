# TBXT Hit Identification Hackathon — [TEAM NAME]

**Pillar VC, Boston · 2026-05-09 · 7:00 pm submission**

> Slide template with `<PLACEHOLDER>` markers. Fill placeholders on the day from `data/tier_a/tier_a_candidates.csv` and the rationale doc. Estimated demo length 4-5 minutes; ~10-12 slides.

---

## Slide 1 — Title

**Team:** [TEAM NAME]
**Members:** [N members]
**Approach in one line:** "[ONE-LINE TAGLINE — e.g., 'TBXT-specific QSAR + multi-conformer co-folding directs site-F-selective scaffold-hopping']"

**4 ranked compounds (preview):**
1. `<PICK_1_ID>` — `<SCAFFOLD_DESCRIPTION_1>` — predicted Kd `<X>` µM
2. `<PICK_2_ID>` — `<SCAFFOLD_DESCRIPTION_2>` — predicted Kd `<X>` µM
3. `<PICK_3_ID>` — `<SCAFFOLD_DESCRIPTION_3>` — predicted Kd `<X>` µM
4. `<PICK_4_ID>` — `<SCAFFOLD_DESCRIPTION_4>` — predicted Kd `<X>` µM

---

## Slide 2 — The Target & Why It's Hard

- **TBXT (Brachyury):** chordoma driver, expressed in >90% of Western chordoma cases via the **G177D rs2305089 SNP** (= our assay protein, PDB 6F59).
- **Transcription factor — historically undruggable.** Site F is a *shallow surface groove*, not a deep pocket. The Chordoma Foundation has been stuck at **10 µM for years** despite multi-million-dollar professional medchem effort.
- **Experimental tier targets:** ≤ 5 µM (3 awards), ≤ 300 nM (2 awards). 2-300× improvement over the state of the art.
- **3.4 billion compounds in onepot's library** — brute-force docking would take 540 years.

---

## Slide 3 — Our Strategy

**Five orthogonal signals + one selectivity argument:**

1. **TBXT-specific QSAR** — trained on the **Naar SPR dataset (650 compounds × measured Kd)** decrypted from Zenodo. Spearman ρ 0.49, MAE 0.5 pKd — significantly more accurate than off-the-shelf docking on TBXT.
2. **Multi-conformer Vina ensemble** — 6 receptor conformations (G177D + DNA, WT, apo, fragment-bound at site F).
3. **GNINA CNN scoring** — pose-validity (0-1) + ML affinity prediction (PDBbind-trained).
4. **Boltz-2 co-folding** — generative protein-ligand prediction with ipTM confidence + binder probability.
5. **Selectivity (T-box family)** — site F is intrinsically TBXT-selective (G177/M181/T183 essentially unique across the 16-member family).

The 4 picks satisfy ALL 5 signals simultaneously (Tier-A) — robust to any single-signal failure mode.

---

## Slide 4 — The Avoid-Duplication Map

We pulled the full Naar SPR dataset (Zenodo 8212611, password "HDB"):
- **2,331 compounds** in the master SMILES list
- **650 with measured Kd** (15 SPR campaigns) — **our QSAR training set**
- **3 CF Labs hits** (Z795991852 10 µM, Z979336988 30 µM, D203-0031 17 µM) — we treat as the validated reference, not a target for resubmission.

**Critical finding:** D203-0031 has a near-twin already disclosed (D203-0030, Tanimoto 0.908) — series exhausted. Our 4 picks are at Tanimoto < 0.85 to all 2,274 unique known compounds.

---

## Slide 5 — Site F is TBXT-selective by design

| Site F residue | Conservation across 15 family members | Role |
|---|---:|---|
| Y88 | 100% (universal) | H-bond anchor |
| **G/D177** | **0% (TBXT-unique)** | Variant residue (chordoma SNP) |
| **R174** | 40% (most family = E) | Salt-bridge anchor |
| **I172, M181, T183** | 47-13% (TBXT-unique character) | Pocket lining |

> "Compounds engaging G/D177 + R174 cannot bind any other T-box family member without major reorganization. Closest off-target TBX19/TPIT differs by only G177S — but that single substitution removes the carboxylate engaging the chordoma-SNP residue our compounds target."

---

## Slide 6 — Our 4-pick Composition

**Diversity rule:** 2 binding sites × 2 chemotypes minimum.

| Pick | Site | Parent / scaffold | Predicted Kd (consensus) | Novelty (T-naar) |
|---|---|---|---|---|
| 1 | F | `<PARENT_1>` | `<X.X>` µM | T = `<X.XX>` |
| 2 | F | `<PARENT_2>` | `<X.X>` µM | T = `<X.XX>` |
| 3 | A | `<PARENT_3>` | `<X.X>` µM | T = `<X.XX>` |
| 4 | F or wildcard | `<PARENT_4>` | `<X.X>` µM | T = `<X.XX>` |

**Why this composition:**
- Site F is the productive site (TEP-recommended; all 3 CF Labs hits bind here)
- Site A as hedge — TEP-recommended dimerization-interface site
- Wildcard for "best orthogonal signal regardless of site"

---

## Slide 7 — Pick #1 Deep Dive

**Compound:** `<SMILES_1>`
**Site:** F (TBXT-selective)
**Predicted Kd:** `<X>` µM (QSAR `<X>`, GNINA `<X>`, Boltz-2 `<X>`)

**Binding hypothesis:**
> [1-2 sentence narrative — e.g., "The carboxylate of the trifluoromethoxybenzoic acid head engages D177 (3.1 Å) and Y88 (3.0 Å) at site F. The morpholine adds a hydrophobic shelf into the L42/I172 pocket. Predicted ~10× tighter than parent fragment FM001580 (148 µM in QSAR)."]

**Confidence:**
- ✅ All 5 signals agree (Tier-A)
- ✅ CNN pose 0.X — matches crystal-style geometry of FM001580
- ✅ Selectivity: contacts G/D177 + Y88 + L42 (3 TBXT-unique anchors)

[INSERT SCAFFOLD IMAGE / DOCKED POSE SCREENSHOT]

---

## Slide 8 — Pick #2 Deep Dive

`<SAME STRUCTURE AS SLIDE 7 FOR PICK 2>`

---

## Slide 9 — Pick #3 Deep Dive (Site A or wildcard)

`<SAME STRUCTURE AS SLIDE 7 FOR PICK 3>`

---

## Slide 10 — Pick #4 Deep Dive

`<SAME STRUCTURE AS SLIDE 7 FOR PICK 4>`

---

## Slide 11 — Methods Summary

**Pre-event tooling (validated against the 3 CF Labs hits):**
- Receptor: PDB 6F59 chain A (G177D + DNA), apo via PDBFixer pH 7.5
- Sites F + A grids defined from TEP pocket residues, validated against fragment-bound 5QSA / 5QSI (Cα RMSD < 1.0 Å)
- Vina 1.2.5 / GNINA 1.3.2 / RDKit 2025.x / OpenFF Sage 2.2 / Boltz-2 v2.2.1
- TBXT QSAR: Random Forest + XGBoost on Morgan FP (r=2, 2048 bits) + 8 RDKit descriptors

**On-day workflow (5 hours):**
- Hour 1: pipeline warm-up, smoke-test on CF Labs hits to confirm pose reproduction
- Hours 2-3: Onepot library lookup → ~570 candidates × site F + A docking
- Hours 4-5: Boltz-2 confirmation + manual chemistry curation → final 4-pick

---

## Slide 12 — What we're proud of + Caveats

**Proud of:**
- TBXT-specific QSAR (no other team likely has this — needs Zenodo password)
- 5-signal Tier-A filter — kills Vina-traps (compounds with high score, wrong geometry)
- Selectivity argument grounded in 16-member T-box family alignment

**Caveats we own:**
- Affinity predictions over-confident by 6-8× at µM regime (consistent with Naar SPR lab-to-lab 3-10× variability)
- We don't have access to the full 3.4B Onepot library; on-day filtering depends on the organizer-provided lookup
- Site A picks rely on shallower pocket — geometric confidence lower than site F

---

## Demo backup — only if asked

- **Why ratchets / why these 4:** Tier-A scoring rule, all 5 signals must agree
- **Why site F over A:** TEP authors recommend; all 3 CF Labs hits bind there; site F has the unique residues for selectivity
- **Why not Z795991852-derived only:** the disclosed-compound rule (T < 0.85 to Naar) limits how close we can stay to the parent; we balanced novelty + binding-signal preservation
- **What about TBX19 off-target:** TBX19 is the only HIGH-risk paralog (8/10 site F identity); our picks engage G/D177 specifically — TBX19's S177 doesn't accept the same anchor

---

## Slide-fill instructions for the team on May 9

1. After lock-down at 6:00 pm, copy `data/tier_a/tier_a_candidates.csv` top 4 rows
2. For each pick, paste:
   - SMILES into pick-deep-dive slide
   - Vina / CNN_pose / CNN_pKd / QSAR / Boltz numbers from `all_signals.csv`
   - Write 1-2 sentence binding hypothesis from anchor-contact analysis (`pose_contacts_summary.csv` for the picks)
   - Generate 2D structure image via `Chem.Draw.MolToFile()` + insert
3. Pre-write the selectivity slide #5 — it's the same regardless of picks
4. Pre-write the avoid-duplication slide #4 — also identical
5. **Practice the demo once at 6:30 pm** before the 7:00 pm submission
