-- ~/.config/nvim/lua/plugins/tmux_navigator.lua
return {
    'christoomey/vim-tmux-navigator',
    event = "VeryLazy",  -- load lazily
    config = function()
        -- Disable default mappings so we can use Alt + Arrow
        vim.g.tmux_navigator_no_mappings = 1

        -- Neovim mappings for Alt + Arrow keys
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap('n', '<A-Left>',  ':TmuxNavigateLeft<CR>',  opts)
        vim.api.nvim_set_keymap('n', '<A-Down>',  ':TmuxNavigateDown<CR>',  opts)
        vim.api.nvim_set_keymap('n', '<A-Up>',    ':TmuxNavigateUp<CR>',    opts)
        vim.api.nvim_set_keymap('n', '<A-Right>', ':TmuxNavigateRight<CR>', opts)
    end
}
