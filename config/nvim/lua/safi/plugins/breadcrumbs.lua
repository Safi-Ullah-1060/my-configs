return {
  "LunarVim/breadcrumbs.nvim",
  dependencies = {
    { "SmiteshP/nvim-navic" },
  },
  config = function()
    require("nvim-navic").setup({
      lsp = { auto_attach = true },
    })
    require("breadcrumbs").setup()

    -- Patch breadcrumbs to exclude dap-view filetypes
    local breadcrumbs = require("breadcrumbs")
    local original_get_winbar = breadcrumbs.get_winbar
    breadcrumbs.get_winbar = function()
      local excluded = {
        ["dap-view"] = true,
        ["dap-view-term"] = true,
        ["dap-repl"] = true,
        ["dapui_watches"] = true,
        ["dapui_stacks"] = true,
        ["dapui_breakpoints"] = true,
        ["dapui_scopes"] = true,
        ["dapui_console"] = true,
        ["dapui_hover"] = true,
      }
      if excluded[vim.bo.filetype] then
        return ""
      end
      return original_get_winbar()
    end
  end
}
