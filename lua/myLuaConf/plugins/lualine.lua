return {
  {
    "lualine.nvim",
    for_cat = 'styling',
    event = "DeferredUIEnter",
    after = function ()
      local auto = require('lualine.themes.auto')
      
      auto.normal.c.bg = 'none'
      auto.normal.x.bg = 'none'
      
      require('lualine').setup({
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
              'filename', path = 1, status = true,
            },
          },
        },
        inactive_sections = {
          lualine_b = {
            {
              'filename', path = 3, status = true,
            },
          },
          lualine_x = {'filetype'},
        },
        tabline = {
          lualine_a = { 'buffers' },
          lualine_b = { 'lsp_progress', },
          lualine_z = { 'tabs' }
        },
      })
    end,
  }
}
