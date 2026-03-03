local nixUtils = require("nixCatsUtils")

return {
  {
    "project.nvim",
    lazy = false,
    after = function()
      -- for some reason the executable name is different in the nix packages, perhaps out of date
      require(nixUtils.isNixCats and "project" or "project_nvim").setup()
    end,
  },
}
