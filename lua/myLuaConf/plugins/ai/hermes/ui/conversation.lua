local Event = require("hermes").Autocommand
local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging").new("Conversation")

---@class Conversation
---@field history PromptHistory
---@field buffer number
---@field window number
---@field position number
local Conversation = {}

---@return Conversation
function Conversation.new()
  local self = {
    position = 1,
    history = nil,
    window = nil,
    buffer = vim.api.nvim_create_buf(false, true),
  }
  vim.bo[self.buffer].filetype = 'markdown'
  setmetatable(self, { __index = Conversation })
  return self
end

---@return Conversation
function Conversation:show()
  logger:trace("Showing conversation")
  self.window = vim.api.nvim_open_win(self.buffer, true, {
    relative = 'editor',
    width = 50,
    height = 50,
    col = 15,
    row = 5,
    style = 'minimal',
    border = 'single', -- Options: 'none', 'single', 'double', 'rounded', etc.
  })
  return self
end

---@return Conversation
function Conversation:hide()
  local window = self.window
  if window and vim.api.nvim_win_is_valid(window) then
    vim.api.nvim_win_close(window, false)
    self.window = nil
  end
  return self
end

---@param history PromptHistory
---@return Conversation
function Conversation:render(history)
  logger:trace("Rendering")
  local messages = history:text_messages()
  local length = #messages
  local new_messages = table.move(messages, self.position, length, 1, {})
  local lines = {}

  logger:debug(new_messages)

  for _, prompt in ipairs(new_messages) do
    if prompt.type == Event.UserTextMessage then
      table.insert(lines, "")
      for _, line in ipairs(vim.split(prompt:render(), "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    elseif prompt.type == Event.AgentTextMessage then
      table.insert(lines, "")
      for _, line in ipairs(vim.split(prompt:render(), "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    elseif prompt.type == Event.AgentTextThought then
      table.insert(lines, "")
      for _, line in ipairs(vim.split(prompt:render(), "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    end
  end

  logger:debug(lines)

  self.position = length + 1
  vim.api.nvim_buf_set_lines(self.buffer, -1, -1, false, lines)
  logger:trace("Rendered")
  return self
end

return Conversation
