local function strip_non_serializable_data(obj)
  local obj_type = type(obj)
  if obj_type ~= "table" then return obj end
  local result = {}
  for k, v in pairs(obj) do
    if type(v) ~= "function" then
      result[k] = strip_non_serializable_data(v)
    end
  end
  return result
end

return {
  strip_non_serializable_data = strip_non_serializable_data
}

