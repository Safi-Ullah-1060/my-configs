return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({

            -- ── Only intercept cmdline input — nothing else ────────────────────
            -- Messages, notifications, LSP messages all fall back to Neovim's
            -- native handling. Only the command input gets the floating popup.
            messages = {
                enabled = false, -- native Neovim handles all messages
            },

            notify = {
                enabled = false, -- native vim.notify, no floats
            },

            -- ── Cmdline input popup ────────────────────────────────────────────
            cmdline = {
                enabled = true,
                view    = "cmdline_popup",
                format  = {
                    cmdline     = { icon = ">" },
                    search_down = { icon = "/ ↓" },
                    search_up   = { icon = "/ ↑" },
                    filter      = { icon = "$" },
                    lua         = { icon = "☾" },
                    help        = { icon = "?" },
                },
            },

            -- ── LSP styling only ──────────────────────────────────────────────
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"]                = true,
                    ["cmp.entry.get_documentation"]                  = true,
                },
                progress = { enabled = false }, -- no LSP progress floats
            },

            -- ── Presets ───────────────────────────────────────────────────────
            presets = {
                bottom_search   = true, -- / and ? stay at bottom natively
                command_palette = false,
                lsp_doc_border  = true,
            },

            -- ── Cmdline popup position ────────────────────────────────────────
            views = {
                cmdline_popup = {
                    position    = { row = "40%", col = "50%" },
                    size        = { width = 60, height = "auto" },
                    border      = { style = "rounded", padding = { 0, 1 } },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
            },
        })

        -- ── Keymaps ───────────────────────────────────────────────────────────

        -- Clear cmdline area (native)
        vim.keymap.set("n", "<leader>cn", function()
            vim.cmd("echo ''")
        end, { desc = "Clear cmdline output" })
    end,
}
