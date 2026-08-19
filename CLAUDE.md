# Resume Repository — OpenCode Instructions

Read `AGENTS.md` before doing anything. It is the canonical reference for all workflows.

## Current state

- `APPLICATIONS.md` — local index of all applications (gitignored, never push)
- `applications/<role-type>/<company-slug>/` — per-application artifacts (gitignored)
- `dist/<role-type>-<NNN>/` — compiled PDFs (tracked, pushed)

## What you can do

**Intake (JD → full artifact set)**
User pastes a JD. Follow `## Intake Workflow` in AGENTS.md exactly:
parse JD → gap analysis → tailor resume → compile PDF → generate 4 comm texts → write timeline → update APPLICATIONS.md.
Return all 4 comm texts copy-paste ready.

**Query (event context → next steps)**
User describes what happened ("got a reply from recruiter at Notion", "no response from Stripe in 2 weeks").
Follow `## Query Interface` in AGENTS.md exactly:
look up company in APPLICATIONS.md → load application artifacts → map event to decision table → return next step + relevant comm text → append timeline → update status.

**Resume only**
User provides JD without tracking. Follow `## Tailoring Workflow` in AGENTS.md.

## Rules

- Never modify files under `base/`
- Never fabricate experience, metrics, or technologies not in `base/Tushar-Pandey-resume.md`
- Always compile and verify PDF before committing
- Only commit `dist/` and `README.md` — never commit `applications/` or `APPLICATIONS.md`
- Commit prefixes: `resume:` `base:` `docs:` `infra:`
