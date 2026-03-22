return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        -- pylint is accurate but very slow (full import analysis on every run).
        -- pyflakes is fast and catches the most important errors (undefined names,
        -- unused imports) without the overhead. Use <leader>l to run pylint manually
        -- when you want a deep check.
        lint.linters_by_ft = {
            python = { "pyflakes" }, -- fast, runs on save
            sh = { "shellcheck" },
            bash = { "shellcheck" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        -- Only lint on BufWritePost (save) and InsertLeave —
        -- removed BufEnter which was running pylint every time you switched buffers
        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        -- Manual trigger for full pylint check when you want deep analysis
        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Lint: Run linter on current file" })

        vim.keymap.set("n", "<leader>lp", function()
            -- Run pylint explicitly on demand — slow but thorough
            lint.try_lint({ "pylint" })
        end, { desc = "Lint: Run pylint (thorough)" })
    end,
}
