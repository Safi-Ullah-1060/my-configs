require("safi.core.init")
require("safi.lazy")
require("safi.lsp")
vim.g.uni = "~/dotfiles/config"
vim.g.uni = "~/Uni Data/Sem IV"
if vim.g.neovide then
    local opacity = io.popen("bash -c $HOME/.config/nvim/read-term-opacity.sh")
    local opaNum = opacity:read("*a")
    opacity:close()
    opaNum = tonumber(opaNum)
    -- /home/safi/dotfiles/config/nvim/
    vim.g.neovide_opacity = opaNum
    vim.g.neovide_cursor_animation_length = 0.13
    vim.g.neovide_cursor_trail_size = 0.8
    vim.o.guifont = "MesloLGSDZ Nerd Font Mono:h17"
    vim.g.neovide_window_blurred = true
    vim.g.neovide_refresh_rate = 60
end
