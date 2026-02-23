return {
  "vyfor/cord.nvim",
  lazy = true,
  event = "VeryLazy",
  build = ":Cord update",
  opts = {
    enabled = true,

    editor = {
      -- client = "",
      icon = "https://media1.tenor.com/m/4uxLipQnd-0AAAAd/anime-frieren.gif",
      tooltip = "Frieren",
    },

    display = {
      swap_icons = true,
      theme = "catppuccin",
    },

    text = {
      workspace = function(opts)
        -- return "📁 | " .. vim.fn.ge cwd():match("[^/]+$")
        return "📁 | " .. opts.workspace
      end,
      viewing = function(opts)
        return "📄 | " .. opts.filename
      end,
      editing = function(opts)
        return "📝 | " .. opts.filename
      end,
      file_browser = function(opts)
        return "🗃️ | " .. opts.name
      end,
      plugin_manager = function(opts)
        return "Managing plugins in " .. opts.name
      end,
      lsp = function(opts)
        return "Configuring LSP in " .. opts.name
      end,
      docs = function(opts)
        return "📄 | " .. opts.name
      end,
      vcs = function(opts)
        return "Committing changes in " .. opts.name
      end,
      notes = function(opts)
        return "Taking notes in " .. opts.name
      end,
      debug = function(opts)
        return "🐞 | " .. opts.name
      end,
      test = function(opts)
        return "Testing in " .. opts.name
      end,
      diagnostics = function(opts)
        return "Fixing problems in " .. opts.name
      end,
      games = function(opts)
        return "Playing " .. opts.name
      end,
      terminal = function(opts)
        return "Running commands in " .. opts.name
      end,
      dashboard = "Home",
    },
  },
}
