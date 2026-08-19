# Resume Workflow — Agent Instructions

See [CONTRIBUTING.md](CONTRIBUTING.md) for the human-facing guide. This file is the authoritative reference for agents.

## Directory Model

```
applications/                      # gitignored — input, contains company slugs
└── <role-type>/
    └── <company-slug>/
        ├── resume.md              # Tailored Markdown source
        └── Tushar-Pandey-resume.pdf

dist/                              # tracked — output, no company names
└── <role-type>-<NNN>/
    └── Tushar-Pandey-resume.pdf   # Only the final PDF is published

APPLICATIONS.md                    # gitignored — local index mapping IDs to companies
```

**Key rule:** `applications/` never leaves the machine. `dist/` is what gets pushed. Company names exist only in `applications/` paths and `APPLICATIONS.md`.

## Folder Structure

```
resumes/
├── base/                          # Source of truth — do not modify
│   ├── Tushar-Pandey-resume.tex   # Legacy LaTeX source (reference only)
│   ├── Tushar-Pandey-resume.md    # Full content library (more detail than src/)
│   └── Tushar-Pandey-resume.pdf
├── src/
│   └── resume.md                  # Pandoc source — edit for base resume changes
├── templates/
│   └── resume-template.tex        # Pandoc LaTeX template (preamble + $body$)
├── filters/
│   └── resume.lua                 # Pandoc Lua filter (MD AST → LaTeX commands)
├── scripts/
│   └── build-resume.sh            # Build script
├── dist/                          # Tracked — published PDFs only, opaque IDs
│   └── <role-type>-<NNN>/
│       └── Tushar-Pandey-resume.pdf
├── applications/                  # Gitignored — input sources with company slugs
│   └── <role-type>/
│       └── <company-slug>/
│           ├── resume.md
│           └── Tushar-Pandey-resume.pdf
├── AGENTS.md
├── CLAUDE.md
├── CONTRIBUTING.md
├── README.md
├── llms.txt
├── compile.sh
└── .gitignore
```

## Tailoring Workflow

When given a job description (JD) and company name:

1. **Determine role-type slug** — broad category based on the JD's primary focus. Canonical list in [CONTRIBUTING.md](CONTRIBUTING.md#folder--file-conventions).

2. **Determine company slug** — lowercase, hyphenated, e.g. `auth0`, `stripe`, `cloudflare`.

3. **Assign next dist ID** — read `dist/` to find the highest existing counter for this role-type, increment by 1. Format: `<role-type>-<NNN>` (zero-padded to 3 digits, e.g. `distributed-backend-001`).

4. **Create the input folder**: `applications/<role-type>/<company-slug>/`

5. **Create and tailor `applications/<role-type>/<company-slug>/resume.md`** starting from `src/resume.md`:
   - Rewrite profile summary to speak directly to the role
   - Reorder bullet points to front-load what the JD values most
   - Adjust Technical Skills to lead with relevant technologies
   - Pull in extra detail from `base/Tushar-Pandey-resume.md` if needed
   - Do NOT fabricate experience, metrics, or technologies not in the base files
   - Keep it to 2 pages max

6. **Compile — input to applications, output to dist**:
   ```bash
   ./scripts/build-resume.sh \
     applications/<role-type>/<company-slug>/resume.md \
     dist/<role-type>-<NNN>/
   ```
   Also copy the PDF into the input folder for local reference:
   ```bash
   cp dist/<role-type>-<NNN>/Tushar-Pandey-resume.pdf \
      applications/<role-type>/<company-slug>/Tushar-Pandey-resume.pdf
   ```

7. **Update `APPLICATIONS.md`** (local, gitignored):
   ```
   <role-type>-<NNN> | <role-type> | <Company> | <Role Title> | pending | <YYYY-MM-DD>
   ```

8. **Update `README.md`** — add a row to the variants table:
   ```markdown
   | <role-type>-<NNN> | <Role Type> | [PDF Link](dist/<role-type>-<NNN>/Tushar-Pandey-resume.pdf) |
   ```

9. **Commit and push**:
   ```bash
   git add dist/<role-type>-<NNN>/ README.md
   git commit -m "resume: <role-type>-<NNN>"
   git push
   ```

## Markdown Source Conventions

The Lua filter (`filters/resume.lua`) interprets these structural patterns. Follow exactly.

### Header block (H1 + contact line)
```markdown
# Full Name
phone | email | [linkedin](url) | [github](url)
```

### Section (H2)
```markdown
## Experience
```

### Experience / Education entry (H3 + italic subline)
```markdown
### Role Title | Company Name | Date Range
_Subtitle or team description | City, Country_
```
- **Last ` | `** in H3 separates everything-before from the date. Company names containing ` | ` are handled correctly.
- Italic subline split on **first ` | `** → subtitle (arg3) and location (arg4).
- Bullet list below → `\resumeItemListStart` / `\resumeItemListEnd`.

### Project entry (H3 with bold name + italic tech)
```markdown
### **Project Name** | _Tech Stack_
```

### Skills / Profile Summary
```markdown
## Profile Summary

Paragraph text here.

## Technical Skills

- **Category**: item, item, item
```

## Rules

- Never modify files under `base/`
- Never invent metrics, technologies, or roles not in the base resume
- Always compile and verify the PDF before committing
- Only commit files under `dist/` and `README.md` — never commit `applications/`
- Always update `README.md` variants table and `APPLICATIONS.md` before committing
- Source of truth for content: `src/resume.md` (and `base/Tushar-Pandey-resume.md` for extra detail)
- Source of truth for styling: `templates/resume-template.tex` + `filters/resume.lua`

## Application Data Model

### Per-Application Folder Structure

Each application lives under `applications/<role-type>/<company-slug>/` with the following files:

```
applications/<role-type>/<company-slug>/
├── jd.md                     # raw JD verbatim — paste exactly as received
├── analysis.md               # structured analysis (see sections below)
├── resume.md                 # tailored resume (Pandoc Markdown source)
├── Tushar-Pandey-resume.pdf  # compiled PDF (copied from dist/)
├── comms/
│   ├── linkedin-connection.md  # generated LinkedIn connection note
│   ├── referral-ask.md         # generated referral request message
│   ├── follow-up-apply.md      # generated post-apply follow-up
│   └── hiring-manager.md       # generated cold HM outreach
└── timeline.md               # append-only event log (markdown table)
```

### analysis.md Internal Structure

`analysis.md` contains five sections in this order:

1. **Role Summary** — 2–3 sentences: role title, team context, seniority, primary focus
2. **Key Requirements** — bulleted list of must-have skills and experiences from JD
3. **Skill Gaps** — explicit gaps between JD requirements and base resume; include mitigation notes
4. **Company Context** — stage, product, 1–2 sentence context derived from JD or public knowledge in base/; no invented facts
5. **Intake Notes** — free-form notes from initial processing: edge cases, tailoring decisions, anything worth referencing later

### timeline.md Format

`timeline.md` is an append-only markdown table. New rows are always added at the bottom. Never delete or edit existing rows.

```markdown
| Date       | Event       | Notes                                              |
|------------|-------------|----------------------------------------------------|
| YYYY-MM-DD | <event-type>| <free-form notes>                                  |
```

Event types: `intake`, `applied`, `recruiter-reply`, `screen-scheduled`, `follow-up-sent`, `rejection`, `offer`, `withdrawn`, `other`.

### Status Vocabulary

Use exactly these values in the `Status` field of `APPLICATIONS.md`:

| Status         | Meaning                                          |
|----------------|--------------------------------------------------|
| `pending`      | Resume generated; not yet submitted              |
| `applied`      | Application submitted                            |
| `screening`    | Initial screen scheduled or in progress          |
| `interviewing` | Full interview loop underway                     |
| `offer`        | Offer received                                   |
| `rejected`     | Rejected at any stage                            |
| `withdrawn`    | Application withdrawn voluntarily                |

### APPLICATIONS.md 9-Field Schema

```
ID | role-type | Company | Role Title | Status | Date | URL | Contact | Notes
```

| Field       | Description                                              | Empty value |
|-------------|----------------------------------------------------------|-------------|
| `ID`        | `<role-type>-<NNN>` — matches dist/ folder name         | —           |
| `role-type` | Role-type slug (see CONTRIBUTING.md for canonical list)  | —           |
| `Company`   | Company display name                                     | —           |
| `Role Title`| Exact role title from JD                                 | —           |
| `Status`    | One of the 7 status values above                         | —           |
| `Date`      | Date row was created (`YYYY-MM-DD`)                      | —           |
| `URL`       | Job posting URL if available                             | `-`         |
| `Contact`   | Recruiter or HM name/handle if known                     | `-`         |
| `Notes`     | 1-line context summary from analysis.md                  | `-`         |

## Intake Workflow

**Trigger:** user pastes a job description (JD).

Work through these 9 steps in order. Do not skip steps.

1. **Parse JD** — extract: role title, company name, tech stack, key requirements, seniority level, team context. Store these in memory for steps below.

2. **Research company context** — from JD text and any context inferable from `base/Tushar-Pandey-resume.md`, determine: company stage, product, 1–2 sentence summary. Do not invent facts. If unknown, write "unknown" in Company Context.

3. **Gap analysis** — compare JD key requirements against `base/Tushar-Pandey-resume.md`. List explicit gaps (skills or experiences present in JD but absent or weak in base). For each gap, note a mitigation (adjacent skill, transferable experience, or honest omission).

4. **Write `jd.md`** — create `applications/<role-type>/<company-slug>/jd.md` with the verbatim JD text, no edits.

5. **Write `analysis.md`** — create `applications/<role-type>/<company-slug>/analysis.md` with these 5 sections using data from steps 1–3:
   - `## Role Summary`
   - `## Key Requirements`
   - `## Skill Gaps`
   - `## Company Context`
   - `## Intake Notes`

6. **Run tailoring workflow** — execute `## Tailoring Workflow` steps 1–9 in full: determine role-type slug, company slug, dist ID; create resume.md; compile; update dist/; update README.md; update APPLICATIONS.md (6-field row at this stage); commit and push.

7. **Generate 4 comms** — using templates in `templates/comms/`, fill all `{{variable}}` placeholders with values derived from analysis.md and JD. Write the 4 filled messages to `applications/<role-type>/<company-slug>/comms/`:
   - `linkedin-connection.md` — fill `{{company}}`, `{{role}}`, `{{shared_context}}`
   - `referral-ask.md` — fill `{{company}}`, `{{role}}`, `{{contact_name}}` (use `-` if unknown), `{{mutual_connection}}` (use `-` if none), `{{shared_context}}`
   - `follow-up-apply.md` — fill `{{company}}`, `{{role}}`, `{{contact_name}}` (use `there` if unknown), `{{applied_date}}`, `{{shared_context}}`
   - `hiring-manager.md` — fill `{{company}}`, `{{role}}`, `{{contact_name}}` (use `-` if unknown), `{{shared_context}}`, `{{why_them}}`

8. **Write `timeline.md`** — create `applications/<role-type>/<company-slug>/timeline.md` with header row and first entry:
   ```markdown
   | Date       | Event  | Notes                                                        |
   |------------|--------|--------------------------------------------------------------|
   | YYYY-MM-DD | intake | JD pasted, analysis run, resume generated, comms drafted     |
   ```

9. **Update `APPLICATIONS.md` row** — extend the row written in step 6 to include the 3 new fields:
   - `URL`: job posting URL from JD if present, otherwise `-`
   - `Contact`: recruiter or HM name/handle if identifiable from JD, otherwise `-`
   - `Notes`: 1-line context summary from `analysis.md` Company Context

**Output to user** — after all 9 steps, return:

- Brief summary of gap analysis (key gaps found, mitigations noted)
- Confirmation list of all artifacts created (jd.md, analysis.md, resume.md, PDF, comms/, timeline.md)
- All 4 comm texts formatted for copy-paste, in this order:
  1. LinkedIn connection note
  2. Referral ask
  3. Post-apply follow-up
  4. Hiring manager outreach

## Query Interface

**Trigger:** user provides natural-language event context about a specific company, e.g.:
- "got a reply from the recruiter at Notion"
- "heard back from hiring manager at Stripe, moving to phone screen"
- "no response from Cartesia after 2 weeks"

Work through these 8 steps in order.

1. **Parse company name** — extract company name from user's message. Normalize to match the `Company` column in `APPLICATIONS.md` (case-insensitive, strip punctuation).

2. **Look up in APPLICATIONS.md** — find the row where `Company` matches. Extract: `ID`, `role-type`, current `Status`, `Date`. Derive `company-slug` by listing `applications/<role-type>/` and matching the folder name to the company.

3. **Load application artifacts** — read all of the following in parallel:
   - `applications/<role-type>/<company-slug>/analysis.md`
   - `applications/<role-type>/<company-slug>/timeline.md`
   - `applications/<role-type>/<company-slug>/comms/linkedin-connection.md`
   - `applications/<role-type>/<company-slug>/comms/referral-ask.md`
   - `applications/<role-type>/<company-slug>/comms/follow-up-apply.md`
   - `applications/<role-type>/<company-slug>/comms/hiring-manager.md`
   - Current `APPLICATIONS.md` row for status

4. **Determine event type** — classify the user's event into one of these types: `recruiter-reply`, `screen-scheduled`, `no-response-7d`, `no-response-14d`, `rejection`, `offer`, `other`.

5. **Map event → next action** — use this decision table:

   | Event                | Next Action                                     | Artifact                      |
   |----------------------|-------------------------------------------------|-------------------------------|
   | `recruiter-reply`    | Reply promptly; ask for screen slot             | `follow-up-apply.md` (adapt)  |
   | `screen-scheduled`   | Prep: re-read analysis.md, review gaps          | `analysis.md`                 |
   | `no-response-7d`     | Send follow-up                                  | `follow-up-apply.md`          |
   | `no-response-14d`    | Send HM outreach                                | `hiring-manager.md`           |
   | `rejection`          | Note in timeline; no action required            | —                             |
   | `offer`              | Update status to `offer` in APPLICATIONS.md     | —                             |

6. **Append to `timeline.md`** — add a new row at the bottom of the table in `applications/<role-type>/<company-slug>/timeline.md`:
   ```markdown
   | YYYY-MM-DD | <event-type> | <user-provided notes or brief summary> |
   ```

7. **Update `APPLICATIONS.md` status** — if the event changes status (e.g. `recruiter-reply` → `screening`, `offer` → `offer`, `rejection` → `rejected`), update the `Status` field for this row. If status is unchanged, skip this step.

8. **Return to user:**
   - Current status (from `APPLICATIONS.md` after any update)
   - Recommended next step (one sentence from decision table)
   - Relevant artifact text — if the decision table maps to an artifact, return the filled message text adapted for the current context, ready to copy-paste
   - Timeline so far — the full contents of `timeline.md` for this application

**Edge case — company not found:** if no row in `APPLICATIONS.md` matches the parsed company name, do not guess. Respond: "No application found for `<company-name>`. Run the Intake Workflow first, or provide the role-type and company-slug to locate the folder manually."
