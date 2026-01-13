local toHex = function(num)
  return num ~= nil and string.format("#%06x", num) or "none"
end

local function get_hl_colors(group_name)
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group_name, true)
  if not ok or not hl then
    vim.notify("Couldn't find highlight colors for highlight group " .. group_name)
    return {
      background = "none",
      foreground = "none",
    }
  end
  return {
    background = toHex(hl.background),
    foreground = toHex(hl.foreground),
  }
end

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
  vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = get_hl_colors("String").foreground, nocombine = true })

  -- completion highlight coloring
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "Function" })
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
