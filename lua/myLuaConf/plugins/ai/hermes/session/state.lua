local history = require("myLuaConf.plugins.ai.hermes.prompts.history")
local state_file = vim.fn.stdpath("state") .. "/hermes.json"

---@class Session
---@field history PromptHistory
local Session = {}

---@return Session
function Session.new()
  local self = {
    history = history.new(),
  }
  setmetatable(self, { __index = Session })
  return self
end

---@alias Sessions table<string, Session>
local Sessions = {}

---@return Sessions
function Sessions.new()
  local self = {}
  setmetatable(self, { __index = Sessions })
  return self
end

---@param session_id string
---@return Session
function Sessions:get(session_id)
  if self[session_id] == nil then
    self[session_id] = Session.new()
  end
  return self[session_id]
end

---@param sessions Sessions
---@return Sessions
function Sessions:load(sessions)
  for session_id, session_data in pairs(sessions) do
    self[session_id] = session_data
  end
  return self
end

return Sessions
