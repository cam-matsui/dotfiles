return {
    'nvim-treesitter/nvim-treesitter',
    commit = 'e947d35b',
    build = ':TSUpdate',
    config = function ()
        local configs = require('nvim-treesitter.configs')

        configs.setup {
            ensure_installed = {
                'python',
                'lua',
                'elixir',
                'rust',
                'typescript',
                'tsx',
                'javascript',
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        }
    end
}
