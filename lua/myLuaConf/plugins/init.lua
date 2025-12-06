local ok, notify = pcall(require, "notify")
if ok then
  notify.setup({
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  })
  vim.notify = notify
  vim.keymap.set("n", "<Esc>", function()
    notify.dismiss({ silent = true })
  end, { desc = "dismiss notify popup and clear hlsearch" })
end

return {
  { import = "myLuaConf.plugins.session-manager" },
  { import = "myLuaConf.plugins.treesitter" },
  { import = "myLuaConf.plugins.completion" },
  {
    "markdown-preview.nvim",
    -- NOTE: for_cat is a custom handler that just sets enabled value for us,
    -- based on result of nixCats('cat.name') and allows us to set a different default if we wish
    -- it is defined in luaUtils template in lua/nixCatsUtils/lzUtils.lua
    -- you could replace this with enabled = nixCats('cat.name') == true
    -- if you didnt care to set a different default for when not using nix than the default you already set
    for_cat = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview <CR>", mode = { "n" }, noremap = true, desc = "markdown preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop <CR>", mode = { "n" }, noremap = true, desc = "markdown preview stop" },
      {
        "<leader>mt",
        "<cmd>MarkdownPreviewToggle <CR>",
        mode = { "n" },
        noremap = true,
        desc = "markdown preview toggle",
      },
    },
    before = function()
      vim.g.mkdp_auto_close = 0
    end,
  },
  {
    "undotree",
    for_cat = "general.extra",
    cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo" },
    keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" } },
    before = function(_)
      vim.g.undotree_WindowLayout = 1
      vim.g.undotree_SplitWidth = 40
    end,
  },
  {
    "comment.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function()
      require("Comment").setup()
    end,
  },
  {
    "nvim-surround",
    for_cat = "general.always",
    event = "DeferredUIEnter",
    -- keys = "",
    after = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "vim-startuptime",
    for_cat = "general.extra",
    cmd = { "StartupTime" },
    before = function()
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
      vim.g.startuptime_exe_path = nixCats.packageBinPath
    end,
  },
  { import = "myLuaConf.plugins.neotest" },
  { import = "myLuaConf.plugins.gitsigns" },
  { import = "myLuaConf.plugins.trouble" },
  { import = "myLuaConf.plugins.lualine" },
  { import = "myLuaConf.plugins.dadbod" },
  { import = "myLuaConf.plugins.which-key" },
  { import = "myLuaConf.plugins.auto-pairs" },
  { import = "myLuaConf.plugins.todo-comments" },
  { import = "myLuaConf.plugins.auto-tag" },
  { import = "myLuaConf.plugins.yazi" },
  { import = "myLuaConf.plugins.oil" },
  { import = "myLuaConf.plugins.substitute" },
  { import = "myLuaConf.plugins.lsp-lines" },
  { import = "myLuaConf.plugins.code-actions" },
}
