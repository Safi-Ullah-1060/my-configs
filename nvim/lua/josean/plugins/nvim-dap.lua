return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- ─── Mason: auto-install adapters ─────────────────────────────────────────
            require("mason-nvim-dap").setup({
                ensure_installed = { "python", "cppdbg" },
                automatic_installation = true,
                handlers = {},
            })

            -- ─── DAP UI ───────────────────────────────────────────────────────────────
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },

                layouts = {
                    {
                        position = "right",
                        size = 40,
                        elements = {
                            { id = "scopes", size = 0.40 },
                            { id = "watches", size = 0.20 },
                            { id = "stacks", size = 0.25 },
                            { id = "breakpoints", size = 0.15 },
                        },
                    },
                },

                controls = {
                    enabled = true,
                    element = "stacks",
                },

                floating = {
                    max_height = 0.9,
                    max_width = 0.5,
                    border = "rounded",
                    mappings = { close = { "q", "<Esc>" } },
                },

                render = {
                    indent = 2,
                    max_value_lines = 6,
                },
            })

            -- ─── Clear nvim-dap terminal pool on session end ───────────────────────────
            -- nvim-dap caches the terminal buffer it opens for integratedTerminal.
            -- If that buffer gets :q'd, nvim-dap still thinks it's valid and won't call
            -- terminal_win_cmd again — so no terminal opens on the next session.
            -- Wiping the internal field on terminate/exit forces a fresh one every time.
            local function clear_terminal_pool()
                dap.defaults.fallback._terminal_buf = nil
            end

            dap.listeners.before.event_terminated.clear_term = clear_terminal_pool
            dap.listeners.before.event_exited.clear_term = clear_terminal_pool

            -- Catches the case where the user manually :q's the terminal mid-session
            vim.api.nvim_create_autocmd("TermClose", {
                callback = function(args)
                    if dap.defaults.fallback._terminal_buf == args.buf then
                        dap.defaults.fallback._terminal_buf = nil
                    end
                end,
                desc = "Clear nvim-dap terminal pool when I/O window is :q'd",
            })

            -- ─── Terminal window command ───────────────────────────────────────────────
            -- Used by cppdbg's integratedTerminal to open I/O.
            -- A plain string is used (not a function) — nvim-dap always creates a new
            -- split from a string command, avoiding the "requires unmodified buffer" error
            -- that happens when it tries to reuse a pooled buffer.
            dap.defaults.fallback.terminal_win_cmd = "belowright 12new"

            -- ─── cpptools adapter ─────────────────────────────────────────────────────
            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
            }

            -- ─── Build helper ─────────────────────────────────────────────────────────
            local function build_current_file()
                local src = vim.fn.expand("%:p")
                local dir = vim.fn.expand("%:p:h")
                local name = vim.fn.expand("%:t:r")
                local out = dir .. "/" .. name
                local ext = vim.fn.expand("%:e")
                local compiler

                if ext == "c" then
                    compiler = "gcc"
                elseif ext == "cpp" or ext == "cc" or ext == "cxx" then
                    compiler = "g++"
                else
                    vim.notify("[dap] Unsupported extension: ." .. ext, vim.log.levels.ERROR)
                    return nil
                end

                local cmd = string.format("%s -g -o %s %s", compiler, vim.fn.shellescape(out), vim.fn.shellescape(src))

                vim.notify("[dap] Building: " .. cmd, vim.log.levels.INFO)
                local output = vim.fn.system(cmd)
                if vim.v.shell_error ~= 0 then
                    vim.notify("[dap] Build FAILED:\n" .. output, vim.log.levels.ERROR)
                    return nil
                end

                vim.notify("[dap] Build OK → " .. out, vim.log.levels.INFO)
                return out
            end

            -- ─── C / C++ debug configurations ─────────────────────────────────────────
            -- console = "integratedTerminal": cppdbg sends a runInTerminal request to
            -- nvim-dap, which opens a real PTY terminal using terminal_win_cmd above.
            -- The process runs inside it so cin/cout work natively.
            dap.configurations.cpp = {
                {
                    name = "Build & Debug active file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        local bin = build_current_file()
                        if not bin then
                            error("Build failed — aborting debug session")
                        end
                        return bin
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtEntry = false,
                    MIMode = "gdb",
                    miDebuggerPath = vim.fn.exepath("gdb"),
                    setupCommands = {
                        {
                            text = "-enable-pretty-printing",
                            description = "enable GDB pretty printing",
                            ignoreFailures = false,
                        },
                    },
                    args = {},
                    console = "integratedTerminal",
                },
            }

            dap.configurations.c = dap.configurations.cpp

            -- ─── Python (debugpy) ─────────────────────────────────────────────────────
            require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

            -- ─── Keymaps ──────────────────────────────────────────────────────────────
            local map = vim.keymap.set

            map("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
            map("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "DAP: Conditional Breakpoint" })

            map("n", "<F5>", dap.continue, { desc = "DAP: Continue / Start" })
            map("n", "<F4>", dap.restart, { desc = "DAP: Restart" })
            map("n", "<F6>", dap.step_over, { desc = "DAP: Step Over" })
            map("n", "<F7>", dap.step_into, { desc = "DAP: Step Into" })
            map("n", "<F8>", dap.step_out, { desc = "DAP: Step Out" })
            map("n", "<F9>", dap.repl.open, { desc = "DAP: Open REPL" })
            map({ "n", "v" }, "<leader>dv", function()
                require("dapui").eval()
            end, { desc = "DAP: Eval under cursor" })

            map("n", "<leader>dx", function()
                dap.terminate()
                dapui.close()
            end, { desc = "DAP: Terminate & Close UI" })

            map("n", "<leader>dd", function()
                local ft = vim.bo.filetype
                if ft == "c" or ft == "cpp" then
                    dap.run(dap.configurations[ft][1])
                elseif ft == "python" then
                    dap.continue()
                else
                    vim.notify("[dap] No debug config for filetype: " .. ft, vim.log.levels.WARN)
                end
            end, { desc = "DAP: Build & Debug" })

            -- Build & Run without debugger
            map("n", "<leader>dr", function()
                local ft = vim.bo.filetype
                if ft ~= "c" and ft ~= "cpp" then
                    vim.notify("[dap] <leader>dr is for C/C++ only", vim.log.levels.WARN)
                    return
                end

                local bin = build_current_file()
                if not bin then
                    return
                end

                vim.cmd("belowright 12new")
                vim.fn.termopen(vim.fn.shellescape(bin))
                vim.cmd("startinsert")
            end, { desc = "DAP: Build & Run (no debug)" })

            map("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
        end,
    },
}
