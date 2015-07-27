---
layout: post
title: "The Odd One Out: Sonic Chronicles (1/3)"
date: 2015-06-05 02:11:18 +0200
comments: true
categories: [news, progress]
author: DrMcCoy
---

And further down the path of getting all targetted games to show areas I go. Previously, I wrote about my progress with [*The Witcher*](/blog/2015/04/12/the-witcher-models-and-areas/), [*Jade Empire*](/blog/2015/02/15/jade-empire-models-and-areas/) and [*Neverwinter Nights 2*](/blog/2015/02/01/neverwinter-nights-2-areas/). For the next two months, I took a look at the odd one out: the Nintendo DS game [*Sonic Chronicles: The Dark Brotherhood*](https://en.wikipedia.org/wiki/Sonic_Chronicles:_The_Dark_Brotherhood).

Yes, a Nintendo DS game. I wasn't so sure myself that game is actually a "proper" target for xoreos. I'm still not 100% sure, but I know now that it at least does use several BioWare file formats, as well as Nintendo DS formats. I also saw that some of those BioWare formats are used in *Dragon Age: Origins* as well, so *Sonic Chronicles* actually did provide a natural station on my path.

I'll divide my report in three parts. In this post, I'll go a bit into the details of those common BioWare file formats. [In the next post](/blog/2015/06/06/the-odd-one-out-sonic-chronicles-2-slash-3/), I cover the graphics (that are mostly Nintendo formats). [And the third post](/blog/2015/06/07/the-odd-one-out-sonic-chronicles-3-slash-3/) will show how I tied it all together in xoreos.

So, onwards to the BioWare formats.

### GFF4 ###

GFF is BioWare's "General File Format", which is used as the basis for many things in BioWare games. It's an old format, already found in the Infinity Engine, but not quite as complex yet. (**Correction:** It seems I misremembered there; GFF is not used in the Infinity Engine. I apologize for this mistake.) Conceptually, it is comparable to [XML](https://en.wikipedia.org/wiki/XML)<sup>[1](#footnote_205150605_1_1)</sup>: hierarchical data, organized in a tree-like fashion, able to hold basically everything. As such, it's used to describe areas, characters, items, dialogues, ... Unlike XML, however, GFF is a binary format, not directly human-readable.

Since GFF is such an important format, xoreos already implemented a reader (thanks to [BioWare releasing specifications for the Neverwinter Nights toolset](https://github.com/xoreos/xoreos-docs/tree/master/specs/bioware). And we provide [a tool to convert them into XML](https://github.com/xoreos/xoreos-tools) for easier readability, too. It was only, however, for versions 3.2 (used by *Neverwinter Nights*, *Neverwinter Nights 2*, *Knights of the Old Republic*, *Knights of the Old Republic 2* and *Jade Empire*) and 3.3 (used by *The Witcher*). But *Sonic Chronicles*, *Dragon Age: Origins* and *Dragon Age 2* needed a reader for versions 4.0 and 4.1 -- and boy did they change the format.

You see, after converting the GFF3 to XML, the whole thing is really quite readable and understandable. Every tag has a full string as a name, making the uses and intentions clear. But from the game's perspective, this has a huge drawback: it's slow. Strings are unwieldy, slow to read and compare, and variable length items are generally a pain when you want to quickly jump to a specific field. To curb that, GFF4 removes those pesky strings. Instead, fields use a single 32-bit integer as their "name", making comparisons easy as pie.

-> [{% imgcap /images/blog/20150605_gff3_t.png 256 173 GFF3 as XML %}](/images/blog/20150605_gff3.png) [{% imgcap /images/blog/20150605_gff4_t.png 256 173 GFF4 as XML %}](/images/blog/20150605_gff4.png) <-

Lucky for me, the new GFF4 format is already documented [on the Dragon Age Toolset Wiki](http://social.bioware.com/wiki/datoolset/index.php/GFF). The huge amount of example files provided by the two *Dragon Age* games and *Sonic Chronicles* gave me ample opportunities to test out corner cases as well. Easy. The gff2xml tool mentioned above now supports GFF4 as well.

<a name="footnote_205150605_1_1">[1]</a> In fact, BioWare generates their GFF4 files out of XML, as can be seen from the *Dragon Age: Origins* toolset.

### TLK ###

Next up, I saw a new TLK format used in Sonic. TLK is a "talktable", a list of strings indexed by a numerical ID. The idea is that you have all text used in the game in one place, easy to use and easy to translate. Already used in Neverwinter Nights, xoreos has a reader for it already. It's relatively simple, too.

However, the new format is quite different. In fact, it's a GFF4! I did say that you can basically stick everything in a GFF, right? That's what they did for *Sonic Chronicles* (and the two *Dragon Age* games). With the new GFF4 reader, adding GFF4'd TLK support was quick and painless.

### GDA ###

Just like the GFF4'd TLK, GDA is an old friend in GFF4 suit. This time, it's 2DA: a 2 dimensional array, a table if you will. If you're still lost, think Excel spreadsheet, a simple collection of data organized on a grid.

2DAs are used to, for example, specify the models of different objects. The GIT file describing objects in an area would say "Here's an object, we call it Chair, it has Appearance 179". The game then looks into appearances.2da, at row 179 and column "ModelName", grab that filename there and load it as the object's model.

GDA is, essentially, just the same thing as GFF4. A list of columns giving their name and type, and a list of rows with the data for each column. **However**... While real 2DA have an actual column name (the "ModelName", for example), making guessing the meaning easy, GDA don't actually store a name. They store a [hash](https://en.wikipedia.org/wiki/Hash_function) of the name (specifically, the CRC32 of the UTF-16LE encoded string in all lowercase), a number that's meaningless in and of itself.

There's 845 unique hashes in the GDA files found in Sonic. There's no real way to turn them back into readable strings, but there's a certain trick I could apply: a [dictionary attack](https://en.wikipedia.org/wiki/Dictionary_attack). I got myself a huge list of words found in a dictionary, hashed them, and compared the hashes. Then I extracted all strings I could find in the game (from the GFFs, mostly), and did the same. Then I combined the words of these lists. Then I combined matches. Each time, I manually went through the list to kick out the many, many false positives: strings that hashed to a valid number, but that don't make sense in the context of the game ("necklessnoflyzone", "rareuniquemummifications", "properlyunsmoked").

Phew, that was a lot of tedious work. Still, I managed to find the source strings for 534 of those 845 hashes, 63%. Sure, there's still 311 missing, but that'll have to wait for later.


And that's it for the common BioWare file formats. [Tune in next time when I go over the graphical formats.](/blog/2015/06/06/the-odd-one-out-sonic-chronicles-2-slash-3/)
