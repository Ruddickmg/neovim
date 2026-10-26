---@class Logger
---@field context string
local Logger = {}

---@param context string
---@return Logger
function Logger.new(context)
  local self = {
    context = context,
  }
  setmetatable(self, { __index = Logger })
  return self
end

---@param context string
---@return string
local function generate_title(context)
  return "Hermes" .. (context ~= nil and (" - " .. context) or "")
end

---@generic T
---@param message T 
---@param level vim.log.levels
function Logger:log(message, level)
  vim.notify(
    type(message) == "string" and message or vim.inspect(message),
    level,
    { title = generate_title(self.context) }
  )
end

---@generic T
---@param message T 
function Logger:debug(message)
  self:log(message, vim.log.levels.DEBUG)
end

---@generic T
---@param message T 
function Logger:warn(message)
  self:log(message, vim.log.levels.WARN)
end

---@generic T
---@param message T 
function Logger:error(message)
  self:log(message, vim.log.levels.ERROR)
end

---@generic T
---@param message T 
function Logger:trace(message)
  self:log(message, vim.log.levels.TRACE)
end

---@generic T
---@param message T 
function Logger:info(message)
  self:log(message, vim.log.levels.INFO)
end

return Logger
