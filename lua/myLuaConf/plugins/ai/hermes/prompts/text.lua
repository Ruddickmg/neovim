local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging").new("Ask")
local M = {}

M.ask = function(session_id)
  logger:info("asking")
  if session_id == nil then
    logger:warn("Please select a session before attempting to prompt")
    return
  end
  vim.ui.input({ prompt = "Ask: " }, function(input)
    if input ~= "" then
      logger:debug("Asking: " .. input .. ", session id: " .. (session_id or "empty"))
      require("hermes").prompt(session_id, {
        type = "text",
        text = input,
      })
    end
  end)
end

return M
