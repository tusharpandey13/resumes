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
2. **The company name** — used for the local input folder slug
3. **Any extra context** — seniority level, team focus, anything not obvious from the JD

The agent will:
- Determine the role-type and assign the next dist ID (e.g. `distributed-backend-002`)
- Create `applications/<role-type>/<company-slug>/resume.md` (gitignored, local only)
- Tailor the content to the JD
- Compile: `dist/<role-type>-<NNN>/Tushar-Pandey-resume.pdf` (tracked, pushed)
- Update `APPLICATIONS.md` (gitignored local index)
- Update the variants table in `README.md`
- Commit and push

Only `dist/` and `README.md` are ever committed. Company names stay local.

See [AGENTS.md](AGENTS.md) for the exact rules and steps the agent follows.

---

## Updating the Base Resume

When your experience, skills, or projects change:

1. Edit `src/resume.md` — this is the Pandoc source compiled to PDF
2. Also edit `base/Tushar-Pandey-resume.md` — the full content library
3. Recompile:
   ```bash
   ./scripts/build-resume.sh
   ```
4. Commit:
   ```bash
   git add src/ base/ Tushar-Pandey-resume.pdf
   git commit -m "base: <what changed>"
   git push
   ```

---

## Folder & File Conventions

```
applications/<role-type>/<company-slug>/resume.md          # local input (gitignored)
applications/<role-type>/<company-slug>/Tushar-Pandey-resume.pdf
dist/<role-type>-<NNN>/Tushar-Pandey-resume.pdf            # published output
```

**Role-type slugs:**

| Slug | When to use |
|------|-------------|
| `auth-identity` | OAuth, OIDC, SDKs, security |
| `distributed-backend` | high-throughput systems, databases, infrastructure |
| `platform-devtools` | SDKs, DX, developer tooling |
| `fullstack` | frontend + backend product work |
| `staff-eng` | staff/principal, architecture, cross-team |

**Company slugs:** lowercase, hyphenated, no punctuation — e.g. `stripe`, `cloudflare`, `morgan-stanley`. Used only in `applications/` paths and `APPLICATIONS.md`, never pushed.

**Dist IDs:** `<role-type>-<NNN>` — zero-padded 3-digit counter per role type. Read `dist/` to find the next available number.

---

## APPLICATIONS.md — Local Index

`APPLICATIONS.md` is gitignored. It maps dist IDs to companies and tracks status:

```
distributed-backend-001 | distributed-backend | Notion  | SWE Infrastructure | applied | 2026-07-13
auth-identity-001       | auth-identity       | Stripe  | SWE Auth           | pending | 2026-07-15
```

---

## Compile Reference

```bash
# Build base resume
./scripts/build-resume.sh

# Build a tailored variant (input → dist)
./scripts/build-resume.sh \
  applications/<role-type>/<company-slug>/resume.md \
  dist/<role-type>-<NNN>/

# Legacy: compile a .tex file directly
./compile.sh path/to/Tushar-Pandey-resume.tex
```

**Prerequisites:** `pandoc` (`brew install pandoc`) + BasicTeX (`pdflatex` at `/Library/TeX/texbin/pdflatex`).

---

## Git Conventions

| Change | Commit message |
|--------|---------------|
| New tailored variant | `resume: <role-type>-<NNN>` |
| Base resume update | `base: <what changed>` |
| Docs/structure change | `docs: <what changed>` |
| Pipeline/infra change | `infra: <what changed>` |

Only ever stage `dist/<role-type>-<NNN>/` and `README.md` for resume variant commits.
