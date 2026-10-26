return {
  "hermes.nvim",
  -- load = function ()
  --   -- in development, plugin is loaded from source
  -- end,
  after = function()
    local logger = require("myLuaConf.plugins.ai.hermes.utilities.logging")
    logger:trace("Starting hermes UI")
    vim.api.nvim_create_augroup("hermes", { clear = true })
    require("myLuaConf.plugins.ai.hermes.environment").detect()

    local hermes = require("hermes")
    local sessions = require("myLuaConf.plugins.ai.hermes.session")
    local registry = require("myLuaConf.plugins.ai.hermes.agents")
    local prompts = require("myLuaConf.plugins.ai.hermes.prompts")
    local State = require("myLuaConf.plugins.ai.hermes.state")
    local Event = hermes.Autocommand
    local Format = hermes.LogFormat
    local Level = hermes.LogLevel
    local state = State.new()

    Snacks.keymap.set("n", "<leader>as", sessions.selectSession, { desc = "[S]essions" })
    Snacks.keymap.set("n", "<leader>ac", registry.selectAgent, { desc = "[C]onnect" })
    Snacks.keymap.set("n", "<leader>aX", function()
      hermes.cancel(sessions.sessionId)
    end, { desc = "Cancel all session activity" })
    Snacks.keymap.set("n", "<leader>aA", function()
      prompts.text.ask(sessions.sessionId)
    end, { desc = "[A]sk" })
    -- Snacks.keymap.set("n", "<leader>ah", prompts.history, { desc = "[H]istory" })
    -- Snacks.keymap.set({ "v" }, "<leader>aA", prompts.embedded.ask, { desc = "[A]sk" })

    hermes.setup({
      download = {
        auto = false,
      },
      log = {
        notification = {
          level = Level.warn,
          format = Format.pretty
        },
        file = {
          level = Level.trace,
        },
      },
    })

    local saved = state:load()
    local auto_connect = saved and saved.agent_id and saved.agent_id ~= nil
    local auto_session_id = saved and saved.session_id

    if auto_connect then
      sessions.sessionId = auto_session_id
      registry.agentId = saved.agent_id
      hermes.connect(saved.agent_id, saved.distribution and { distribution = saved.distribution } or nil)
    end

    vim.api.nvim_create_autocmd("User", {
      group = "hermes",
      pattern = Event.ConnectionInitialized,
      callback = function(args)
        ---@type HermesConnectionInitialized
        local data = args.data
        local info = data.agentInfo
        logger:info("Connected to " .. info.name .. " " .. info.version)
        state.agent_id = state.agent_id or registry.agentId
        state:save()
        if auto_session_id then
          hermes.load_session(auto_session_id)
        elseif not auto_connect then
          hermes.list_sessions()
        end
        auto_connect = false
        auto_session_id = nil
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = "hermes",
      pattern = Event.SessionLoaded,
      callback = function()
        if state.agent_id and sessions.sessionId then
          state.session_id = sessions.sessionId
          state:save()
        end
      end,
    })
  end,
}
