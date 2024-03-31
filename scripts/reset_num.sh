# execute: ./scripts/reset_numbers.sh
# SPDX-License-Identifier: CC0-1.0 OR 0BSD
set -x
readonly POSIXLY_CORRECT
export POSIXLY_CORRECT

find . -type f -name info.json \
       -execdir sh -xc 'jq --raw-output .num ./info.json > ./num.txt' ';'
