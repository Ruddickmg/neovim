return function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    Snacks.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- TODO: uncomment this when on neovim version 12+
  -- vim.lsp.inline_completion.enable()

  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end
