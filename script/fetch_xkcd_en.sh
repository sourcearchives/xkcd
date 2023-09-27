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

printf 'creating %s\n' "$c"
mkdir -p "$c"

printf 'downloading and formatting https://xkcd.com/%s/info.0.json to %s/info.json\n' "$1" "$c"
curl 'https://xkcd.com/'"$1"'/info.0.json' --output - | \
jq --compact-output --monochrome-output --sort-keys '.' - > "$c"'/info.json'

printf 'extracting %s/alt.txt from %s/info.json\n' "$c" "$c"
jq --raw-output '.alt' "$c"'/info.json' > "$c"'/alt.txt'

printf 'extracting %s/link.txt from %s/info.json' "$c" "$c"
jq --raw-output '.link' "$c"'/info.json' > "$c"'/link.txt'

printf 'extracting %s/news.html from %s/info.json' "$c" "$c"
jq --raw-output '.news' "$c"'/info.json' > "$c"'/news.html'

printf 'extracting %s/title.txt from %s/info.json\n' "$c" "$c"
jq --raw-output '.title' "$c"'/info.json' > "$c"'/title.txt'

printf 'extracting %s/transcript.txt from %s/info.json\n' "$c" "$c"
jq --raw-output '.transcript' "$c"'/info.json' > "$c"'/transcript.txt'

i="$(jq --raw-output '.img' "$c"'/info.json')"
export i

printf 'downloading %s to %s/1x.png\n' "$i" "$c"
curl "$i" --output "$c"'/1x.png'

if [ "$(cat "$c"'/link.txt')" = "$(printf '\n')" ];then
  printf 'removing %s/link.txt\n' "$c"
  rm "$c"'/link.txt'
fi

if [ "$(cat "$c"'/news.html')" = "$(printf '\n')" ];then
  printf 'removing %s/news.html\n' "$c"
  rm "$c"'/news.html'
fi

if [ "$(cat "$c"'/transcript.txt')" = "$(printf '\n')" ];then
  printf 'removing %s/transcript.txt\n' "$c"
  rm "$c"'/transcript.txt'
fi
