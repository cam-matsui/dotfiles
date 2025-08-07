return {
    cmd = { "ruff", "server", "--preview" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        ".git",
        "ruff.toml",
    },
    single_file_support = true,
    settings = {},
}
