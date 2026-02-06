local location = require("myLuaConf.utilities.location")

local function detect_package_manager()
  local path = location.project_root()
  local package_manager = "npm"
  local package_managers = {
    pnpm = "pnpm-lock.yaml",
    yarn = "yarn.lock",
    bun = "bun.lockb",
  }

  for manager, filename in pairs(package_managers) do
    if location.file_exists((path or "") .. "/" .. filename) then
      package_manager = manager
    end
  end
  return package_manager
end

local function scripts()
  Snacks.picker.pick({
    title = "Scripts",
    format = "text",
    preview = "preview",
    finder = function()
      local json = vim.fn.json_decode(vim.fn.readfile(location.project_root() .. "/package.json"))
      local script_definitions = json and json.scripts or {}
      local items = {}
      local package_manager = location.node_package_manager()
      for name, cmd in pairs(script_definitions) do
        table.insert(items, {
          text = name,
          cmd = cmd,
          preview = {
            text = package_manager .. " run " .. cmd,
          },
        })
      end
      return items
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        require("plenary.job")
          :new({
            command = detect_package_manager(),
            args = { "run", item.text },
            cwd = location.project_root(),
            on_exit = function(job, code)
              local result = job:result()
              local message = ""
              for _, value in pairs(result) do
                message = message .. value .. "\n"
              end
              vim.notify(message, code == 0 and "info" or "error")
            end,
          })
          :start()
      end
    end,
  })
end

return {
  package_manager = detect_package_manager,
  scripts = scripts,
}
