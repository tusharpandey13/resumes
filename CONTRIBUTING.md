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
- Create `2026/<role-type>/<company-slug>/resume.md` tailored to the JD
- Compile to PDF via the Pandoc pipeline
- Update the variants table in `README.md`
- Commit and push

See [AGENTS.md](AGENTS.md) for the exact rules and steps the agent follows.

---

## Updating the Base Resume

When your experience, skills, or projects change:

1. Edit `src/resume.md` — this is the Pandoc source compiled to PDF
2. Also edit `base/Tushar-Pandey-resume.md` — the full content library (may have more detail)
3. Recompile:
   ```
   ./scripts/build-resume.sh
   ```
4. Commit:
   ```
   git add src/ base/ Tushar-Pandey-resume.pdf
   git commit -m "base: <what changed>"
   git push
   ```

Keep `src/resume.md` and `base/Tushar-Pandey-resume.md` in sync. The `base/` file can carry extra detail not on the active resume; `src/resume.md` is what actually compiles.

---

## Folder & File Conventions

```
2026/<role-type>/<company-slug>/resume.md          # Markdown source (tailored)
2026/<role-type>/<company-slug>/Tushar-Pandey-resume.pdf
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

After adding a variant, update `README.md` — add a row to the variants table:
```markdown
| 2026/auth-identity/stripe | Auth, Identity | [PDF](2026/auth-identity/stripe/Tushar-Pandey-resume.pdf) |
```

---

## Compile Reference

```bash
# Build base resume (Pandoc pipeline — primary)
./scripts/build-resume.sh

# Build a tailored variant
./scripts/build-resume.sh 2026/<role-type>/<company-slug>/resume.md 2026/<role-type>/<company-slug>/

# Legacy: compile a .tex file directly (pdflatex)
./compile.sh path/to/Tushar-Pandey-resume.tex
```

**Pandoc pipeline prerequisites:** `pandoc` (`brew install pandoc`) + BasicTeX (`pdflatex` at `/Library/TeX/texbin/pdflatex`).

---

## Git Conventions

| Change | Commit message |
|--------|---------------|
| New tailored variant | `resume: <role-type>/<company-slug>` |
| Base resume update | `base: <what changed>` |
| Docs/structure change | `docs: <what changed>` |
| Pipeline/infra change | `infra: <what changed>` |
