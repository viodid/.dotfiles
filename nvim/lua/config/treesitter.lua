local max_filesize = 100 * 1024 -- 100 KB

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ts-start", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return
    end
    -- fails silently for filetypes without a parser
    if not pcall(vim.treesitter.start, buf) then
      return
    end
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldlevel = 99
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
