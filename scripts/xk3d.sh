#!/bin/sh
# ./scripts/xk3d.sh
# SPDX-License-Identifier: CC0-1.0 OR 0BSD
set -x
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT
set +x

if [ "$1" = '' ];then
  printf \
'usage: ./scripts/xk3d.sh <0/00/000/0000>
Please run this script from the repository root.
This script downloads data and creates files for the ‘xk3d’ comic number you provide.\n'
  set -x
  exit 1
fi

set -x

num="$2"
readonly num
export num

if ! curl --head --fail "https://3d.xkcd.com/$num/";then
  printf \
'Couldn’t find ‘xk3d’ %s online.
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

hun="$(printf '%s%s\n' "$pad" "$num" | cut -c1-2)"
readonly hun
export hun

dir="./content/en/xkcd/comics/${hun}00-${hun}99/$pad$num"
readonly dir
export dir

if ! mkdir "$dir/3d";then
  printf \
'Couldn’t create directory %s/3d .
Make sure that %s already exists.\n' "$dir" "$dir"
  exit 1
fi

if ! mkdir "$dir/3d/images";then
  printf \
'Couldn’t create directory %s/3d/images .
Make sure that %s/3d already exists.\n' "$dir" "$dir"
  exit 1
fi

curl "https://3d.xkcd.com/$num/" | \
grep --fixed-strings '{"parallax_layers":' | \
sed -n 's/.*omgitsin3d(\({.*}\)).*/\1/p' | \
sed 's/) }$//' | \
jq --compact-output --monochrome-output -- . - > "$dir/3d/comic.json"

for lay in $(jq --raw-output --monochrome-output -- ".parallax_layers[].src | sub(\"$num/\";\"\")" "$dir/3d/comic.json");do
  export lay
  curl --output "$dir/3d/image/$lay" "https://imgs.xkcd.com/xk3d/$num/$lay"
done

jq --raw-output --monochrome-output -- .converted_by "$dir/3d/comic.json" > "$dir/3d/converted_by.txt"

if [ "$(cat "$dir/3d/converted_by.txt")" = null ];then
  rm "$dir/3d/converted_by.txt"
fi

set +x

printf \
'Done.
You might want to check the command output and/or output directory for errors.
%s/3d\n' "$dir"

set -x
exit 0
