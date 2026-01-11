local in_package_json = string.find(vim.api.nvim_buf_get_name(0), "package.json")

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
    enabled = in_package_json,
    after = function()
      local info = require("package-info")
      info.setup()
      vim.keymap.set({ "n" }, "<LEADER>td", info.toggle, { silent = true, noremap = true, desc = "[d]ependencies" })
      Snacks.keymap.set("n", "<leader>cv", info.change_version, { silent = true, noremap = true, desc = "[v]ersion" })
      Snacks.keymap.set(
        { "n" },
        "<leader>js",
        require("myLuaConf.utilities.javascript").scripts,
        { silent = true, desc = "[s]cripts" }
      )
    end,
  },
  {
    "nui.nvim",
    enabled = in_package_json,
    dep_of = { "package-info.nvim" },
  },
}
