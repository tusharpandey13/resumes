## Context

Existing repo is a resume generation pipeline: JD → tailored resume → PDF. The
`applications/<role-type>/<company-slug>/` tree already holds per-application
artifacts (resume.md, PDF) but has no JD, analysis, comms, or lifecycle
tracking. As the application count grows (15+ in APPLICATIONS.md already),
navigating status, communications, and follow-up timing from memory is
untenable. This story adds a full application lifecycle layer on top of the
existing pipeline without touching the compile or dist workflows.

Split into three sub-stories executed in order:
- **A — app-data-model**: data schema and folder structure
- **B — comms-templates**: 4 communication template files + intake workflow
- **C — query-interface**: lifecycle query entrypoint in AGENTS.md

## Objective

Add a file-based application tracking workflow that handles intake (JD → analysis
→ resume → 4 comms) and ongoing lifecycle queries (event context → next steps +
relevant artifact), with all data stored under `applications/` and all agent
instructions in AGENTS.md.

## Constraints

From project-context.md:
- File-based, no DB, no external services
- applications/ gitignored — never committed, never pushed
- Markdown: ATX headings, no trailing spaces, blank lines between blocks
- Commit message prefixes: `docs:` for AGENTS.md/CONTRIBUTING.md changes,
  `infra:` for templates/scripts
- Never break existing tailoring workflow or compile.sh
- No personal data beyond what already exists in base/

Additional constraints from task scope:
- All new agent instructions go in AGENTS.md as new sections — do not remove
  or reorder existing sections
- templates/comms/ mirrors templates/ folder pattern already in repo
- APPLICATIONS.md schema extension must be backward-compatible (new fields
  appended, existing rows updated in place, empty fields allowed as `-`)

## Plan

### Sub-story A — app-data-model

**Step 1 — Extend APPLICATIONS.md schema**
- File: `APPLICATIONS.md`
- Update format comment (line 2): add `URL | Contact | Notes` fields
- Add `-` placeholders for all 15 existing rows that lack these fields
- Result: `ID | role-type | Company | Role Title | Status | Date | URL | Contact | Notes`

**Step 2 — Add `## Application Data Model` section to AGENTS.md**
- File: `AGENTS.md` (append after existing `## Rules` section)
- Define per-application folder structure:
  ```
  applications/<role-type>/<company-slug>/
  ├── jd.md                     # raw JD verbatim
  ├── analysis.md               # structured: role summary, requirements, gaps, company context
  ├── resume.md                 # tailored resume (existing)
  ├── Tushar-Pandey-resume.pdf  # compiled PDF (existing)
  ├── comms/
  │   ├── linkedin-connection.md
  │   ├── referral-ask.md
  │   ├── follow-up-apply.md
  │   └── hiring-manager.md
  └── timeline.md               # append-only event log
  ```
- Define `analysis.md` internal structure (sections: Role Summary, Key
  Requirements, Skill Gaps, Company Context, Intake Notes)
- Define `timeline.md` as a markdown table:
  `| Date | Event | Notes |`
- Define status vocabulary: pending, applied, screening, interviewing, offer,
  rejected, withdrawn
- Define APPLICATIONS.md extended schema with all 9 fields

**Step 3 — Update CONTRIBUTING.md APPLICATIONS.md section**
- File: `CONTRIBUTING.md` (section `## APPLICATIONS.md — Local Index`)
- Update example row to show all 9 fields
- Document new status values and field semantics (URL, Contact, Notes)

### Sub-story B — comms-templates

**Step 4 — Create 4 communication templates**
- Files: `templates/comms/linkedin-connection.md`,
  `templates/comms/referral-ask.md`,
  `templates/comms/follow-up-apply.md`,
  `templates/comms/hiring-manager.md`
- Each template: frontmatter block (purpose, when-to-use, char limit),
  message body with `{{variable}}` placeholders
- Variables shared across templates: `{{company}}`, `{{role}}`, `{{contact_name}}`
- Template-specific vars:
  - linkedin-connection: `{{shared_context}}` (1-line hook from analysis)
  - referral-ask: `{{mutual_connection}}`, `{{shared_context}}`
  - follow-up-apply: `{{applied_date}}`, `{{shared_context}}`
  - hiring-manager: `{{shared_context}}`, `{{why_them}}` (from analysis Company Context)

**Step 5 — Add `## Intake Workflow` section to AGENTS.md**
- File: `AGENTS.md` (append after `## Application Data Model`)
- Full intake sequence (trigger: user pastes JD):
  1. Parse JD → extract: role title, company, tech stack, key requirements,
     seniority level, team context
  2. Research company → populate Company Context in analysis.md (stage, product,
     1-2 sentence context; use only what is inferable from JD or public knowledge
     in base/)
  3. Gap analysis → compare JD requirements to base/Tushar-Pandey-resume.md;
     list explicit gaps and mitigations
  4. Write `applications/<role-type>/<company-slug>/jd.md` (verbatim JD)
  5. Write `applications/<role-type>/<company-slug>/analysis.md`
  6. Run existing tailoring workflow (AGENTS.md `## Tailoring Workflow` steps
     1–9) — resume.md, compile, dist, README, APPLICATIONS.md, commit
  7. Generate 4 comms using templates/comms/* → write to
     `applications/<role-type>/<company-slug>/comms/`
  8. Write `timeline.md` with first entry: `| <date> | intake | JD pasted,
     analysis run, resume generated, comms drafted |`
  9. Update APPLICATIONS.md row: add url (from JD if present), contact (`-`
     if unknown), notes (1-line context summary from analysis)
- Output to user: summary of analysis gaps, confirmation of artifacts created,
  all 4 comm texts (formatted for copy-paste)

### Sub-story C — query-interface

**Step 6 — Add `## Query Interface` section to AGENTS.md**
- File: `AGENTS.md` (append after `## Intake Workflow`)
- Trigger: user provides natural-language event context, e.g.:
  "got a reply from the recruiter at Notion"
  "heard back from hiring manager at Stripe, moving to phone screen"
  "no response from Cartesia after 2 weeks"
- Agent steps:
  1. Parse company name from user context
  2. Look up company in APPLICATIONS.md → find role-type + company-slug + ID
  3. Load: `applications/<role-type>/<company-slug>/analysis.md`,
     `applications/<role-type>/<company-slug>/timeline.md`,
     `applications/<role-type>/<company-slug>/comms/` (all 4 files),
     APPLICATIONS.md row for current status
  4. Determine event type from user context (reply, rejection, screen request,
     offer, silence, etc.)
  5. Map event type → next action using decision table (defined inline in
     AGENTS.md section):
     | Event | Next Action | Artifact |
     |-------|-------------|---------|
     | recruiter reply | reply promptly, ask for screen slot | follow-up-apply.md (adapt) |
     | screen scheduled | prep: reread analysis.md, gaps | analysis.md |
     | no response (7d) | send follow-up | follow-up-apply.md |
     | no response (14d) | send HM outreach | hiring-manager.md |
     | rejection | note in timeline, move on | — |
     | offer | update status=offer in APPLICATIONS.md | — |
  6. Append new event to timeline.md:
     `| <date> | <event-type> | <user-provided notes> |`
  7. Update APPLICATIONS.md status field for this row if status changed
  8. Return to user:
     - Current status (from APPLICATIONS.md)
     - Recommended next step (one sentence)
     - Relevant artifact text (adapted, ready to copy-paste) if applicable
     - Timeline so far (from timeline.md)
- Edge case: company not found in APPLICATIONS.md → prompt user to run intake
  first or provide role-type + slug to locate the folder manually

**Step 7 — Verify consistency**
- Cross-check: all {{variable}} references in templates are named consistently
  in Intake Workflow section
- Cross-check: all file paths referenced in AGENTS.md new sections match the
  data model folder structure defined in Step 2
- No broken references in CONTRIBUTING.md or AGENTS.md cross-links

## Acceptance Criteria

- [ ] APPLICATIONS.md has 9-field schema; all existing rows updated with `-`
      placeholders for url/contact/notes
- [ ] `applications/<role-type>/<company-slug>/` folder structure documented
      in AGENTS.md with all 7 files named and their purposes defined
- [ ] `analysis.md` internal structure defined with 5 sections
- [ ] `timeline.md` format defined (markdown table, append-only)
- [ ] Status vocabulary documented: pending, applied, screening, interviewing,
      offer, rejected, withdrawn
- [ ] `templates/comms/` contains all 4 template files with frontmatter,
      variable placeholders, and message body
- [ ] AGENTS.md `## Intake Workflow` section covers all 9 steps in order
- [ ] Intake workflow output spec: all 4 comm texts returned to user
      ready for copy-paste
- [ ] AGENTS.md `## Query Interface` section covers all 8 agent steps
- [ ] Decision table (event → next action → artifact) present in Query Interface
- [ ] No existing AGENTS.md or CONTRIBUTING.md sections broken or removed
- [ ] All {{variable}} names consistent between templates and Intake Workflow
      instructions
- [ ] CONTRIBUTING.md APPLICATIONS.md section updated with 9-field example

## Files Created / Modified

### Created
- `templates/comms/linkedin-connection.md`
- `templates/comms/referral-ask.md`
- `templates/comms/follow-up-apply.md`
- `templates/comms/hiring-manager.md`

### Modified
- `APPLICATIONS.md` — extended schema, all rows updated
- `AGENTS.md` — 3 new sections appended: Application Data Model, Intake
  Workflow, Query Interface
- `CONTRIBUTING.md` — APPLICATIONS.md section updated with 9-field example
  and status vocabulary

## Design Decisions

1. **No new scripts** — all workflow logic lives in AGENTS.md instructions.
   Agent reads files and acts; no shell automation needed for comms or queries.
   Cost: agent must re-read files on each query. Benefit: zero infra, zero
   maintenance surface.

2. **timeline.md as append-only markdown table** — simplest queryable log
   format. Agent appends rows. No parsing complexity, human-readable.

3. **Separate comms/ subfolder** — keeps comms distinct from resume artifacts.
   Four discrete files (not one comms.md) so agent can reference, adapt, and
   version each independently.

4. **{{variable}} placeholders in templates** — agent fills these at intake
   and at query time. Not shell variables — markdown placeholders that the
   agent replaces with actual values when generating output.

5. **analysis.md written at intake, read at query time** — single source of
   truth for role context. Avoids re-parsing JD on every query.

6. **APPLICATIONS.md schema extension is backward-compatible** — new fields
   appended, empty = `-`. Existing tailoring workflow (steps 7 in Tailoring
   Workflow) continues to work; intake workflow adds the 3 new fields.

7. **Query interface is stateless per call** — agent loads files fresh each
   time. No persistent session or cache. Aligns with file-based constraint.

8. **Company research scoped to JD + base/ only** — no external API calls.
   Company Context in analysis.md is derived from what the JD reveals plus
   any context inferable from base resume (e.g. if candidate worked there).
