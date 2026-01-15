# Neovim configuration 

PDE setup for nixos and non-nix environments

## Non nix setup

### vcs

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

## TODO

- plugins
  - add nvim-ufo
- configuration
  - style doc popup to have a border
  - configure sql lsp for autocompletion
  - use tree sitter to get lsp suggestions etc in embedded code (sql, etc)
  - configure snacks
  - configure noice
  - fixes
    - fix flash selection color issues
    - fix snacks scrolling weirdness (maybe replace with neoscroll)
    - fix rust lsp
- ai
  - look into avante.nvim
  - augment.nvim
  - opencode.nvim
  - mcphub.nvim
- make which-key key bindings pretty
