source ~/.config/sh/helpers.sh

nvim="$(__get_nvim_path_with_fallback)"
if [ -n "$nvim" ]; then
  export VISUAL="$nvim"
  export EDITOR="$VISUAL"
fi
