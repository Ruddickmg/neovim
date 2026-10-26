local hermes = require("hermes")
local Event = hermes.Autocommand

---@param message HermesPlan
---@return string
local renderPlan = function(message)
  local text = ""
  for _, entry in ipairs(message.update.entries) do
    text = text .. "status: " .. entry.status .. "\n"
    text = text .. "priority: " .. entry.priority .. "\n"
    text = text .. "content: " .. entry.content .. "\n---\n"
  end
  return text
end

---@param message HermesToolCall
---@return string
local renderToolCall = function(message)
  local content = message.update.content
  return vim.inspect(content)
end

---@param message HermesToolCallUpdate
---@return string
local renderToolCallUpdate = function(message)
  return vim.inspect(message.update.content)
end

---@param message HermesUserTextMessage
---@return string
local renderUserTextMessage = function(message)
  return message.update.content.text
end

---@param message HermesUserImageMessage
---@return string
local renderUserImageMessage = function(message)
  return message.update.content.uri or "no image available"
end

---@param message HermesAgentTextMessage
---@return string
local renderAgentTextMessage = function(message)
  return message.update.content.text
end

---@param message HermesAgentTextThought
---@return string
local renderAgentTextThought = function(message)
  return message.update.content.text
end

---@param message HermesAgentImageMessage
---@return string
local renderAgentImageMessage = function(message)
  return message.update.content.uri or "image unavailable"
end

---@param message HermesAgentImageThought
---@return string
local renderAgentImageThought = function(message)
  return message.update.content.uri or "image unavailable"
end

---@param message HermesAgentResourceLinkThought
---@return string
local renderAgentResourceLinkThought = function(message)
  return message.update.content.description
end

---@param message HermesAgentResourceLinkMessage
---@return string
local renderAgentResourceLinkMessage = function(message)
  return message.update.content.description
end

---@param message HermesAvailableCommands
---@return string
local renderAvailableCommands = function(message)
  return vim.inspect(message.update.availableCommands)
end

---@param message HermesModeCurrent
---@return string
local renderModeCurrent = function(message)
  return message.update.currentModeId
end

---@param message HermesConfigurationOption
---@return string
local renderConfigurationOption = function(message)
  return vim.inspect(message.update.configOptions)
end

---@param message HermesUsageUpdate
---@return string
local renderUsageUpdate = function(message)
  local update = message.update
  return "Cost: " .. update.cost .. ", Size: " .. update.size .. ", Used" .. update.used
end

---@param message HermesCompactionUpdate
---@return string
local renderCompactionUpdate = function(message)
  return vim.inspect(message.update.summary)
end

---@param message HermesCompactionSummaryChunk
---@return string
local renderCompactionSummaryChunk = function(message)
  return message.update.content.text
end

---@param message HermesSessionUpdate
---@return string
local renderSessionUpdate = function(message)
  return message.update.title
end

---@generic T
---@alias Render table<string, fun(arg: T): string>

---@type Render
local render = {
  [Event.Plan] = renderPlan,
  [Event.ToolCall] = renderToolCall,
  [Event.ToolCallUpdate] = renderToolCallUpdate,
  [Event.UserTextMessage] = renderUserTextMessage,
  [Event.UserImageMessage] = renderUserImageMessage,
  [Event.AgentTextMessage] = renderAgentTextMessage,
  [Event.AgentTextThought] = renderAgentTextThought,
  [Event.AgentImageMessage] = renderAgentImageMessage,
  [Event.AgentImageThought] = renderAgentImageThought,
  [Event.AgentResourceLinkThought] = renderAgentResourceLinkThought,
  [Event.AgentResourceLinkMessage] = renderAgentResourceLinkMessage,
  [Event.AvailableCommands] = renderAvailableCommands,
  [Event.ModeCurrent] = renderModeCurrent,
  [Event.ConfigurationOption] = renderConfigurationOption,
  [Event.UsageUpdate] = renderUsageUpdate,
  [Event.CompactionUpdate] = renderCompactionUpdate,
  [Event.CompactionSummaryChunk] = renderCompactionSummaryChunk,
  [Event.SessionUpdate] = renderSessionUpdate,
}

return render
