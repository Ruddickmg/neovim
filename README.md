## Directory Structure
 
This configuration primarily uses the following directory structure:

- The `lua/` directory for core configurations.
- The `after/plugin/` directory to demonstrate compatibility.

While this structure works well, you are encouraged to further modularize your setup by utilizing any of the runtime directories checked by Neovim:

- `ftplugin/` for file-type-specific configurations.
- `plugin/` for global plugin configurations.
- Even `pack/*/{start,opt}/` work if you want to make a plugin inside your configuration.
- And so on...

If you are unfamiliar with the above, refer to the [Neovim runtime path documentation](https://neovim.io/doc/user/options.html#'rtp').

## Non nix

### LSP setup

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

- add javascript/typescript lsp, linting, etc
- add docker lsp, linting, etc
- add lsp for everything else, justfiles, pulumi, helm, json, etc..
- configure snacks
- configure noice
- set up key bindings
- set up tmux
- use tree sitter to get lsp suggestions etc in embedded code (sql, etc)
- configure sql lsp for autocompletion
