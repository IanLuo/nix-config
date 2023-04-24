require('nvim-lightbulb').setup({
  sign = {
    enabled = true,
    priority = 10,
  },
  float = {
    enabled = true,
    text = "💡",
    win_opts = {
      winblend = 100,
      border = "none",
    },
    opts = {
      position = 'bottom',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
  },
  virtual_text = {
    enabled = true,
    text = "💡",
  },
  status_text = {
    enabled = true,
    text = "💡",
  },
})
