return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    enabled = true,
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Define configurations for each LSP server
      -- Python
      vim.lsp.config('basedpyright', { capabilities = capabilities })

      -- Go
      vim.lsp.config('gopls', { capabilities = capabilities })

      -- C/C++
      vim.lsp.config('clangd', {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose', '--fallback-style=WebKit' },
        init_options = {
          -- fallbackFlags = { '-std=c++98' },
        },
        capabilities = capabilities
      })

      -- Lua
      vim.lsp.config('lua_ls', { capabilities = capabilities })

      -- Enable the configured LSP servers
      vim.lsp.enable({ 'basedpyright', 'gopls', 'clangd', 'lua_ls' })

      -- Existing LspAttach autocommand (no changes needed here, but adding clear=true to the group for robustness)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = true }), -- Added clear = true
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }), -- Use a distinct group for formatting
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end
        end,
      })
    end,
  }
}
