vim.g.mapleader = " "
-- Open Vim Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = '[P]roject [V]iew - vim Ex' })
-- Move selelcted section around and autoindent
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move Select Down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move Select Up' })
-- append next line to the end of the current line and stay cursor at the same place
vim.keymap.set("n", "J", "mzJ`z",
  { desc = 'Append next line to the end of the current line and stay cursor at the same place' })
-- search half-way page: up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Search half-way down' })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Search half-way up' })
-- stay cursor in the middle when searching terms
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- "Special copy"
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to the clipboard instead of vim's buffer
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- search and replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = 'Search and replace current word' })
-- make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }, { desc = 'Make current file executable' })
-- cellular automata
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")

-- set hlsearch
vim.keymap.set("n", "<leader>hs", "<cmd>set hlsearch!<CR>")

-- quickfix
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
vim.keymap.set("n", "<M-e>", "<cmd>copen<CR>")

-- lsp
vim.keymap.set("n", "gd", "<C-]>")

-- jump to signature (treesitter-context)
vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })
