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
    vim.opt.runtimepath:prepend(M.dev_path)
    -- Point the native loader at the dev build instead of <root>/lib/
    local binary = require("hermes.binary")
    local original = binary.get_rock_binary_path
    binary.get_rock_binary_path = function()
      if vim.fn.filereadable(M.build_path) == 1 then
        return M.build_path
      end
      notify(
        'No release found at build path "' + M.build_path + '", build hermes and try again. Defaulting to non-dev',
        vim.log.levels.ERROR
      )
      M.disable()
      return original()
    end
  end
  M.setup()
end

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Hermes Environment" })
end

function M.enable()
  if vim.fn.filereadable(M.build_path) == 0 then
    notify(
      "Cannot enable Hermes dev mode: "
        .. M.build_path
        .. " not found.\nRun 'cargo build --release' in "
        .. M.dev_path
        .. " first.",
      vim.log.levels.ERROR
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
    notify("Hermes environment: installed — restarting...")
  else
    if not M.enable() then
      return
    end
    notify("Hermes environment: local dev (" .. M.dev_path .. ") — restarting...")
  end
  vim.cmd("restart")
end

function M.setup()
  local desc = "Toggle Hermes [E]nvironment"
  local ok, Snacks = pcall(require, "snacks")
  if ok then
    Snacks.keymap.set("n", "<leader>aE", M.toggle, { desc = desc })
  else
    vim.keymap.set("n", "<leader>aE", M.toggle, { desc = desc })
  end

  vim.api.nvim_create_user_command("HermesEnvironment", M.toggle, {
    desc = desc,
  })
end

return M
