return {
  {
    "rustaceanvim",
    lazy = false,
    after = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function() end,
          default_settings = {
            ["rust-analyzer"] = {
              installCargo = false,
              installRustc = false,
              cachePriming = {
                enable = false,
              },
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
