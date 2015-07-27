---
layout: post
title: "The Odd One Out: Sonic Chronicles (2/3)"
date: 2015-06-06 01:42:26 +0200
comments: true
categories: [news]
author: DrMcCoy
---

(This is part 2 of 3 of my report about the progress on *Sonic Chronicles*. [Part 1 can be found here.](/blog/2015/06/05/the-odd-one-out-sonic-chronicles-1-slash-3/) [Part 3 can be found here.](/blog/2015/06/07/the-odd-one-out-sonic-chronicles-3-slash-3/))

After having implemented readers for the common BioWare formats, I turned to the graphics formats. They're, for the most part, stock Nintendo DS formats, which means I could build upon detective work from the Nintendo modding scene. I have to thank three people in particular: [Martin Korth](http://problemkaputt.de/), of [NO$GBA](http://problemkaputt.de/gba.htm) fame, whose [GBATEK documentation](http://problemkaputt.de/gbatek.htm) is invaluable, [lowlines](http://llref.emutalk.net/) who figured out much of the [gory details of Nintendo's formats](http://llref.emutalk.net/docs/) and pleoNeX, whose GPLv3-licensed tool [Tinke](https://github.com/pleonex/tinke) provided the base on which I implemented my code.

### SMALL ###

When I looked over the files inside the *Sonic Chronicles* archives, I noticed a peculiar thing. There's a lot of files with names ending in ".small". I suspected a compression scheme, especially after examining the files in a hexeditor. And sure enough, there are several compression algorithms provided by the Nintendo DS firmware. The one used by *Sonic Chronicles* is an LZSS variant, which can be decompressed using [barubary's MIT-licensed dsdecmp tool](https://code.google.com/p/dsdecmp/) ([GitHub mirror](https://github.com/gravgun/dsdecmp)). I pulled the decompressor into xoreos.

### NSBTX ###

The first graphics format in *Sonic Chronicles* I inspected was [NSBTX](http://llref.emutalk.net/docs/?file=xml/btx0.xml#xml-doc). NSBTX files are texture; or rather: archives of several textures used by a single model each. Implementing the reading of these was simple enough, and I added a small program to [our tools collection](https://github.com/xoreos/xoreos-tools) that can "extract" them into TGAs.

-> [{% imgcap /images/blog/20150606_nsbtx1.png 128 64 Hill %}](/images/blog/20150606_nsbtx1.png) [{% imgcap /images/blog/20150606_nsbtx2.png 64 64 Boar %}](/images/blog/20150606_nsbtx2.png) [{% imgcap /images/blog/20150606_nsbtx3.png 64 64 Tails %}](/images/blog/20150606_nsbtx3.png) <-

### NFTR ###

Next up, I wanted to see the fonts, [NFTR](http://romxhack.esforos.com/fuentes-nftr-de-nds-t67), used in the game. They're bitmap fonts, with each glyph an image. The image can be 1-bit black and white, or it can be greyscale for anti-aliasing, shadowing or outlining purposes. Additionally, there's mapping tables to translate a code point in a certain encoding ([UTF-16](https://en.wikipedia.org/wiki/UTF-16), [UTF-32](https://en.wikipedia.org/wiki/UTF-32), [CP1252](https://en.wikipedia.org/wiki/Windows-1252) or [Shift-JIS](https://en.wikipedia.org/wiki/Shift_JIS)) into the index of the glyph it represents. 

There was a bit of trial and error involved, as the documentation and existing FLOSS projects to display the fonts weren't quite correct in certain details (which might not even be their fault; Nintendo likes to subtly change formats between firmware versions). But, before long, I could print arbitrary strings in these fonts in xoreos.

-> [{% imgcap /images/blog/20150606_nftr_t.png 256 299 Font drawing test %}](/images/blog/20150606_nftr.png) <-

### NBFS/NBFP ###

*Sonic Chronicles* comes with a few NBFS files, which is a dead-simple raw format: 8-bit paletted image data, with the palette (in [16-bit RGB555](https://en.wikipedia.org/wiki/High_color) values) in an NBFP file of the same name. They're mostly used for images spanning a whole Nintendo DS screen.

-> [{% imgcap /images/blog/20150606_nbfs1.png 256 192 Mini map %}](/images/blog/20150606_nbfs1.png) [{% imgcap /images/blog/20150606_nbfs2.png 256 192 Conversation card %}](/images/blog/20150606_nbfs2.png) <-

### NCGR/NCLR ###

The main image format used in *Sonic Chronicles*, however, was still missing: [NCGR](http://llref.emutalk.net/docs/?file=xml/ncgr.xml#xml-doc). As I went along implementing a reader, I learned these ugly facts:

- The palettes are in separate [NCLR](http://llref.emutalk.net/docs/?file=xml/nclr.xml#xml-doc) files that are shared among NCGR
- Most of the images are made up of several NCGR files, arranged on a grid
- The NCGR image data itself is made up of 8x8 pixel tiles

Essentially, this image of Sonic is divided into these parts:

-> [{% imgcap /images/blog/20150606_ncgr1.png 128 192 Sonic %}](/images/blog/20150606_ncgr1.png) [{% imgcap /images/blog/20150606_ncgr2.png 132 196 NCGR cells %}](/images/blog/20150606_ncgr2.png) [{% imgcap /images/blog/20150606_ncgr3.png 145 217 NCGR tiles %}](/images/blog/20150606_ncgr3.png) <-

This all makes assembling the final image a bit...ugly. But hey, I made it work in the end.

...except for one thing: a few of the NCGR files don't specify their width and height. By fiddling with the values a bit, I managed to find these values manually, but the resulting image looks off: it's as if the image is supposed to be rearranged afterwards, different pieces drawn at different places. Each of those file also has an [NCER](http://llref.emutalk.net/docs/?file=xml/ncer.xml#xml-doc) file with the same name. I assume that means information on how to draw these NCGR are within the NCER. A thing for the TODO pile.

### NSBMD ###

I then went for the big one: the 3D model format [NSBMD](http://llref.emutalk.net/docs/?file=xml/bmd0.xml#xml-doc). This involved a lot of fiddling, guessing and trial-and-error, as the documentation of these formats is sparse, and oftentimes wrong.

Conceptually, an NSBMD file consists of these parts:

- Bones
- Bone commands
- Materials
- Polygons
- Polygon commands

A bone consists of a name and a transformation that displaces it from its (at that point unknown) parent bone. They are stored as a flat list. The bone commands then specify how the bones connect together. And they give each bone a location in the Nintendo DS's matrix stack (a list of [transformation matrices](https://en.wikipedia.org/wiki/Transformation_matrix) containing the absolute transformation of each bone at the time of rendering).

-> [{% imgcap /images/blog/20150606_nsbmd_bones1_t.png 256 170 Broken boar skeleton %}](/images/blog/20150606_nsbmd_bones1.png) [{% imgcap /images/blog/20150606_nsbmd_bones2_t.png 256 170 Getting there... %}](/images/blog/20150606_nsbmd_bones2.png) [{% imgcap /images/blog/20150606_nsbmd_bones3_t.png 256 170 Correct boar skeleton %}](/images/blog/20150606_nsbmd_bones3.png) <-

The material contains the texture name (which reference textures inside the NSBTX with the same name as the NSBMD), and a few properties.

Each polygon can use a single material, and contains a list of polygon commands. These polygon commands produce the actual geometry. They set color, normal and texture coordinates, and generate vertices. They also manipulate the matrix stack, specifically replacing the working matrix with the matrix from the stack position of certain bones. In essence, this bases the vertices on the position of the bone.

-> [{% imgcap /images/blog/20150606_nsbmd_polygons1_t.png 256 170 No. %}](/images/blog/20150606_nsbmd_polygons1.png) [{% imgcap /images/blog/20150606_nsbmd_polygons2_t.png 256 170 Boar with holes %}](/images/blog/20150606_nsbmd_polygons2.png) [{% imgcap /images/blog/20150606_nsbmd_polygons3_t.png 256 170 Correct boar %}](/images/blog/20150606_nsbmd_polygons3.png) <-

While the Nintendo DS interprets the polygon commands on-the-fly while rendering, and while they can be nearly directly converted to OpenGL-1.2-era glBegin()/glEnd() blocks, this is not really want we want to do. So instead, we, while loading, interpret the polygon commands into an intermediate structure.

-> [{% imgcap /images/blog/20150606_nsbmd1_t.png 256 170 Sonic %}](/images/blog/20150606_nsbmd1.png) [{% imgcap /images/blog/20150606_nsbmd2_t.png 256 170 Amy %}](/images/blog/20150606_nsbmd2.png) [{% imgcap /images/blog/20150606_nsbmd3_t.png 256 170 Tails %}](/images/blog/20150606_nsbmd3.png) <-

The result is a relatively massive loader for these files, and that doesn't yet include support for animations.

One interesting anecdote: the Nintendo DS doesn't use [floating-point numbers](https://en.wikipedia.org/wiki/Floating_point) to represent real numbers, but various formats of [fixed-point numbers](https://en.wikipedia.org/wiki/Fixed-point_arithmetic). Those are found extensively in the NSBMD files. But when I implemented the GFF4 format earlier (see [part 1 of my *Sonic Chronicles* progress report](/blog/2015/06/05/the-odd-one-out-sonic-chronicles-1-slash-3/)), I found, in the GFF4 files used by *Sonic Chronicles*, a field type not described in the *Dragon Age* toolset wiki. Turns out, those are Nintendo DS fixed-point numbers!

### CBGT/PAL and CDPTH ###

With those pesky models out of the way, I was ready to show the areas, right? Wrong. There's yet another graphics format in *Sonic Chronicles*: CBGT, used for the area background images.

However, CBGT isn't a Nintendo format. No, it's one of BioWare's creation. It does, though, take inspiration from the Nintendo DS formats. It consists of blocks of 64x64 pixels, each compressed using the LZSS algorithm found in SMALL files, and each block divided into 8x8 pixel tiles. PAL files of the same name carry palettes, with each CBGT able to use a different palette within the PAL.

Since I already knew how to puzzle together those cells and tiles from the NCGR format, getting the image itself was not a problem. But I was at a loss where to get the dimensions of the image from, and how to distribute the palettes onto the cells. I figured out an algorithm for the latter, that worked for *nearly* all images, but the outliers still annoyed me. Then it hit me: for each CBGT/PAL pair, there's a third file: a 2DA. And that one contains the information which cell uses which palette, neatly organized in a 2D table exactly how the cells are arranged in the final image. This, of course, is enough to calculate the final image dimensions as well.

-> [{% imgcap /images/blog/20150606_cbgt1_t.png 255 188 Wrong palette distribution %}](/images/blog/20150606_cbgt1.png) [{% imgcap /images/blog/20150606_cbgt2_t.png 255 188 Correct palette distribution %}](/images/blog/20150606_cbgt2.png) <-

I also found a fourth file for nearly each CBGT/PAL/2DA tuple: a CDPTH. Arranged in a similar fashion to the CBGT, it contains 16-bit depth information for each area background. This is used to let certain background pieces draw over the 3D models in the game, when they should appear behind something.

-> [{% imgcap /images/blog/20150606_cdpth_t.png 255 188 Depth values %}](/images/blog/20150606_cdpth.png) <-

*Now* I was ready to implement actual *Sonic Chronicles* stuff. [I'll describe that in part 3](/blog/2015/06/07/the-odd-one-out-sonic-chronicles-3-slash-3/).
