return {
  {
    'eandrju/cellular-automaton.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight-moon'
    end,
    opts = {},
  }
}
