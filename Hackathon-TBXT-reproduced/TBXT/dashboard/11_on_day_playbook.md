# Task 11 — On-day playbook (May 9, 2026)

**Owner:** Presenter (or coordinator if presenter is busy with Task 9). **Compute:** all team members on event day. **Effort:** 5 hours (the event itself). **Depends on:** Tasks 0, 1, 9, 10.

## What you're solving

Translating 50 hours of team prep into a winning 5-hour event window. Most failures on hackathon day come from on-day chaos, not from poor prep — this brief is the operations playbook.

## Pre-event checklist (do at T-12h, May 8 evening)

- [ ] Final 4 picks locked from Task 10 (`FINAL_4_PICKS.md` written)
- [ ] 4 backups identified
- [ ] Slide deck final state (`SLIDES.pptx`)
- [ ] Demo dry-run completed (≤ 4:30 elapsed)
- [ ] All team members' `setup_check.sh` re-run (one more time)
- [ ] Onepot library access mechanism confirmed (Task 1 answers)
- [ ] muni.bio / Rowan account status confirmed for all members
- [ ] Snapshot taken: `bash scripts/snapshot.sh T-12h`
- [ ] Team contact list with phones (in case someone gets stuck on the day)

## Roles for the event day

| Role | Person | Time-block |
|---|---|---|
| Coordinator | <name> | All day; runs LIVE_TRACKER + handles surprises |
| Library lookup | <name> | 2–4 pm; runs Onepot membership filter |
| Compute owner #1 | <name> | 2–4 pm; reruns multi-seed GNINA on filtered set |
| Compute owner #2 | <name> | 3–4 pm; reruns Boltz on filtered set |
| Chemist #1 | <name> | 4–5 pm; manual curation of top 10 |
| Chemist #2 | <name> | 4–5 pm; pairs with #1; spots concerns |
| Rationale writer | <name> | 5–6 pm; writes per-pick narrative |
| Slides + verification | <name> | 6–7 pm; locks deck, verifies SMILES |
| Presenter | <name> | 7–7:30 pm; demos |
| Submitter | <name> | 7 pm sharp; submits |

## Hour-by-hour timeline

### 1:00 pm — Doors open

- Team arrives. Coordinator checks everyone in.
- Collect logistics: Wi-Fi password, muni.bio access if not done, Onepot interface URL.
- Set up the 10-laptop pool. Verify each can reach the team's git remote (the workspace + scripts).

### 1:30 pm — Announcements

- Presenter takes notes on any rule clarifications.
- Submit the `organizer_questions.md` items that haven't been answered yet, in person.
- **Critical:** confirm Onepot library lookup mechanism; whatever it is, the library-lookup owner runs it from now.

### 2:00 pm — Hacking begins

**Library-lookup owner:**
```bash
# Run Onepot membership check on Tier-A list (40 picks + backups + generative top 50 = ~100 input)
python scripts/team/onepot_filter.py \
    --candidates data/tier_a/final_tier_a.csv \
    --onepot-interface <ONEPOT_API_OR_FILE> \
    --out data/onday/onepot_filtered.csv
# Expected output: ~5–20 in-library compounds
```

**Compute owners:** standby until library-lookup finishes (~30 min). Then run multi-seed GNINA on the in-library set at exhaustiveness 16 (more thorough than pre-event).

### 2:30 pm — Multi-seed GNINA on filtered set

**Compute owner #1 (parallelized across 2-4 GPUs in the team):**
```bash
python scripts/team/dock_gnina_multiseed.py \
    --smiles-csv data/onday/onepot_filtered.csv \
    --site F \
    --out-dir data/onday/gnina_F_filtered \
    --seeds 10 \
    --exhaustiveness 16
# ~20 compounds × 10 seeds × ~10 sec at exh 16 = ~30 min on 1 GPU
```

### 3:00 pm — Boltz-2 on filtered set

**Compute owner #2:**
```bash
python scripts/run_boltz.py \
    --smiles-csv data/onday/onepot_filtered.csv \
    --out-dir data/onday/boltz_filtered
# ~20 compounds × ~1 min on A100 = ~20 min
```

### 4:00 pm — Manual chemistry curation

**Chemists 1 + 2 (paired):**
- Open `data/onday/gnina_F_filtered/dock_results_multiseed.csv` and `data/onday/boltz_filtered/boltz_summary.csv`
- For each compound (top 10 by composite):
  - Eyeball the structure for chemistry concerns (reactive groups, weird stereo, etc.)
  - Check the docked pose (open in PyMOL: `pymol data/onday/gnina_F_filtered/poses/<id>_F.pdbqt data/dock/receptor/6F59_apo.pdb`)
  - Flag anything odd in `data/onday/chemistry_flags.md`

### 5:00 pm — Per-pick rationale + final 4

**Rationale writer + chemists:**
- For each top compound, run anchor-contact analysis:
  ```bash
  python scripts/analyze_poses.py --validation-dirs data/onday/gnina_F_filtered
  ```
- Write 1-paragraph binding hypothesis per pick (use template from `dashboard/10_consensus_aggregation.md`).
- Write/update `data/onday/FINAL_4_PICKS_ONDAY.md`.

### 5:30 pm — Convergence meeting

**All:**
- 30-min review. Vote on final 4 (chemists have veto on chemistry concerns).
- Update slides with final picks + numbers + rationale.

### 6:00 pm — **LOCK**

**No more code, no more new ideas. Only verification + slide polish.**

- Slides owner finalizes `SLIDES.pptx`.
- Submitter verifies:
  - 4 SMILES are valid (RDKit can parse)
  - All 4 are in the Onepot filtered list
  - PAINS-clean
  - Chordoma rule compliant
  - Properties match what's in the deck

### 6:30 pm — Demo dry-run

**Presenter:**
- Run through the deck once, timed. Target ≤ 4:30.
- Iterate once if needed.

### 6:45 pm — Buffer / submission verification

**Submitter:**
- Open the submission portal/form (whatever it turned out to be from Task 1's answers).
- Pre-fill the 4 SMILES + binding sites + properties.
- Don't submit yet.

### 7:00 pm — **SUBMIT + DEMO**

**Submitter:** click submit at 7:00:00 sharp.
**Presenter:** demo.

### 7:30 pm — Judging Q&A

**Presenter + chemists:** field questions. Reference the per-pick anchor-contact numbers, FEP rankings, selectivity-dock numbers.

## What can go wrong on the day (with fixes)

| Scenario | Fix |
|---|---|
| Onepot interface is slow / queued | Use the pre-event Tier-A list; mark in slide that Onepot membership is "pending verification" |
| Wi-Fi at the venue is bad | Have all repos + data + env on a USB stick as backup |
| Only 2-3 picks survive Onepot membership | Pick 1 strong + use 3 backups from `FINAL_4_PICKS.md` backup list |
| Demo crashes (slides software) | Have PDF + paper printout + backup laptop |
| Boltz fails to run on the day's hardware | Skip Boltz-on-day; use pre-event Boltz numbers |
| Compound's docked pose looks wrong | Re-dock at exhaustiveness 32 + 20 seeds (slow but more reliable) |
| 6:30 demo dry-run goes 7+ minutes | Cut 1 slide; tighten transitions; rehearse one more time |

## Post-event (T+0 to T+48h)

- Take a final snapshot: `bash scripts/snapshot.sh post-event`
- Within 48 hours: write `post_mortem.md` per `~/Hackathon/docs/HACKATHON_LEARNINGS.md` § 11.
- If we won: register for the next phase of the experimental program (Sept 1 batch deadline).

## Notes

- **Lock at 6:00 pm is non-negotiable.** Per `HACKATHON_LEARNINGS.md` § 3, "the last hour of changes usually hurt." Your job at 6:00 is to *prevent* further changes.
- **The presenter speaks to the science, not the code.** Judges grade rationale, not pipeline.
- **Don't refresh Onepot status more than once per 5 min.** Watching it doesn't make it faster.
