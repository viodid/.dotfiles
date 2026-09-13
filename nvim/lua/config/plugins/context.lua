return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 3,           -- was 0 = unlimited; 3 stops it eating the screen
      multiline_threshold = 1, -- collapse long signatures to one line
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
    },
  },
}
