-- resume.lua
-- Pandoc Lua filter: transforms resume Markdown AST → custom LaTeX commands.
-- Conventions (see stories/pandoc-pipeline.md for full spec):
--   H1          → \begin{center} heading block (name + contacts)
--   H2          → \section{}; opens/closes \resumeSubHeadingListStart blocks
--   H3 + italic → \resumeSubheading{company}{date}{role}{location}
--   H3 bold|ita → \resumeProjectHeading{\textbf{name} $|$ \emph{tech}}{}
--   BulletList  → \resumeItemListStart … \resumeItemListEnd with \resumeItem{}
--   Profile/Skills lists handled via section-context tracking

local stringify = pandoc.utils.stringify

-- ── helpers ──────────────────────────────────────────────────────────────────

-- Render Inline list to LaTeX string, preserving bold/italic/links.
local function inlines_to_latex(inlines)
  local result = {}
  for _, el in ipairs(inlines) do
    if el.t == "Str" then
      local s = el.text
      s = s:gsub("%%", "\\%%")
      s = s:gsub("%$", "\\$")
      s = s:gsub("&",  "\\&")
      s = s:gsub("#",  "\\#")
      -- underscore: only escape when not already escaped
      s = s:gsub("([^\\])_", "%1\\_")
      s = s:gsub("^_", "\\_")
      s = s:gsub("%^", "\\^{}")
      s = s:gsub("~",  "\\~{}")
      table.insert(result, s)
    elseif el.t == "Space" then
      table.insert(result, " ")
    elseif el.t == "SoftBreak" or el.t == "LineBreak" then
      table.insert(result, " ")
    elseif el.t == "Strong" then
      table.insert(result, "\\textbf{" .. inlines_to_latex(el.content) .. "}")
    elseif el.t == "Emph" then
      table.insert(result, "\\textit{" .. inlines_to_latex(el.content) .. "}")
    elseif el.t == "Link" then
      local url   = el.target
      local label = inlines_to_latex(el.content)
      table.insert(result, "\\href{" .. url .. "}{\\underline{" .. label .. "}}")
    elseif el.t == "Code" then
      table.insert(result, "\\texttt{" .. el.text .. "}")
    elseif el.t == "RawInline" and el.format == "latex" then
      table.insert(result, el.text)
    else
      table.insert(result, stringify({el}))
    end
  end
  return table.concat(result)
end

-- Extract inlines from a Para or Plain block.
local function block_to_latex(block)
  if block.t == "Para" or block.t == "Plain" then
    return inlines_to_latex(block.content)
  end
  return ""
end

-- Split on LAST occurrence of sep.
local function split_last(s, sep)
  local last_i = nil
  local start  = 1
  while true do
    local i = s:find(sep, start, true)
    if not i then break end
    last_i = i
    start  = i + #sep
  end
  if last_i then
    return s:sub(1, last_i - 1):match("^%s*(.-)%s*$"),
           s:sub(last_i + #sep):match("^%s*(.-)%s*$")
  end
  return s:match("^%s*(.-)%s*$"), ""
end

-- Split on FIRST occurrence of sep.
local function split_first(s, sep)
  local i = s:find(sep, 1, true)
  if i then
    return s:sub(1, i - 1):match("^%s*(.-)%s*$"),
           s:sub(i + #sep):match("^%s*(.-)%s*$")
  end
  return s:match("^%s*(.-)%s*$"), ""
end

-- Check whether a Para/Plain contains only a single Emph node.
local function is_italic_para(block)
  if block.t ~= "Para" and block.t ~= "Plain" then return false end
  local non_space = 0
  local has_emph  = false
  for _, el in ipairs(block.content) do
    if el.t ~= "Space" and el.t ~= "SoftBreak" then
      non_space = non_space + 1
      if el.t == "Emph" then has_emph = true end
    end
  end
  return non_space == 1 and has_emph
end

-- Extract text from first Emph inside a Para/Plain.
local function emph_text_from_para(block)
  for _, el in ipairs(block.content) do
    if el.t == "Emph" then
      return inlines_to_latex(el.content)
    end
  end
  return ""
end

-- Detect project H3: heading contains both Strong and Emph nodes.
local function is_project_heading(inlines)
  local has_strong = false
  local has_emph   = false
  for _, el in ipairs(inlines) do
    if el.t == "Strong" then has_strong = true end
    if el.t == "Emph"   then has_emph   = true end
  end
  return has_strong and has_emph
end

-- Extract bold and italic parts from project H3 inlines.
local function parse_project_heading(inlines)
  local bold_parts = {}
  local emph_parts = {}
  for _, el in ipairs(inlines) do
    if el.t == "Strong" then
      table.insert(bold_parts, inlines_to_latex(el.content))
    elseif el.t == "Emph" then
      table.insert(emph_parts, inlines_to_latex(el.content))
    end
  end
  return table.concat(bold_parts, " "), table.concat(emph_parts, ", ")
end

-- Render a BulletList's items into LaTeX resumeItem lines.
-- Returns a single string (no trailing newline).
local function render_bullet_list(bullet_list)
  local lines = { "\\resumeItemListStart" }
  for _, item in ipairs(bullet_list.content) do
    local item_text = ""
    -- Items in tight lists use Plain; loose lists use Para.
    if #item > 0 then
      item_text = block_to_latex(item[1])
    end
    table.insert(lines, "  \\resumeItem{" .. item_text .. "}")
  end
  table.insert(lines, "\\resumeItemListEnd")
  return table.concat(lines, "\n")
end

-- ── main filter ──────────────────────────────────────────────────────────────

function Pandoc(doc)
  local blocks = doc.blocks
  local out    = {}
  local i      = 1
  local cur_section         = nil
  local in_subheading_list  = false
  local in_plain_list       = false

  -- Emit a single RawBlock. Use this for all output to avoid inter-block blanks.
  local function raw(s)
    table.insert(out, pandoc.RawBlock("latex", s))
  end

  local function close_plain_list()
    if in_plain_list then
      raw("\\end{itemize}\n")
      in_plain_list = false
    end
  end

  local function close_subheading_list()
    if in_subheading_list then
      raw("\\resumeSubHeadingListEnd\n")
      in_subheading_list = false
    end
  end

  local function open_subheading_list()
    if not in_subheading_list then
      raw("\\resumeSubHeadingListStart")
      in_subheading_list = true
    end
  end

  while i <= #blocks do
    local block = blocks[i]

    -- ── H1: name + contact ──────────────────────────────────────────────────
    if block.t == "Header" and block.level == 1 then
      local name = inlines_to_latex(block.content)
      local contact_line = ""
      if i + 1 <= #blocks and (blocks[i+1].t == "Para" or blocks[i+1].t == "Plain") then
        i = i + 1
        contact_line = inlines_to_latex(blocks[i].content)
        -- Replace " | " separators with LaTeX math pipe
        contact_line = contact_line:gsub(" | ", " $|$ ")
      end
      raw(
        "%-----------HEADING----------\n" ..
        "\\begin{center}\n" ..
        "\\textbf{\\Huge \\scshape " .. name .. "} \\\\ \\vspace{4pt}\n" ..
        "\\small " .. contact_line .. "\n" ..
        "\\end{center}\n"
      )
      i = i + 1

    -- ── H2: section ─────────────────────────────────────────────────────────
    elseif block.t == "Header" and block.level == 2 then
      close_plain_list()
      close_subheading_list()
      cur_section = stringify(block.content)
      local sec_label = inlines_to_latex(block.content)

      if cur_section == "Profile Summary" then
        raw(
          "%%-----------" .. cur_section:upper() .. "-----------\n" ..
          "\\section{" .. sec_label .. "}\n" ..
          "\\begin{itemize}[leftmargin=0.15in, label={}]"
        )
        in_plain_list = true
      elseif cur_section == "Technical Skills" then
        raw(
          "%%-----------" .. cur_section:upper() .. "-----------\n" ..
          "\\section{" .. sec_label .. "}\n" ..
          "\\begin{itemize}[leftmargin=0.15in, label={}, itemsep=2pt, parsep=0pt]"
        )
        in_plain_list = true
      else
        raw(
          "%%-----------" .. cur_section:upper() .. "-----------\n" ..
          "\\section{" .. sec_label .. "}\n"
        )
      end
      i = i + 1

    -- ── H3: experience or project entry ─────────────────────────────────────
    elseif block.t == "Header" and block.level == 3 then
      open_subheading_list()

      if is_project_heading(block.content) then
        -- Project: H3 = "**Name** | _Tech_"
        local bold_text, emph_text = parse_project_heading(block.content)
        local heading_arg = "\\textbf{" .. bold_text .. "} $|$ \\emph{" .. emph_text .. "}"
        i = i + 1

        local bullets = ""
        if i <= #blocks and blocks[i].t == "BulletList" then
          bullets = "\n" .. render_bullet_list(blocks[i])
          i = i + 1
        end
        raw("\\resumeProjectHeading\n    {" .. heading_arg .. "}{}" .. bullets .. "\n")

      else
        -- Experience / Education: H3 = "Title | Company | Date" (last pipe = date)
        local h3_text = inlines_to_latex(block.content)
        local company, date = split_last(h3_text, " | ")
        i = i + 1

        -- Optional italic subline: "Role | Location"
        local role, location = "", ""
        if i <= #blocks and is_italic_para(blocks[i]) then
          local sub = emph_text_from_para(blocks[i])
          role, location = split_first(sub, " | ")
          i = i + 1
        end

        local bullets = ""
        if i <= #blocks and blocks[i].t == "BulletList" then
          bullets = "\n" .. render_bullet_list(blocks[i])
          i = i + 1
        end

        raw(
          "\\resumeSubheading\n" ..
          "  {" .. company .. "}{" .. date .. "}\n" ..
          "  {" .. role .. "}{" .. location .. "}" ..
          bullets .. "\n"
        )
      end

    -- ── Para inside Profile Summary ──────────────────────────────────────────
    elseif block.t == "Para" and cur_section == "Profile Summary" then
      local text = inlines_to_latex(block.content)
      raw("\\resumeItem{" .. text .. "}")
      i = i + 1

    -- ── BulletList inside Technical Skills ───────────────────────────────────
    elseif block.t == "BulletList" and cur_section == "Technical Skills" then
      local lines = {}
      for _, item in ipairs(block.content) do
        local item_text = ""
        if #item > 0 then
          item_text = block_to_latex(item[1])
        end
        table.insert(lines, "  \\resumeItem{" .. item_text .. "}")
      end
      raw(table.concat(lines, "\n"))
      i = i + 1

    -- ── HorizontalRule: skip ─────────────────────────────────────────────────
    elseif block.t == "HorizontalRule" then
      i = i + 1

    else
      table.insert(out, block)
      i = i + 1
    end
  end

  close_plain_list()
  close_subheading_list()

  return pandoc.Pandoc(out, doc.meta)
end
