#!/usr/bin/env sh

# SPDX-License-Identifier: CC0-1.0

# run this script from the repository root: ./script/fetch_xkcd_en.sh
#                                   (or: sh ./script/fetch_xkcd_en.sh )
# this does not currently get 2x comics or irregular ones

export POSIXLY_CORRECT

# incorrect arguments?
if [ "$1"  = '' ] || [ "$2"  = '' ] ||
   [ "$3"  = '' ] || [ "$4" != '' ];then
  printf 'usage: ./script/fetch_xkcd_en.sh <url number> <range directory> <comic directory>\n'
  exit 1
fi

c='./content/en/xkcd/'"$2"'/'"$3"
export c

mkdir -p "$c"

curl 'https://xkcd.com/'"$1"'/info.0.json' --output - | \
jq --compact-output --monochrome-output --sort-keys '.' - > "$c"'/info.json'

jq --raw-output '.alt' "$c"'/info.json' > "$c"'/alt.txt'

jq --raw-output '.link' "$c"'/info.json' > "$c"'/link.txt'

jq --raw-output '.news' "$c"'/info.json' > "$c"'/news.html'

jq --raw-output '.title' "$c"'/info.json' > "$c"'/title.txt'

jq --raw-output '.transcript' "$c"'/info.json' > "$c"'/transcript.txt'

i="$(jq --raw-output '.img' "$c"'/info.json')"
export i

curl "$i" --output "$c"'/1x.png'

if [ "$(cat "$c"'/link.txt')" = "$(printf '\n')" ];then
  rm "$c"'/link.txt'
fi

if [ "$(cat "$c"'/news.html')" = "$(printf '\n')" ];then
  rm "$c"'/news.html'
fi

if [ "$(cat "$c"'/transcript.txt')" = "$(printf '\n')" ];then
  rm "$c"'/transcript.txt'
fi

printf '%s\n' "$c"
