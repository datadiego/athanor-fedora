-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.sidescrolloff = 4  -- Columns of context (reducido de 8)
opt.sidescroll = 1     -- Columns to scroll horizontally

-- Disable default SQL ftplugin arrow key mappings that call sqlcomplete# functions
-- (incompatible with blink.cmp/dadbod-completion used by LazyVim)
vim.g.omni_sql_no_default_maps = true

-- Disable auto-format on save; format only manually with <leader>cf
vim.g.autoformat = false
