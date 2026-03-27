return {
    -- ── Core Mason (only loads when :Mason is called) ──────────────────────────
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    -- ── LSP server installer ───────────────────────────────────────────────────
    -- Loads on BufReadPre so LSP is ready when you open a file,
    -- but not during the initial startup splash.
    {
        "williamboman/mason-lspconfig.nvim",
        event = "BufReadPre",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                -- Keep only what you actively use
                "lua_ls", -- Lua (nvim config)
                "bashls", -- Bash
                "pyright", -- Python
                "bashls", -- Bash
                "clangd", -- C/C++
                -- Web tools removed — add back if you return to web dev:
                -- "ts_ls", "html", "cssls", "tailwindcss",
                -- "svelte", "graphql", "emmet_ls", "prismals", "eslint",
            },
        },
    },

    -- ── Formatter / linter installer ──────────────────────────────────────────
    -- VeryLazy = loads after UI, does not block startup at all
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "stylua", -- Lua formatter
                "black", -- Python formatter
                "isort", -- Python import sorter
                "shfmt", -- Bash Formattter
                "shellcheck", -- Bash Linter
                "pylint", -- Python linter
                "clang-format", -- C/C++ formatter
                "markdown-toc", -- MD formatter
                "markdownlint-cli2", -- MD formatter
                -- Removed: prettier, eslint_d (web dev tools)
            },
            automatic_enable = true,
        },
    },
}
