local hermes = require("hermes")
local Logger = require("myLuaConf.plugins.ai.hermes.utilities.logging")
local promp = require("myLuaConf.plugins.ai.hermes.prompts.prompt")
local Prompts = promp.Prompts
local Prompt = promp.Prompt
local Event = hermes.Autocommand

---@class PromptHistory
---@field prompts Prompts
local PromptHistory = {}

---@return PromptHistory
function PromptHistory.new()
  ---@type PromptHistory
  local self = {
    prompts = Prompts.new(),
  }
  setmetatable(self, { __index = PromptHistory })
  return self
end

---@generic T
---@param prompt_id string
---@param data T
---@param type string
function PromptHistory:add(prompt_id, data, type)
  self.prompts:add(prompt_id, Prompt.new(type, data))
end

---@param callback fun(arg: Prompts)
function PromptHistory:iter_prompts(callback)
  self.prompts:iter(callback)
end

---@param callback fun(arg: Prompt)
function PromptHistory:iter(callback)
  self:iter_prompts(function (prompts)
    for _, prompt in ipairs(prompts) do
      callback(prompt)
    end
  end)
end

---@param callback fun(arg: Prompt)
---@param types string[]
function PromptHistory:iter_by_type(types, callback)
  self.prompts:iter_by_type(types, function (prompts)
    for _, prompt in ipairs(prompts) do
      callback(prompt)
    end
  end)
end

---@return string
function PromptHistory:render()
  local text = ""
  for _, prompt in ipairs(self:text_messages()) do
    text = text .. prompt:render() .. "\n"
  end
  return text
end

---@return Prompt[][]
function PromptHistory:tool_call_prompts()
  return self.prompts:by_type({ Event.ToolCall, Event.ToolCallUpdate })
end

---@return Prompt[]
function PromptHistory:tool_calls()
  local tool_calls = {}
  self:iter_by_type({ Event.ToolCall, Event.ToolCallUpdate }, function (prompt)
    table.insert(tool_calls, prompt)
  end)
  return tool_calls
end

---@return Prompt[][]
function PromptHistory:text_messages_prompts()
  local text_messages_prompts = {}
  self.prompts:iter_by_type({ Event.AgentTextMessage, Event.AgentTextThought, Event.UserTextMessage }, function(prompts)
    table.insert(text_messages_prompts, prompts)
  end)
  return text_messages_prompts
end

---@return Prompt[]
function PromptHistory:text_messages()
  local text_messages = {}
  self:iter_by_type({ Event.AgentTextMessage, Event.AgentTextThought, Event.UserTextMessage }, function(prompt)
      table.insert(text_messages, prompt)
  end)
  return text_messages
end

local history = PromptHistory.new()

local events = {
  Event.Plan,
  Event.ToolCall,
  Event.ToolCallUpdate,
  Event.UserTextMessage,
  Event.AgentTextMessage,
  Event.AgentTextThought,
  Event.UserImageMessage,
  Event.AgentImageMessage,
  Event.AgentImageThought,
  Event.AgentResourceLinkThought,
  Event.AgentResourceLinkMessage,
  Event.UserResourceLinkMessage,
  Event.UserResourceMessage,
  Event.AvailableCommands,
  Event.ModeCurrent,
  Event.ConfigurationOption,
  Event.UsageUpdate,
  Event.CompactionUpdate,
  Event.CompactionSummaryChunk,
  Event.SessionUpdate,
}

local notice = Logger.new(Event.Notice)

vim.api.nvim_create_autocmd("User", {
  group = "hermes",
  pattern = Event.Notice,
  callback = function(args)
    ---@type HermesNotice
    local data = args.data
    local update = data.update
    local severity = vim.log.levels.INFO
    if update.severity == "error" then
      severity = vim.log.levels.ERROR
    elseif update.severity == "warning" then
      severity = vim.log.levels.WARN
    end
    notice:log(update.description, severity)
  end,
})

for _, event in pairs(events) do
  vim.api.nvim_create_autocmd("User", {
    group = "hermes",
    pattern = event,
    callback = function(args)
      local data = args.data
      history:add(data.promptId, data, event)
    end,
  })
end

return history
