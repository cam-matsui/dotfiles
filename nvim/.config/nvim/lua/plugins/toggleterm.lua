return {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
        open_mapping = [[<C-\>]],
        winbar = { enabled = false },
    },
    config = function(_, opts)
        require('toggleterm').setup(opts)

        keymap('t', '<esc>', '<C-\\><C-n>')
        keymap('t', '<C-k>', '<C-\\><C-n><C-w>k')
    end,
}
