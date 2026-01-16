local color = require("myLuaConf.utilities.color")
local elements = {
  "statusline",
  "TabLine",
  "TabLineFill",
  "SnacksPicker",
  "SnacksPickerBorder",
  "WhichKeyNormal",
  "Normal",
  "NormalFloat",
  "@markup.raw.block.markdown",
  "RenderMarkdownCode",
  "RenderMarkdownH1Bg",
  "RenderMarkdownH2Bg",
  "RenderMarkdownH3Bg",
  "RenderMarkdownH4Bg",
  "RenderMarkdownH5Bg",
  "RenderMarkdownH6Bg",
  "SnacksDashboardDir",
  "BlinkCmpMenu",
  "Pmenu",
}

local clear_backgrounds = function()
  for _, element in ipairs(elements) do
    vim.api.nvim_set_hl(0, element, { bg = "none", nocombine = true })
  end
end

local update_colors = function()
  clear_backgrounds()

  -- completion source color
  vim.api.nvim_set_hl(0, "BlinkCmpSource", { link = "Boolean" })

  -- completion scroll thumb color
  vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = color.get_hl_colors("String").foreground, nocombine = true })

  -- completion highlight coloring
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "Function" })

  -- lazygit border color
  vim.api.nvim_set_hl(0, "FloatBorder", { link = "Identifier" })
end
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = update_colors })

return {
  {
    "monokai-pro.nvim",
    colorscheme = "monokai-pro",
    after = function()
      require("monokai-pro").setup({
        transparent_background = true,
        terminal_colors = true,
        devicons = true, -- highlight the icons of `nvim-web-devicons`
        filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
        day_night = {
          enable = false, -- turn off by default
          day_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
          night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
        },
        background_clear = {
          "toggleterm",
          "notify",
        },
        inc_search = "background", -- underline | background
      })
    end,
  },
}
