#!/usr/bin/env sh
# SPDX-License-Identifier: CC0-1.0

# This POSIX shell script is similar to a Makefile;
#   it creates a file containing the entire book.
# Currently supported file formats are:
#   [placeholder]
# These file formats will be supported in the future:
#   OpenDocument Drawing (ODG)
#   Portable Document Format (PDF)
#   comic book ACE (CBA)
#   comic book RAR (CBR)
#   comic book tar (CBT)
#   comic book ZIP (CBZ)
#   comic book 7z  (CB7)

# tell shells to be POSIX-compliant
export POSIXLY_CORRECT

# show help
usage () {
  printf 'This shell script builds files containing xkcd: volume 0 by Randall Munroe.\n'
}
