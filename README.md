# Tushar Pandey — Resumes

Tailored resume variants for job applications. Markdown source compiled to PDF via Pandoc. Designed for AI-assisted tailoring to job descriptions.

&copy; Tushar Pandey. All rights reserved. Content may not be reproduced or adapted without permission.

---

## Pandoc Pipeline (Markdown → PDF)

Edit `src/resume.md`, then run from repo root:

```bash
./scripts/build-resume.sh
```

Output: `Tushar-Pandey-resume.pdf` in repo root.

For a tailored variant:

```bash
./scripts/build-resume.sh 2026/<role-type>/<company-slug>/resume.md 2026/<role-type>/<company-slug>/
```

**Prerequisites:** `pandoc` (`brew install pandoc`) + BasicTeX (`pdflatex` at `/Library/TeX/texbin/pdflatex`).

---

## Available Variants

| Variant | Role Type | PDF |
|---------|-----------|-----|
| base | General | [Tushar-Pandey-resume.pdf](base/Tushar-Pandey-resume.pdf) |
| 2026/fullstack/insify | Fullstack / Product Eng | [Tushar-Pandey-resume.pdf](2026/fullstack/insify/Tushar-Pandey-resume.pdf) |
| 2026/distributed-backend/notion | Distributed Backend / Infra | [Tushar-Pandey-resume.pdf](2026/distributed-backend/notion/Tushar-Pandey-resume.pdf) |

---

## Workflow

See [AGENTS.md](AGENTS.md) for the full tailoring workflow and Markdown source conventions.
See [CONTRIBUTING.md](CONTRIBUTING.md) for the human-facing guide.
