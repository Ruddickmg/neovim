return {
  {
    "yamlls",
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
    enabled = string.find(vim.api.nvim_buf_get_name(0), "package.json"),
    after = function()
      local info = require("package-info")
      info.setup()
      vim.keymap.set({ "n" }, "<LEADER>td", info.toggle, { silent = true, noremap = true, desc = "[d]ependencies" })
      vim.keymap.set(
        { "n" },
        "<leader>js",
        require("myLuaConf.utilities.js-scripts").scripts,
        { silent = true, desc = "[j]avascript[s]cripts" }
      )
    end,
  },
}
