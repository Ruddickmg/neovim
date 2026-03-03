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
