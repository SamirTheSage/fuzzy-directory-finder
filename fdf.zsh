#!/usr/bin/env zsh
# fdf — fuzzy directory finder
# Source this file (or add it to .zshrc) to get the `fdf` function.
# Usage:
#   fdf          — fuzzy search saved dirs and cd to selection
#   fdf add      — save current directory
#   fdf remove   — fuzzy search saved dirs and remove selection

fdf() {
  local store="${FDF_STORE:-$HOME/.fdf_dirs}"
  local cmd="${1:-}"

  case "$cmd" in
    add)
      local dir="$PWD"
      if grep -qxF "$dir" "$store" 2>/dev/null; then
        echo "fdf: already saved: $dir"
      else
        echo "$dir" >> "$store"
        echo "fdf: saved $dir"
      fi
      ;;

    remove)
      if ! grep -qxF "$PWD" "$store" 2>/dev/null; then
        echo "fdf: not saved: $PWD"
        return 1
      fi
      local tmpfile
      tmpfile=$(mktemp)
      grep -vxF "$PWD" "$store" > "$tmpfile" && mv "$tmpfile" "$store"
      echo "fdf: removed $PWD"
      ;;

    "")
      [[ ! -s "$store" ]] && { echo "fdf: no saved directories (use 'fdf add' to save one)"; return 1; }
      local selection
      local lines=$LINES
      local fzf_height=40
      local top_margin=$(( (lines - fzf_height * lines / 100) / 2 ))
      [[ $top_margin -lt 1 ]] && top_margin=1
      tput clear
      selection=$(cat "$store" | fzf \
        --height=${fzf_height}% \
        --margin="${top_margin},10,0,10" \
        --color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#3a3a3a,gutter:-1 \
        --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00 \
        --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf \
        --color=border:#5f87af,label:#5fd7ff,query:#d9d9d9 \
        --border="rounded" \
        --border-label="Search Directories" \
        --border-label-pos="0" \
        --padding="1,1" \
        --margin="1,1,1" \
        --prompt="> " \
        --marker="* " \
        --pointer=">" \
        --separator="-" \
        --scrollbar="" \
        --layout="default" \
        --info="right" \
        --preview='CLICOLOR_FORCE=1 ls -lrthG {}' \
        --preview-label=" Files " \
        --preview-window='right:50%:border-sharp')
      [[ -z "$selection" ]] && return 0
      if [[ ! -d "$selection" ]]; then
        echo "fdf: directory no longer exists: $selection"
        return 1
      fi
      cd "$selection" && clear
      ;;

    *)
      echo "Usage: fdf [add|remove]"
      return 1
      ;;
  esac
}
