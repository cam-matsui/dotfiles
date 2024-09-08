-- :help options

local options = {
    -- backup
    backup = false,
    swapfile = false,
    undofile = true,

    -- search
    hlsearch = true,
    ignorecase = true,
    smartcase = true,

    -- indentation
    smartindent = true,
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,

    -- splits
    splitbelow = true,
    splitright = true,

    -- navigation & display
    number = true,
    relativenumber = true,
    cursorline = true,
    wrap = false,
    scrolloff = 8,
    termguicolors = true,
    showmode = false,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
