local features = "all"
-- local lspmux_path = "/run/user/1000/lspmux/lspmux.sock

vim.g.rustaceanvim = {
  server = {
    on_attach = function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.keymap.set("n", "<leader>a", function()
        vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
      end, { silent = true, buffer = bufnr })
      vim.keymap.set(
        "n",
        "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
        function()
          vim.cmd.RustLsp({ "hover", "actions" })
        end,
        { silent = true, buffer = bufnr }
      )
      vim.keymap.set("n", "<leader>lt", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "[t]oggle lsp inlay hints", silent = true, buffer = bufnr })
    end,
    cmd = { "lspmux" },
    -- cmd = function()
    --   return vim.lsp.rpc.connect(lspmux_path)
    -- end,
    settings = {
      ["rust-analyzer"] = {
        lspMux = {
          version = "1",
          method = "connect",
          server = "rust-analyzer",
        },
        installCargo = false,
        installRustc = false,
        cargo = {
          features = features,
        },
        check = {
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
