return
{
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
      git = {
        enable = false, -- disable git integration
      },
    })

    -- keymaps with descriptions
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {
      silent = true,
      desc = "Toggle file explorer",
    })

    vim.keymap.set("n", "<leader>f", ":NvimTreeFocus<CR>", {
      silent = true,
      desc = "Focus file explorer",
    })
  end,
}
