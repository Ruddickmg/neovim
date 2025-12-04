return {
  {
    "todo-comments.nvim",
    for_cat = "utility",
    event = "BufReadPost", -- Lazy load on file open
    keys = {
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
      },
    },
    after = function()
      require("todo-comments").setup({})
    end,
  },
}
