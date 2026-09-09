-- nightfox: options are set at setup time — must run BEFORE the colorscheme
-- command. `options.transparent` lets kitty's blur show through the editor
-- and nvim-tree panels (nightfox sets NvimTreeNormal bg = NONE when enabled).
require("nightfox").setup({
  options = {
    transparent = true,
  },
  groups = {
    nightfox = {
      CursorLine = { bg = "#1e2a3a" },
      Visual = { bg = "#3b4f6b" },
    },
  },
})
