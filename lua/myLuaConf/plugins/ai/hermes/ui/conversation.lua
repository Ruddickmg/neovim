local Event = require("hermes").Autocommand
local mouse = require("myLuaConf.plugins.ai.hermes.utilities.mouse")
local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging").new("Conversation")
local Mouse = mouse.Mouse
local WindowMousePosition = mouse.WindowMousePosition

local MIN_SIZE = 10

---@class ConversationResizeState
---@field mode "move"|"resize"
---@field side WindowMousePosition
---@field row number
---@field col number
---@field width number
---@field height number
---@field start_row number
---@field start_col number

---@class Conversation
---@field history PromptHistory
---@field buffer number
---@field window number
---@field position number
---@field width number
---@field height number
---@field mouse Mouse
---@field mouse_position WindowMousePosition
---@field resize_state ConversationResizeState|nil
local Conversation = {}

---@return Conversation
function Conversation.new()
  local self = {
    mouse_position = nil,
    resize_state = nil,
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
  vim.keymap.set("n", "<LeftRelease>", function()
    self:stop_resize()
    return "<LeftRelease>"
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

---@param side WindowMousePosition
---@return boolean
function Conversation:is_resizable_side(side)
  return side == WindowMousePosition.Bottom
    or side == WindowMousePosition.Left
    or side == WindowMousePosition.Right
    or side == WindowMousePosition.BottomLeft
    or side == WindowMousePosition.BottomRight
end

function Conversation:resize()
  if not self:window_ready() then
    return
  end

  local config = vim.api.nvim_win_get_config(self.window)
  local mouse = vim.fn.getmousepos()

  -- Snapshot the geometry on the first drag event so every subsequent event is
  -- applied as a delta from the drag origin. This keeps the math independent of
  -- borders/screen offsets and prevents the window from oscillating.
  if self.resize_state == nil then
    local mode
    if self.mouse_position == WindowMousePosition.Top then
      mode = "move"
    elseif self:is_resizable_side(self.mouse_position) then
      mode = "resize"
    else
      return
    end
    self.resize_state = {
      mode = mode,
      side = self.mouse_position,
      row = config.row,
      col = config.col,
      width = config.width,
      height = config.height,
      start_row = mouse.screenrow,
      start_col = mouse.screencol,
    }
    logger:debug("Started " .. mode .. " from: " .. self.resize_state.side)
  end

  local state = self.resize_state
  if state == nil then
    return
  end
  local side = state.side
  local delta_row = mouse.screenrow - state.start_row
  local delta_col = mouse.screencol - state.start_col

  if state.mode == "move" then
    -- Dragging the top border moves the whole window; size is unchanged.
    config.row = state.row + delta_row
    config.col = state.col + delta_col
  end

  if side == WindowMousePosition.Bottom or side == WindowMousePosition.BottomLeft or side == WindowMousePosition.BottomRight then
    -- Top edge stays fixed.
    config.height = math.max(MIN_SIZE, state.height + delta_row)
  end

  if side == WindowMousePosition.Left or side == WindowMousePosition.BottomLeft then
    -- Right edge stays fixed.
    local width = math.max(MIN_SIZE, state.width - delta_col)
    config.width = width
    config.col = state.col + (state.width - width)
  end

  if side == WindowMousePosition.Right or side == WindowMousePosition.BottomRight then
    -- Left edge stays fixed.
    config.width = math.max(MIN_SIZE, state.width + delta_col)
  end

  vim.api.nvim_win_set_config(self.window, config)
  logger:debug(
    "Dragging "
      .. state.side
      .. " ("
      .. state.mode
      .. ") to "
      .. config.col
      .. ","
      .. config.row
      .. " ("
      .. config.width
      .. "x"
      .. config.height
      .. ")"
  )
end

function Conversation:stop_resize()
  self.resize_state = nil
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
