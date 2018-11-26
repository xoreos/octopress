---
layout: post
title: "Not-Thanksgiving 2018"
date: 2018-11-26 22:49:00 +0100
comments: true
categories: [news, progress]
author: DrMcCoy
---

Another year nears its end. [After unfortunately skipping last year's Not-Thanksgiving post](/blog/2018/07/03/xoreos-0-dot-0-5-dawn-star-released/), we are, back to our regular yearly retrospection. For people new to xoreos: this series is a kind of introspective look into what happened with the xoreos project over the past year. I'm not in the USA, so I don't observe Thanksgiving, but nevertheless, I do want to give thanks to all the great people working with me on xoreos, and supporting us in other ways.

-> [{% imgcap /images/blog/20181125_malak_t.png 256 192 KotOR main menu with Darth Malak %}](/images/blog/20181125_malak.png) <-

I already wrote [a combination introspective and release post back in July](/blog/2018/07/03/xoreos-0-dot-0-5-dawn-star-released/), which gave some updates since the previous [Not-Thanksgiving post in 2016](/blog/2016/11/24/not-thanksgiving-2016/), so let's see what happened since then:

* After the release, I took a look at the different kind of "wavebanks" xoreos-supported games use, and implemented loaders for those. A wavebank is a collection of sound files packed into an archive, indexed by either a numerical or string ID. We have:
	* [XACT WaveBank](https://github.com/xoreos/xoreos/blob/master/src/sound/xactwavebank.h), used by Jade Empire. There's two versions, [a binary one](https://github.com/xoreos/xoreos/blob/master/src/sound/xactwavebank_binary.cpp) (the original format, I assume) in the Xbox version, and [an ASCII one](https://github.com/xoreos/xoreos/blob/master/src/sound/xactwavebank_ascii.cpp) in the Windows version.
	* [FMOD SampleBank](https://github.com/xoreos/xoreos/blob/master/src/sound/fmodsamplebank.h), used in Dragon Age: Origins.
	* [Wwise SoundBank](https://github.com/xoreos/xoreos/blob/master/src/sound/wwisesoundbank.h), used in Dragon Age II.
* However, "wavebanks" are just one part of the coin. They're used together with sound and event definitions, which tell you *how* to play the waves in the wavebank, including looping, sequencing and filters. These are still mostly missing. [Nostritius has started](https://github.com/xoreos/xoreos/pull/362) [looking at FMOD Event files, FEV](https://github.com/xoreos/xoreos/pull/367), though.
* Next, I looked at the Android versions of Knights of the Old Republic and Jade Empire. I found that they contain packed data in archives. I added [a tool to xoreos-tools, unobb](https://github.com/xoreos/xoreos-tools/blob/master/src/unobb.cpp), that can extract these. I also added probes for the extracted data files to xoreos.
* Nostritius also [added a probe for the Xbox version of Dragon Age: Origins](https://github.com/xoreos/xoreos/pull/337), and we added support for its data file differences.
	* For the Xbox version of Dragon Age II, [we're still missing information on its ERF compression](https://github.com/xoreos/xoreos/issues/335).
* seedhartha, in the mean time, [restructured the engine code to store object references in scripts and containers as IDs](https://github.com/xoreos/xoreos/pull/341), instead of plain pointers. This is necessary to correctly implement the DestroyObject script function, for example, without accidentally accessing the objects afterwards.
* Nostritius notified me that I had the wrong string encoding table set up for Jade Empire. [We fixed that](https://github.com/xoreos/xoreos/commit/9e991c76d). Now non-English versions of Jade Empire should work correctly.
* Nostritius also [made Malak appear in the KotOR menu](https://github.com/xoreos/xoreos/pull/319), and implemented [GUI scaling for KotOR](https://github.com/xoreos/xoreos/pull/312) [and KotOR2](https://github.com/xoreos/xoreos/pull/374).
* Nostritius wrote several new tools for xoreos-tools: a [packer and unpacker for The Witcher save files](https://github.com/xoreos/xoreos-tools/pull/25), a [KEY/BIF packer](https://github.com/xoreos/xoreos-tools/pull/26), and a [xml2gff tool](https://github.com/xoreos/xoreos-tools/pull/27) (which means he had to write a [GFF3 writer](https://github.com/xoreos/xoreos/pull/300), which will be very useful in the future).
* I bumped the C++ version for xoreos-tools to C++11. This is kind of a test run for xoreos proper. In the future, I plan to C++11-ify the codebase quite a bit.
* rjshae took [asr1 WIP code](https://github.com/xoreos/xoreos-tools/pull/1) to fix the non-standard XML files NWN2 uses for its GUI [and brought it up to speed](https://github.com/xoreos/xoreos-tools/pull/24). This means the way to implement the NWN2 GUI is now clear(er).
* rjshae also [fixed up our common trap/trigger code](https://github.com/xoreos/xoreos/pull/372), and [partially implemented triggers for NWN2](https://github.com/xoreos/xoreos/pull/377).
* Nostritius started implementing support for the [Flash-based](https://github.com/xoreos/xoreos/pull/294) [ScaleForm GFx](https://github.com/xoreos/xoreos/pull/373), which the two Dragon Age games use for their GUI.
* seedhartha took mirv's WIP shader-based renderer and [turned it into a clean PR](https://github.com/xoreos/xoreos/pull/381), which I then merged. This means, mirv can now continue working on the new renderer in-tree, with hopefully smaller, more easily reviewable PRs to come.
* Finally, clone2727 reorganized our [audio](https://github.com/xoreos/xoreos/compare/d9d2c3f87e20cbe95d98fcb33dc7ff31ef79e92d%5E...9bc09deee719121ddd064a6534f0c6018e276416) and [video decoding code](https://github.com/xoreos/xoreos/compare/cc67f12b36b6f34445a62e1959c244e9fac77b38%5E...25975d5e44e6445f0146e1f54d38f86f2a1fd620).

-> [{% imgcap /images/blog/20181125_dao_t.png 256 201 WIP Dragon Age: Origins main menu %}](/images/blog/20181125_dao.png) <-

Quite a lot, right? :)

Of course, there's still things in progress, among them:

* mirv is continuing work on the new renderer.
* Supermanu is [working on pathfinding](https://github.com/xoreos/xoreos/pull/211).
* Nostritius is furthering our ScaleForm GFx reimplementation.

xoreos wouldn't be what it is without the help of a lot of great people, for whom I am thankful.

* [rjshae](https://github.com/rjshae), for taking up work on NWN2 in xoreos.
* [asr1](https://github.com/asr1), for starting the NWN2 XML fixer, that's now in xoreos-tools.
* [seedhartha](https://github.com/seedhartha), for working on KotOR and getting the renderer rewrite mergeable.
* [mirv](https://github.com/mirv-sillyfish), for doing the renderer rewrite in the first place.
* [Nostritius](https://github.com/Nostritius), for doing a heck of a lot of different things in xoreos.
* [clone2727](https://github.com/clone2727), for keeping me grounded.
* [Luigi Auiremma](http://aluigi.altervista.org/), for all his research and tools.
* [Supermanu](https://github.com/Supermanu), for his pathfinding work.
* [Farmboy0](https://github.com/Farmboy0), for his help and advice.
* The people at [GamingOnLinux](https://www.gamingonlinux.com/), a great community for, well, Gaming on Linux.
* Linux porters like [flibitijibibo](http://flibitijibibo.com/), [icculus](https://icculus.org/) and [Cheeseness](https://cheeseness.itch.io/), for providing this much-needed service and also being all-around good people.
* A myriads of other people I probably forgot, because I'm bad at remembering.

Hopefully, the future will bring even more movement into this little project. If *you* would like to help with that, then please, feel free to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us)! :)
