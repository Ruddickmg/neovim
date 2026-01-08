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


## TODO

- add lsp for justfiles, pulumi, helm, etc..
- configure snacks
- configure noice
- set up key bindings
- set up tmux
- use tree sitter to get lsp suggestions etc in embedded code (sql, etc)
- configure sql lsp for autocompletion
