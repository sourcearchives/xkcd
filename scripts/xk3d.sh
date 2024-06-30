#!/bin/sh
# ./scripts/xk3d.sh
# SPDX-License-Identifier: CC0-1.0 OR 0BSD
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

num="$1"
readonly num
export num

if [ "$num" = '' ];then
  printf 'usage: ./scripts/xk3d.sh <0/00/000/0000>
Please run this script from the repository root.
This script downloads data and creates files for the “xk3d” comic number you provide.\n'
  exit 1
fi

if ! curl -fI "https://3d.xkcd.com/$num/";then
  printf \
'Couldn’t find “xk3d” %s online.
Make sure it exists and that you’re connected to the Internet.\n' "$num"
  exit 1
fi

if   [ "${#num}" = 1 ];then
  pad=000
elif [ "${#num}" = 2 ];then
  pad=00
elif [ "${#num}" = 3 ];then
  pad=0
else
  pad=''
fi
readonly pad
export pad

hundred="$(printf '%s\n' "$pad$num"|cut -c1-2)"
readonly hundred
export hundred

dir="./content/en/xkcd/comics/${hundred}00-${hundred}99/$pad$num"
readonly dir
export dir

if ! mkdir -p "$dir/3d";then
  printf 'Couldn’t create directory %s/3d\n' "$dir"
  exit 1
fi

if ! mkdir -p "$dir/3d/images";then
  printf 'Couldn’t create directory %s/3d/images\n' "$dir"
  exit 1
fi

curl "https://3d.xkcd.com/$num/" | \
grep -F '{"parallax_layers":' | \
sed -n 's/.*omgitsin3d(\({.*}\)).*/\1/p' | \
sed 's/) }$//' | \
jq --compact-output --monochrome-output . - > "$dir/3d/comic.json"

for layer in $(jq --raw-output --monochrome-output ".parallax_layers[].src | sub(\"$num/\";\"\")" "$dir/3d/comic.json");do
  export layer
  curl -o "$dir/3d/image/$layer" "https://imgs.xkcd.com/xk3d/$num/$layer"
done

jq --raw-output --monochrome-output .converted_by "$dir/3d/comic.json" > "$dir/3d/converted_by.txt"

if [ "$(cat "$dir/3d/converted_by.txt")" = null ];then
  rm -f "$dir/3d/converted_by.txt"
fi

printf \
'Done.
%s/3d\n' "$dir"

exit 0
