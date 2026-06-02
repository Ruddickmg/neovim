local M = {}

local gh = function(x) return 'https://github.com/' .. x end

---@type table<string, fun(ev: {data: {path: string}})|string>
local build_hooks = {}

local function setup_build_hooks()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if (kind == 'install' or kind == 'update') and build_hooks[name] then
        local hook = build_hooks[name]
        if type(hook) == 'string' then
          vim.cmd(hook)
        else
          hook(ev)
        end
      end
    end,
  })
end

local function derive_name(repo)
  return repo:match("/([^/]+)$")
end

-- Swap this to a custom function for finer-grained loading control:
--   M.load = function(info)
--     -- info.spec, info.path
--   end
---@type boolean|fun(info: {spec: vim.pack.Spec, path: string})|nil
M.load = function(_) end

function M.setup(v)
  if not vim.g[['nixCats-special-rtp-entry-nixCats']] then
    setup_build_hooks()
    local start_specs, lazy_specs = {}, {}
    for _, spec in ipairs(v) do
      if type(spec) == "string" then
        table.insert(lazy_specs, { src = gh(spec) })
      else
        local name = spec.name or derive_name(spec[1])
        local clean = { src = gh(spec[1]), name = name }
        if spec.version then clean.version = spec.version end
        if spec.lazy == false then
          table.insert(start_specs, clean)
        else
          table.insert(lazy_specs, clean)
        end
        if spec.build then
          build_hooks[name] = spec.build
        end
      end
    end
    if #start_specs > 0 then
      vim.pack.add(start_specs, { confirm = false })
    end
    if #lazy_specs > 0 then
      vim.pack.add(lazy_specs, { load = M.load, confirm = false })
    end
  end
end

return M
