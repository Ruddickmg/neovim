
require('myLuaConf.opts_and_keys')
require("lze").register_handlers(require('nixCatsUtils.lzUtils').for_cat)
require('lze').register_handlers(require('lzextras').lsp)
require("myLuaConf.plugins")
require("myLuaConf.LSPs")

if nixCats('debug') then
  require('myLuaConf.debug')
end
if nixCats('lint') then
  require('myLuaConf.lint')
end
if nixCats('format') then
  require('myLuaConf.format')
end

require('myLuaConf.colors')

vim.diagnostic.config({
  virtual_text = {
    source = true,
  },
  underline = true, -- Underline problematic lines
  -- You can also configure specific highlight groups for different diagnostic severities
  -- For example:
  -- severity_sort = true, -- Sort diagnostics by severity
})
