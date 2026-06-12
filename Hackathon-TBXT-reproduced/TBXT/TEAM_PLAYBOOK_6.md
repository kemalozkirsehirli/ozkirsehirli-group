# TBXT Hackathon — Team Playbook (6 Members)

**Lead-facing master plan. As of T-1 day (2026-05-08). Hackathon: 2026-05-09, 1 pm – 7:30 pm at Pillar VC Boston.**

This document supersedes `TEAM_HANDOFF.md` for the 6-member execution. The strategic content there is unchanged; this file replaces the role allocation, the timeline, and the win-definition with a sharper version calibrated to **6 equally-skilled members each owning 1–2 tasks, with 1–2 days of compute, all work done before the event.**

---

## 1. Win-definition (what "we won" means)

| Tier | State at 7:30 pm May 9 | Realistic odds with this plan |
|---|---|---|
| **Tier 1 — Hackathon judging prize ($250 + visibility)** | Judges declare us in their top 1–3 by **scientific rationale + tractability + judgment** of the 4-pick | **~70%** with the work done. Already over-determined by the 5-signal pipeline + 40 Tier-A picks + selectivity argument. |
| **Tier 2 — Experimental ≤ 5 µM ($100K, 3 awards)** | At least 1 of our 4 picks binds ≤ 5 µM in CF Labs SPR | **~30–40%** with the **100–500 candidate strategy** (see §2). Without the strategy, ~10–15%. |
| Tier 3 — ≤ 300 nM ($250K, 2 awards) | Sub-µM binder | Don't optimize for. Lottery ticket. |

**The winning posture: lock Tier 1 hard, structure for Tier 2, ignore Tier 3.**

---

## 2. The 100–500 candidate strategy (the strategic shift)

### Why we don't pick only 4 in advance

The hackathon submission is 4 ranked SMILES. But the deciding constraint **on the day** is whether each pick is in onepot's 3.4B library — and we have no way to test that in advance (their interface is on-day-only). If we pre-select 4 picks and any of them aren't in onepot's library, the submission is degraded or invalid.

### The strategy

**Build a deep, multi-method-validated, ranked candidate pool of 100–500 compounds before the event.** On the day, run them through onepot's membership filter and take the top 4 from the in-library survivors.

```
Pre-event (this playbook):
  570-compound pool (already there) → multi-signal validated by 6 members
    → consensus-ranked top 500 in `report/task10_top500.csv`

On-day (~2 pm May 9):
  500 compounds → onepot membership API → ~10–50 in-library survivors
    → top 4 by consensus rank → submit
```

**Why 100–500 and not just 100?** Onepot's library is enumerated from 7 reaction classes. Our pool consists of BRICS-recombined compounds + analogs of Naar-disclosed scaffolds. Empirical guess: 5–20% of our pool will be in-library. Going to 500 gives expected ~25–100 survivors → comfortable margin to pick 4.

**Why this changes nothing we're doing pre-event:** we already have all 570 compounds going through every task. The change is **how we present the result** — task10 now outputs the top 500 ranked, not just the top 4 picks.

---

## 3. Member allocation

6 members, equally skilled in ML/chemistry/bio. Lead is M1.

| Member | Primary task | Secondary task | Why this pairing | Compute |
|---|---|---|---|---|
| **M1 (you, lead)** | Task 1 — email organizers | Task 9 — pose renders + Task 10 — consensus | Lead's secondary tasks are *terminal* (depend on M2-M6 finishing). Done in last few hours. | Laptop |
| **M2** | Task 2 — multi-seed GNINA on 570-pool at site F | Task 3 — site-A pool dock | Same pipeline at different grid; tight coupling. | A100 + 28 CPU |
| **M3** | Task 4 — Boltz-2 full pool co-fold | (slack: stretch trials) | Boltz alone is ~10 GPU-h on A100; full single owner. | A100 + 28 CPU |
| **M4** | Task 5 — MMGBSA fix + run on top 200 | Task 6 — selectivity dock vs paralogs | Both need protein-prep + OpenMM toolchain familiarity. M4 fixes energy decomp first, runs MMGBSA, then preps paralog receptors + selectivity dock. | A100 + 28 CPU |
| **M5** | Task 7 — generative scale-up to 500–1000 proposals | (slack: pocket-conditioned generative if BRICS done) | Generative is the highest-novelty task; long stretch ladder available. | A100 + 28 CPU |
| **M6** | Task 8 — FEP on top 8 pairs | — | FEP is the heaviest task: ~4 h to write run_fep.py + ~40 GPU-h of perturbations. Sole owner, all 1–2 days. | A100 + 28 CPU |

**Why no one is double-booked on a heavy task:** with 1–2 days, no member has slack for two compute-heavy primaries. Secondaries are either fast (Task 3 = ~50 min), terminal (Tasks 9 + 10 wait for upstream), or stretch-only.

---

## 4. Calendar — T-2 → T-12h → T-0

| Date / time | What | Owner |
|---|---|---|
| **T-2 day evening** (May 7, 11 pm) | Code freeze on `task<N>.sh`. Members pull latest from `TBXT` branch. Lead sends MEMBERS.md with assignments. | Lead |
| **T-1 day morning** (May 8, 8 am) | Each member runs `bash setup.sh` + `bash smoke_test.sh`. Reports OK in chat. | All |
| **T-1 day morning** (May 8, 9 am) | Lead sends organizer email (Task 1). Each member reads their `dashboard/M<N>.md`, opens their `dashboard/task<N>_playbook.md`, kicks off `bash TBXT/experiment_scripts/task<N>.sh`. | All |
| **T-1 day, every 4 hr** | Lead runs `bash TBXT/experiment_scripts/pipeline_status.sh --all-trials`. Posts blocker check in chat. | Lead |
| **T-1 day afternoon** (May 8, 2 pm) | Halfway-status standup (15 min). Anyone < 30% done flags it. | All |
| **T-1 day evening** (May 8, 8 pm) | Members upload **base-trial JSON** (`report/task<N>_trial1.json`) to Drive even if stretch trials still running. | All |
| **T-12h hard deadline** (May 8, 11 pm) | All members must have at least their base-trial JSON in Drive. Anyone not done → lead pulls partial JSON or marks task as PARTIAL. | All |
| **T-12h to T-8h** (May 8, 11 pm → May 9, 3 am) | Lead pulls all JSONs from Drive into local `report/`. Runs `bash TBXT/experiment_scripts/task10.sh`. Produces `report/task10_top500.csv` + `task10_trial1.json`. | Lead |
| **T-8h to T-4h** (May 9, 3 am → 7 am) | Lead runs `bash TBXT/experiment_scripts/task9.sh` for top 8 picks. Drafts slide deck with placeholders + numbers. | Lead |
| **T-4h to T-2h** (May 9, 7 am → 11 am) | Demo dry-run (≤ 4:30). One iteration on slides if needed. **Lock.** | Lead + chemist M4 |
| **T-0 (May 9, 1 pm)** | Doors. Team arrives at Pillar VC. | All |
| **T-0+1h (May 9, 2 pm)** | Onepot membership filter on `top500_consensus_ranked.csv` → in-library survivors. Top 4 by consensus rank picked. | Lead + M2-M5 |
| **T-0+5h (May 9, 6 pm)** | Submission locked. Final slide review. | Lead |
| **T-0+6h (May 9, 7 pm)** | **Submit + Demo.** | Lead (presenter) |

---

## 5. Done-criteria framework

Every task has 4 levels:

| Level | What it means | Lead's response |
|---|---|---|
| **MIN** (mandatory) | Base run completes; JSON has `status: OK` and minimum N processed | Lock. Member uploads JSON. |
| **TARGET** (expected) | All scientifically meaningful filters pass; correlations sane | Lock. Member moves to first stretch trial. |
| **STRETCH** (good day) | Member completes 1+ additional trial with a parameter sweep | Recognized in slide deck "we did N trials" |
| **WIN+** (excellent day) | Member's signal materially shifts the consensus ranking | Highlight in demo as a strength |

Each `dashboard/task<N>_playbook.md` has explicit JSON-metric thresholds for MIN/TARGET. Members aim for TARGET, accept MIN if blocked.

---

## 6. Lead management — your daily cadence

### Standups (15 min, 9 am and 6 pm)

Every member answers:
- What did you finish since last standup?
- What's running now? Expected wall-clock?
- Any blockers > 1 h?

Status tools:
```bash
bash TBXT/experiment_scripts/pipeline_status.sh --all-trials
```

### Redistribution rules

- **At T-1d 9 am**: any member who hasn't started by 10 am → call them, troubleshoot, redistribute task if no progress in 30 min.
- **At T-12h 8 pm**: any member with `status != OK` → take their partial JSON (whatever's there), mark consensus contribution as PARTIAL, move on.
- **Never redistribute heavy tasks (FEP, Boltz, generative) within < 6 h of deadline** — too short to redo. Accept partial.

### Escalation — what only lead handles

- Task 1 email + organizer responses
- Anyone blocked on `setup.sh` (download issues, env)
- Disagreement between members about consensus weighting
- Pulling JSONs from Drive after T-12h
- Demo + submission on the day

### Communication

Single chat channel. Channel etiquette:
- **🚨 BLOCKED:** prefix when you need lead intervention within 1 h
- **✅ DONE: task<N> trial<T>** when JSON uploaded to Drive
- **▶ STRETCH:** when starting an additional trial

---

## 7. Risk register

| Risk | Probability | Mitigation |
|---|:---:|---|
| Onepot membership filter returns < 4 in-library compounds | **Low (with 500 pool)** | Top 500 → expected 25-100 survivors. Ample margin. |
| Member's compute fails / GPU dies | Medium | Lead reassigns task to whoever finished early; FEP is the only task that can't be redone in < 1 day. |
| FEP framework not written by M6 | Medium | M6's playbook says: write the script first, run minimal config, expand if working. PARTIAL is acceptable. |
| MMGBSA fix doesn't converge | Medium | Task 5 already has a working scaffold; even bugged numbers PARTIAL-feed the consensus. |
| Member doesn't read task playbook | Low | Lead sends per-member playbook URL via chat; each playbook is < 2 pages. |
| Boltz-2 GPU compatibility issue | Medium | If Boltz fails on M3's GPU, fall back to using existing reference-set Boltz numbers. |
| Onepot's submission portal differs from expected | Medium | Task 1 email asks; lead has 3 backup formats prepared. |
| Demo runs over time | Low | Dry-run + iteration at T-4h. |

---

## 8. Files in this playbook bundle

| Path | Audience | Purpose |
|---|---|---|
| **`TEAM_PLAYBOOK_6.md`** (this file) | Lead | Master plan |
| `dashboard/M1.md` … `M6.md` | Each member | "What I do, when, with what done-criteria" |
| `dashboard/task1_playbook.md` … `task10_playbook.md` | Anyone running that task | Scientific goal + done criteria + stretch ladder |
| `experiment_scripts/task<N>.sh` | All | The script itself; called by member |
| `experiment_scripts/pipeline_status.sh` | Lead | Status reader (only reads JSONs) |
| `dashboard/MEMBERS.md` | Lead | Identity → role mapping (lead fills with names) |
| `dashboard/LIVE_TRACKER.md` | All | Status board template (legacy from 10-member plan; 6-member plan uses chat instead) |

---

## 9. The 24-hour playbook for you (lead) in detail

### T-1d 8 am
- Send chat: "Setup check: everyone run `bash setup.sh && bash smoke_test.sh`. ✅ in chat when done."
- Send organizer email (Task 1):
  ```bash
  cd ~/Hackathon
  bash TBXT/experiment_scripts/task1.sh
  # Copy output, send to tbxtchallenge@chordoma.org
  ```

### T-1d 9 am
- Send to each member: their `dashboard/M<N>.md` URL.
- Each member reads playbook, reads task playbook, kicks off task.

### T-1d 10 am to 6 pm
- Every 2 h: check `pipeline_status.sh`. Address 🚨 BLOCKED in chat within 30 min.
- Light status updates only. Don't over-manage.

### T-1d 8 pm
- Standup. Confirm who has uploaded base-trial JSON.
- Anyone delayed: triage. Heavy tasks (Boltz, FEP) given hard "upload by 11 pm what you have" deadline.

### T-1d 11 pm — T-0 3 am (4 hour focused block, lead alone)
- Pull all JSONs from Drive into local `report/`.
- `bash TBXT/experiment_scripts/task10.sh` → produces `top500_consensus_ranked.csv` + `task10_trial1.json`.
- Inspect top 50 manually with M4 (chemist sanity). Flag any that have weird stereo, PAINS missed, or look impossible to synthesize.
- `bash TBXT/experiment_scripts/task9.sh` → renders for top 8.
- Slide deck: fill numbers from `task10_trial1.json`'s top 8.

### T-0 3 am — T-0 7 am (sleep 4 hr if you can, set alarm)

### T-0 7 am — 11 am
- Demo dry-run with co-presenter (M4 chemist). Time it. ≤ 4:30.
- One slide iteration if needed.
- **Lock the deck at 11 am.** No more changes.

### T-0 1 pm doors
- Team arrives.
- Onepot interface confirmed at 1:30 pm announcements.

### T-0 2 pm – 6 pm
- Filter `top500_consensus_ranked.csv` → onepot in-library subset.
- Pick top 4 by consensus rank from survivors. M4 + M2 do final chemistry sanity on those 4.
- 6 pm: lock submission.

### T-0 7 pm
- **Submit + demo.** (Tip: submit at 6:55 pm to avoid 7 pm rush.)

### T-0 7:30 pm
- Q&A. Stay calm. Reference the per-pick rationale and selectivity numbers — both are in the slide deck.

---

## 10. The 24-hour playbook for each working member (M2–M6) in summary

```
T-1d 8 am:  bash setup.sh && bash smoke_test.sh; ✅ in chat.
T-1d 9 am:  read dashboard/M<N>.md and dashboard/task<N>_playbook.md.
T-1d 9:30:  bash TBXT/experiment_scripts/task<N>.sh (or --test first if unsure).
T-1d ?? :   monitor; if blocked > 1 h, post 🚨 BLOCKED in chat.
T-1d ?? :   when base trial OK, ✅ DONE in chat. If time + interest, kick off
            stretch trial (--trial 2 with knob change per playbook stretch ladder).
T-1d 8 pm:  upload report/task<N>_trial<T>.json to Drive.
T-1d 11 pm: hard deadline. Whatever JSON exists must be in Drive.
T-0 May 9:  rest. Show up at 1 pm if local. Otherwise be on chat.
```

That's it. Members should not improvise outside this scope.

---

## 11. The mantras

- **Lock the work before the hackathon, not during.**
- **Strength is in 100–500 candidates, not in 4.**
- **Boring multi-signal consensus wins over a single fancy method.**
- **MIN > TARGET > STRETCH > WIN+** — don't chase WIN+ if MIN isn't done.
- **Lead doesn't compute** — lead unblocks, integrates, presents.
- **At 6 pm event day: lock.** No new code, no new ideas, only verification.
