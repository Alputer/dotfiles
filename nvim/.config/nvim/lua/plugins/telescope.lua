return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    telescope.setup{
      defaults = {
        -- minimal default settings
        prompt_prefix = "> ",
        selection_caret = "> ",
        path_display = { "smart" },
      },
    }

    -- optional keymaps
    local map = vim.keymap.set
    map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
    map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
  end,
}

