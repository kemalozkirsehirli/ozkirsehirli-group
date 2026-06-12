# TBXT Hackathon — Team Handoff & Winning Plan

**Drafted 2026-05-07 (T-2 days). For: 10-person team, 50 hours, A100 + 28-core CPU per person.**

This document defines **how we win**. Every other doc in this repo is reference; this one is the actionable plan.

---

## 1. Goal hierarchy

| Tier | Prize | What it takes | Our position |
|---:|---|---|---|
| **1** | **Hackathon judging — $250 muni credits** (judged on rationale + tractability + 4-pick judgment) | Defensible 4-pick + clean narrative + polished demo at 7:00 pm May 9 | **Already competitive.** 5-signal pipeline + 40 Tier-A picks + selectivity argument all in hand. **Plan must lock this in.** |
| **2** | **Experimental ≤ 5 µM tier — $100K each, 3 awards** (judged by CF Labs SPR Kd ≤ 5 µM after onepot synthesizes) | A submitted compound that actually binds at ≤ 5 µM in CF Labs assay | **Real shot, not a coin flip.** Foundation has been at 10 µM for years. With 500 GPU-hours we can drive prediction error from 6–25× → 2–4×, plus broaden the candidate pool. Realistic odds: ~20–35% on at least one of our 4. |
| 3 | Experimental ≤ 300 nM tier — $250K each, 2 awards | Same, at 300 nM | **Don't optimize for this.** Needs wet-lab medchem cycles we can't do in 50 hours. Treat as upside, not target. |

**Tier 1 = floor (lock it in). Tier 2 = ceiling (push hard). Tier 3 = lottery ticket (don't sacrifice T1/T2 for it).**

---

## 2. Where we are right now

| Asset | Numbers / status |
|---|---|
| Pre-event candidate pool | **570** compounds (503 enumerated analogs + 67 generative proposals), all Tanimoto < 0.85 to 2 274 known, all Chordoma-rule-compliant |
| Tier-A surfaced | **40** compounds passing all 4 hard signals (CNN pose ≥ 0.5, CNN pKd ≥ 4.5, Vina ≤ −6.0, QSAR pKd ≥ 4.0) |
| Validated orthogonal signals | **5**: Vina ensemble (6 confs), GNINA CNN (pose+pKd), TBXT-specific QSAR, Boltz-2 co-folding, T-box selectivity |
| Reference-set calibration | CF Labs hits predicted Kd within 6–25× of real (over-prediction); fragments correctly classified weak |
| Top current pick | `gen_0004` — predicted GNINA Kd 0.35 µM, QSAR Kd 23 µM, CNN pose 0.70, Tanimoto-to-known 0.30 |
| Workspace state | snapshotted at `data/snapshots/T-0/`, SHA-256 manifest, reproducible from scratch |
| Outstanding blockers | (a) Onepot library access — wall-clock-bound on organizer; (b) CNN pose run-to-run variance; (c) MMGBSA energy-decomp bug |

**Honest read:** Tier 1 is mostly done. Tier 2 needs 3–5 of the moves below to land.

---

## 3. The 11 highest-EV moves

Ordered by **(impact × probability of completing) / (compute cost)**. Each has its own dashboard brief at `dashboard/<NN>_*.md` with a pre-wired script.

| # | Move | Tier impact | GPU-h | Wall-clock | Brief |
|---:|---|:---:|---:|---:|---|
| 0 | **Setup + distribute env** (git + conda-pack + Drive) | T1+T2 (gating) | 0 | 4 h, 1 owner | `00_setup.md` |
| 1 | **Email organizers** (Onepot/muni/Rowan/submission format) | T1 | 0 | 1 h | `01_email_organizers.md` |
| 2 | **Multi-seed GNINA** on full 570-pool (kills CNN pose noise → robust Tier-A) | T1+T2 | ~5 | 2 h | `02_gnina_multiseed.md` |
| 3 | **Site-A GNINA pool** (gain site-diversified picks) | T1 | ~1 | 1 h | `03_site_A_pool.md` |
| 4 | **Boltz-2 full-pool co-fold** (independent Kd + ipTM signal) | T1+T2 | ~10 | 4 h | `04_boltz_full_pool.md` |
| 5 | **Fix MMGBSA** energy decomp + run on top 50 (6th orthogonal signal) | T2 | ~3 | 4 h | `05_mmgbsa_fix.md` |
| 6 | **Selectivity-dock** vs TBR1/TBX2/TBX21 (back rationale with numbers) | T1 | ~5 | 3 h | `06_selectivity_dock.md` |
| 7 | **Pocket-conditioned generative** (Pocket2Mol / DiffSBDD scale) | T2 | ~30 | 8 h | `07_generative_pocket2mol.md` |
| 8 | **FEP on top 8** (alchemical relative ΔG; gold-standard ranking) | T2 | ~40 | 12 h | `08_fep_top_picks.md` |
| 9 | **Pose renders + slides** (PyMOL + Biotite for the demo) | T1 | 0 | 6 h | `09_pose_renders.md` |
| 10 | **Consensus aggregation** + final 4-pick decision | T1+T2 (gating) | ~1 | 2 h | `10_consensus_aggregation.md` |
| 11 | **On-day playbook** (1 pm → 7 pm execution) | T1 (gating) | TBD | 5 h on event day | `11_on_day_playbook.md` |

**Total committed compute:** ~95 GPU-hours = **19% of budget**. Remaining 81% is slack for parameter sweeps and on-day reactive compute.

**Total committed person-hours:** ~52 hours of focused work distributed across 10 people = each person owns ~5 hours of critical-path work + has time for parameter exploration.

---

## 4. Critical path

```
                                                       ┌─────────────────┐
                                          ┌──────────► │ 10 Consensus    │ ────┐
                                          │            │ aggregation +   │     │
[T-2 day]                  [T-1 day → T-0]│            │ 4-pick decision │     │
                                          │            └─────────────────┘     │
┌─────────────┐  ┌────────────────────────┴──────┐                              │
│ 0 Setup     │ ►│ 2  GNINA multi-seed           │                              │
│ + git +     │  │ 3  Site-A GNINA pool          │                              │
│ conda-pack  │  │ 4  Boltz-2 full pool          │     ┌─────────────────┐     │
│ + Drive     │  │ 5  MMGBSA fix + top 50        │ ──► │  Convergence    │ ────┤
│             │  │ 6  Selectivity-dock           │     │  meeting (T-12h)│     │
│             │  │ 7  Generative scale           │     │  pick the 4     │     │
│             │  │ 8  FEP on top 8               │     └─────────────────┘     │
│             │  │ 9  Pose renders + slides      │                              │
└─────────────┘  └───────────────────────────────┘                              │
                                                                                ▼
                            ┌────────────────────────────────────────────┐
[Event day, T-0]            │  11 On-day: Onepot filter → final dock →  │
                            │     submit at 7 pm + demo                 │
                            └────────────────────────────────────────────┘
                                                       ▲
[anytime]   ┌────────────────────────┐                 │
            │ 1  Email organizers    │ ────────────────┘
            │   (Tier-1 unblocker)   │   (provides Onepot access info)
            └────────────────────────┘
```

**Hard sequencing:**
- Task 0 must complete before any other (env distribution).
- Task 1 can run in parallel with everything else, but its result (Onepot access) is needed for Task 11.
- Tasks 2–9 can all run in parallel after Task 0.
- Task 10 needs Tasks 2, 4, 5, 6, 8 to have produced outputs.
- Task 11 is event-day execution.

**Convergence meeting at T-12h** (e.g., May 8 evening): all task owners post results to `dashboard/LIVE_TRACKER.md`; team picks the final 4 from the consensus list.

---

## 5. Compute budget plan

| Phase | GPU-hours used | % of budget |
|---|---:|---:|
| Tasks 2 + 3 + 4 (consensus signals on full pool) | 16 | 3% |
| Task 5 (MMGBSA on top 50) | 3 | 0.6% |
| Task 6 (selectivity dock) | 5 | 1% |
| Task 7 (generative scale) | 30 | 6% |
| Task 8 (FEP on 8 picks) | 40 | 8% |
| **Total committed** | **~95** | **19%** |
| Headroom for parameter sweeps + redo + on-day reactive | ~405 | 81% |

Each person carrying ~50 GPU-hours has plenty of slack to:
- Increase exhaustiveness on their docking task (8 → 32 = 4× more accurate)
- Run alternative seeds / models / ensembles
- Try parameter variations of their own design

---

## 6. Risk register

| Risk | Probability | Mitigation | Owner |
|---|:---:|---|---|
| **Onepot library access not delivered until 2 pm** | High | Task 1: email organizers now; have backup of submitting our pre-validated Tier-A even if not Onepot-confirmed (with caveat in slide) | Task-1 owner |
| **All 4 picks turn out NOT in onepot library** | Medium | Tier-A list of 40 gives ~10× redundancy; on-day filter will surface ~5–10 in-library | Task-10 owner |
| **CNN pose run-to-run variance reshuffles Tier-A** | Confirmed (we observed) | Task 2: multi-seed averaging is the explicit fix | Task-2 owner |
| **Boltz / MMGBSA / FEP disagree on top picks** | Medium | Task 10 consensus rule weights agreement across methods; disagreement flags compound for closer manual look | Task-10 owner |
| **Demo too long / too dense / runs over** | Medium | Task 9: dry-run at T-12h; cap at 4 min; one slide per pick | Task-9 owner |
| **Onepot synthesis fails on winning compound** | Low (in-event), high post-event | Bias picks toward simple chemistry (≤ 4 retrosynthetic disconnections from onepot's 7 reactions) | Task-10 owner |
| **Team member drops out / hardware fails** | Low | Tasks have no within-task dependencies; redistribute among owners | Coordinator |
| **muni.bio is required and we haven't onboarded** | Medium | Task 1 confirms; if required, register early with all members | Task-1 owner |
| **Discovered prior art that invalidates a pick** | Low | Tanimoto < 0.85 hard filter already applied; manual re-check at T-12h | Task-10 owner |

---

## 7. Final 4-pick selection criteria (locked-in rule for Task 10)

A compound makes the **on-day final 4** if and only if:

**Hard requirements (all must pass):**
1. Compound is in onepot's 3.4B library (on-day Onepot-membership check)
2. Tanimoto < 0.85 to all 2 274 known compounds
3. Tier-A on multi-seed GNINA (CNN pose ≥ 0.5 averaged across ≥ 5 seeds, CNN pKd ≥ 4.5)
4. QSAR pKd ≥ 4.0
5. PAINS-clean (Baell 2010 catalog)

**Soft signals (use to break ties + rank):**
6. Boltz-2 prob_binder ≥ 0.4 AND ipTM ≥ 0.65
7. MMGBSA ΔG ≤ –20 kcal/mol (after fix)
8. FEP relative ΔΔG within ±2 kcal/mol of best-in-class (only for top 8 candidates)
9. Selectivity: docked pose contacts ≥ 2 of {G/D177, R174, M181, T183}
10. Selectivity-dock: scores ≥ 1 kcal/mol weaker against ≥ 1 T-box paralog

**Diversity rule (the 4 must collectively):**
- Span ≥ 2 distinct chemotypes (e.g., quinazolinone-triazole vs pyrimidobicyclic)
- Span ≥ 2 binding sites (F + A) IF site-A picks survive Tier-A
- Cover the predicted-Kd range from sub-µM (best signal) to ~µM (insurance against over-prediction)

**Tiebreaker:** prefer compounds with retrosynthesis that decomposes into ≤ 4 of onepot's 7 supported reactions (amide coupling, Suzuki, Buchwald, urea, thiourea, N-alkylation, O-alkylation).

---

## 8. On-day timeline (May 9, 2026)

| Time | Action | Owner | Backup |
|---|---|---|---|
| 1:00 pm | Doors open. Team arrives, checks in, locates muni.bio access + Onepot interface | Coordinator | — |
| 1:30 pm | Announcements. Submit `organizer_questions.md` items in person if not yet answered | Coordinator | — |
| 2:00 pm | **Hacking begins.** Spin up Onepot membership filter on Tier-A list of 40 → produce `data/onday_filtered.csv` (~5–10 survivors expected) | Library-lookup owner | Coordinator |
| 2:30 pm | Run multi-seed GNINA at site F + A on Onepot-filtered set (parallel: 1 person per site) | GNINA owners (2) | — |
| 3:00 pm | Run Boltz-2 on Onepot-filtered set (~5 min per compound on A100) | Boltz owner | — |
| 4:00 pm | Manual chemistry curation: each chemist reviews top 10 by consensus rank, flags concerns | Chemists (2) | — |
| 5:00 pm | Run anchor-contact analysis on top 10; build per-pick rationale paragraphs | Rationale owner | — |
| 5:30 pm | Convergence meeting: team discusses, picks final 4 + ranking | All | — |
| 6:00 pm | **LOCK.** Final 4 SMILES into submission template; build slide deck final state with poses + numbers | Slides owner + presenter | — |
| 6:30 pm | Dry-run demo (1× through, time it, fix obvious issues) | Presenter | — |
| 6:45 pm | Submission verification: SMILES validity, in-Onepot, PAINS-clean, properties pasted | Verifier | — |
| 7:00 pm | **SUBMIT + DEMO.** | Presenter | Coordinator |
| 7:30 pm | Judging. Stand by for Q&A. | Presenter + chemists | — |

---

## 9. Roles (positions, not names)

The plan defines 5 functional roles. The **assignment** of names to positions happens in `dashboard/MEMBERS.md` (currently empty — fill it in once the team is identified).

1. **Coordinator (1 person)** — Owns the LIVE_TRACKER.md, runs the convergence meeting, manages risk register. Doesn't run compute.
2. **GPU-compute owners (4 people)** — Each owns 1–2 of {Tasks 2, 4, 5, 7, 8}. Runs on their A100. Posts results to LIVE_TRACKER.md.
3. **CPU-compute owner (1 person)** — Owns Task 3 + 6 (CPU-bound docking). Can be the same person as a chemist if they have basic conda skills.
4. **Chemists (2 people)** — Own the manual curation step at T-12h and 4 pm on event day. Don't necessarily run compute. Read the consensus rankings, flag chemistry concerns.
5. **Slides + presenter (2 people)** — Own Tasks 9, 11. One is the demo presenter at 7 pm. The other is the SMILES/onepot/PAINS verifier.

(That's 1 + 4 + 1 + 2 + 2 = **10 people**.)

If the team has fewer than 10, merge roles in this priority order: chemist 2 → coordinator → CPU owner → presenter helper → GPU owner 4.

---

## 10. How to use this repo

```bash
# One-time setup per team member (after Task 0 produces the env tarball):
# 1. Clone the repo
git clone <REPO_URL_TBD> ~/Hackathon-TBXT
cd ~/Hackathon-TBXT

# 2. Download the env bundle from Drive
wget <DRIVE_LINK_TBD> -O tbxt_env.tar.gz
mkdir -p ~/miniconda3/envs/tbxt
tar -xzf tbxt_env.tar.gz -C ~/miniconda3/envs/tbxt
source ~/miniconda3/envs/tbxt/bin/activate
conda-unpack

# 3. Verify
bash scripts/team/setup_check.sh
# Expected: "all 12 checks passed"

# 4. Find your task in dashboard/MEMBERS.md, then:
cat dashboard/<NN>_<your_task>.md
# Follow the "How to run" section verbatim.

# 5. Post your result in dashboard/LIVE_TRACKER.md when done.
```

---

## 11. Convergence rule (when in doubt, do this)

Whenever a decision arises that isn't covered by this plan:

1. **Default to Tier 1.** Don't sacrifice the judging prize for a Tier-2 long shot.
2. **Default to consensus.** A compound favored by 4 of 5 signals beats one favored by 1 signal at much higher score.
3. **Default to boring + tractable.** Per `~/Hackathon/docs/HACKATHON_LEARNINGS.md` § 4: "the simpler, calibrated, less-aggressive model wins on full evaluation."
4. **Default to lock at 6:00 pm.** No new code, no new ideas, only verification.
5. **When in real doubt: post the decision to LIVE_TRACKER.md and tag the coordinator.**

---

## 12. What success looks like

- 7:00 pm May 9: 4 ranked SMILES submitted, demo delivered, all team members on-site or remote-coordinated.
- 7:30 pm May 9: At least 1 of our 4 picks is judged "scientifically credible" and chemically tractable enough to advance to onepot synthesis.
- Post-event: At least 1 of our 4 binds at ≤ 5 µM in CF Labs SPR.

**At minimum:** Tier-1 prize won.
**Aspirationally:** Tier-2 prize on at least 1 compound.

---

## 13. Files referenced from this plan

```
TEAM_HANDOFF.md                         (this file — winning plan)
PROGRESS.md                             (work log + status detail)
STRATEGIES.md                           (strategy library reference)
dashboard/
├── MEMBERS.md                          (assignment matrix — fill in)
├── LIVE_TRACKER.md                     (shared status board)
├── 00_setup.md                         (env distribution recipe)
├── 01_email_organizers.md              (Tier-1 unblocker)
├── 02_gnina_multiseed.md               (CNN pose noise reduction)
├── 03_site_A_pool.md                   (site diversification)
├── 04_boltz_full_pool.md               (independent Kd signal)
├── 05_mmgbsa_fix.md                    (6th orthogonal signal)
├── 06_selectivity_dock.md              (vs T-box paralogs)
├── 07_generative_pocket2mol.md         (pocket-conditioned generative)
├── 08_fep_top_picks.md                 (alchemical relative ΔG)
├── 09_pose_renders.md                  (slide assets + dry-run)
├── 10_consensus_aggregation.md         (final 4-pick selection)
└── 11_on_day_playbook.md               (May 9 execution)
data/tier_a/tier_a_candidates.csv       (40 current Tier-A picks)
data/tier_a/all_signals.csv             (every compound × every signal)
data/snapshots/T-0/                     (frozen pre-event state)
organizer_questions.md                  (email body for Task 1)
```
