local function set_rainbow_hl()
  local ok, colors = pcall(require, "base16-colorscheme")
  if not ok or not colors.colors then
    return
  end
  local c = colors.colors

  vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = c.base08 })
  vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = c.base0A })
  vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = c.base0B })
  vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = c.base09 })
  vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = c.base0C })
  vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = c.base0E })
  vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = c.base0D })
end

return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    main = "rainbow-delimiters.setup",
    lazy = false,
    config = function()
      require("rainbow-delimiters.setup").setup({
        query = {
          ts = "rainbow-parens",
          tsx = "rainbow-parens",
        },
      })
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_rainbow_hl })
      set_rainbow_hl()
    end,
  },
}