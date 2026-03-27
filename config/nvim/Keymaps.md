# Neovim Keymaps Cheatsheet

> Plugin-specific keymaps are defined inside each plugin's config. This file is the single reference for all keymaps.

---

## General

| Key          | Mode   | Description             |
| ------------ | ------ | ----------------------- |
| `jk`         | Insert | Exit insert mode        |
| `<leader>nh` | Normal | Clear search highlights |
| `<leader>+`  | Normal | Increment number        |
| `<leader>-`  | Normal | Decrement number        |

---

## Window Management

| Key          | Description                   |
| ------------ | ----------------------------- |
| `<leader>sv` | Split vertically              |
| `<leader>sh` | Split horizontally            |
| `<leader>se` | Equal split sizes             |
| `<leader>sx` | Close current split           |
| `<leader>sm` | Toggle maximise current split |

---

## Tab Management

| Key          | Description            |
| ------------ | ---------------------- |
| `<leader>to` | New tab                |
| `<leader>tx` | Close tab              |
| `<leader>tn` | Next tab               |
| `<leader>tp` | Prev tab               |
| `<leader>tf` | Open buffer in new tab |

---

## File Explorer (`nvim-tree`)

| Key          | Description                          |
| ------------ | ------------------------------------ |
| `<leader>ee` | Toggle file explorer                 |
| `<leader>ef` | Toggle file explorer on current file |
| `<leader>ec` | Collapse file explorer               |
| `<leader>er` | Refresh file explorer                |

---

## Fuzzy Finder (`telescope`)

| Key                | Description           |
| ------------------ | --------------------- |
| `<leader>ff`       | Find files            |
| `<leader>fg`       | Live grep             |
| `<leader>fb`       | Buffers               |
| `<leader>fh`       | Help tags             |
| `<leader>fs`       | LSP document symbols  |
| `<leader>fw`       | LSP workspace symbols |
| `<C-j>` *(picker)* | Next item             |
| `<C-k>` *(picker)* | Prev item             |

---

## Debugger (`nvim-dap`)

| Key          | Description                              |
| ------------ | ---------------------------------------- |
| `<leader>dd` | Build & Debug (C/C++/Python)             |
| `<leader>dr` | Build & Run without debugger             |
| `<leader>db` | Build Release (C/C++ only)               |
| `<leader>dx` | Terminate session & close UI             |
| `<leader>du` | Toggle DAP UI                            |
| `<leader>dv` | Eval expression under cursor / selection |
| `<leader>b`  | Toggle breakpoint                        |
| `<leader>B`  | Conditional breakpoint                   |
| `<F4>`       | Restart                                  |
| `<F5>`       | Continue / Start                         |
| `<F6>`       | Step over                                |
| `<F7>`       | Step into                                |
| `<F8>`       | Step out                                 |
| `<F9>`       | Open REPL                                |

### Watches Panel

| Key | Description             |
| --- | ----------------------- |
| `a` | Add watch expression    |
| `d` | Delete watch expression |
| `e` | Edit watch expression   |

---

## LSP

> Active in LSP buffers only.

| Key          | Description             |
| ------------ | ----------------------- |
| `gR`         | Show references         |
| `gD`         | Go to declaration       |
| `gd`         | Go to definition (peek) |
| `gi`         | Go to implementation    |
| `gt`         | Go to type definition   |
| `K`          | Hover docs              |
| `<leader>ca` | Code action             |
| `<leader>rn` | Rename symbol           |
| `<leader>D`  | Show line diagnostics   |
| `<leader>d`  | Prev diagnostic         |
| `]d`         | Next diagnostic         |
| `[d`         | Prev diagnostic         |
| `<leader>rs` | Restart LSP             |

---

## Snippets & Completion

| Key         | Description                                   |
| ----------- | --------------------------------------------- |
| `<Tab>`     | Expand snippet / jump forward / next cmp item |
| `<S-Tab>`   | Jump backward / prev cmp item                 |
| `<C-k>`     | Prev cmp suggestion                           |
| `<C-j>`     | Next cmp suggestion                           |
| `<C-b>`     | Scroll docs up                                |
| `<C-f>`     | Scroll docs down                              |
| `<C-Space>` | Trigger completion                            |
| `<C-e>`     | Abort completion                              |
| `<CR>`      | Confirm completion                            |

---

## Formatting & Linting

| Key          | Description                     |
| ------------ | ------------------------------- |
| `<leader>mp` | Format file or visual selection |
| `<leader>l`  | Trigger lint on current file    |

> Auto-formats on `:w` for all configured filetypes.

---

## Git (`gitsigns`)

| Key          | Description              |
| ------------ | ------------------------ |
| `]h`         | Next hunk                |
| `[h`         | Prev hunk                |
| `<leader>hs` | Stage hunk               |
| `<leader>hr` | Reset hunk               |
| `<leader>hS` | Stage buffer             |
| `<leader>hR` | Reset buffer             |
| `<leader>hu` | Undo stage hunk          |
| `<leader>hp` | Preview hunk             |
| `<leader>hb` | Blame line (full)        |
| `<leader>hB` | Toggle line blame        |
| `<leader>hd` | Diff this                |
| `<leader>hD` | Diff this ~              |
| `ih`         | *(text obj)* Select hunk |
| `<leader>lg` | Open LazyGit             |

---

## Diagnostics (`trouble`)

| Key          | Description           |
| ------------ | --------------------- |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics  |
| `<leader>xq` | Quickfix list         |
| `<leader>xl` | Location list         |
| `<leader>xt` | Todo list             |
| `]t`         | Next TODO comment     |
| `[t`         | Prev TODO comment     |

---

## Substitute

| Key          | Mode   | Description               |
| ------------ | ------ | ------------------------- |
| `<leader>r`  | Normal | Substitute with motion    |
| `<leader>rr` | Normal | Substitute line           |
| `<leader>R`  | Normal | Substitute to end of line |
| `<leader>r`  | Visual | Substitute selection      |

---

## Session (`auto-session`)

| Key          | Description             |
| ------------ | ----------------------- |
| `<leader>wr` | Restore session for cwd |
| `<leader>ws` | Save session for cwd    |

---

## Folding (`nvim-ufo`)

| Key     | Description               |
| ------- | ------------------------- |
| `<Tab>` | Toggle fold under cursor  |
| `zR`    | Open all folds            |
| `zM`    | Close all folds           |
| `zK`    | Peek fold (or hover docs) |

---

## Markdown (`render-markdown`)

| Key          | Description               |
| ------------ | ------------------------- |
| `<leader>mt` | Toggle markdown rendering |
| `<leader>me` | Expand all headings       |
| `<leader>mc` | Collapse all headings     |

---

## Treesitter Text Objects

### Select

| Key         | Description                 |
| ----------- | --------------------------- |
| `a=` / `i=` | Outer / inner assignment    |
| `l=` / `r=` | LHS / RHS assignment        |
| `aa` / `ia` | Outer / inner argument      |
| `ai` / `ii` | Outer / inner conditional   |
| `al` / `il` | Outer / inner loop          |
| `af` / `if` | Outer / inner function call |
| `am` / `im` | Outer / inner method/func   |
| `ac` / `ic` | Outer / inner class         |

### Swap

| Key          | Description             |
| ------------ | ----------------------- |
| `<leader>na` | Swap param with next    |
| `<leader>pa` | Swap param with prev    |
| `<leader>nm` | Swap function with next |
| `<leader>pm` | Swap function with prev |

### Move

| Key         | Description                 |
| ----------- | --------------------------- |
| `]f` / `[f` | Next / prev function call   |
| `]m` / `[m` | Next / prev method start    |
| `]c` / `[c` | Next / prev class start     |
| `]i` / `[i` | Next / prev conditional     |
| `]l` / `[l` | Next / prev loop            |
| `;`         | Repeat last move            |
| `,`         | Repeat last move (opposite) |
