vim.o.mousemoveevent = true

---@enum WindowMousePosition
local WindowMousePosition = {
  Left = "left",
  Right = "right",
  Bottom = "bottom",
  Top = "top",
  BottomLeft = "bottom-left",
  BottomRight = "bottom-right",
  TopLeft = "top-left",
  TopRight = "top-right",
  Inside = "inside",
  Outside = "outside"
}

---@class Mouse
---@field buffer number
local Mouse = {}

---@return Mouse
function Mouse.new()
  local self = {
    buffer = 1,
  }
  setmetatable(self, { __index = Mouse })
  return self
end

---@param window number
---@return WindowMousePosition
function Mouse:window_position(window)
  local mouse = vim.fn.getmousepos()
  if type(window) == "number" and vim.api.nvim_win_is_valid(window) and mouse.winid == window then
    local cfg = vim.api.nvim_win_get_config(window)
    local w_height = cfg.height
    local w_width = cfg.width
    local r = mouse.winrow
    local c = mouse.wincol
    local buffer = self.buffer

    local is_on_bottom_edge = (r >= w_height - buffer)
    local is_on_right_edge = (c >= w_width - buffer - 1)
    local is_on_left_edge = c <= buffer
    local is_on_top_edge = r <= buffer

    if is_on_bottom_edge then
      if is_on_left_edge then
        return WindowMousePosition.BottomLeft
      elseif is_on_right_edge then
        return WindowMousePosition.BottomRight
      else
        return WindowMousePosition.Bottom
      end
    elseif is_on_top_edge then
      if is_on_left_edge then
        return WindowMousePosition.TopLeft
      elseif is_on_right_edge then
        return WindowMousePosition.TopRight
      else
        return WindowMousePosition.Top
      end
    elseif is_on_left_edge then
      return WindowMousePosition.Left
    elseif is_on_right_edge then
      return WindowMousePosition.Right
    end
    return WindowMousePosition.Inside
  end
  return WindowMousePosition.Outside
end

return {
  Mouse = Mouse,
  WindowMousePosition = WindowMousePosition,
}
