local M = {}

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
M.load = false

function M.setup(v)
  if not vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] then
    setup_build_hooks()
    vim.pack.add(v, { load = M.load })
  end
end

return M
