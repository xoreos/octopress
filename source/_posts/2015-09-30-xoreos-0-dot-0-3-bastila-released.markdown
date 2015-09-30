---
layout: post
title: "xoreos 0.0.3 \"Bastila\" Released"
date: 2015-09-30 15:30:00 +0200
comments: true
categories: [news, releases]
author: DrMcCoy
---

To keep things moving following the [previous 0.0.2 release](/blog/2015/07/27/xoreos-0-dot-0-2-aribeth-released/), we're proud to announce the release of version 0.0.3, nicknamed "Bastila", of [xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.3) and [xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.3).

This release features a working script system for all targeted games, with game scripts being fired for the start of a campaign or module, when entering and leaving areas, and when clicking on in-game object. The singular exception is the Nintendo DS game *Sonic Chronicles: The Dark Brotherhood*, which doesn't seem to feature any scripts at all.

The vast majority of engine functions, the functions that are called by the scripts and that do the actual work of tracking and changing the game state, are still missing, though. Per game there are about 850 functions (with some overlap) that need to be implemented. We currently have about 90, per game, of these written and working within xoreos. Moreover, many of the functions still missing depend on features not yet implemented.

Apart from the script system changes, 0.0.3 also comes with support for reflective environment mapping in *Neverwinter Nights* and the two *Knights of the Old Republic* games. The "metallic" armor and area parts that were rendered transparent in xoreos are now properly reflective. This can be seen, for example, in the Sith troopers in *Knights of the Old Republic*, in various plate armor worn by NPC in *Neverwinter Nights*, as well as the metallic floors on the planet of Taris and the icy wastes of Cania. For *Neverwinter Nights*, xoreos now also correctly smoothes the vertex normals of (binary) models, so that the metallic effect is not broken by sharp polygon edges.

-> [{% imgcap /images/blog/20150930_kotor1_t.png 256 170 Semi-transparent mask %}](/images/blog/20150930_kotor1.png) [{% imgcap /images/blog/20150930_kotor2_t.png 256 170 Plus reflectivity %}](/images/blog/20150930_kotor2.png) [{% imgcap /images/blog/20150930_kotor3_t.png 256 170 Correctly rendered Sith trooper %}](/images/blog/20150930_kotor3.png) <-

-> [{% imgcap /images/blog/20150930_nwn1_t.png 256 170 Without environment map %}](/images/blog/20150930_nwn1.png) [{% imgcap /images/blog/20150930_nwn2_t.png 256 170 Without normal smoothing %}](/images/blog/20150930_nwn2.png) [{% imgcap /images/blog/20150930_nwn3_t.png 256 170 Correctly rendered plate armor %}](/images/blog/20150930_nwn3.png) <-

On the xoreos-tools side of things, there's now a new xml2tlk tool that can convert XML files created by the tlk2xml tool back into a talk table TLK file. Please note that, at the moment, only non-GFF'd TLK files can be written, as used by the two *Neverwinter Nights* games, the two *Knights of the Old Republic* games, *Jade Empire* and *The Witcher*. TLK files as used by *Sonic Chronicles: The Dark Brotherhood* and the two *Dragon Age* games can not be written (they can, however, be read with the tlk2xml tool).

Additionally, the convert2da tool gained the ability to write binary 2DA files, as used by the two *Knights of the Old Republic* games; and xoreostex2tga can now correctly read TPC cube maps.

Binaries for Windows, GNU/Linux and Mac OS X are attached to the GitHub release, [here for xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.3) and [here for xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.3). Additionally, packages for various GNU/Linux distributions can be found on the OpenSuSE Build Service ([here for xoreos](https://software.opensuse.org/download.html?project=home%3ADrMcCoy%3Axoreos&package=xoreos), [here for xoreos-tools](https://software.opensuse.org/download.html?project=home%3ADrMcCoy%3Axoreos&package=xoreos-tools)) and in Arch Linux's AUR ([here for xoreos](https://aur.archlinux.org/packages/xoreos/), [here for xoreos-tools](https://aur.archlinux.org/packages/xoreos-tools/)).

Alternatively, the repository and the source tarballs contain PKGBUILD files in dists/arch/ and a debian build directory in dists/debian/, which can be used to build Arch Linux and Debian/Ubuntu packages, respectively.

And as always, we're looking for more developers to join us in our efforts to reimplement those 3D BioWare RPGs. If *you* would like to help, please feel free to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us). :)
