return {
  {
    "tiny-cmdline.nvim",
    after = function()
      vim.api.nvim_create_autocmd("CmdlineEnter", {
        group = vim.api.nvim_create_augroup("TinyCmdlineHL", { clear = true }),
        callback = function()
          local t = vim.fn.getcmdtype()
          if t == "/" or t == "?" then
            vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { fg = "#ff9e64" })
            vim.api.nvim_set_hl(0, "TinyCmdlineNormal", { bg = "#2d2020" })
          else
            vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { link = "FloatBorder" })
            vim.api.nvim_set_hl(0, "TinyCmdlineNormal", { link = "MsgArea" })
          end
        end,
      })

      require("tiny-cmdline").setup({
        on_reposition = require("tiny-cmdline").adapters.blink,
        native_types = {},
        position = { y = "10%" },
        title = {
          enabled = true,
          pos = "left",
          formats = {
            { type = "/", title = "  " },
            { type = "?", title = "  " },
            { type = ":", title = "  " },
            { type = "=", title = "  " },
            { type = "@", title = " 󰥻 " },
            { type = ">", title = " 󰅏 " },
            { title = "  " },
          },
        },
      })
    end,
  },
}
