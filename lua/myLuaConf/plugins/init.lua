local ok, notify = pcall(require, "notify")

if ok then
  notify.setup({
    background_colour = "#00000000",
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  })
  vim.notify = notify
  vim.keymap.set("n", "<Esc>", function()
    notify.dismiss({ silent = true })
  end, { desc = "dismiss notify popup and clear hlsearch" })
end

return {
  { import = "myLuaConf.plugins.language" },
  {
    "comment.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function()
      require("Comment").setup()
    end,
  },
  { import = "myLuaConf.plugins.surround" },
  { import = "myLuaConf.plugins.files" },
  { import = "myLuaConf.plugins.helpers" },
  { import = "myLuaConf.plugins.test" },
  { import = "myLuaConf.plugins.vcs" },
  { import = "myLuaConf.plugins.ui" },
  { import = "myLuaConf.plugins.ai" },
}
