{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
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
            general = with pkgs; [
              tombi
              universal-ctags
              ripgrep
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
                snacks-nvim
                noice-nvim
                oil-nvim
                vim-repeat
              ];
            };
          };

          optionalPlugins = {
            database = with pkgs.vimPlugins; [
              vim-dadbod
              vim-dadbod-ui
              vim-dadbod-completion
            ];
            testing = {
              default = with pkgs.vimPlugins; [
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
              markdown-preview-nvim
            ];
            neonixdev = with pkgs.vimPlugins; [
              lazydev-nvim
            ];
            styling = with pkgs.vimPlugins; [
              lualine-lsp-progress
              lualine-nvim
              monokai-pro-nvim
            ];
            general = {
              blink = with pkgs.vimPlugins; [
                luasnip
                blink-cmp
                blink-compat
                colorful-menu-nvim
              ];
              treesitter = with pkgs.vimPlugins; [
                nvim-treesitter-textobjects
                (nvim-treesitter.withPlugins (
                  plugins: with plugins; [
                    nix
                    vim
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
                comment-nvim
                which-key-nvim
                undotree
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
              git = true;
              database = true;
              markdown = true;
              rust = true;
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
