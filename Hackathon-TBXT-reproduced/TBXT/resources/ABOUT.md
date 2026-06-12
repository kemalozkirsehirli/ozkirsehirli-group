# About: TBXT Hit Identification Hackathon
Boston ·  May 9, 2026 · Pillar VC
Hosted by muni in collaboration with Rowan and onepot

> **Note on the playbook:** `HACKATHON_LEARNINGS.md` was written for tabular ML / leaderboard competitions. This event is a **structural-biology / cheminformatics hit-identification challenge** with a single judged submission and *no* live leaderboard. Translations of the playbook's lessons are noted in **Strategy decisions** below.

---

## Basics

- **Event:** TBXT Hit Identification Hackathon
- **Organizer:** muni, in collaboration with Rowan and onepot
- **Venue:** Pillar VC, Boston
- **Date:** 2026-05-09 (today is 2026-05-06, T-3 days)
- **Schedule (from luma):** 1:00 pm doors · 1:30 pm announcements · 2:00 pm team formation + hacking · 6:30 pm dinner · 7:00 pm final submissions + demos · 7:30 pm judging + wrap-up
- **Active hacking window:** ~5 hours (2:00 pm – 7:00 pm, with dinner break)
- **Format:** Single open-ended challenge — submit 4 ranked compounds + rationale
- **Team size:** Larger team (6–8 members). "Come solo or with a team" (luma) — no stated size cap.
- **Team members + roles:** Roles to assign on the day (see Strategy decisions). Individual member details deferred.
- **Team slot / ID:** TBD

## Where things live

- **Event landing page:** https://luma.com/n9hheb8j
- **TBXT Challenge experimental program (separate from hackathon):** https://tbxtchallenge.org/?utm_source=luma#prizes — note: this site describes the *broader* Chordoma Foundation experimental prize program (June 1 intent deadline, Sept 1 first batch). Hackathon winners feed into this pipeline.
- **Compound library (constraint):** https://www.onepot.ai/ — onepot's 3.4B compound library
- **Target UniProt:** https://www.uniprot.org/uniprotkb/O15178/entry#structure (TBXT, O15178, 435 aa)
- **TBXT TEP datasheet (read end-to-end before event):** https://www.thesgc.org/sites/default/files/2024-05/TBXT_TEP_datasheet_v1_0.pdf
- **TBXT–DNA structures:** PDB **6F58** (WT) · PDB **6F59** (G177D, *matches assay protein*) · https://www.rcsb.org/structure/6F59
- **Fragment-bound DNA-free crystals:** PDB **5QS9** (G177D, crystal form 1, sites A–E) · PDB **5QRM** onward (WT, crystal form 2, sites F, G, A')
- **SGC structural data hub:** https://tinyurl.com/bddybesb
- **Naar SMILES (prior-screened — avoid duplication):** https://docs.google.com/spreadsheets/d/1k-vcM_jVd1s_6W6u-ag2YQabGov_40oB/edit
- **Naar physics-based screen compounds:** https://zenodo.org/records/8212611
- **SGC TBXT paper (2025 Nat Commun):** https://www.nature.com/articles/s41467-025-56213-1
- **Submission portal:** TBD — luma describes "final submissions + demos at 7:00 pm" but no portal/form URL. Likely an in-person form provided at the event. Confirm at door.
- **Organizer contact (for experimental program, may apply to hackathon too):** tbxtchallenge@chordoma.org
- **muni platform:** https://muni.bio — "where molecules meet agents." Collaborative agentic scientific platform: run scientific models, orchestrate with agents, see results. Twitter @muni_bio. The $250 hackathon prize is in muni.bio credits.
- **Rowan platform:** https://rowansci.com — ML-powered computational chemistry (DFT, xTB, AIMNet2 ML potentials, automated workflows). 500 free credits + weekly top-ups for new accounts.

## The Target

- **Protein:** Human TBXT (Brachyury), T-box transcription factor
- **Length:** 435 aa
- **Domain of interest:** DNA-binding domain (DBD), residues 42–219 (N-terminal; C-terminus largely unstructured)
- **Disease relevance:** Driver of chordoma (rare bone cancer, no approved systemic therapy); aberrantly expressed in multiple cancers; historically undruggable like most TFs
- **TEP fragment screen:** 29 fragments across 6 binding sites (A, B, C, D, E in G177D crystal form 1; F, G, A' in WT crystal form 2). Fragment library = Diamond DSI-Poised. All fragment SMILES are in PDB entries 5QRF–5QSK (with prefixes F9000xxx, FM00xxxx, XSxxxxxx, UB000200, DA000167).

### G177D — this is rs2305089, a chordoma-associated common variant (NOT a custom mutation)

- Allele frequency 42% in general population; present in **>90% of Western chordoma cases**
- G→D adds a negative charge at the variant residue
- Reduces thermostability (~0.7 °C lower Tm), reduces dimerization, alters DNA binding
- **The CF Labs SPR assay uses biotinylated full-length G177D TBXT** (TBXTA-c027 construct from the TEP). So docking/scoring should target the G177D form.
- **Use 6F59 as the primary docking receptor** (G177D + DNA), or 5QS9 for the DNA-free G177D crystal form 1 (sites A–E).

### Pocket map (TEP) — these are the binding sites the screen identified

| Site | Crystal form | Key residues | Notes |
|---|---|---|---|
| **A** | Form 1 (G177D) | S89, P130, V173, S129, D120, R180, L91, V123, H125, H126 | Most fragments bound here. **Close to dimerization interface.** Disrupting could block palindromic-DNA binding. **TEP recommends.** |
| B | Form 1 | Q118, P117, N161 | Several fragments. |
| C | Form 1 | L163 | One fragment (5QRW location 2). |
| D | Form 1 | P111, P115, K114, G112 | One fragment (5QS0). |
| E | Form 1 | A120, A121, V123 | One fragment (5QRR). |
| **F** | Form 2 (WT) | **Y88, D177**, L42 | Pocket directly engages the variant residue. "Could disrupt downstream effector interactions; more tractable than competing with DNA binding." **TEP recommends.** Naar best binders all predicted at site F. |
| **G** | Form 2 (WT) | Y210, E48, E50, G81 | Promiscuous pocket on hinge of DNA-binding helix (2-fold symmetry). Many fragments bind here, but selectivity may be poor. |
| A' | Form 2 (WT) | (Neighboring site A in WT) | A few fragments. |

### Prior SPR — read this carefully

The Naar compounds were screened in TBXT SPR by both an external CRO (HDB) and CF Labs. Results diverged for several compounds:

| Compound | HDB Kd | CF Labs Kd | Predicted site |
|---|---|---|---|
| Z979336988 | 3 µM | 30 µM | F |
| Z795991852 | 10 µM | 10 µM | F |
| D203-0031 | 2 µM | 17 µM | F or G |

Implication: SPR is not reproducible across labs at the µM level (typical 3–10× spread). Judging is CF Labs SPR, so weight CF Labs values when calibrating expectations. Best in-class Naar binders are at **site F** — confirms F as the productive site.

### Affinity reality check

The strongest reported optimized fragment in the TEP achieved Kd = 80 µM (kinetic) / 104 µM (dose-response). To win:
- Hackathon judging prize: only requires good rationale, not high affinity
- Experimental 1 µM prize: ~20× improvement over best optimized fragment
- Experimental 300 nM prize: ~300× improvement over best optimized fragment

## Challenge

### Submission contents (as of luma + TBXT_Hackathon.md)

- **Team name**
- **4 ranked compounds (SMILES), rank order clearly indicated** — must be in onepot's 3.4B library
- **Predicted binding pocket / site** (use TEP labels: A, B, C, D, E, F, G, A')
- **Short rationale for the ranking**
- **Key computed evidence** (docking, MD, FEP, similarity, ML scores — whatever you used)
- **Relevant molecular properties**

### Design constraints (hard)

- Non-covalent, small molecule
- In onepot's 3.4B library
- Chordoma Foundation chemistry guidance:
  - LogP ≤ 6
  - HBD ≤ 6
  - HBA ≤ 12
  - MW ≤ 600

### Lead-like targets (preferred)

- 10–30 heavy atoms
- HBD + HBA ≤ 11
- cLogP / cLogD < 5
- < 5 ring systems
- ≤ 2 fused rings

### Avoid (PAINS-like / problematic motifs unless strongly justified)

- Acid halides, aldehydes, diazo groups, imines
- Polycyclic aromatics with > 2 fused benzene rings
- Long alkyl chains
- Highly reactive or problematic charged motifs

### Onepot synthesis filter (informs which chemistries to prefer)

Onepot's 3.4B-compound enumeration uses **7 reaction classes**: Amide coupling · Suzuki–Miyaura · Buchwald–Hartwig amination · Urea synthesis · Thiourea synthesis · N-Alkylation · O-Alkylation. Compounds requiring chemistry outside this set will fail synthesis. Bias the shortlist toward scaffolds whose retrosynthetic disconnections fall within these reactions. Synthesis turnaround = ~5–10 business days (post-event).

## Rules and constraints

- **Allowed tools:** No restrictions stated by organizers. Luma: "Teams will use muni, Rowan tools, onepot's 3.4B compound library, or their own workflows." External LLMs, paid APIs, commercial docking suites — assumed allowed unless told otherwise.
- **Prohibited (implicit):** Submitting compounds outside onepot's library; resubmitting compounds from the Naar dataset (treated as duplication, not novel)
- **Compute limits:** Not stated by organizers. Our setup: **local workstation + HPC with GPU** (enables docking, ML scoring, MD validation, possibly short FEP/binding-affinity passes). Plus muni.bio + Rowan credits if provided at the event.
- **Submission cadence:** Single submission of 4 compounds at 7:00 pm

## Judging

### 1. Hackathon judging prize — $250 muni credits

Judged on:
- **Scientific rationale and computational support** — plausible *why*; design choices supported by thoughtful work and interpretation, not a single score
- **Compound quality and tractability** — chemically sensible, no obvious liabilities, realistic to make and SPR-test
- **Hit identification judgment** — the 4-compound set reflects good prioritization and tradeoff-making, not volume / single-metric optimization

### 2. Experimental prize — up to $250K (downstream, via Chordoma Foundation pipeline)

Compounds that move forward are synthesized by onepot (if synthetically tractable), then assayed by CF Labs SPR (full-length G177D TBXT, two-fold six-point titration; hits < 5 µM confirmed twice more).

- **SPR protocol:** Biacore S200; biotinylated G177D TBXT (TBXTA-c027) on Series S SA sensor, ~1500 RU; running buffer 10 mM HEPES pH 7.5, 150 mM NaCl, 1 mM DTT, 1% DMSO
- 1 µM tier and 300 nM tier prizes available
- Awarded until 3 teams win any prize OR 2 teams win the 300 nM tier (whichever first)
- Winning structures vetted by an expert third-party chemist for drug-like properties + PAINS absence
- Note: the broader TBXT Challenge experimental program has its own deadlines (June 1 intent / Sept 1 first batch). Hackathon winners feed into this pipeline.

The compounds that win the *hackathon* and the compounds that win the *experimental* prize may not be the same. Plan accordingly.

## Strategy decisions

### Playbook translation for this event

| Playbook lesson (ML version) | Translation for this hackathon |
|---|---|
| OOF CV doesn't predict OOD leaderboard | Docking / FEP / ML scores poorly predict true SPR Kd. Don't pick the 4 compounds by single-score top-rank. The HDB-vs-CF Labs 3–10× SPR spread *is the calibration ceiling*. |
| Boring wins (calibrated, regularized model) | Boring wins (chemically-sensible, fragment-grounded compounds with orthogonal evidence at known pockets A or F). |
| Submit baseline within hour 1 | Validate submission format + onepot library lookup early. Confirm a fragment-derived compound *can* be submitted end-to-end before getting fancy. |
| ≤ 5 leaderboard submissions | N/A — single submission. But: pick the 4 compounds for **diversity of hypothesis** (different sites / chemotypes) so you're not all-in on one bet. |
| Lock 60 min before deadline | Lock the 4 SMILES + rationale by 6:00 pm; last hour is verification + slide polish only. |
| Calibration is half the score | Orthogonal evidence is half the score. Combine docking (against 6F59 G177D) + ML scores + fragment-similarity + onepot-synthesizability + property checks. No single oracle. |

### Site selection priority (data-driven)

1. **Site F** (highest priority) — engages D177 directly; TEP authors recommend; all best Naar binders predicted here; CF Labs SPR already validated this pocket. Use 6F59 receptor or overlay G177D variant onto crystal form 2 (PDB 5QSA, 5QSC, 5QSI, 5QSK fragment poses).
2. **Site A** (secondary) — at dimerization interface; most fragments bound here; TEP recommends. Many fragment-derived SAR options (PDB 5QRF, 5QRG, 5QRH, 5QRK, 5QRL, etc.).
3. **Site G** (consider but cautious) — promiscuous; easy to hit but selectivity is the concern.
4. **Sites B, C, D, E, A'** — low priority unless we have a strong specific hypothesis; few fragments mean limited SAR.

### Decisions to make

- **Lock-down time:** 6:00 pm — no compound changes after this; final hour is verification + slide polish
- **Diversity rule:** the 4 compounds should span **at least 2 binding sites** and **at least 2 chemotypes**. Recommended composition: 2× site F (different chemotypes), 1× site A, 1× wildcard (best-orthogonal-evidence regardless of site).
- **Stop-loss:** if a candidate scaffold fails property filters or has no orthogonal supporting evidence after 1 hour, drop it
- **Onepot retrosynthesis check:** every compound on the shortlist must look plausible via the 7 onepot reactions before final ranking
- **Naar overlap filter:** automated similarity (e.g., Tanimoto > 0.85) check against Naar SMILES before locking submission
- **Role assignments (for 6–8 person team — assign on the day):**
  - **Workflow lead** (1) — owns the docking + ML scoring pipeline end-to-end against 6F59 / 5QS9
  - **Site F specialist** (1) — focuses on pocket F docking, fragment-derived design, similarity to Naar best binders
  - **Site A specialist** (1) — focuses on pocket A, leverages many existing fragment poses (5QRF–5QS5)
  - **Chemistry sanity** (1) — PAINS/property filter, onepot retrosynthesis check, lead-likeness
  - **Library lookup** (1) — onepot 3.4B library search, Naar overlap filter
  - **Rationale + slides** (1–2) — own the narrative + presentation from hour 0; fill numbers as they land
  - **Submission verification** (1) — reads `predict.sh`-equivalent steps; confirms the 4 SMILES are valid and in onepot library before lock-down

## Deliverables

- **Submission (7:00 pm):** Team name + 4 ranked SMILES + binding site + rationale + computed evidence + properties (format TBD — confirm with organizers at door)
- **Final demo (7:00 pm):** Required for hackathon judging — format/length TBD
- **Code release:** Not stated — assume optional unless told otherwise

## Open questions (still to resolve at the event)

Resolved during pre-event prep:
- ✅ **muni** = muni.bio, "where molecules meet agents" — agentic scientific compute platform. Prize is platform credits.
- ✅ **Team size** = 6–8 members.
- ✅ **Compute** = local workstation + HPC with GPU.

Still open (confirm at the door on May 9):

1. **Onepot library access during the event.** Onepot CORE has no public API or download — access is contract-restricted. The organizer (onepot is a co-host) will provide a search/lookup mechanism on the day. Until then, plan workflow assuming we'll get a SMILES-search interface or bulk catalog (most likely the former).
2. **Submission portal/format.** Luma says "final submissions" at 7:00 pm but doesn't link a form. Likely an in-person submission form or organizer-provided portal.
3. **muni.bio platform capabilities.** What scientific models does muni expose? (Docking? Co-folding? Property prediction? Generative?) Is muni.bio access provided at the event, or only as the prize? Worth checking on May 9 morning whether to onboard early.
4. **Rowan platform during event.** Are Rowan workflows pre-provisioned for participants, or do we use the public free-tier (500 credits)? DFT/xTB credits go fast on real-sized systems.

## Risks and unknowns (resolved or known limitations)

- **Naar dataset overlap** — must filter shortlist against Naar SMILES before locking. Treat near-duplicates (Tanimoto > 0.85) as duplication.
- **HDB vs CF Labs SPR divergence** — affinity predictions accurate to ~3–10× at best at the µM level. A "1 µM in silico" prediction is realistically 3–30 µM in CF Labs SPR.
- **Onepot synthesis filter** — even if a compound is in the enumerated 3.4B set, it may fail synthesis. Bias toward simple chemistry (fewer, more reliable disconnections among the 7 reactions).
- **Ranking signal is weak.** Docking/FEP/ML scores rarely predict SPR Kd within an order of magnitude. Diversity-of-hypothesis matters more than single-score ranking.
- **5-hour hacking window is short.** No time for full FEP runs (each takes hours). Plan for: docking + ML scoring + fragment-similarity + property filters + manual chemistry curation.

---

*Read [HACKATHON_LEARNINGS.md](../../docs/HACKATHON_LEARNINGS.md) for strategic guidance.*
*Read [BOOTSTRAP.md](../../docs/BOOTSTRAP.md) for filesystem and workflow.*
