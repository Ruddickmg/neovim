local hl_group = vim.api.nvim_create_augroup("TinyCmdlineHL", { clear = true })
vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = hl_group,
  callback = function()
    local t = vim.fn.getcmdtype()
    if t == "/" or t == "?" then
      vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { fg = "#ff9e64" })
    else
      vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "TinyCmdlineNormal", { link = "MsgArea" })
    end
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = hl_group,
  callback = function()
    vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "TinyCmdlineNormal", { link = "MsgArea" })
  end,
})

return {
  {
    "tiny-cmdline.nvim",
    after = function()
      require("tiny-cmdline").setup({
        on_reposition = require("tiny-cmdline").adapters.blink,
        native_types = {},
        position = { y = "13%" },
      })
    end,
  },
}
