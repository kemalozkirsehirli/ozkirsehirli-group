I've re-read the organizer materials end-to-end. **Honest audit follows. There are real misalignments I want you to see before we burn HPC hours.**

---

## ✅ What we're aligned on

| Organizer ask                                                   | Our state                                                        |
| --------------------------------------------------------------- | ---------------------------------------------------------------- |
| 4 ranked SMILES + rationale                                     | `final_4_picks.csv` ✓                                            |
| Predicted binding site labeled                                  | All site F per TEP labels ✓                                      |
| Computed evidence (multi-signal)                                | 6 signals (Vina + GNINA + QSAR + Boltz + MMGBSA + selectivity) ✓ |
| Chordoma chemistry rule (MW ≤ 600, LogP ≤ 6, HBD ≤ 6, HBA ≤ 12) | All 4 picks pass ✓                                               |
| Naar dataset duplication avoided                                | Tanimoto < 0.85 to all 2274 known ✓                              |
| PAINS-clean                                                     | All 4 picks PAINS-clean per RDKit Baell catalog ✓                |
| Method rigor (judging prize)                                    | Strong — 6-signal consensus, explicit diversity rules ✓          |

---

## 🚨 What we are MISALIGNED on (high-stakes)

### 1. Onepot library membership — **submission validity risk**

Organizer text is unambiguous: > "Submissions must be restricted to compounds within onepot's 3.4B compound library."

Reality of our pool:
- 503 Z-prefix analogs are *enumerated by us* from Z795991852 etc., **not from onepot**. Z* in the Naar dataset are Enamine REAL — onepot is a *different* enumeration.
- 67 gen_NNNN are **BRICS-recombinant novel compounds**. By construction, novelty implies they're not in any commercial catalog, including onepot.

**Most likely outcome on-day:** Zero or very few of our top 500 compounds are in onepot's 3.4B set. We get an invalid submission.


**This makes our top-500 buffer load-bearing — and we have *no evidence* the buffer will catch ≥ 4 onepot members.** Running 5 variants on the same pool doesn't fix this.


Potential Solutions:

1. Check if openpot.ai (https://www.onepot.ai/) have public access (even partially) just to see what is there workflow science-wise and implementation, and our codebase will connect or will adapt quickly to use onepot.ai.

2. See what are scientific white paper/literature/research of openpot.ai, if we understand what are scientific principles onepot.ai is based on we can either build an independent, terms-compliant workflow from public literature or adjacent parallel implementation based on same scientific principles (see https://www.onepot.ai/research) 


### 2. Onepot 7-reaction synthesis filter — **chemistry gate**

Onepot = 7 reactions: amide coupling, Suzuki, Buchwald, urea, thiourea, N-alkylation, O-alkylation. **Sulfonamide formation is NOT in the list** — but our pick #2 `gen_0025` has a sulfonamide linker (`NS(=O)(=O)`). It will likely fail onepot synthesis check.

We haven't audited any of our 4 picks (or 100, or 500) for retrosynthesizability under these 7 reactions. This is a real exclusion risk.

Potential Solutions:

Same as above, see what are scientific white paper/literature/research of openpot.ai for for retrosynthesizability, if we understand what are scientific principles onepot.ai is based on we can either build an independent, terms-compliant workflow from public literature or adjacent parallel implementation based on same scientific principles (see https://www.onepot.ai/research)

The fundamental chemistry science and principle for retrosynthesizability must exactly same, just the implementation might be different, we use the same principle for retrosynthesizability on which the provided platform build their workflow and even same data if publically available


 

### 3. Site diversity — **judging prize "good prioritization" criterion**

ABOUT.md §"Decisions to make" recommends: *"2× site F (different chemotypes), 1× site A, 1× wildcard"*. **All 4 of our picks are at site F.** We deferred task3 (site A docking) for time. Judges will note: "All 4 picks single site = single-bet hypothesis = poor prioritization judgment".

Potential Solutions

1. More variations

### 4. muni.bio + Rowan platform engagement — **political/scoring signal**

The hackathon is hosted on muni.bio. The $250 prize is in muni credits. Rowan tools are explicitly offered. **We have used neither.** Judges likely value teams that engaged with the host platform. We've built something fully off-platform.


Potential solution

1. check the available workflow publically available for easier adaptablility with codebase

### 5. Slide deck / live demo — **infrastructure surprise**

Schedule: "7:00 pm final submissions + demos · 7:30 pm judging". We have `SUBMISSION.md` (text) but no slide deck. **We don't know yet whether demos are slides, oral, lightning, or interactive.** Format unknown = preparation risk.

### 6. Submission portal format — **unknown until 1:30 pm**

ABOUT.md flags this as still open. Whether it's a Google Form, a portal, an email, or an in-person form will be revealed at 1:30 pm announcements. We've prepared content but haven't planned a submission contingency for any format.

### 7. Onepot library access mechanism — **unknown infrastructure**

ABOUT.md: *"Onepot CORE has no public API or download — access is contract-restricted. The organizer will provide a search/lookup mechanism on the day."*

Our `onepot_filter.py` assumes a CSV input. **We don't know if onepot's lookup will give us a downloadable list, a SMILES-by-SMILES lookup API, a structure-similarity service, or something else.** Plan accordingly: build resilience for all three formats, not just CSV.

---

## 🤔 Honest verdict

We've done **excellent science** but we're optimizing the **wrong quadrant**. The real gating question on-day isn't *"are our consensus signals robust"* — it's *"are our compounds even valid submissions"*. The variant strategy I proposed adds rigor but doesn't help if our pool fails the validity gate.

The judging prize ($250) values **rationale, tractability, judgment**. The experimental prize ($100K-300K) values **affinity at lab scale**. Both are gated on onepot validity.

---

## 🎯 What I'd ACTUALLY use 5 L40S for instead of variants

Re-prioritized batch 1 (in order of de-risking, not novelty):

| #   | Job                                                                                                                                                                                                                                        | Why                                                    | Compute               |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------ | --------------------: |
| 1   | **Run task3 (site A docking) on full 570** + add ≥ 1 site-A compound to the final 4. Address site diversity.                                                                                                                               | Direct judging-prize impact.                           | ~3 GPU-h              |
| 2   | **Synthesizability audit** — score every compound in top 100 against the 7 onepot reactions (retrosynthetic Buchwald/Suzuki/amide-coupling/etc. matching, e.g. via AiZynthFinder or RDKit reaction templates). Drop unsynthesizable picks. | Gates whether our submission is valid at all.          | ~2 CPU-h              |
| 3   | **Naar near-duplicate audit** — recompute Tanimoto vs the FULL Naar set (2274) for top 100, flag ≥ 0.85, demote to backup.                                                                                                                 | Direct exclusion risk.                                 | <1 CPU-h              |
| 4   | **Onepot-aware regeneration** — task7-v2: REINVENT (or template-based generation) constrained to use ONLY the 7 onepot reactions on the parent scaffolds. Generates 200+ new compounds biased toward onepot membership.                    | Most-likely fix for the "no compounds in onepot" risk. | ~5 GPU-h              |
| 5   | **muni.bio + Rowan onboarding + re-rank** — sign up; if they expose a docking/co-folding/property service, run our top 30 through it; cite results in submission. Even if scientifically marginal, it shows engagement.                    | Political/scoring signal.                              | ~1 h human + ~2 GPU-h |
| 6   | **Slide deck draft** (assume slide-based demo) — 5–6 slides: target → method → top 4 → rationale per pick → future.                                                                                                                        | Infrastructure prep.                                   | ~2 h human            |
| 7   | **Variant 1 (baseline_full) ONLY** from the original variant plan, deferring variants 2-5 until validity is fixed.                                                                                                                         | Method rigor.                                          | ~25 GPU-h             |

This uses ~38 GPU-h total + ~3 human-hours, all directly de-risking the submission.

---

## My recommendation

**Pause batch 1 (variant 1-5).** Their value is *method rigor* — but we don't have a *valid submission* yet. Rigor on an invalid pool is wasted.

Run the 7 jobs above instead. They directly address every misalignment I flagged.

If after these we're still ahead of schedule, *then* run variants 2-5 for additional rigor.

Want me to draft the new batch 1 around these 7 jobs?



● Re-read of MISALLIGNMENT_FIX.md vs current state

  ┌─────┬────────────────────────┬───────────────────────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │  #  │ Original misalignment  │      Status now       │                                                                                  Evidence                                                                                  │
  ├─────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 1   │ Onepot CORE membership │ ⚠ MITIGATED, not      │ Read onepot's preprint (arXiv:2601.12603); built a real retrosynth audit on the 7 reactions. 460/570 of pool reach ≥ 0.95; 2 of 4 final picks reach 1.0; the other 2 reach │
  │     │                        │ solved                │  0.74. CORE membership only verifiable on May 9 morning.                                                                                                                   │
  ├─────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 2   │ 7-reaction synthesis   │ ⚠ ADDRESSED, advisory │ gen_0025 (sulfonamide) is now a NOT a strict-onepot pick — kept it because Boltz prob_binder = 0.61 dominates other signals, and the rest of the molecule disconnects via  │
  │     │ filter                 │                       │ the 7. Documented limitation in SUBMISSION.md.                                                                                                                             │
  ├─────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 3   │ Site diversity         │ ✅ FIXED              │ task3 done. Pick 1 = Z795991852_analog_0021 at site A, predicted Kd 0.28 µM, reach 1.0.                                                                                    │
  ├─────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 4   │ muni.bio + Rowan       │ ⚠ DEFERRED to on-day  │ muni.bio site is auth-walled (403). Rowan has free credits + RBFE + Python API, but recon says use it on-day. Playbook covers signup steps.                                │
  │     │ engagement             │                       │                                                                                                                                                                            │
  ├─────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 5   │ Slide deck             │ ✅ DONE               │ report/SLIDES.md 10-slide Marp-compatible draft.                                                                                                                           │
  ├─────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 6   │ Submission portal      │ ⚠ Cannot resolve      │ Playbook covers 4 alternative paths.                                                                                                                                       │
  │     │ format                 │ pre-event             │                                                                                                                                                                            │
  ├─────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 7   │ Onepot lookup          │ ⚠ Cannot resolve      │ Playbook covers 4 alternative paths.                                                                                                                                       │
  │     │ mechanism              │ pre-event             │                                                                                                                                                                            │
  └─────┴────────────────────────┴───────────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

  ---
  Honest current state

  The science is in good shape. The validity gate is the only material risk.

  Six of seven misalignments are now either fixed or have explicit playbook contingencies. The remaining open items (#6, #7) are not solvable until the organizer-side announcements at 1:30 pm. We've prepared resilient handlers for the
  4 most-likely formats.

  Submission package locked:
  - 4 ranked SMILES (3F + 1A, 2 chemotypes, all Tier-A)
  - SUBMISSION.md narrative + SLIDES.md deck
  - Pose renders (8 PNGs)
  - Top-100 backup CSV with 5 signals + reachability scores per compound
  - Onepot-friendliness signal built into both pick selection AND backup ordering

  ---
  Win-chance estimate (honest)

  ┌─────────────────────────────────────┬────────┬─────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │             Prize tier              │ Reward │ Probability │                                                                                  Why                                                                                  │
  ├─────────────────────────────────────┼────────┼─────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ Hackathon judging prize ($250 muni  │ $250   │      55–70% │ Strong rigor + multi-signal + site diversity + onepot-aware retrosynth = strong defensibility. Risk: someone shows up with ML-generated compounds that look prettier. │
  │ credits)                            │        │             │                                                                                                                                                                       │
  ├─────────────────────────────────────┼────────┼─────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ Experimental ≤ 5 µM tier ($100K,    │ $100K  │       8–18% │ Best free-energy methods over-predict by 6–25× at µM. Realistic SPR outcome: 1–2 picks bind in 20–60 µM range. Need luck (or a hidden good pick) for ≤ 5 µM. The "max │
  │ max 3 awards)                       │        │             │  3 awards" cap means there's slack — if 2 teams already win, still possible.                                                                                          │
  ├─────────────────────────────────────┼────────┼─────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ Experimental ≤ 300 nM tier ($150K,  │ $150K  │        1–3% │ Would require ~300× improvement over best disclosed fragment. Not realistic without lab optimization rounds; won't happen from in-silico picks alone.                 │
  │ max 2 awards)                       │        │             │                                                                                                                                                                       │
  ├─────────────────────────────────────┼────────┼─────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ Total expected value                │ —      │           — │ E[$] ≈ 0.6 × 250 + 0.13 × 100K + 0.02 × 150K ≈ $16K dominated by the experimental tier if it materializes                                                             │
  └─────────────────────────────────────┴────────┴─────────────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

  The honest read: we're playing for the judging prize as the primary ($250 + visibility), with non-trivial lottery odds on the experimental tier.

  The "experimental ≤ 5 µM" odds depend HEAVILY on whether the picks are actually onepot-synthesizable AND whether organizers select us for synthesis. Your validity-de-risking instinct in MISALLIGNMENT_FIX is correct — improving onepot
   reachability is the highest-leverage remaining work.

  ---
  What's done, what's left

  Done (locked in)

  - Full pre-event pipeline: tasks 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 all OK
  - 6 orthogonal signals integrated for the 4 final picks
  - Site A docking complete (570 cmpds, 164 Tier-A at site A)
  - Onepot retrosynth reachability audit (full 570 pool)
  - HuggingFace dataset distribution (env + data + supplement live)
  - Drive fallback (setup.sh) — quota issue handled with detection
  - Member onboarding (setup_hf.sh smoke-tested on fresh dir)
  - Submission deliverables: SUBMISSION.md, SLIDES.md, final_4_picks.csv, top_100_consensus.csv, 8 PNG renders
  - On-day playbook with 4 alternate onepot-filter paths, sanity checks, Q&A prep

  Left (decisions today, action tomorrow)

  ┌────────────────────────┬──────────────────────────────┬────────────────────────────────┐
  │         Action         │            Window            │        Decision needed         │
  ├────────────────────────┼──────────────────────────────┼────────────────────────────────┤
  │ Overnight HPC variants │ tonight 6 pm → tomorrow 9 am │ what to run (this discussion)  │
  ├────────────────────────┼──────────────────────────────┼────────────────────────────────┤
  │ 8 am pre-flight        │ T-0 morning                  │ mechanical                     │
  ├────────────────────────┼──────────────────────────────┼────────────────────────────────┤
  │ 1:30 pm onepot lookup  │ T-0 afternoon                │ depends on organizer mechanism │
  ├────────────────────────┼──────────────────────────────┼────────────────────────────────┤
  │ muni / Rowan signup    │ T-0 afternoon                │ only if credits given out      │
  ├────────────────────────┼──────────────────────────────┼────────────────────────────────┤
  │ 5:30 pm hard lock      │ T-0 evening                  │ mechanical                     │
  ├────────────────────────┼──────────────────────────────┼────────────────────────────────┤
  │ 7 pm submit + demo     │ T-0 evening                  │ mechanical                     │
  └────────────────────────┴──────────────────────────────┴────────────────────────────────┘

  ---
  Surprises we may encounter

  ┌─────┬──────────────────────────────────────────────────────────────────┬──────────────────────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │  #  │                             Surprise                             │        Impact        │                                                             Mitigation                                                             │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 1   │ Onepot lookup excludes ALL of our 4 picks                        │ High — invalid       │ Top-100 CSV + 460-cmpd reach-≥0.95 pool to swap in. If still none, pivot to Plan B: cite reachability score as evidence of         │
  │     │                                                                  │ submission           │ plausible synthesizability and ask organizers to consider analogues                                                                │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 2   │ Submission demands sub-format we didn't anticipate (e.g.,        │ Medium               │ Have RDKit-derived InChI + IUPAC pre-computed for top 4; can generate on-the-fly if time permits                                   │
  │     │ specific InChI, IUPAC name)                                      │                      │                                                                                                                                    │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 3   │ Demo is interactive notebook, not slides                         │ Medium               │ We have full code in repo + JSONs in report/; can demo from terminal in <2 min                                                     │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 4   │ Time pressure compresses the 5-hr window (e.g., onepot mechanism │ Medium               │ Lock at 5:30 pm regardless of new info; submission with 4 confirmed picks > submission with 4 picks improved at 6:55 pm            │
  │     │  arrives late)                                                   │                      │                                                                                                                                    │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 5   │ Wi-Fi at venue is throttled / fails                              │ High                 │ Phone hotspot; Tailscale is configured to pre-stage what we need; printed paper backup of final_4_picks.csv                        │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 6   │ Rowan / muni credits aren't actually distributed                 │ Low                  │ Plan doesn't depend on them; "engagement" signal is nice-to-have not essential                                                     │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 7   │ Z795991852_analog_0021 has weird Naar similarity (parent =       │ Medium-High          │ Verify Tanimoto < 0.85 of the analog vs ALL Naar compounds before submission. If borderline, swap for top reach-1.0 site-A         │
  │     │ Z795991852, a Naar compound)                                     │                      │ alternative                                                                                                                        │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 8   │ Judges flag "where's the muni.bio engagement?"                   │ Medium               │ If asked, sign up live during Q&A; document in deck "we tried but couldn't access pre-event"                                       │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 9   │ A team already submitted Z795991852 itself or close analog       │ High                 │ Our top-100 has fallbacks not derived from Z795991852 (e.g., gen_NNNN, FM-derivatives)                                             │
  ├─────┼──────────────────────────────────────────────────────────────────┼──────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 10  │ Unrelated organizational issue (location change, schedule shift) │ Low                  │ Check Luma + email morning of                                                                                                      │
  └─────┴──────────────────────────────────────────────────────────────────┴──────────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

  ---
  Overnight HPC plan — 5–10 parallel jobs

  Constraints:
  - 5 L40S parallel jobs, each 1 GPU
  - ~16 hours wall budget (May 8 evening 6 pm → May 9 10 am)
  - L40S throughput ~1.5–2× RTX 5050 for our workloads

  Goals (in priority order):
  1. De-risk onepot validity (single biggest remaining gap)
  2. Strengthen rigor for judging prize
  3. Improve odds at experimental ≤ 5 µM tier
  4. Generate variant-convergence audit (defensible "robust pick" argument)

  Recommended 5-job overnight batch

  ┌──────┬─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┬───────────┬───────────────────────────────────┬──────────────┐
  │ Slot │                                                                           Variant                                                                           │ What it   │           GPU-h on L40S           │    Goal      │
  │      │                                                                                                                                                             │   does    │                                   │  alignment   │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼───────────┼───────────────────────────────────┼──────────────┤
  │    1 │ onepot_friendly_gen.sh — generate 500+ NEW compounds via REINVENT constrained to the 7 onepot reactions on Enamine BBs subset, score with our pipeline,     │ ~12 h     │ (1) onepot validity — single best │              │
  │      │ surface top 50 onepot-friendly site-F + site-A binders                                                                                                      │           │                              move │              │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼───────────┼───────────────────────────────────┼──────────────┤
  │    2 │ full_pool_boltz.sh — Boltz-2 on FULL 570 (currently only top 30) at 3 samples × 200 sampling × 3 recycling. Adds prob_binder + Kd to 540 more compounds     │ ~16 h     │       (2) rigor; (3) lottery odds │              │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼───────────┼───────────────────────────────────┼──────────────┤
  │    3 │ receptor_ensemble.sh — task2 multi-seed GNINA on 3 receptor conformations (6F59 apo + 6F58 WT + AlphaFold2 relaxed). Min-vina + mean-CNN consensus          │ ~12 h     │        (2) rigor; (4) convergence │              │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼───────────┼───────────────────────────────────┼──────────────┤
  │    4 │ alchemical_fep.sh — proper alchemical FEP via OpenFE on top 8 picks (currently MMGBSA-style ΔΔG). 12 λ × 5 ns (free)                                        │ ~10 h     │       (2) rigor; (3) lottery odds │              │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼───────────┼───────────────────────────────────┼──────────────┤
  │    5 │ site_g_dock.sh — task2-style GNINA on full 570 against site G (the third TEP-recommended pocket). Adds 3rd-site backup picks if needed                      │ ~6 h      │ (2) rigor; (4) wildcard slot for  │              │
  │      │                                                                                                                                                             │           │                         diversity │              │
  └──────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴───────────┴───────────────────────────────────┴──────────────┘

  Total ~56 GPU-h ÷ 5 GPUs = ~11 wall-clock hours. Comfortably finishes by 6 am May 9.

  Optional batch-2 (if compute headroom remains after batch 1, post-midnight launch)

  ┌──────┬─────────────────────────────────────────────────────────────────────────────────────────────┬───────────────────────────────────────┬──────────────────────────────────────────────────┐
  │ Slot │                                           Variant                                           │                 GPU-h                 │                       Why                        │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────┼───────────────────────────────────────┼──────────────────────────────────────────────────┤
  │    6 │ mmgbsa_full_pool.sh — MMGBSA on full 570 (vs current top 30)                                │ ~25 h on 1 GPU; shard 2× → ~12 h each │ More free-energy data per compound for consensus │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────┼───────────────────────────────────────┼──────────────────────────────────────────────────┤
  │    7 │ generative_v2.sh — pharmacophore-guided REINVENT on top-50-pose-derived pharmacophore       │                                  ~6 h │ Novelty boost, onepot-aware                      │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────┼───────────────────────────────────────┼──────────────────────────────────────────────────┤
  │    8 │ taskA_multi_seed.sh — multi-seed at site A (currently single-seed), tightens site-A pick    │                                  ~8 h │ Defensible site-A claim                          │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────┼───────────────────────────────────────┼──────────────────────────────────────────────────┤
  │    9 │ paralog_dock.sh — real GNINA dock against TBR1 (6JG2), TBX2 (5HKR), TBX21 (1H6F) for top 30 │                                  ~5 h │ Real selectivity (not just sequence-aware)       │
  ├──────┼─────────────────────────────────────────────────────────────────────────────────────────────┼───────────────────────────────────────┼──────────────────────────────────────────────────┤
  │   10 │ muni_re_rank.sh — runs top 30 through muni.bio API (after on-day signup)                    │                               ~30 min │ Engagement signal                                │
  └──────┴─────────────────────────────────────────────────────────────────────────────────────────────┴───────────────────────────────────────┴──────────────────────────────────────────────────┘

  Critical: variant-convergence audit (CPU, runs after all variants finish)

  report/convergence_audit.csv:
    per-compound row, columns = [score in variant1, ..., score in variant10]
    surface "robust picks" = compounds in top 4 of ≥ 70% of variants

  This generates the strongest possible defensibility argument: "Our 4 picks survive across 5 distinct methodological perturbations." That's the kind of rigor a judging panel rewards.

  My recommendation

  Submit the 5 overnight jobs tonight by 7 pm. Slot 1 (onepot generation) is the single highest-impact job — even if it produces 50 new compounds with ANY onepot disconnection, we go into May 9 with a much larger validity buffer than
  today.

  Want me to write all 5 variant scripts now, with qsub-friendly env-var configurability so each job is bash variantN.sh regardless of scheduler?
