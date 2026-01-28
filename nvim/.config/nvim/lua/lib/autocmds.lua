-- :help autocmd

-- equalize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

-- prek
VENV_COMMAND = "PATH=.venv/bin:$PATH prek run --hook-stage manual --files "
UV_COMMAND = "uv run prek run --files "

pre_commit_configs = {
    {
        repo = "whatnot_backend",
        extensions = { "py", "graphql" },
        command = VENV_COMMAND,
    },
    {
        repo = "dotfiles",
        extensions = { "lua" },
        command = VENV_COMMAND,
    },
    {
        repo = "dagster-workflows-core",
        extensions = { "py", "yaml", "yml" },
        command = UV_COMMAND,
    }
    
}

function map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function run_pre_commit(config)
    local command = config.command .. vim.fn.expand('%:p')
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
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = pattern_string,
        callback = function()
            run_pre_commit(config)
        end,
    })
    vim.api.nvim_command("augroup END")
end

for _, pre_commit_config in ipairs(pre_commit_configs) do 
    setup_pre_commit(pre_commit_config)
end

-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gd", vim.lsp.buf.declaration, "Goto Declaration")
        map("gr", vim.lsp.buf.references, "Goto References")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("<leader>cr", vim.lsp.buf.rename, "Rename all references")
    end,
})
