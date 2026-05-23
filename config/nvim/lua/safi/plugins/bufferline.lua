return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  config = function()
    local bufferline = require("bufferline")

    bufferline.setup({
      highlights = {
        -- The underline on the active tab —
        -- sp = the color of the underline itself
        -- kanagawa-dragon's accent color is roninYellow (#ff9e3b)
        buffer_selected = {
          bold      = true,
          italic    = false,
          underline = true,
          sp        = "#f0f0f0", -- roninYellow from kanagawa-dragon
        },
        indicator_selected = {
          fg        = "#f0f0f0",
          underline = true,
          sp        = "#f0f0f0",
        },
      },
      options = {
        mode            = "tabs",
        indicator       = { style = "underline" },
        separator_style = { ' ', ' ' },
        style_preset    = bufferline.style_preset.no_italic,
        offsets         = { -- fixed typo: was "offests"
          {
            filetype   = "NvimTree",
            text       = "File Explorer",
            text_align = "left",
            highlight  = "Directory",
            separator  = false,
          },
        },
      },
    })
  end,
}
