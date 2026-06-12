# Team kickoff email

**Subject:** TBXT Hackathon — production run complete; your role May 9

---

Team,

Big update: I ran the **full end-to-end production pipeline** on my GPU last night. All 6 signals computed, top 100 candidates ranked, final 4 picks locked. **Your job is now validation + on-day execution**, not running tasks from scratch.

## What's already done (committed to TBXT branch, commit `8de7a3b`)

| Artifact | Location |
|---|---|
| Submission narrative | `TBXT/report/SUBMISSION.md` |
| Top 100 ranked candidates (with all 6 signals) | `TBXT/report/top_100_consensus.csv` |
| Final 4 picks + rationale | `TBXT/report/final_4_picks.csv` |
| Pose renders (2D + 3D, 8 PNGs) | `TBXT/data/task9/trial1/renders/` |
| Per-task JSON reports | `TBXT/report/task<N>_trial1.json` |

## Final 4 picks (composite-ordered)

1. **gen_0025** — novel sulfonamide; Boltz prob_binder 0.61, MMGBSA -2.63 kcal/mol
2. **gen_0007** — novel triazolopyridazinone; **MMGBSA -7.67, FEP ΔΔG -0.81 (beats reference)**
3. **Z795991852_analog_0087** — quinazolinone-chromene-ether; Boltz Kd 1.87 µM, MMGBSA -4.40
4. **Z795991852_analog_0001** — quinazolinone-chromene-amide; selectivity 0.77 (highest)

All Tier-A on multi-mode docking; pairwise Tanimoto < 0.55 (proper diversity); Boltz prob_binder 0.52-0.61 (binder zone); MMGBSA ΔE all favorable.

## What you need to do

**Step 1 — Setup (any time today):**

```bash
git clone -b TBXT <PUBLIC_REPO_URL>
cd Hackathon
bash TBXT/setup.sh
bash TBXT/smoke_test.sh
```

`setup.sh` auto-detects whether your machine has a GPU and installs the right torch wheels. ~15 min first time.

**Step 2 — Read the submission and form an opinion (~30 min):**

```bash
cat TBXT/report/SUBMISSION.md
```

If anything looks wrong — picks, rationale, scores — flag it in chat. We have 24h to redo.

**Step 3 — Pick ONE of these to validate redundantly (your choice):**

| Member | Suggested redundancy task | Why |
|---|---|---|
| M2 | rerun task2 multi-seed GNINA, exh 16 (~12 h GPU) | confirms multi-mode picks are stable |
| M3 | rerun task4 Boltz on the 4 picks at 5 samples × 300 steps (~30 min GPU) | tightens prob_binder confidence |
| M4 | sanity-check QSAR predictions vs CF Labs hits | validates the only target-trained signal |
| M5 | run task7 generative expansion to 200+ on Onepot library (Sat morning) | hedges against Onepot library miss |
| M6 | rerun task8 FEP at 12 λ × 5 ns instead of MMGBSA-style (~2 h GPU) | proper alchemical FEP for top 4 |

These are nice-to-have. The submission can ship as-is if no one has GPU time.

## On-day (Sat May 9)

**Doors at 1 pm. Submission portal closes ~6 pm.**

1. **Morning:** organizers reveal Onepot library (~10:00 am if past hackathons are a guide)
2. **Filter:** `python TBXT/experiment_scripts/onepot_filter.py --top500 ... --onepot ...`
3. **Lock final 4:** if all 4 picks survive Onepot membership, ship them. If not, swap from top 100.
4. **Submit:** SMILES + rationale (deck content already in SUBMISSION.md per-pick rationale)

**Drive for any new JSON uploads:** `<paste folder link here>`
**Chat:** `<paste Slack/WhatsApp link here>`

## Big picture

We're optimizing for the **judging prize** ($250 muni credits, scored on rationale + tractability + judgment). The experimental-tier prize ($100K, ≤ 5 µM SPR) is unlikely without optimization rounds, but the multi-signal consensus pipeline is judges-defensible — every pick has 5/6 favorable signals.

Read `TBXT/TEAM_PLAYBOOK_6.md` for the full pre-event plan and `TBXT/PROGRESS.md` Phase 8 for the production run details.

— TBXT Hackathon Team