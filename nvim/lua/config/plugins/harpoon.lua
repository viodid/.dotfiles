return {
  "ThePrimeagen/harpoon",
  lazy = false,
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
  keys = {
    { "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>",        desc = "Mark file with harpoon" },
    { "<C-j>",     "<cmd>lua require('harpoon.ui').nav_file(1)<cr>",         desc = "Go to file 1" },
    { "<C-k>",     "<cmd>lua require('harpoon.ui').nav_file(2)<cr>",         desc = "Go to file 2" },
    { "<C-l>",     "<cmd>lua require('harpoon.ui').nav_file(3)<cr>",         desc = "Go to file 3" },
    { "<C-e>",     "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show harpoon marks" },
  },
}
