local Event = require("hermes").Autocommand
local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging").new("Conversation")

---@class Conversation
---@field history PromptHistory
---@field buffer number
---@field window number
---@field position number
---@field width number
---@field height number
local Conversation = {}

---@return Conversation
function Conversation.new()
  local self = {
    position = 1,
    history = nil,
    window = nil,
    width = 60,
    height = 40,
    buffer = vim.api.nvim_create_buf(false, true),
  }
  vim.bo[self.buffer].filetype = 'markdown'
  vim.bo[self.buffer].undolevels = -1
  vim.bo[self.buffer].modifiable = false
  vim.bo[self.buffer].readonly = true
  setmetatable(self, { __index = Conversation })
  return self
end

---@return Conversation
function Conversation:show()
  logger:trace("Showing conversation")
  local window = vim.api.nvim_open_win(self.buffer, true, {
    relative = 'editor',
    width = self.width,
    height = self.height,
    col = 15,
    row = 5,
    style = 'minimal',
    border = 'rounded', -- Options: 'none', 'single', 'double', 'rounded', etc.
  })

  vim.wo[window].number = false
  vim.wo[window].relativenumber = false
  vim.wo[window].foldenable = false

  self.window = window

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
  vim.bo[self.buffer].modifiable = true
  vim.api.nvim_buf_set_lines(self.buffer, -1, -1, false, lines)
  vim.bo[self.buffer].modifiable = false
  logger:trace("Rendered")
  return self
end

return Conversation
