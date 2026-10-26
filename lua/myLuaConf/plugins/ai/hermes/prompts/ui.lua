require("myLuaConf.plugins.ai.hermes.prompts.history")
local Event = require("hermes").Autocommand
local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging").new("Prompt History")

---@param prompts Prompt[]
local function format_history(prompts)
  local lines = {}
  for _, prompt in ipairs(prompts) do
    if prompt.type == Event.UserTextMessage then
      table.insert(lines, "")
      for _, line in ipairs(vim.split(prompt:render(), "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    elseif prompt.type == Event.AgentTextMessage then
      table.insert(lines, "")
      for _, line in ipairs(vim.split(prompt:render(), "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    elseif prompt.type == Event.AgentTextThought then
      table.insert(lines, "")
      for _, line in ipairs(vim.split(prompt:render(), "\n", { plain = true })) do
        table.insert(lines, "  " .. line)
      end
      table.insert(lines, "")
    end
  end
  return lines
end

---@param state PromptHistory
local history = function(state)
  ---@class PromptItem
  ---@field text HermesAutocommand
  ---@field time number
  ---@field data Prompt[]

  ---@type PromptItem[]
  local items = {}

  for _, prompts in ipairs(state:text_message_prompts()) do
    if #prompts > 0 then
      local first_prompt = prompts[1]
      logger:debug(first_prompt)
      table.insert(items, {
        text = first_prompt:render(),
        time = first_prompt.date_time,
        type = first_prompt.type,
        data = prompts,
      })
    end
  end

  if #items == 0 then
    logger:info("No prompt history")
    return
  end

  logger:debug("Opening promt history")

  Snacks.picker({
    title = "Prompt History",
    finder = function()
      return items
    end,
    format = function(item)
      return {
        { item.time, "Keyword" },
        { " | ", "Comment" },
        { item.type, "Constant" },
        { " | ", "Comment" },
        { item.text, "Title" },
      }
    end,
    preview = function(ctx)
      -- Write lines, set filetype, and use vim.schedule to handle window options and trigger BufWinEnter
      vim.bo[ctx.buf].modifiable = true
      vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, format_history(ctx.item.data))
      vim.bo[ctx.buf].modifiable = false
      vim.bo[ctx.buf].filetype = "markdown"

      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(ctx.buf) then
          return
        end
        vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = ctx.buf })

        if ctx.win and vim.api.nvim_win_is_valid(ctx.win) then
          vim.wo[ctx.win].number = false
          vim.wo[ctx.win].relativenumber = false
          vim.wo[ctx.win].signcolumn = "no"
          vim.wo[ctx.win].foldcolumn = "0"
        end
      end)

      return true
    end,
    confirm = function(picker, item)
      picker:close()
      local prompts = item.data
      local buf = vim.api.nvim_create_buf(false, true)
      local lines = format_history(prompts)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].filetype = "markdown"
      vim.bo[buf].modifiable = false
      vim.cmd("tabnew")
      vim.api.nvim_set_current_buf(buf)
      vim.bo[buf].modified = false
    end,
  })
end

return {
  history_selector = history,
}
