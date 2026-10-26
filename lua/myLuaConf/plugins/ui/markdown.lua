return {
  {
    "render-markdown.nvim",
    for_cat = "markdown",
    ft = "markdown",
    after = function()
      require("render-markdown").setup({
        completions = { lsp = { enabled = true } },
      })
    end,
  },
  {
    -- md-render auto-detects budoux for CJK phrase-aware line breaking.
    "budoux.lua",
    for_cat = "markdown",
    dep_of = "md-render.nvim",
  },
  {
    "md-render.nvim",
    for_cat = "markdown",
    ft = "markdown",
    keys = {
      {
        "<leader>mp",
        function()
          require("md-render").preview.show()
        end,
        desc = "Markdown preview (toggle)",
      },
      {
        "<leader>mt",
        function()
          require("md-render").preview.show_tab()
        end,
        desc = "Markdown preview in tab",
      },
      {
        "<leader>ms",
        function()
          require("md-render").preview.split()
        end,
        desc = "Markdown preview in split",
      },
      {
        "<leader>mo",
        function()
          require("md-render").preview.toggle()
        end,
        desc = "Markdown render in place",
      },
      {
        "<leader>ma",
        function()
          require("md-render").preview.auto_toggle()
        end,
        desc = "Markdown auto render (experimental)",
      },
      {
        "<leader>md",
        function()
          require("md-render").preview.show_demo()
        end,
        desc = "Markdown render demo",
      },
    },
    after = function()
      -- OSC 66 text sizing is Kitty-only. md-render explicitly disables it
      -- for terminals like Ghostty, so this is a no-op there.
      require("md-render.text_size").setup({ enabled = true })

      -- Use more of a wide terminal window (default is 80).
      vim.g.md_render_max_width = 120
    end,
  },
}
