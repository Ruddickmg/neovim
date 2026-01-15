return {
  {
    "flash.nvim",
    event = { "CmdlineEnter" },
    keys = {
      {
        "<c-s>",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
    },
    after = function()
      require("flash").setup({
        search = {
          exclude = {
            "blink-cmp-menu",
            "blink-cmp-documentation",
            "blink-cmp-signature",
            "notify",
            "cmp_menu",
            "noice",
            "flash_prompt",
            function(win)
              -- exclude non-focusable windows
              return not vim.api.nvim_win_get_config(win).focusable
            end,
          },
        },
        modes = {
          char = {
            enabled = false,
          },
          search = {
            enabled = true,
            incremental = true,
          },
        },
      })
    end,
  },
}
