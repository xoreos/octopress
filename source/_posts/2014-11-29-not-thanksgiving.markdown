---
layout: post
title: "Not-Thanksgiving"
date: 2014-11-29 12:58
comments: true
categories: [news]
author: DrMcCoy
---

I am not an US-citizen, but nevertheless, I think the time is right for an introspective blog posts about the progress and general state of the xoreos project and what I am thankful for. Oh, and no worries, I'm not throwing the towel here. :)

So, let's start with what has happened: there has been quite some work and changes and fixes under the hood. Not as much as I'd like, and no hugely visible new features yet, but still.

On the code side, we have:

* BZF:
  Added support for BZF archives, used in the [iOS version of Knights of the Old Republic](https://itunes.apple.com/en/app/star-wars-knights-old-republic/id611436052). Basically, these are your standard [BIF archives](https://github.com/xoreos/xoreos-docs/raw/master/specs/bioware/KeyBIF_Format.pdf), but the data inside is compressed using [LZMA](https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Markov_chain_algorithm).
* WMA:
  Fixed a crash in the WMA decoder occurring in some audio files found in the Xbox version Knights of the Old Republic.
* FilePath and FileList cleanup:
  Lots of cleanup and restructuring in these utility classes handling paths, file names and lists of these.
* Rewrote absolutize(), relativize(), normalize(), canonicalize():
  These functions operate on path. They creating absolute paths from relative paths and vice versa, normalized (resolving ambiguities like "/./") or canonicalized (stronger disambiguities including symbolic links) versions. As a result, paths in the config file now properly resolve ~/ to the user's home directory.
* ConfigDir and UserDir:
  Changed the location of the config file on GNU/Linux to $XDG\_CONFIG\_HOME/xoreos/xoreos.conf (i.e. following the [XDG Base Directory Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html)) and on Mac OS X to ~/Library/Preferences/xoreos/xoreos.conf. Likewise, the default log path is now $XDG\_DATA\_HOME/xoreos/xoreos.log on GNU/Linux and ~/Library/Application Support/xoreos/xoreos.log on Mac OS OX. On Windows, but are still in $APPDATA/xoreos/.
* UNUSED:
  Added an UNUSED macro to mark deliberately unused function parameters and enabled the compiler flag to warn about unused function parameters without this macro. This helps find places where the lack of usage was in error.
* Icon:
  Embedded the [xoreos icon](https://github.com/xoreos/xoreos-media/blob/master/icons/svg/icon-grey.svg) into the executable to be displayed in the standard application icon of the operating system.
* Loading progress:
  Added a progress bar [visualizing](images/xoreos_progressbar.png) the game loading stages at startup.
* Split docs / tools repo:
  I split the xoreos-docs repository from the xoreos-tools repository. Both are now clean standalone repositories.

Additionally, I started working on another little tool: [Phaethon](https://github.com/xoreos/phaethon). Phaethon is a graphical resource explorer (using [wxWidgets](https://www.wxwidgets.org/)) for BioWare Aurora engine games, able to look into the archives, extract files, display images and play audio files. It's not yet finished, and there's several things left to implement, including displaying [GFF files](https://github.com/xoreos/xoreos-docs/blob/master/specs/bioware/GFF_Format.pdf). The goal is to have a more user-friendly, GUI companion to the existing [CLI xoreos tools](https://github.com/xoreos/xoreos-tools).

There has also been several improvements on the documentation side of things:

* Clarified the license on our [custom m4 macros](https://github.com/xoreos/xoreos/tree/master/m4):
  They're all released under the terms of the CC0 license now.
* Fixed the wrong-headed BioWare "copyright" notices:
  Instead, we now properly [identify trademarks](https://github.com/xoreos/xoreos/blob/master/AUTHORS#L36) registered and/or used by BioWare and others.
* CONTRIBUTING:
  Added a proper [CONSTRIBUTING.md](https://github.com/xoreos/xoreos/blob/master/CONTRIBUTING.md) file explaining how to contribute to the project.
* Wiki:
  Added articles in [our wiki](https://wiki.xoreos.org/) explaining [how to compile xoreos](https://wiki.xoreos.org/index.php?title=Compiling_xoreos) and [how to run and configure xoreos](https://wiki.xoreos.org/index.php?title=Running_xoreos). Also added a collection of links hopefully providing some [introduction to reverse engineering](https://wiki.xoreos.org/index.php?title=Developer_Central#Reverse_engineering_help).

As you can see, this is quite a list. And that's only half of the story. Leading to what (or, more precisely, *who*) I am thankful for, there's been contributions by several incredible people:

* I am thankful to [ImperatorPrime](https://github.com/ImperatorPrime), for wrangling the [Travis CI](https://travis-ci.org/xoreos/xoreos) integration. This also helped me in setting up a more comfortable, semi-automatic [Coverity Scan](https://scan.coverity.com/projects/544) integration
* I am thankful to [Supermanu](https://github.com/Supermanu), for improving on the Neverwinter Nights GUI code and for continuing to implement the Neverwinter Nights character generator
* I am thankful to [mirv](https://github.com/mirv-sillyfish), for starting to tackle the monumental task of rewriting the graphics subsystem. I'm looking forward to seeing this evolve, so that we can finally put my naive OpenGL code out of its misery
* I am thankful to [clone2727](http://clone2727.blogspot.com/), for all his insights and advice over the years, for always having an open ear for my complaints and rants
* I am thankful to all the other people providing me with help, with tips, bug reports, bug fixes, file format information, existing modding tools, Aurora engine knowledge, complaints, offers to contribute, etc., etc., etc.

There, this is what's happened in the last 7 month since the last blog post; this is the current state of the project. Looking forward, here's hoping that we all continue to find time to work on xoreos, that maybe more people will join us and that together, we can make this project bloom into something wonderful.
