return function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    Snacks.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- vim.lsp.buf.completion(): Trigger code completion.
  -- nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("cn", vim.lsp.buf.rename, "[C]hange [N]ame")
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
  nmap("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")

  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end
