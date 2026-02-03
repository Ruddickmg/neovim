local catUtils = require("nixCatsUtils")
local on_attach = require("myLuaConf.LSPs.on_attach")

if catUtils.isNixCats and nixCats("lspDebugMode") then
  vim.lsp.set_log_level("debug")
end

-- NOTE: This file uses lzextras.lsp handler https://github.com/BirdeeHub/lzextras?tab=readme-ov-file#lsp-handler
-- This is a slightly more performant fallback function
-- for when you don't provide a filetype to trigger on yourself.
-- nixCats gives us the paths, which is faster than searching the rtp!
local old_ft_fallback = require("lze").h.lsp.get_ft_fallback()
require("lze").h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" })
    or nixCats.pawsible({ "allPlugins", "start", "nvim-lspconfig" })
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    if not ok then
      ok, cfg = pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
    end
    return (ok and cfg or {}).filetypes or {}
  else
    return old_ft_fallback(name)
  end
end)

return {
  {
    "nvim-lspconfig",
    for_cat = "general.always",
    on_require = { "lspconfig" },
    -- NOTE: define a function for lsp,
    -- and it will run for all specs with type(plugin.lsp) == table
    -- when their filetype trigger loads them
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.lsp.config("*", {
        on_attach = on_attach,
      })
    end,
  },
  {
    "mason.nvim",
    -- only run it when not on nix
    enabled = not catUtils.isNixCats,
    on_plugin = { "nvim-lspconfig" },
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("mason-lspconfig.nvim")
      require("mason").setup()
      -- auto install will make it install servers when lspconfig is called on them.
      require("mason-lspconfig").setup({
        -- TODO: these will have to be kept in sync with nix, haven't found a better solution
        ensure_installed = {
          "postgres_lsp",
          "ts_ls",
          "yamlls",
          "jsonls",
          "terraformls",
          "dockerls",
          "just",
          "tombi",
          -- nix
          "rnix",
          "nil_ls",
          -- lua
          "lua_ls",
          "stylua",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    -- lazydev makes your lsp way better in your config without needing extra lsp configuration.
    "lazydev.nvim",
    for_cat = "neonixdev",
    cmd = { "LazyDev" },
    ft = "lua",
    after = function(_)
      require("lazydev").setup({
        library = {
          { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
        },
      })
    end,
  },
  { import = "myLuaConf.LSPs.rust-analyzer" },
  { import = "myLuaConf.LSPs.typescript" },
  { import = "myLuaConf.LSPs.tombi" },
  { import = "myLuaConf.LSPs.docker" },
  { import = "myLuaConf.LSPs.config-files" },
  { import = "myLuaConf.LSPs.nix" },
  { import = "myLuaConf.LSPs.lua_ls" },
  { import = "myLuaConf.LSPs.postgres" },
  { import = "myLuaConf.LSPs.just" },
  { import = "myLuaConf.LSPs.terraform" },
}
