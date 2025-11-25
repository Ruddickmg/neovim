-- make background transparent
-- require('colorscheme').setup({ transparent = true })
local locations = {"Normal", "NormalFloat", "FloatBorder"}

for _, element in ipairs(locations) do 
  vim.api.nvim_set_hl(0, element, { bg = 'none' })
end
