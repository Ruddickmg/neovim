local keymap = {
  preset = "super-tab",
  -- ["<CR>"] = { "accept", "fallback" },
  ["<C-y>"] = { "accept", "fallback" },
  ["<Tab>"] = {
    "snippet_forward",
    function() -- sidekick next edit suggestion
      return require("sidekick").nes_jump_or_apply()
    end,
    -- TODO: uncomment when on neovim version 12+
    -- function() -- if you are using Neovim's native inline completions
    --   return vim.lsp.inline_completion.get()
    -- end,
    "accept",
    "fallback",
  },
}

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
    after = function()
      require("colorful-menu").setup({
        ls = {
          lua_ls = {
            arguments_hl = "@comment",
          },
          ts_ls = {
            extra_info_hl = "@comment",
          },
          vtsls = {
            extra_info_hl = "@comment",
          },
          ["rust-analyzer"] = {
            extra_info_hl = "@comment",
            align_type_to_right = true,
            preserve_type_when_truncate = true,
          },
          fallback = true,
          fallback_extra_info_hl = "@comment",
        },
        fallback_highlight = "@variable",
        max_width = 60,
      })
    end,
  },
  {
    "blink.cmp",
    for_cat = "general.blink",
    version = "1.*",
    event = "DeferredUIEnter",
    after = function()
      require("blink.cmp").setup({
        keymap = keymap,
        cmdline = {
          keymap = keymap,
          enabled = true,
          completion = {
            menu = {
              auto_show = true,
            },
          },
          sources = function()
            local type = vim.fn.getcmdtype()
            if type == "/" or type == "?" then
              return { "buffer" }
            end
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
            border = "rounded",
            draw = {
              treesitter = { "lsp" },
              columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name", gap = 1 } },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
                source_name = {
                  text = function(ctx)
                    if ctx.source_name == "LSP" then
                      local client_name = nil
                      pcall(function()
                        client_name = ctx.item.source.source.client.name
                      end)

                      if client_name then
                        return "[" .. client_name .. "]"
                      end
                    end

                    return "[" .. ctx.source_name .. "]"
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = true,
            window = {
              border = "rounded",
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            },
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
          default = { "lsp", "copilot", "omni", "npm", "path", "snippets", "buffer" },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-copilot",
              score_offset = 100,
              async = true,
            },
            path = {
              score_offset = 60,
            },
            lsp = {
              score_offset = 50,
            },
            npm = {
              name = "npm",
              module = "blink-cmp-npm",
              async = true,
              score_offset = 100,
              opts = {
                ignore = {},
                only_semantic_versions = false,
                only_latest_version = false,
              },
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
  {
    "blink.compat",
    version = "1.*",
    event = "DeferredUIEnter",
    dep_of = { "blink.cmp" },
  },
  {
    "blink-cmp-npm.nvim",
    ft = { "json" },
    event = "DeferredUIEnter",
    dep_of = { "blink.cmp" },
  },
}
