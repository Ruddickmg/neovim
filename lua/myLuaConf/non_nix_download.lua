-- load the plugins via paq-nvim when not on nix
require("nixCatsUtils.catPacker").setup({
  -- my plugin
  -- { "/var/www/connect.nvim", opt = true },

  --  NOTE:  we take care of lazy loading elsewhere in an autocommand
  -- so that we can use the same code on and off nix.
  -- so here we just tell it not to auto load it
  { "folke/lazydev.nvim", opt = true },
  { "BirdeeHub/lze" },
  { "BirdeeHub/lzextras" },

  -- actions
  -- { "tpope/vim-repeat" },
  { "gbprod/substitute.nvim", opt = true },
  { "folke/flash.nvim", opt = true },
  { "numToStr/Comment.nvim", opt = true, as = "comment.nvim" },
  { "antosha417/nvim-lsp-file-operations", opt = true },
  { "michaelb/sniprun", build = "sh ./install.sh 1", opt = true },

  -- file system & navigation
  { "ahmedkhalf/project.nvim" },
  { "stevearc/oil.nvim" },
  { "mikavilpas/yazi.nvim", opt = true },
  { "stevearc/aerial.nvim", opt = true },
  { "Pocco81/auto-save.nvim", opt = true },

  -- testing
  { "nvim-lua/plenary.nvim" },
  { "antoinemadec/FixCursorHold.nvim", opt = true },
  { "nvim-neotest/nvim-nio" },
  { "nvim-neotest/neotest", opt = true },
  { "nvim-neotest/neotest-plenary", opt = true },
  { "nvim-neotest/neotest-jest", opt = true },
  { "thenbe/neotest-playwright", opt = true },
  { "marilari88/neotest-vitest", opt = true },

  -- debugging
  { "rcarriga/nvim-dap-ui", opt = true },
  { "theHamsta/nvim-dap-virtual-text", opt = true },
  { "mfussenegger/nvim-dap", opt = true },
  { "folke/trouble.nvim", opt = true },

  -- ui
  { "MunifTanjim/nui.nvim", opt = true },
  { "nvim-tree/nvim-web-devicons" },
  { "folke/snacks.nvim" },
  { "folke/which-key.nvim", opt = true },
  { "folke/todo-comments.nvim", opt = true },
  { "aznhe21/actions-preview.nvim", opt = true },

  -- aesthetic
  { "nvim-lualine/lualine.nvim", opt = true },
  { "arkav/lualine-lsp-progress", opt = true },
  { "rachartier/tiny-inline-diagnostic.nvim", opt = true },
  { "folke/noice.nvim", opt = true },
  { "loctvl842/monokai-pro.nvim" },
  { "smjonas/inc-rename.nvim", opt = true },
  { "MeanderingProgrammer/render-markdown.nvim", opt = true },

  -- language
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main", opt = true, as = "treesitter-textobjects" },
  { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate", opt = true },

  -- lsp
  { "williamboman/mason.nvim", opt = true },
  { "williamboman/mason-lspconfig.nvim", opt = true },
  { "neovim/nvim-lspconfig", opt = true },
  { "pmizio/typescript-tools.nvim", opt = true },
  { "vuki656/package-info.nvim", opt = true },
  { "jmbuhr/otter.nvim", opt = true },
  -- { "Ruddickmg/connect.nvim", opt = true },
  { "b0o/schemastore.nvim" },
  { "mrcjkb/rustaceanvim" },

  -- completion
  { "L3MON4D3/LuaSnip", opt = true, as = "luasnip" },
  { "saghen/blink.cmp", branch = "v1", build = "cargo build --release", opt = true },
  { "Saghen/blink.compat", opt = true },
  { "xzbdmw/colorful-menu.nvim", opt = true },
  { "kylechui/nvim-surround", opt = true },
  { "windwp/nvim-autopairs", opt = true },
  { "windwp/nvim-ts-autotag", opt = true },
  { "alexandre-abrioux/blink-cmp-npm.nvim", opt = true },

  -- lint and format
  { "mfussenegger/nvim-lint", opt = true },
  { "stevearc/conform.nvim", opt = true },
  { "esmuellert/nvim-eslint", opt = true },

  -- vcs
  { "mbbill/undotree", opt = true },
  { "sindrets/diffview.nvim", opt = true },
  { "lewis6991/gitsigns.nvim", opt = true },

  -- ai
  { "nickjvandyke/opencode.nvim", opt = true },
  { "zbirenbaum/copilot.lua", opt = true },
  { "CopilotC-Nvim/CopilotChat.nvim", opt = true },
  { "fang2hou/blink-copilot", opt = true },
})
