local hermes = require("hermes")
local Logger = require("myLuaConf.plugins.ai.hermes.utilities.logging")
local PromptHistory = require("myLuaConf.plugins.ai.hermes.prompts.history")
local Conversation = require("myLuaConf.plugins.ai.hermes.ui.conversation")
local history = PromptHistory.new()
local Event = hermes.Autocommand
local conversation = Conversation.new()

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

local notice_logger = Logger.new(Event.Notice)

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
    notice_logger:log(update.description, severity)
  end,
})

for _, event in pairs(events) do
  vim.api.nvim_create_autocmd("User", {
    group = "hermes",
    pattern = event,
    callback = function(args)
      local data = args.data
      notice_logger:debug(data)
      history:add(data.promptId, data, event)
      conversation:render(history)
    end,
  })
end

return {
  text = require("myLuaConf.plugins.ai.hermes.prompts.text"),
  history = history,
  conversation = conversation,
}
