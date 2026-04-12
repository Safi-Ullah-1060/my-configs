return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        local harpoon_extensions = require("harpoon.extensions")
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        vim.keymap.set("n", "ha", function() harpoon:list():add() end)
        vim.keymap.set("n", "hx", function() harpoon:list():remove() end)
        vim.keymap.set("n", "hv", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        for i = 1, 9 do
            vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { noremap = true })
        end

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
    end
}
