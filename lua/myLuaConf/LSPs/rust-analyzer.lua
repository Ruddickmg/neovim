return {
  {
    "rustaceanvim",
    lazy = false,
    after = function()
      local lspmux_path = "/run/user/1000/lspmux/lspmux.sock"
      vim.g.rustaceanvim = {
        server = {
          on_attach = function() end,
          cmd = function()
            return vim.lsp.rpc.connect(lspmux_path)
          end,
          settings = {
            ["rust-analyzer"] = {
              lspMux = {
                version = "1",
                method = "connect",
                server = "rust-analyzer",
              },
              installCargo = false,
              installRustc = false,
              check = {
                command = "clippy", -- use clippy for diagnostics on save
              },
            },
          },
        },
      }
    end,
  },
}
