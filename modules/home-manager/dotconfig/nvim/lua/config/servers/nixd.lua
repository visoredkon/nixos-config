return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "/home/pahril/.config/nixos-config").nixosConfigurations."nixu".config',
        },
        ["home-manager"] = {
          expr = '(builtins.getFlake "/home/pahril/.config/nixos-config").nixosConfigurations."nixu".config.home-manager.users."pahril"',
        },
      },
      diagnostics = {
        enable = true,
      },
    },
  },
}
