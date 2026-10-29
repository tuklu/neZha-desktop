return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      bash = { "shellcheck" },
      dockerfile = { "hadolint" },
      markdown = { "markdownlint-cli2" },
      python = { "ruff" },
      sh = { "shellcheck" },
      sql = { "sqlfluff" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
