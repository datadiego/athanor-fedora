-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function smart_resize(direction)
  local current = vim.fn.winnr()
  local has_right_neighbor = vim.fn.winnr('l') ~= current and vim.fn.winnr('l') > 0

  if not has_right_neighbor then
    if direction == '>' then
      direction = '<'
    elseif direction == '<' then
      direction = '>'
    end
  end

  vim.cmd('wincmd ' .. direction)
end

vim.keymap.set('n', '<A-Right>', function() smart_resize('>') end, { desc = 'Resize: move separator right' })
vim.keymap.set('n', '<A-Left>', function() smart_resize('<') end, { desc = 'Resize: move separator left' })
vim.keymap.set('n', '<A-Down>', function() smart_resize('+') end, { desc = 'Resize: move separator down' })
vim.keymap.set('n', '<A-Up>', function() smart_resize('-') end, { desc = 'Resize: move separator up' })

vim.keymap.set('n', '<C-Left>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-Down>', '<C-w>j', { desc = 'Move to split below' })
vim.keymap.set('n', '<C-Up>', '<C-w>k', { desc = 'Move to split above' })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Move to right split' })

vim.keymap.set('n', '<C-Tab>', '<CMD>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<C-S-Tab>', '<CMD>bprevious<CR>', { desc = 'Previous buffer' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local function terminal_float()
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
  })

  vim.cmd("terminal")
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>tf", terminal_float, { desc = "Open floating terminal" })

vim.keymap.set('n', '<leader>cc', 'gcc', { desc = 'Toggle comment line', remap = true })
vim.keymap.set('x', '<leader>cc', 'gc', { desc = 'Toggle comment selection', remap = true })

