local builtin = require('telescope.builtin')

-- list files in working directory respecting .gitignore.
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- list git files
vim.keymap.set('n', '<leader>fp', builtin.git_files, {})

-- list references
vim.keymap.set('n', '<leader>fr', builtin.live_grep, {})