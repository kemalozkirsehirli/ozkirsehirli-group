# Task 1 Playbook — Email organizers

**Owner:** M1 (lead). **Compute:** none. **Wall-clock:** 30 min total.

## Scientific goal

Unblock on-day Onepot/muni/Rowan + submission-format questions before May 9. Without answers we go in blind. Pre-emptively asks the 11 questions we identified pre-event.

## Single command

```bash
cd ~/Hackathon
bash TBXT/experiment_scripts/task1.sh
```

Outputs:
- `report/task1_trial1.json` — short JSON metadata (recipient, hash, char count)
- `data/task1/trial1/email_body.txt` — copy-pasteable email body
- Terminal prints the email body for direct copy-paste

## Done criteria

| Level | Criterion |
|---|---|
| **MIN** | Email sent to `tbxtchallenge@chordoma.org` |
| **TARGET** | Reply received with answers to ≥ 3 of {Q1 onepot, Q5 submission portal, Q9 team size} before T-12h |
| **STRETCH** | All 11 questions answered |

## Hard upload deadline

T-1d 9 am — email sent. Answers may arrive any time.

## Stretch ladder (if no reply)

| Rank | Action |
|---:|---|
| 1 | Phone-call follow-up at T-1d 6 pm if no reply |
| 2 | DM organizer on Luma at T-12h |
| 3 | Ask in person at 1:30 pm announcements on May 9 |

## Escalation

This task is the lead's responsibility. No escalation needed; lead resolves independently.

## What to post in chat

```
✅ DONE: task1 (email sent at YYYY-MM-DD HH:MM to tbxtchallenge@chordoma.org)
```

When replies arrive, post:

```
📧 ORG REPLY: <key answer summary>
```
