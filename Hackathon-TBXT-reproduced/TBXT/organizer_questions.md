# Email — Pre-event questions for organizers

> Email-ready. Suggested recipient: `tbxtchallenge@chordoma.org` (organizer contact for the broader TBXT Challenge; if a hackathon-specific contact exists on luma, use that instead). Suggested cc: muni / Rowan / onepot if separate addresses are listed.

---

**Subject:** Pre-event questions for the TBXT Hit-Identification Hackathon (May 9, Pillar VC)

Hi team,

Thanks for putting on the TBXT hackathon — looking forward to it. We're planning ahead and would appreciate clarification on a few logistics so we can show up ready to use the 5-hour window well. Listed below in priority order; happy to take answers in any form (email, link to a FAQ, or noted at the 1:30 pm announcements).

---

### Tools and access

**1. Onepot library lookup.** How do teams query whether a given compound (SMILES) is in the 3.4B-compound library on the day?
- Web search interface, REST API, batch upload, SMARTS substructure search, or other?
- Per-team access credentials in advance, or activated at the door?
- Approximate query latency (per-compound vs batch)? Useful so we can plan the on-day filter step.

**2. muni.bio platform.** The luma page mentions teams will use muni.
- What does muni.bio expose for this challenge? (Docking? Co-folding? Property prediction? Generative models? Agent orchestration?)
- When does platform access activate — on-day, or available now for pre-event onboarding?
- Is the $250 muni-credits prize equivalent to the standard platform credit unit, and how does that amount compare to typical workflow costs?

**3. Rowan provisioning.** Are participants pre-issued event-specific Rowan credits, or expected to use the public 500-credit free tier? (Asking because DFT/xTB credits can go fast on real-sized systems.)

**4. Compute.** Are any GPU/CPU resources provided at the venue, or do we use our own hardware/cloud throughout?

---

### Submission and judging

**5. Submission portal.** What's the actual mechanism at 7:00 pm — email, web form, in-person handoff, slide deck upload?

**6. Pre-event work and the rationale.** Two related questions:
- May we reference computational work done **before** May 9 in our rationale (e.g. a docking score generated last week against PDB 6F59), or must all evidence come from work done in the 2:00–7:00 pm window?
- If pre-event work is allowed: any disclosure expectation about how much was done in advance?

**7. Disclosed-compound rule.** The brief asks teams to avoid duplication with the Naar dataset. How is this enforced?
- Is exact-SMILES match the threshold, or is there a similarity bound (e.g. Tanimoto > 0.85 against any Naar entry)?
- Can a team resubmit a CF-Labs-validated hit (e.g. `Z795991852`) as one of their 4? Or does prior CF-Labs SPR validation count as "disclosed"?

**8. Demo format at 7:00 pm.** Length per team, slide count expectation, required content?

---

### Logistics

**9. Team size cap.** Luma says "come solo or with a team." Is there an upper bound? We're planning to bring 6–8 people; want to make sure that's allowed.

**10. On-site materials.** Anything we should bring beyond laptops (chargers obviously) — printed reference handouts, ID for prize disbursement, etc.?

**11. Wi-Fi and licensing.** Any restrictions at Pillar VC on commercial-software licensing or third-party API use during the event (Schrödinger, OpenEye, paid LLM APIs)?

---

Thanks again — we'll be there for the 1:00 pm doors, and happy to follow up on any of the above before then if convenient.

Best,
[Your name]
[Team name, if registered]
