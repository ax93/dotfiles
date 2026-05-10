#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$script_dir/palette.env"
. "$script_dir/semantic.env"

vars="$(awk -F'=' '/^export [a-zA-Z_]+=/ { printf "${%s} ", $1 }' \
        "$script_dir/palette.env" "$script_dir/semantic.env" \
        | sed 's/export //g')"

count=0
while IFS= read -r -d '' tmpl; do
  out="${tmpl%.tmpl}"
  envsubst "$vars" < "$tmpl" > "$out"
  count=$((count + 1))
done < <(find -L "$HOME/.config" -type f -name '*.tmpl' -print0)

echo "built $count files"
