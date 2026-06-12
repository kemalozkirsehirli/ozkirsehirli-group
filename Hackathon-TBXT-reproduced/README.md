# TBXT/Brachyury Small-Molecule Hackathon Research Repository

Public GitHub-ready research release of the `Hackathon-TBXT` archive for continued chordoma-focused TBXT/brachyury computational hit-identification work under **Kemal Özkırşehirli / Özkırşehirli Group**.

This README is the main orientation document. It explains what the repository contains, what changed for public release, how the website works, how to publish it, how to cite it, what the license permits, what it does not permit, and what legal/scientific boundaries apply.

> **Public-release safety note:** This repository uses neutral attribution and governance language. It does not publish personal allegations, does not assert sole ownership of all underlying work, and does not adjudicate external authorship, employment, institutional, patent, or contract disputes. Historical contribution credit is preserved separately from current GitHub repository maintainership.

---

## 1. Public release status

| Field | Value |
|---|---|
| Repository root folder | `Hackathon-TBXT/` |
| Current public repository contact / maintainer | Kemal Özkırşehirli / Özkırşehirli Group |
| Public role statement | Student Principal Investigator, Özkırşehirli Group and TBXT Small-Molecule Hackathon; project lead for the public research release |
| Research area | AI/CADD, molecular simulation, docking, QSAR, computational hit identification, reproducible rare-cancer research workflows |
| Biological focus | Chordoma; TBXT/brachyury-related computational hit identification |
| License | Custom source-available, non-commercial research license; see [`LICENSE`](LICENSE) |
| Citation metadata | [`CITATION.cff`](CITATION.cff) |
| Attribution and governance | [`NOTICE.md`](NOTICE.md), [`AUTHORS.md`](AUTHORS.md), [`CONTRIBUTORS.md`](CONTRIBUTORS.md), [`MAINTAINERS.md`](MAINTAINERS.md), [`GOVERNANCE.md`](GOVERNANCE.md), [`GOVERNANCE_AND_ATTRIBUTION.md`](GOVERNANCE_AND_ATTRIBUTION.md) |
| Third-party/data limits | [`THIRD_PARTY_AND_DATA_NOTICE.md`](THIRD_PARTY_AND_DATA_NOTICE.md) |
| Public-release safety notes | [`PUBLIC_RELEASE_SAFETY_NOTES.md`](PUBLIC_RELEASE_SAFETY_NOTES.md) |
| Release audit | [`FINAL_RELEASE_AUDIT.md`](FINAL_RELEASE_AUDIT.md) |
| GitHub Pages website | [`docs/index.html`](docs/index.html) |
| Google Form setup | [`docs/WEBSITE_SETUP.md`](docs/WEBSITE_SETUP.md), [`docs/GOOGLE_FORM_TEMPLATE.md`](docs/GOOGLE_FORM_TEMPLATE.md) |

---

## 2. What this repository is

This repository is a cleaned, licensed, public GitHub-ready release of the supplied `Hackathon-TBXT` project archive. It preserves the technical record of a TBXT/brachyury small-molecule hackathon project, including source code, Bash automation, dashboard notes, reports, small data summaries, rendered figures, final slide/PDF materials, and reproducibility notes.

The project centers on computational hit identification for chordoma-relevant TBXT/brachyury biology. The preserved workflow includes docking, QSAR, CNN rescoring, generative chemistry, candidate filtering, sourceability checks, and final candidate-selection artifacts.

This is a **research repository**, not a clinical product, wet-lab protocol, medical recommendation, regulatory submission, patent claim, purchasing instruction, or authorization to synthesize, procure, test, dose, or administer any compound.

---

## 3. Scientific background in plain language

Chordoma is a rare cancer that occurs in the bones of the skull base and spine. Public clinical/research resources describe chordoma as very rare, with incidence on the order of about 1 in 1,000,000 people per year and roughly hundreds of diagnoses per year in the United States.

Brachyury, also known as TBXT, is closely tied to chordoma biology and diagnosis. Public chordoma resources state that nearly all chordomas have high levels of brachyury/TBXT, which is why this repository treats TBXT/brachyury as the central computational focus.

Helpful public references:

- Chordoma Foundation - Understanding chordoma: https://www.chordomafoundation.org/understanding-chordoma/
- Chordoma Foundation - Diagnosis / brachyury-TBXT: https://www.chordomafoundation.org/diagnosis/
- National Cancer Institute - Chordoma Study: https://dceg.cancer.gov/research/clinical-studies/chordoma

---

## 4. Özkırşehirli Group website and Google Form

This repository includes a ready-to-publish static website for **Özkırşehirli Group**:

```text
docs/index.html
```

The website summarizes the group as a computational science / AI for science group working on chordoma-focused TBXT/brachyury research. It includes a prominent button that sends visitors to a Google Form for collaboration/contact.

Before sharing the website, replace the placeholders in `docs/index.html`:

```text
https://forms.gle/REPLACE_WITH_YOUR_GOOGLE_FORM_ID
YOUR_CONTACT_EMAIL
```

Find them with:

```bash
grep -RIn "REPLACE_WITH_YOUR_GOOGLE_FORM_ID\|YOUR_CONTACT_EMAIL" docs/index.html
```

Suggested Google Form questions are provided in:

```text
docs/GOOGLE_FORM_TEMPLATE.md
```

**Privacy boundary for the form:** Do not ask respondents to submit patient health information, private medical records, confidential institutional data, passwords, unpublished third-party data, or proprietary compound lists through a public Google Form.

### Enable GitHub Pages

After pushing the repository to GitHub:

1. Open the GitHub repository.
2. Go to **Settings -> Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**.
4. Choose branch `main`.
5. Choose folder `/docs`.
6. Save.

GitHub Pages supports publishing from a repository branch and folder, including `/docs`; GitHub Pages also looks for an entry file such as `index.html` at the top level of the publishing source. Official docs:

- https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site
- https://docs.github.com/articles/creating-project-pages-manually
- https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages

---

## 5. What was preserved

The original substantive file names and relative paths from the supplied archive were preserved.

Preserved categories include:

- `TBXT/` source code and scripts;
- `TBXT/experiment_scripts/` task automation;
- `TBXT/scripts/` and `TBXT/scripts/team/` pipeline utilities;
- `TBXT/dashboard/` planning and day-of-operation notes;
- `TBXT/report/` and `TBXT/final/` report and slide materials;
- small included result summaries and candidate/evidence files;
- rendered PNG figures and final PDF artifacts;
- `docs/` hackathon process documentation.

Only non-substantive macOS/archive metadata was removed:

```text
__MACOSX/
._* AppleDouble files
.DS_Store
```

The preservation audit is recorded in [`FINAL_RELEASE_AUDIT.md`](FINAL_RELEASE_AUDIT.md). The file manifest used for GitHub publication is [`REPO_MANIFEST.txt`](REPO_MANIFEST.txt).

---

## 6. What changed for public GitHub release

The public release adds governance, licensing, safety, and publication files:

- [`LICENSE`](LICENSE)
- [`NOTICE.md`](NOTICE.md)
- [`AUTHORS.md`](AUTHORS.md)
- [`CONTRIBUTORS.md`](CONTRIBUTORS.md)
- [`MAINTAINERS.md`](MAINTAINERS.md)
- [`GOVERNANCE.md`](GOVERNANCE.md)
- [`GOVERNANCE_AND_ATTRIBUTION.md`](GOVERNANCE_AND_ATTRIBUTION.md)
- [`THIRD_PARTY_AND_DATA_NOTICE.md`](THIRD_PARTY_AND_DATA_NOTICE.md)
- [`PUBLIC_RELEASE_SAFETY_NOTES.md`](PUBLIC_RELEASE_SAFETY_NOTES.md)
- [`CITATION.cff`](CITATION.cff)
- [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md)
- [`PUBLISH_TO_GITHUB.md`](PUBLISH_TO_GITHUB.md)
- [`PUBLISH_TO_GITHUB.sh`](PUBLISH_TO_GITHUB.sh)
- [`docs/index.html`](docs/index.html)
- [`docs/WEBSITE_SETUP.md`](docs/WEBSITE_SETUP.md)
- [`docs/GOOGLE_FORM_TEMPLATE.md`](docs/GOOGLE_FORM_TEMPLATE.md)

For public-release safety, the repo now avoids personal allegations, avoids statements that purport to adjudicate disputed ownership, and neutralizes former local/private path references where practical. Historical contribution credit is preserved, but current repository access and public release operations are controlled through the root governance files above.

---

## 7. Repository structure

```text
Hackathon-TBXT/
├── README.md                         # this file
├── LICENSE                           # custom source-available research license
├── NOTICE.md                         # public release notice
├── AUTHORS.md                        # attribution record
├── CONTRIBUTORS.md                   # contributor list and correction process
├── MAINTAINERS.md                    # current GitHub repository maintainer/contact
├── GOVERNANCE.md                     # repository governance
├── GOVERNANCE_AND_ATTRIBUTION.md     # distinction between attribution and repo access
├── THIRD_PARTY_AND_DATA_NOTICE.md    # third-party data/model/API limits
├── PUBLIC_RELEASE_SAFETY_NOTES.md    # public-release risk-reduction changes
├── CITATION.cff                      # citation metadata
├── CODE_OF_CONDUCT.md                # public collaboration norms
├── PUBLISH_TO_GITHUB.md              # push instructions
├── PUBLISH_TO_GITHUB.sh              # helper script for a clean first push
├── REPO_MANIFEST.txt                 # file list used by helper script
├── docs/
│   ├── index.html                    # Özkırşehirli Group GitHub Pages website
│   ├── WEBSITE_SETUP.md              # website / Google Form setup
│   ├── GOOGLE_FORM_TEMPLATE.md       # suggested Google Form fields
│   └── ...                           # original docs preserved
└── TBXT/
    ├── START.md                      # original onboarding
    ├── TEAM_HANDOFF.md               # team execution handoff
    ├── setup.sh / setup_hf.sh        # environment/data setup helpers
    ├── smoke_test.sh                 # original smoke-test entrypoint
    ├── experiment_scripts/           # task scripts
    ├── scripts/                      # computational pipeline utilities
    ├── dashboard/                    # planning and execution notes
    ├── data/                         # small preserved data/result summaries
    ├── report/                       # report materials
    └── final/                        # final submission/slide artifacts
```

---

## 8. How to publish this exact repository to GitHub

Create a new empty GitHub repository. Do **not** initialize it with a README, license, or `.gitignore`, because this package already includes those files.

Then run:

```bash
unzip Hackathon-TBXT-FINAL-PUBLIC-GITHUB-LOWER-RISK.zip
cd Hackathon-TBXT
bash PUBLISH_TO_GITHUB.sh git@github.com:OWNER/Hackathon-TBXT.git "Kemal Özkırşehirli" "YOUR_GIT_EMAIL"
```

HTTPS alternative:

```bash
bash PUBLISH_TO_GITHUB.sh https://github.com/OWNER/Hackathon-TBXT.git "Kemal Özkırşehirli" "YOUR_GIT_EMAIL"
```

Manual equivalent:

```bash
git init
git checkout -B main
git config user.name "Kemal Özkırşehirli"
git config user.email "YOUR_GIT_EMAIL"
git add -f --pathspec-from-file=REPO_MANIFEST.txt
git commit -m "Release TBXT hackathon research repository"
git remote add origin git@github.com:OWNER/Hackathon-TBXT.git
git push -u origin main
```

---

## 9. External data and setup bundles

This public release intentionally does **not** publish hardcoded Google Drive file IDs for large environment/data bundles. If you control those bundles and have the right to distribute them, pass the IDs through environment variables when running `TBXT/setup.sh`:

```bash
export ID_ENV="YOUR_ENV_TARBALL_DRIVE_ID"
export ID_DATA="YOUR_DATA_TARBALL_DRIVE_ID"
export ID_CHECKSUMS="YOUR_CHECKSUMS_DRIVE_ID"
export ID_MANIFEST="YOUR_MANIFEST_DRIVE_ID"
# optional:
export ID_SUPPLEMENT="YOUR_SUPPLEMENT_DRIVE_ID"
bash TBXT/setup.sh
```

The public source tree itself preserves small result summaries and scripts. Large external datasets, model weights, catalog exports, hosted bundles, and service outputs remain subject to their own licenses and access terms.

---

## 10. Running the preserved workflow

The original workflow expected a Linux/HPC-style environment with tools such as Bash, Python, RDKit, AutoDock Vina, GNINA, OpenMM/OpenFF, Boltz-style inference dependencies, and other scientific packages. Some files are preserved research artifacts rather than one-command runnable notebooks.

Typical public-release orientation:

```bash
cd Hackathon-TBXT
python -m compileall TBXT || true
bash -n TBXT/setup.sh
bash -n TBXT/smoke_test.sh
```

For full scientific reproduction, you need the external data/model/environment assets described above, plus any third-party permissions required for datasets, compound catalogs, and software dependencies.

---

## 11. License summary

See [`LICENSE`](LICENSE) for the binding terms. Informally, the license is designed to allow:

- public reading and GitHub platform use;
- non-commercial research review, audit, teaching, and benchmarking;
- local modification and reproduction attempts;
- citation and limited research reuse with attribution.

The license does **not** grant:

- commercial drug-discovery use;
- paid consulting, SaaS, screening, procurement, or compound-sourcing services;
- patent rights;
- trademark or institutional endorsement rights;
- permission to remove attribution;
- permission to claim sole authorship or false maintainership;
- permission to use third-party datasets, models, catalogs, APIs, or hosted bundles beyond their own terms;
- clinical, diagnostic, therapeutic, wet-lab, animal, or human-subject authorization.

The license applies only to materials for which the applicable rights holders have authority to license. Third-party materials remain under third-party terms.

---

## 12. Attribution and governance boundaries

This repository separates three concepts:

1. **Scientific attribution** - who contributed to the preserved research record.
2. **Repository maintainership** - who controls this public GitHub release and accepts changes.
3. **Legal ownership** - copyright, patent, institutional, contractual, and other rights that may require separate review.

The root files preserve this separation:

- Attribution: [`AUTHORS.md`](AUTHORS.md), [`CONTRIBUTORS.md`](CONTRIBUTORS.md), [`NOTICE.md`](NOTICE.md)
- Current public repo access/governance: [`MAINTAINERS.md`](MAINTAINERS.md), [`GOVERNANCE.md`](GOVERNANCE.md)
- License and rights limits: [`LICENSE`](LICENSE), [`THIRD_PARTY_AND_DATA_NOTICE.md`](THIRD_PARTY_AND_DATA_NOTICE.md)

The repository does not publish personal conduct allegations and does not claim that historical contributors lose attribution because this public release is maintained by Kemal Özkırşehirli / Özkırşehirli Group.

---

## 13. Citation

Use [`CITATION.cff`](CITATION.cff) and preserve [`AUTHORS.md`](AUTHORS.md) / [`CONTRIBUTORS.md`](CONTRIBUTORS.md) in substantial copies or forks.

Suggested plain-text citation:

```text
Özkırşehirli, K. and TBXT Small-Molecule Hackathon Contributors. TBXT/Brachyury Small-Molecule Hackathon Research Repository. Public source-available research release, 2026.
```

---

## 14. No medical, safety, or procurement advice

The compound IDs, SMILES, docking scores, QSAR predictions, Boltz-style readouts, MMGBSA/FEP notes, and candidate rankings are computational research artifacts. They are not validated medicines, do not prove binding or efficacy, and should not be used to make clinical, procurement, synthesis, dosing, safety, or investment decisions without independent expert review and lawful approvals.

---

## 15. Public-release checklist before pushing

Before making the repository public:

```bash
# confirm no macOS metadata
find . -name '__MACOSX' -o -name '._*' -o -name '.DS_Store'

# check placeholders you still need to fill
grep -RIn "OWNER/Hackathon-TBXT\|YOUR_GIT_EMAIL\|REPLACE_WITH_YOUR_GOOGLE_FORM_ID\|YOUR_CONTACT_EMAIL" .

# check no hardcoded old private/local paths remain
grep -RIn "OLD_PRIVATE_NAMESPACE_PATTERN" . || true

# optional syntax checks
find . -type f -name '*.sh' -print0 | xargs -0 -n1 bash -n
```

---

## 16. Contact / collaboration

Use the GitHub Pages site in [`docs/index.html`](docs/index.html) and the Google Form described in [`docs/GOOGLE_FORM_TEMPLATE.md`](docs/GOOGLE_FORM_TEMPLATE.md). Replace the placeholders before publishing.
