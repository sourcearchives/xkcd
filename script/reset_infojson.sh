#!/bin/sh

# run this script from the repository root: ./script/reset_infojson.sh
#                                  ( or: sh ./script/reset_infojson.sh )

readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

if [ "$1"     = '' ]||
   [ "${#1}" !=  9 ]||
   [ "$2"     = '' ]||
   [ "${#2}" !=  4 ]||
   [ "$3"    != '' ];then
  printf \
'usage: ./script/reset_infojson.sh 0000-0000 0000
Please run this script from the repository root.
This script re-downloads the info.json of the English xkcd comic number you
provide and adds a newline to the end of the file, replacing any custom
formatting.
This intentionally does not include any xk3d JSON files.\n'
  set -x
  exit 1
fi

set -x

if   [ "${#2}" = 1 ];then
  p=000
  readonly p
  export p
elif [ "${#2}" = 2 ];then
  p=00
  readonly p
  export p
elif [ "${#2}" = 3 ];then
  p=0
  readonly p
  export p
else
  p=''
  readonly p
  export p
fi

c="./content/en/xkcd/$1/$p$2"
readonly c
export c

find . -type f -path "$c/info.json" \
       -exec curl "https://xkcd.com/$2/info.0.json" --output '{}' ';' \
       -exec sh -c 'printf "\n" >> "$1"' shell '{}' ';'

printf \
'Done.
You might want to check the command output and/or output directory for errors.
%s\n' "$c"
exit 0
