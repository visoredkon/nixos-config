{
  description = "I use NixOS btw";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

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

    forgecode = {
      url = "github:tailcallhq/forgecode/v2.11.1";
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
          {
            "antigravity" = true;
            "vscode" = true;
          } ? ${lib.getName pkg};
      };

      pkgs = import nixpkgs {
        system = arch;
        config.allowUnfreePredicate =
          pkg:
          {
            "cloudflare-warp" = true;
            "terraform" = true;
          } ? ${lib.getName pkg};
        overlays = [
          inputs.nix-cachyos-kernel.overlays.pinned
        ];
      };

      mkPkgs = {
        "nixos" = {
          nixpkgs.pkgs = pkgs;

          nix.settings = {
            extra-substituters = [
              "https://nix-community.cachix.org"
              "https://attic.xuyh0120.win/lantian"
            ];
            extra-trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
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
                "lmstudio" = true;
                "obsidian" = true;
                "ookla-speedtest" = true;
                "postman" = true;
                "spotify" = true;
              } ? ${lib.getName pkg};
            overlays = [
              (_: _: {
                forge = pkgs.stdenv.mkDerivation rec {
                  pname = "forge";
                  version = "2.11.1";

                  src = pkgs.fetchurl {
                    url = "https://github.com/tailcallhq/forgecode/releases/download/v${version}/forge-x86_64-unknown-linux-gnu";
                    hash = "sha256-v5H0/wdnFlSiXFTWF5oJU2cQTa1D3jdy+XPCeXmziA8=";
                  };

                  dontUnpack = true;
                  dontBuild = true;

                  nativeBuildInputs = [ pkgs.autoPatchelfHook ];

                  buildInputs = with pkgs; [
                    gcc.cc.lib
                    glibc
                  ];

                  installPhase = ''
                    mkdir -p $out/bin
                    cp $src $out/bin/forge
                    chmod +x $out/bin/forge
                  '';
                };
              })
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
