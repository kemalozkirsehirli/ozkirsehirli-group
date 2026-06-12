# Team Member Assignment Matrix

**Fill this in once team members are identified. Assignments are independent of the plan — the plan works regardless of who fills which role.**

## Roles

The plan defines 5 functional roles totaling 10 positions. See `TEAM_HANDOFF.md` § 9.

| Role | # | Compute needed | Skills needed | Tasks owned |
|---|:---:|---|---|---|
| Coordinator | 1 | Laptop only | Project management, conda basic | Owns LIVE_TRACKER, runs convergence meeting |
| GPU-compute owner | 4 | A100 + 28-core CPU | Python + conda + read scripts | 1–2 of {Task 2, 4, 5, 7, 8} each |
| CPU-compute owner | 1 | 28-core CPU (GPU optional) | Same | Tasks 3 + 6 |
| Chemist | 2 | Laptop fine | Medicinal chem, SMILES literacy | T-12h curation + on-day Task 11 |
| Slides + presenter | 2 | Laptop with PyMOL | PyMOL + slide tools, demo confidence | Tasks 9, 11 |

## Assignment table — FILL IN

| Position | Member name | Email/contact | Time-zone | Available hours | Tasks assigned | Backup |
|:---:|---|---|---|---|---|---|
| Coordinator | <TBD> | <TBD> | <TBD> | <TBD> | LIVE_TRACKER + convergence | <TBD> |
| GPU-1 | <TBD> | <TBD> | <TBD> | <TBD> | Task 2 (multi-seed GNINA) | <TBD> |
| GPU-2 | <TBD> | <TBD> | <TBD> | <TBD> | Task 4 (Boltz full pool) | <TBD> |
| GPU-3 | <TBD> | <TBD> | <TBD> | <TBD> | Task 5 (MMGBSA fix) + Task 8 (FEP) | <TBD> |
| GPU-4 | <TBD> | <TBD> | <TBD> | <TBD> | Task 7 (Generative scale) | <TBD> |
| CPU-1 | <TBD> | <TBD> | <TBD> | <TBD> | Task 3 (Site-A pool) + Task 6 (Selectivity dock) | <TBD> |
| Chemist-1 | <TBD> | <TBD> | <TBD> | <TBD> | T-12h curation, on-day chem-flag | <TBD> |
| Chemist-2 | <TBD> | <TBD> | <TBD> | <TBD> | T-12h curation, on-day chem-flag | <TBD> |
| Slides | <TBD> | <TBD> | <TBD> | <TBD> | Task 9 (renders + slides), demo verification | <TBD> |
| Presenter | <TBD> | <TBD> | <TBD> | <TBD> | Task 11 (on-day playbook owner), 7 pm demo | <TBD> |

## Cross-cutting tasks (no specific owner, claim as you go)

| Task | Owner | Status |
|---|---|---|
| Task 0 (env distribution) | <TBD> | <TBD> |
| Task 1 (email organizers) | Coordinator usually | <TBD> |
| Task 10 (consensus aggregation) | Coordinator + Chemist-1 | <TBD> |

## How to fill this in

1. Coordinator collects names + skills + compute access.
2. Map skills → roles using the table above.
3. Fill in all `<TBD>` entries.
4. Post the filled MEMBERS.md to the team channel.
5. Each member opens their assigned task brief (`dashboard/<NN>_*.md`) and follows the "How to run" section.
