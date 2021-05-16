# About
This docker contains a set of tools for compressing and optimize images in many formats with high results, it also includes [GNU parallel](https://www.gnu.org/software/parallel/).

## Tools included until now
* [Leanify](https://github.com/JayXon/Leanify) - Leanify is a lightweight lossless file minifier/optimizer. It removes unnecessary data (debug information, comments, metadata, etc.) and recompress the file to reduce file size. It will not reduce image quality at all.
* [Efficient Compression Tool](https://github.com/fhanau/Efficient-Compression-Tool)- Efficient Compression Tool (or ECT) is a C++ file optimizer. It supports PNG, JPEG, GZIP and ZIP files.
* [Gifsicle](https://github.com/kohler/gifsicle) - Gifsicle manipulates GIF image files. Depending on command line options, it can merge several GIFs into a GIF animation; explode an animation into its component frames; change individual frames in an animation; turn interlacing on and off; add transparency; add delays, disposals, and looping to animations; add and remove comments; flip and rotate; optimize animations for space; change images' colormaps; and other things.

## Usage

``` shell
docker run -v $PWD:/data skhaz/compression-tools:latest
```

### Credits
A huge thanks to [ajshell1](https://www.reddit.com/r/commandline/comments/e8cuen/ask_whats_the_best_tools_for_optimizing_jpeg_png/faavg2t/).
