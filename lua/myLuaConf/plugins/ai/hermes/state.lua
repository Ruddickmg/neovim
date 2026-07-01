local M = {}
local state_file = vim.fn.stdpath("state") .. "/hermes.json"

M.current = {}

function M.save()
  vim.fn.writefile({ vim.json.encode(M.current) }, state_file)
end

function M.load()
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(state_file)))
  end)
  if ok and type(data) == "table" then
    M.current = data
    return data
  end
end

return M
