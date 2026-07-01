local M = {}

local prompt_groups = {}

vim.api.nvim_create_autocmd("User", {
  group = "hermes",
  pattern = {
    "UserTextMessage",
    "AgentTextMessage",
    "AgentTextThought",
  },
  callback = function(args)
    local data = args.data
    if not data or not data.sessionId or not data.promptId then
      vim.notify("no sessionId")
      return
    end
    if not data.update or not data.update.content or not data.update.content.text then
      vim.notify("no text")
      return
    end

    local prompt_id = data.promptId
    local chunk_text = data.update.content.text
    if chunk_text == "" then
      vim.notify("chunk_text is empty")
      return
    end

    local role
    if args.match == "UserTextMessage" then
      role = "user"
    elseif args.match == "AgentTextMessage" then
      role = "agent"
    elseif args.match == "AgentTextThought" then
      role = "thought"
    else
      vim.notify("invalid role")
      return
    end

    if not prompt_groups[prompt_id] then
      prompt_groups[prompt_id] = {
        id = prompt_id,
        identifier = "",
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        messages = {},
      }
    end

    local group = prompt_groups[prompt_id]
    local last = group.messages[#group.messages]
    if last and last.role == role then
      last.text = last.text .. chunk_text
    else
      table.insert(group.messages, { role = role, text = chunk_text })
    end

    if group.identifier == "" and role == "user" then
      local trimmed = vim.trim(chunk_text)
      group.identifier = trimmed:sub(1, 60)
      if #trimmed > 60 then
        group.identifier = group.identifier .. "..."
      end
    end
  end,
})

local function format_preview(group)
  local lines = {}
  for _, msg in ipairs(group.messages) do
    if msg.role == "user" then
      table.insert(lines, "User:")
      for _, line in ipairs(vim.split(msg.text, "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    elseif msg.role == "agent" then
      table.insert(lines, "Agent:")
      for _, line in ipairs(vim.split(msg.text, "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    elseif msg.role == "thought" then
      table.insert(lines, "Thought:")
      for _, line in ipairs(vim.split(msg.text, "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    end
  end
  return lines
end

local function format_buffer(group)
  local lines = {}
  for _, msg in ipairs(group.messages) do
    if msg.role == "user" then
      table.insert(lines, "# User")
      table.insert(lines, "")
      for _, line in ipairs(vim.split(msg.text, "\n", { plain = true })) do
        table.insert(lines, line)
      end
      table.insert(lines, "")
    elseif msg.role == "agent" then
      table.insert(lines, "# Agent")
      table.insert(lines, "")
      for _, line in ipairs(vim.split(msg.text, "\n", { plain = true })) do
        table.insert(lines, line)
      end
      table.insert(lines, "")
    elseif msg.role == "thought" then
      table.insert(lines, "# Thought")
      table.insert(lines, "")
      for _, line in ipairs(vim.split(msg.text, "\n", { plain = true })) do
        table.insert(lines, line)
      end
      table.insert(lines, "")
    end
  end
  return lines
end

M.history = function()
  local items = {}

  for _, group in pairs(prompt_groups) do
    local display_text = group.identifier ~= "" and group.identifier or "(no message)"
    table.insert(items, {
      text = display_text,
      time = group.timestamp,
      data = group,
    })
  end

  table.sort(items, function(a, b)
    return a.data.timestamp > b.data.timestamp
  end)

  if #items == 0 then
    vim.notify("No prompt history", vim.log.levels.INFO, { title = "Hermes" })
    return
  end

  vim.notify("Opening promt history")

  Snacks.picker({
    title = "Prompt History",
    finder = function()
      return items
    end,
    format = function(item)
      return {
        { item.text, "Title" },
        { " | ", "Comment" },
        { item.time, "Keyword" },
      }
    end,
    preview = function(ctx)
      local group = ctx.item.data
      local lines = format_preview(group)
      vim.bo[ctx.buf].modifiable = true
      vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, lines)
      vim.bo[ctx.buf].modifiable = false
      vim.bo[ctx.buf].filetype = "markdown"
      pcall(function()
        vim.wo[ctx.win].number = false
        vim.wo[ctx.win].relativenumber = false
      end)
      return true
    end,
    confirm = function(picker, item)
      picker:close()
      local group = item.data
      local buf = vim.api.nvim_create_buf(false, true)
      local lines = format_buffer(group)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].filetype = "markdown"
      vim.bo[buf].modifiable = false
      vim.cmd("tabnew")
      vim.api.nvim_set_current_buf(buf)
      vim.bo[buf].modified = false
    end,
  })
end

return M
