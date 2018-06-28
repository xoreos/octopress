---
layout: post
title: "xoreos 0.0.5 \"Dawn Star\" Released"
date: 2018-07-03 16:50:00 +0200
comments: true
categories: [news, releases, progress]
author: DrMcCoy
---

Fashionably (?) late, but still finally there, a new release of xoreos arrives! xoreos 0.0.5, nicknamed "Dawn Star", coming with [xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.5), [xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.5) and for the first time, [Phaethon](https://github.com/xoreos/phaethon/releases/tag/v0.0.5), an in-progress graphical resource explorer.

A lot has happened in the last two years. A busy real life unfortunately made me miss the yearly "Not-Thanksgiving" progress report last year...so this here will be a kind of combination release post and progress report. Buckle up, this will be a long one. If you're only interested in the short release notes, move on to the GitHub release pages linked above and again at the bottom of the post. Cool? Cool.

So, continuing from [the last progress report in 2016](/blog/2016/11/24/not-thanksgiving-2016/), what exactly has happened?

Back then, I said I was working on unit tests for xoreos, planning to make them public in December. [I did that](https://github.com/xoreos/xoreos/pull/133), and then merged them in February 2017. Since then, several more have been added and bugs were found (and prevented) with them. I consider them a huge success and a boon to the codebase. However, the coverage is nowhere near 100%. [Pull requests](https://github.com/xoreos/xoreos/pulls) adding new unit tests to existing code are always welcome ;).

Soon after, I took another stab at one variant of the texture format in *Jade Empire*, used for lightmaps. I had previously tried to figure it out, but failed. But with the added knowledge of the textures in the Xbox version of *Knights of the Old Republic*, which are swizzled [\*], I realized that the lightmaps in *Jade Empire* are also swizzled. They're even swizzled in the same way, so I could just reuse the deswizzling code, and voilà, now that texture variant is correctly read.

-> [{% imgcap /images/blog/20180703_texture_swizzled.png 128 128 Swizzled texture %}](/images/blog/20180703_texture_swizzled.png) [{% imgcap /images/blog/20180703_texture_deswizzled.png 128 128 Deswizzled texture %}](/images/blog/20180703_texture_deswizzled.png) <-

([\*] Swizzling changes how the pixels of the image are stored. Usually, pixels are stored linearly, from left to right, from top to bottom. This is not necessarily ideal for GPUs, though, because GPUs like it when things that are displayed near each other are also stored near each other ([spacial locality](https://en.wikipedia.org/wiki/Locality_of_reference)). And while the pixels left and right of a pixel are near each other, the pixels above and below are not. Therefore, swizzled textures store pixels in a sort of zig-zag order. The [Z-order curve](https://en.wikipedia.org/wiki/Z-order_curve) is a popular scheme for that.)

Next up, Farmboy0 and Nostritius both worked on the GUI systems in *Jade Empire* and the two *Knights of the Old Republic* games. *Jade Empire* now has a partially working main menu (with dressupgeekout submitting pull requests to [make the "Exit" button work](https://github.com/xoreos/xoreos/pull/277) and [enabling background music](https://github.com/xoreos/xoreos/pull/272)), and the *Knights of the Old Republic* games gained character creators and partial in-game menus.

-> [{% imgcap /images/blog/20180703_jade_menu_t.png 256 192 Jade Empire main menu %}](/images/blog/20180703_jade_menu.png) [{% imgcap /images/blog/20180703_kotor_chargen_t.png 256 192 KotOR character generator %}](/images/blog/20180703_kotor_chargen.png) [{% imgcap /images/blog/20180703_kotor2_chargen_t.png 256 192 KotOR2 character generator %}](/images/blog/20180703_kotor2_chargen.png) <-

Speaking of *Knights of the Old Republic*, these two games are progressing quite a bit, thanks to seedhartha. They now have a fully working animation system, PC movement (with walkmesh evaluation based on [Supermanu's work](https://github.com/xoreos/xoreos/pull/211)) and even initial dialogues. In fact, the first game already shows a semblance of the first few minutes of tutorial on the Endar Spire, with your bunk mate telling you grab your gear from a chest and equip it.

-> {% youtube gh7shS90wSw 640 480 %} <-

For the *Dragon Age* games, Nostritius implemented an [ActionScript](https://en.wikipedia.org/wiki/ActionScript) interpreter. Together with a renderer for [Adobe Flash](https://en.wikipedia.org/wiki/Adobe_Flash) vector graphics (still work in progress), this will be a reimplementation of [Scaleform GFx](https://en.wikipedia.org/wiki/Scaleform_GFx). Scaleform GFx is used for the user interface, like menus and quickbars, in *Dragon Age: Origins* and *Dragon Age II*. Note that the vector renderer is not yet in the public xoreos codebase and that the screenshot below is more of a proof of concept.

-> [{% imgcap /images/blog/20180703_dao_flash_t.png 256 201 Dragon Age: Origins main menu (WIP) %}](/images/blog/20180703_dao_flash.png) <-

On the xoreos-tools side of things, I added two new tools, ssf2xml and xml2ssf. ssf2xml takes a sound set file (SSF), as used by the two *Neverwinter Nights* and the two *Knights of the Old Republic* games and converts it into a human-readable XML file. xml2ssf is the counterpart, taking an XML file and converting it back into a game-readable SSF file.

Nostritius then added a third new tools, erf, [an ERF packer](https://github.com/xoreos/xoreos-tools/pull/19). It is the counterpart to the already existing unerf tool. Where unerf extracts files from ERF archives, erf takes files and creates a new ERF archive. Unlike the unerf tool, erf currently only supports version V1.0 of the ERF format, as used by *Neverwinter Nights*, the two *Knights of the Old Republic* games. *Jade Empire* and *The Witcher*.

Also on xoreos-tools, cosmo-ray [unified the parameter handling](https://github.com/xoreos/xoreos-tools/pull/8). This massively cuts down on code duplication in the tools and removes a potential source of mistakes.

Moving on to the third package, Phaethon. Phaethon is a graphical resource explorer, able to look into the archives found in the BioWare Aurora games and display several different types of resources. Previous xoreos releases didn't mention it, but it has existed for several years already now. Of course, it's still far from finished and could use more contributors.

-> [{% imgcap /images/blog/20180703_phaethon_t.png 256 196 Phaethon %}](/images/blog/20180703_phaethon.png) <-

In the past, Phaethon used the wxWidgets libraries for the GUI. But I was never really happy with it; I never managed to get widget placement to work consistently across platforms (or even just across different window managers on Linux). I always hoped to rewrite it in Qt some day. Therefore, I was really quite happy that michaelpm54 [did that work for me](https://github.com/xoreos/phaethon/pull/7), rewriting Phaethon to use Qt5.

I'm now far more comfortable providing Phaethon release packages along with xoreos and xoreos-tools. However, due to us using [Verdigris](https://woboq.com/blog/verdigris-qt-without-moc.html) to compile Qt5 applications without moc, Phaethon now requires a C++14-capable compiler. My local cross-compilers, the ones I use to create the binary release packages for Windows and macOS (and the chroot I use to build the Linux packages), didn't have that.  Consequently, I had to update my cross-compilers and chroot.

I did that, and now I can create working binary packages for Phaethon on these operating systems. And this also opens up a path to let C++11 features into the xoreos codebases in the future, something which I had been thinking about for a while now (currently, apart from Verdigris in Phaethon, all of the xoreos codebases are C++03-compliant).

-> {% youtube vInkatsPTB0 640 360 %} <-

On the other hand, also on the packages front, I dropped the openSUSE Build Service (OBS), the service that builds binary packages for a number of Linux distributions. I simply do not have enough time to keep the build specifications there up-to-date. Especially since every time a new distribution release is added, it requires me to invest several days worth of work to get them to build. Anybody willing to take over that task and officially administrate the xoreos OBS specs, please [contact us](https://wiki.xoreos.org/index.php?title=Contact_us).

Last but not least, there were also, of course, a lot of code quality improvements. Many of which were triggered by the introduction of new compiler warnings flags, new compiler instrumentations and static analyzers. I'm really grateful for all the options I have for checking the xoreos codebase, grateful for all the amount of work done by the gcc and clang/llvm people, and all the services offering free access to FLOSS projects.

And that's about it for the past two years. Many improvements, but also still many things left to do. There's several things cooking, but I'd rather not jinx them ;). In either case, I'll try getting out the next release relatively sooner.

-> [{% imgcap /images/blog/20180703_kotor_bastila_t.png 256 192 Meeting Bastila in KotOR %}](/images/blog/20180703_kotor_bastila.png) [{% imgcap /images/blog/20180703_kotor2_handmaidens_t.png 256 192 Meeting the Handmaidens in KotOR2 %}](/images/blog/20180703_kotor2_handmaidens.png) <-

Sources and binaries for Windows, GNU/Linux and macOS are attached to the GitHub release, [here for xoreos](https://github.com/xoreos/xoreos/releases/tag/v0.0.5), [here for xoreos-tools](https://github.com/xoreos/xoreos-tools/releases/tag/v0.0.5) and [here for Phaethon](https://github.com/xoreos/phaethon/releases/tag/v0.0.5).

Additionally, the repository and the source tarballs contain PKGBUILD files in dists/arch/, debian build directories in dists/debian/ and spec files in dists/fedora, which can be used to build Arch Linux, Debian/Ubuntu  and Fedora packages, respectively. Alternatively, the PKGBUILD files are also in Arch Linux's AUR ([here for xoreos](https://aur.archlinux.org/packages/xoreos/), [here for xoreos-tools](https://aur.archlinux.org/packages/xoreos-tools/), [here for Phaethon](https://aur.archlinux.org/packages/phaethon/), and we have a [Gentoo overlay](https://github.com/xoreos/gentoo-overlay).

And as always, we're looking for more developers to join us in our efforts to reimplement those 3D BioWare RPGs. If *you* would like to help, please feel free to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us). :)
