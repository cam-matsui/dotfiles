-- numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- color column
vim.opt.colorcolumn = "80"

-- Editing
-- nowrap
vim.opt.wrap = false

-- padding
vim.opt.scrolloff = 8

-- tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- resize splits with mouse
vim.g.mouse = "n"

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>h", "::nohlsearch<CR>")

-- move splits
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")

-- equalize splits
vim.keymap.set("n", "<C-=>", "<C-w><C-=>")

-- Highlighted Movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")