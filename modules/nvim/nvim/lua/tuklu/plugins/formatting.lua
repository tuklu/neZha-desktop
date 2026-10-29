return {
  "stevearc/conform.nvim",
  lazy = false,
  dependencies = {
    "mason-org/mason.nvim",
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = { "prettier", "delve", "debugpy" },
        run_on_start = true,
      },
    },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        css = { "prettier" },
        go = { "goimports", "gofumpt" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        svelte = { "prettier" },
        toml = { "taplo" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = nil,
    })

  end,
}
