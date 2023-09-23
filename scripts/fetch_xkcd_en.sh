#!/usr/bin/env sh

# SPDX-License-Identifier: CC0-1.0

# this does not currently get 2x comics or irregular ones

# too many arguments?
if [ "$1"  = '' ] || [ "$2"  = '' ] ||
   [ "$3"  = '' ] || [ "$4" != '' ];then
  printf 'usage: ./scripts/fetch_xkcd_en.sh <url number> <range directory> <comic directory>\n' "$0"
  exit 1
fi

comic_path='./content/en/comic/'"$2"'/'"$3"

mkdir -p "$comic_path"

curl 'https://xkcd.com/'"$1"'/info.0.json' > "$comic_path"'/info.json'

jq --compact-output --monochrome-output --sort-keys '.' "$comic_path"'/info.json' > "$comic_path"'/info.json.2'

cat "$comic_path"'/info.json.2' > "$comic_path"'/info.json'

rm "$comic_path"'/info.json.2'

jq --raw-output '.title' "$comic_path"'/info.json' > "$comic_path"'/title.txt'
jq --raw-output '.alt' "$comic_path"'/info.json' > "$comic_path"'/alt.txt'
jq --raw-output '.transcript' "$comic_path"'/info.json' > "$comic_path"'/transcript.txt'

curl "`jq --raw-output '.img'`" > "$comic_path"'/1x.png'

if [ ! -s "$comic_path"'/transcript.txt' ];then
  rm "$comic_path"'/transcript.txt'
fi
