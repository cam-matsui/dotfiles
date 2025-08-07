return {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPost', -- Load the plugin after a buffer is read
    config = function()
        require('treesitter-context').setup {
            enable = true,
            max_lines = 3,
        }
    end
}
