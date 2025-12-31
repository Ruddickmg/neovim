return {
  {
    "tiny-inline-diagnostic.nvim",
    for_cat = "debug",
    event = { "BufReadPost" },
    after = function()
      local diagnostices = require("tiny-inline-diagnostic")
      diagnostices.setup({
        -- Choose a preset style for diagnostic appearance
        -- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
        preset = "modern",
        transparent_bg = false,
        hi = {
          error = "DiagnosticError", -- Highlight for error diagnostics
          warn = "DiagnosticWarn", -- Highlight for warning diagnostics
          info = "DiagnosticInfo", -- Highlight for info diagnostics
          hint = "DiagnosticHint", -- Highlight for hint diagnostics
          arrow = "NonText", -- Highlight for the arrow pointing to diagnostic
          background = "CursorLine", -- Background highlight for diagnostics
          mixing_color = "Normal", -- Color to blend background with (or "None")
        },
        options = {
          -- Use icons from vim.diagnostic.config instead of preset icons
          use_icons_from_diagnostic = false,

          -- Color the arrow to match the severity of the first diagnostic
          set_arrow_to_diag_color = false,

          -- Throttle update frequency in milliseconds to improve performance
          -- Higher values reduce CPU usage but may feel less responsive
          -- Set to 0 for immediate updates (may cause lag on slow systems)
          throttle = 20,

          -- Minimum number of characters before wrapping long messages
          softwrap = 30,

          -- Control how diagnostic messages are displayed
          -- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
          --       If you want them to always be displayed, you can also set multilines.always_show = true.
          add_messages = {
            messages = true, -- Show full diagnostic messages
            display_count = false, -- Show diagnostic count instead of messages when cursor not on line
            use_max_severity = false, -- When counting, only show the most severe diagnostic
            show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
          },
          -- Show muliline stuff
          multilines = {
            enabled = true,
            always_show = true,
          },
          -- Automatically disable diagnostics when opening diagnostic float windows
          override_open_float = false,
          -- Break long messages into separate lines
          break_line = {
            enabled = false, -- Enable automatic line breaking
            after = 30, -- Number of characters before inserting a line break
          },
          -- Handle messages that exceed the window width
          overflow = {
            mode = "wrap", -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
            padding = 0, -- Extra characters to trigger wrapping earlier
          },
          -- Display related diagnostics from LSP relatedInformation
          show_related = {
            enabled = true, -- Enable displaying related diagnostics
            max_count = 3, -- Maximum number of related diagnostics to show per diagnostic
          },
        },
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
}
