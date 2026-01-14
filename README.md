# Neovim configuration 

PDE setup for nixos and non-nix environments

## Non nix setup

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
  - add flash.neovim
  - add treesitter-text-subjects
  - add cursor movement styling
- configuration
  - style doc popup to have a border
  - configure sql lsp for autocompletion
  - use tree sitter to get lsp suggestions etc in embedded code (sql, etc)
  - fix rust lsp
  - configure snacks
  - configure noice
- ai
  - look into avante.nvim
  - augment.nvim
  - opencode.nvim
  - mcphub.nvim
