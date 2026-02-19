return {
  {
    "yamlls",
    event = { "BufReadPre", "BufNewFile" },
    lsp = {
      settings = {
        yaml = {
          schemaStore = {
            -- You must disable built-in schemaStore support if you want to use
            -- this plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = "",
          },
          schemas = require("schemastore").yaml.schemas({
            select = {
              "docker-compose.yml",
            },
          }),
          validate = {
            enable = true,
          },
        },
      },
    },
  },
  {
    "jsonls",
    event = { "BufReadPre", "BufNewFile" },
    lsp = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas({
            select = {
              ".eslintrc",
              "package.json",
              "tsconfig.json",
            },
          }),
          validate = { enable = true },
        },
      },
    },
  },
  {
    "package-info.nvim",
    event = { "BufReadPre", "BufNewFile" },
    enable = function()
      return string.find(vim.api.nvim_buf_get_name(0), "package.json") or false
    end,
    after = function()
      local info = require("package-info")
      info.setup({
        autostart = false,
        hide_up_to_date = true,
      })
      Snacks.keymap.set("n", "<leader>d", info.toggle, { noremap = true, desc = "[d]ependencies" })
      Snacks.keymap.set("n", "<leader>v", info.change_version, { noremap = true, desc = "[v]ersion" })
      Snacks.keymap.set("n", "<leader>rs", require("myLuaConf.utilities.javascript").scripts, { desc = "[s]cripts" })
    end,
  },
}
