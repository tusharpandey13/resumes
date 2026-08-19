---
purpose: Cold outreach to a hiring manager — establish relevance before or after applying
when-to-use: When you can identify the HM directly; most effective before applying or within 48 hours of applying
limit: ~400 words; lead with value, keep the ask small
variables:
  - "{{company}}"       — company display name
  - "{{role}}"          — exact role title from JD
  - "{{contact_name}}"  — first name of the hiring manager
  - "{{shared_context}}"— 1-line hook from analysis.md (shared tech, product angle, relevant signal)
  - "{{why_them}}"      — 1-sentence reason specific to this company/team from analysis.md Company Context
---

Hi {{contact_name}},

I'm reaching out about the {{role}} opening at {{company}}. {{why_them}}.

{{shared_context}}. I'd love to learn more about the team's current focus and share why I think I'd contribute quickly.

Would you be open to a brief chat? I'm happy to work around your schedule.

Thanks,
Tushar
