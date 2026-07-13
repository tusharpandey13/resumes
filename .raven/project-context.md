# project-context.md

## Tech Stack

- **Toolchain**: pdflatex (`/Library/TeX/texbin/pdflatex`), Pandoc (target: ≥ 3.x)
- **Languages**: LaTeX, Markdown, Bash
- **Pandoc extensions**: lua filters, `--pdf-engine=pdflatex`
- **LaTeX class**: `article`, `letterpaper`, `10pt`
- **Key packages**: fullpage, titlesec, enumitem, hyperref, fancyhdr, tabularx, fontenc(T1), glyphtounicode

## Folder Layout

```
resumes/
├── base/               # source of truth — never modify
│   ├── Tushar-Pandey-resume.tex   # canonical styled LaTeX
│   ├── Tushar-Pandey-resume.md    # full content library
│   └── Tushar-Pandey-resume.pdf
├── templates/          # (planned) Pandoc LaTeX template
├── filters/            # (planned) Pandoc Lua filter
├── src/                # (planned) Markdown source for Pandoc pipeline
├── scripts/            # (planned) build script
├── 2026/
│   └── <role-type>/<company-slug>/
│       ├── Tushar-Pandey-resume.tex
│       └── Tushar-Pandey-resume.pdf
├── compile.sh          # existing pdflatex build script
├── AGENTS.md
├── CONTRIBUTING.md
├── README.md
└── llms.txt
```

## Coding Conventions

- Shell scripts: `set -e`, quote all paths, `#!/bin/bash`
- Markdown: ATX headings, no trailing spaces, blank line between blocks
- LaTeX: custom macros in template preamble, not inline
- Commit messages: `resume:`, `base:`, `docs:`, `infra:` prefixes
- File naming: `Tushar-Pandey-resume.{ext}` for all resume outputs
- Variant folders: `2026/<role-type>/<company-slug>/`

## Tooling

- **Compile (existing)**: `./compile.sh path/to/file.tex`
- **Compile (planned)**: `./scripts/build-resume.sh [src] [out]`
- **Lint**: none formal; visual PDF inspection
- **Test**: successful PDF generation + 2-page check

## Security / Auth / Performance Rules

- No personal data beyond what already exists in base/
- PDF must be ATS-parseable (pdfgentounicode=1, no bitmapped fonts)
- Never embed passwords, tokens, or API keys

## Never Do

- Never modify files under `base/`
- Never invent metrics, technologies, or roles not in base resume
- Never commit a broken PDF (always verify before committing)
- Never use xelatex/lualatex — existing workflow uses pdflatex only
- Never break the existing `compile.sh` workflow (additive only)
- Never put volatile/generated content in `project-context.md`
