#!/usr/bin/env sh
# SPDX-FileContributor: author: gabldotink [@gabldotink] <gabl@gabl.ink>
# SPDX-FileCopyrightText: No rights reserved.
# SPDX-FileName: ./checks.sh
# SPDX-FileType: APPLICATION
# SPDX-FileType: SOURCE
# SPDX-LicenseConcluded: CC0-1.0
# SPDX-License-Identifier: CC0-1.0

# This POSIX shell script performs some checks on the repository to ensure the repository is complete and consistent.

# tell (some) shells to be POSIX-compliant
export POSIXLY_CORRECT

trap quit INT

quit () {
  exit 2
}

info () {
  printf 'This shell script checks the repository for format and internal consistency. It does not currently take any arguments.\n'
}

if [ "$1" != '' ]; then info; exit 2; fi
