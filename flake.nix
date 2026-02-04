{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    plugins-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit (inputs.nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = {
        allowUnfree = true;
      };
      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];
      categoryDefinitions =
        { pkgs, ... }:
        {
          lspsAndRuntimeDeps = {
            rust = with pkgs; [
              vscode-extensions.vadimcn.vscode-lldb.adapter
            ];
            javascript = with pkgs.vimPlugins; [
              typescript-tools-nvim
            ];
            configuration-files = with pkgs; [
              yaml-language-server
              vscode-json-languageserver
            ];
            rust-analyzer = with pkgs; [
              rust-analyzer
            ];
            database = with pkgs; [
              postgres-language-server
            ];
            format = with pkgs; [
              stylua
              nixfmt
              rustfmt
            ];
            git = with pkgs; [
              lazygit
            ];
            general = with pkgs; [
              tree-sitter
              tombi
              universal-ctags
              ripgrep
              clang
              fd
            ];
            neonixdev = {
              inherit (pkgs) nix-doc lua-language-server nixd;
            };
          };

          startupPlugins = {
            rust = with pkgs.vimPlugins; [
              rustaceanvim
            ];
            debug = with pkgs.vimPlugins; [
              nvim-nio
            ];
            styling = with pkgs.vimPlugins; [
              nvim-web-devicons
            ];
            general = with pkgs.vimPlugins; {
              always = [
                lze
                lzextras
                plenary-nvim
                (nvim-notify.overrideAttrs { doCheck = false; }) # TODO: remove overrideAttrs after check is fixed
              ];
              utility = [
                project-nvim
                SchemaStore-nvim
                snacks-nvim
                direnv-vim
                noice-nvim
                vim-repeat
              ];
            };
          };

          optionalPlugins = {
            diagnostics = with pkgs.vimPlugins; [
              actions-preview-nvim
              tiny-inline-diagnostic-nvim
            ];
            database = with pkgs.vimPlugins; [
              vim-dadbod
              vim-dadbod-ui
              vim-dadbod-completion
            ];
            testing = with pkgs.vimPlugins; {
              javascript = [
                neotest-playwright
                neotest-vitest
                neotest-jest
              ];
              default = [
                neotest
                FixCursorHold-nvim
                neotest-plenary
              ];
            };
            debug = with pkgs; {
              default = with vimPlugins; [
                nvim-dap
                nvim-dap-ui
                nvim-dap-virtual-text
              ];
            };
            lint = with pkgs.vimPlugins; [
              nvim-lint
            ];
            format = with pkgs; {
              always = with vimPlugins; [
                conform-nvim
              ];
            };
            markdown = with pkgs.vimPlugins; [
              render-markdown-nvim
            ];
            neonixdev = with pkgs.vimPlugins; [
              lazydev-nvim
            ];
            styling = with pkgs.vimPlugins; [
              lualine-lsp-progress
              lualine-nvim
              monokai-pro-nvim
              smear-cursor-nvim
              inc-rename-nvim
            ];
            file-manager = with pkgs.vimPlugins; [
              nvim-lsp-file-operations
              oil-nvim
              yazi-nvim
              aerial-nvim
            ];
            session-manager = with pkgs.vimPlugins; [
              persistence-nvim
            ];
            general = {
              blink = with pkgs.vimPlugins; [
                blink-cmp-npm-nvim
                blink-cmp
                blink-compat
                luasnip
                colorful-menu-nvim
              ];
              treesitter = with pkgs.vimPlugins; [
                pkgs.neovimPlugins.treesitter-textobjects
                (nvim-treesitter.withPlugins (
                  plugins: with plugins; [
                    query
                    nix
                    liquid
                    toml
                    html
                    tsx
                    vim
                    svelte
                    javascript
                    typescript
                    regex
                    lua
                    bash
                    markdown
                    markdown_inline
                    rust
                    sql
                  ]
                ))
              ];
              git = with pkgs.vimPlugins; [
                gitsigns-nvim
                diffview-nvim
                neogit
              ];
              always = with pkgs.vimPlugins; [
                nvim-lspconfig
                nvim-surround
                trouble-nvim
              ];
              utility = with pkgs.vimPlugins; [
                nui-nvim
                undotree
                substitute-nvim
                todo-comments-nvim
                auto-session
                comment-nvim
                # completion
                nvim-ts-autotag
                nvim-autopairs
                which-key-nvim
                # search functionality
                flash-nvim
                # run code in files
                sniprun
                # config file completion
                package-info-nvim
              ];
            };
          };

          extraCats = {
            test = [
              [
                "test"
                "default"
              ]
            ];
            debug = [
              [
                "debug"
                "default"
              ]
            ];
          };
        };

      packageDefinitions = {
        nixCats =
          { pkgs, ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              aliases = [
                "nvim"
                "vim"
                "vi"
                "vimdiff"
                "vimcat"
              ];
              wrapRc = true;
              configDirName = "nixCats-nvim";
            };
            categories = {
              profiling = false;
              session-manager = true;
              configuration-files = true;
              diagnostics = true;
              file-manager = true;
              git = true;
              database = true;
              markdown = true;
              javascript = true;
              rust = true;
              rust-analyzer = false;
              typescript = true;
              utility = true;
              testing = true;
              debug = true;
              styling = true;
              general = true;
              lint = true;
              format = true;
              neonixdev = true;
              lspDebugMode = false;
              colorscheme = "monokai-pro";
            };
            extra = {
              nixdExtras = {
                nixpkgs = ''import ${pkgs.path} {}'';
              };
            };
          };
      };

      defaultPackageName = "nixCats";
    in
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;

        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        };

      }
    )
    // (
      let
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
