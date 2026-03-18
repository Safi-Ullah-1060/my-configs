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

            -- ─── Mason ────────────────────────────────────────────────────────────────
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

            -- ─── CMake helpers ────────────────────────────────────────────────────────

            -- Walk up from start_dir to find the directory containing CMakeLists.txt.
            -- Returns that directory path, or nil if not found within 10 levels.
            local function cmake_find_root(start_dir)
                local dir = start_dir
                for _ = 1, 10 do
                    if vim.fn.filereadable(dir .. "/CMakeLists.txt") == 1 then
                        return dir
                    end
                    local parent = vim.fn.fnamemodify(dir, ":h")
                    if parent == dir then
                        break
                    end
                    dir = parent
                end
                return nil
            end

            -- CMake names the binary after this, so we know where to find it.

            -- Parse the project() name from CMakeLists.txt.
            -- local function cmake_get_project_name(root)
            --     for _, line in ipairs(vim.fn.readfile(root .. "/CMakeLists.txt")) do
            --         local name = line:match("^%s*project%s*%((%S+)")
            --         if name then
            --             return name
            --         end
            --     end
            --     return nil
            -- end

            -- Parse the add_executable() name from CMakeLists.txt.
            local function cmake_get_exe_name(root)
                for _, line in ipairs(vim.fn.readfile(root .. "/CMakeLists.txt")) do
                    local name = line:match("add_executable%s*%(%s*(%S+)")
                    if name then
                        return name
                    end
                end
                return nil
            end

            -- Configure + build via CMake.
            -- build_type = "Debug" | "Release"
            -- Creates build/debug or build/release to keep them separate.
            -- Returns binary path on success, nil on failure.
            local function cmake_build(root, build_type)
                build_type = build_type or "Debug"
                -- Separate dirs for Debug and Release so switching doesn't force a full reconfigure
                local build_dir = root .. "/build/" .. build_type:lower()

                if vim.fn.isdirectory(build_dir) == 0 then
                    vim.fn.mkdir(build_dir, "p")
                    vim.notify("[cmake] Created: " .. build_dir, vim.log.levels.INFO)
                end

                -- Configure
                vim.notify("[cmake] Configuring (" .. build_type .. ")...", vim.log.levels.INFO)
                local cfg_out = vim.fn.system(
                    string.format(
                        "cmake -S %s -B %s -DCMAKE_BUILD_TYPE=%s",
                        vim.fn.shellescape(root),
                        vim.fn.shellescape(build_dir),
                        build_type
                    )
                )
                if vim.v.shell_error ~= 0 then
                    vim.notify("[cmake] Configure FAILED:\n" .. cfg_out, vim.log.levels.ERROR)
                    return nil
                end

                -- Build
                vim.notify("[cmake] Building...", vim.log.levels.INFO)
                local build_out = vim.fn.system(string.format("cmake --build %s", vim.fn.shellescape(build_dir)))
                if vim.v.shell_error ~= 0 then
                    vim.notify("[cmake] Build FAILED:\n" .. build_out, vim.log.levels.ERROR)
                    return nil
                end

                local exe = cmake_get_exe_name(root)
                if not exe then
                    vim.notify("[cmake] Could not parse executable name from CMakeLists.txt", vim.log.levels.ERROR)
                    return nil
                end
                local binary = build_dir .. "/" .. exe

                if vim.fn.executable(binary) == 0 then
                    vim.notify("[cmake] Binary not found: " .. binary, vim.log.levels.ERROR)
                    return nil
                end

                vim.notify("[cmake] OK → " .. binary, vim.log.levels.INFO)
                return binary
            end

            -- ─── Single-file fallback build ───────────────────────────────────────────
            local function singlefile_build(src, dir, name, ext)
                local compiler
                if ext == "c" then
                    compiler = "gcc"
                elseif ext == "cpp" or ext == "cc" or ext == "cxx" then
                    compiler = "g++"
                else
                    vim.notify("[dap] Unsupported extension: ." .. ext, vim.log.levels.ERROR)
                    return nil
                end

                local out = dir .. "/" .. name
                local output = vim.fn.system(
                    string.format("%s -g -o %s %s", compiler, vim.fn.shellescape(out), vim.fn.shellescape(src))
                )
                if vim.v.shell_error ~= 0 then
                    vim.notify("[dap] Build FAILED:\n" .. output, vim.log.levels.ERROR)
                    return nil
                end

                vim.notify("[dap] Build OK → " .. out, vim.log.levels.INFO)
                return out
            end

            -- ─── Unified build entry point ────────────────────────────────────────────
            -- build_type = "Debug" (default) | "Release"
            -- Returns binary path or nil.
            local function build(build_type)
                local src = vim.fn.expand("%:p")
                local dir = vim.fn.expand("%:p:h")
                local name = vim.fn.expand("%:t:r")
                local ext = vim.fn.expand("%:e")

                local cmake_root = cmake_find_root(dir)
                if cmake_root then
                    vim.notify("[cmake] Root: " .. cmake_root, vim.log.levels.INFO)
                    return cmake_build(cmake_root, build_type or "Debug")
                end

                -- No CMakeLists.txt — single file compile (always debug flags)
                return singlefile_build(src, dir, name, ext)
            end

            -- ─── C / C++ DAP configurations ───────────────────────────────────────────
            dap.configurations.cpp = {
                {
                    name = "Build & Debug active file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        local bin = build("Debug")
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

            -- ─── Python ───────────────────────────────────────────────────────────────
            require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

            -- ─── Run terminal (reused across <leader>dr calls) ────────────────────────
            local dr_term_buf = nil
            local dr_term_win = nil

            local function run_in_term(cmd)
                -- Invalidate stale state
                if dr_term_buf and not vim.api.nvim_buf_is_valid(dr_term_buf) then
                    dr_term_buf = nil
                    dr_term_win = nil
                end

                if dr_term_win and vim.api.nvim_win_is_valid(dr_term_win) then
                    -- Reuse existing window — wipe buffer and rerun
                    vim.api.nvim_set_current_win(dr_term_win)
                    vim.cmd("enew")
                    dr_term_buf = vim.api.nvim_get_current_buf()
                else
                    -- Find source window so split stays in the left column only
                    local src_win = nil
                    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
                        if not ft:match("^dap") and ft ~= "terminal" then
                            src_win = win
                            break
                        end
                    end
                    if src_win then
                        vim.api.nvim_set_current_win(src_win)
                    end
                    vim.cmd("rightbelow 10new")
                    dr_term_buf = vim.api.nvim_get_current_buf()
                    dr_term_win = vim.api.nvim_get_current_win()
                end

                vim.fn.termopen(cmd)
                vim.cmd("startinsert")
            end

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

            -- <leader>dd — Build (Debug) then start DAP session
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

            -- <leader>db — Build for Release (no debugger, just compile)
            map("n", "<leader>db", function()
                local ft = vim.bo.filetype
                local ext = vim.fn.expand("%:e")
                if ft == "c" or ft == "cpp" or ext == "c" or ext == "cpp" or ext == "cc" or ext == "cxx" then
                    local bin = build("Release")
                    if bin then
                        vim.notify("[dap] Release binary: " .. bin, vim.log.levels.INFO)
                    end
                else
                    vim.notify("[dap] <leader>db is for C/C++ only", vim.log.levels.WARN)
                end
            end, { desc = "DAP: Build Release" })

            -- <leader>dr — Build (Debug) then run in terminal (no debugger)
            map("n", "<leader>dr", function()
                local ft = vim.bo.filetype
                local src = vim.fn.expand("%:p")
                local ext = vim.fn.expand("%:e")

                if ft == "python" then
                    run_in_term("python3 " .. vim.fn.shellescape(src))
                elseif ft == "c" or ft == "cpp" or ext == "c" or ext == "cpp" or ext == "cc" or ext == "cxx" then
                    local bin = build("Debug")
                    if not bin then
                        return
                    end
                    run_in_term(vim.fn.shellescape(bin))
                else
                    vim.notify("[dap] <leader>dr: no run config for filetype: " .. ft, vim.log.levels.WARN)
                end
            end, { desc = "DAP: Build & Run (no debug)" })

            map("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })

            map({ "n", "v" }, "<leader>dv", function()
                dapui.eval()
            end, { desc = "DAP: Eval expression" })
        end,
    },
}
