return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "│" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 500,
    },
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        opts.desc = opts.desc and ("Gitsigns: " .. opts.desc) or nil
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end)

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end)

      -- Actions
      map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage the current hunk" })
      map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset the current hunk" })

      map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage the selected hunk" })

      map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset the selected hunk" })

      map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage the entire buffer" })
      map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset the entire buffer" })
      map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview the current hunk" })
      map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview the current hunk inline" })

      map("n", "<leader>hb", gitsigns.blame_line, { desc = "Show blame for the current line" })

      map("n", "<leader>hd", gitsigns.diffthis, { desc = "Show diff for the current file" })

      map("n", "<leader>hD", function()
        gitsigns.diffthis("~")
      end, { desc = "Show diff against the previous commit" })

      map("n", "<leader>hQ", function()
        gitsigns.setqflist("all")
      end, { desc = "Add all hunks to the quickfix list" })
      map("n", "<leader>hq", gitsigns.setqflist, { desc = "Add current hunk to the quickfix list" })

      -- Toggles
      map("n", "<leader>htb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame for the current line" })
      map("n", "<leader>htw", gitsigns.toggle_word_diff, { desc = "Toggle word diff highlighting" })

      -- Text object
      map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select the current hunk" })
    end,
  },
}
