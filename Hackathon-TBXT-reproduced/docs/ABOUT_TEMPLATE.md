# About: <event_name>

Single source of truth for this event. Fill this in *before* the event starts. Update during if rules change.

---

## Basics

- **Event:** <full name>
- **Organizer:** <institution / company>
- **Dates:** <start> -- <end>
- **Time window:** <how many active hours>
- **Format:** <single challenge | multi-challenge | open-ended>
- **Team:** <names, roles>
- **Team slot / ID:** <if applicable>

## Where things live

- **Leaderboard URL:** <link>
- **Submission instructions:** <link or summary>
- **Organizer Slack / Discord / forum:** <link>
- **Data location:** <path or URL>
- **Compute environment:** <local / cloud / cluster -- include login info>

## Challenges (one per challenge if multi-challenge)

### Challenge <N>: <name>

- **Task:** <classification | regression | etc., what's predicted from what>
- **Evaluation metric:** <metric, lower-or-higher-is-better>
- **Baseline:** <published baseline score, if any>
- **Deadline:** <if challenge-specific>
- **Submission format:** <CSV columns | predict.sh | API call>

## Rules and constraints

- **Allowed tools:** <are external LLMs/APIs allowed? specific frameworks required?>
- **Prohibited:** <e.g., training on test data is disqualifying>
- **Compute limits:** <GPU hours, RAM, etc.>
- **Submission cadence:** <unlimited | N per hour | N total>

## Strategy decisions

- **Lock-down time:** <minutes before deadline, no new code after this>
- **Max leaderboard submissions per challenge:** <e.g., 5>
- **Stop-loss rule:** <e.g., if 3 changes in a row don't improve, pivot>
- **Role assignments:**
  - Coder 1: <responsibility>
  - Coder 2: <responsibility>
  - Slides / leaderboard watch: <name>
  - Submission verification: <name>

## Deliverables

- **Submission(s):** <what to submit, where>
- **Presentation:** <required? length? format?>
- **Code release:** <required? what license?>

## Risks and unknowns

- <Each thing you don't yet know. Update as you find out.>

---

*Read [HACKATHON_LEARNINGS.md](../../docs/HACKATHON_LEARNINGS.md) for strategic guidance.*
*Read [BOOTSTRAP.md](../../docs/BOOTSTRAP.md) for filesystem and workflow.*
