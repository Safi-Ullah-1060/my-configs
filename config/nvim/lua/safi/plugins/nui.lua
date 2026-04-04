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
}
