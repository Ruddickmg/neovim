local history = require("myLuaConf.plugins.ai.hermes.ui.history").history_selector
local Conversation = require("myLuaConf.plugins.ai.hermes.ui.conversation")

---@class Ui
---@field history fun(state: PromptHistory, group_prompts: boolean)
---@field Conversation Conversation
return {
  history = history,
  Conversation = Conversation,
}
