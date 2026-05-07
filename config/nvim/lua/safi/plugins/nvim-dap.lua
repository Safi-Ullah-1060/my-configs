return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dd", desc = "DAP: Build & Debug" },
      { "<leader>dr", desc = "DAP: Build & Run" },
      { "<leader>db", desc = "DAP: Build Release" },
      { "<leader>dx", desc = "DAP: Terminate" },
      { "<leader>du", desc = "DAP: Toggle UI" },
      { "<leader>dv", desc = "DAP: Eval expression" },
      { "<leader>b",  desc = "DAP: Toggle Breakpoint" },
      { "<leader>B",  desc = "DAP: Conditional Breakpoint" },
      { "<F5>",       desc = "DAP: Continue" },
      { "<F4>",       desc = "DAP: Restart" },
      { "<F6>",       desc = "DAP: Step Over" },
      { "<F7>",       desc = "DAP: Step Into" },
      { "<F8>",       desc = "DAP: Step Out" },
      { "<F9>",       desc = "DAP: Open REPL" },
    },
    dependencies = {
      "igorlfs/nvim-dap-view",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap     = require("dap")
      local dapview = require("dap-view")

      require("mason-nvim-dap").setup({
        ensure_installed       = { "python", "cppdbg" },
        automatic_installation = true,
        handlers               = {},
      })

      local term_win, term_buf = nil, nil

      local function find_editor_win()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local b  = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value("filetype", { buf = b })
          local bt = vim.api.nvim_get_option_value("buftype", { buf = b })
          if not ft:match("^dap") and bt ~= "terminal" then return win end
        end
      end

      local function open_term_split()
        local src = find_editor_win()
        if src then vim.api.nvim_set_current_win(src) end
        vim.cmd("rightbelow " .. math.floor(vim.api.nvim_win_get_height(src or 0) * 0.35) .. "new")
        term_win = vim.api.nvim_get_current_win()
        term_buf = vim.api.nvim_get_current_buf()
        return term_buf, term_win
      end

      dap.defaults.fallback.terminal_win_cmd = open_term_split

      dapview.setup({
        winbar      = {
          show              = true,
          sections          = { "scopes", "watches", "repl", "threads", "breakpoints", "exceptions" },
          default_section   = "scopes",
          show_keymap_hints = false,
          controls          = {
            enabled  = true,
            position = "right",
            buttons  = { "play", "step_into", "step_over", "step_out", "run_last", "terminate" },
          },
          base_sections     = {
            -- Labels can be set dynamically with functions
            -- Each function receives the window's width and the current section as arguments
            breakpoints = { label = "[B]", keymap = "B" },
            scopes = { label = "[S]", keymap = "S" },
            exceptions = { label = "[E]", keymap = "E" },
            watches = { label = "[W]", keymap = "W" },
            threads = { label = "[T]", keymap = "T" },
            repl = { label = "[R]", keymap = "R" },
            sessions = { label = "Sessions", keymap = "K" },
            console = { label = "Console", keymap = "C" },
          },
        },
        windows     = { size = 0.35, position = "right", terminal = { hide = { "cppdbg", "debugpy" } } },
        auto_toggle = false,
      })

      dap.listeners.before.attach.dapview_config = function() dapview.open() end
      dap.listeners.before.launch.dapview_config = function() dapview.open() end

      local function on_session_end()
        dapview.close()
        term_buf, term_win = nil, nil
      end
      dap.listeners.before.event_terminated.dapview_config = on_session_end
      dap.listeners.before.event_exited.dapview_config     = on_session_end

      dap.adapters.cppdbg                                  = {
        id      = "cppdbg",
        type    = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
      }

      local function cmake_find_root(dir)
        if vim.fn.filereadable(dir .. "/CMakeLists.txt") == 1 then return dir end
      end

      local function cmake_get_exe(root)
        for _, line in ipairs(vim.fn.readfile(root .. "/CMakeLists.txt")) do
          local n = line:match("add_executable%s*%(%s*(%S+)")
          if n then return n end
        end
      end

      local function cmake_build(root, build_type)
        local bdir = root .. "/build/" .. build_type:lower()
        if vim.fn.isdirectory(bdir) == 0 then vim.fn.mkdir(bdir, "p") end

        local cfg = vim.fn.system(string.format(
          "cmake -S %s -B %s -DCMAKE_BUILD_TYPE=%s",
          vim.fn.shellescape(root), vim.fn.shellescape(bdir), build_type))
        if vim.v.shell_error ~= 0 then
          vim.notify("[cmake] Configure FAILED:\n" .. cfg, vim.log.levels.ERROR); return nil
        end

        local bld = vim.fn.system("cmake --build " .. vim.fn.shellescape(bdir))
        if vim.v.shell_error ~= 0 then
          vim.notify("[cmake] Build FAILED:\n" .. bld, vim.log.levels.ERROR); return nil
        end

        local exe = cmake_get_exe(root)
        if not exe then
          vim.notify("[cmake] Cannot parse exe name", vim.log.levels.ERROR); return nil
        end

        local bin = bdir .. "/" .. exe
        if vim.fn.executable(bin) == 0 then
          vim.notify("[cmake] Binary not found: " .. bin, vim.log.levels.ERROR); return nil
        end
        return bin
      end

      local function singlefile_build(src, dir, name, ext)
        local cc = ({ c = "gcc", cpp = "g++", cc = "g++", cxx = "g++" })[ext]
        if not cc then
          vim.notify("[dap] Unsupported: ." .. ext, vim.log.levels.ERROR); return nil
        end
        local out = dir .. "/" .. name
        local res = vim.fn.system(string.format("%s -g -o %s %s", cc, vim.fn.shellescape(out), vim.fn.shellescape(src)))
        if vim.v.shell_error ~= 0 then
          vim.notify("[dap] Build FAILED:\n" .. res, vim.log.levels.ERROR); return nil
        end
        return out
      end

      local function build(build_type)
        local src, dir = vim.fn.expand("%:p"), vim.fn.expand("%:p:h")
        local root = cmake_find_root(dir)
        if root then return cmake_build(root, build_type or "Debug") end
        return singlefile_build(src, dir, vim.fn.expand("%:t:r"), vim.fn.expand("%:e"))
      end

      dap.configurations.cpp = {
        {
          name           = "Build & Debug active file",
          type           = "cppdbg",
          request        = "launch",
          program        = function()
            local bin = build("Debug")
            if not bin then error("Build failed") end
            return bin
          end,
          cwd            = "${workspaceFolder}",
          stopAtEntry    = false,
          MIMode         = "gdb",
          miDebuggerPath = vim.fn.exepath("gdb"),
          setupCommands  = { { text = "-enable-pretty-printing", ignoreFailures = false } },
          args           = {},
          console        = "integratedTerminal",
        },
      }
      dap.configurations.c = dap.configurations.cpp

      require("dap-python").setup(
        vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

      local function run_in_term(cmd)
        local win = (term_win and vim.api.nvim_win_is_valid(term_win)) and term_win or select(2, open_term_split())
        vim.api.nvim_set_current_win(win)
        vim.fn.termopen(cmd)
        vim.cmd("startinsert")
      end

      local map = vim.keymap.set

      map("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
      map("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end,
        { desc = "DAP: Conditional Breakpoint" })
      map("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
      map("n", "<F4>", dap.restart, { desc = "DAP: Restart" })
      map("n", "<F6>", dap.step_over, { desc = "DAP: Step Over" })
      map("n", "<F7>", dap.step_into, { desc = "DAP: Step Into" })
      map("n", "<F8>", dap.step_out, { desc = "DAP: Step Out" })
      map("n", "<F9>", dap.repl.open, { desc = "DAP: Open REPL" })

      map("n", "<leader>dx", function()
        dap.terminate(); dapview.close()
      end, { desc = "DAP: Terminate" })

      map("n", "<leader>dd", function()
        local ft = vim.bo.filetype
        if ft == "c" or ft == "cpp" then
          dap.run(dap.configurations[ft][1])
        elseif ft == "python" then
          dap.continue()
        else
          vim.notify("[dap] No config for: " .. ft, vim.log.levels.WARN)
        end
      end, { desc = "DAP: Build & Debug" })

      map("n", "<leader>db", function()
        local ft, ext = vim.bo.filetype, vim.fn.expand("%:e")
        if ft == "c" or ft == "cpp" or ext == "c" or ext == "cpp" or ext == "cc" or ext == "cxx" then
          local bin = build("Release")
          if bin then vim.notify("[dap] Release: " .. bin, vim.log.levels.INFO) end
        else
          vim.notify("[dap] C/C++ only", vim.log.levels.WARN)
        end
      end, { desc = "DAP: Build Release" })

      map("n", "<leader>dr", function()
        local ft, src, ext = vim.bo.filetype, vim.fn.expand("%:p"), vim.fn.expand("%:e")
        if ft == "python" then
          run_in_term("python3 " .. vim.fn.shellescape(src))
        elseif ft == "c" or ft == "cpp" or ext == "c" or ext == "cpp" or ext == "cc" or ext == "cxx" then
          local bin = build("Debug")
          if bin then run_in_term(vim.fn.shellescape(bin)) end
        else
          vim.notify("[dap] No run config for: " .. ft, vim.log.levels.WARN)
        end
      end, { desc = "DAP: Build & Run" })

      map("n", "<leader>du", function()
        dapview.toggle()
        if term_win and vim.api.nvim_win_is_valid(term_win) then
          vim.api.nvim_win_close(term_win, true)
        elseif term_buf and vim.api.nvim_buf_is_valid(term_buf) then
          local src = find_editor_win()
          if src then vim.api.nvim_set_current_win(src) end
          vim.cmd("rightbelow " .. math.floor(vim.api.nvim_win_get_height(src or 0) * 0.35) .. "new")
          term_win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(term_win, term_buf)
        end
      end, { desc = "DAP: Toggle UI" })

      map({ "n", "v" }, "<leader>dv", dapview.hover, { desc = "DAP: Eval expression" })
    end,
  },
}
