vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = false
vim.opt.guicursor =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- swapfile
opt.swapfile = false

-- ── Performance tweaks ────────────────────────────────────────────────────────
-- Default is 4000ms — way too slow for gitsigns, diagnostics, hover docs.
-- 250ms is the sweet spot: fast enough to feel snappy, not so fast it hammers
-- the LSP on every keystroke.
opt.updatetime = 250

-- Reduce mapped sequence wait time (default 1000ms).
-- Affects how long Neovim waits for the next key in a keymap sequence.
-- 300ms feels instant without breaking multi-key leader sequences.
opt.timeoutlen = 1000
