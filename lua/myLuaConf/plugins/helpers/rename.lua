return {
  {
    "inc-rename.nvim",
    keys = {
      { "<leader>cn", desc = "[N]ame" },
    },
    after = function()
      local rename = require("inc_rename")
      rename.setup({
        cmd_name = "IncRename",
        hl_group = "Substitute",
        preview_empty_name = true,
        show_message = true,
        save_in_cmdline_history = true,
        input_buffer_type = "noice",
      })
      Snacks.keymap.set("n", "<leader>cn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "[N]ame" })
    end,
  },
}
