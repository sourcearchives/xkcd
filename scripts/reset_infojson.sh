#!/bin/sh
# ./scripts/reset_infojson.sh
# SPDX-License-Identifier: CC0-1.0 OR 0BSD
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

if [ "${#1}" !=  9 ]||
   [ "$#"    !=  2 ]||
   [ "$2"     = '' ];then
  printf \
'usage: ./scripts/reset_infojson.sh <0000-0000> <0/00/000/0000>
Please run this script from the repository root.
This script re-downloads the info.json of the English ‘xkcd’ comic number you
provide and adds a newline to the end of the file, replacing any custom
formatting.
This intentionally does not include any ‘xk3d’ JSON files.\n'
  set -x
  exit 1
fi

set -x

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

c="./content/en/xkcd/comics/$1/$p$2"
readonly c
export c

find . -type f -path "$c/info.json" \
       -exec sh -xc 'curl "https://xkcd.com/$2/info.0.json" --output "$1"
             printf "\n" >> "$1"' \
             shell '{}' "$2" ';'

printf \
'Done.
You might want to check the command output and/or output directory for errors.
%s\n' "$c"
exit 0
