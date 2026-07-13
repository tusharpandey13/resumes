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
