local colorscheme = nixCats("colorscheme")
local elements = {
  "statusline",
  "TabLine",
  "TabLineFill",
  "SnacksPicker",
  "SnacksPickerBorder",
  "WhichKeyNormal",
  "Normal",
  "NormalFloat",
}

local clear_backgrounds = function()
  for _, element in ipairs(elements) do
    vim.api.nvim_set_hl(0, element, { bg = "none", nocombine = true })
  end
end

require("lze").load({
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
})

vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = clear_backgrounds })

vim.cmd.colorscheme(colorscheme)
