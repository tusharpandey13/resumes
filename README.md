# Resume Pipeline

A Markdown-to-PDF resume system with AI-assisted tailoring. Write your resume once in Markdown, compile to a pixel-perfect PDF with one command, and let an AI agent tailor it to any job description — automatically.

&copy; Tushar Pandey. All rights reserved. Content may not be reproduced or adapted without permission.

---

## What this is

Most resume workflows force a tradeoff: LaTeX gives beautiful output but is hostile to quick edits. Word processors are easy to edit but produce inconsistent results. Markdown-based tools are clean to write but lose typographic control at the PDF stage.

This repo threads that needle. The source of truth is a plain Markdown file (`src/resume.md`). A Pandoc Lua filter translates its structure into custom LaTeX resume commands — `\resumeSubheading`, `\resumeProjectHeading`, `\resumeItemListStart` — preserving the exact spacing, font sizing, and layout of a hand-crafted LaTeX resume. You never touch a `.tex` file to update your experience.

The second layer is an AI agent workflow. Drop a job description in, get a tailored PDF out. The agent reads the JD, reorders bullets to front-load what the role values, rewrites the profile summary, adjusts the skills section, and compiles the PDF — without inventing anything that isn't already in your base resume.

---

## How it works

### The pipeline

```
src/resume.md
    │
    ▼  pandoc --lua-filter filters/resume.lua
    │         --template templates/resume-template.tex
    │         --pdf-engine=pdflatex
    ▼
Tushar-Pandey-resume.pdf
```

**`src/resume.md`** — the only file you edit. Plain Markdown with a small set of structural conventions the Lua filter understands (see below).

**`filters/resume.lua`** — a Pandoc Lua filter that walks the Markdown AST and emits custom LaTeX commands. It maps:
- H1 + contact paragraph → `\begin{center}` heading block
- H2 → `\section{}` (with titlesec formatting)
- H3 + italic subline → `\resumeSubheading{company}{date}{role}{location}`
- H3 with bold name + italic tech → `\resumeProjectHeading{\textbf{name} $|$ \emph{tech}}{}`
- Bullet lists → `\resumeItemListStart` / `\resumeItemListEnd` with `\resumeItem{}`
- Profile Summary and Technical Skills sections → their respective `itemize` environments

**`templates/resume-template.tex`** — a Pandoc LaTeX template containing the full preamble (packages, margins, custom commands) from the original LaTeX source. The body is just `$body$` — Pandoc fills it in.

**`scripts/build-resume.sh`** — wraps the full `pandoc` invocation with prereq checks and sensible defaults.

### The Markdown conventions

The filter relies on a small set of structural patterns. These are the only things you need to know to write or edit the source:

```markdown
# Full Name
phone | email | [linkedin](url) | [github](url)

## Experience

### Role Title | Company Name | Date Range
_Team or product description | City, Country_

- **Bullet heading**: detail detail detail.
- **Another bullet**: detail detail detail.

## Key Projects

### **Project Name** | _Tech Stack_

- What it does and why it matters.

## Technical Skills

- **Category**: item, item, item
```

The only non-obvious rule: the **last** ` | ` in an H3 line is the date separator. This means company names that contain ` | ` (e.g. `Role | Auth0 (Okta) | Date`) work correctly without any escaping.

### Building

```bash
# Prerequisites
brew install pandoc
# BasicTeX: https://tug.org/mactex/morepackages.html

# Build base resume → Tushar-Pandey-resume.pdf in repo root
./scripts/build-resume.sh

# Build a tailored variant (input → dist)
./scripts/build-resume.sh \
  applications/<role-type>/<company-slug>/resume.md \
  dist/<role-type>-<NNN>/
```

---

## AI-assisted tailoring

The real leverage comes from pairing this pipeline with an AI agent. The workflow:

1. **Paste a job description** into a conversation with the agent (OpenCode, Claude, etc.)
2. The agent reads the JD and identifies what the role values most — specific technologies, system properties, team structures
3. It starts from `src/resume.md` and produces a tailored variant:
   - Rewrites the profile summary to speak directly to the role
   - Reorders bullets within each job to front-load the most relevant work
   - Adjusts the Technical Skills section to lead with what the JD emphasizes
   - Pulls in extra detail from `base/Tushar-Pandey-resume.md` (the full content library) where relevant
4. Compiles to `dist/<role-type>-<NNN>/Tushar-Pandey-resume.pdf`
5. Updates `README.md` and pushes

**The constraint that makes this safe:** the agent never fabricates. Every bullet, metric, and technology in the output must exist in the base resume. Tailoring means reordering and reframing — not inventing.

### Privacy model

Input and output directories are decoupled:

- **`applications/`** (gitignored) — company-slug directory names, full Markdown source, intermediate PDFs. Stays on your machine.
- **`dist/`** (tracked) — final PDFs only, named with opaque role-type IDs (`distributed-backend-001`). No company names anywhere in the pushed output.
- **`APPLICATIONS.md`** (gitignored) — local index mapping IDs to companies, roles, and status.

What gets pushed is a PDF behind an opaque ID. What you applied to, and when, never leaves your machine.

---

## Base resume

| Version | Role Type | PDF |
|---------|-----------|-----|
| base | General | [PDF Link](base/Tushar-Pandey-resume.pdf) |

## Tailored variants

| ID | Role Type | PDF |
|----|-----------|-----|
| distributed-backend-001 | Distributed Backend / Infra | [PDF Link](dist/distributed-backend-001/Tushar-Pandey-resume.pdf) |

---

## Repo structure

```
├── src/
│   └── resume.md              # Edit this — Pandoc Markdown source
├── base/
│   ├── Tushar-Pandey-resume.md   # Full content library (more detail than src/)
│   ├── Tushar-Pandey-resume.tex  # Original LaTeX (reference, do not modify)
│   └── Tushar-Pandey-resume.pdf  # Compiled base PDF
├── templates/
│   └── resume-template.tex    # Pandoc LaTeX template
├── filters/
│   └── resume.lua             # Pandoc Lua filter (AST → LaTeX commands)
├── scripts/
│   └── build-resume.sh        # Build script
├── dist/                      # Tracked — published PDFs, opaque IDs
│   └── <role-type>-<NNN>/
│       └── Tushar-Pandey-resume.pdf
├── applications/              # Gitignored — local input, company slugs
│   └── <role-type>/<company-slug>/
│       ├── resume.md
│       └── Tushar-Pandey-resume.pdf
├── .raven/                    # Agent workflow artifacts (project context, stories)
└── compile.sh                 # Legacy pdflatex script (still functional)
```

---

## See also

- [AGENTS.md](AGENTS.md) — full agent instructions: tailoring workflow, directory model, Markdown conventions
- [CONTRIBUTING.md](CONTRIBUTING.md) — human-facing guide: editing the base resume, compile reference, index format
