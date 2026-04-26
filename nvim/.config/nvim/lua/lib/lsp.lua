vim.lsp.enable('ruff')
vim.lsp.enable('pyright')
vim.lsp.enable('vtsls')
vim.lsp.enable('biome')
vim.lsp.enable('tailwindcss')

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "always",
    },
})
