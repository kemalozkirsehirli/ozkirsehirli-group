# Hackathon Workspace -- Bootstrap

How `~/Hackathon/` is organized and how to start a new event. Read this before reading anything else in this directory.

If you are a new Claude session: also read [HACKATHON_LEARNINGS.md](HACKATHON_LEARNINGS.md) before working.

---

## What this directory is

`~/Hackathon/` is a multi-event git repository. It holds:

- **Hackathon-agnostic content on `master`** -- this guide, the playbook, snippets, checklists. The durable knowledge that applies to any event.
- **Event-specific content on per-event branches** -- one branch per hackathon (`medai_2026`, `hackathon2`, etc.). Each branch holds the master content plus a single event directory.

Master never contains event-specific work. Event branches never modify the agnostic docs (unless adding a new lesson learned, which gets cherry-picked back to master after the event).

---

## Layout

```
~/Hackathon/
├── README.md                         # Top-level index of events
├── .gitignore
├── docs/                             # Agnostic, lives on master
│   ├── BOOTSTRAP.md                  # This file
│   ├── HACKATHON_LEARNINGS.md        # Strategic playbook -- read before any event
│   ├── ABOUT_TEMPLATE.md             # Template for per-event ABOUT.md
│   ├── snippets/                     # Reusable code patterns
│   └── checklists/                   # Pre-event / day-of checklists
└── <event_name>/                     # Only present on the event's branch
    ├── resources/                    # Organizer-provided materials + ABOUT.md
    │   ├── ABOUT.md                  # What you know about this event
    │   ├── starter_code/             # Copied from organizer
    │   ├── data_README.md            # Or whatever they hand you
    │   └── (other organizer materials)
    └── (your work: code, notebooks, scripts, outputs, post_mortem.md)
```

---

## Reading order for a fresh Claude session

When you start a new session in an event directory, point Claude at these files in order:

1. **`~/Hackathon/docs/BOOTSTRAP.md`** (this file) -- understand the system.
2. **`~/Hackathon/docs/HACKATHON_LEARNINGS.md`** -- internalize the strategic lessons.
3. **`~/Hackathon/<event>/resources/ABOUT.md`** -- learn this specific event's goals, rules, deadlines.
4. **`~/Hackathon/<event>/resources/`** (the rest) -- organizer materials.

A paste-able first message to a new Claude session:

> Before working on this hackathon, read these files in order:
> 1. `~/Hackathon/docs/BOOTSTRAP.md`
> 2. `~/Hackathon/docs/HACKATHON_LEARNINGS.md`
> 3. `./resources/ABOUT.md`
> 4. Skim the rest of `./resources/` for organizer-provided materials.
>
> Then confirm what you understand about the event before we start working.

---

## Starting a new event

Step-by-step. Pick a short, unique slug for the event (e.g., `medai_2026`, `kaggle_titanic_2026`, `boston_ai_2026`).

### 1. Create a branch off master

```bash
cd ~/Hackathon
git checkout master
git pull              # if the repo has a remote
git checkout -b <event_slug>
```

### 2. Create the event directory

```bash
mkdir -p <event_slug>/resources
cp docs/ABOUT_TEMPLATE.md <event_slug>/resources/ABOUT.md
# Edit ABOUT.md with what you know.
```

### 3. Drop organizer materials into resources/

Copy starter code, data READMEs, rules PDFs, slide decks -- anything they handed you. Don't modify these files; they're the unmodified inputs.

```bash
cp -r /path/to/organizer/starter_code <event_slug>/resources/
```

### 4. Update `.gitignore` on this branch

Master gitignores all event directories so it stays clean. On your event branch, you need to allow tracking of *your* event dir. Edit `.gitignore` and either:

- Remove the line that excludes `<event_slug>/`, or
- Add a `!<event_slug>/` exception.

```bash
# Remove the line that excludes your event dir from .gitignore
# Then:
git add <event_slug>/ .gitignore
git commit -m "Initial setup for <event_slug>"
```

### 5. Start a Claude session at the event directory

```bash
cd ~/Hackathon/<event_slug>
claude
```

Paste the bootstrap message from the "Reading order" section above.

### 6. Work on the event

All your code, notebooks, scripts, outputs go in `~/Hackathon/<event_slug>/` (anywhere except `resources/`). The `resources/` directory stays as an organizer-provided reference.

---

## After the event

### Within 48 hours: write a post-mortem

```bash
cd ~/Hackathon/<event_slug>
$EDITOR post_mortem.md
```

Use the template in `docs/HACKATHON_LEARNINGS.md` section 11.

### Update the agnostic docs if you learned something durable

If you discovered a new lesson, code snippet, or checklist item that applies to *any* hackathon, port it back to master:

```bash
git checkout master
# Edit docs/HACKATHON_LEARNINGS.md or add to docs/snippets/
git add docs/
git commit -m "Add lesson from <event_slug>"
```

Then optionally rebase your event branch on the updated master so future references stay current.

### Keep the event branch indefinitely

Don't delete event branches. They are the historical record. Each branch is a self-contained snapshot of an event including the version of the playbook you used at the time.

---

## What goes where -- decision rules

| Content | Lives in |
|---|---|
| ML strategy applicable to any hackathon | `docs/HACKATHON_LEARNINGS.md` (master) |
| Filesystem layout, "how to start an event" | `docs/BOOTSTRAP.md` (this file, master) |
| Generic code snippets (calibration, cross-val, etc.) | `docs/snippets/` (master) |
| Pre-event or day-of checklists | `docs/checklists/` (master) |
| Templates (ABOUT.md, post_mortem.md) | `docs/*_TEMPLATE.md` (master) |
| Organizer-provided files (starter code, READMEs, data docs) | `<event>/resources/` (event branch) |
| Your event-specific summary, deadlines, rules | `<event>/resources/ABOUT.md` (event branch) |
| Your code, scripts, notebooks, outputs | `<event>/` excluding `resources/` (event branch) |
| Post-event reflection | `<event>/post_mortem.md` (event branch) |

---

## Common operations

### Switch to another event

```bash
git checkout <other_event_slug>
```

Note: you'll lose access to the current event's files in the working tree until you switch back. Each branch sees only its own event directory.

### List all events

```bash
git branch
```

### Compare two events' agnostic docs (did the playbook change?)

```bash
git diff <event1> <event2> -- docs/
```

### Bring updated master docs into an in-progress event branch

```bash
git checkout <event_slug>
git rebase master
```

### Snapshot from another git repo into this workspace

If you have an external repo to absorb (e.g., your work from a prior hackathon that was its own repo):

```bash
git checkout -b <event_slug>
# Drop the external repo's contents (excluding its .git/) into <event_slug>/
rsync -a --exclude='.git' /path/to/external/repo/ <event_slug>/
# Edit .gitignore to allow tracking of <event_slug>/, then:
git add <event_slug>/ .gitignore
git commit -m "Import <event_slug> work"
```

---

## A note on Claude auto-memory

When you start a Claude session at `~/Hackathon/<event>/`, Claude's auto-memory is keyed to that path. It stays scoped to that single event -- which is correct: facts about your team's compute paths, dataset quirks, and event-specific decisions belong with the event, not with the agnostic system.

Cross-event lessons should be promoted to `docs/HACKATHON_LEARNINGS.md` *manually* after the event. The auto-memory does not, and should not, automatically carry between events.
