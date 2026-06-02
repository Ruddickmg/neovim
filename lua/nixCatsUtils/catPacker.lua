local M = {}

local gh = function(x) return 'https://github.com/' .. x end

local function setup_build_hooks()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if kind == 'install' or kind == 'update' then
        if name == 'nvim-treesitter' then
          vim.cmd('TSUpdate')
        elseif name == 'sniprun' then
          vim.system({ 'sh', './install.sh', '1' }, { cwd = ev.data.path })
        elseif name == 'blink.cmp' then
          vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path })
        end
      end
    end,
  })
end

-- Swap this to a custom function for finer-grained loading control:
--   M.load = function(info)
--     -- info.spec, info.path
--   end
---@type boolean|fun(info: {spec: vim.pack.Spec, path: string})|nil
M.load = function(_) end

function M.setup(v)
  if not vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] then
    setup_build_hooks()
    local start_specs, lazy_specs = {}, {}
    for _, spec in ipairs(v) do
      if type(spec) == "string" then
        table.insert(lazy_specs, { src = gh(spec) })
      else
        local clean = { src = gh(spec[1]) }
        if spec.name then clean.name = spec.name end
        if spec.version then clean.version = spec.version end
        if spec.lazy == false then
          table.insert(start_specs, clean)
        else
          table.insert(lazy_specs, clean)
        end
      end
    end
    if #start_specs > 0 then
      vim.pack.add(start_specs)
    end
    if #lazy_specs > 0 then
      vim.pack.add(lazy_specs, { load = M.load })
    end
  end
end

return M
