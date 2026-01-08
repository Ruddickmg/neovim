return {
  {
    "sniprun",
    keys = {
      {
        "<leader>r",
        "<Plug>SnipRun",
        mode = { "v" },
        desc = "[r]un [c]ode",
      },
      {
        "<leader>r",
        "<Plug>SnipRunOperator",
        mode = { "n" },
        desc = "[r]un [c]ode",
      },
      {
        "<leader>R",
        "<Plug>SnipRun",
        mode = { "n" },
        desc = "[r]un [c]ode at cursor",
      },
    },
    after = function()
      require("sniprun").setup({
        repl_enable = { "Rust_original" },
        interpreter_options = {
          TypeScript_original = {
            interpreter = "node",
          },
          Rust_original = {
            compiler = "rustc",
          },
        },
        display = { "NvimNotify" },
        display_options = {
          notification_timeout = 5, -- in seconds
          notification_render = "minimal", -- nvim-notify render style
        },
      })
    end,
  },
}
