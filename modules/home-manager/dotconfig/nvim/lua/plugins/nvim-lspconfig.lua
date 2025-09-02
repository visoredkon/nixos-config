return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {},

        lua_ls = {},

        nixd = {
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
              },
            },
          },
        },

        hyprls = {},
      },
    },
  },
}
