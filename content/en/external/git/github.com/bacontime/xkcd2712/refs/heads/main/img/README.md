The images in this directory are heavily compressed versions of the original images from XKCD.

I used the images from [this google drive folder](https://drive.google.com/drive/folders/1CVADHsRgBtDPYca-gdfVwNW_nEsrJ-zj) as a base.

For the black holes, I created two heavily compressed transparent images. All but one of the black holes just uses a copy of `maw_transparent.png`

For all the other objects, I used the opaque, black-background versions of the images, and converted them to compressed .webp files. 
(GIMP settings were 20 image quality, and 0 alpha quality.)
That's a lot of compression, but these simple stick doodles compress quite nicely.

There were several images that were 16384x16384. Annoyingly, the max dimension size for webp is 16383. For these images, 
I scaled them down 50% before compressing.

With this processing, I was able to reduce the size of the images from 35 MB to 5 MB
