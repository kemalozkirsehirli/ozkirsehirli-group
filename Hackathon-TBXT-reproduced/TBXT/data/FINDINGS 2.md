# Prior-Art Findings (TBXT Hackathon)

Generated from `prior_art_canonical.csv`. See `scripts/build_inventory.py` and `scripts/pains_and_findings.py` for the pipeline.

---

## Inventory size

- **Total unique canonical compounds:** 2274
- tep_fragment: 42
- naar_sheet: 136
- naar_zenodo: 2096

## The 3 CF Labs SPR hits — your validated reference set

| ID | Site | CF Kd (µM) | HA | MW | LogP | Rings | Fused | PAINS | SMILES |
|---|---|---:|---:|---:|---:|---:|---:|---|---|
| Z979336988 | F | 30.0 | 36 | 478.6 | 4.69 | 6 | 2 | N | `Cc1ccc2[nH]c(C3CCCN(C(=O)c4cccc(CN5C(=O)c6ccccc6C5=O)c4)C3)nc2c1` |
| Z795991852 | F | 10.0 | 37 | 495.5 | 2.88 | 6 | 2 | N | `Cn1c(=O)c2ccccc2n2c(COC(=O)c3cccc(NC(=O)C4Cc5ccccc5O4)c3)nnc12` |
| D203-0031 | F or G | 17.0 | 35 | 476.5 | 2.86 | 6 | 2 | N | `O=C(c1ccc2c(c1)OCO2)N1CCC(c2nc(O)c3nnn(Cc4ccc(F)cc4)c3n2)CC1` |

**Read this:** all three pass the Chordoma hard rule (LogP≤6, HBD≤6, HBA≤12, MW≤600) but **none** pass the strict lead-like rule (each has 6 rings; the rule wants <5). The validated binders are scaffolded compounds, not classical lead-likes. **Use the relaxed rule (HA≤35, rings≤6, fused≤2, no PAINS) for our shortlist.** A strict lead-like filter would exclude the only known binders.

## Critical: prior-art near the CF Labs hits

- **D203-0031 has a near-twin in the disclosed set: D203-0030 (Tanimoto 0.908).** Differs only in linker — OCO (methylenedioxy) vs OCCO (ethylenedioxy) on the piperonyl. The D203-* series is heavily explored and disclosed; *do not* propose linker variants of D203-0031.
- **Z979336988** has a moderately similar Naar analog Z953858624 (T 0.436) that retains the methylbenzimidazole-piperidine core but swaps the phthalimide for a triazolopyridazinone — a PAINS-safer alternative that hasn't been CF-Labs-tested. Worth investigating.
- **Z795991852** has only weak Naar neighbors (T 0.27). Its methylquinazolinone-triazole-amide chemotype is **the least-explored** of the three CF Labs scaffolds. **Most novel-friendly site F starting point.**

## CF Labs hits are NOT close to TEP fragments

Max Tanimoto from any CF Labs hit to any TEP fragment is **0.32**. The validated binders are independently-discovered scaffolds, not direct elaborations of the X-ray fragments. Implication: fragment-growing from TEP alone is unlikely to recapitulate the known hits. **The TEP fragments and the CF Labs hits represent two parallel sources of starting chemistry at site F.**

## Naar set already explored ~16% of TEP-fragment chemistry

**365 Naar compounds (16% of the screen)** have Tanimoto ≥ 0.5 to a TEP fragment.
- Sites **G, A', B** are heavily co-explored (top T ≈ 0.7–0.78) — limited novel space
- Site **F** TEP fragments have only moderate Naar similarity (T 0.6–0.69) — relatively underexplored, but the 3 CF Labs hits already validate parts of the pocket
- Sites **A** has 20 fragments mostly with CSC* (ChemSpace) lookalikes screened

## PAINS in the inventory

| Source | Total | PAINS-flagged | % |
|---|---:|---:|---:|
| tep_fragment | 42 | 1 | 2.4% |
| naar_sheet | 136 | 2 | 1.5% |
| naar_zenodo | 2096 | 13 | 0.6% |

PAINS-flagged TEP fragments (1):
- `F9000710` (site G, anil_di_alk_A(478))

## Site F starting set — synthesised + validated chemistry

### TEP fragment hits (small starting points)
| ID | CCD | HA | MW | LogP | SMILES | IUPAC |
|---|---|---:|---:|---:|---|---|
| FM001580 | K2P | 14 | 206.1 | 2.28 | `O=C(O)c1ccccc1OC(F)(F)F` | 2-(trifluoromethoxy)benzoic acid |
| FM001452 | O1D | 15 | 199.3 | 2.85 | `Nc1cccc(OCc2ccccc2)c1` | 3-(benzyloxy)aniline |
| FM002150 | O1J | 12 | 166.2 | 1.29 | `O=C(O)COCc1ccccc1` | (benzyloxy)acetic acid |

### CF Labs SPR hits at site F (full-size validated binders)
Already included above. Treat all three as scaffolds for SAR exploration, with priority Z795991852 > Z979336988 > D203-0031 (in increasing duplication risk).

---

## Strategy implications for the 4-pick

1. **Site F is the productive site** — TEP-recommended, all CF Labs hits bind there. Bias the shortlist toward F.
2. **Z795991852 chemotype** (methylquinazolinone-triazole-amide) is most novel-friendly — start here for one of the 4 picks.
3. **Phthalimide replacement** in Z979336988: phthalimide is *not* flagged by RDKit's strict PAINS catalog (Baell 2010), so it doesn't auto-fail PAINS, but it's a known reactivity / metabolic-liability concern (Brenk filter would flag the di-imide). Z953858624 already shows triazolopyridazinone works as a swap — but it's in the disclosed set, so we'd need a *different* replacement.
4. **D203-* series is too explored** — skip unless we have a structurally distinct linker variant.
5. **Property filter:** apply Chordoma hard rule + relaxed lead-like (HA≤35, rings≤6, fused≤2, PAINS=N). The strict 'lead-like' rule from organizers excludes the only known µM binders — relax it.
6. **Tanimoto-to-Naar ≥ 0.85 = duplication risk.** Compounds with T 0.4–0.7 to a CF Labs hit are 'inherits-binding-potential, novel-enough' candidates.
7. **Diversify across sites for the 4-pick.** Suggested composition: 2× site F (chemotypes from Z795991852 and a TEP fragment elaboration), 1× site A (most fragment data), 1× wildcard (best orthogonal signal regardless of site).

## Compounds to manually inspect next

- `Z795991852` and 1–2 close Naar analogs (T 0.4–0.6) at site F
- `FM001580` (site F TEP fragment) and Naar analog `UNC-AH-01-089` (T 0.65) — fragment growth path
- `FM001452` (site F TEP fragment, benzyloxyaniline) and `CSC000284925` (T 0.69)
- The 19 remaining Naar compounds with T ≥ 0.5 to Z795991852 — manual chemistry curation
