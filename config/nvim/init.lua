require("safi.core.init")
require("safi.lazy")
require("safi.lsp")
vim.g.uni = "~/dotfiles/config"
vim.g.uni = "~/Uni Data/Sem IV"
if vim.g.neovide then
    vim.g.neovide_opacity = 0.9
    vim.g.neovide_cursor_animation_length = 0.13
    vim.g.neovide_cursor_trail_size = 0.8
    vim.o.guifont = "Hack Nerd Font Propo:h15"
    vim.g.neovide_fullscreen = true
    vim.g.neovide_refresh_rate = 60
end
