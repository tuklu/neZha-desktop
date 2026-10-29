return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Disable netrw for cleaner setup
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Line numbers follow global settings (user toggles with :set nu / :set rnu)

    require("nvim-tree").setup({
      view = {
        width = 35,
      },
      renderer = {
        highlight_opened_files = "name",
        indent_markers = {
          enable = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            none = " ",
          },
        },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
          },
          glyphs = {
            folder = {
              arrow_closed = "→",
              arrow_open = "↓",
            },
          },
        },
      },
      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = { enable = false },
        },
      },
    })

    -- Keymaps for explorer controls
    local keymap = vim.keymap
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Focus file explorer on current file" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
  end,
}
