return {
  {
    "yazi.nvim",
    for_cat = "file-manager",
    keys = {
      {
        "<leader>e",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
    },
    after = function()
      require("yazi").setup({
        open_for_directories = true,
        yazi_floating_window_winblend = 0,
        keymaps = {
          -- <Tab> is needed by the whoosh.yazi bookmark menu (directory history)
          cycle_open_buffers = "<S-Tab>",
        },
        integrations = {
          grep_in_directory = function(directory)
            Snacks.picker.grep({ dirs = { directory } })
          end,
          picker_add_copy_relative_path_action = "snacks.picker",
        },
      })
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
