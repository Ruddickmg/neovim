return {
  "opencode.nvim",
  lazy = false,
  after = function()
    --- @type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        enabled = "snacks",
        snacks = {
          -- ...
        },
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    Snacks.keymap.set({ "n", "t" }, "<leader>ao", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })
    -- Recommended/example keymaps.
    Snacks.keymap.set({ "n", "x" }, "<leader>aa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode…" })
    Snacks.keymap.set({ "n", "x" }, "<leader>ax", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })

    Snacks.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { desc = "Add range to opencode", expr = true })
    Snacks.keymap.set("n", "<leader>al", function()
      return require("opencode").operator("@this ") .. "_"
    end, { desc = "Add line to opencode", expr = true })

    Snacks.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Scroll opencode up" })
    Snacks.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Scroll opencode down" })

    -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap).
    Snacks.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    Snacks.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}
