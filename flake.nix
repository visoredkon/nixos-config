{
  description = "I use NixOS btw";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;

      arch = "x86_64-linux";
      stateVersion = lib.versions.majorMinor lib.version;

      username = "pahril";
      hostname = {
        guiHost = "nixu";
        cli = "rune";
      };

      mkPkgs = {
        "nixos" = {
          nixpkgs = {
            hostPlatform = arch;
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "cloudflare-warp"
              ];
          };
        };
        "home-manager" = {
          nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "discord"
              "intelephense"
              "obsidian"
              "ookla-speedtest"
              "phpstorm"
              "spotify"
              "vscode"
            ];
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
          path,
        }:
        {
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              stateVersion
              username
              ;
          };
          home-manager.users.${username} =
            { ... }:
            {
              imports = [
                mkPkgs."home-manager"

                path
              ];
            };
        };
    in
    {
      nixosConfigurations = {
        "${hostname.guiHost}" = mkSystem {
          hostname = "${hostname.guiHost}";
          extraModules = [
            home-manager.nixosModules.home-manager
            (mkHome {
              path = ./modules/home-manager/desktop;
            })
          ];
        };

        "${hostname.cli}" = mkSystem {
          hostname = "${hostname.cli}";
          extraModules = [
            home-manager.nixosModules.home-manager
            (mkHome {
              path = ./modules/home-manager/base;
            })
          ];
        };
      };
    };
}
