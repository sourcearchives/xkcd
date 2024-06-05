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

hun="$(printf '%s%s\n' "$pad" "$num" | cut -c1-2)"
readonly hun
export hun

dir="./content/en/xkcd/comics/${hun}00-${hun}99/$pad$num"
readonly dir
export dir

if ! mkdir "$dir";then
  printf \
'Couldn’t create directory %s .
Make sure that ./content/en/xkcd/comics/%s00-%s99 already exists.\n' "$dir" "$hun" "$hun"
  exit 1
fi

curl --output - "https://xkcd.com/$num/info.0.json" | \
jq --compact-output --monochrome-output -- . - > "$dir/info.json"

jq --raw-output --monochrome-output -- .alt "$dir/info.json" > "$dir/alt.txt"
jq --raw-output --monochrome-output -- .link "$dir/info.json" > "$dir/link.txt"
jq --raw-output --monochrome-output -- .news "$dir/info.json" > "$dir/news.html"
jq --raw-output --monochrome-output -- .title "$dir/info.json" > "$dir/title.txt"
jq --raw-output --monochrome-output -- .transcript "$dir/info.json" > "$dir/transcript.txt"
jq --raw-output --monochrome-output -- .num "$dir/info.json" > "$dir/num.txt"

img="$(jq --raw-output --monochrome-output -- .img "$dir/info.json")"
readonly img
export img

ext="${img##*.}"
readonly ext
export ext

bas="$(printf '%s' "$img" | sed 's/\.'"$ext"'//g')"
readonly bas
export bas

curl --output "$dir/1x.$ext" "$img"
curl --fail --output "$dir/2x.$ext" "${bas}_2x.$ext"

nlf="$(printf '\n')"
readonly nlf
export nlf

if [ "$(cat "$dir/link.txt")" = "$nlf" ];then
  rm -f "$dir/link.txt"
fi

if [ "$(cat "$dir/news.html")" = "$nlf" ];then
  rm -f "$dir/news.html"
fi

if [ "$(cat "$dir/transcript.txt")" = "$nlf" ];then
  rm -f "$dir/transcript.txt"
fi

set +x

printf \
'Done.
You might want to check the command output and/or output directory for errors.
%s/\n' "$dir"

set -x
exit 0
