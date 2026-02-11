return {
  {
    "postgres_lsp",
    for_cat = "database",
    event = { "BufReadPre", "BufNewFile" },
    lsp = {
      filetypes = { "sql" },
      cmd = { "postgres-language-server", "lsp-proxy" },
      root_markers = { "postgres-language-server.jsonc" },
    },
  },
}
