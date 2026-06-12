# Final Public GitHub Release Audit

Created: 2026-06-12

## Source archive

- Source ZIP: `Hackathon-TBXT 2.zip`
- Source SHA256: `62e6d4d41d9e7032ba2e5dbe7e6f8aba73403ecc6e44a5717127845c8133740c`

## Preservation audit

- Clean substantive files in the uploaded source archive, after excluding macOS metadata: **254**.
- Substantive source files missing from this public-ready repository: **0**.
- Total files in this public-ready repository manifest: **275**.
- Repository root folder in ZIP: `Hackathon-TBXT/`.

## Missing original files

None.

## Source-file content intentionally updated for public release

The original filenames and relative paths were preserved. Some file contents were updated to make the repository public-GitHub-ready:

- root `README.md` expanded into a public release README;
- `.gitignore` adjusted so public attribution/citation files are not blocked;
- `TBXT/setup.sh` and `TBXT/setup_hf.sh` no longer hardcode a former private upstream repository;
- public-facing root governance identifies Kemal Özkırşehirli as current public repository maintainer/contact;
- hardcoded legacy local machine paths and private upstream GitHub URLs in text files were replaced with generic public-release references;
- final PDF slide artifacts were redacted/stamped where needed to remove obsolete private GitHub links and old project-lead title text.

## Added release/governance/licensing files

- `.gitattributes`
- `.github/CODEOWNERS`
- `.github/ISSUE_TEMPLATE/attribution_correction.md`
- `AUTHORS.md`
- `CITATION.cff`
- `CODE_OF_CONDUCT.md`
- `CONTRIBUTORS.md`
- `GOVERNANCE.md`
- `GOVERNANCE_AND_ATTRIBUTION.md`
- `LICENSE`
- `LICENSE_DECISION.md`
- `LICENSE_SHA256.txt`
- `MAINTAINERS.md`
- `NOTICE.md`
- `PUBLISH_TO_GITHUB.md`
- `PUBLISH_TO_GITHUB.sh`
- `REPO_MANIFEST.txt`
- `REPRODUCTION_NOTES.md`
- `SOURCE_ARCHIVE_SHA256.txt`
- `THIRD_PARTY_AND_DATA_NOTICE.md`

## Intentional exclusions

Only non-substantive macOS/archive metadata was excluded:

- `__MACOSX/`
- AppleDouble `._*` files
- `.DS_Store` files

## License SHA256

`b2828c076e549285850c09622eacf8bf97027148f8e26404f52b1ea69366b833`

## Scope clarification

This is a repository-level reproduction of the supplied archive: files, structure, scripts, dashboards, reports, result summaries, final materials, and provenance have been preserved and licensed for a public GitHub release.

This audit does not claim that every computational workflow was rerun end-to-end, that every external dependency was redownloaded, that third-party datasets/models were relicensed, or that the computational claims have wet-lab validation. Those remain future research/validation tasks.


## Website addition

Added a GitHub Pages-ready Özkırşehirli Group landing page under `docs/index.html`, plus `docs/WEBSITE_SETUP.md` and `docs/GOOGLE_FORM_TEMPLATE.md`. The site summarizes the group’s chordoma/TBXT research and includes a Google Form call-to-action placeholder.

Validation after website addition:

- Original substantive file paths preserved: 254 / 254.
- Repository manifest file count: 278.
- Bash syntax files checked: 27; failures: 0.
- macOS metadata scan: 0 hits.
- Old private namespace/local-path scan: 0 hits in text files.


## Final README and website packaging update

- `README.md` was expanded into the primary public-release orientation document.
- `docs/index.html` provides the Özkırşehirli Group GitHub Pages landing page.
- `docs/WEBSITE_SETUP.md` explains GitHub Pages setup and the Google Form placeholder replacement.
- `docs/GOOGLE_FORM_TEMPLATE.md` provides suggested Google Form fields.
- The repository remains rooted at `Hackathon-TBXT/`; original substantive file paths are preserved.


## Lower-risk public-release pass

A later public-release pass removed personal-allegation language, avoided sole-ownership claims, separated attribution from repository maintainership, redacted hardcoded external Google Drive IDs, and neutralized former private/local path references where practical. See `PUBLIC_RELEASE_SAFETY_NOTES.md`.
