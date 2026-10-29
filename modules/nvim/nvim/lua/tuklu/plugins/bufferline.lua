return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        separator_style = "thin",
        indicator = { style = "underline" },
        show_buffer_close_icons = true,
        show_close_icon = false,
        diagnostics = "nvim_lsp",

        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },

        close_command = function(bufnr)
          local is_current = (bufnr == vim.api.nvim_get_current_buf())
          vim.api.nvim_buf_delete(bufnr, { force = true })

          vim.schedule(function()
            local buffers = vim.fn.getbufinfo({ buflisted = 1 })
            local fallback_buf = nil

            for _, buf in ipairs(buffers) do
              local ft = vim.bo[buf.bufnr].filetype
              if buf.bufnr ~= bufnr and ft ~= "NvimTree" and ft ~= "alpha" then
                fallback_buf = buf.bufnr
                break
              end
            end

            if fallback_buf then
              if is_current then
                vim.api.nvim_set_current_buf(fallback_buf)
              end
            else
              local curr_buf = vim.api.nvim_get_current_buf()
              local curr_name = vim.api.nvim_buf_get_name(curr_buf)
              local curr_ft = vim.bo[curr_buf].filetype
              local curr_bt = vim.bo[curr_buf].buftype

              if curr_name == "" and curr_ft == "" and curr_bt == "" then
                vim.cmd("enew")
              end
              vim.cmd("Alpha")
            end

            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "NvimTree" then
                vim.api.nvim_set_current_win(win)
                break
              end
            end
          end)
        end,
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>tn", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<leader>tp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
    vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
    vim.keymap.set("n", "<leader>tP", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer by letter" })
    vim.keymap.set("n", "<leader>t>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
    vim.keymap.set("n", "<leader>t<", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
    for index = 1, 9 do
      vim.keymap.set("n", "<leader>" .. index, function()
        require("bufferline").go_to(index, true)
      end, { desc = "Go to buffer " .. index })
    end
    vim.keymap.set("n", "<leader>tx", function()
      local current = vim.api.nvim_get_current_buf()
      local buffers = vim.fn.getbufinfo({ buflisted = 1 })

      vim.cmd("bdelete")

      local fallback_buf = nil
      for _, buf in ipairs(buffers) do
        local ft = vim.bo[buf.bufnr].filetype
        if buf.bufnr ~= current and ft ~= "NvimTree" and ft ~= "alpha" then
          fallback_buf = buf.bufnr
          break
        end
      end

      vim.schedule(function()
        if fallback_buf then
          vim.api.nvim_set_current_buf(fallback_buf)
        else
          local curr_buf = vim.api.nvim_get_current_buf()
          local curr_name = vim.api.nvim_buf_get_name(curr_buf)
          local curr_ft = vim.bo[curr_buf].filetype
          local curr_bt = vim.bo[curr_buf].buftype

          if curr_name == "" and curr_ft == "" and curr_bt == "" then
            vim.cmd("enew")
          end

          vim.cmd("Alpha")
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "NvimTree" then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end)
    end, { desc = "Smart buffer close" })

    -- Trigger UI tweaks
    vim.api.nvim_exec_autocmds("User", { pattern = "BufferlineConfigLoaded" })
  end,
}
