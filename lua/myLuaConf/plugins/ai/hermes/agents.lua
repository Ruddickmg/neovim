local M = {}

local svg_pixel = require("myLuaConf.plugins.ai.hermes.svg_pixel")

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
      input_keys[key] = { action_name, mode = { "n", "i" } }
      list_keys[key] = { action_name, mode = { "n", "i" } }
    end

    Snacks.picker({
      title = "Select Agent",
      format = function(item)
        return {
          { "󰚥 ", "Special" },
          { item.text, "Title" },
        }
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

        local icon_lines = data.icon and svg_pixel.get_icon(data.icon, { width = 22, height = 12 })
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
        vim.notify("Loading agent: " .. agent_id, vim.log.levels.INFO, { title = "Hermes" })
        require("hermes").connect(agent_id, dist and { distribution = dist } or nil)
        M.agentId = agent_id
      end,
    })
  end,
})

M.selectAgent = function()
  local hermes = require("hermes")
  vim.notify("getting agents")
  hermes.agents({
    update = false,
  })
end

return M
