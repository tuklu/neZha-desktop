-- Replace the raw E211 for vanished files with a readable notice.
-- The buffer is kept, so :w restores the file or <leader>tx drops it.
vim.api.nvim_create_autocmd("FileChangedShell", {
  callback = function(args)
    if vim.v.fcs_reason ~= "deleted" then
      vim.v.fcs_choice = "ask"
      return
    end
    local path = vim.fn.fnamemodify(args.file, ":~:.")
    vim.notify("File deleted or moved: " .. path, vim.log.levels.WARN)
  end,
})
