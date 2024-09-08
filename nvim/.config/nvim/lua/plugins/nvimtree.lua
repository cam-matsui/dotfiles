return {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        filters = { dotfiles = true },
    },
    config = function(_, opts)
        require('nvim-tree').setup(opts)

        keymap('n', '<leader>tt', ':NvimTreeToggle<cr>')
    end,
}
