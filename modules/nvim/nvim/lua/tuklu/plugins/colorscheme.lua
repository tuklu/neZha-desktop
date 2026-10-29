return {
  "olimorris/onedarkpro.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("onedarkpro").setup({
      colors = {},
      highlights = {},
      options = {
        transparency = false,
      },
      styles = {
        comments = "italic",
        keywords = "bold",
        functions = "italic",
        variables = "NONE",
      },
    })

    vim.cmd("colorscheme onedark")
  end,
}
