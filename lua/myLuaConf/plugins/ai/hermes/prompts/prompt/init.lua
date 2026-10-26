local render = require("myLuaConf.plugins.ai.hermes.prompts.prompt.render")

---@generic T
---@class Prompt
---@field data T
---@field timestamp number
---@field type string
local Prompt = {}

---@return Prompt
---@param type HermesAutocommand
function Prompt.new(type, data)
  ---@type Prompt
  local self = {
    data = data,
    type = type,
    timestamp = os.time(),
  }
  setmetatable(self, { __index = Prompt })
  return self
end

---@return string
function Prompt:render()
  return render[self.type](self.data)
end

---@class Prompts
---@field data table<string, Prompt[]>
---@field ordering string[]
local Prompts = {}

---@return Prompts
function Prompts.new()
  local self = {
    ordering = {},
    data = {},
  }
  setmetatable(self, { __index = Prompts })
  return self
end

---@param id string
---@return Prompt
function Prompts:get(id)
  return self.data[id]
end

---@param id string
---@param prompt Prompt
function Prompts:add(id, prompt)
  if self.data[id] == nil then
    table.insert(self.ordering, id)
    self.data[id] = {}
  end
  table.insert(self.data[id], prompt)
end

---@param callback fun(arg: Prompt[])
function Prompts:iter(callback)
  for _, key in ipairs(self.ordering) do
    callback(self.data[key])
  end
end

---@param callback fun(arg: Prompt): boolean
---@return Prompt[][]
function Prompts:filter(callback)
  local filtered_prompts = {}
  self:iter(function(prompts)
    local prompt_turn = {}
    for _, prompt in ipairs(prompts) do
      if callback(prompt) then
        table.insert(prompt_turn, prompt)
      end
    end
    table.insert(filtered_prompts, prompt_turn)
  end)
  return filtered_prompts
end

---@param types string[]
---@return Prompt[][]
function Prompts:by_type(types)
  local mapping = {}
  for _, value in ipairs(types) do
    mapping[value] = true
  end
  return self:filter(function(prompt)
    return mapping[prompt.type] ~= nil
  end)
end

---@param types HermesAutocommand[]
---@param callback fun(arg: Prompt[])
function Prompts:iter_by_type(types, callback)
  for _, prompts in ipairs(self:by_type(types)) do
    callback(prompts)
  end
end

return {
  Prompt = Prompt,
  Prompts = Prompts,
}
