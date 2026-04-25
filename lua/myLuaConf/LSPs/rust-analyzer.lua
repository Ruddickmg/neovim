local features = "all"
local lspmux_path = "/run/user/1000/lspmux/lspmux.sock"

vim.g.rustaceanvim = {
  tools = {
    float_win_config = {
      -- Options: "none", "single", "double", "rounded", "solid", "shadow"
      border = "rounded", -- Example: set to 'rounded'
    },
  },
  server = {
    on_attach = function()
      local bufnr = vim.api.nvim_get_current_buf()
      Snacks.keymap.set("n", "<leader>A", function()
        vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
      end, { silent = true, buffer = bufnr })
      Snacks.keymap.set(
        "n",
        "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
        function()
          vim.cmd.RustLsp({ "hover", "actions" })
        end,
        { silent = true, buffer = bufnr }
      )
      Snacks.keymap.set("n", "<leader>lt", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "[t]oggle lsp inlay hints", silent = true, buffer = bufnr })
    end,
    cmd = function()
      if vim.fn.filereadable(lspmux_path) == 1 then
        return vim.lsp.rpc.connect(lspmux_path)
      else
        return { "lspmux" }
      end
    end,
    settings = {
      ["rust-analyzer"] = {
        lspMux = {
          version = "1",
          method = "connect",
          server = "rust-analyzer",
        },

        runnables = {
          extraTestBinaryArgs = {
            "--nocapture",
          },
        },
        installCargo = false,
        installRustc = false,
        files = {
          watcher = "server",
          exclude = {
            "**/.git/**",
            "**/target/**",
            "**/node_modules/**",
            "**/dist/**",
            "**/out/**",
          },
        },
        cargo = {
          allTargets = true,
          targetDir = "target/ra",
          features = features,
        },
        check = {
          allTargets = true,
          features = features,
          command = "clippy",
        },
      },
    },
  },
}

return {
  {
    "rustaceanvim",
    lazy = false,
    version = "^6",
  },
}
