<!-- SPDX-License-Identifier: CC0-1.0 OR 0BSD -->
# <i>xkcd</i> archive &ndash;&nbsp;filenames

<i>“Filename” means either a filename or a directory name.</i>

Filenames <em>should</em> match <em>all</em> of these conditions:

<ul type="disc">

<li>

  Filenames <em>should</em> only use characters in the [Portable Filename Character Set](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_282):

```Text
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
a b c d e f g h i j k l m n o p q r s t u v w x y z
0 1 2 3 4 5 6 7 8 9 . _ -
```

  Almost all file systems in common usage support this character set. They are also not shell special characters, and don’t cause word splitting.

</li>

<li>

  Filenames <em>should not</em> start with a hyphen (`-`).

  A hyphen indicates setting options in many command-line programs, making names starting with one difficult to work with in many applications.

  Also, many applications interpret a single hyphen in place of a filename as an indication to read data from the standard input stream.

</li>

<li>

  Filenames <em>should not</em> end with a period (`.`).

  Microsoft Windows generally does not allow names ending with a period. This restriction can be worked around, but doing so causes problems with many Windows programs.

  In addition, most operating systems and transfer protocols use the name `.` to represent the current directory and `..` to represent the directory above.

  Names <em>may</em> <em>start</em> with a period, but note that this will cause the file or directory to be “hidden,” or not shown by default, on Unix-like systems (or on Windows, if a certain Git config is set).

</li>

<li>

  Filenames <em>should</em> match this regular expression:

```Regular-Expression
^(.*/)?(([A-Za-z0-9_.][A-Za-z0-9_.-]{0,125}[A-Za-z0-9_-])|[A-Za-z0-9_])$
```

  There are some rules listed above which are not implemented in the regular expression, so all valid filenames <em>should</em> match this, but not all matches are valid filenames.

</li>

</ul>
