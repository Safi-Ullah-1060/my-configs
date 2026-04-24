-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master", -- or branch = "0.1.x" if you prefer
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",            desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",             desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",               desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",             desc = "Help Tags" },
      -- LSP pickers (very useful)
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
      { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
    },
    config = function()
      local actions = require('telescope.actions')
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous", ["<c-d>"] = actions
            .delete_buffer, },
          },
          n = {
            ["<c-d>"] = actions.delete_buffer,
            ["dd"] = actions.delete_buffer,
          },
        },
      })

      -- Load fzf extension
      require("telescope").load_extension("fzf")
    end,
  },
}
