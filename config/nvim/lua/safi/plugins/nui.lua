return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = { -- add any options here
        -- ...
    },
    dependencies = {
        "MunifTanjim/nui.nvim", -- Dependency is automatically handled by lazy.nvim
        "rcarriga/nvim-notify",
    },
    vim.keymap.set('n', '<leader>cn', function()
        require('notify').dismiss({ silent = true, pending = true })
    end, { desc = 'Dismiss notifications' })
}
