local nixColorScheme = nixCats("colorscheme")
local colorscheme = type(nixColorScheme) == "string" and nixColorScheme or "monokai-pro"
local lazy_packages = {
  { import = "myLuaConf.snacks" },
  { import = "myLuaConf.session" },
  { import = "myLuaConf.plugins" },
  { import = "myLuaConf.LSPs" },
  { import = "myLuaConf.colors" },
}

require("myLuaConf.opts_and_keys")

if nixCats("debug") then
  table.insert(lazy_packages, { import = "myLuaConf.debug" })
end
if nixCats("lint") then
  table.insert(lazy_packages, { import = "myLuaConf.lint" })
end
if nixCats("format") then
  table.insert(lazy_packages, { import = "myLuaConf.format" })
end

---@type lzextras | lze
local lze = require("lze")

-- register any handlers from lzextras you want
lze.register_handlers(require("nixCatsUtils.lzUtils").for_cat)
lze.register_handlers(require("lzextras").lsp)

lze.h.lsp.set_ft_fallback(function(name)
  error("No filetypes provided for " .. name)
end)

lze.load(lazy_packages)

vim.cmd.colorscheme(colorscheme)

vim.filetype.add({
  extension = {
    cjs = "javascript",
    mjs = "javascript",
  },
})
