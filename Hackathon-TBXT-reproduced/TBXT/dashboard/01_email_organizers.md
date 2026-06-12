# Task 1 — Email organizers (Tier-1 unblocker)

**Owner:** Coordinator. **Compute:** none. **Effort:** 1 h. **Blocks:** Task 11 (on-day playbook).

## What you're solving

Five questions block our on-day workflow. Three of them (Onepot library access, muni.bio capability, Rowan provisioning) are gating for Task 11. We need answers as early as possible.

The email body is already drafted at `organizer_questions.md` in the repo root. Send it now.

## How to run

1. Open `organizer_questions.md`. Review the 11 questions; remove any that no longer apply.
2. Address the email to:
   - **Primary:** `tbxtchallenge@chordoma.org` (the experimental-program contact; likely also relevant for the hackathon)
   - **Cc, if separate addresses are listed:** muni / Rowan / onepot from the luma event page
3. Subject: `Pre-event questions for the TBXT Hit-Identification Hackathon (May 9, Pillar VC)`
4. Send.

## Success criteria

- Email sent.
- Answer received for at least Q1 (Onepot library access mechanism), Q5 (submission portal), Q9 (team size).
- Answer logged in `LIVE_TRACKER.md` Task 1 section.

## What to post in LIVE_TRACKER.md

```
[YYYY-MM-DD HH:MM] <Coordinator>  STATUS=in-progress
RESULT: email sent to tbxtchallenge@chordoma.org at <time>
DELIVERABLE: -
GOTCHAS: -
NEXT: monitor inbox; follow up if no response in 24 h
```

When responses arrive, update with the actual answers:

```
[YYYY-MM-DD HH:MM] <Coordinator>  STATUS=done
RESULT: Q1 (onepot access)=<answer>, Q5 (submission portal)=<answer>, Q9 (team size)=<answer>, ...
DELIVERABLE: thread in <email/Slack>
GOTCHAS: <if any answers change our plan>
NEXT: propagate any plan-changing answers to all task owners
```

## Plan changes triggered by answers

Watch for these specifically and announce to the team if they happen:

| If they say | Then we | Notify |
|---|---|---|
| "Onepot only does exact-SMILES lookup, not substructure" | Skip pharmacophore-screen plans for the day; rely on our 570 pre-screened pool through their lookup | All compute owners |
| "muni.bio is REQUIRED for the workflow / submission" | All members register on muni.bio before May 9 | All members |
| "Rowan has 5 000 free credits per team" | Use Rowan as a 6th orthogonal scoring signal on top picks | Task 10 owner |
| "Pre-event computational work is NOT allowed in the rationale" | Strip pre-event analysis from the demo; redo the 4-pick from scratch on the day with the same pipeline | Task 11 owner — major plan rework |
| "Tanimoto > 0.85 to disclosed = auto-disqualify" | Re-check our 4-pick against the disclosed set with this threshold; tighten to 0.80 if needed | Task 10 owner |
| "Solo + team submissions both allowed, no team size cap" | We're fine | — |

## If they don't respond in 24 h

- Try again with a shorter version (Q1 + Q5 only).
- Phone the listed contact if any.
- Plan B: assume worst case (Onepot is in-person on the day, format is slide-upload, allowed-tools are unrestricted).

## Notes

This is the **single highest-leverage hour** in the plan: a 30-min email can save 3 hours of guessed-wrong on the day. Don't skip.
