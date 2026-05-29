local M = {}

M.ask = function(session_id)
  if session_id == nil then
    vim.notify("Please select a session before attempting to prompt", vim.log.levels.WARN, { title = "Hermes" })
    return
  end
  vim.ui.input({ prompt = "Ask: " }, function(input)
    if input ~= "" then
      vim.notify("Asking: " .. input .. ", session id: " .. (session_id or "empty"), vim.log.levels.INFO, { title = "Hermes" })
      require("hermes").prompt(session_id, {
        type = "text",
        text = input,
      })
    end
  end)
end

return M
