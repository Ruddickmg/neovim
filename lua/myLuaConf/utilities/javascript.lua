local M = {}

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function project_root()
  local project_markers = { "package.json" }
  local current_file_path = vim.api.nvim_buf_get_name(0) -- Get the path of the current buffer's file
  return vim.fs.root(current_file_path, project_markers)
end

local function detect_package_manager()
  local path = project_root()
  local pm = "npm"
  local package_managers = {
    pnpm = "pnpm-lock.yaml",
    yarn = "yarn.lock",
    bun = "bun.lockb",
  }

  for manager, filename in pairs(package_managers) do
    if file_exists(path .. "/" .. filename) then
      pm = manager
    end
  end
  return pm
end

M.scripts = function()
  Snacks.picker.pick({
    title = "Scripts",
    format = "text",
    preview = "preview",
    finder = function(opts, ctx)
      local json = vim.fn.json_decode(vim.fn.readfile(project_root() .. "/package.json"))
      local scripts = json and json.scripts or {}
      local items = {}
      local package_manager = detect_package_manager()
      for name, cmd in pairs(scripts) do
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
            cwd = project_root(),
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

return M
