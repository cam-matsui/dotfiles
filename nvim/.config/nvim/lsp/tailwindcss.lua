return {
    cmd = { 'tailwindcss-language-server', '--stdio' },
    filetypes = {
        'html', 'css',
        'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
    },
    root_markers = {
        'tailwind.config.ts', 'tailwind.config.js',
        'postcss.config.mjs', 'postcss.config.js',
        'package.json', '.git',
    },
}
