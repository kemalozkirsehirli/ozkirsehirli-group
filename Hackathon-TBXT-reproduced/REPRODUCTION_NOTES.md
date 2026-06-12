# Reproduction Notes

Created: 2026-06-12

This repository was reproduced from the supplied `Hackathon-TBXT` archive and prepared as a public GitHub-ready release with the original root folder name preserved as `Hackathon-TBXT/`.

Source archive SHA256:

```text
62e6d4d41d9e7032ba2e5dbe7e6f8aba73403ecc6e44a5717127845c8133740c
```

## Cleaning performed

Removed only non-substantive macOS metadata:

- `__MACOSX/`
- AppleDouble `._*` files
- `.DS_Store` files

No scientific source files, reports, dashboards, data summaries, figures, or slide/PDF artifacts were intentionally removed.

## Public-release adjustments

- Added `LICENSE`, `NOTICE.md`, `AUTHORS.md`, `CONTRIBUTORS.md`, `MAINTAINERS.md`, `GOVERNANCE.md`, `GOVERNANCE_AND_ATTRIBUTION.md`, `CODE_OF_CONDUCT.md`, `THIRD_PARTY_AND_DATA_NOTICE.md`, and `CITATION.cff`.
- Removed invalid pre-public placeholders from `CITATION.cff`, `.github/CODEOWNERS`, and maintainer docs.
- Replaced obsolete private-upstream GitHub URLs and legacy local machine paths in text files with public-release references.
- Updated public-facing submission/slide text to identify Kemal Özkırşehirli as current reproduced-release lead while preserving historical-contributor attribution in the governance files.
- Patched final PDF slide artifacts where obsolete private GitHub links or old project-lead title text appeared.
- Generated a plain `REPO_MANIFEST.txt` suitable for `git add -f --pathspec-from-file=REPO_MANIFEST.txt`.

## Validation performed

- ZIP integrity test.
- macOS metadata scan.
- placeholder scan for GitHub-critical fields.
- Python syntax compilation check.
- Bash syntax check.
- dry-run `git add -f --pathspec-from-file=REPO_MANIFEST.txt` check in a temporary Git repository.

## Reproduction scope

The repository package preserves and republishes the source tree and artifacts. It does not assert that every docking, QSAR, Boltz, MMGBSA/FEP, or external-service result was recomputed end-to-end during this packaging pass.


## Lower-risk public-release pass

A later public-release pass removed personal-allegation language, avoided sole-ownership claims, separated attribution from repository maintainership, redacted hardcoded external Google Drive IDs, and neutralized former private/local path references where practical. See `PUBLIC_RELEASE_SAFETY_NOTES.md`.
