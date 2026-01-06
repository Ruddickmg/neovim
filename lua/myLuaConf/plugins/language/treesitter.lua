-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
return {
  {
    "nvim-treesitter",
    for_cat = "general.treesitter",
    dep_of = { "neotest", "trouble.nvim" },
    -- cmd = { "" },
    event = "DeferredUIEnter",
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("nvim-treesitter-textobjects")
    end,
    after = function()
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      local treesitter = require("nvim-treesitter")

      treesitter.setup({
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<M-space>",
          },
        },
        textobjects = {
          lsp_interop = {
            enable = true,
            border = "none",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of assignmet" }, -- 1
              ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of assignmet" }, -- 2
              ["a="] = { query = "@assignment.outer", desc = "Select right hand side of assignmet" }, -- 3
              ["i="] = { query = "@assignment.inner", desc = "Select right hand side of assignmet" }, -- 4
              ["aa"] = { query = "@attribute.outer", desc = "Select outer attribute" }, -- 5,
              ["ia"] = { query = "@attribute.inner", desc = "Select outer attribute" }, -- 6,
              ["ib"] = { query = "@block.inner", desc = "Select inner block" }, -- 7
              ["ab"] = { query = "@block.outer", desc = "Select outer block" }, -- 8
              ["ic"] = { query = "@call.inner", desc = "Select inner call" }, -- 9
              ["ac"] = { query = "@call.outer", desc = "Select outer call" }, -- 10
              ["iC"] = { query = "@class.inner", desc = "Select inner class" }, -- 11
              ["aC"] = { query = "@class.outer", desc = "Select outer class" }, -- 12

              ["a/"] = { query = "@comment.outer", desc = "Select" }, -- 14
              ["ai"] = { query = "@conditional.outer", desc = "Select outer conditional" }, -- 15
              ["ii"] = { query = "@conditional.inner", desc = "Select inner conditional" }, -- 16

              ["af"] = { query = "@function.outer", desc = "Select outer function" }, -- 19
              ["if"] = { query = "@function.inner", desc = "Select inner function" }, -- 20
              ["al"] = { query = "@loop.outer", desc = "Select outer loop" }, -- 21
              ["il"] = { query = "@loop.inner", desc = "Select inner loop" }, -- 22
              ["in"] = { query = "@number.inner", desc = "Select inner number" }, -- 23
              ["ap"] = { query = "@parameter.outer", desc = "Select outer part of parameter/argument" }, -- 24
              ["ip"] = { query = "@parameter.inner", desc = "Select inner part of parameter/argument" }, -- 25

              ["ax"] = { query = "@regex.outer", desc = "Select outer regex" }, -- 26
              ["ix"] = { query = "@regex.inner", desc = "Select inner regex" }, -- 27
              ["ar"] = { query = "@return.outer", desc = "Select outer return" }, -- 28
              ["ir"] = { query = "@return.inner", desc = "Select inner return" }, -- 29

              ["as"] = { query = "@statement.outer", desc = "Select outer statement" }, -- 31
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
}
