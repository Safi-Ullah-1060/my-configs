return {
    "hrsh7th/cmp-nvim-lsp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/lazydev.nvim", opts = {} },
    },
    config = function()
        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- Super-Tab style: <Tab> expands OR jumps forward, <S-Tab> jumps backward
        -- Put this AFTER cmp.setup() or in a place where luasnip and cmp are already required

        local luasnip = require("luasnip")
        local cmp = require("cmp") -- only needed if you want cmp menu fallback

        -- Forward jump / expand
        vim.keymap.set({ "i", "s" }, "<Tab>", function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif cmp.visible() then
                cmp.select_next_item()
            else
                -- Normal <Tab> behavior (indent, insert tab, etc.)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
            end
        end, { silent = true, desc = "LuaSnip / cmp: expand or jump" })

        -- Backward jump
        vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n", true)
            end
        end, { silent = true, desc = "LuaSnip / cmp: jump backward" })
    end,
}
