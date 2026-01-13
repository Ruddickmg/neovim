local js_enabled = nixCats("javascript") or false

return {
  enabled = js_enabled,
  dependencies = {
    {
      "neotest-jest",
      for_cat = "testing",
      enabled = js_enabled,
      dep_of = "neotest",
    },
    {
      "neotest-vitest",
      for_cat = "testing",
      enabled = js_enabled,
      dep_of = "neotest",
    },
    {
      "neotest-playwright",
      for_cat = "testing",
      enabled = js_enabled,
      dep_of = "neotest",
    },
  },
  adapters = function()
    return {
      require("neotest-vitest"),
      require("neotest-playwright").adapter({
        options = {
          persist_project_selection = true,
          enable_dynamic_test_discovery = true,
        },
      }),
      require("neotest-jest")({
        jestCommand = "npm test --",
        jestArguments = function(defaultArguments, context)
          return defaultArguments
        end,
        jestConfigFile = "custom.jest.config.ts",
        env = { CI = true },
        cwd = function(path)
          return vim.fn.getcwd()
        end,
        isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
      }),
    }
  end,
}
