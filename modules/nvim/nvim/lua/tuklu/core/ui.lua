local tree_bg   = "#202227"
local editor_bg = "#25272d"

local function apply_highlights()
  -- Float windows
  vim.api.nvim_set_hl(0, "FloatBorder",  { fg = "#F45666", bg = tree_bg })
  vim.api.nvim_set_hl(0, "NormalFloat",  { bg = tree_bg })

  -- Window separator (between Nvim-Tree & editor)
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = tree_bg, bg = tree_bg })

  -- BufferLine (tabs) styling
  vim.api.nvim_set_hl(0, "BufferLineFill",                { bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineBackground",          { bg = tree_bg, fg = "#888888" })
  -- Offset area (file explorer header) separator — blend with tree_bg
  vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator",     { fg = tree_bg,   bg = tree_bg })
  -- BufferLine diagnostics: strip undercurl so icons don't get red squiggles
  vim.api.nvim_set_hl(0, "BufferLineError",                    { fg = "#e06c75", bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineErrorDiagnostics",         { fg = "#e06c75", bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineErrorSelected",            { fg = "#e06c75", bg = editor_bg })
  vim.api.nvim_set_hl(0, "BufferLineErrorDiagnosticsSelected", { fg = "#e06c75", bg = editor_bg })
  vim.api.nvim_set_hl(0, "BufferLineWarning",                    { fg = "#e5c07b", bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineWarningDiagnostics",         { fg = "#e5c07b", bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineWarningSelected",            { fg = "#e5c07b", bg = editor_bg })
  vim.api.nvim_set_hl(0, "BufferLineWarningDiagnosticsSelected", { fg = "#e5c07b", bg = editor_bg })
  vim.api.nvim_set_hl(0, "BufferLineInfo",                    { fg = "#61afef", bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineInfoDiagnostics",         { fg = "#61afef", bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineInfoSelected",            { fg = "#61afef", bg = editor_bg })
  vim.api.nvim_set_hl(0, "BufferLineInfoDiagnosticsSelected", { fg = "#61afef", bg = editor_bg })
  -- Inactive tabs: separators hidden, close button hidden
  vim.api.nvim_set_hl(0, "BufferLineSeparator",           { fg = tree_bg,   bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible",    { fg = tree_bg,   bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineIndicatorVisible",    { fg = tree_bg,   bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineCloseButton",         { fg = tree_bg,   bg = tree_bg })
  -- Active tab: distinct bg, subtle side separators, no underline
  vim.api.nvim_set_hl(0, "BufferLineBufferSelected",      { bg = editor_bg, fg = "#FFFFFF", bold = true })
  vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected",   { fg = "#3a3d45", bg = tree_bg })
  vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected",   { fg = editor_bg, bg = editor_bg })
  vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", { fg = "#FFFFFF", bg = editor_bg })

  -- Nvim-Tree styling
  vim.api.nvim_set_hl(0, "NvimTreeNormal",           { bg = tree_bg, fg = "#b0b0b0" })
  vim.api.nvim_set_hl(0, "NvimTreeNormalNC",         { bg = tree_bg, fg = "#b0b0b0" })
  vim.api.nvim_set_hl(0, "NvimTreeWinSeparator",     { fg = tree_bg, bg = tree_bg })
  vim.api.nvim_set_hl(0, "NvimTreeIndentMarker",     { fg = "#3B3FCF" })
  vim.api.nvim_set_hl(0, "NvimTreeFolderIcon",       { fg = "#AAAAAA" })
  vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#FFD87F", bold = true })
  vim.api.nvim_set_hl(0, "NvimTreeRootFolder",       { fg = "#FFFFFF", bold = true })
  vim.api.nvim_set_hl(0, "NvimTreeSignColumn",       { bg = tree_bg })
  vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer",      { bg = tree_bg, fg = tree_bg })
  vim.api.nvim_set_hl(0, "NvimTreeCursorLine",       { bg = "#2a2d34" })
  vim.api.nvim_set_hl(0, "NvimTreeCursorLineNr",     { bg = "#2a2d34", fg = "#C0CAF5", bold = true })
  vim.api.nvim_set_hl(0, "NvimTreeLineNr",           { bg = tree_bg, fg = "#565F89" })
  vim.api.nvim_set_hl(0, "NvimTreeLineNrAbove",     { bg = tree_bg, fg = "#565F89" })
  vim.api.nvim_set_hl(0, "NvimTreeLineNrBelow",     { bg = tree_bg, fg = "#565F89" })
  vim.api.nvim_set_hl(0, "NvimTreeStatusLine",       { bg = tree_bg, fg = tree_bg })
  vim.api.nvim_set_hl(0, "NvimTreeStatusLineNC",     { bg = tree_bg, fg = tree_bg })

  -- Override main editor background (Normal = focused, NormalNC = unfocused)
  vim.api.nvim_set_hl(0, "Normal",        { bg = editor_bg })
  vim.api.nvim_set_hl(0, "NormalNC",      { bg = editor_bg })
  -- Gutter: pin bg so line numbers / signs don't look like a separate panel
  vim.api.nvim_set_hl(0, "LineNr",        { bg = editor_bg, fg = "#565F89" })
  vim.api.nvim_set_hl(0, "LineNrAbove",   { bg = editor_bg, fg = "#565F89" })
  vim.api.nvim_set_hl(0, "LineNrBelow",   { bg = editor_bg, fg = "#565F89" })
  vim.api.nvim_set_hl(0, "CursorLineNr",  { bg = editor_bg, fg = "#C0CAF5", bold = true })
  vim.api.nvim_set_hl(0, "SignColumn",    { bg = editor_bg })
  vim.api.nvim_set_hl(0, "FoldColumn",    { bg = editor_bg })
end

-- Apply now and re-apply after every colorscheme load
-- (colorscheme plugin loads after core and would otherwise overwrite these)
apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })

-- Ensure Nvim-Tree window always uses tree highlights via winhighlight
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.opt_local.winhighlight = table.concat({
      "Normal:NvimTreeNormal",
      "NormalNC:NvimTreeNormalNC",
      "CursorLine:NvimTreeCursorLine",
      "CursorLineNr:NvimTreeCursorLineNr",
      "LineNr:NvimTreeLineNr",
      "LineNrAbove:NvimTreeLineNrAbove",
      "LineNrBelow:NvimTreeLineNrBelow",
      "SignColumn:NvimTreeSignColumn",
      "EndOfBuffer:NvimTreeEndOfBuffer",
      "StatusLine:NvimTreeStatusLine",
      "StatusLineNC:NvimTreeStatusLineNC",
    }, ",")
  end,
})
