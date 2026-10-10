return {
  {
    'folke/tokyonight.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-moon")
    end,
    opts = {},
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true, -- matches Alacritty opacity 0.95
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nordfox", -- nightfox, nordfox, terafox, carbonfox
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme nordfox")
    end
  },
}
