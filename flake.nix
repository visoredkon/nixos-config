{
  description = "I use NixOS btw";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/master";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+file:///home/pahril/.config/nixos-config/secrets";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hytale-launcher = {
      url = "github:visoredkon/hytale-launcher-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      treefmt-nix,
      ...
    }:
    let
      lib = nixpkgs.lib;

      arch = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${arch};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      stateVersion = lib.versions.majorMinor lib.version;

      username = "pahril";
      hostname = {
        guiHost = "nixu";
        cli = "rune";
      };

      pkgs-unstable = import nixpkgs-unstable {
        system = arch;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "antigravity"
            "vscode"
          ];
      };

      mkPkgs = {
        "nixos" = {
          nixpkgs = {
            hostPlatform = arch;
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "cloudflare-warp"
                "terraform"
              ];

            overlays = [
              inputs.nix-cachyos-kernel.overlays.pinned
            ];
          };

          nix.settings = {
            extra-substituters = [
              "https://attic.xuyh0120.win/lantian"
            ];
            extra-trusted-public-keys = [
              "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            ];
          };
        };
        "home-manager" = {
          nixpkgs = {
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "discord"
                "google-chrome"
                "hytale-launcher"
                "intelephense"
                "obsidian"
                "ookla-speedtest"
                "postman"
                "spotify"
              ];

            overlays = [
              inputs.hytale-launcher.overlays.default
            ];
          };
        };
      };

      mkSystem =
        {
          hostname,
          system ? arch,
          extraModules ? [ ],
        }:
        lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              stateVersion
              username
              hostname
              ;
          };
          modules = [
            mkPkgs."nixos"

            ./hosts/${hostname}
          ]
          ++ extraModules;
        };

      mkHome =
        {
          homePath,
          hostname,
        }:
        {
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "home-manager.backup";
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              pkgs-unstable
              stateVersion
              username
              hostname
              ;
          };
          home-manager.users.${username} =
            { ... }:
            {
              imports = [
                mkPkgs.home-manager

                homePath
              ];
            };
        };
    in
    {
      formatter.${arch} = treefmtEval.config.build.wrapper;

      nixosConfigurations = {
        "${hostname.guiHost}" = mkSystem {
          hostname = "${hostname.guiHost}";
          extraModules = [
            home-manager.nixosModules.home-manager
            (mkHome {
              homePath = ./modules/home-manager/desktop;
              hostname = "${hostname.guiHost}";
            })
          ];
        };

        "${hostname.cli}" = mkSystem {
          hostname = "${hostname.cli}";
          extraModules = [
            home-manager.nixosModules.home-manager
            (mkHome {
              homePath = ./modules/home-manager/base;
              hostname = "${hostname.cli}";
            })
          ];
        };
      };
    };
}
