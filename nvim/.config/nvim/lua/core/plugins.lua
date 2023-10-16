-- see https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
      return true
    end
    return false
  end

  local packer_bootstrap = ensure_packer()

  return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use({'psliwka/vim-smoothie'})
    use({'nvim-tree/nvim-tree.lua'})
    use({'nvim-tree/nvim-web-devicons'})
    use({
      'nvim-telescope/telescope.nvim',
      tag = '0.1.3',
      requires = { {'nvim-lua/plenary.nvim'} },
    })
    use({'sainnhe/sonokai', as = 'sonokai'})
    use({'github/copilot.vim'})
    use({
      'nvim-treesitter/nvim-treesitter',
      {run = ':TSUpdate'}
    })
    use("xiyaowong/transparent.nvim")
    use({
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v2.x',
      requires = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' },
        {
          'williamboman/mason.nvim',
          run = function()
            pcall(vim.cmd, 'MasonUpdate')
          end,
        },
        { 'williamboman/mason-lspconfig.nvim' },

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'L3MON4D3/LuaSnip' },
      }
    })

    if packer_bootstrap then
      require('packer').sync()
    end
  end)

