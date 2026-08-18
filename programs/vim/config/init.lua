require("core.options")
require("core.keymaps")
require("core.colorscheme")
require("plugins.comment")
require("plugins.cmp-config")
require("plugins.nvim-tree")
require("plugins.telescope")
-- require("plugins.nvim-cmp")
require("plugins.autopairs")
require("plugins.treesitter")
require("plugins.legendary-config")
require("plugins.indent-blankline-config")
require("plugins.lsp")

require("neogit").setup{}

require("gitsigns").setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend("force", opts or {}, { buffer = bufnr })
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Jump between hunks
    map("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })
    map("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, { expr = true, desc = "Previous hunk" })

    -- Stage / reset hunks
    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })

    -- Stage / reset entire buffer
    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })

    -- Preview, blame, diff
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })

    -- Undo staged hunk
    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })

    -- Toggles
    map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle inline blame" })
    map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted lines" })
  end,
}
