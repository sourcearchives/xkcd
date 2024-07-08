#!/bin/sh
# ./scripts/xkcd.sh
# SPDX-License-Identifier: CC0-1.0 OR 0BSD
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

arg="$1"
readonly arg
export arg

# make sure that the argument is an integer (“number”)
if [ "$(printf '%s' "$arg" | grep -e '^[0-9]*$')" = '' ];then
  # the argument is not an integer (e.g. empty, “-h,” “--help,” “-?,” etc.), so print usage
  printf \
'usage: ./scripts/xkcd.sh <0/00/000/0000>
Please run this script from the repository root.
This script downloads data and creates files for the English “xkcd” comic number
you provide.
It automatically handles 1x and 2x images; info.json; title.txt, alt.txt,
transcript.txt, link.txt, and news.html.
It currently doesn’t do anything past that. You might want to check the
comics you’re downloading first for potential issues.\n'
  # exit unsuccessfully
  exit 1
fi

# remove leading “0s” from the number by multiplying by 1
num="$(($arg*1))"
readonly num
export num

# make sure that the number doesn’t give an error
if ! curl -Ifs "https://xkcd.com/$num/";then
  printf \
'Couldn’t find “xkcd” %s online.
Make sure it exists and that you’re connected to the Internet.\n' "$num"
  # exit unsuccessfully
  exit 1
fi

# add padding with “0s” to number, for compatibility with directory structure
if   [ "${#num}" = 1 ];then
  pad=000
elif [ "${#num}" = 2 ];then
  pad=00
elif [ "${#num}" = 3 ];then
  pad=0
elif [ "${#num}" = 4 ];then
  pad=''
else
  # given “xkcd”’s schedule stays consistent, this code should work until July 8, 2069
  printf \
'The number is more than 4 digits long.
Please file an issue at
https://github.com/sourcearchives/xkcd
if this is a valid comic number.'
  # exit unsuccessfully
  exit 1
fi
readonly pad
export pad

# extract first two digits of number for categorization
hundred="$(printf '%s\n' "$pad$num"|cut -c1-2)"
readonly hundred
export hundred

# the first 99 comics are categorized differently
if [ "$hundred" = 00 ];then
  dir="./content/en/xkcd/comics/0001-0099/$pad$num"
else
  dir="./content/en/xkcd/comics/${hundred}00-${hundred}99/$pad$num"
fi
readonly dir
export dir

if ! mkdir -p "$dir";then
  printf 'Couldn’t create directory %s\n' "$dir"
  # exit unsuccessfully
  exit 1
fi

# download JSON and compact it
curl -o - "https://xkcd.com/$num/info.0.json" | \
jq --compact-output --monochrome-output . - > "$dir/info.json"

# extract some JSON fields to files
jq --raw-output --monochrome-output .alt "$dir/info.json" > "$dir/alt.txt" &
jq --raw-output --monochrome-output .link "$dir/info.json" > "$dir/link.txt" &
jq --raw-output --monochrome-output .news "$dir/info.json" > "$dir/news.html" &
jq --raw-output --monochrome-output .title "$dir/info.json" > "$dir/title.txt" &
jq --raw-output --monochrome-output .transcript "$dir/info.json" > "$dir/transcript.txt" &
jq --raw-output --monochrome-output .num "$dir/info.json" > "$dir/num.txt" &
wait

img="$(jq --raw-output --monochrome-output .img "$dir/info.json")"
readonly img
export img

# extract the file extension
ext="${img##*.}"
readonly ext
export ext

# extract the filename without the extension
base="$(printf '%s' "$img" | sed 's/\.'"$ext"'//g')"
readonly base
export base

# download image, plus 2x image if it exists
curl -so "$dir/1x.$ext" "$img" &
curl -fso "$dir/2x.$ext" "${base}_2x.$ext" &
wait

lf="$(printf '\n')"
readonly lf
export lf

# if these files are blank, then delete them
[ "$(cat "$dir/link.txt")" = "$lf" ] &&
  rm -f "$dir/link.txt"

[ "$(cat "$dir/news.html")" = "$lf" ] &&
  rm -f "$dir/news.html"

[ "$(cat "$dir/transcript.txt")" = "$lf" ] &&
  rm -f "$dir/transcript.txt"

printf \
'Done.
%s\n' "$dir"

# exit successfully
exit 0
