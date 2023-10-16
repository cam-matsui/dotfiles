-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- setup nvim-tree
require("nvim-tree").setup({
    sort_by = "case_sensitive",
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})

local function open_nvim_tree(data)
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
    local directory = vim.fn.isdirectory(data.file) == 1

    if not no_name and not directory then
        return
    end

    if directory then
        vim.cmd.cd(data.file)
    end

    require("nvim-tree.api").tree.open()
end


local api = require("nvim-tree.api")
-- open nvim tree with vim
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- fix colors for nvim-tree
vim.cmd[[ hi NvimTreeNormal guibg=NONE ctermbg=NONE ]]
vim.cmd[[ hi NvimTreeEndOfBuffer guibg=NONE ctermbg=NONE ]]

-- set <Control-s> to open/close
vim.keymap.set('n', '<C-s>', api.tree.toggle)
