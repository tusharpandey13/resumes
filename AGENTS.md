# Resume Workflow — Agent Instructions

## Overview

This repo contains Tushar Pandey's resume in LaTeX. The base resume lives in `base/`. Tailored variants are saved under `2026/<role-type>/<company-slug>/`.

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
├── compile.sh
└── AGENTS.md
```

## Tailoring Workflow

When given a job description (JD) and company name:

1. **Determine role-type slug** — broad category based on the JD's primary focus, e.g.:
   - `auth-identity` — OAuth, OIDC, SDKs, security
   - `distributed-backend` — high-throughput systems, databases, infrastructure
   - `platform-devtools` — SDKs, DX, developer tooling
   - `fullstack` — frontend + backend product work
   - `staff-eng` — staff/principal, architecture, cross-team

2. **Determine company slug** — lowercase, hyphenated, e.g. `auth0`, `stripe`, `cloudflare`

3. **Create the output folder**: `2026/<role-type>/<company-slug>/`

4. **Copy and tailor the `.tex`** from `base/Tushar-Pandey-resume.tex`:
   - Reorder or emphasise bullet points to match what the JD values most
   - Rewrite profile summary to speak directly to the role
   - Adjust Technical Skills ordering to front-load relevant technologies
   - Pull in extra detail from `base/Tushar-Pandey-resume.md` if the `.md` has content not in the `.tex`
   - Do NOT fabricate experience, metrics, or technologies not already present in base files
   - Keep it to 2 pages max

5. **Compile to PDF**:
   ```
   ./compile.sh 2026/<role-type>/<company-slug>/Tushar-Pandey-resume.tex
   ```

6. **Commit and push**:
   ```
   git add 2026/<role-type>/<company-slug>/
   git commit -m "resume: <role-type>/<company-slug>"
   git push
   ```

## Rules

- Never modify files under `base/`
- Never invent metrics, technologies, or roles not in the base resume
- Always compile and verify the PDF before committing
- One `.tex` and one `.pdf` per company folder — no `.md` needed for variants
