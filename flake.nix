{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = { nixpkgs, ... }@inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
      allowUnfree = true;
    };
    dependencyOverlays = /* (import ./overlays inputs) ++ */ [
      (utils.standardPluginOverlay inputs)
    ];

    categoryDefinitions = { pkgs, ... }: {
      lspsAndRuntimeDeps = {
        rust = with pkgs; [
          rust-analyzer
        ];
        database = with pkgs; [
          postgres-language-server 
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

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # or a tool for organizing this like lze or lz.n!
      # to get the name packadd expects, use the
      # `:NixCats pawsible` command to see them all
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
            stylua
            nixfmt
          ];
          rust = [ rustfmt ];
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
          [ "test" "default" ]
        ];
        debug = [
          [ "debug" "default" ]
        ];
      };
    };

    packageDefinitions = {
      nixCats = { pkgs, ... }: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          aliases = [ "nvim" "vim" "vi" "vimdiff" "vimcat" ];
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
  forEachSystem (system: let
    # and this will be our builder! it takes a name from our packageDefinitions as an argument, and builds an nvim.
    nixCatsBuilder = utils.baseBuilder luaPath {
      # we pass in the things to make a pkgs variable to build nvim with later
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
      # and also our categoryDefinitions and packageDefinitions
    } categoryDefinitions packageDefinitions;
    # call it with our defaultPackageName
    defaultPackage = nixCatsBuilder defaultPackageName;

    # this pkgs variable is just for using utils such as pkgs.mkShell
    # within this outputs set.
    pkgs = import nixpkgs { inherit system; };
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
  in {
    # these outputs will be wrapped with ${system} by utils.eachSystem

    # this will generate a set of all the packages
    # in the packageDefinitions defined above
    # from the package we give it.
    # and additionally output the original as default.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // (let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });

}
