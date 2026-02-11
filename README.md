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
  - set up script runner with language adapters
    - per language
      - rust -> just
      - javascript -> package.json scripts
      - etc
    - same keymap
    - allow script execution/viewing from anywhere in the project
    - show script progress (status) for integration with lualine, etc
    - create hook for output for integration with notify, etc
    - allow viewing output from script runs
  - add nvim-ufo (maybe?)
- ai
  - look into avante.nvim
  - augment.nvim
  - opencode.nvim
  - mcphub.nvim
- visual
  - make which-key key bindings pretty
  - set up icons
