local Event = require("hermes").Autocommand
local mouse = require("myLuaConf.plugins.ai.hermes.utilities.mouse")
local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging").new("Conversation")
local Mouse = mouse.Mouse
local WindowMousePosition = mouse.WindowMousePosition

---@class Conversation
---@field history PromptHistory
---@field buffer number
---@field window number
---@field position number
---@field width number
---@field height number
---@field mouse Mouse
---@field mouse_position WindowMousePosition
local Conversation = {}

---@return Conversation
function Conversation.new()
  local self = {
    mouse_position = nil,
    position = 1,
    history = nil,
    window = nil,
    mouse = Mouse.new(),
    width = 60,
    height = 40,
    buffer = vim.api.nvim_create_buf(false, true),
  }
  vim.bo[self.buffer].filetype = "markdown"
  vim.bo[self.buffer].undolevels = -1
  vim.bo[self.buffer].modifiable = false
  vim.bo[self.buffer].readonly = true
  setmetatable(self, { __index = Conversation })
  vim.keymap.set("n", "<MouseMove>", function()
    self:detect_mouse_position()
    return "<MouseMove>"
  end, { silent = true })
  vim.keymap.set("n", "<LeftDrag>", function()
    self:resize()
    return "<LeftDrag>"
  end, { silent = true })
  return self
end

function Conversation:detect_mouse_position()
  if self:window_ready() then
    local position = self.mouse:window_position(self.window)
    if self.mouse_position ~= position then
      self.mouse_position = position
      logger:debug("Changed position to: " .. position)
    end
  end
end

function Conversation:resize()
  local config = vim.api.nvim_win_get_config(self.window)
  local mouse = vim.fn.getmousepos()
  if self.mouse_position == WindowMousePosition.Bottom then
    -- resize bottom
    config.row = -- calculate with `mouse`
  elseif self.mouse_position == WindowMousePosition.Top then
    -- resize top 
  elseif self.mouse_position == WindowMousePosition.Left then
    -- resuze left side
  elseif self.mouse_position == WindowMousePosition.Right then
    -- resize right side  
  end

  logger:info("Mouse dragging coordinates: " .. mouse.screenrow .. ", " .. mouse.screencol)
end

---@return boolean
function Conversation:window_ready()
  return type(self.window) == "number" and vim.api.nvim_win_is_valid(self.window)
end

---@return boolean
function Conversation:buffer_ready()
  return type(self.buffer) == "number" and vim.api.nvim_buf_is_valid(self.buffer)
end

function Conversation:move_view_to_bottom()
  if self:window_ready() then
    vim.cmd("normal! Gzb")
  end
end

---@return Conversation
function Conversation:show()
  logger:trace("Showing conversation")
  local window = vim.api.nvim_open_win(self.buffer, true, {
    relative = "editor",
    width = self.width,
    height = self.height,
    col = 15,
    row = 5,
    style = "minimal",
    border = "rounded", -- Options: 'none', 'single', 'double', 'rounded', etc.
  })

  vim.wo[window].number = false
  vim.wo[window].relativenumber = false
  vim.wo[window].foldenable = false

  self.window = window
  self:move_view_to_bottom()

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

---@param lines string[]
function Conversation:add_lines(lines)
  if not self:buffer_ready() then
    return
  else
    local total_lines = vim.api.nvim_buf_line_count(self.buffer)

    vim.bo[self.buffer].modifiable = true
    vim.api.nvim_buf_set_lines(self.buffer, -1, -1, false, lines)
    vim.bo[self.buffer].modifiable = false

    if self:window_ready() then
      local last_visible_line = vim.fn.line("w$")
      local is_at_bottom = (last_visible_line >= total_lines)
      if is_at_bottom then
        logger:debug("Move to bottom")
        self:move_view_to_bottom()
      end
    end

    logger:trace("Rendered")
  end
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
  self:add_lines(lines)
  logger:trace("Rendered")
  return self
end

function Conversation:move_with_mouse()
  if self.mouse == nil then
    return
  end
end

return Conversation
