---
layout: post
title: "xoreos 0.0.6 \"Elanee\" Released"
date: 2020-08-03 15:00:00 +0200
comments: true
categories: [news, releases, progress]
author: DrMcCoy
---
As a belated 10th birthday (yes, xoreos is 10 years old now), here's a new release of xoreos! It's xoreos 0.0.6, nicknamed "Elanee", including [xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.6), [xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.6) and [Phaethon](https://github.com/xoreos/phaethon/releases/tag/v0.0.6).

In xoreos proper, the most visible change is in *Knights of the Old Republic*: [seedhartha](https://github.com/seedhartha) has put a lot of work into making the tutorial partially playable! The player character can collect their belongings, put on their gear, let Trask open the first door, open the second door and engage in mock combat.

You can see it in action in this video here:

-> {% youtube oxNPYHSE60A 640 360 %} <-

Under the hood, the code for *Knights of the Old Republic* and *Knights of the Old Republic II* was fundamentally restructured to build off a common base, so a lot of the underlying concepts in the first game are also available in the second, but are not as visible. You can, however, skip the prologue in *Knights of the Old Republic II* to watch your player character awaken in the Peragus mining facility and trigger a few early interactions.

Watch it in this video here:

-> {% youtube Njjs7ukE1_c 640 360 %} <-

The only other game where something has happened visibly is *Jade Empire*: you can now run through a preliminary character generation and listen to area background music.

User-invisible changes include:

- Partial implementations of ActionScript and Scaleform GFx for *Dragon Age* menus, thanks to [Nostritius](https://github.com/Nostritius)
- Partial implementations of XACT WaveBanks and SoundBanks for *Jade Empire*
- Partial implementations of FMOD SampleBanks and Events for *Dragon Age: Origins*, the latter thanks to [Nostritius](https://github.com/Nostritius)
- Partial implementations of Wwise SoundBanks for *Dragon Age II*
- WebM (Matroska + VPx) support for the Enhanced Edition of *Neverwinter Nights*, thanks to [clone2727](https://github.com/clone2727)
- Support for big-endian GFF4 files found in console ports
- Support for resource files found in mobile ports
- Support for more *Neverwinter Nights 2* structures, thanks to [rjshae](https://github.com/rjshae)

-> {% youtube 9OmHLipK8Sw 640 360 %} <-

xoreos and xoreos-tools now require a C++11-capable compiler, in an attempt to modernize a bit. This should hopefully not be a huge problem. Phaethon already required a C++14-capable compiler the last release; this has not changed.

This leads us to the news in xoreos-tools: the xoreos-tools package has gained nine new tools, most of them thanks to [Nostritius](https://github.com/Nostritius). These tools are: unobb, untws, rim, keybif, tws, fixnwn2xml, xml2gff, fev2xml and ncsdecomp.

The first two new tools, unobb and untws, are new archive unpackers. unobb extracts "obb" files found in Aspyr's Android and iOS ports of the BioWare games, which can be either plain ZIP files or, more interesting, a virtual filesystem. untws extracts save files from *The Witcher*.

The next three tools, rim, keybif and tws are archive packers. rim is the counterpart to unrim, creating RIM archives. keybif is the counterpart to unkeybif, creating KEY/BIF archives (and lzma-compressed KEY/BZF archives found in Aspyr's mobile ports). However, V1.1 files for *The Witcher* are not yet supported. And lastly, tws, is the counterpart to the new untws tool, creating save files for The *Witcher*.

Next up, fixnwn2xml takes the non-standard XML files in *Neverwinter Nights 2* and turns them into valid, standards-compliant XML files. This tool is thanks to [rjshae](https://github.com/rjshae), based on [asr1](https://github.com/asr1)'s work, reworking it to fit better into our stream classes.

xml2gff is the counterpart to gff2xml, taking an XML file and turning it back into a GFF. Only GFF3 (GFF V3.2/V3.3) are supported for now, so neither *Sonic Chronicles: The Dark Brotherhood* nor the *Dragon Age* games (which use GFF V4.0/V4.1) are supported at the moment.

Another work-in-progress tool is fev2xml, which reads the FMOD event file format FEV and creates a human-readable XML file. Only the FEV1 version is supported and then only a fraction of its features.

Likewise, ncsdecomp is the start of an NWScript bytecode decompiler, built on the foundations of our NWScript bytecode disassembler. It's highly experimental and we give no guarantees that it works correctly at all.

In addition to these new tools, there are some new minor features and bugfixes:

- unerf can now extract ERF V2.1
- erf can now create ERF V2.0 and V2.2
- xoreostex2tga now supports animated TPCs and swizzled Xbox SBMs
- gff2xml now supports SAC files and big-endian GFF4s
- tlk2xml now supports big-endian GFF4s
- The character encoding matrix for *Jade Empire* is now correct

As for Phaethon, the 0.0.6 version of Phaethon is mostly a "maintenance release", keeping the foundation in sync with xoreos. There are no major new features. There are, however, a number of smaller bug fixes. Also, Phaethon can now open ERF V2.1 files and display swizzled Xbox SBM images. Additionally, BIF files can be inspected directly, even when no corresponding KEY file can be found (this does mean, though, that the filenames are missing).

To sum it all up: xoreos inched a bit further along, gained more initial implementations useful later on and xoreos-tools hopefully increased its usefulness for modders and spelunkers. Still a lot more to do, a long way to go. But we are, after all, in for the long ride. :)


Sources and binaries for Windows, GNU/Linux and macOS are attached to the GitHub release, [here for xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.6), [here for xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.6) and [here for Phaethon](https://github.com/xoreos/phaethon/releases/tag/v0.0.6).

Additionally, the repository and the source tarballs contain PKGBUILD files in dists/arch/, debian build directories in dists/debian/ and spec files in dists/fedora, which can be used to build Arch Linux, Debian/Ubuntu and Fedora packages, respectively. Alternatively, the PKGBUILD files are also in Arch Linux’s AUR ([here for xoreos](https://aur.archlinux.org/packages/xoreos/), [here for xoreos-tools](https://aur.archlinux.org/packages/xoreos-tools/), [here for Phaethon](https://aur.archlinux.org/packages/phaethon/)), and we have a [Gentoo overlay](https://github.com/xoreos/gentoo-overlay).

And as always, we’re looking for more developers to join us in our efforts to reimplement those 3D BioWare RPGs. If *you* would like to help, please feel free to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us). :)
