**TBXT Hit Identification Hackathon**  
Boston ·  May 9, 2026 · Pillar VC  
Hosted by muni in collaboration with Rowan and onepot

Links: 

https://luma.com/n9hheb8j
https://tbxtchallenge.org/?utm_source=luma#prizes

## **Goal**

Design and prioritize non-covalent small-molecule ligands for human TBXT (Brachyury) using computational workflows.

The goal is to identify the strongest credible TBXT binder within [onepot’s 3.4B compound library](https://www.onepot.ai/), while favoring compounds that are chemically reasonable, tractable to synthesize, and unlikely to create obvious issues in downstream SPR assays.

This challenge is not intended to solve TBXT biology end-to-end. Rather, it is designed to test whether modern computational small-molecule workflows can identify credible binders to a clinically relevant transcription factor.

## **Target**

**Target:** Human TBXT (Brachyury)  
**Protein class:** T-box transcription factor  
**Length:** 435 amino acids  
**Domain of interest:** DNA-binding domain (DBD), residues \~42–219  
**Structure:** The DBD lies in the N-terminal region and is followed by a largely unstructured C-terminal region.

TBXT is the defining feature and a key dependency of chordoma, a rare bone cancer with no approved systemic therapy. It is also aberrantly expressed in multiple cancers and, like most transcription factors, has been difficult to target with small molecules. 

[The TBXT Target Enabling Package](https://www.thesgc.org/sites/default/files/2024-05/TBXT_TEP_datasheet_v1_0.pdf) includes crystal structures of the DNA-binding domain and a fragment screen that identifies 29 fragments across 6 clusters, providing real starting points for computational design and optimization. These fragments are not finished tool compounds, but they offer structural hypotheses and starting chemistry for designing stronger TBXT binders.

## **Structural Input**

**UniProt:**  
[https://www.uniprot.org/uniprotkb/O15178/entry\#structure](https://www.uniprot.org/uniprotkb/O15178/entry#structure)

## **Relevant prior work and reference material**

**Participant note**  
Participants are encouraged to review these prior public-domain materials, particularly the Naar SMILES dataset, ahead of the event and to use them to inform their design strategy and avoid unnecessary duplication.

Reference list of previously disclosed TBXT-screened compounds, included to help teams avoid duplication: [**Naar SMILES**](https://docs.google.com/spreadsheets/d/1k-vcM_jVd1s_6W6u-ag2YQabGov_40oB/edit?usp=sharing&ouid=114298948653576509712&rtpof=true&sd=true)

SGC paper on TBXT and related structural work: [**Nature Communications paper**](https://www.nature.com/articles/s41467-025-56213-1)

TBXT structure bound to DNA: [**RCSB 6F59**](https://www.rcsb.org/structure/6F59)

TBXT in complex with different compounds: [**SGC structural data**](https://tinyurl.com/bddybesb)

Compounds from Anders Naar’s physics-based screen: [**Zenodo dataset**](https://zenodo.org/records/8212611)

**Prior SPR results**  
The Naar compounds were screened in a TBXT SPR assay performed by a CRO. The most interesting hits were also screened by Lee and team in the TBXT SPR developed within CF Labs. For several compounds, the HDB and CF Labs SPR results differed:

* **Z979336988** — HDB: 3 uM; CF: 30 uM; Predicted site: F  
* **Z795991852** — HDB: 10 uM; CF: 10 uM; Predicted site: F  
* **D203-0031** — HDB: 2 uM; CF: 17 uM; Predicted site: F or G

## 

## **Challenge Format**

The fragment hits in the TEP should be used as starting points for chemistry optimization. This is a hit identification challenge rather than an unconstrained de novo design challenge, and we’re focused on rewarding depth of validation, not volume. Submissions must be restricted to compounds within onepot’s 3.4B compound library: [https://www.onepot.ai/](https://www.onepot.ai/)

Each team should submit:

* 4 compounds, in ranked order  
* a short rationale for why the ranked list represents the best compounds to make and test

## **Design Constraints**

Compounds should be:

* non-covalent  
* small molecules  
* within onepot’s 3.4B compound library  
* chemically reasonable and practical to make and test  
* designed with downstream binding assays in mind

Compounds should also aim to satisfy the Chordoma Foundation’s chemistry guidance:

* LogP ≤ 6  
* H-bond donors ≤ 6  
* H-bond acceptors ≤ 12  
* Molecular weight ≤ 600

For more typical lead-like TBXT binders, compounds should ideally be closer to:

* 10–30 heavy atoms  
* combined H-bond donors \+ acceptors ≤ 11  
* cLogP / cLogD \< 5  
* fewer than five ring systems  
* no more than two fused rings

Problematic functionalities and PAINS-like motifs should generally be avoided unless strongly justified, including:

* acid halides  
* aldehydes  
* diazo groups  
* imines  
* polycyclic aromatics with more than two fused benzene rings  
* long alkyl chains  
* highly reactive or problematic charged motifs

## **Judging and Prizes**

A hackathon judging prize of $250 in muni credits will be awarded to, and compounds that win the hackathon judging are eligible for separate experimental prizes.

### **1\. Hackathon judging prize**

Judges will evaluate submissions and final demos based on:

**Scientific rationale and computational support**  
Is there a plausible rationale for why the proposed compounds should bind TBXT, and are the design choices supported by thoughtful computational work and interpretation rather than by a single score or ranking alone?

**Compound quality and tractability**  
Are the proposed compounds chemically sensible, with reasonable properties and no obvious liabilities, and are they realistic to make and appropriate for downstream SPR evaluation?

**Hit identification judgment**  
Does the 4-compound ranked set reflect good prioritization and tradeoff-making, rather than favoring volume, novelty alone, or a single metric?

### **2\. Experimental prize**

Each team may compete for experimental prizes totaling up to $250K for compounds that demonstrate binding to TBXT, including one award at the 1 μM level and/or one award at the 300 nM level. Prizes will be awarded until three teams win any prize or two teams are awarded the 300 nM prize, whichever comes first. In addition, molecular structures meeting the affinity criteria will be confidentially evaluated by an expert third-party chemist to confirm acceptable drug-like properties and the absence of problematic functionalities (e.g., PAINS), unless intentionally incorporated. [Here’s the link for more information on these prizes.](https://tbxtchallenge.org/#prizes) 

## **After the hackathon**

Submitted compounds that are within scope and can be successfully synthesized by onepot will move forward to experimental binding evaluation against purified, full-length TBXT.

Compounds will be evaluated by CF Labs personnel for binding to full-length TBXT (G177D) via surface plasmon resonance (SPR) using a two-fold, six-point titration. Hits that achieve an affinity \< 5 μM will be tested twice more for confirmation. The Foundation can provide raw SPR output, dose-response values, fitted KD values, sensorgrams, and QC data.

## **Your Submission**

Once you’re done, submit:

* Team name  
* **4 ranked compounds (SMILES), with rank order clearly indicated**  
* Predicted binding pocket / binding site  
* Short rationale for the ranking  
* Key computed evidence  
* Relevant molecular properties

## **Notes**

This is a TBXT hit identification challenge, not a promise of functional inhibition or therapeutic efficacy.

The goal is to identify credible binders, not to solve all downstream biology in one step.

The most compelling submissions will likely be the ones that balance structural rationale, chemistry quality, and realism about what is worth making and testing.