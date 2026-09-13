return {
  {
    "nvim-telescope/telescope.nvim",
    -- tag = "0.1.8" removed: that tag predates 0.12 and can break on it
    branch = "master",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>sf", function() require("telescope.builtin").find_files() end,  desc = "Search files" },
      { "<leader>sg", function() require("telescope.builtin").git_files() end,   desc = "Search git files" },
      { "<leader>sh", function() require("telescope.builtin").help_tags() end,   desc = "Search help" },
      { "<leader>sc", function() require("telescope.builtin").grep_string() end, desc = "Search word under cursor" },
      { "<leader>sb", function() require("telescope.builtin").buffers() end,     desc = "Search buffers" },
      { "<leader>sr", function() require("telescope.builtin").resume() end,      desc = "Resume last picker" },
      { "<leader>sq", function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" },
      { "<leader>st", desc = "Multigrep" }, -- actually bound in multigrep.setup()
    },
    config = function()
      require("telescope").setup({ extensions = { fzf = {} } })
      require("telescope").load_extension("fzf")
      require("config.telescope.multigrep").setup()
    end,
  },
}
