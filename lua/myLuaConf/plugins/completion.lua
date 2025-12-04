return {
  {
    "friendly-snippets",
    for_cat = "general.blink",
    dep_of = { "luasnip" },
  },
  {
    "luasnip",
    for_cat = "general.blink",
    dep_of = { "blink.cmp" },
    after = function(_)
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      local ls = require("luasnip")

      vim.keymap.set({ "i", "s" }, "<M-n>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
    end,
  },
  {
    "colorful-menu.nvim",
    for_cat = "general.blink",
    on_plugin = { "blink.cmp" },
  },
  {
    "blink.cmp",
    for_cat = "general.blink",
    event = "DeferredUIEnter",
    after = function(_)
      require("blink.cmp").setup({
        keymap = {
          preset = "default",
        },
        cmdline = {
          enabled = true,
          completion = {
            menu = {
              auto_show = true,
            },
          },
          sources = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == "/" or type == "?" then
              return { "buffer" }
            end
            -- Commands
            if type == ":" or type == "@" then
              return { "cmdline" }
            end
            return {}
          end,
        },
        fuzzy = {
          sorts = {
            "exact",
            -- defaults
            "score",
            "sort_text",
          },
        },
        signature = {
          enabled = true,
          window = {
            show_documentation = true,
          },
        },
        completion = {
          menu = {
            draw = {
              treesitter = { "lsp" },
              columns = { { "kind_icon" }, { "label", gap = 1 } },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = true,
          },
        },
        snippets = {
          preset = "luasnip",
          active = function()
            local snippet = require("luasnip")
            local blink = require("blink.cmp")
            if snippet.in_snippet() and not blink.is_visible() then
              return true
            else
              if not snippet.in_snippet() and vim.fn.mode() == "n" then
                snippet.unlink_current()
              end
              return false
            end
          end,
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "omni" },
          providers = {
            path = {
              score_offset = 50,
            },
            lsp = {
              score_offset = 40,
            },
            snippets = {
              score_offset = 40,
            },
            buffer = {
              score_offset = 30,
            },
            dadbod = {
              name = "Dadbod",
              module = "vim_dadbod_completion.blink",
            },
            cmdline = {
              module = "blink.cmp.sources.cmdline",
            },
          },
        },
      })
    end,
  },
}
