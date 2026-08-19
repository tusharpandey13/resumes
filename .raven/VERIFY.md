# Verification Report — app-tracking-workflow

story: app-tracking-workflow
stage: test
verified: 2026-08-19
verifier: agent (claude-sonnet-4.6)

## Results

| # | Criterion | Status | Note |
|---|-----------|--------|------|
| 1 | APPLICATIONS.md has 9-field schema; all existing rows updated with `-` for url/contact/notes | PASS | Line 2 format comment lists all 9 fields. All 13 rows carry `-` in URL, Contact, Notes columns. |
| 2 | `applications/<role-type>/<company-slug>/` folder structure documented in AGENTS.md with all 7 files named and purposes defined | PASS | AGENTS.md lines 162–173: full tree with 9 leaf files (7 new + 2 pre-existing), each with inline purpose comment. |
| 3 | `analysis.md` internal structure defined with 5 sections | PASS | AGENTS.md lines 177–183: Role Summary, Key Requirements, Skill Gaps, Company Context, Intake Notes — all 5 named and described. |
| 4 | `timeline.md` format defined (markdown table, append-only) | PASS | AGENTS.md lines 185–195: append-only rule stated, header row + example row shown, event-type vocabulary listed. |
| 5 | Status vocabulary documented: pending, applied, screening, interviewing, offer, rejected, withdrawn | PASS | AGENTS.md lines 197–209: all 7 values in table with meanings. |
| 6 | `templates/comms/` contains all 4 template files with frontmatter, variable placeholders, and message body | PASS | All 4 files present with YAML frontmatter (purpose/when-to-use/limit/variables), `{{variable}}` placeholders in body, and complete message text. |
| 7 | AGENTS.md `## Intake Workflow` section covers all 9 steps in order | PASS | AGENTS.md lines 229–268: steps 1–9 explicitly numbered and ordered. |
| 8 | Intake workflow output spec: all 4 comm texts returned to user copy-paste ready | PASS | AGENTS.md lines 270–278: "Output to user" block lists all 4 comms in order (LinkedIn, referral, follow-up, HM) formatted for copy-paste. |
| 9 | AGENTS.md `## Query Interface` section covers all 8 agent steps | PASS | AGENTS.md lines 280–328: steps 1–8 explicitly numbered and ordered. |
| 10 | Decision table (event → next action → artifact) present in Query Interface | PASS | AGENTS.md lines 306–313: 3-column table with 6 event rows covering all required cases. |
| 11 | No existing AGENTS.md or CONTRIBUTING.md sections broken or removed | PASS | All 5 original AGENTS.md sections intact: `## Directory Model` (L5), `## Folder Structure` (L23), `## Tailoring Workflow` (L56), `## Markdown Source Conventions` (L105), `## Rules` (L145). CONTRIBUTING.md sections unchanged. |
| 12 | All `{{variable}}` names consistent between templates and Intake Workflow instructions | PASS | Exact match per file: linkedin-connection (`{{company}}`,`{{role}}`,`{{shared_context}}`); referral-ask (+ `{{contact_name}}`,`{{mutual_connection}}`); follow-up-apply (+ `{{applied_date}}`); hiring-manager (+ `{{why_them}}`). All names appear verbatim in AGENTS.md L253–256. |
| 13 | CONTRIBUTING.md APPLICATIONS.md section updated with 9-field example | PASS | CONTRIBUTING.md lines 80–105: format line shows 9 fields, two example rows include URL/Contact/Notes columns, field semantics table and status values documented. |

## Summary

- PASS: 13 / 13
- FAIL: 0 / 13
- SKIP: 0 / 13

All acceptance criteria met. Build artifacts are consistent and complete.
