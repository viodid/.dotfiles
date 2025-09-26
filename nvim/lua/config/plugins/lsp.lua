-- config/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    enabled = true,
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Define configurations for each LSP server
      vim.lsp.config('basedpyright', { capabilities = capabilities })
      vim.lsp.config('gopls', { capabilities = capabilities })
      vim.lsp.config('clangd', {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose', '--fallback-style=WebKit' },
        capabilities = capabilities,
      })
      vim.lsp.config('lua_ls', { capabilities = capabilities })

      -- Enable the configured LSP servers
      vim.lsp.enable({ 'basedpyright', 'gopls', 'clangd', 'lua_ls' })

      -- LspAttach autocommand for keymaps and other buffer-local settings
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp.attach', { clear = true }),
        callback = function(args)
          -- Add your LSP keymaps here
        end,
      })

      -- Create a dedicated augroup for format-on-save logic
      local format_group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })

      -- Autocommand for Python files using Ruff (synchronous)
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        pattern = "*.py",
        callback = function(args)
          local bufnr = args.buf
          local filepath = vim.fn.bufname(bufnr)
          if filepath == '' then return end

          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local content = table.concat(lines, '\n')

          local ruff_result = vim.system({ 'ruff', 'format', '--stdin-filename', filepath }, {
            text = true,
            stdin = content,
            cwd = vim.fn.fnamemodify(filepath, ':h'),
          }):wait()

          if ruff_result.code == 0 then
            local formatted_content = ruff_result.stdout or ""
            local new_lines = vim.split(formatted_content, '\n', { plain = true })

            if #new_lines ~= #lines or table.concat(new_lines, '\n') ~= content then
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
            end
          else
            vim.notify('Ruff formatting failed: ' .. (ruff_result.stderr or "Unknown error"), vim.log.levels.ERROR,
              { title = 'Ruff Formatter' })
          end

          vim.api.nvim_win_set_cursor(0, cursor_pos)
        end,
      })

      -- Fallback autocommand for other files using LSP (synchronous)
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        pattern = "*",
        callback = function(args)
          if vim.bo[args.buf].filetype == 'python' then
            return -- Skip, as it's handled by the Ruff autocommand above
          end

          -- Save cursor position
          local cursor_pos = vim.api.nvim_win_get_cursor(0)

          -- FIX: Simplified LSP formatting call.
          -- This function automatically finds a client that supports formatting
          -- for the given buffer. It does nothing if no such client is found.
          vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 })

          -- Restore cursor position
          vim.api.nvim_win_set_cursor(0, cursor_pos)
        end,
      })
    end,
  },
}
