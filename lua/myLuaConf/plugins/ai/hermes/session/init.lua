local hermes = require("hermes")
local Event = hermes.Autocommand
local Logger = require("myLuaConf.plugins.ai.hermes.utilities.logging")
local logger = Logger.new("Session")
local M = {
  state = require("myLuaConf.plugins.ai.hermes.session.state")
}

vim.api.nvim_create_autocmd("User", {
  group = "hermes",
  pattern = Event.SessionsListed,
  callback = function(args)
    ---@type HermesSessionsListed
    local data = args.data
    local max_file_path_size = 0
    Snacks.picker({
      title = "Select Session",
      preview = false,
      layout = {
        preview = false,
      },
      format = function(item, ctx)
        local left = item.text or ""
        local right = item.time or ""
        local prefix_pre = (item.data.cwd or "")
        local prefix = (prefix_pre or "") .. " - "

        local total_width = (ctx and ctx.width or 100) + 16

        local prefix_width = vim.fn.strdisplaywidth(prefix)
        local left_width = vim.fn.strdisplaywidth(left)
        local right_width = vim.fn.strdisplaywidth(right)
        local left_padding = max_file_path_size - vim.fn.strdisplaywidth(prefix_pre)

        local padding = math.max(1, total_width - left_padding - prefix_width - left_width - right_width)

        return {
          { item.data.cwd, "Constant" },
          { string.rep(" ", left_padding) .. " | ", "Comment" },
          { left, "Title" },
          { string.rep(" ", padding) .. "| ", "Comment" },
          { right, "Keyword" },
        }
      end,
      finder = function()
        local items = {}
        for _, session in ipairs(data.sessions) do
          if max_file_path_size < vim.fn.strdisplaywidth(session.cwd) then
            max_file_path_size = vim.fn.strdisplaywidth(session.cwd)
          end
          table.insert(items, {
            text = vim.trim(session.title:match("^(.-)%-") or session.title),
            time = session.updatedAt,
            data = session,
          })
        end
        return items
      end,
      confirm = function(picker, item)
        local session_id = item.data.sessionId
        picker:close()
        logger:info("Loading session: " .. session_id)
        require("hermes").load_session(session_id)
        M.sessionId = session_id
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = "hermes",
  pattern = Event.SessionLoaded,
  callback = function()
    local history = require("myLuaConf.plugins.ai.hermes.prompts").history
    logger:debug(history:render())
  end,
})

M.selectSession = function()
  hermes.list_sessions()
end

return M
