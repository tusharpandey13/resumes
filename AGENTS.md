# Resume Workflow — Agent Instructions

See [CONTRIBUTING.md](CONTRIBUTING.md) for the human-facing guide. This file is the authoritative reference for agents.

## Folder Structure

```
resumes/
├── base/                          # Source of truth — do not modify
│   ├── Tushar-Pandey-resume.tex
│   ├── Tushar-Pandey-resume.md    # Full content library (more detail than .tex)
│   └── Tushar-Pandey-resume.pdf
├── 2026/
│   └── <role-type>/
│       └── <company-slug>/
│           ├── Tushar-Pandey-resume.tex
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

3. **Create the output folder**: `2026/<role-type>/<company-slug>/`

4. **Copy and tailor the `.tex`** from `base/Tushar-Pandey-resume.tex`:
   - Rewrite profile summary to speak directly to the role
   - Reorder bullet points to front-load what the JD values most
   - Adjust Technical Skills to lead with relevant technologies
   - Pull in extra detail from `base/Tushar-Pandey-resume.md` if it has content not in the `.tex`
   - Do NOT fabricate experience, metrics, or technologies not in the base files
   - Keep it to 2 pages max

5. **Compile to PDF**:
   ```
   ./compile.sh 2026/<role-type>/<company-slug>/Tushar-Pandey-resume.tex
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

## Rules

- Never modify files under `base/`
- Never invent metrics, technologies, or roles not in the base resume
- Always compile and verify the PDF before committing
- One `.tex` and one `.pdf` per company folder — no `.md` needed for variants
- Always update `README.md` variants table before committing
