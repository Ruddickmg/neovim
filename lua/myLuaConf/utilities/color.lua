local toHex = function(num)
  return num ~= nil and string.format("#%06x", num) or "none"
end

return {
  get_hl_colors = function(group_name)
    local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group_name, true)
    if not ok or not hl then
      vim.notify("Couldn't find highlight colors for highlight group " .. group_name)
      return {
        background = "none",
        foreground = "none",
      }
    end
    return {
      background = toHex(hl.background),
      foreground = toHex(hl.foreground),
    }
  end,
}
