# Neovim configuration 

My PDE setup for both nixos and non-nix environments

## Non nix setup

### LSP

typescript
```bash
npm install -g typescript-language-server typescript
```

json
```bash
npm i -g vscode-langservers-extracted
```

yaml
```
brew install yaml-language-server
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

- fix docker lsp
- set up package.json script runner
- set up lsp key bindings
- fix treesitter errors
- set up testing keybindings
- use tree sitter to get lsp suggestions etc in embedded code (sql, etc)
- configure sql lsp for autocompletion
- fix rust lsp
- configure snacks
- configure noice
