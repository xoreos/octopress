---
layout: post
title: "Not-Thanksgiving 2016"
date: 2016-11-24 17:30:00 +0100
comments: true
categories: [news, progress]
author: DrMcCoy
---

And again a year is nearing its end. Like [last year](/blog/2015/11/27/not-thanksgiving-2015/) and [the year before](/blog/2014/11/29/not-thanksgiving/), I'd like to turn my gaze inwards.

A lot of things happened with xoreos this past year, albeit most of them hidden and "under the hood":

* I wrote about [disassembling NWScript bytecode](/blog/2016/01/12/disassembling-nwscript-bytecode/). The tasks I mentioned there are still open, too. If anybody wants to take them up, I'd be happy to explain them in more detail :).
* We [released xoreos 0.0.4, nicknamed "Chodo"](/blog/2016/02/01/xoreos-0-dot-0-4-chodo-released/). That was the only release of xoreos in 2016. xoreos 0.0.4 included some minor fixes and features for *Neverwinter Nights*, and the xoreos-tools package included the new NWScript disassembler.
* In April, I reached a streak of a full year of daily xoreos commits. Due to some real life things, I had to take a break there, though. I'm now again at three months of daily commits, but there is a three-month "hole" between April and August.

-> [{% imgcap /images/blog/20161124_github1.png 730 280 GitHub contribution graph in April %}](/images/blog/20161124_github1.png) <-

-> [{% imgcap /images/blog/20161124_github2.png 730 192 GitHub contribution graph in November %}](/images/blog/20161124_github2.png) <-

* Farmboy0 fleshed out the *Jade Empire* engine a bit, mostly in the scripts department.
* [Supermanu implemented a huge chunk of the character generator](https://github.com/xoreos/xoreos/commits?author=Supermanu) for *Neverwinter Nights*.
* [Farmboy0 fixed a glitch in the *Neverwinter Nights* animation system](https://github.com/xoreos/xoreos/pull/125) that has plagued xoreos for quite some time: the animation scaling in various creature models was off. This lead to, for example, the head and arms of elves detaching from the body during the yawn animation.
* I then implemented a few more animation script functions, too, which is especially noticeable in the intro animation for Hordes of the Underdark. I also fixed a mistake in the keyframe interpolation. This takes care of another glitch in *Neverwinter Nights*: model nodes rotating the wrong way around.
* [smbas added support for Lua scripts in *The Witcher*](https://github.com/xoreos/xoreos/pull/127). A lot of the initialization code that sets up the classes and functions *The Witcher* expects to find is still missing, so nothing obvious is visible as of yet.
* [Farmboy0 moved the window handling from the GraphicsManager into a new WindowManager class](https://github.com/xoreos/xoreos/pull/121), making the code more readable.
* [I fundamentally restructured our build system](https://github.com/xoreos/xoreos/pull/128), or at least the autotools part of it (xoreos can be built using either autotools or CMake). Previously, we used a recursive autotools setup, where make recurses into each subdirectory. This is, unfortunately, pretty slow, among other drawbacks. I changed it to be non-recursive now, with the top-level Makefile instead being created using (recursive) includes.
* I then introduced various smart pointer templates into the codebase, making it easier to read and easier to keep track of memory allocations.
* [berenm added AppVeyor integration](https://github.com/xoreos/xoreos/pull/129). Like [Travis CI](https://travis-ci.org/) (which we already use as well), [AppVeyor](https://www.appveyor.com/) is a [continuous integration](https://en.wikipedia.org/wiki/Continuous_integration) service. This means that every single commit to the public xoreos repository will now be built on Microsoft Windows, using Microsoft Visual Studio 2015, in addition to gcc and clang on GNU/Linux (via Travis CI). This ensures that any compilation breakage on these systems is immediately visible and can be fixed at once.
* [GitHub added a new feature, "Projects"](https://github.com/blog/2256-a-whole-new-github-universe-announcing-new-tools-forums-and-features), that provide Kanban-like boards of tasks. I took the time to fill the [xoreos Projects page](https://github.com/orgs/xoreos/projects) with boards for tasks from our TODO list.
* There were of course also various clean-ups, minor fixes and expanded code documentation.

-> [{% imgcap /images/blog/20161124_nwn1_t.png 256 170 Animation with glitch %}](/images/blog/20161124_nwn1.png) [{% imgcap /images/blog/20161124_nwn2_t.png 256 170 Animation without glitch %}](/images/blog/20161124_nwn2.png) [{% imgcap /images/blog/20161124_nwn3_t.png 256 170 Animations in the HotU intro %}](/images/blog/20161124_nwn3.png) <-

Additionally, there are several tasks currently being worked on, among them:

* [Supermanu is looking into pathfinding](https://twitter.com/mtondeur42/status/793465750589759492).
* mirv is still working on rewriting the OpenGL renderer.
* I am currently writing unit tests for the xoreos codebase, using [Google Test](https://github.com/google/googletest). I already found multiple issues, bugs, and corner cases while adding them.

From my side of things, my current plan is to make my unit tests branch public some time in December. I'll write a small announcement here about it then. A new release of xoreos, 0.0.5, should follow early next year.

As always, this all wouldn't have been possible without a lot of people. For them I am thankful.

* [Farmboy0](https://github.com/farmboy0), for various fixes, implementations and file format spelunking.
* [Supermanu](https://github.com/Supermanu), for his character generator work and pathfinding research.
* [mirv](https://github.com/mirv-sillyfish), for continuing to work on the OpenGL rewrite.
* [smbas](https://github.com/smbas), for his work on Lua and *The Witcher*.
* [berenm](https://github.com/berenm), for the AppVeyor integration and CMake knowledge.
* [TC01](https://github.com/TC01), for writing a Fedora specfile for the xoreos projects.
* [CromFr](https://github.com/CromFr), for taking a stab at the [walkmesh structure in NWN2's TRN files](https://gist.github.com/CromFr/104bac52dc9191099d9d9e3dbd2c4975).
* [clone2727](https://github.com/clone2727), for invaluable ideas and corrections.
* The folks at [GamingOnLinux](https://www.gamingonlinux.com/), who continue to be a great resource for all things related to Games on Linux.

I am also thankful for all the people who take the time to explain things to others, people who write interesting, useful or needed articles, and people who provide mentoring and help. Relatedly: a week ago, Stephanie Hurlburt published [an article with engineers who are willing to mentor or answer programming/engineering questions](http://stephaniehurlburt.com/blog/2016/11/14/list-of-engineers-willing-to-mentor-you). I for one think that's a really great idea. Please take a look at that article.

And now, let's see what the next year has in store for us. If *you*, however, found all this terribly interesting and would like to help with our little project, then please, feel free to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us)! :)
