local M = {}

M.text = {
  ask = function(session_id)
    vim.ui.input({ prompt = "Ask: " }, function(input)
      if input ~= "" then
        require("hermes").prompt(session_id, {
          type = "text",
          value = input,
        })
      end
    end)
  end,
}

return M
