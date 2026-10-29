-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap 


-- General Keymaps

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- tab management
vim.keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "New tab layout" })
vim.keymap.set("n", "<A-x>", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<A-l>", "<cmd>tabnext<CR>", { desc = "Next tab layout" })
vim.keymap.set("n", "<A-h>", "<cmd>tabprevious<CR>", { desc = "Previous tab layout" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- text wraping tougle
vim.keymap.set({ "n", "i", "c" }, "<M-z>", function()
    vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle Line Wrap", silent = true })

keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
