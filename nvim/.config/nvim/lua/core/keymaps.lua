-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Don't copy to clipboard on 'x' delete
vim.keymap.set('n', 'x', '"_x')

-- Move Line Up & Down
vim.keymap.set("n", "<C-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<C-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<C-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<C-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<C-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<C-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

vim.keymap.set("v", "p", '"_dP') -- Keep the yank, ie. copy paste won't lose current copy

-- the `zz` is to center results
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

-- keep search results centered
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- better indenting
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
