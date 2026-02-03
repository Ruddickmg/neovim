local node = require("myLuaConf.utilities.javascript")
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
        jestCommand = node.package_manager() .. " run jest",
        jestArguments = function(defaultArguments)
          return defaultArguments
        end,
        jestConfigFile = "kest.config.ts",
        cwd = function()
          return vim.fn.getcwd()
        end,
        isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
      }),
    }
  end,
}
