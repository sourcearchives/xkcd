#!/usr/bin/env bash

# SPDX-FileContributor: author: gabldotink | email:gabl@gabl.ink | github:gabldotink
# SPDX-FileCopyrightText: No rights reserved.
# SPDX-FileName: ./scripts/fetch.sh
# SPDX-FileType: APPLICATION
# SPDX-FileType: SOURCE
# SPDX-FileType: TEXT
# SPDX-LicenseConcluded: CC0-1.0
# SPDX-License-Identifier: CC0-1.0

# THIS SCRIPT DOES NOT WORK YET.
# do not use it.

# too many arguments?
if [[ "$2" != '' ]] ; then
  printf 'usage: %s <fourdigitnumber>\n' "$0"
  exit 1
fi

# argument an integer?
if [[ ! "$1" =~ '^[0-9][0-9][0-9][0-9]*$' ]]; then
  printf 'usage: %s <fourdigitnumber>\n' "$0"
  exit 1
fi

printf 'fetching English xkcd: '"$1"'\n'

if command -v curl ; then : ;
else printf 'curl is required and not installed\n' ; exit 1
fi

if curl --fail-with-body --silent 'https://xkcd.com/'"$1"'/' >/dev/null ; then
  printf 'comic exists\n'
else printf 'comic does not exist\n'
     exit 1
fi

if command -v jq ; then : ;
else printf 'jq is required and not installed\n' ; exit 1
fi

curl --silent 'https://xkcd.com/'"$1"'/info.0.json' | \
jq -cMS . > ../content/en/comic/"$(cut -c 1-2 $1)"99/$1/info.json
