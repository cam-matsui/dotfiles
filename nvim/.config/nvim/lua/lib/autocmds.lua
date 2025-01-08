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
    },
    {
        repo = "dotfiles",
        extensions = { "lua" },
    }
}

function map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function run_pre_commit()
    local command = "PATH=.venv/bin:$PATH pre-commit run --hook-stage manual --files " .. vim.fn.expand('%:p')
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

    local pattern = {}
    for _, ext in ipairs(config.extensions) do
        table.insert(pattern, "*." .. ext)
    end
    local pattern_string = table.concat(pattern, ",")

    vim.api.nvim_command("augroup AutoPreCommit")
    vim.api.nvim_command("autocmd!")
    vim.api.nvim_command("autocmd BufWritePost " .. pattern_string .. " lua run_pre_commit()")
    vim.api.nvim_command("augroup END")
end

for _, pre_commit_config in ipairs(pre_commit_configs) do 
    setup_pre_commit(pre_commit_config)
end
