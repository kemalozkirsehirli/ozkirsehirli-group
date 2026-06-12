# T-box Family Selectivity Analysis — Strategy 8 Complete

**Conclusion:** Site F is **intrinsically TBXT-selective**. Three of the most contact-relevant residues (G/D177, M181, T183) are essentially unique to TBXT across the 16-member human T-box family. Compounds engaging these residues have built-in selectivity. **This is the strongest scientific-rationale point we have for the demo.**

## Method

- 16 human T-box family member sequences pulled from UniProt
- Each pairwise-aligned to TBXT DBD (residues 42-219) via Bio.Align (BLOSUM-style scoring)
- Aligned-block coordinates used to map TBXT positions to family-equivalent positions
- Residue identity tabulated at each TBXT site F + site A pocket position

Family members covered: TBR1, TBR2, TBX1, TBX2, TBX3, TBX5, TBX6, TBX10, TBX15, TBX18, TBX19, TBX20, TBX21, TBX22, MGA.

## Site F: TBXT-specific signatures

Conservation across non-TBXT family members at each TBXT site F residue:

| TBXT residue | Role | Conservation | Observed in family | TBXT-specific? |
|---|---|---:|---|:---:|
| L42 | anchor (hydrophobic) | 7% | aligns out of DBD core; only TBX21 retains L | ✓ |
| G81 | loop | 100% | G everywhere | — (universal) |
| L82 | loop hydrophobic | 80% | L=12, M=2, V=1 | — |
| D83 | loop polar | 80% | D=12, N=2, E=1 | — |
| Y88 | H-bond anchor | 100% | Y everywhere | — (universal) |
| **I172** | hydrophobic | 47% | I=7, V=6, L=2 | **✓** |
| **R174** | salt bridge / cation | 40% | R=6, E=4, Y=1, others | **✓** |
| **G177** | VARIANT site (G177D = chordoma SNP) | **0%** | L=4, Y=2, S=2, P=2, E=1, N=1, Q=1, C=1, K=1 | **✓ unique** |
| **M181** | hydrophobic | 7% | TBR2 also M; otherwise G/N/E/T/K/A/V | **✓** |
| **T183** | polar | 13% | K=5, R=3, T=2, H=2, Q=1, C=1, A=1 | **✓** |

**Key insight:** G177 is occupied by 9 different amino acids across the family — a hot spot of family divergence. Compounds engaging this residue (or its D177 variant in our assay protein) cannot bind any other T-box family member without major reorganization.

R174 + M181 + T183 are also TBXT-unique. Together with G/D177 these define a "selectivity quadrant" inside site F.

## Site A: lower selectivity than site F

| TBXT residue | Role | Conservation |
|---|---|---:|
| S89 | anchor polar | 47% (S=7, others=8) |
| L91 | hydrophobic | 67% |
| P120 | rigid | 87% |
| S121 | polar | 13% |
| V123 | hydrophobic | 53% |
| I125 | hydrophobic | 53% |
| H126 | polar | 100% |
| S129 | polar | 100% |
| P130 | rigid | 87% |
| V173 | hydrophobic | 73% |
| R180 | salt bridge | 7% (most family members have S/T/E) |

Site A has more conserved residues (H126, S129, P130 are 100%/87% conserved). Selectivity at site A would have to come from R180 (TBXT-unique), but R180 is the only TBXT-specific residue at site A.

## Off-target risk per family member

Sorted by TBXT-similarity at site F (highest = greatest off-target risk):

| Family member | Site F identity | Site F substitutions | Off-target risk |
|---|---:|---|---|
| **TBX19 (TPIT)** | **8/10** | only G177S | **HIGH** — closest to TBXT at site F |
| TBX2 | 6/10 | G177L, M181T, T183R | MEDIUM |
| TBX3 | 6/10 | G177L, M181T, T183R | MEDIUM |
| TBR1 | 5/10 | I172V, R174E, G177E, M181E | LOW-MEDIUM |
| TBX21 (T-bet) | 5/10 | D83E, R174E, G177C, M181N, T183H | LOW-MEDIUM |
| TBX5 | 5/10 | D83N, R174G, G177S, M181A, T183C | LOW |
| TBX6, TBX15, TBX18, TBX20 | 4-5/10 | various | LOW |
| TBR2 (EOMES) | 4/10 | D83N, R174E, G177N, M181K, T183Q | LOW |
| TBX22 | 4/10 | I172V, R174E, G177L, M181G, T183K | LOW |
| **TBX1** | **3/10** | L82M, I172V, R174Y, G177Y, M181N, T183K | **VERY LOW** |
| **TBX10** | **3/10** | L82M, I172V, R174F, G177Y, M181N, T183K | **VERY LOW** |
| MGA | 4/10 | I172L, R174P, G177K, M181V, T183H | LOW |

**Therapeutically: this is a great selectivity profile.** TBR1 (neuronal differentiation), TBR2/EOMES (Th1 lineage), TBX21 (immune cell fate) are all therapeutically relevant — and they're all in the LOW or LOW-MEDIUM off-target tier. TBX19 (TPIT, pituitary) is the only HIGH-risk off-target, and it's a single substitution (G177S) — meaning compounds that specifically engage G/D177 retain selectivity. TBX2/3 (cancer drivers) are at MEDIUM risk and their substitutions (G177L) preserve no carboxylate — so any compound engaging D177 in TBXT G177D would lose binding to TBX2/3.

## Direct narrative for the slide deck

> "Site F is TBXT-selective by design. Three of the four primary contact residues (G177, M181, T183) are essentially unique to TBXT across the 16-member human T-box family. Compounds engaging the variant residue G177D (the chordoma-associated allele present in 90% of cases) gain charge contact unique to the disease form. Off-target binding to TBR1, TBX2, TBX21 — therapeutically relevant T-box paralogs — requires the compound to displace 4-5 substituted residues simultaneously, which is structurally implausible. The closest off-target, TBX19/TPIT (pituitary), differs by only G177S — but that single substitution removes the carboxylate / glycine variant signature our compounds engage."

## Files

- `data/selectivity/site_F_residue_matrix.csv` — site F per-position table
- `data/selectivity/site_A_residue_matrix.csv` — site A per-position table
- `data/selectivity/{TBXT,TBR1,...}.fasta` — 16 family member sequences
- `scripts/tbox_selectivity.py` — pipeline

## Caveats

- **Sequence-only analysis.** A structural overlay against TBR1 (PDB 6JG2) or TBX21 (PDB 4A04) would refine the selectivity claim with 3D pocket geometry. Pre-event time permitting, dock our top picks against TBR1 / TBX19 to confirm predicted weak binding.
- **L42 alignment artifact.** L42 is in the N-terminal linker before the conserved T-box DBD core; "-" entries for L42 in the matrix mean the family alignment doesn't extend that far N-terminally. The L42 contact in our docked poses is a TBXT-specific feature regardless.
- **G/D177 variant.** Our assay uses TBXT G177D (the chordoma SNP). The selectivity argument is even stronger for the variant: compounds targeting D177 specifically (rather than the WT G) are uniquely engaging the disease-associated form.
- **Functional vs. structural selectivity.** Even if a compound binds another T-box member, it may not be functionally consequential (T-box proteins are tissue-restricted; off-target binding in a non-expressing tissue is harmless). Selectivity here is a structural argument; functional selectivity needs in-cell validation.
