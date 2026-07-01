local M = {}

local function pixel_data_to_icon(data)
  if not data or not data.pixels or not data.width or not data.height then
    return nil
  end
  local w, h = data.width, data.height
  local pixels = data.pixels
  local chars = { " ", "▓", "█" }
  local lines = {}
  for y = 0, h - 1 do
    local line = {}
    for x = 0, w - 1 do
      local v = pixels[y * w + x + 1] or 0
      local idx = math.floor(v / 255 * 2) + 1
      line[x + 1] = chars[idx]
    end
    lines[y + 1] = table.concat(line)
  end
  return lines
end

vim.api.nvim_set_hl(0, "HermesPixelArt", { fg = "#ffffff" })

vim.api.nvim_create_autocmd("User", {
  group = "hermes",
  pattern = "AgentList",
  callback = function(args)
    local dist_keys = {}
    for _, agent in ipairs(args.data.agents) do
      for _, dist in ipairs(agent.distributions or {}) do
        local key = dist:sub(1, 1):lower()
        if key:match("^[a-z]$") then
          dist_keys[key] = true
        end
      end
    end

    local actions = {}
    local input_keys = {}
    local list_keys = {}

    for key, _ in pairs(dist_keys) do
      local action_name = "select_dist_" .. key
      actions[action_name] = function(picker)
        local item = picker:current()
        if item then
          for _, dist in ipairs(item.data.distributions or {}) do
            if dist:sub(1, 1):lower() == key then
              item.data.selected_distribution = item.data.selected_distribution == dist and nil or dist
              picker:show_preview()
              return
            end
          end
        end
      end
      input_keys[key] = { action_name, mode = { "n" } }
      list_keys[key] = { action_name, mode = { "n", "i" } }
    end

    Snacks.picker({
      focus = "input",
      enter = true,
      title = "Select Agent",
      format = function(item)
        return {
          { "󰚥 ", "Special" },
          { item.text, "Title" },
        }
      end,
      on_show = function(_picker)
        vim.schedule(function()
          vim.cmd("startinsert")
        end)
      end,
      actions = actions,
      win = {
        input = { keys = input_keys },
        list = { keys = list_keys },
      },
      finder = function()
        local items = {}
        for _, agent in ipairs(args.data.agents) do
          table.insert(items, {
            text = agent.name,
            icon = agent.icon,
            data = agent,
          })
        end
        return items
      end,
      preview = function(ctx)
        local item = ctx.item
        local data = item.data
        local buf = ctx.buf

        local function pad(n)
          return string.rep(" ", n)
        end

        local lines = {}
        table.insert(lines, "")
        table.insert(lines, pad(4) .. data.name)
        table.insert(lines, pad(4) .. string.rep("─", #data.name + 2))
        table.insert(lines, "")

        local icon_lines
        if data.icon_pixel_data then
          icon_lines = pixel_data_to_icon(data.icon_pixel_data)
        end
        local icon_start_buf
        if icon_lines then
          icon_start_buf = #lines
          for _, l in ipairs(icon_lines) do
            table.insert(lines, pad(4) .. l)
          end
          table.insert(lines, "")
        end

        if data.description then
          table.insert(lines, pad(2) .. data.description)
          table.insert(lines, "")
        end
        table.insert(lines, pad(2) .. "License: " .. (data.license or "N/A"))
        table.insert(lines, pad(2) .. "Version: " .. (data.version or "N/A"))
        if data.website then
          table.insert(lines, pad(2) .. "Website: " .. data.website)
        end
        table.insert(lines, "")
        table.insert(lines, pad(2) .. string.rep("─", 36))
        table.insert(lines, "")
        if data.distributions and #data.distributions > 1 then
          local parts = {}
          for _, d in ipairs(data.distributions) do
            local key = d:sub(1, 1):upper()
            if d == data.selected_distribution then
              table.insert(parts, "●[" .. key .. "]" .. d:sub(2))
            else
              table.insert(parts, " [" .. key .. "]" .. d:sub(2))
            end
          end
          table.insert(lines, pad(2) .. "Distribution: " .. table.concat(parts, "  "))
        elseif data.distributions and #data.distributions == 1 then
          table.insert(lines, pad(2) .. "Distribution: " .. data.distributions[1])
        end

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
        pcall(function()
          vim.wo[ctx.win].number = false
          vim.wo[ctx.win].relativenumber = false
        end)

        if icon_start_buf and icon_lines then
          local ns = vim.api.nvim_create_namespace("HermesPixelArt")
          vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
          for i = 0, #icon_lines - 1 do
            vim.api.nvim_buf_add_highlight(buf, ns, "HermesPixelArt", icon_start_buf + i, 4, -1)
          end
        end

        return true
      end,
      confirm = function(picker, item)
        local agent_id = item.data.id
        local dist = item.data.selected_distribution
        picker:close()
        require("hermes").connect(agent_id, dist and { distribution = dist } or nil)
        M.agentId = agent_id
        M.distribution = dist
      end,
    })
  end,
})

M.selectAgent = function()
  local hermes = require("hermes")
  hermes.agents({
    update = false,
  })
end

return M
