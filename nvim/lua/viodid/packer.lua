-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'folke/tokyonight.nvim'
  use 'eandrju/cellular-automaton.nvim'
  use 'EdenEast/nightfox.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-treesitter/playground'
  use 'thePrimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'
  use 'andweeb/presence.nvim'
  use 'folke/zen-mode.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'm4xshen/autoclose.nvim'
  use 'github/copilot.vim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
--  use {
--    'VonHeikemen/lsp-zero.nvim',
--    requires = {
--      -- LSP Support
--      {'neovim/nvim-lspconfig'},
--      {'williamboman/mason.nvim'},
--      {'williamboman/mason-lspconfig.nvim'},
--
--      -- Autocompletion
--      {'hrsh7th/nvim-cmp'},
--      {'hrsh7th/cmp-buffer'},
--      {'hrsh7th/cmp-path'},
--      {'saadparwaiz1/cmp_luasnip'},
--      {'hrsh7th/cmp-nvim-lsp'},
--      {'hrsh7th/cmp-nvim-lua'},
--
--      -- Snippets
--      {'L3MON4D3/LuaSnip'},
--      {'rafamadriz/friendly-snippets'},
--    }
--  }
--
end)
