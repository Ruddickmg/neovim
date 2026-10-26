local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging").new("Environment")

local M = {}

local marker = vim.fn.stdpath("state") .. "/hermes-dev-mode"

M.dev_path = "/var/www/hermes.nvim"
M.build_path = M.dev_path .. "/target/release/libhermes.so"

function M.enabled()
  return vim.fn.filereadable(marker) == 1
end

function M.detect()
  if M.detected then
    return
  end
  M.detected = true
  vim.g.hermes_dev = M.enabled()
  if vim.g.hermes_dev then
    -- Prefer the dev repo for both runtime files and Lua module resolution.
    vim.opt.runtimepath:prepend(M.dev_path)
    package.path = M.dev_path .. "/lua/?.lua;" .. M.dev_path .. "/lua/?/init.lua;" .. package.path

    -- Drop any hermes modules already cached from the nix-store build so the
    -- dev repo's Lua code is used consistently.
    for name in pairs(package.loaded) do
      if name == "hermes" or name:match("^hermes%.") then
        package.loaded[name] = nil
      end
    end

    -- Re-source the dev plugin script so its commands/autocmds replace the
    -- nix-store ones.
    pcall(vim.cmd, "source " .. vim.fn.fnameescape(M.dev_path .. "/plugin/hermes.lua"))

    -- Point the native loader at the dev build instead of <root>/lib/
    local binary = require("hermes.binary")
    local original = binary.get_rock_binary_path
    binary.get_rock_binary_path = function()
      if vim.fn.filereadable(M.build_path) == 1 then
        return M.build_path
      end
      logger:error(
        'No release found at build path "' .. M.build_path .. '", build hermes and try again. Defaulting to non-dev'
      )
      M.disable()
      return original()
    end
  end
  M.setup()
end

function M.enable()
  if vim.fn.filereadable(M.build_path) == 0 then
    logger:error(
      "Cannot enable Hermes dev mode: "
        .. M.build_path
        .. " not found.\nRun 'cargo build --release' in "
        .. M.dev_path
        .. " first."
    )
    return false
  end

  vim.fn.writefile({ os.date("%Y-%m-%dT%H:%M:%S") }, marker)
  return true
end

function M.disable()
  pcall(vim.fn.delete, marker)
  return true
end

function M.toggle()
  if M.enabled() then
    M.disable()
    logger:debug("Hermes environment: installed — restarting...")
  else
    if not M.enable() then
      return
    end
    logger:debug("Hermes environment: local dev (" .. M.dev_path .. ") — restarting...")
  end
  vim.cmd("restart")
end

function M.setup()
  local desc = "[E]nvironment (development)"
  local ok, Snacks = pcall(require, "snacks")
  if ok then
    local toggle = Snacks.toggle.new({
      name = "Development",
      get = M.enabled,
      set = function(state)
        if state then
          if not M.enable() then
            return
          end
        else
          M.disable()
        end
      end,
      notify = function(state)
        if M.enabled() ~= state then
          return -- enable failed; M.enable() already notified why
        end
        local env = state and ("local dev (" .. M.dev_path .. ")") or "installed"
        logger:debug("restarting " .. env)
        vim.cmd("restart")
      end,
    })
    toggle:map("<leader>aE")
    vim.api.nvim_create_user_command("HermesEnvironment", function()
      toggle:toggle()
    end, { desc = desc })
  else
    vim.keymap.set("n", "<leader>aE", M.toggle, { desc = desc })
    vim.api.nvim_create_user_command("HermesEnvironment", M.toggle, { desc = desc })
  end
end

return M
