-- :help autocmd

-- equalize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

-- format on save
local function setup_pre_commit()
    vim.api.nvim_command("augroup AutoPreCommit")
    vim.api.nvim_command("autocmd!")
    vim.api.nvim_command("autocmd BufWritePost *.py,*.graphql lua run_pre_commit()")
    vim.api.nvim_command("augroup END")
end

function run_pre_commit()
    local command = ".venv/bin/pre-commit run --hook-stage manual --files " .. vim.fn.expand('%:p')
    local job_id = vim.fn.jobstart(command, {
        on_exit = function(_, exit_code)
            vim.api.nvim_command('checktime')
        end,
    })
end

if vim.fn.getcwd():find("whatnot_backend", 1, true) ~= nil then
    setup_pre_commit()
end
