return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        animate = {
          duration = {
            step = 20,
            total = 100,
          },
        },
      },
      dashboard = {
        preset = {
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          header = [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠠⠤⠤⠤⠤⠤⠤⠀⣀⣀⣀⠀⠀⢀⡀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⡒⠉⠀⠀⠀⠒⠲⠤⡀⠀⠀⠀⠈⠙⠻⣷⠿⢄⡀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡔⡵⠋⠀⡆⠀⠀⠀⠀⠀⠀⠈⠳⣄⠀⠀⠀⠀⠀⠑⢄⠙⢪⡓⣌⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢊⠎⠀⠀⢠⠋⠦⡀⠀⠀⠀⠀⠀⠀⠈⢣⡀⢢⠀⠀⠀⠈⢣⡀⢹⣌⢯⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⢃⡎⢀⠀⢠⠇⠀⠀⠈⠒⣵⡲⣖⠖⠀⠀⠠⢣⠈⣇⠀⠀⠀⢰⣵⠀⠘⡆⢻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢸⠀⣞⣠⣃⠀⠀⠀⠀⠀⠋⣉⡙⠿⡦⣄⡀⠈⡇⢸⠀⠀⠀⠀⠟⣧⠀⢸⡄⢳⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⡄⢠⢿⠯⠜⠁⠀⠀⠀⠀⢸⡇⠀⠀⠀⡀⠈⠁⢺⠘⠀⠀⠀⠀⢰⢸⠀⢸⣇⠈⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣬⠃⠃⢸⢯⠞⠙⠦⠀⠀⠀⠀⠈⢀⣶⢾⣿⣿⡿⣧⢾⠛⠀⠀⠀⠀⠘⢸⣠⣃⣿⡀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⢰⢻⠈⢠⣐⣤⣀⠀⠀⠀⠀⠸⠃⠘⡷⢽⠿⠁⢸⣸⡆⠀⠀⠀⣤⢸⢁⣠⠤⠬⠭⠭⠭⣭⣭⠭⢭⡭⠟⣩⠆
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡀⠀⢻⣠⣿⠻⣟⢿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⢧⠀⠀⢠⢿⡏⠙⢢⠀⠀⠀⠀⠀⡼⠨⢔⣯⠴⠋⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⡀⠀⣇⠈⠙⠋⠉⢸⣇⠄⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠸⡀⠀⡌⢸⣁⣤⣊⡀⠤⠤⣖⣪⠖⠚⠉⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢤⣃⣇⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠄⠀⠀⠀⠀⠘⠀⠀⣇⣞⣄⣈⣽⠟⣆⣀⡤⠚⠁⠀⣆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠯⠭⠝⢻⣿⡄⢸⢧⠀⠀⠀⠀⠀⠒⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠞⠉⠀⣷⠀⡇⡇⠀⠀⠀⢿⡆⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⢹⣼⠒⠳⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⠈⡇⠀⢸⢰⣿⢸⢹⠀⠀⠀⠀⡘⣷⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡌⡼⠈⠀⠀⢿⡷⢄⡀⠀⠀⠀⠀⠀⠀⢀⡠⠔⠉⠀⠀⠀⡇⠀⢸⢸⣿⣏⡇⠀⠀⠀⠀⡇⢋⠇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣧⠇⠀⠀⠀⣾⡇⠀⡉⡖⢤⣀⣀⣤⣶⣛⣀⣠⣤⣤⣤⣤⣇⠀⢸⡞⣻⡞⠀⠀⠀⠀⠀⣷⢸⡸⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡘⠀⠀⠀⢰⠛⠃⣰⢁⣷⡿⣿⣉⣉⡭⠭⠭⠭⠽⠷⠯⠤⠤⡵⢸⣇⣷⠁⠀⠀⠀⠀⠀⢻⢸⡇⢣⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⠃⠀⠀⣠⠸⠀⢰⠃⡼⡸⡇⠘⣿⣿⠀⠀⠀⠀⠀⠀⠀⣀⣀⣡⣸⡿⠁⠀⠀⠀⠀⠀⢰⢸⢸⡇⢸⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⢀⣇⠇⢠⢃⠜⠹⣹⣁⣈⣉⣉⣉⣉⣉⣉⣉⣉⡁⠤⠤⠤⡼⠁⠀⠀⠀⠀⠀⠆⢸⢸⣾⢣⡎⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⣜⡜⢠⠟⠁⣀⡀⢀⡏⡜⢡⡏⢸⠀⡇⠀⠀⠀⠀⠀⠀⢰⠃⠀⠀⠀⠀⠀⢰⠀⣸⣰⠷⠃⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡜⠀⠀⠀⢠⠹⢡⠇⠀⠀⠉⠪⣽⣧⡇⠸⡇⠸⠤⡧⠤⠃⠀⠀⠀⠀⡎⠀⠀⠀⠀⠀⠀⠘⠀⣇⠋⠳⣄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⠔⡽⠀⠀⠀⠀⣎⢀⠏⠀⠀⠀⠀⢠⠃⡘⢀⠏⢹⠀⡄⠁⠀⠀⠀⠀⠀⢰⠃⠀⠀⠀⠀⠀⠀⡇⠀⡏⠀⠀⠘⢷⡄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡰⠋⣼⠆⠀⠀⠀⢸⡎⡜⠀⠀⠀⠀⠀⡞⢠⠇⡜⠀⢸⠀⡇⢰⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⡇⠀⡇⠀⠀⠀⠈⢿⡀⠀⠀]],
                    -- stylua: ignore
                    ---@diagnostic disable-next-line: undefined-doc-name
                    ---@type snacks.dashboard.Item[]
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
          project = {
            limit = 2,
          },
          recent_files = {
            limit = 2,
          },
        },
        sections = {
          {
            -- pane = 1,
            {
              section = "header",
            },
            {
              section = "keys",
              -- gap = 0.7,
              padding = 1,
            },
          },
          {
            -- pane = 2,
            {
              icon = " ",
              title = "Projects",
              section = "projects",
              indent = 2,
              padding = 1,
            },
            {
              icon = " ",
              title = "Recent Files",
              section = "recent_files",
              indent = 2,
              padding = 1,
            },
          },
          {
            section = "startup",
          },
          -- {
          --     pane = 2,
          --     section = "terminal",
          --     cmd = "colorscript -e square",
          --     height = 5,
          --     padding = 1,
          -- },
          -- {
          --     pane = 2,
          --     icon = " ",
          --     title = "Git Status",
          --     section = "terminal",
          --     enabled = function()
          --         return Snacks.git.get_root() ~= nil
          --     end,
          --     cmd = "git status --short --branch --renames",
          --     height = 5,
          --     padding = 1,
          --     ttl = 5 * 60,
          --     indent = 3,
          -- },
        },
      },
    },
  },
}
