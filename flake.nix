{
  description = "I use NixOS btw";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stabel.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixos-cli.url = "github:nix-community/nixos-cli";

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
      nixpkgs-stabel,
      home-manager,
      ...
    }:
    let
      arch = "x86_64-linux";
      stateVersion = nixpkgs.lib.versions.majorMinor nixpkgs.lib.version;

      username = "pahril";
      hostname = {
        guiHost = "nixu";
        cli = "rune";
      };

      mkSystem =
        {
          hostname,
          system ? arch,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit
              inputs
              stateVersion
              username
              system
              hostname
              ;

            stable = import nixpkgs-stabel { system = system; };
          };
          modules = [
            ./hosts/${hostname}

            (
              { ... }:
              {
                nixpkgs.overlays = [
                  (self: super: {
                    ripgrep = super.ripgrep.override {
                      withPcre2 = true;
                    };
                  })
                ];
              }
            )
          ]
          ++ extraModules;
        };

      mkHome =
        {
          hostname,
          system ? arch,
          path,
        }:
        {
          # home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              stateVersion
              username
              system
              ;

            stable = nixpkgs-stabel.legacyPackages.${system};
            hostName = "${hostname}";
          };
          home-manager.users.${username} =
            { ... }:
            {
              imports = [ path ];
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
              hostname = "${hostname.guiHost}";
              path = ./modules/home-manager/desktop;
            })
          ];
        };

        "${hostname.cli}" = mkSystem {
          hostname = "${hostname.cli}";
          extraModules = [
            home-manager.nixosModules.home-manager
            (mkHome {
              hostname = "${hostname.cli}";
              path = ./modules/home-manager/base;
            })
          ];
        };
      };
    };
}
