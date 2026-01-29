return {
  {
    "postgres_ls",
    for_cat = "database",
    event = { "BufReadPre", "BufNewFile" },
    lsp = {
      filetypes = { "sql", "rs" },
      cmd = { "postgres-language-server", "lsp-proxy" },
      root_markers = { "postgres-language-server.jsonc" },
    },
    after = function()
      print("postgres-language-server")
    end,
  },
}
