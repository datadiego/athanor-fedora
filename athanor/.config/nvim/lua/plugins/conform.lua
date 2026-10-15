return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    for _, ft in ipairs({
      "css",
      "graphql",
      "handlebars",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "less",
      "scss",
      "typescript",
      "typescriptreact",
      "vue",
      "yaml",
    }) do
      opts.formatters_by_ft[ft] = { "prettier" }
    end
    opts.formatters_by_ft.python = { "ruff", "black" }
    opts.formatters_by_ft.lua = { "stylua" }
    opts.formatters_by_ft.sql = { "sqlfmt" }
    opts.formatters_by_ft.markdown = nil
    opts.formatters_by_ft["markdown.mdx"] = nil
  end,
}