return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')

        keymap('n', '<leader>ff', builtin.find_files)
        keymap('n', '<leader>fgf', builtin.git_files)
        keymap('n', '<leader>fr', function()
            builtin.grep_string({ search = vim.fn.input('grep > ') })
        end)
    end
}
