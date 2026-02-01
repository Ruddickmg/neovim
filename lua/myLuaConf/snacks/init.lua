local dashboard = require("myLuaConf.snacks.dashboard")
local keymap = require("myLuaConf.snacks.keys")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    -- Override print to use snacks for `:=` command
    if vim.fn.has("nvim-0.11") == 1 then
      vim._print = function(_, ...)
        dd(...)
      end
    else
      vim.print = _G.dd
    end
  end,
})

return {
  {
    "snacks.nvim",
    lazy = false,
    for_cat = { "utility" },
    keys = keymap,
    after = function()
      require("snacks").setup({
        dashboard = dashboard,
        picker = {
          files = {
            hidden = true,
            ignored = true,
          },
          sources = {
            gh_issue = {},
            gh_pr = {},
          },
        },
        image = { enabled = true },
        bufdelete = { enabled = true },
        -- indent = { enabled = true },
        input = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
        },
        -- keymap = { enabled = true },
        debug = { enabled = true },
        gh = { enabled = true },
        git = { enabled = true },
        lazygit = { enabled = true },
        terminal = { enabled = true },
        layout = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        profiler = { enabled = true },
        scroll = {
          enabled = true,
          animate = {
            duration = { step = 10, total = 150 },
            easing = "linear",
          },
          -- faster animation when repeating scroll after delay
          animate_repeat = {
            delay = 100, -- delay in ms before using the repeat animation
            duration = { step = 5, total = 50 },
            easing = "linear",
          },
          -- what buffers to animate
          filter = function(buf)
            return vim.g.snacks_scroll ~= false
              and vim.b[buf].snacks_scroll ~= false
              and vim.bo[buf].buftype ~= "terminal"
          end,
        },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
          notification = {
            -- wo = { wrap = true } -- Wrap notifications
          },
        },
      })
      -- Toggle the profiler
      Snacks.toggle.profiler():map("<leader>pp")
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map("<leader>ph")
    end,
  },
}
