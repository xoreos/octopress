---
layout: post
title: "xoreos 0.0.4 \"Chodo\" Released"
date: 2016-02-01 00:00:00 +0100
comments: true
categories: [news, releases]
author: DrMcCoy
---

A new year, a new release: we are proud to announce the release of version 0.0.4, nicknamed "Chodo", of [xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.4) and [xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.4).

In this release, Neverwinter Nights now shows speech bubbles for conversation one-liners, as used for cutscenes, bark strings and short NPC dialogues. Additionally, the premium modules BioWare sold for Neverwinter Nights, including the three that come with the Diamond Edition, can now be properly loaded and started.

-> [{% imgcap /images/blog/20160201_bubbles_t.png 256 170 Speech bubbles %}](/images/blog/20160201_bubbles.png) <-

An oversight in the handling of the texture fonts used in Neverwinter Nights and the two Knights of the Old Republic games has been fixed. This oversight broke rendering of certain characters, most prominently of those used in eastern European languages and the "smart" single quotation mark that's used instead of an apostrophe in some strings found in the French versions.

For xoreos-tools, there's two new tools: fixpremiumgff and ncsdis.

The first tool, fixpremiumgff, can restore the deliberately broken GFF files found in the BioWare premium modules for Neverwinter Nights. The resulting GFF files can then be edited as normal.

The second tool, ncsdis, is [a disassembler for the stack-based bytecode of BioWare's NWScript scripting language](/blog/2016/01/12/disassembling-nwscript-bytecode/). It supports the scripts of all games targeted by xoreos and can disassemble them into a full assembly listing.  It can also produce a control flow graph in the DOT description language, which can then be plotted into an image by using the dot tools from the [GraphViz suite](http://graphviz.org/).

Moreover, this release includes a lot of user-invisible code documentation and quality fixes, in both xoreos and xoreos-tools.

Binaries for Windows, GNU/Linux and Mac OS X are attached to the GitHub release, [here for xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.4) and [here for xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.4). Additionally, packages for various GNU/Linux distributions can be found on the OpenSuSE Build Service ([here for xoreos](https://software.opensuse.org/download.html?project=home%3ADrMcCoy%3Axoreos&package=xoreos), [here for xoreos-tools](https://software.opensuse.org/download.html?project=home%3ADrMcCoy%3Axoreos&package=xoreos-tools)) and in Arch Linux's AUR ([here for xoreos](https://aur.archlinux.org/packages/xoreos/), [here for xoreos-tools](https://aur.archlinux.org/packages/xoreos-tools/)).

Alternatively, the repository and the source tarballs contain PKGBUILD files in dists/arch/ and a debian build directory in dists/debian/, which can be used to build Arch Linux and Debian/Ubuntu packages, respectively.

And as always, we're looking for more developers to join us in our efforts to reimplement those 3D BioWare RPGs. If *you* would like to help, please feel free to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us). :)
