vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true


-- Set indentation settings per file type
-- vim.api.nvim_exec([[
--   augroup IndentSettings
--     autocmd!
--     autocmd FileType c,cpp,java setlocal shiftwidth=4 tabstop=4 softtabstop=4
--     autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
--   augroup END
-- ]], false)


vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

-- General color styles
-- highlight Normal guibg=none
vim.cmd [[
  highlight LineNr guifg=white
  highlight LineNrAbove guifg=grey
  highlight LineNrBelow guifg=grey
]]


-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = true,
})

-- True Color (24-bit) and italics with alacritty + tmux + vim (neovim)
vim.o.termguicolors = true
-- vim.cmd 'colorscheme catppuccin-frappe'
