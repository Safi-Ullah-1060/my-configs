return -- hot-reload.nvim [config reload]
-- https://github.com/Zeioth/hot-reload.nvim
{
    "Zeioth/hot-reload.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufEnter",
    opts = function()
        local config_dir = vim.fn.stdpath("config") .. "/lua/safi/"
        local map = vim.keymap.set

        map("n", "<leader><leader>", "<cmd>Reload", { desc = "Reload_neovim" })

        return {
            -- Files to be hot-reloaded when modified.
            reload_files = {
                config_dir .. "core/init.lua",
                config_dir .. "core/options.lua",
                config_dir .. "core/keymaps.lua",
            },
            -- Things to do after hot-reload trigger.
            reload_callback = function()
                vim.cmd(":silent! colorscheme " .. vim.g.default_colorscheme) -- nvim     colorscheme reload command.
                vim.cmd(":silent! doautocmd ColorScheme") -- heirline colorscheme reload event.
            end,
        }
    end,
}
