local in_package_json = string.find(vim.api.nvim_buf_get_name(0), "package.json") or false

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
    enable = in_package_json,
    after = function()
      if in_package_json then
        local info = require("package-info")
        info.setup({
          autostart = false,
          hide_up_to_date = true,
        })
        Snacks.keymap.set("n", "<leader>fd", info.toggle, { noremap = true, desc = "[d]ependencies" })
        Snacks.keymap.set("n", "<leader>cv", info.change_version, { noremap = true, desc = "[v]ersion" })
        Snacks.keymap.set("n", "<leader>js", require("myLuaConf.utilities.javascript").scripts, { desc = "[s]cripts" })
      end
    end,
  },
}
