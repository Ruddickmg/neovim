# Neovim configuration 

PDE setup for nixos and non-nix environments

## Non nix setup

### VCS

lazygit
```bash
brew install lazygit
```

### Node

provider
```bash
npm install -g neovim
```

### LSP

typescript
```bash
npm i -g typescript-language-server typescript
```

json
```bash
npm i -g vscode-langservers-extracted
```

yaml
```bash
npm i -g yaml-language-server
```

lua
```bash
brew install lua-language-server in
```

docker
```bash
brew install docker-language-server
```

### Code Snippet Runner

typescript
```bash
npm install -g ts-node typescript
```

rust
```bash
cargo install evcxr_repl
```


## TODO

- configuration
  - fixes
    - fix flash selection color issues
    - fix snacks scrolling weirdness (maybe replace with neoscroll)
    - fix luasnip, snippets not showing up in autocompletion
    - fix rust lsp
  - figure out how to substitute from system clipboard
- plugins
  - create plugin for sql (connect to postgresql lsp)
    - configure sql lsp for autocompletion
    - integrate with tree sitter to get lsp suggestions etc in embedded code (sql, etc)
    - add connection status? lualine
    - add crud operations for connections
      - add ui for creating new connections (host, port, name, password, etc)
    - integrate with snacks picker for connections
      - allow selection of lsp (if multiple sql lsps are available)
      - allow selection of connection (if multiple connections are available)
        - display connections
        - connect
        - disconnect
        - deleting selection
        - edit connection
  - add nvim-ufo (maybe?)
- ai
  - look into avante.nvim
  - augment.nvim
  - opencode.nvim
  - mcphub.nvim
- make which-key key bindings pretty
