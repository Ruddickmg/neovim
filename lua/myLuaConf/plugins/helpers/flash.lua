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
      local color = require("myLuaConf.utilities.color")
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

      local text_hl_colors = function(group)
        return {
          fg = "black", --[[  get_hl_colors("@namespace.builtin").foreground, ]]
          bg = color.get_hl_colors(group).foreground,
        }
      end

      -- flash label
      vim.api.nvim_set_hl(0, "FlashLabel", text_hl_colors("Boolean"))

      -- flash selected
      vim.api.nvim_set_hl(0, "FlashMatch", text_hl_colors("@variable.parameter"))
      vim.api.nvim_set_hl(0, "IncSearch", text_hl_colors("@variable.parameter"))
      vim.api.nvim_set_hl(0, "Search", text_hl_colors("@variable.parameter"))
    end,
  },
}
