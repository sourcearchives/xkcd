#!/bin/sh
# ./scripts/xkcd.sh
# SPDX-License-Identifier: CC0-1.0 OR 0BSD
set -x
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT
set +x

if [ "$1" = '' ];then
  printf \
'usage: ./scripts/xkcd.sh <0/00/000/0000>
Please run this script from the repository root.
This script downloads data and creates files for the English ‘xkcd’ comic number
you provide.
It automatically handles 1x and 2x images; info.json; title.txt, alt.txt,
transcript.txt, link.txt, and news.html.
It currently doesn’t do anything past that. You might want to check the
comics you’re downloading first for potential issues.\n'
  set -x
  exit 1
fi

set -x

num="$1"
readonly num
export num

if ! curl --head --fail "https://xkcd.com/$num/";then
  printf \
'Couldn’t find ‘xkcd’ %s online.
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

hundred="$(printf '%s%s\n' "$pad" "$num" | cut -c1-2)"
readonly hundred
export hundred

dir="./content/en/xkcd/comics/${hundred}00-${hundred}99/$pad$num"
readonly dir
export dir

if ! mkdir -p "$dir";then
  printf \
'Couldn’t create directory %s\n' "$dir"
  exit 1
fi

curl --output - "https://xkcd.com/$num/info.0.json" | \
jq --compact-output --monochrome-output . - > "$dir/info.json"

jq --raw-output --monochrome-output .alt "$dir/info.json" > "$dir/alt.txt"
jq --raw-output --monochrome-output .link "$dir/info.json" > "$dir/link.txt"
jq --raw-output --monochrome-output .news "$dir/info.json" > "$dir/news.html"
jq --raw-output --monochrome-output .title "$dir/info.json" > "$dir/title.txt"
jq --raw-output --monochrome-output .transcript "$dir/info.json" > "$dir/transcript.txt"
jq --raw-output --monochrome-output .num "$dir/info.json" > "$dir/num.txt"

img="$(jq --raw-output --monochrome-output .img "$dir/info.json")"
readonly img
export img

ext="${img##*.}"
readonly ext
export ext

base="$(printf '%s' "$img" | sed 's/\.'"$ext"'//g')"
readonly base
export base

curl --output "$dir/1x.$ext" "$img"
curl --fail --output "$dir/2x.$ext" "${base}_2x.$ext"

lf="$(printf '\n')"
readonly lf
export lf

if [ "$(cat "$dir/link.txt")" = "$lf" ];then
  rm -f "$dir/link.txt"
fi

if [ "$(cat "$dir/news.html")" = "$lf" ];then
  rm -f "$dir/news.html"
fi

  if [ "$(cat "$dir/transcript.txt")" = "$lf" ];then
  rm -f "$dir/transcript.txt"
fi

set +x

printf \
'Done.
%s/\n' "$dir"

set -x
exit 0
