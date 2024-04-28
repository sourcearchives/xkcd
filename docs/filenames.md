<!-- SPDX-License-Identifier: CC0-1.0 OR 0BSD -->
# <i>xkcd</i> archive &ndash;&nbsp;filenames

Filenames <em>should</em> only use characters in the  [Portable Filename Character Set](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_282):

```Text
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
a b c d e f g h i j k l m n o p q r s t u v w x y z
0 1 2 3 4 5 6 7 8 9 . _ -
```

Filenames <em>should</em> match this regular expression (currently a bit buggy):

```Regular-Expression
([A-Za-z0-9_.][A-Za-z0-9_.-]{0,125}[A-Za-z0-9_-])|([A-Za-z0-9_])
```
