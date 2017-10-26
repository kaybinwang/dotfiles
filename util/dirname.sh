#
# Takes an file path as an input and outputs the absolute directory name of the
# file. This resolves symlinks, relative paths, and symlinks to relative paths.
#
# Source:
#   https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within/246128#246128
#
function abs_dirname() {
  local script="$1"
  local dir
  while [ -h "$script" ]; do
    dir="$(cd -P "$(dirname "$script")" && pwd)"
    script="$(readlink "$script")"
    [[ $script != /* ]] && script="$dir/$script"
  done
  dir="$(cd -P "$(dirname "$script")" && pwd)"
  echo "$dir"
}
