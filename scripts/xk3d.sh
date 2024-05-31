#!/bin/sh
# ./scripts/xk3d.sh
# SPDX-License-Identifier: CC0-1.0 OR 0BSD
set -x
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT
set +x

if [ "${#1}" !=  9 ]||
   [ "$#"    !=  2 ]||
   [ "$2"     = '' ];then
  printf \
'usage: ./scripts/xk3d.sh <0000-0000> <0/00/000/0000>
Please run this script from the repository root.
This script downloads data and creates files for the ‘xk3d’ comic number you provide.\n'
  set -x
  exit 1
fi

set -x

hun="$1"
readonly hun
export hun

num="$2"
readonly num
export num

curl --head --fail "https://3d.xkcd.com/$num/" ||
printf \
'Couldn’t find ‘xk3d’ %s online.
Make sure it exists and that you’re connected to the Internet.\n' "$num"

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

dir="./content/en/xkcd/comics/$hun/$pad$num"
readonly dir
export dir

mkdir "$dir/3d" ||
printf \
'Couldn’t create directory %s/3d .
Make sure that %s already exists.\n' "$dir" "$dir"
mkdir "$dir/3d/images"

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
%s/\n' "$dir/3d"

set -x
exit 0
