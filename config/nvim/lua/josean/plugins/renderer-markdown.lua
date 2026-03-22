return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown" }, -- only loads for markdown files
        config = function()
            local rm = require("render-markdown")

            rm.setup({
                -- Rendered in normal, command and terminal modes.
                -- In insert mode raw markdown is shown so you can edit cleanly.
                render_modes = { "n", "c", "t" },

                -- ── Headings ────────────────────────────────────────────────────────
                -- Each level gets a different icon and background highlight.
                -- Icons use Nerd Font glyphs — remove them if you don't use NF.
                heading = {
                    enabled = true,
                    sign = false, -- no sign column clutter
                    icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                    width = "full", -- highlight spans full window width
                },

                -- ── Code blocks ─────────────────────────────────────────────────────
                -- Gives code blocks a distinct background and a language label.
                code = {
                    enabled = true,
                    sign = false,
                    style = "full", -- background + border
                    width = "block", -- only as wide as the code, not full window
                    right_pad = 1,
                    language_pad = 1, -- padding around language label
                },

                -- ── Bullets ─────────────────────────────────────────────────────────
                -- Replaces - / * / + with clean bullet icons per nesting level.
                bullet = {
                    enabled = true,
                    icons = { "●", "○", "◆", "◇" },
                },

                -- ── Checkboxes ──────────────────────────────────────────────────────
                -- Renders [ ] and [x] as visual checkboxes.
                checkbox = {
                    enabled = true,
                    unchecked = { icon = "󰄱 " },
                    checked = { icon = "󰱒 " },
                },

                -- ── Horizontal rules ────────────────────────────────────────────────
                -- Renders --- as a full-width decorative line.
                dash = {
                    enabled = true,
                    icon = "─",
                    width = "full",
                },

                -- ── Tables ──────────────────────────────────────────────────────────
                -- Renders markdown tables with proper box-drawing characters.
                pipe_table = {
                    enabled = true,
                    style = "full", -- full borders around the table
                },

                -- ── Inline code ─────────────────────────────────────────────────────
                -- Highlights `inline code` with a subtle background.
                inline_highlight = {
                    enabled = true,
                },

                -- ── Links ───────────────────────────────────────────────────────────
                -- Adds icons before links and images.
                link = {
                    enabled = true,
                    image = "󰥶 ",
                    hyperlink = "󰌹 ",
                },

                -- ── Callouts / alerts ───────────────────────────────────────────────
                -- GitHub-flavoured alerts like > [!NOTE], > [!WARNING] etc.
                quote = {
                    enabled = true,
                    icon = "▋",
                },

                -- ── nvim-cmp completions ─────────────────────────────────────────────
                -- Provides checkbox and callout completions in insert mode.
                completions = {
                    lsp = { enabled = true },
                },
            })

            -- ── Keymaps ─────────────────────────────────────────────────────────────
            local map = vim.keymap.set

            -- Toggle rendering on/off (useful when you need to see raw markdown)
            map("n", "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", { desc = "Markdown: Toggle render" })

            -- Expand / collapse all folds (useful for long documents)
            map("n", "<leader>me", "<cmd>RenderMarkdown expand<cr>", { desc = "Markdown: Expand all" })

            map("n", "<leader>mc", "<cmd>RenderMarkdown contract<cr>", { desc = "Markdown: Contract all" })
        end,
    },
}
