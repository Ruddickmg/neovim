-- TODO: remove this when no longer debugging/in development
package.loaded['hermes'] = nil
-- vim.notify(vim.inspect(package.loaded))
vim.opt.runtimepath:prepend("/var/www/hermes")
require("nixCatsUtils").setup({
  non_nix_value = true,
})
require("myLuaConf.non_nix_download")
require("myLuaConf")
