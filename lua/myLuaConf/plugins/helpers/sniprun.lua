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
      require("sniprun").setup()
    end,
  },
}
