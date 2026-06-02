return {
  keys = {
    {
      "<leader>U",
      function()
        vim.cmd.packadd("nvim.undotree")
        require("undotree").open()
      end,
      mode = { "n" },
      desc = "Undo Tree",
    },
  },
}
