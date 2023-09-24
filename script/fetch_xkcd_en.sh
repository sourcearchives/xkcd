#!/usr/bin/env sh

# SPDX-License-Identifier: CC0-1.0

# run this script from the repository root: ./script/fetch_xkcd_en.sh
#                                   (or: sh ./script/fetch_xkcd_en.sh )
# this does not currently get 2x comics or irregular ones

# too many arguments?
if [ "$1"  = '' ] || [ "$2"  = '' ] ||
   [ "$3"  = '' ] || [ "$4" != '' ];then
  printf 'usage: ./script/fetch_xkcd_en.sh <url number> <range directory> <comic directory>\n'
  exit 1
fi

c='./content/en/xkcd/'"$2"'/'"$3"

printf 'creating %s\n' "$c"
mkdir -p "$c"

printf 'downloading https://xkcd.com/%s/info.0.json to %s/info.json\n' "$1" "$c"
curl 'https://xkcd.com/'"$1"'/info.0.json' > "$c"'/info.json'

printf 'formatting %s/info.json to %s/info.json.2\n' "$c" "$c"
jq --compact-output --monochrome-output --sort-keys '.' "$c"'/info.json' > "$c"'/info.json.2'

printf 'copying %s/info.json.2 to %s/info.json\n' "$c" "$c"
cat "$c"'/info.json.2' > "$c"'/info.json'

printf 'removing %s/info.json.2\n' "$c"
rm "$c"'/info.json.2'

printf 'extracting %s/title.txt from %s/info.json\n' "$c" "$c"
jq --raw-output '.title' "$c"'/info.json' > "$c"'/title.txt'

printf 'extracting %s/alt.txt from %s/info.json\n' "$c" "$c"
jq --raw-output '.alt' "$c"'/info.json' > "$c"'/alt.txt'

printf 'extracting %s/link.txt from %s/info.json' "$c" "$c"
jq --raw-output '.link' "$c"'/info.json' > "$c"'/link.txt'

printf 'extracting %s/transcript.txt from %s/info.json\n' "$c" "$c"
jq --raw-output '.transcript' "$c"'/info.json' > "$c"'/transcript.txt'

i="`jq --raw-output '.img' \"$c\"'/info.json'`"

printf 'downloading %s to %s/1x.png\n' "$i" "$c"
curl "$i" > "$c"'/1x.png'

if [ "`cat \"$c\"'/link.txt'`" = "`printf '\n'`" ];then
  printf 'removing %s/link.txt\n' "$c"
  rm "$c"'/link.txt'
fi

if [ "`cat \"$c\"'/transcript.txt'`" = "`printf '\n'`" ];then
  printf 'removing %s/transcript.txt\n' "$c"
  rm "$c"'/transcript.txt'
fi
