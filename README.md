# Tushar Pandey — Resumes

Tailored resume variants for job applications. Base resume in LaTeX + Markdown; compiled to PDF per role.

&copy; Tushar Pandey. All rights reserved. Content may not be reproduced or adapted without permission.

---

## Pandoc Pipeline (Markdown → PDF)

Edit `src/resume.md`, then run from repo root:

```bash
./scripts/build-resume.sh
```

Output: `Tushar-Pandey-resume.pdf` in repo root.

For a tailored variant (e.g. `2026/auth-identity/stripe/`):

```bash
./scripts/build-resume.sh src/resume.md 2026/auth-identity/stripe/
```

**Prerequisites:** `pandoc` (`brew install pandoc`) + BasicTeX (`pdflatex` at `/Library/TeX/texbin/pdflatex`).

---

## Available Variants

| Variant | Role Type | PDF |
|---------|-----------|-----|
| base | General | [Tushar-Pandey-resume.pdf](base/Tushar-Pandey-resume.pdf) |
| 2026/fullstack/insify | Fullstack / Product Eng | [Tushar-Pandey-resume.pdf](2026/fullstack/insify/Tushar-Pandey-resume.pdf) |

---

## Workflow

See [AGENTS.md](AGENTS.md) for the full tailoring workflow.

**Compile a variant manually:**
```
./compile.sh path/to/Tushar-Pandey-resume.tex
```
