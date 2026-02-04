return {
  "otter.nvim",
  ft = { "markdown" },
  after = function()
    vim.notify("loading otter!")
    require("otter").activate({
      diagnostic_update_events = { "BufWritePost", "InsertLeave" },
      buffers = {
        set_filetype = true,
        write_to_disk = true,
      },
    })
  end,
}
