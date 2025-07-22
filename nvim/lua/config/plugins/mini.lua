return {
  {
    'echasnovski/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = false }

      local cursorword = require 'mini.cursorword'
      cursorword.setup { delay = 0 }
      -- ✅ Set underline highlight for cursorword
      -- vim.api.nvim_set_hl(0, 'MiniCursorword', { underline = true })
      -- vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', { underline = false }) -- Optional: highlight current word differently
      vim.api.nvim_set_hl(0, 'MiniCursorword', { bg = "#884499" })
      vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', { underline = false }) -- Optional: highlight current word differently

      -- TODO:
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end
  }
}
