return {
  {
    "vim-dadbod-completion",
    for_cat = "database",
    dep_of = { "vim-dadbod" },
  },
  {
    "vim-dadbod-ui",
    for_cat = "database",
    dep_of = "vim-dadbod",
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    after = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end
  },
  {
    "vim-dadbod",
    for_cat = "database",
  }
}
