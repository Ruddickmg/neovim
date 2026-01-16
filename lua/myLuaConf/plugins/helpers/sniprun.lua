return {
  {
    "sniprun",
    keys = {
      {
        "<leader>rc",
        function()
          require("sniprun").run("v")
        end,
        mode = { "v" },
        desc = "Selected [C]ode",
      },
      {
        "<leader>rc",
        function()
          require("sniprun").run("n")
        end,
        mode = { "n" },
        desc = "Selected [C]ode",
      },
      {
        "<leader>rl",
        function()
          require("sniprun").run()
        end,
        mode = { "n" },
        desc = "[L]ine at cursor",
      },
    },
    after = function()
      require("sniprun").setup({
        display = { "NvimNotify" },
        repl_enable = { "Rust_original" },
        interpreter_options = {
          Rust_original = {
            compiler = "rustc",
          },
          TypeScript_original = {
            interpreter = "node",
          },
        },
      })
    end,
  },
}
