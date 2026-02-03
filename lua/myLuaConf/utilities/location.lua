local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function project_root()
  local project_markers = { "package.json" }
  local current_file_path = vim.api.nvim_buf_get_name(0) -- Get the path of the current buffer's file
  return vim.fs.root(current_file_path, project_markers)
end

return {
  file_exists = file_exists,
  project_root = project_root,
}
