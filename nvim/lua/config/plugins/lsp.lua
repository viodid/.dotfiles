return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/lazydev.nvim", ft = "lua", opts = {
          library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
      } },
    },
    config = function()
      -- one wildcard config instead of repeating capabilities per server
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--fallback-style=WebKit" },
      })
      vim.lsp.config("ruff", {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false -- let basedpyright own hover
        end,
      })

      vim.lsp.enable({ "basedpyright", "gopls", "clangd", "lua_ls", "ruff", "nil_ls" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp.attach", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local map = function(k, f, d)
            vim.keymap.set("n", k, f, { buffer = buf, desc = "LSP: " .. d })
          end
          local tb = require("telescope.builtin")
          map("gd", vim.lsp.buf.definition, "Definition")
          map("gD", vim.lsp.buf.declaration, "Declaration")
          map("gr", tb.lsp_references, "References")
          map("gI", tb.lsp_implementations, "Implementations")
          map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>ds", tb.lsp_document_symbols, "Document symbols")
          map("<leader>sw", tb.lsp_dynamic_workspace_symbols, "Workspace symbols")
        end,
      })

      -- format on save: ruff for python, LSP for everything else
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
        callback = function(args)
          vim.lsp.buf.format({
            bufnr = args.buf,
            async = false,
            timeout_ms = 2000,
            filter = function(client)
              if vim.bo[args.buf].filetype == "python" then
                return client.name == "ruff"
              end
              return client.name ~= "ruff"
            end,
          })
        end,
      })
    end,
  },
}
