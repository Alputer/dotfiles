return {
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- or "tabs"
          separator_style = "thin", -- "slant", "padded_slant", "thick", etc.
          diagnostics = "nvim_lsp",
          show_close_icon = false,
          show_buffer_close_icons = true,
          always_show_bufferline = true,
        },
          highlights = require("catppuccin.special.bufferline").get_theme()
      })
    end,
  },
}
