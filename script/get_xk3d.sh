#!/bin/sh
# run this script from the repository root: ./script/get_xk3d.sh
#                                  ( or: sh ./script/get_xk3d.sh )
LC_ALL=C
readonly LC_ALL
export LC_ALL
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

if [ "${#1}" !=  9 ]||
   [ "$#"    !=  2 ]||
   [ "$2"     = '' ];then
  printf \
'usage: ./script/get_xkcd.sh [0000-0000] [0/00/000/0000]
Please run this script from the repository root.
This script downloads data and creates files for the ‘xk3d’ comic number you provide.\n'
  set -x
  exit 1
fi

set -x

curl --head --fail "https://3d.xkcd.com/$2/" || \
printf \
'Couldn’t find ‘xk3d’ %s online.
Make sure it exists and that you’re connected to the Internet.\n' "$2"

if   [ "${#2}" = 1 ];then
  p=000
elif [ "${#2}" = 2 ];then
  p=00
elif [ "${#2}" = 3 ];then
  p=0
else
  p=''
fi
readonly p
export p

c="./content/en/xkcd/comic/$1/$p$2"
readonly c
export c

mkdir "$c/_3d" || \
printf \
'Couldn’t create directory %s/_3d .
Make sure that %s already exists.\n' "$c" "$c"
mkdir "$c/_3d/image"

curl "https://3d.xkcd.com/$2/" | \
grep --fixed-strings '{"parallax_layers":' | \
sed -n 's/.*omgitsin3d(\({.*}\)).*/\1/p' | \
sed 's/) }$//' > "$c/_3d/comic.json"

for i in $(jq --raw-output ".parallax_layers[].src | sub(\"$2/\";\"\")" "$c/_3d/comic.json");do
  export i
  curl "https://imgs.xkcd.com/xk3d/$2/$i" --output "$c/_3d/image/$i"
done

jq --raw-output .converted_by "$c/_3d/comic.json" > "$c/_3d/converted_by.txt"

if [ "$(cat "$c/_3d/converted_by.txt")" = null ];then
  rm "$c/_3d/converted_by.txt"
fi

printf \
'Done.
You might want to check the command output and/or output directory for errors.
%s/\n' "$c/_3d"

exit 0
