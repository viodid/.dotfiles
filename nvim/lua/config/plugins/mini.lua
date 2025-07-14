return {
  {
    'echasnovski/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = false }

      -- local cursorword = require 'mini.cursorword'
      -- cursorword.setup { delay = 300 }
      -- -- ✅ Set underline highlight for cursorword
      -- vim.api.nvim_set_hl(0, 'MiniCursorword', { underline = true })
      -- vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', { underline = true }) -- Optional: highlight current word differently
    end
  }
}
