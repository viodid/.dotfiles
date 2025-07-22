return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = true,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  }
}
