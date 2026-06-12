# On-day playbook — TBXT Hackathon, Saturday May 9, 2026

Pillar VC, Boston. Doors 1:00 pm · Submissions 7:00 pm · Judging 7:30 pm.

This playbook is the hour-by-hour script for executing the submission. The
pipeline is fully pre-computed. On-day work is filtering against onepot,
locking final picks, and demoing.

---

## 8:00 am — Lead pre-flight (home)

```bash
cd ~/Hackathon
git pull
bash TBXT/setup_hf.sh --update         # picks up any overnight bundle changes
bash TBXT/smoke_test.sh                # 7-step pipeline sanity (~6 s)
```

Confirm:
- ✅ all 12 setup checks pass
- ✅ smoke test ends with `ALL SMOKE-TEST CHECKS PASSED`
- ✅ `report/SUBMISSION.md` is current
- ✅ `report/SLIDES.md` ready (export to PDF separately if you want backup)

Pack: laptop, charger, phone, USB-C hub, paper printout of `final_4_picks.csv`
(safety net if Wi-Fi fails).

## 9:00 am — 12:00 pm — Travel + arrive

Get to Pillar VC ~12:30 pm to claim a good seat with power + Wi-Fi.

## 12:30 pm — 1:30 pm — Pre-event setup

1. **Connect to Pillar VC Wi-Fi** — confirm bandwidth ≥ 5 Mbps
2. **Test repo + HF download:** `cd ~/Hackathon && git pull && bash TBXT/setup_hf.sh --update` should complete in <2 min if all bundles cached
3. **Browser tabs to open in advance:**
   - https://luma.com/n9hheb8j (event page — submission link likely posted here)
   - https://tbxtchallenge.org/?utm_source=luma#prizes (prize info)
   - https://huggingface.co/datasets/<HF_USER>/<HF_REPO> (our bundles)
   - <PUBLIC_REPO_URL> (public repo)
   - https://www.muni.bio (sign up at venue if not done)
   - https://labs.rowansci.com/create-account (Rowan free credits)

## 1:30 pm — Announcements

**Listen for / write down:**

1. **Onepot library access mechanism** (CSV download? SMILES lookup API?
   structure-search service? Their on-day interface determines our filter step.)
2. **Submission portal format** — Google Form? In-person? Slide deck?
   Demo length?
3. **Team registration** — do they want us to register a team name?
4. **muni.bio + Rowan credits** — are they handed out at the door?
5. **Any rule clarifications** — esp. on novelty / Naar overlap / chemistry filter

**At 1:30 pm announcements end, you should know:**
- The exact onepot lookup mechanism
- The exact submission format
- Team name + slot ID

## 1:30 pm — 2:30 pm — Onepot filtering

This is the **single highest-stakes hour** of the event.

### Path A — Onepot provides a downloadable subset

```bash
# 1. Save their CSV to disk (e.g. ~/onepot_today.csv)
# 2. Filter our top 100 against it
cd ~/Hackathon
python TBXT/scripts/team/onepot_filter.py \
    --top500 TBXT/data/task10/trial1/top500_consensus_ranked.csv \
    --onepot ~/onepot_today.csv \
    --output TBXT/report/onepot_survivors.csv \
    --topn 4
cat TBXT/report/onepot_survivors.csv
```

### Path B — Onepot provides a structure-search API / web lookup

For each of our 4 picks (and top 100 backup), submit the SMILES to their
lookup. Mark each as in-CORE / not-in-CORE.

If 4 picks survive → ship them. If fewer survive → walk down `top_100_consensus.csv`
filling slots, prioritizing site diversity (≥ 1 site-A) and onepot reach ≥ 0.95.

### Path C — Onepot provides similarity-search only (SMILES → nearest CORE compound)

Submit each of our 4 SMILES; accept the nearest-CORE compound as a substitute
if Tanimoto ≥ 0.90 (effectively the same molecule). If Tanimoto < 0.90 for any
pick, swap that slot using `top_100_consensus.csv`.

### Path D — Onepot lookup unavailable / broken

Submit our 4 picks anyway, citing **onepot reachability score (1.00 / 0.74)** as
evidence each is plausibly synthesizable. Document the limitation in the
rationale.

---

## 2:30 pm — 5:30 pm — Use spare time productively

Pick from these in order of leverage. Skip the ones that don't apply.

### 2.5a — muni.bio engagement

```
1. Sign up at https://www.muni.bio (uses event credits from organizer if provided)
2. Try docking / co-folding on the 4 picks against TBXT G177D
3. If muni gives Kd / pose, add to deck as 7th orthogonal signal
```

If muni accepts SMILES: paste our 4 picks. If muni accepts SDF: convert via
`obabel /tmp/picks.smi -O /tmp/picks.sdf`.

### 2.5b — Rowan re-rank (RBFE)

```
1. Sign up at https://labs.rowansci.com/create-account
2. Use Rowan's RBFE to compute relative ΔG between gen_0007 (our anchor)
   and the other 3 picks
3. Cross-validate against our own MMGBSA + FEP results
```

### 2.5c — Pose visualization polish

```bash
cd ~/Hackathon
ls TBXT/data/task9/trial1/renders/   # already 8 PNGs (4 picks × 2D + 3D)
# Add per-pick interaction-residue annotations if time permits
```

### 2.5d — Stress test the slides

Read `TBXT/report/SLIDES.md` aloud once. Time it (target: 5 min).
Trim anything beyond the 5-min mark.

---

## 5:30 pm — Lock the picks (HARD)

No more changes after 5:30 pm. Last 90 min is verification + slide polish only.

```bash
# Generate / refresh deck (Marp or paste into Google Slides)
cd ~/Hackathon
cat TBXT/report/SLIDES.md
cat TBXT/report/SUBMISSION.md
cat TBXT/report/final_4_picks.csv | column -t -s,
```

**Final sanity checks (run all):**

| # | Check | Pass criterion |
|---|---|---|
| 1 | All 4 SMILES parse via RDKit | `python -c "from rdkit import Chem; ..."` returns valid mol for all 4 |
| 2 | All 4 pass Chordoma rule | MW ≤ 600, LogP ≤ 6, HBD ≤ 6, HBA ≤ 12 |
| 3 | All 4 PAINS-clean | no Baell-2010 catalog matches |
| 4 | All 4 Tanimoto < 0.85 to Naar 2274 | re-check with `prior_art_canonical.csv` |
| 5 | Sites match `final_4_picks.csv` | site-A pick is `Z795991852_analog_0021` |
| 6 | Submission format matches portal | confirm table / form fields populate correctly |

## 6:30 pm — Dinner break

Eat. Drink water. Don't open the laptop unless the deck typo'd.

## 7:00 pm — Submit + demo

Submit via whatever mechanism the organizers announced at 1:30 pm.

**Demo opener (read aloud):** *"We attacked TBXT G177D site F (the variant
pocket) with a 6-signal consensus pipeline on a 570-compound novelty-filtered
pool. Our 4 picks span 2 sites and 2 chemotypes; the strongest by free-energy
beats the CF Labs SPR-validated reference, and 2 of 4 have direct onepot
retrosynthetic disconnections. Here's the table…"*

## 7:30 pm — Judging

Be ready to answer:

- **"How did you avoid Naar duplication?"** → Tanimoto < 0.85 against full 2274
- **"What about onepot synthesizability?"** → reachability score audit per arXiv:2601.12603 method; 81% of pool ≥ 0.95
- **"Why these 4 and not other top-ranked compounds?"** → diversity rules (≥ 2 sites, ≥ 2 chemotypes, Tanimoto < 0.7 between picks) + reachability tiebreaker
- **"What's your honest expectation in CF Labs SPR?"** → 1-2 picks bind in 20-60 µM range; methods over-predict by 6-25× at µM regime
- **"Why site F?"** → G177 is 0% conserved across 16 T-box paralogs; intrinsically TBXT-selective
- **"What if all 4 fail in onepot?"** → top 100 (`top_100_consensus.csv`) plus 460 reachability ≥ 0.95 in pool ⇒ 4 backup picks within reach

---

## Emergency contingencies

| Scenario | Action |
|---|---|
| Wi-Fi dies | Use phone hotspot; or printed `final_4_picks.csv` for paper submission |
| Laptop dies | Phone has SSH access to HPC; submission is markdown so paste from phone |
| Submission portal rejects a SMILES | Paste from `top_100_consensus.csv` row 5 onward; sites + chemotypes still fine |
| Onepot says all 4 picks are "not in CORE" | Plead the case from reachability audit; ALSO submit nearest reach-1.0 compound as backup |
| Demo time exceeded | Skip per-pick rationale slides; jump to "honest expectations" |

## Pre-event checklist (do night before)

- [ ] `git pull` on lead's machine — latest commit pushed
- [ ] `bash setup_hf.sh --update` — bundles current
- [ ] `bash smoke_test.sh` — passes
- [ ] Print `final_4_picks.csv` to paper (3 copies)
- [ ] Charge laptop + phone + battery pack
- [ ] Confirm Pillar VC address: 60 Bromfield St, Boston, MA
- [ ] Confirm doors at 1:00 pm Saturday May 9
- [ ] Print directions
