-- :help autocmd

-- equalize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

-- pre-commit
pre_commit_configs = {
    {
        repo = "whatnot_backend",
        extensions = { "py", "graphql" },
    }
}

function run_pre_commit()
    local command = "pre-commit run --hook-stage manual --files " .. vim.fn.expand('%:p')
    local job_id = vim.fn.jobstart(command, {
        on_exit = function(_, exit_code)
            vim.api.nvim_command('checktime')
        end,
    })
end

local function setup_pre_commit(config)
    if vim.fn.getcwd():find(config.repo, 1, true) == nil then
        return
    end

    extensions_str = map(
        function(ext) return "*." .. ext end,
        config.extensions
    ):join(",")

    vim.api.nvim_command("augroup AutoPreCommit")
    vim.api.nvim_command("autocmd!")
    vim.api.nvim_command("autocmd BufWritePost %s lua run_pre_commit()", extensions_str)
    vim.api.nvim_command("augroup END")
end

for _, pre_commit_config in ipairs(pre_commit_configs) do 
    setup_pre_commit(pre_commit_config)
end
