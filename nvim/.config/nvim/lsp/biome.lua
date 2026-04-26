return {
    cmd = { 'pnpm', 'exec', 'biome', 'lsp-proxy' },
    filetypes = {
        'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
        'json', 'jsonc', 'css',
    },
    root_markers = { 'biome.json', 'biome.jsonc', 'package.json', '.git' },
}
