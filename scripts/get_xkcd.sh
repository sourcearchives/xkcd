#!/bin/sh
# run this script from the repository root: ./scripts/get_xkcd.sh
#                                  ( or: sh ./scripts/get_xkcd.sh )
LC_ALL=C
readonly LC_ALL
export LC_ALL
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

if [ "${#1}" !=  9 ]||
   [ "$#"    !=  2 ]||
   [ "$2"     = '' ];then
  printf \
'usage: ./scripts/get_xkcd.sh <0000-0000> <0/00/000/0000>
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

curl --head --fail "https://xkcd.com/$2/" ||
printf \
'Couldn’t find ‘xkcd’ %s online.
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

c="./content/en/xkcd/comics/$1/$p$2"
readonly c
export c

mkdir "$c" ||
printf \
'Couldn’t create directory %s .
Make sure that %s already exists.\n' "$c" "$c"

curl "https://xkcd.com/$2/info.0.json" --output "$c/info.json"
printf '\n' >> "$c/info.json"

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

m="$(printf '%s' "$i" | sed 's/\.'"$e"'//g')"
readonly m
export m

curl "$i" --output "$c/1x.$e"
curl --fail "$m""_2x.$e" --output "$c/2x.$e"

n="$(printf '\n')"
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

printf \
'Done.
You might want to check the command output and/or output directory for errors.
%s/\n' "$c"

exit 0