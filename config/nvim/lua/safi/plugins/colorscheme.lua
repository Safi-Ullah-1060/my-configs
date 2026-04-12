return {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
        require("kanagawa").setup({
            overrides = function(colors)
                local palette = colors.palette -- ← access via the passed colors object (preferred)
                -- local palette = require("kanagawa.colors").palette  -- this also works but is less "theme-aware"

                return {
                    CursorLineNr = { fg = palette.roninYellow, bold = true },
                    LineNr = { fg = palette.waveAqua2 },

                    -- If you want to override the relative-line variants (Neovim 0.10+):
                    -- LineNrAbove = { fg = palette.oldWhite },
                    -- LineNrBelow = { fg = palette.oldWhite },
                }
            end,

            theme = "dragon", -- this selects the base theme to load

            background = {    -- map :set background=XXX → theme
                dark = "dragon",
                light = "lotus",
            },

            -- other options you might want...
            -- compile = true,         -- speeds up startup after first compile
            transparent = true,
            -- commentStyle = { italic = true },
        })
        vim.cmd("colorscheme kanagawa")
    end,
}

-- Uncomment ablove block and comment below block to use kanagawa

-- return {
--     "gmr458/vscode_modern_theme.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         require("vscode_modern").setup({
--             cursorline = true,
--             transparent_background = false,
--             nvim_tree_darker = true,
--         })
--         vim.cmd.colorscheme("vscode_modern")
--     end,
-- }
