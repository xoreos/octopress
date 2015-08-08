---
layout: post
title: "xoreos 0.0.2 \"Aribeth\" Released"
date: 2015-07-27 17:00:08 +0200
comments: true
categories: [news, releases]
author: DrMcCoy
---

We are proud to announce our very first release of [xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.2) and [xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.2), version 0.0.2, nicknamed "Aribeth".

While xoreos is still far from being useful to end-users, all targeted games work insofar as that they at least show basic in-game areas. You can start the game, xoreos loads the game resources, loads a campaign or module, and then shows an area of the game. This accurately demonstrates what the xoreos project wants to accomplish.

-> [{% imgcap /screenshots/nwn/ingame06_t.png 256 192 Neverwinter Nights %}](/screenshots/nwn/ingame06.png) [{% imgcap /screenshots/kotor/menu01_t.png 256 192 Knights of the Old Republic %}](/screenshots/kotor/menu01.png) [{% imgcap /screenshots/dao/ingame01_t.png 256 192 Dragon Age: Origins %}](/screenshots/dao/ingame01.png) <-

Within the in-game area, you can fly around in a "spectator" mode, using the common first-person WASD control scheme. Moving the mouse while holding down the middle mouse button rotates the camera. With Ctrl+D, a debug console drops down, allowing for general resource dumping and the loading of different areas, modules and/or campaigns.

A few games, specifically *Neverwinter Nights* and *Knights of the Old Republic*, also show a main menu, although the latter's is not as extensive yet. The former also shows a few in-game menu elements.

Additionally, *Neverwinter Nights* also has a script system hooked up, and preliminary dialogue support. This means that clicking on an NPC opens up its conversation dialog, and some of the script commands will be executed. For example, the door in the first area of the original campaign's prelude opens after speaking to Bim and telling him that no tutorial is necessary. However, triggering the tutorial leads to the scripts looping endlessly, because the necessary game functions are not implemented yet.

Further gameplay is still missing. At the moment, none of the other games have a script system.

The current graphics are very basic: only flat-shaded, textured meshes are shown. No lighting, shadows or shaders of any kind are currently available.

Please note that xoreos is still missing a GUI and needs to be started from the command line.

The accompanying xoreos-tools package includes command line tools that can be used to inspect the games' resource files and, as such, are meant primarily for developers.

Binaries for Windows, GNU/Linux and Mac OS X are attached to the GitHub release, [here for xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.2) and [here for xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.2). Additionally, packages for various GNU/Linux distributions can be found on the OpenSuSE Build Service ([here for xoreos](https://software.opensuse.org/download.html?project=home%3ADrMcCoy%3Axoreos&package=xoreos), [here for xoreos-tools](https://software.opensuse.org/download.html?project=home%3ADrMcCoy%3Axoreos&package=xoreos-tools)) and in Arch Linux's AUR ([here for xoreos](https://aur.archlinux.org/packages/xoreos/), [here for xoreos-tools](https://aur.archlinux.org/packages/xoreos-tools/)).

Alternatively, the repository and the source tarballs contain PKGBUILD files in dists/arch/ and a debian build directory in dists/debian/, which can be used to build Arch Linux and Debian/Ubuntu packages, respectively.

And as always, we're looking for more developers to join us in our efforts to reimplement those 3D BioWare RPGs. If *you* would like to help, please feel free to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us). :)
