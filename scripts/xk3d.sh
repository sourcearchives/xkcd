#!/bin/sh
# ./scripts/xk3d.sh
# SPDX-License-Identifier: CC0-1.0 OR 0BSD
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

arg="$1"
readonly arg
export arg

# make sure that the argument is an integer (“number”)
if [ "$(printf '%s' "$arg" | grep -e '^[0-9]*$')" = '' ];then
  # the argument is not a number (e.g. empty, “-h,” “--help,” “-?,” etc., so print usage)
  printf \
'usage: ./scripts/xk3d.sh <0/00/000/0000>
Please run this script from the repository root.
This script downloads data and creates files for the “xk3d” comic number you provide.\n'
  exit 1
fi

# remove leading “0s” from the number by multiplying by 1
num="$(($arg*1))"
readonly num
export num

# make sure that the number doesn’t give an error
if ! curl -fI "https://3d.xkcd.com/$num/";then
  printf \
'Couldn’t find “xk3d” %s online.
Make sure it exists and that you’re connected to the Internet.\n' "$num"
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
Please file an issue or pull request at
https://github.com/sourcearchives/xkcd
if this is a valid comic number.'
  exit 1
fi
readonly pad
export pad

# extract first two digits of number for categorization
hundred="$(printf '%s\n' "$pad$num" | cut -c1-2)"
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

if ! mkdir -p "$dir/3d";then
  printf 'Couldn’t create directory %s/3d\n' "$dir"
  exit 1
fi

if ! mkdir -p "$dir/3d/images";then
  printf 'Couldn’t create directory %s/3d/images\n' "$dir"
  exit 1
fi

# extract JSON from webpage (don’t ask me how this works please)
curl "https://3d.xkcd.com/$num/" |\
grep -F '{"parallax_layers":' |\
sed -n 's/.*omgitsin3d(\({.*}\)).*/\1/p' |\
sed 's/) }$//' |\
jq --compact-output --monochrome-output . - > "$dir/3d/comic.json"

# download all the images in the JSON
for layer in $(jq --raw-output --monochrome-output ".parallax_layers.[].src | sub(\"$num/\";\"\")" "$dir/3d/comic.json");do
  export layer
  curl -o "$dir/3d/image/$layer" "https://imgs.xkcd.com/xk3d/$num/$layer"
done

jq --raw-output --monochrome-output .converted_by "$dir/3d/comic.json" > "$dir/3d/converted_by.txt"

# most comics don’t have “converted_by,” so if it’s empty delete the file
[ "$(cat "$dir/3d/converted_by.txt")" = null ] &&
  rm -f "$dir/3d/converted_by.txt"

printf \
'Done.
%s/3d\n' "$dir"

# exit successfully
exit 0
