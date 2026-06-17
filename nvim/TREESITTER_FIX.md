# Fixing Treesitter / Shift+K on a New Machine

## Symptoms

- `K` (hover) shows a decoration provider error: `attempt to call method 'range' (a nil value)`
- Traceback points to `languagetree.lua` and `treesitter.lua`
- May also see `attempt to call field 'ft_to_lang' (a nil value)` in telescope

## Root Cause

Neovim 0.12.3 changed the `iter_matches` API so that `match[capture_id]` returns
an array of nodes `{node}` instead of a single node. The pinned nvim-treesitter
version predates this change, so its custom query predicates pass a table where
a TSNode is expected, crashing `get_node_text`.

There are several layers to fix:

1. The nvim-treesitter query predicates pass raw `match[id]` to `get_node_text`
2. Telescope uses the removed `ft_to_lang` API
3. The lua injection query uses `#offset!` incompatibly with Neovim 0.12.3

## Fix

### 1. Use Homebrew stable Neovim (not nightly)

If you have a manually installed nightly at `~/.local/nvim/`, point the symlink
to Homebrew's stable build instead:

```bash
brew install neovim
ln -sf /opt/homebrew/opt/neovim/bin/nvim ~/.local/bin/nvim
```

### 2. Clear stale parsers and reinstall

Old `.so` parser files from another machine are ABI-incompatible and must be recompiled:

```bash
rm -f ~/.local/share/nvim/lazy/nvim-treesitter/parser/*.so
rm -f ~/.local/share/nvim/site/parser/*.so
```

Then in Neovim:

```
:TSInstall python lua elixir rust typescript tsx javascript
```

### 3. Patch `query_predicates.lua`

In `~/.local/share/nvim/lazy/nvim-treesitter/lua/nvim-treesitter/query_predicates.lua`,
add a helper after the `opts` line and update all handlers to use it:

```lua
-- In Neovim 0.12+, match[id] returns a list of nodes instead of a single node.
local function get_node(match, id)
  local node = match[id]
  if type(node) == "table" then
    return node[1]
  end
  return node
end
```

Then replace every `match[pred[2]]`, `match[capture_id]`, and `match[id]` in the
directive/predicate handlers with `get_node(match, pred[2])` etc.

Affected handlers: `nth?`, `is?`, `kind-eq?`, `set-lang-from-mimetype!`,
`set-lang-from-info-string!`, `downcase!`

### 4. Patch `telescope/previewers/utils.lua`

In `~/.local/share/nvim/lazy/telescope.nvim/lua/telescope/previewers/utils.lua`,
replace the `treesitter_attach` function:

```lua
local treesitter_attach = function(bufnr, ft)
  local lang = (vim.treesitter.language.get_lang and vim.treesitter.language.get_lang(ft)) or ft
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  if not ok or not parser then
    return false
  end
  vim.treesitter.highlighter.new(parser)
  vim.api.nvim_buf_set_option(bufnr, "syntax", ft)
  return true
end
```

### 5. Remove `#offset!` from lua injection query

In `~/.local/share/nvim/lazy/nvim-treesitter/queries/lua/injections.scm`,
remove the `(#offset! @injection.content 0 1 0 0)` line from the luadoc comment
injection pattern.

### 6. Clear the Lua bytecode cache

Neovim caches compiled Lua — always clear it after patching runtime files:

```bash
rm -rf ~/.cache/nvim/luac
```

## Warning

Steps 3–5 patch files inside `~/.local/share/nvim/lazy/` which will be
**overwritten by `:Lazy update`**. If an update breaks things again, re-apply
the patches in steps 3–5 and clear the cache again.
