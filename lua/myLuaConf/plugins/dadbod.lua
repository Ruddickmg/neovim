return {
  {
    "vim-dadbod-completion",
    for_cat = "database",
    dep_of = { "vim-dadbod" },
    after = function()
      print("doing dadbod completion stuff")
    end
  },
  {
    "vim-dadbod-ui",
    for_cat = "database",
    dep_of = "vim-dadbod",
    after = function()
      print("doing dadbod ui stuff")
    end
  },
  {
    "vim-dadbod",
    for_cat = "database",
    after = function()
      print("doing dadbod stuff")
      vim.g.db_ui_use_nerd_fonts = 1
    end
  }
}
