local opt = vim.opt

-- Clipboard & mouse
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 4 -- How many space is visible for single tab character
opt.softtabstop = 4 -- Pressing Tab inserts 4 spaces
opt.shiftwidth = 4 -- Pressing Shift width inserts 4 spaces
opt.expandtab = true -- space instead of tab
opt.autoindent  = true -- automatic indentation
opt.smartindent = true

-- Search (Case-insensitive searching UNLESS \C or one or more capital letters in the search term)
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Scrolling
opt.wrap = false
opt.scrolloff = 5
opt.sidescrolloff = 5

-- Splits behavior (Already works like that but extra config does not hurt)
opt.splitright = true
opt.splitbelow = true

-- updatetime doesn't affect typing speed at all — it only triggers background
-- events like CursorHold, which is what many LSP and git plugins hook into.
-- 250ms is a sweet spot.
opt.updatetime = 250
opt.timeoutlen = 500 -- For leader key

-- UI
opt.termguicolors = true
opt.signcolumn = "yes" --Show signcolumn even if no sign exists
opt.cursorline = true
opt.showmode = false
opt.colorcolumn = "80" -- highlight column, opt.textwidth inserts

-- Persist undo history to disk so you can undo after closing and reopening a file
opt.undofile = true
opt.undodir = ".local/state/nvim/undo"
opt.swapfile = false -- Don't create swap files (modern file systems + git make them unnecessary)
opt.backup = false

-- Display tabs, trailing spaces and non-breakable space characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- When tab-completing in command mode, show all matches in a menu
-- instead of cycling through them blindly
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
opt.confirm = true
