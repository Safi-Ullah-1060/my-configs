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
            -- The "console" element is dap-ui's own managed integrated terminal.
            -- It correctly handles buffer lifecycle (open/close/reopen) across sessions,
            -- unlike raw terminal_win_cmd which is subject to nvim-dap's buffer pooling.
            -- We put it in a bottom tray so it sits below the source + right sidebar.
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },

                layouts = {
                    {
                        position = "right",
                        size = 32,
                        elements = {
                            { id = "scopes", size = 0.30 },
                            { id = "watches", size = 0.25 },
                            { id = "stacks", size = 0.27 },
                            { id = "breakpoints", size = 0.18 },
                        },
                    },
                    {
                        position = "bottom",
                        size = 10,
                        elements = {
                            { id = "console", size = 1.0 },
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

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

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
            -- console = "integratedTerminal": cppdbg routes the inferior's I/O through
            -- the integrated terminal, which dap-ui's "console" element displays and
            -- manages. cin/cout work natively since it's a real PTY.
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

            -- Eval expression under cursor (n) or selected expression (v)
            map({ "n", "v" }, "<leader>dv", function()
                dapui.eval()
            end, { desc = "DAP: Eval expression" })
        end,
    },
}
