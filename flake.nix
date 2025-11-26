{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
      allowUnfree = true;
    };
    dependencyOverlays = /* (import ./overlays inputs) ++ */ [
      (utils.standardPluginOverlay inputs)
    ];

    categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags
          ripgrep
          fd
        ];
        neonixdev = {
          inherit (pkgs) nix-doc lua-language-server nixd;
        };
      };

      startupPlugins = {
        debug = with pkgs.vimPlugins; [
          nvim-nio
        ];
        general = with pkgs.vimPlugins; {
          always = [
            lze
            lzextras
            vim-repeat
            plenary-nvim
            (nvim-notify.overrideAttrs { doCheck = false; }) # TODO: remove overrideAttrs after check is fixed
          ];
          extra = [
            oil-nvim
            nvim-web-devicons
          ];
        };
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # or a tool for organizing this like lze or lz.n!
      # to get the name packadd expects, use the
      # `:NixCats pawsible` command to see them all
      optionalPlugins = {
        debug = with pkgs.vimPlugins; {
          default = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];
        };
        lint = with pkgs.vimPlugins; [
          nvim-lint
        ];
        format = with pkgs.vimPlugins; [
          conform-nvim
        ];
        markdown = with pkgs.vimPlugins; [
          markdown-preview-nvim
        ];
        neonixdev = with pkgs.vimPlugins; [
          lazydev-nvim
        ];
        general = {
          blink = with pkgs.vimPlugins; [
            luasnip
            cmp-cmdline
            blink-cmp
            blink-compat
            colorful-menu-nvim
          ];
          treesitter = with pkgs.vimPlugins; [
            nvim-treesitter-textobjects
              (nvim-treesitter.withPlugins (
                plugins: with plugins; [
                  nix
                  lua
                ]
              ))
          ];
          telescope = with pkgs.vimPlugins; [
            telescope-fzf-native-nvim
            telescope-ui-select-nvim
            telescope-nvim
          ];
          always = with pkgs.vimPlugins; [
            nvim-lspconfig
            lualine-nvim
            gitsigns-nvim
            vim-sleuth
            vim-fugitive
            vim-rhubarb
            nvim-surround
          ];
          extra = with pkgs.vimPlugins; [
            fidget-nvim
            # lualine-lsp-progress
            which-key-nvim
            comment-nvim
            undotree
            indent-blankline-nvim
            vim-startuptime
            monokai-pro-nvim
            # If it was included in your flake inputs as plugins-hlargs,
            # this would be how to add that plugin in your config.
            # pkgs.neovimPlugins.hlargs
          ];
        };
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [ # <- this would be included if any of the subcategories of general are
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          default = {
            CATTESTVARDEFAULT = "It worked!";
          };
        };
      };

      # see :help nixCats.flake.outputs.categoryDefinitions.default_values
      # this will enable test.default and debug.default
      # if any subcategory of test or debug is enabled
      # WARNING: use of categories argument in this set will cause infinite recursion
      # The categories argument of this function is the FINAL value.
      # You may use it in any of the other sets.
      extraCats = {
        test = [
          [ "test" "default" ]
        ];
        debug = [
          [ "debug" "default" ]
        ];
        go = [
          [ "debug" "go" ] # yes it has to be a list of lists
        ];
      };
    };

    packageDefinitions = {
      nixCats = { pkgs, name, ... }@misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          # The name of the package, and the default launch name,
          # and the name of the .desktop file, is `nixCats`,
          # or, whatever you named the package definition in the packageDefinitions set.
          # WARNING: MAKE SURE THESE DONT CONFLICT WITH OTHER INSTALLED PACKAGES ON YOUR PATH
          # That would result in a failed build, as nixos and home manager modules validate for collisions on your path
          aliases = [ "nvim" "vim" "vi" "vimdiff" "vimcat" ];

          # explained below in the `regularCats` package's definition
          # OR see :help nixCats.flake.outputs.settings for all of the settings available
          wrapRc = true;
          configDirName = "nixCats-nvim";
        };
        # enable the categories you want from categoryDefinitions
        categories = {
          markdown = true;
          general = true;
          lint = true;
          format = true;
          neonixdev = true;

          lspDebugMode = false;
          colorscheme = "monokai-pro";
        };
        extra = {
          # to keep the categories table from being filled with non category things that you want to pass
          # there is also an extra table you can use to pass extra stuff.
          # but you can pass all the same stuff in any of these sets and access it in lua
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
            # or inherit nixpkgs;
          };
        };
      };
    };

    defaultPackageName = "nixCats";
  in
  # you shouldnt need to change much past here, but you can if you wish.
  # but you should at least eventually try to figure out whats going on here!
  # see :help nixCats.flake.outputs.exports
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
