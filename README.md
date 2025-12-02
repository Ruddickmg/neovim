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

## TODO

- configure rust lsp to be faster
- add javascript/typescript lsp, linting, etc
- add docker lsp, linting, etc
- figure out why the leader key isn't working
- set up key bindings
- set up tmux
- use tree sitter to get lsp suggestions etc in embedded code (sql, etc)
