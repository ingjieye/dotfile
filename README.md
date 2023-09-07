# Dotfile
My dotfile setup for vim/nvim/tmux/zsh etc.. deeply inspired by MaskRay/Config

## Deploying
```
./deploy.sh
```

## Vim
### Key bindings

```
Overview of which map command works in which mode.
COMMANDS                      MODES
:map   :noremap  :unmap       Normal, Visual, Select, Operator-pending
:nmap  :nnoremap :nunmap :nn  Normal
:vmap  :vnoremap :vunmap      Visual and Select
:smap  :snoremap :sunmap      Select
:xmap  :xnoremap :xunmap      Visual
:omap  :onoremap :ounmap      Operator-pending
:map!  :noremap! :unmap!      Insert and Command-line
:imap  :inoremap :iunmap      Insert
:lmap  :lnoremap :lunmap      Insert, Command-line, Lang-Arg
:cmap  :cnoremap :cunmap      Command-line
```

#### No prefix
- `=` - More vertical space for current window
- `-` - Less vertical space for current window
- `+` - More horizontal space for current window
- `_` - Less horizontal space for current window

- `H` - Clear hilight

- `K` - coc show documentation
- `gd` - coc Jump to variable definition
- `gy` - coc Jump to type definition
- `gi` - coc Jump to implementation
- `gr` - coc Jump to references

- `s` - Easymotion(Hop)

#### Alt(meta)
- `ALT` + `1/2/3/4/5` - switch to corresponding tab

#### Ctrl
- `Ctrl` + `S` - Save

- `Ctrl` + `H` - Navigate to left window
- `Ctrl` + `L` - Navigate to right window
- `Ctrl` + `K` - Navigate to up window
- `Ctrl` + `J` - Navigate to down window

- `Ctrl` + `F` - Open FZF

- `Ctrl` + `P` - Jump to previous diagnostics
- `Ctrl` + `N` - Jump to next diagnostics

#### Leader
- `Leader` + `cg` - Check colorgroup for current cursor

- `Leader` + `ne` - Toggle nvim tree
- `Leader` + `nf` - Find current file in nvim tree

- `Leader` + `ac` - coc codeAction
- `Leader` + `qf` - coc quickfix
- `Leader` + `f`  - coc format selected
