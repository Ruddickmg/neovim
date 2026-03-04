return {
  actions = {
    open_in_browser = function(picker)
      local current = picker:current()
      local selected = picker:selected()
      if not selected and not current then
        vim.notify("No selection found", vim.log.levels.WARN, {
          title = "Snacks Action",
          timeout = 2000,
        })
        return
      end

      if is_empty(selected) then
        table.insert(selected, current)
      end

      for _, file in ipairs(selected) do
        local path = file.file or file.path
        if path then
          local sys = vim.loop.os_uname().sysname
          local cmd

          if sys == "Darwin" then
            cmd = { "open", path }
          elseif sys == "Linux" then
            cmd = { "xdg-open", path }
          elseif sys:match("Windows") then
            cmd = { "cmd.exe", "/c", "start", "", path }
          end

          if cmd then
            vim.fn.jobstart(cmd, { detach = true })
          end
        else
          vim.notify("No file fund at path: " .. path, vim.log.levels.WARN)
        end
      end
    end,
  },
  win = {
    list = {
      keys = {
        ["<c-o>"] = { "open_in_browser", mode = { "n", "i" }, desc = "Open file in browser" },
      },
    },

    input = {
      keys = {
        ["<c-o>"] = { "open_in_browser", mode = { "n", "i" }, desc = "Open file in browser" },
      },
    },
  },
  files = {
    hidden = true,
    ignored = true,
  },
  sources = {
    files = {
      hidden = true, -- Shows dotfiles
    },
    gh_issue = {},
    gh_pr = {},
  },
}
