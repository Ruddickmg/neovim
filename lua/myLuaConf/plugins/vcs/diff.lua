return {
  "diffview.nvim",
  {
    keys = {
      {
        "<leader>dD",
        function()
          vim.cmd.packadd("nvim.difftool")
          vim.api.nvim_input(":DiffTool ")
        end,
        mode = { "n" },
        desc = "DiffTool",
      },
    },
  },
}
