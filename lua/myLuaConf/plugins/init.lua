local ok, notify = pcall(require, "notify")

if ok then
  notify.setup({
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
    "undotree",
    for_cat = "general.extra",
    cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo" },
    keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" } },
    before = function(_)
      vim.g.undotree_WindowLayout = 1
      vim.g.undotree_SplitWidth = 40
    end,
  },
  {
    "comment.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function()
      require("Comment").setup()
    end,
  },
  {
    "nvim-surround",
    for_cat = "general.always",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-surround").setup()
    end,
  },
  { import = "myLuaConf.plugins.files" },
  { import = "myLuaConf.plugins.helpers" },
  { import = "myLuaConf.plugins.test" },
  { import = "myLuaConf.plugins.database" },
  { import = "myLuaConf.plugins.vcs" },
  { import = "myLuaConf.plugins.ui" },
}
