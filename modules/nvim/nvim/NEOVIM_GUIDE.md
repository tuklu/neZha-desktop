# Neovim Learning Guide

A practical reference for learning this setup gradually. Neovim is modal: most movement and editing happens in Normal mode, while Insert mode is for entering text. Press `Esc` to return to Normal mode. In this config, `jk` also exits Insert mode.

## Start here

Run `:Tutor` inside Neovim for the built-in interactive introduction. Learn a few motions at a time and use them while editing real code. The most useful habit is to describe an edit as an action plus a destination: delete to the end of the line, change inside these quotes, or copy this paragraph.

## Move around

### Within a line

| Keys | Destination |
| --- | --- |
| `0` | First character in the line |
| `^` | First nonblank character |
| `$` | Last character |
| `g_` | Last nonblank character |
| `I` | Insert at the first nonblank character |
| `A` | Insert after the last character |

### Words and code

| Keys | Motion |
| --- | --- |
| `w`, `b`, `e` | Next word, previous word, end of word |
| `W`, `B`, `E` | Same motions, treating whitespace-separated text as words |
| `f{char}` / `F{char}` | Find a character forward / backward on this line |
| `t{char}` / `T{char}` | Move just before a character forward / backward |
| `;` / `,` | Repeat the last `f`, `F`, `t`, or `T` motion / repeat in reverse |
| `%` | Jump between matching brackets |
| `{` / `}` | Previous / next paragraph or code block boundary |

Counts work with motions: `5j` moves down five lines, `3w` moves over three words, and `d2w` deletes two words.

### Lines and search

- `gg` goes to the first line; `G` goes to the last line.
- `42G` goes to line 42. `:42` also jumps to that line.
- `/pattern` searches forward; `?pattern` searches backward.
- `n` and `N` move to the next and previous search match.
- `*` searches for the word under the cursor.
- `Ctrl-o` jumps back through your locations; `Ctrl-i` moves forward again.

## Combine edits with motions

Think of an operator followed by a motion or text object:

| Operator | Action |
| --- | --- |
| `d` | Delete |
| `c` | Change, meaning delete then enter Insert mode |
| `y` | Yank, meaning copy |

Examples:

- `d$` deletes to the line end. `D` is the shortcut.
- `c$` changes to the line end. `C` is the shortcut.
- `y$` copies to the line end.
- `d^` deletes back to the first nonblank character.
- `ciw` changes the word under the cursor; `daw` deletes that word and its surrounding space.
- `ci"` changes inside double quotes; `ca"` includes the quotes.
- `ci(` changes inside parentheses; `da(` deletes the parentheses and their contents.
- `yap` copies a paragraph; `dap` deletes it.

Other high-value edits:

- `.` repeats the last change.
- `u` undoes; `Ctrl-r` redoes.
- `x` deletes the character under the cursor without replacing the clipboard.
- Since system clipboard is enabled, ordinary yank and paste use the system clipboard too.

## Find code and use LSP

These LSP shortcuts are available in buffers with an attached language server:

| Keys | Action |
| --- | --- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Show hover documentation |
| `gK` | Show signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Show code actions |
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>e` | Show diagnostic details |
| `<leader>ls` / `<leader>lS` | Document / workspace symbols |
| `<leader>ld` | Search workspace diagnostics |
| `<leader>uh` | Toggle inlay hints |

## Your leader-key shortcuts

The leader key is Space. Pause after pressing it to see available commands from which-key.

| Keys | Action |
| --- | --- |
| `<leader>ff` | Find files with Telescope |
| `<leader>fr` | Find recent files |
| `<leader>fs` | Search text across the current working directory |
| `<leader>fc` | Search for the word under the cursor |
| `<leader>ee` | Toggle the file explorer |
| `<leader>ef` | Toggle the explorer focused on the current file |
| `<leader>tn` / `<leader>tp` | Next / previous buffer |
| `<leader>tx` | Close the current buffer |
| `<leader>sv` / `<leader>sh` | Vertical / horizontal split |
| `<leader>se` | Equalize split sizes |
| `<leader>sx` | Close the current split |
| `<leader>cf` | Format the current buffer |
| `<leader>nh` | Clear search highlighting |
| `<leader>ws` / `<leader>wr` | Save / restore the workspace session |

Use `Ctrl-w h`, `Ctrl-w j`, `Ctrl-w k`, and `Ctrl-w l` to move between splits. `Alt-t` creates a tab layout, `Alt-h` and `Alt-l` switch tab layouts, and `Alt-x` closes one.

Completion opens as you type. Use `Ctrl-Space` to trigger it, `Ctrl-n` and `Ctrl-p` to move through choices, and `Enter` to accept the selected choice. `Tab` and `Shift-Tab` move through snippets when available.

## Debug code

The DAP UI supports C, C++, Rust, Go, and Python. Set a breakpoint with `<leader>db`, then press `F5` to start or continue. The first C, C++, or Rust launch asks for the compiled executable. Build with debug symbols first, such as `-g -O0` for C/C++, or `cargo build` for Rust. Go starts debugging the package containing the current file. Python starts the current file and uses `.venv/bin/python` when that project environment exists.

| Keys | Debug action |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set conditional breakpoint |
| `F5` | Start or continue |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `<leader>du` | Toggle debugger panes |
| `<leader>dr` | Toggle the debugger REPL |
| `<leader>dl` | Run the last debug session again |
| `<leader>dx` | Terminate the session |

The panes open when a debug session starts and close when it ends. Use the scopes and stacks panes to inspect variables and frames. Use the REPL to evaluate expressions while execution is paused.

## A gradual practice plan

### First few sessions

1. Use `:Tutor` and learn `h`, `j`, `k`, `l`, `w`, `b`, `0`, `^`, and `$`.
2. Practice `A`, `I`, `o`, and `O` for entering text at line ends, line starts, and new lines.
3. Use `ciw`, `ci"`, `daw`, and `.` while making small edits.

### Once movement feels comfortable

1. Use `/` and `n` to search, then `Ctrl-o` to return after following a definition.
2. Navigate with `gd`, `gr`, `K`, and `]d` in a language-server buffer.
3. Find files and symbols with `<leader>ff`, `<leader>fs`, `<leader>ls`, and `<leader>lS`.

### Later

Practice marks (`ma` to set mark `a`, then `` `a `` to jump back to it), macros (`qa` to record, `q` to stop, `@a` to replay), and counts such as `d3w` or `5j`.

## Possible next improvements

These are ideas for later, not enabled features:

- Flash-style jumps to a visible word or character.
- Syntax-aware text objects for functions, parameters, and blocks.
- Git hunk navigation and staging inside Neovim.

Add these one at a time after the basic motions and current shortcuts feel familiar.
