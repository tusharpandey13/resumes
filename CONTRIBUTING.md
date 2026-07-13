# Contributing & Usage

## Who this is for

This is a personal resume repository for Tushar Pandey. "Contributing" here means:
- Adding tailored resume variants for new job applications (via an AI agent)
- Updating the base resume when experience changes
- Maintaining the repo structure and index files

---

## Adding a Tailored Variant (via AI Agent)

Trigger the agent (OpenCode, Claude, etc.) with:

1. **The job description** — paste the full JD
2. **The company name** — used for the folder slug
3. **Any extra context** — seniority level, team focus, anything not obvious from the JD

The agent will:
- Determine the role-type and company slug
- Create `2026/<role-type>/<company-slug>/Tushar-Pandey-resume.tex`
- Tailor the content to the JD (reorder bullets, rewrite summary, adjust skills order)
- Compile to PDF
- Update the variants table in `README.md`
- Commit and push

See [AGENTS.md](AGENTS.md) for the exact rules and steps the agent follows.

---

## Updating the Base Resume

When your experience, skills, or projects change:

1. Edit `base/Tushar-Pandey-resume.md` — this is the full content library
2. Edit `base/Tushar-Pandey-resume.tex` — this is the formatted LaTeX source
3. Recompile:
   ```
   ./compile.sh base/Tushar-Pandey-resume.tex
   ```
4. Commit:
   ```
   git add base/
   git commit -m "base: <what changed>"
   git push
   ```

Keep `.md` and `.tex` in sync — the `.md` can have more detail (it's a content library), but anything in `.tex` should also be in `.md`.

---

## Folder & File Conventions

```
2026/<role-type>/<company-slug>/Tushar-Pandey-resume.{tex,pdf}
```

**Role-type slugs:**

| Slug | When to use |
|------|-------------|
| `auth-identity` | OAuth, OIDC, SDKs, security |
| `distributed-backend` | high-throughput systems, databases, infrastructure |
| `platform-devtools` | SDKs, DX, developer tooling |
| `fullstack` | frontend + backend product work |
| `staff-eng` | staff/principal, architecture, cross-team |

If a JD doesn't fit cleanly, use the dominant technical area as the slug (lowercase, hyphenated).

**Company slugs:** lowercase, hyphenated, no punctuation — e.g. `stripe`, `cloudflare`, `morgan-stanley`.

---

## Keeping the Index Files Updated

After adding a variant, two files must be updated:

**`README.md`** — add a row to the variants table:
```markdown
| 2026/auth-identity/stripe | Auth, Identity | [PDF](2026/auth-identity/stripe/Tushar-Pandey-resume.pdf) |
```

**`llms.txt`** — no per-variant updates needed; it describes repo structure, not individual files.

---

## Compile Reference

```bash
# Compile any .tex to PDF in the same directory
./compile.sh path/to/Tushar-Pandey-resume.tex
```

Requires BasicTeX (`pdflatex` at `/Library/TeX/texbin/pdflatex`). Runs two passes for cross-references, cleans aux files automatically.

---

## Git Conventions

| Change | Commit message |
|--------|---------------|
| New tailored variant | `resume: <role-type>/<company-slug>` |
| Base resume update | `base: <what changed>` |
| Docs/structure change | `docs: <what changed>` |
