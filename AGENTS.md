# Resume Workflow — Agent Instructions

See [CONTRIBUTING.md](CONTRIBUTING.md) for the human-facing guide. This file is the authoritative reference for agents.

## Folder Structure

```
resumes/
├── base/                          # Source of truth — do not modify
│   ├── Tushar-Pandey-resume.tex   # Legacy LaTeX source (reference only)
│   ├── Tushar-Pandey-resume.md    # Full content library (more detail than .tex)
│   └── Tushar-Pandey-resume.pdf
├── src/
│   └── resume.md                  # Pandoc source — edit this for base resume changes
├── templates/
│   └── resume-template.tex        # Pandoc LaTeX template (preamble + $body$)
├── filters/
│   └── resume.lua                 # Pandoc Lua filter (MD AST → LaTeX commands)
├── scripts/
│   └── build-resume.sh            # Primary build script
├── 2026/
│   └── <role-type>/
│       └── <company-slug>/
│           ├── resume.md          # Tailored Markdown source
│           └── Tushar-Pandey-resume.pdf
├── AGENTS.md
├── CLAUDE.md
├── CONTRIBUTING.md
├── README.md
├── llms.txt
├── compile.sh                     # Legacy pdflatex script (still works)
└── .gitignore
```

## Tailoring Workflow

When given a job description (JD) and company name:

1. **Determine role-type slug** — broad category based on the JD's primary focus. Canonical list in [CONTRIBUTING.md](CONTRIBUTING.md#folder--file-conventions).

2. **Determine company slug** — lowercase, hyphenated, e.g. `auth0`, `stripe`, `cloudflare`.

3. **Create the output folder**: `2026/<role-type>/<company-slug>/`

4. **Create and tailor `resume.md`** in the output folder, starting from `src/resume.md`:
   - Rewrite profile summary to speak directly to the role
   - Reorder bullet points to front-load what the JD values most
   - Adjust Technical Skills to lead with relevant technologies
   - Pull in extra detail from `base/Tushar-Pandey-resume.md` if it has content not in `src/resume.md`
   - Do NOT fabricate experience, metrics, or technologies not in the base files
   - Keep it to 2 pages max

5. **Compile to PDF** using the Pandoc pipeline:
   ```
   ./scripts/build-resume.sh 2026/<role-type>/<company-slug>/resume.md 2026/<role-type>/<company-slug>/
   ```

6. **Update `README.md`** — add a row to the variants table:
   ```markdown
   | 2026/<role-type>/<company-slug> | <Role Type> | [PDF](2026/<role-type>/<company-slug>/Tushar-Pandey-resume.pdf) |
   ```

7. **Commit and push**:
   ```
   git add 2026/<role-type>/<company-slug>/ README.md
   git commit -m "resume: <role-type>/<company-slug>"
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
- One `resume.md` and one `Tushar-Pandey-resume.pdf` per company folder
- Always update `README.md` variants table before committing
- Source of truth for content: `src/resume.md` (and `base/Tushar-Pandey-resume.md` for extra detail)
- Source of truth for styling: `templates/resume-template.tex` + `filters/resume.lua`
