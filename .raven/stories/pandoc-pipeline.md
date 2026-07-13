# Story: pandoc-pipeline

## Context

Resume repo currently uses two parallel sources of truth: `base/Tushar-Pandey-resume.tex`
(formatted, compiled directly) and `base/Tushar-Pandey-resume.md` (content library, not
compiled). Tailored variants are `.tex` copies with manual edits. Editing experience/skills
requires touching LaTeX. Goal: make Markdown the single editable source; Pandoc + LaTeX
template handles rendering. Existing `.tex` styling must be preserved exactly.

---

## Objective

One command converts `src/resume.md` → `Tushar-Pandey-resume.pdf` via Pandoc, reproducing
current spacing, sections, and typography; all content edits happen only in Markdown.

---

## Constraints

_(from `project-context.md`)_

- pdflatex only — no xelatex/lualatex
- Never modify `base/`
- `compile.sh` must remain functional (additive, not replaced)
- ATS-safe output required (`pdfgentounicode=1`, no bitmapped fonts)
- 2-page max
- No fabricated content; `src/resume.md` derived verbatim from `base/Tushar-Pandey-resume.md`
- Shell scripts: `set -e`, quote paths, `#!/bin/bash`

---

## Markdown Source Conventions

The Lua filter interprets these structural patterns. **Must be documented and followed exactly.**

### Header block (H1)
```markdown
# Tushar Pandey
+919380611436 | tusharpandey13@gmail.com | [linkedin](url) | [github](url)
```
→ emits the `\begin{center}...\end{center}` heading block with `\textbf{\Huge \scshape}` name
and pipe-separated contact line.

### Section (H2)
```markdown
## Experience
```
→ emits `\section{Experience}` (titlesec formatting picks up automatically).

### Experience entry (H3 + italic subline)
```markdown
### Company Name | Date Range
_Role subtitle | Location_
```
- H3 text split on ` | ` → arg1 (company), arg2 (date)
- Following italic paragraph split on ` | ` → arg3 (role), arg4 (location)
- Emits: `\resumeSubheading{Company Name}{Date Range}{Role subtitle}{Location}`
- Bullet list immediately after → wrapped in `\resumeItemListStart` / `\resumeItemListEnd`
- Each bullet → `\resumeItem{text}`

### Project entry (H3, no italic subline)
```markdown
### **Project Name** | _Tech Stack_
```
- H3 contains bold span + ` | ` + italic span
- Emits: `\resumeProjectHeading{\textbf{Project Name} $|$ \emph{Tech Stack}}{}`
- Bullet list after → same `\resumeItemListStart` / `\resumeItemListEnd` wrapping

### Skills / Profile lists (H2 = "Technical Skills" or "Profile Summary")
```markdown
## Profile Summary

Paragraph text...

## Technical Skills

- **Category**: value, value
```
- Profile Summary paragraph → `\resumeItem{text}` inside `\begin{itemize}[leftmargin=0.15in, label={}]`
- Technical Skills list → `\begin{itemize}[leftmargin=0.15in, label={}, itemsep=2pt, parsep=0pt]`
  with each item as `\resumeItem{\textbf{Category}: value}`

### Experience / Projects list wrappers
All H3 entries grouped under `## Experience` or `## Key Projects` H2 sections are
automatically wrapped in `\resumeSubHeadingListStart` / `\resumeSubHeadingListEnd`.

---

## File Plan

| # | File | Action | Notes |
|---|------|--------|-------|
| 1 | `templates/resume-template.tex` | **Create** | Pandoc LaTeX template; full preamble + custom commands from `base/*.tex`; `$body$` placeholder |
| 2 | `filters/resume.lua` | **Create** | Pandoc Lua filter; AST → custom LaTeX commands per conventions above |
| 3 | `src/resume.md` | **Create** | Markdown source following conventions; content from `base/Tushar-Pandey-resume.md` verbatim |
| 4 | `scripts/build-resume.sh` | **Create** | Single-command build; accepts optional `[src.md]` and `[out-dir]` args |
| 5 | `README.md` | **Update** | Add "Pandoc Pipeline" usage section; keep existing variants table intact |

### File 1 — `templates/resume-template.tex` (detail)

Pandoc template structure:
```latex
% [full preamble from base tex — packages, margins, fancyhdr, titleformat, custom commands]

\begin{document}

$body$

\end{document}
```

Key points:
- All `\newcommand` / `\renewcommand` definitions copied verbatim from `base/Tushar-Pandey-resume.tex`
- Margin settings copied verbatim
- `\pdfgentounicode=1` and `\input{glyphtounicode}` preserved
- Template does NOT contain any content — only preamble + `$body$`
- Use `$if(geometry)$...$endif$` Pandoc variables only if needed; prefer hardcoded margins to match existing exactly

### File 2 — `filters/resume.lua` (detail)

Pandoc Lua filter, executed with `--lua-filter`. Operates on Pandoc AST.

Functions needed:
```
pandoc.Header(1, ...)  → raw LaTeX: \begin{center}...\end{center} heading block
pandoc.Header(2, ...)  → raw LaTeX: \section{name}
pandoc.Header(3, ...)  → detect type (experience vs project), emit subheading command
pandoc.BulletList(...) → wrap with resumeItemListStart/End, each item as \resumeItem{}
pandoc.Para(...)       → if italic-only after H3 → consumed by H3 handler; else passthrough
```

Section-context tracking: filter must track current H2 section to know whether H3 entries
are Experience-type (need italic subline) or Project-type (bold+italic in H3 itself).

Also wraps entire H3 group in `\resumeSubHeadingListStart` / `\resumeSubHeadingListEnd` per
H2 section. Simplest approach: emit list-start with first H3, emit list-end with next H2 or
end of document.

Inline formatting:
- `**bold**` in filter output → `\textbf{}`
- `_italic_` → `\textit{}` / `\emph{}`
- Hyperlinks → `\href{url}{\underline{text}}`
- `$|$` separator used in project headings (raw LaTeX math)

### File 3 — `src/resume.md` (detail)

Content: verbatim from `base/Tushar-Pandey-resume.md`, restructured to follow conventions.

Differences from base `.md`:
- H1 = name only; contact line = plain paragraph below H1
- H3 entries use ` | ` delimiter for company/date and role/location splits
- Italic sublines use `_text | text_` format
- Project H3 entries use `**Name** | _Tech_` format
- Skills use `- **Category**: ...` format (already matches)

### File 4 — `scripts/build-resume.sh` (detail)

```bash
#!/bin/bash
set -e

SRC="${1:-src/resume.md}"
OUTDIR="${2:-.}"
OUTFILE="$OUTDIR/Tushar-Pandey-resume.pdf"

pandoc "$SRC" \
  --template templates/resume-template.tex \
  --lua-filter filters/resume.lua \
  --pdf-engine=pdflatex \
  -o "$OUTFILE"

echo "Done: $OUTFILE"
```

Pandoc must be on PATH. Script runs from repo root.

### File 5 — `README.md` (detail)

Add after existing intro, before variants table:

```markdown
## Pandoc Pipeline (Markdown → PDF)

Edit `src/resume.md`, then:
```
./scripts/build-resume.sh
```
Output: `Tushar-Pandey-resume.pdf` in repo root.

For a variant:
```
./scripts/build-resume.sh src/resume.md 2026/auth-identity/stripe/
```
```

---

## Acceptance Criteria

- [ ] `./scripts/build-resume.sh` runs without error from repo root
- [ ] Output PDF opens and is visually close to `base/Tushar-Pandey-resume.pdf` (sections, fonts, spacing, 2 pages)
- [ ] PDF is ATS-parseable: text selectable, no missing glyphs
- [ ] All 6 sections present: Profile Summary, Experience, Key Projects, Technical Skills, Education, heading block
- [ ] Both Experience entries render with correct 4-field subheading (company, date, role, location)
- [ ] Both Project entries render with bold name + italic tech stack
- [ ] Editing a bullet in `src/resume.md` and re-running produces updated PDF; no `.tex` touch needed
- [ ] `./compile.sh base/Tushar-Pandey-resume.tex` still works (not broken by any changes)
- [ ] `base/` directory untouched
- [ ] `README.md` variants table row count unchanged; new usage section added above it

---

## Open Questions / Risks

| Risk | Mitigation |
|------|-----------|
| Lua filter inline-bold handling — Pandoc AST `Strong`/`Emph` nodes inside H3 | Test H3 parsing in isolation first; emit `pandoc.utils.stringify` for plain text fallback if needed |
| `glyphtounicode` file path — may need absolute path or texmf lookup | Copy `\input{glyphtounicode}` verbatim; pdflatex on system already resolves it for existing `.tex` |
| Pandoc not installed | Add prereq check in `build-resume.sh`; document `brew install pandoc` in README |
| 2-page overflow after Pandoc rendering | Lua filter must not add extra vertical space; test with full content before finalizing |
| Pipe character ` | ` in company/role names | If name contains ` | `, use `--` as fallback delimiter (document in conventions) |
