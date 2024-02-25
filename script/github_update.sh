#!/bin/sh
# run this script from the repository root: ./script/github_update.sh
#                                  ( or: sh ./script/github_update.sh )
LC_ALL=C
readonly LC_ALL
export LC_ALL
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

if [ "$#" !=  1 ]||
   [ "$1"  = '' ];then
  printf \
'usage: ./script/github_update.sh <owner/repo>
Please run this script from the repository root so that it doesn’t get confused about file paths.

This script updates the GitHub API JSON for the repository name you provide.
It does not operate on bundle files or create new files or directories.\n'
  set -x
  exit 1
fi

set -x

c="./content/en/external/git/github.com/$1"
readonly c
export c

if [ -f "$c/info.json" ];then
  curl --request GET \
       --url "https://api.github.com/repos/$1" \
       --header 'X-GitHub-Api-Version: 2022-11-28'
       --output "$c/info.json"
else
  printf '[error] Couldn’t find file: %s\n' "$c/info.json"
  printf '[error] The script has stopped due to the above error.
Operated on no files.\n'
  exit 1
fi

printf 'Done. Operated on files:
%s\n' "$c/info.json"
exit 0
