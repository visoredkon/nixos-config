{
  description = "I use NixOS btw";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/visoredkon/nixos-secrets.git";
      flake = false;
    };

    # secrets = {
    #   url = "git+file:///home/pahril/.config/nixos-config/secrets";
    #   flake = false;
    # };

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

    my-flakes = {
      url = "github:visoredkon/my-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pvetui = {
      url = "github:devnullvoid/pvetui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
      inherit (nixpkgs) lib;
      arch = "x86_64-linux";
      stateVersion = lib.versions.majorMinor lib.version;

      username = "pahril";
      hostname = {
        guiHost = "nixu";
        cli = "rune";
      };

      nixSettings = {
        nix.settings = {
          extra-substituters = [
            "https://attic.xuyh0120.win/lantian"
            "https://hyprland.cachix.org"
            "https://nix-community.cachix.org"
          ];
          extra-trusted-public-keys = [
            "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          fallback = true;
        };
      };

      pkgs-unstable = import nixpkgs-unstable {
        system = arch;
        config.allowUnfreePredicate =
          pkg:
          {
            "antigravity" = true;
            "lmstudio" = true;
            "vscode" = true;
          } ? ${lib.getName pkg};
      };

      mkPkgs = {
        "nixos" = {
          nixpkgs = {
            system = arch;
            config.allowUnfreePredicate =
              pkg:
              {
                "cloudflare-warp" = true;
              } ? ${lib.getName pkg};
            overlays = [
              inputs.nix-cachyos-kernel.overlays.pinned
            ];
          };
        };

        "home-manager" = {
          nixpkgs = {
            config.allowUnfreePredicate =
              pkg:
              {
                "discord" = true;
                "google-chrome" = true;
                "hytale-launcher" = true;
                "intelephense" = true;
                "obsidian" = true;
                "ookla-speedtest" = true;
                "postman" = true;
                "terraform" = true;
                "spotify" = true;
              } ? ${lib.getName pkg};
            overlays = [
              inputs.hytale-launcher.overlays.default
              inputs.my-flakes.overlays.default

              (_final: prev: {
                pvetui = inputs.pvetui.packages.${prev.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
                  vendorHash = "sha256-5dcnwOlai2OAC28GgO2IAi1W039+sut+9ThbntNadS0=";
                });
              })

              (_final: prev: {
                waybar = (prev.waybar.override { cavaSupport = false; }).overrideAttrs (_: {
                  src = prev.fetchFromGitHub {
                    owner = "Alexays";
                    repo = "Waybar";
                    rev = "05945748dccce28bf96d26d8f64a9e69a8dd49ba";
                    hash = "sha256-51R3mIt8cLNvh/X5qe9vOqeJCj0U9KRyemVE5y+OhiU=";
                  };
                });
              })
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
            nixSettings
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
          home-manager = {
            useUserPackages = true;
            backupFileExtension = "home-manager.backup";
            extraSpecialArgs = {
              inherit
                inputs
                pkgs-unstable
                stateVersion
                username
                hostname
                ;
            };
          };
          home-manager.users.${username} =
            { ... }:
            {
              imports = [
                mkPkgs."home-manager"

                homePath
              ];
            };
        };
    in
    {
      formatter.${arch} =
        (treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${arch} ./treefmt.nix).config.build.wrapper;

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
