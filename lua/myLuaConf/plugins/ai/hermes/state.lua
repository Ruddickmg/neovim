local Sessions = require("myLuaConf.plugins.ai.hermes.session.state")
local utilities = require("myLuaConf.plugins.ai.hermes.utilities")
local Logger = require("myLuaConf.plugins.ai.hermes.utilities.logging")
local state_file = vim.fn.stdpath("state") .. "/hermes.json"
local logger = Logger.new("State")

---@class State
---@field session Sessions
---@field agent_id string | nil
---@field session_id string | nil
---@field distribution string | nil
local State = {}

---@return State
function State.new()
  ---@type State
  local self = {
    session = Sessions.new(),
    distribution = nil,
    agent_id = nil,
    session_id = nil
  }
  setmetatable(self, { __index = State })
  return self
end

function State:save()
  logger:trace("Saving application state")
  local data = vim.json.encode(utilities.strip_non_serializable_data(self))
  logger:debug(data)
  vim.fn.writefile({ data }, state_file)
  logger:trace("Application state saved successfully")
end


---@return State
function State:load()
  logger:trace("Loading application state file from path: " .. state_file)
  ---@type boolean, State
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(state_file)))
  end)
  logger:debug({ ok, data })
  if ok and type(data) == "table" then
    self.agent_id = data.agent_id
    self.distribution = data.distribution
    self.session_id = data.session_id
    self.session:load(data.session or {})
    logger:debug(vim.inspect(self))
  end
    logger:trace("Application state updated: ")
  return self
end

return State
