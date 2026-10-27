local Event = require("hermes").Autocommand
local session = require("myLuaConf.plugins.ai.hermes.session")
local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging").new("Ask")
local M = {}

M.ask = function(session_id)
  logger:trace("asking")
  if session_id == nil then
    logger:warn("Please select a session before attempting to prompt")
    return
  end
  vim.ui.input({ prompt = "Ask: " }, function(input)
    if input ~= "" then
      logger:debug("Asking: " .. input .. ", session id: " .. (session_id or "empty"))
      vim.api.nvim_exec_autocmds("User", {
        pattern = Event.UserTextMessage,
        ---@type HermesUserTextMessage
        data = {
          data = {
            promptId = "random",
            sessionId = session.session_id,
            sessionUpdate = "user_message_chunk",
            content = {
              type = "text",
              text = input,
              annotations = {},
            },
          },
        },
      })
      -- require("hermes").prompt(session_id, {
      --   type = "text",
      --   text = input,
      -- })
    end
  end)
end

return M
