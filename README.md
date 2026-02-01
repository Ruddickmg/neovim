# Neovim configuration 

PDE setup for nixos and non-nix environments

## Non nix setup

### VCS

lazygit
```bash
brew install lazygit
```

### Dependencies

#### Node

provider
```bash
npm install -g neovim
```

#### Code Snippet Runner

typescript
```bash
npm install -g ts-node typescript
```

rust
```bash
cargo install evcxr_repl
```

#### LSP

rust
```bash
# add rust analyzer lsp
rustup component add rust-analyzer

# add lspmux rust analyzer multiplexer
cargo install lspmux

# run lspmux server
lspmux server
```

## TODO

- configuration
  - fixes
    - fix luasnip, snippets not showing up in autocompletion
    - fix rust lsp
    - fix snacks scrolling weirdness (maybe replace with neoscroll)
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
- visual
  - make which-key key bindings pretty
  - set up icons
