local opts = { noremap = true, silent = true }
function keymap(mode, lhs, rhs)
    local success, error = pcall(vim.api.nvim_set_keymap, mode, lhs, rhs, opts)
    if not success then
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- space as leader
keymap('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.localleader = ' '
vim.g.maplocalleader = '\\'

-- split navigation
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- split resizing
keymap('n', '<A-h>', ':vertical resize -2<cr>')
keymap('n', '<A-j>', ':resize +2<cr>')
keymap('n', '<A-k>', ':resize -2<cr>')
keymap('n', '<A-l>', ':vertical resize +2<cr>')

-- split equalizing
keymap('n', '<A-=>', ':wincmd =<cr>')

-- buffer navigation
keymap('n', '<leader>gb', ':bnext<cr>')
keymap('n', '<leader>gB', ':bprev<cr>')

-- stay in indent mode
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- move text up and down
keymap('v', '<A-k>', ":m '<-2<cr>gv=gv")
keymap('v', '<A-j>', ":m '>+1<cr>gv=gv")

-- when pasting over something, don't replace clipboard
keymap('v', 'p', '"_dP')

-- copy current file path to clipboard
vim.keymap.set('n', '<leader>cp', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  print('Copied to clipboard: ' .. path)
end, opts)

-- run make qtest with current file path
vim.keymap.set('n', '<leader>qt', function()
  local path = vim.fn.expand('%')
  vim.cmd('!make qtest t=' .. path)
end, opts)
