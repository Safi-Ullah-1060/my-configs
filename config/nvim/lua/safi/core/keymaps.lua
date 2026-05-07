-- ─────────────────────────────────────────────────────────────────────────────
-- keymaps.lua — all keymaps in one place
--
-- Keymaps that require a plugin to be loaded are NOT here — they live in their
-- plugin's config function so the plugin is guaranteed loaded when they fire.
-- Those are listed in the reference section at the bottom as comments.
-- ─────────────────────────────────────────────────────────────────────────────

vim.g.mapleader = " "

local map = vim.keymap.set

-- ─── General ──────────────────────────────────────────────────────────────────
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
map("n", "<leader>=", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
map({ "n", "v" }, "<A-s>", ":w<CR>", { desc = "Write Buffer" })

-- ─── Window management ────────────────────────────────────────────────────────
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equal split sizes" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- ─── Tab management ───────────────────────────────────────────────────────────
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>]", "<cmd>tabn<CR>", { desc = "Next tab" })
map("n", "<leader>[", "<cmd>tabp<CR>", { desc = "Prev tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open buffer in new tab" })

-- Jump to tab 1, 2, etc. with Alt + number
for i = 1, 9 do
  vim.keymap.set('n', '<A-' .. i .. '>', i .. 'gt', { noremap = true })
end

-- ─── Clipboard ────────────────────────────────────────────────────────────────
-- map("n", "<leader>y", '"+y',  { desc = "Yank to clipboard" })
-- map("v", "<leader>y", '"+y',  { desc = "Yank to clipboard" })
-- map("n", "<leader>Y", '"+Y',  { desc = "Yank line to clipboard" })

-- ─────────────────────────────────────────────────────────────────────────────
-- PLUGIN KEYMAPS REFERENCE
-- These are defined inside each plugin's config function, not here.
-- Listed for quick reference — use this file as your cheatsheet.
-- ─────────────────────────────────────────────────────────────────────────────

-- ── File Explorer (nvim-tree) ─────────────────────────────────────────────────
-- <leader>ee   Toggle file explorer
-- <leader>ef   Toggle file explorer on current file
-- <leader>ec   Collapse file explorer
-- <leader>er   Refresh file explorer

-- ── Fuzzy Finder (telescope) ──────────────────────────────────────────────────
-- <leader>ff   Find files
-- <leader>fg   Live grep
-- <leader>fb   Buffers
-- <leader>fh   Help tags
-- <leader>fs   LSP document symbols
-- <leader>fw   LSP workspace symbols
-- (in picker)
-- <C-j>        Next item
-- <C-k>        Prev item

-- ── DAP: Debugger ─────────────────────────────────────────────────────────────
-- <leader>dd   Build & Debug (C/C++/Python)
-- <leader>dr   Build & Run without debugger
-- <leader>db   Build Release (C/C++ only)
-- <leader>dx   Terminate session & close UI
-- <leader>du   Toggle DAP UI
-- <leader>dv   Eval expression under cursor / selection
-- <leader>b    Toggle breakpoint
-- <leader>B    Conditional breakpoint
-- <F4>         Restart
-- <F5>         Continue / Start
-- <F6>         Step over
-- <F7>         Step into
-- <F8>         Step out
-- <F9>         Open REPL
-- (in watches panel)
-- a            Add watch expression
-- d            Delete watch expression
-- e            Edit watch expression

-- ── LSP ───────────────────────────────────────────────────────────────────────
-- (defined in lspconfig on_attach, active in LSP buffers only)
-- gR           Show references
-- gD           Go to declaration
-- gd           Go to definition (peek)
-- gi           Go to implementation
-- gt           Go to type definition
-- K            Hover docs
-- <leader>ca   Code action
-- <leader>rn   Rename symbol
-- <leader>D    Show line diagnostics
-- <leader>d    Prev diagnostic
-- ]d           Next diagnostic
-- [d           Prev diagnostic
-- <leader>rs   Restart LSP

-- ── Snippets / Completion ─────────────────────────────────────────────────────
-- <Tab>        Expand snippet / jump forward / next cmp item
-- <S-Tab>      Jump backward / prev cmp item
-- <C-k>        Prev cmp suggestion
-- <C-j>        Next cmp suggestion
-- <C-b>        Scroll docs up
-- <C-f>        Scroll docs down
-- <C-Space>    Trigger completion
-- <C-e>        Abort completion
-- <CR>         Confirm completion

-- ── Formatting (conform) ──────────────────────────────────────────────────────
-- <leader>mp   Format file or visual selection
-- (auto-formats on :w for all configured filetypes)

-- ── Linting (nvim-lint) ───────────────────────────────────────────────────────
-- <leader>l    Trigger lint on current file

-- ── Git (gitsigns) ───────────────────────────────────────────────────────────
-- ]h           Next hunk
-- [h           Prev hunk
-- <leader>hs   Stage hunk
-- <leader>hr   Reset hunk
-- <leader>hS   Stage buffer
-- <leader>hR   Reset buffer
-- <leader>hu   Undo stage hunk
-- <leader>hp   Preview hunk
-- <leader>hb   Blame line (full)
-- <leader>hB   Toggle line blame
-- <leader>hd   Diff this
-- <leader>hD   Diff this ~
-- ih           (text obj) select hunk

-- ── Git UI (lazygit) ──────────────────────────────────────────────────────────
-- <leader>lg   Open LazyGit

-- ── Diagnostics (trouble) ─────────────────────────────────────────────────────
-- <leader>xw   Workspace diagnostics
-- <leader>xd   Document diagnostics
-- <leader>xq   Quickfix list
-- <leader>xl   Location list
-- <leader>xt   Todo list

-- ── TODO comments ─────────────────────────────────────────────────────────────
-- ]t           Next TODO comment
-- [t           Prev TODO comment

-- ── Substitute ────────────────────────────────────────────────────────────────
-- <leader>r    Substitute with motion
-- <leader>rr   Substitute line
-- <leader>R    Substitute to end of line
-- <leader>r    (visual) Substitute selection

-- ── Maximizer ─────────────────────────────────────────────────────────────────
-- <leader>sm   Toggle maximise current split

-- ── Session (auto-session) ────────────────────────────────────────────────────
-- <leader>wr   Restore session for cwd
-- <leader>ws   Save session for cwd

-- ── Folding (nvim-ufo) ────────────────────────────────────────────────────────
-- <Tab>        Toggle fold under cursor
-- <zR>         Open all folds
-- <zM>         Close all folds
-- <zK>         Peek fold (or hover docs)

-- ── Markdown (render-markdown) ────────────────────────────────────────────────
-- <leader>mt   Toggle markdown rendering
-- <leader>me   Expand all headings
-- <leader>mc   Collapse all headings

-- ── Treesitter text objects ───────────────────────────────────────────────────
-- (select)
-- a=  outer assignment    i=  inner assignment
-- l=  lhs assignment      r=  rhs assignment
-- aa  outer argument      ia  inner argument
-- ai  outer conditional   ii  inner conditional
-- al  outer loop          il  inner loop
-- af  outer function call if  inner function call
-- am  outer method/func   im  inner method/func
-- ac  outer class         ic  inner class
-- (swap)
-- <leader>na   Swap param with next      <leader>pa  Swap param with prev
-- <leader>nm   Swap function with next   <leader>pm  Swap function with prev
-- (move)
-- ]f  Next function call    [f  Prev function call
-- ]m  Next method start     [m  Prev method start
-- ]c  Next class start      [c  Prev class start
-- ]i  Next conditional      [i  Prev conditional
-- ]l  Next loop             [l  Prev loop
-- ;   Repeat last move      ,   Repeat last move (opposite)
