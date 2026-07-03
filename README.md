# fdf

Fuzzy directory finder for zsh. Save directories, jump to them fast.

## Requirements

- [fzf](https://github.com/junegunn/fzf)

## Install

Source it in your `.zshrc`:

```zsh
source "$HOME/path/to/fdf.zsh"
```

## Usage

```
fdf           # fuzzy search saved dirs and jump
fdf add       # save current directory
fdf remove    # remove current directory from saved list
```

Saved directories are stored in `~/.fdf_dirs`. Override with `$FDF_STORE`.
