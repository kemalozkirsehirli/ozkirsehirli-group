# TBXT Hackathon — High-Leverage Strategies (Beyond the Basic Pipeline)

**Status as of 2026-05-06 (T-3).** This file enumerates the 8 high-leverage strategies that go beyond Vina + GNINA + analog enumeration. Each entry: what / why / inputs / method / test plan / effort / on-day deployment decision.

The basic pipeline (Vina + GNINA + Analog enumeration) gives us a Tier-B effort. To compete at Tier-A — i.e., to credibly attack the hard problem (3.4B compounds, 10 µM ceiling, judges who reward reasoning) — we need at least 2–3 of these.

## Strategy summary table

| # | Strategy | Effort (hrs) | Status | Leverage | Order |
|---|---|---:|---|---|---:|
| **1** | **TBXT-specific QSAR on Naar SPR data** | **2–3** | **READY** | **Highest** | **1st** |
| 2 | Pharmacophore match against onepot 3.4B | 2 (setup) | BLOCKED-ONDAY | High | (5th) on-day |
| 3 | Active-learning loop on the 3.4B | 4 (setup) | BLOCKED-ONDAY | Medium-high | (6th) on-day |
| 4 | Co-folding with Boltz-2 / AlphaFold3 | 2 setup + ~min/cmpd | READY | Medium-high | 4th |
| 5 | Ensemble docking (multi-conformer receptor) | 1 | READY | Medium | 3rd |
| 6 | FEP / MMGBSA on top picks | 3 setup + overnight | READY | High (top-N only) | 6th, post-shortlist |
| 7 | Generative chemistry (Pocket2Mol / DiffSBDD) | 4 | READY | High | 5th |
| 8 | Selectivity check vs T-box family | 1 | READY | Medium (rationale-only) | 2nd |

**Recommended execution order (pre-event):** 1 → 8 → 5 → 4 → 7 → 6. Pharmacophore + active learning (2, 3) deploy on-day after Onepot access is established.

---

## Strategy 1: TBXT-specific QSAR on the Naar SPR data

### What
Train a target-specific affinity predictor using the **2331 compound + Kd dataset** sitting in `data/naar/` (Zenodo record 8212611, password "HDB"). Output: a model that ingests SMILES and produces a TBXT-binding score, calibrated to the actual CF Labs / HDB SPR assay.

### Why
- **Highest leverage of any strategy.** GNINA's CNN was trained on PDBbind (mostly enzymes/kinases) — TBXT is out of distribution. A model fit on 2331 *real TBXT SPR measurements* will be vastly better calibrated than off-the-shelf docking on this specific target.
- We are the only team that's looked seriously at this dataset. (It's Zenodo-public but obscure and password-locked.)
- A simple Random Forest on Morgan fingerprints typically produces R² 0.3–0.5 on QSAR tasks at this scale — enough to discriminate "likely binder" from "unlikely" robustly.
- Goes directly to the hardest problem: affinity prediction at µM regime.

### Inputs
- ✅ Data already pulled: `data/naar/` (15 password-protected XLSX files, password "HDB" per Zenodo description).
- Need to install `msoffcrypto-tool` (`pip install msoffcrypto-tool` in the conda env).
- Need to extract Kd values per compound — the XLSX files contain SPR sensorgrams + fitted Kd's per compound per campaign (10 campaigns).

### Method
1. Decrypt the 14 timestamped SPR campaign Excel files (msoffcrypto-tool → unencrypted XLSX).
2. Parse out compound_id → fitted Kd per campaign. Aggregate (median? best-fit? 'binder' vs 'non-binder' label?).
3. Match compound IDs to SMILES from the master `ID_with_SMILES.xlsx` (already done — `naar_smiles.csv`).
4. Compute Morgan FPs (radius 2, 2048 bits) for the matched set.
5. Train multiple simple regressors:
   - Random Forest regressor on log10(Kd)
   - XGBoost on the same target
   - kNN baseline (Tanimoto-weighted)
6. 5-fold cross-validation by compound (not by campaign — that's the relevant generalization).
7. **Decision metric:** Spearman correlation on held-out folds. Target ρ > 0.4. If achieved, the model is a credible orthogonal score.

### Test plan
- Cross-validation on the Naar set itself (above)
- Apply the model to the 3 CF Labs hits — does it predict their Kd within 3× of CF Labs reality? (Z795991852 = 10 µM; Z979336988 = 30 µM; D203-0031 = 17 µM)
- Apply to the 3 site F TEP fragments — does it predict them as weak binders?
- Apply to our 503-compound analog pool — does ranking change vs GNINA pKd? Are there compounds GNINA flagged that QSAR demotes (or vice versa)?

### Effort: 2–3 hours

### Status: ✅ READY (data in hand; just need to decrypt + train)

### Expected output
- `data/qsar/training_set.csv` — 2331 compounds × {SMILES, Kd_uM, source_campaign, label}
- `data/qsar/model.pkl` — trained RF/XGB ensemble
- `data/qsar/cv_results.json` — fold-level R² + Spearman ρ
- `scripts/qsar_predict.py` — wrapper: `predict(smiles_list) → predicted_pKd`
- `data/qsar/QSAR_VALIDATION.md` — predictions for CF Labs hits, TEP fragments, analog pool top-10

### On-day deployment
**YES, mandatory.** The QSAR model becomes a third orthogonal signal alongside Vina + GNINA. Tier-A picks must pass `qsar_pKd ≥ 4.0` AND existing GNINA criteria.

---

## Strategy 2: Pharmacophore match against onepot 3.4B

### What
Define a 3D pharmacophore for site F (e.g., "carboxylate H-bonding D177 + hydrophobic aryl in L42 pocket"), then use Onepot's on-day search interface to filter the 3.4B library to the ~10K-100K compounds that *could* satisfy the pharmacophore. These become the docking input.

### Why
- This is the **only way to actually search the 3.4B**. We will never dock 3.4B compounds; we need to pre-filter by chemistry, not by enumeration.
- Pharmacophore matching is the standard way virtual-screening teams attack this scale.
- Reduces the search space by 10⁴–10⁵ before expensive scoring.
- Combines well with QSAR (#1): pharmacophore reduces 3.4B → 10K, QSAR ranks 10K, dock top 1K, GNINA top 100, manual top 4.

### Inputs
- ✅ Site F pharmacophore can be defined now from TEP fragment poses (FM001580 carboxylate position, L42 contact, D177 contact).
- ⚠ **BLOCKED:** Onepot's on-day search interface. Whatever it supports (SMARTS substructure? 3D pharmacophore? simple Morgan-FP search?) determines feasibility.

### Method
Pre-event (do now):
1. Extract pharmacophore features from the 3 site F TEP fragment poses (5QSA, 5QSC, 5QSI, 5QSK PDBs):
   - Carboxylate / aniline / amide donor at distance d±2 Å from D177-OD
   - Aromatic ring centroid at distance d±2 Å from L42-CB
   - Hydrophobic feature in the OCF₃ slot
2. Build a 3D pharmacophore SDF using RDKit's `Pharmacophore` module.
3. Build a SMARTS substructure backup: `[#6;a]C(=O)[OH] OR [#6;a][NH2]` AND `c1ccccc1OC*` etc. — ready to paste into Onepot's interface if SMARTS is what they accept.

On-day:
4. Run pharmacophore (or SMARTS fallback) against 3.4B → expect ~10K-100K survivors.
5. Filter survivors against our QSAR model (Strategy 1) → top ~1K.
6. Dock top 1K with GNINA at site F → top 100.
7. Manual + co-folding for the final 8–10.

### Test plan
- Pre-event: confirm the pharmacophore correctly retrieves the 3 site F TEP fragments + the 3 CF Labs hits when applied to our 2331-compound Naar set.
- On-day: time the full 3.4B query; ensure throughput is workable in the 5-hour window.

### Effort: 2 hours pre-event; 1–2 hours on-day

### Status: ⚠ BLOCKED-ONDAY (pre-event prep is unblocked; deployment depends on Onepot)

### Expected output
- `data/pharmacophore/site_F_query.sdf` — 3D pharmacophore
- `data/pharmacophore/site_F_smarts.txt` — SMARTS fallback
- `scripts/pharmacophore_filter.py` — runs SMARTS or 3D filter against any compound set
- On-day: `data/onepot_pool/pharmacophore_survivors.csv`

### On-day deployment
**Conditional on Onepot interface.** If they support pharmacophore or SMARTS search, **mandatory**. If they only support exact SMILES lookup, fall back to filtering our enumerated 503-pool through Onepot membership and dock that.

---

## Strategy 3: Active-learning loop on the 3.4B

### What
Iterate over the 3.4B in batches. Each round: pick N candidates (random or via uncertainty sampling), score with QSAR + GNINA, retrain QSAR including the new data, re-prioritize. Convergence criterion: top-N ranking stabilizes.

### Why
- **Scales** to libraries we can't dock exhaustively.
- Concentrates compute on the *interesting* regions of chemical space, not random samples.
- Naturally combines with Strategy 1 (QSAR seed model) and Strategy 2 (pharmacophore-reduced pool).

### Inputs
- ✅ QSAR seed model (from Strategy 1).
- ⚠ **BLOCKED:** Onepot batch-query interface (need ability to pull N random compounds at a time).
- GPU time for repeated GNINA scoring.

### Method
On-day (after Onepot access):
1. Round 0: seed with the 3 CF Labs hits + best 50 from Strategy-1 QSAR top-50 against onepot pharmacophore-survivors.
2. Round 1: dock + GNINA on round-0 set; pick top 100 by combined score.
3. Round 2: train the QSAR model on (Naar) + (round-0 results); rank remaining onepot survivors; pick next 100 by uncertainty + score.
4. Repeat 3–4 rounds; final round = manual selection of 4 from the converged top-50.

### Test plan
Pre-event: simulate the loop on our 503-pool. Does picking 50 random + iteratively training converge to the same top-4 as scoring all 503? If yes, the loop works at this scale; bigger pools should generalize.

### Effort: 4 hours setup pre-event; 2–3 hours running on-day

### Status: ⚠ BLOCKED-ONDAY (Onepot dependency); pre-event simulation is unblocked

### Expected output
- `scripts/active_learn.py` — orchestrator
- `data/active_learning/round_NN.csv` — per-round picks + scores
- `data/active_learning/AL_log.md` — convergence report

### On-day deployment
**If Strategy 2 (pharmacophore) returns >50K compounds, deploy active learning.** If <10K, just dock them all (no need for AL).

---

## Strategy 4: Co-folding with Boltz-2 / AlphaFold3 / Chai-1

### What
For top candidates from docking, run a recent co-folding model (Boltz-2 is open + GPU-fast; Chai-1 is competitive; AlphaFold3 has restrictive license). Output: predicted protein-ligand co-fold + confidence score (pLDDT-equivalent). Validates the docked pose without rigid-receptor assumption.

### Why
- **Handles induced fit.** Vina/GNINA assume rigid receptor; co-folding models the protein around the ligand.
- **Confidence score is a real orthogonal signal.** Boltz-2's pLDDT-equivalent + ligand-confidence reflects whether the model "believes" the binding mode is plausible.
- This is the current SOTA for pose validation.
- Validates poses for compounds GNINA's CNN couldn't fit a known mode to (e.g., the 3 CF Labs hits scored 0.23–0.42 on CNN pose — co-folding may reveal why).

### Inputs
- ✅ GPU available (RTX 5050 8 GB; or HPC).
- Need: Boltz-2 weights (~10 GB) and inference code from https://github.com/jwohlwend/boltz
- Or: Chai-1 weights (~similar size) from https://github.com/chaidiscovery/chai-lab
- Top candidate SMILES (from Strategies 1 + 4 + 7).

### Method
1. Install Boltz-2: `pip install boltz` in the conda env (it's on PyPI as of 2026).
2. Pull Boltz-2 weights (auto-download on first run).
3. Co-fold our reference set first: TBXT G177D + each of {Z795991852, Z979336988, D203-0031, FM001580, FM001452, FM002150}.
4. Compare predicted poses to GNINA-docked poses + crystal poses (5QSA, 5QSI for the TEP fragments).
5. Compare Boltz confidence to GNINA CNN pose — do they agree?

### Test plan
- Re-fold the 3 site F TEP fragments with TBXT — predicted pose RMSD to crystal poses (5QSA, 5QSI) should be < 4 Å for a "good" co-fold.
- Re-fold the 3 CF Labs hits — does Boltz predict site F binding (i.e., near Y88/D177/L42)? If yes: validates site F assignment. If no: Boltz is telling us something we missed.
- Apply to top-10 picks from Strategies 1 + 4 + 7. Confidence score becomes a 4th orthogonal signal alongside Vina + GNINA + QSAR.

### Effort: 2 hours setup + ~1 min/compound on RTX 5050 → ~1 hour for top 50

### Status: ✅ READY

### Expected output
- `scripts/cofold_boltz.py` — wrapper: SMILES + receptor → co-folded pose + confidence
- `data/cofold/<compound_id>/predicted_complex.pdb`
- `data/cofold/cofold_summary.csv` — per-compound: confidence, predicted site, pose RMSD to GNINA pose
- `data/cofold/COFOLD_VALIDATION.md`

### On-day deployment
**Apply to the final 8–15 picks**, after dock + GNINA + QSAR ranking. Co-folding confidence becomes the tiebreaker for the final 4.

---

## Strategy 5: Ensemble docking against multiple receptor conformations

### What
Dock against several receptor conformations, not just 6F59 chain A. Combine scores via consensus (mean? best-of?).

### Why
- **Cheap insurance against single-conformation bias.** Site F may be more open/closed in different crystal contexts.
- 6F59 = G177D + DNA. 5QS9 = G177D, no DNA, fragment-bound (sites A-E). 5QSA/5QSI/5QSK = WT, no DNA, site F fragment-bound. **All are valid receptor states.**
- A binder that scores well across the ensemble is more credible than one that scores well in one snapshot.

### Inputs
- ✅ All PDBs already pulled (5QS9, 5QSA, 5QSI; need to add 6F58, 6F59 chain B, 5QSK, 5QSC).
- Same prep pipeline as 6F59 chain A (PDBFixer + obabel → PDBQT).

### Method
1. Prep 4-6 receptor conformations:
   - 6F59 chain A (G177D + DNA, current default)
   - 6F59 chain B (the dimer partner)
   - 6F58 chain A (WT + DNA, for sanity)
   - 5QS9 chain A (G177D apo, fragment-bound at A)
   - 5QSA chain A (WT apo, FM001580 bound at site F)
   - 5QSI chain A (WT apo, FM001452 bound at site F)
2. Define site F + site A grids on each (centroid of pocket residues; same as `define_pockets.py`).
3. Re-run validation set (6 reference compounds) against each.
4. Compute consensus score:
   - "Best-N consensus": median rank across receptors
   - "All-positive": compound must score ≤ -6.0 on ALL receptors
5. For full pool: dock against the 2 best receptors (most discriminative for the validation set).

### Test plan
- Validation: do CF Labs hits score consistently across receptors? If Z795991852 scores -8 in 6F59 but -4 in 5QSA, the ensemble flags it as conformer-dependent.
- Consensus on the 16 analog smoke-test compounds — does the Vina-trap (Z795991852_analog_0024) get filtered by ensemble?

### Effort: 1 hour to prep + 1 hour to re-dock validation set

### Status: ✅ READY

### Expected output
- `data/dock/ensemble_receptors/{6F59A, 6F59B, 5QS9A, 5QSA, 5QSI}/6F59_apo.pdbqt`
- `data/dock/ensemble_grids.json`
- `scripts/ensemble_dock.py` — wrapper: SMILES → consensus score across receptors
- `data/dock/ENSEMBLE_VALIDATION.md`

### On-day deployment
**Use ensemble for the final ranking**, not for the bulk shortlist (cost ~5×). Single-conformer GNINA for screening, ensemble for the top 50.

---

## Strategy 6: FEP / MMGBSA on top picks

### What
Free-energy methods on the top 8–15 candidates. Two flavors:
- **MMGBSA**: ~minutes per compound on GPU; estimates ΔG_bind from MD trajectories. Easy to set up via OpenMM + AMBER force fields.
- **FEP**: hours per compound; alchemical transformations between pairs. Most accurate; gold-standard for relative ΔG.

### Why
- The only methods with a chance of distinguishing 1 µM vs 10 µM (both Vina and GNINA over-predict by 7–25× at this regime).
- Even MMGBSA, while approximate, gives a quantitative ΔG estimate that's grounded in MD physics rather than neural-network priors.
- For the final 4-pick decision, we want methods physics + chemistry agree on.

### Inputs
- ✅ GPU available.
- Need: OpenMM + amber14 force field + GAFF2 for ligands (or OpenFF). Conda-installable.
- Need: top candidate poses (from GNINA).
- Solvation box + counter-ions added.

### Method
**MMGBSA path (faster, recommended for the hackathon):**
1. For each top pick: take GNINA pose, build OpenMM system (protein + ligand + water box).
2. Run 1 ns MD (~minutes on RTX 5050).
3. Compute MMGBSA ΔG_bind on snapshots from the trajectory.
4. Rank candidates by ΔG_MMGBSA.

**FEP path (overnight, optional):**
1. For pairs of similar candidates (same scaffold, different R-group), set up alchemical transformation.
2. Run thermodynamic-integration or BAR. ~3–5 GPU-hours per pair.
3. Compute relative ΔG.

### Test plan
- Run MMGBSA on the 6 reference compounds. Does the ranking better match CF Labs Kd than Vina/GNINA? Target: Spearman ρ > 0.5 with the 3 CF Labs Kds.

### Effort: 3 hours setup + overnight runs

### Status: ✅ READY (just hasn't been started)

### Expected output
- `scripts/run_mmgbsa.py` — OpenMM-based MMGBSA wrapper
- `data/mmgbsa/<compound>/trajectory.dcd`, `mmgbsa_results.csv`
- `data/mmgbsa/MMGBSA_VALIDATION.md`

### On-day deployment
**Apply to top 8–15 picks** (after pharmacophore + QSAR + GNINA + co-folding shortlist). The MMGBSA ranking is the highest-fidelity single-method we have. Use it as the primary score for the final 4-pick decision.

---

## Strategy 7: Generative chemistry (Pocket2Mol / DiffSBDD / REINVENT)

### What
Pocket-conditioned generative model. Inputs: site F pocket (atoms + geometry). Outputs: SMILES of *de novo* compounds designed to fit the pocket.

### Why
- **Searches chemical space we haven't enumerated.** Our 503 analogs are ALL near-elaborations of 4 known scaffolds. Generative models can propose entirely new scaffolds.
- Best-in-class for "find compounds that aren't in your library or your imagination."
- Outputs are valid SMILES that can then be filtered through Onepot membership.

### Inputs
- ✅ Site F pocket already defined (residues 42, 88, 177 + neighbors).
- Need: Pocket2Mol or DiffSBDD weights + inference code.
- Outputs feed into Onepot membership check (on-day).

### Method
1. Install Pocket2Mol: clone https://github.com/pengxingang/Pocket2Mol; ~few-GB weights.
   Or DiffSBDD (faster, simpler): https://github.com/arneschneuing/DiffSBDD.
2. Convert 6F59 chain A around site F (residues within 8 Å of pocket center) into the model's input format.
3. Sample 1000–10000 candidate molecules.
4. Filter through:
   - Property filter (relaxed lead-like)
   - QSAR model (Strategy 1) — TBXT-binding likelihood
   - Tanimoto < 0.85 to Naar (no duplicates)
5. Top 100–500 → on-day Onepot membership filter → dock survivors.

### Test plan
- After sampling: do top 100 by QSAR contain any compounds with Tanimoto > 0.5 to a CF Labs hit? (Sanity check that the model is in the right region of chemical space.)
- Are top 100 chemically reasonable (not pathological / not impossible to make)? Spot-check 10.

### Effort: 4 hours setup + ~30 min sampling

### Status: ✅ READY

### Expected output
- `data/generative/pocket2mol_proposals.csv` — N candidates with ranking
- `data/generative/sample_top10.png` — visual SDF of top 10 designs
- `data/generative/GENERATIVE_VALIDATION.md`

### On-day deployment
**Yes — generated proposals go through the same filter funnel as enumerated analogs.** Onepot membership is the hard filter; if a generated compound isn't in onepot's library, it's invalid for submission. This is why we need it in the candidate pool BEFORE Onepot lookup, not after.

---

## Strategy 8: Selectivity check vs T-box family

### What
Compare site F across the T-box family (TBX21, TBR1, TBX2, TBXT, etc.). Identify residue substitutions at site F. Filter our top candidates by predicted off-target binding.

### Why
- **Differentiates the rationale narrative** ("Compound X exploits residue D177, which is unique to TBXT — TBX21 has Glu, TBR1 has Asn — predicted selectivity > 100×").
- Judges grade scientific rationale heavily; a selectivity argument is the highest-quality kind of rationale.
- Cheap to do — sequence alignment + maybe a few quick docks against a homology model.

### Inputs
- ✅ TBXT crystal already prepped.
- Need: T-box family sequences (UniProt Q9Y458, O15370, Q9Y458, etc.).
- Optional: T-box family structures (e.g. TBX21 has crystal structures; TBX2 too).

### Method
1. Pull T-box family sequences from UniProt: TBXT (O15178), TBR1 (Q16650), TBX2 (Q13207), TBX3 (O15119), TBX21 (Q9UL17), TBX5 (Q99593).
2. Align via Biopython's `pairwise2` or call MUSCLE.
3. Identify residues equivalent to TBXT G177/D177, Y88, L42 in each family member.
4. For our top picks: which family members would also bind? Predict by:
   - "If pocket residues are conserved, compound binds family member"
   - "If D177 → other amino acid in family member, compound likely doesn't bind"
5. For ≥1 selectivity-relevant family member (TBX21 most relevant clinically), dock our top 4 picks.

### Test plan
- Confirm D177 is unique to TBXT (or has a different residue in other family members). If conserved, the strategy is moot.
- Confirm our top 4 picks score worse against ≥1 other family member than against TBXT.

### Effort: 1 hour

### Status: ✅ READY

### Expected output
- `data/selectivity/tbox_alignment.txt` — multiple-sequence alignment
- `data/selectivity/site_F_residue_matrix.csv` — per-family-member residue at TBXT positions 42, 88, 177, etc.
- `data/selectivity/SELECTIVITY_RATIONALE.md` — used directly in the slide deck

### On-day deployment
**Selectivity narrative goes in the rationale section of the submission**, not in the docking workflow. Compute pre-event; reference in the demo at 7:00 pm.

---

## Execution plan

### Tonight + tomorrow (T-3, T-2)

In dependency order:

1. **Strategy 1: QSAR on Naar SPR** (~2-3 hr) — enables Strategies 3, 4, 7 downstream
2. **Strategy 8: Selectivity check** (~1 hr) — independent, fast, narrative-heavy
3. **Strategy 5: Ensemble docking** (~2 hr) — independent
4. **Strategy 4: Co-folding (Boltz-2)** (~3 hr) — needs GPU + weights
5. **Strategy 7: Generative chemistry** (~4 hr) — uses QSAR for ranking
6. **Strategy 6: FEP / MMGBSA** (~3 hr setup; runs overnight)

### On-day (T-0, May 9 2:00 pm)

7. **Strategy 2: Pharmacophore filter** against Onepot 3.4B → ~10K survivors
8. **Strategy 3: Active learning** if survivor pool > 50K

### Final ranking (T-0, 5:00–6:00 pm)

Combine all signals. Tier-A picks must satisfy:
- GNINA: CNN pose ≥ 0.5 AND CNN pKd ≥ 5.0
- QSAR (Strategy 1): predicted pKd ≥ 4.0
- Co-folding (Strategy 4): confidence ≥ threshold (TBD from validation)
- Ensemble docking (Strategy 5): consensus rank top-50 across receptors
- MMGBSA (Strategy 6): ΔG ≤ –20 kcal/mol (TBD threshold)
- Selectivity (Strategy 8): predicted off-target ≥ 10× weaker (rationale only)

### How a compound becomes a final pick

A compound is **shippable** if it appears in the Tier-A list of ≥ 3 of {GNINA, QSAR, Boltz-2, Ensemble, MMGBSA}. We pick 4 such compounds, prioritizing diversity of hypothesis (≥ 2 chemotypes, mixed sites if any score for site A as well).

---

## Honest assessment

If we execute Strategies 1, 5, 8 alone we are **Tier B+**.
If we add Strategies 4 and 7 we are **Tier A-**.
If we add Strategy 6 (MMGBSA) we are **Tier A**.
If we have Onepot-supported pharmacophore (Strategy 2) we are competitive with serious teams.

The hackathon $250 prize is winnable at Tier B+. The experimental $250K-tier requires Tier A or better — and even Tier A is a long shot at 5 µM (the Foundation has been stuck at 10 µM for years).
