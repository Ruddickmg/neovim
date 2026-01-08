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
}
