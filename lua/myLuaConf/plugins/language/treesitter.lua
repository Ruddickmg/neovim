local set_select_key = function(keymap, target, description)
  vim.keymap.set({ "x", "o" }, keymap, function()
    require("nvim-treesitter-textobjects.select").select_textobject(target, "textobjects")
  end, { desc = description })
end

local set_move_to_end_key = function(keymap, target)
  vim.keymap.set({ "n", "x", "o" }, keymap, function()
    require("nvim-treesitter-textobjects.move").goto_next_end(target, "textobjects")
  end, { desc = "Move to the start of the next: " .. target })
end

local set_move_to_start_key = function(keymap, target)
  vim.keymap.set({ "n", "x", "o" }, keymap, function()
    require("nvim-treesitter-textobjects.move").goto_next_start(target, "textobjects")
  end, { desc = "Move to start of the next: " .. target })
end

local set_move_to_previous_end_key = function(keymap, target)
  vim.keymap.set({ "n", "x", "o" }, keymap, function()
    require("nvim-treesitter-textobjects.move").goto_previous_end(target, "textobjects")
  end, { desc = "Move to end of the previous: " .. target })
end

local set_move_to_previous_start_key = function(keymap, target)
  vim.keymap.set({ "n", "x", "o" }, keymap, function()
    require("nvim-treesitter-textobjects.move").goto_previous_start(target, "textobjects")
  end, { desc = "Move to the start of the previous: " .. target })
end

local set_keymaps = function(key, target)
  local inner = ".inner"
  local outer = ".outer"
  set_select_key("a" .. key, target .. outer, "Select outer " .. target)
  set_select_key("i" .. key, target .. inner, "Select inner " .. target)
  set_move_to_start_key("[" .. key, target .. outer)
  set_move_to_end_key("[" .. string.upper(key), target .. outer)
  set_move_to_previous_start_key("]" .. key, target .. outer)
  set_move_to_previous_end_key("]" .. string.upper(key), target .. outer)
end

local keys = {
  ["="] = "@assignment",
  ["a"] = "@parameter",
  ["b"] = "@block",
  ["c"] = "@class",
  ["d"] = "@attribute",
  ["e"] = "@call",
  ["f"] = "@function",
  ["i"] = "@conditional",
  ["l"] = "@loop",
  ["r"] = "@return",
  ["t"] = "@trait",
  ["x"] = "@regex",
}

local individual_keys = {
  ["a/"] = { query = "@comment.outer", desc = "Select comment" }, -- 14
  ["as"] = { query = "@statement.outer", desc = "Select statement" }, -- 31
  ["in"] = { query = "@number.inner", desc = "Select number" }, -- 23
  ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignmet" }, -- 1
  ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignmet" }, -- 2
}

return {
  {
    "nvim-treesitter",
    lazy = false,
    dep_of = { "treesitter-textobjects", "otter.nvim", "comment.nvim" },
    after = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({
        -- TODO: These will have to be kept in sync with flake.nix
        ensure_installed = {
          "query",
          "latex",
          "nix",
          "liquid",
          "markdown",
          "html",
          "tsx",
          "vim",
          "svelte",
          "javascript",
          "typescript",
          "regex",
          "lua",
          "toml",
          "bash",
          "markdown",
          "markdown_inline",
          "rust",
          "sql",
        },
      })

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then
          return
        end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = treesitter.get_available()

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local installed_parsers = treesitter.get_installed("parsers")

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` enable it after ensuring it is installed
            treesitter.install(language):await(function()
              treesitter_try_attach(buf, language)
            end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
  {
    "treesitter-textobjects",
    lazy = false,
    before = function()
      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main?tab=readme-ov-file#using-a-package-manager
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
    after = function()
      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
          },
          include_surrounding_whitespace = false,
        },
      })

      for key, mapping in pairs(individual_keys) do
        set_select_key(key, mapping.query, mapping.desc)
      end

      for key, target in pairs(keys) do
        set_keymaps(key, target)
      end

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ "x", "o" }, "as", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end)
    end,
  },
}
