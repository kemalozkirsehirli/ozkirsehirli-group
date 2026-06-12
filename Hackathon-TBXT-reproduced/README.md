# TBXT Hackathon Research Repository - Licensed Reproduced Release

This repository is a cleaned, licensed, and independently maintained reproduced
release of the supplied `Hackathon-TBXT` archive for continued TBXT/brachyury
small-molecule hit-identification research.

## Current status

- **Maintaining project lead:** Kemal Özkırşehirli / Özkırşehirli Group.
- **Role statement:** Student Principal Investigator / project lead for the TBXT
  Small-Molecule Hackathon work and maintaining lead of this reproduced release.
- **License:** `TBXT Research Source License v1.0`, see [`LICENSE`](LICENSE).
- **Attribution:** historical contributor attribution is preserved; see
  [`AUTHORS.md`](AUTHORS.md), [`CONTRIBUTORS.md`](CONTRIBUTORS.md),
  [`MAINTAINERS.md`](MAINTAINERS.md), and [`NOTICE`](NOTICE).

## What was preserved

- Substantive project files from the supplied archive: source code, scripts,
  dashboards, reports, data summaries, renders, and final slide/PDF materials.
- Original directory layout under `TBXT/` and `docs/`.
- Existing executable permissions for shell scripts.

## What was removed

Only operating-system metadata was removed from the repo ZIP:

- `__MACOSX/`
- AppleDouble `._*` files
- `.DS_Store` files

## Important publication notes

This release distinguishes current maintainership from historical archive
provenance. Historical files may still contain earlier private GitHub URLs, local
paths, Hugging Face references, task-role labels, or team handoff language. Those
archival references are retained for reproducibility and should not be read as
current repository governance.

Before asking collaborators to run the workflow, review:

```bash
grep -RIn "anandsahuofficial\|/home/anandsahu\|git@github.com:anandsahuofficial" .
```

## Start here

1. Read [`LICENSE`](LICENSE) before using the repository.
2. Read [`REPRODUCED_WORK_NOTICE.md`](REPRODUCED_WORK_NOTICE.md) for provenance.
3. Read [`MAINTAINERS.md`](MAINTAINERS.md) for current governance.
4. Read `TBXT/START.md` for the original project onboarding sequence.
5. Read [`PUBLISH_TO_GITHUB.md`](PUBLISH_TO_GITHUB.md) before pushing.

Source archive SHA256: `62e6d4d41d9e7032ba2e5dbe7e6f8aba73403ecc6e44a5717127845c8133740c`

---

## Original root README from the archive

# Hackathons

Multi-event git repository. Master holds hackathon-agnostic content; each event lives on its own branch.

## Start here

- **[`docs/BOOTSTRAP.md`](docs/BOOTSTRAP.md)** -- filesystem layout, how to start a new event.
- **[`docs/HACKATHON_LEARNINGS.md`](docs/HACKATHON_LEARNINGS.md)** -- strategic playbook. Read before any hackathon.

## Branches

| Branch | Event | Date | Result |
|---|---|---|---|
| `master` | -- | -- | Hackathon-agnostic docs only |
| `medai_2026` | BU MedAI Hackathon 2026 | 2026-04-11 | Did not place; rank 7 on C1 leaderboard |

To list branches: `git branch -a`. To switch: `git checkout <branch>`.

## Starting a new event

See [`docs/BOOTSTRAP.md`](docs/BOOTSTRAP.md) for the full workflow. TL;DR:

```bash
cd ~/Hackathon
git checkout master
git checkout -b <event_slug>
mkdir -p <event_slug>/resources
cp docs/ABOUT_TEMPLATE.md <event_slug>/resources/ABOUT.md
# Edit ABOUT.md, drop organizer materials in resources/
# Edit .gitignore to allow <event_slug>/
git add . && git commit -m "Initial setup for <event_slug>"
```
