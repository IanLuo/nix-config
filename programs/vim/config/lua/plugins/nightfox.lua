-- nightfox: options are set at setup time — must run BEFORE the colorscheme
-- command. `options.transparent` lets kitty's blur show through the editor
-- and nvim-tree panels (nightfox sets NvimTreeNormal bg = NONE when enabled).
require("nightfox").setup({
  options = {
    transparent = true,
  },
})
