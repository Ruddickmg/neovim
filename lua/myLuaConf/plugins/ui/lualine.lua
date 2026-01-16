return {
  {
    "lualine-lsp-progress",
    for_cat = "styling",
    dep_of = { "lualine.nvim" },
    event = "DeferredUIEnter",
  },
  {
    "lualine.nvim",
    for_cat = "styling",
    event = "DeferredUIEnter",
    after = function()
      local auto = require("lualine.themes.auto")

      auto.normal.c.bg = "none"
      auto.normal.x.bg = "none"

      local config = {
        options = {
          component_separators = "",
          icons_enabled = true,
          section_separators = { left = "", right = "" },
          theme = auto,
          transparent = true,
        },
        extensions = { "trouble", "fugitive", "nvim-dap-ui", "oil" },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
              function()
                return " " .. os.date("%R")
              end,
              separator = { right = "" },
            },
          },
          lualine_c = {
            {
              "aerial",
              sep = " ) ",
              depth = nil,
              dense = false,
              dense_sep = ".",
              colored = true,
            },
            "lsp_progress",
          },
        },
        inactive_sections = {
          lualine_b = {
            {
              "filename",
              path = 3,
              status = true,
            },
          },
          lualine_x = { "filetype" },
        },
        tabline = {
          lualine_a = { "buffers" },
          lualine_z = { "tabs" },
          lualine_x = {
            function()
              return require("auto-session.lib").current_session_name(true)
            end,
          },
        },
      }

      local base = "#ECBE7B"
      local main = "#a9a1e1"

      table.insert(config.sections.lualine_c, {
        "lsp_progress",
        colors = {
          percentage = main,
          title = base,
          spinner = base,
          lsp_client_name = base,
          use = true,
        },
        display_components = { "lsp_client_name", "spinner", { "title", "percentage" } },
        separators = {
          component = " ",
          progress = " | ",
          percentage = { pre = "", post = "%% " },
          title = { pre = "", post = ": " },
          lsp_client_name = { pre = "[", post = "]" },
          spinner = { pre = "", post = "" },
          message = { commenced = "In Progress", completed = "Completed" },
        },
        timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
        spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
      })

      require("lualine").setup(config)
    end,
  },
}
