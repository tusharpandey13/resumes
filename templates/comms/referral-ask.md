---
purpose: Ask an employee at the target company for a referral
when-to-use: After connecting on LinkedIn or when you have a warm contact at the company; send before or shortly after applying
limit: ~500 words; keep it concise and specific
variables:
  - "{{company}}"           — company display name
  - "{{role}}"              — exact role title from JD
  - "{{contact_name}}"      — first name of the person you are asking
  - "{{mutual_connection}}" — shared person or context that bridges the introduction; omit this sentence entirely if cold outreach (no mutual connection)
  - "{{shared_context}}"    — 1-line hook from analysis.md (shared tech, product interest, why this company)
note: If {{mutual_connection}} is unknown/cold, remove the "{{mutual_connection}} suggested I reach out" sentence entirely.
---

Hi {{contact_name}},

I came across the {{role}} role at {{company}} and it aligns closely with what I've been building toward. {{shared_context}}.

[If warm: "{{mutual_connection}} suggested I reach out — "] I'd really appreciate a referral if you think it could be a good fit.

I've attached my resume and am happy to share more context if that would help. No pressure at all — I appreciate you taking a look either way.

Thanks,
Tushar
