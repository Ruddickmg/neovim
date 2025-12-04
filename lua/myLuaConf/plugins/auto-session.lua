return {
  {
    "auto-session",
    lazy = false,
    for_cat = "utility",
    dep_of = "lualine",
    keys = {
      { "<leader>sw", "<cmd>AutoSession search<CR>", desc = "Session search" },
      { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
      { "<leader>ta", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
    },
    after = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      require("auto-session").setup({
        allowed_dirs = { "~/.config/nvim/*", "~/Nixos/*", "/var/www/*" },
        bypass_save_filetypes = { "alpha", "dashboard", "snacks_dashboard" }, -- or whatever dashboard you use
      })
    end,
  },
}
