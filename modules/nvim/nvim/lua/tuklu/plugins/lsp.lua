local mason_servers = {
  "bashls",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "gopls",
  "html",
  "jdtls",
  "jsonls",
  "kotlin_language_server",
  "lua_ls",
  "marksman",
  "ocamllsp",
  "pyright",
  "ruby_lsp",
  "svelte",
  "sqls",
  "taplo",
  "ts_ls",
  "yamlls",
  "zls",
}

return {
  "mason-org/mason-lspconfig.nvim",
  lazy = false,
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config("*", { capabilities = capabilities })
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = { library = { vim.env.VIMRUNTIME } },
          diagnostics = { globals = { "vim" } },
          telemetry = { enable = false },
        },
      },
    })
    vim.lsp.config("ts_ls", {
      init_options = {
        plugins = {
          {
            name = "typescript-svelte-plugin",
            location = vim.fn.stdpath("data")
              .. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin",
            languages = { "svelte" },
          },
        },
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = mason_servers,
      automatic_enable = mason_servers,
    })

    vim.lsp.enable({ "clangd", "rust_analyzer" })

    vim.diagnostic.config({
      severity_sort = true,
      underline = true,
      virtual_text = { spacing = 2, source = "if_many" },
      float = { border = "rounded", source = "if_many" },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local bufnr = event.buf
        local builtin = require("telescope.builtin")
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("gd", builtin.lsp_definitions, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gr", builtin.lsp_references, "Find references")
        map("gi", builtin.lsp_implementations, "Go to implementation")
        map("<leader>ls", builtin.lsp_document_symbols, "Document symbols")
        map("<leader>lS", builtin.lsp_workspace_symbols, "Workspace symbols")
        map("<leader>ld", builtin.diagnostics, "Workspace diagnostics")
        map("K", vim.lsp.buf.hover, "Show documentation")
        map("gK", vim.lsp.buf.signature_help, "Show signature help")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
        map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("<leader>q", vim.diagnostic.setloclist, "Diagnostics to location list")
        map("<leader>uh", function()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        end, "Toggle inlay hints")
      end,
    })
  end,
}
