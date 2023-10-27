#!/bin/sh

# run this script from the repository root: ./script/fetch_xkcd_en.sh
#                                  ( or: sh ./script/fetch_xkcd_en.sh )
# review the comics yourself manually first

set -x

readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

if [ "$1"  = '' ]||
   [ "$2"  = '' ]||
   [ "$3" != '' ];then
  printf 'usage: ./script/fetch_xkcd_en.sh <range directory> <unpadded number>\n'
  exit 1
fi

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

mkdir -p "$c"

curl "https://xkcd.com/$2/info.0.json" --output - | \
jq --compact-output --monochrome-output --sort-keys '.' - > "$c/info.json"

jq --raw-output .alt "$c/info.json" > "$c/alt.txt"

jq --raw-output .link "$c/info.json" > "$c/link.txt"

jq --raw-output .news "$c/info.json" > "$c/news.html"

jq --raw-output .title "$c/info.json" > "$c/title.txt"

jq --raw-output .transcript "$c/info.json" > "$c/transcript.txt"

i="$(jq --raw-output .img "$c/info.json")"
readonly i
export i

e="${i##*.}"
readonly e
export e

m="$(printf '%s' "$i" | sed "s/\.$e//g")"
readonly m
export m

curl "$i" --output "$c/1x.$e"
curl --fail "$m_2x.$e" --output "$c/2x.$e"

n='
' # (newline)
readonly n
export n

if [ "$(cat "$c/link.txt")" = "$n" ];then
  rm "$c/link.txt"
fi

if [ "$(cat "$c/news.html")" = "$n" ];then
  rm "$c/news.html"
fi

if [ "$(cat "$c/transcript.txt")" = "$n" ];then
  rm "$c/transcript.txt"
fi

printf 'Done!\nThis script does not include error checking, so you may want to check yourself.\n%s\n' "$c"
exit 0
