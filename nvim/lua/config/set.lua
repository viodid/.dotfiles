vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes" -- stops gitsigns/diagnostics shifting text

vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
-- vim.opt.cindent = true       -- fights smartindent/treesitter; use after/ftplugin

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo" -- created automatically
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.cmd [[
  highlight LineNr guifg=white
  highlight LineNrAbove guifg=grey
  highlight LineNrBelow guifg=grey
]]

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank() -- vim.highlight.on_yank is deprecated
  end,
})

-- single source of truth (remove the duplicate block in remap.lua)
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  float = { border = "rounded" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
})
