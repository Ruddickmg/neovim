-- load the plugins via paq-nvim when not on nix

require('nixCatsUtils.catPacker').setup({
  --  NOTE:  we take care of lazy loading elsewhere in an autocommand
    -- so that we can use the same code on and off nix.
    -- so here we just tell it not to auto load it
  { 'folke/lazydev.nvim', opt = true, },
  { "BirdeeHub/lze", },
  { "BirdeeHub/lzextras", },

  -- actions
  { 'tpope/vim-repeat', },
  { 'gbprod/substitute.nvim', opt = true, },
  { 'numToStr/Comment.nvim', opt = true, as = "comment.nvim", },
  { 'antosha417/nvim-lsp-file-operations', opt = true, },

  -- file system
  { "stevearc/oil.nvim", },
  { 'mikavilpas/yazi.nvim', opt = true, },

  -- testing
  { 'nvim-neotest/nvim-nio', },
  { 'nvim-neotest/neotest', opt = true, },
  { 'nvim-neotest/neotest-plenary', opt = true, },
  { 'nvim-lua/plenary.nvim', },
  { 'antoinemadec/FixCursorHold.nvim', opt = true, },

  -- debugging
  { 'rcarriga/nvim-dap-ui', opt = true, },
  { 'theHamsta/nvim-dap-virtual-text', opt = true, },
  { 'mfussenegger/nvim-dap', opt = true, },

  -- ui
  { 'nvim-tree/nvim-web-devicons', },
  { 'loctvl842/monokai-pro.nvim', },
  { 'rcarriga/nvim-notify', },
  { 'folke/snacks.nvim', },
  { 'folke/noice.nvim', },
  { 'folke/trouble.nvim', opt = true, },
  { 'folke/which-key.nvim', opt = true, },
  { 'folke/persistence.nvim', opt = true, },
  { 'folke/todo-comments.nvim' , opt = true }, 
  { 'folke/which-key.nvim', opt = true, },
  { 'nvim-lualine/lualine.nvim', opt = true, },
  { 'rachartier/tiny-inline-diagnostic.nvim', opt = true, },
  { 'aznhe21/actions-preview.nvim', opt = true, },
  { 'arkav/lualine-lsp-progress', opt = true, },

  -- language
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = "main", opt = true, as = "treesitter-textobjects" },
  { 'nvim-treesitter/nvim-treesitter', branch = "main", build = ':TSUpdate', opt = true, },

  -- lsp
  { 'williamboman/mason.nvim', opt = true, },
  { 'williamboman/mason-lspconfig.nvim', opt = true, },
  { 'neovim/nvim-lspconfig', opt = true, },
  { 'mrcjkb/rustaceanvim', },

  -- database
  { 'tpope/vim-dadbod', opt = true, },
  { 'kristijanhusak/vim-dadbod-ui', opt = true, },
  { 'kristijanhusak/vim-dadbod-completion', opt = true, },

  -- completion
  { 'L3MON4D3/LuaSnip', opt = true, as = "luasnip", },
  { 'Saghen/blink.cmp', opt = true, branch = 'v1.8.0', },
  { 'Saghen/blink.compat', opt = true, },
  { 'xzbdmw/colorful-menu.nvim', opt = true, },
  { 'kylechui/nvim-surround', opt = true, },
  { 'windwp/nvim-autopairs', opt = true, },
  { 'windwp/nvim-ts-autotag', opt = true, },

  -- lint and format
  { 'mfussenegger/nvim-lint', opt = true, },
  { 'stevearc/conform.nvim', opt = true, },

  -- vcs
  { 'mbbill/undotree', opt = true, },
  { 'sindrets/diffview.nvim', opt = true, },
  { 'lewis6991/gitsigns.nvim', opt = true, },
})
