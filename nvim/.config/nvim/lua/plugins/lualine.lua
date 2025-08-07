return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'cpea2506/one_monokai.nvim' },
    requires = { 'nvim-tree/nvim-web-devicons'},
    config = function()
        require('lualine').setup({
            options = {
                theme = 'one_monokai',
            },
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1
                    }
                }
            }
        })
    end,
}
