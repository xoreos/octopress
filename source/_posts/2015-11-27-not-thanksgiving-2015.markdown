---
layout: post
title: "Not-Thanksgiving 2015"
date: 2015-11-27 00:06:00 +0100
comments: true
comments: true
categories: [news, progress]
author: DrMcCoy
---

The end of the year is approaching fast, and just like [last year](/blog/2014/11/29/not-thanksgiving/), I want to use this time for some retrospection.

First of all, what happened in the last year?

* [berenm](https://github.com/berenm) [added support for building xoreos with CMake](https://github.com/xoreos/xoreos/pull/57), by the way of parsing the automake files used for the autotools build system. This way, xoreos can now be built with either CMake or autotools. I was skeptical at first, especially since I harbour no love for CMake, but it is working reasonably well and I am quite happy with it. In hindsight, I was wrong to reject this pull request for so long.
* I focused on supporting all the different model formats used in the Aurora games, and then I made all the games display their in-game areas with objects.
* xoreos adopted the [Contributor Covenant](https://github.com/xoreos/xoreos/blob/master/CODE_OF_CONDUCT.md) as its Code of Conduct, in the hopes that it helps foster a friendly and welcoming community.
* The big one: our first official release, [xoreos 0.0.2](/blog/2015/07/27/xoreos-0-dot-0-2-aribeth-released/), nicknamed "Aribeth".
* I overhauled the script system, making it more generic. This way, I was able to apply it to all targeted games, except *Sonic Chronicles: The Dark Brotherhood* (which doesn't seem to use any scripts at all). This included figuring out and implementing four new script bytecode opcodes: two for array access in *Dragon Age: Origins*, and two for reference creation in *Dragon Age II*.
* I implemented reflective environment mapping for *Neverwinter Nights* and the two *Knights of the Old Republic* games.
* I added a new tool to the [xoreos-tools](https://github.com/xoreos/xoreos-tools) package: tlk2xml, which can recreate TLK talk table files out of XML files created by xml2tlk.
* With these changes, I decided to push out [xoreos 0.0.3](/blog/2015/09/30/xoreos-0-dot-0-3-bastila-released/), nicknamed "Bastila".

This is all old news, more or less already discussed in previous blog posts. However, since then, I added yet another new tool to the xoreos-tools package: ncsdis. It's a disassembler for NCS files, the stack-based compiled bytecode of the C-like NWScript, BioWare's scripting language used throughout their Aurora-based games.

It basically replaces the disassembler within the old [OpenKnightsN WScript compiler](https://github.com/DrMcCoy/NWNTools), with various added benefits. I'll write a bit more about this tool in the near future, so for now I'll just leave you with an example [assembly listing](https://gist.github.com/DrMcCoy/a07ccb04fe3f232896e6) it can produce, as well as a [control flow graph](/images/blog/20151127_2443_tr_portal_cl.png) it can create (with the help of [Graphviz](https://en.wikipedia.org/wiki/Graphviz)). As you can see, it already groups the instruction by blocks and subroutines. It performs a static analysis of the stack (to figure out subroutine parameters and return types) and it also analyzes the control flow to detect assorted control structures (loops, if/else). I plan to grow it into a full-fledged NWScript decompiler.

Additionally, I also added support for BioWare's *Neverwinter Nights* premium modules, like [Kingmaker](https://en.wikipedia.org/wiki/Neverwinter_Nights:_Kingmaker), to xoreos.

On the documentation side of things,

* I added comments and documentation to various files in the xoreos sources, hopefully making them more understandable and useful for potential new contributors and otherwise interested people. Considering how awful my memory is at, this is also a kind of future-proofing.
* [Farmboy0](https://github.com/farmboy0) added "research" subpages for various games on our wiki, filling them with information about their workings.
* I extended our [TODO list](https://wiki.xoreos.org/index.php?title=TODO) considerably.
* I added an [example configuration file](https://github.com/xoreos/xoreos/blob/master/doc/xoreos.conf.example), and extended the documentation on the wiki on how to [compile](https://wiki.xoreos.org/index.php?title=Compiling_xoreos) and [run](https://wiki.xoreos.org/index.php?title=Running_xoreos) xoreos.
* I wrote [man pages for each tool in xoreos](https://github.com/xoreos/xoreos-tools/tree/master/man) and [for xoreos itself](https://github.com/xoreos/xoreos/tree/master/man). I also added the former [to the wiki](https://wiki.xoreos.org/index.php?title=Running_xoreos-tools).

Phew! This is again a bigger list than I had anticipated. This wouldn't have been possible without these people, for whom I am thankful:

* I am thankful to [berenm](https://github.com/berenm) for providing the CMake bindings, despite my grumbling about it.
* I am thankful to [Supermanu](https://github.com/Supermanu), for continuing on chipping away on the *Neverwinter Nights* character generator.
* I am thankful to [Farmboy0](https://github.com/Farmboy0), for working on xoreos' Jade Empire engine and researching game internals.
* I am thankful to [mirv](https://github.com/mirv-sillyfish), for continuing with the huge task of rewriting my naive OpenGL code.
* I am thankful to [Coraline Ada Ehmke](https://github.com/CoralineAda/) for creating the Contributor Covenant.
* I am thankful to all the people in the different BioWare modding communities, for having figured out many different things already. [Skywing](https://github.com/SkywingvL/) for example, who had emailed me a few years ago about certain NWScript issues, issues I recently stumbled over again.
* I am thankful to [fuzzie](https://github.com/fuzzie), for giving me pointers on the NCS disassembler/decompiler.
* I am thankful to the [GamingOnLinux](http://www.gamingonlinux.com/) people, who do a lot of work reporting on all sorts of Linux-related gaming news, and who so graciously mirror my xoreos blog posts.
* I am thankful to [kevL](https://github.com/kevL), for notifying me of issues with xoreos' build system on configurations I hadn't thought about.
* I am thankful to [clone2727](http://clone2727.blogspot.com/), for putting up with rants and ravings.
* I am thankful to all the people who told me when I was wrong, for example when [I wrongheadedly silenced clang static analyzer warnings](https://github.com/xoreos/xoreos/commit/bfe06f4c357df2ddaf0ff6ee0b44ef9ff654873c#commitcomment-14211110), without understanding what I was doing.
* I am thankful to everybody else who gave me hints and tips, taught me tricks and procedure, showed me new things, old things, forgotten things, broken things.
* I am thankful to all the people who are not angry with me for forgetting them, because they are aware that this is not meant as a personal slight ;).

Now that I have these mushy feelings out of my system, here's hoping for another great year! :)

And like always, if you want to join our effort, please don't hesitate to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us)!
