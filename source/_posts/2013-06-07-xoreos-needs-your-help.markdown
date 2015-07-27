---
layout: post
title: "xoreos Needs Your Help"
date: 2013-06-07 11:00
comments: true
categories: [news]
author: DrMcCoy
---

**TL;DR:** xoreos needs contributors badly. Especially OpenGL wizards. I might give you cake.
(If you haven’t heard about xoreos yet, please read the [short introduction on its website](/about/index.html), or my [previous blog post about it](http://drmccoy.de/gobsmacked/?p=484) before continuing with this post. Thanks.)

**NOTE**: This is a mirror of the original blog post here: http://drmccoy.de/gobsmacked/?p=530

{% img https://drmccoy.de/gobsmacked/wp-content/uploads/2013/06/xoreos_logo.png "The old xoreos logo: the word 'xoreos' rendered in neon green" %}

People who are following [xoreos](http://xoreos.org/) a bit will already have noticed this: development has slowed considerably.

This has several causes:

1. I’m a bit busy-ish with real life
2. I’ve got (too many) other projects
3. Motivation is a bit low

Point one is not big problem.
Point two can be worked around.
Point three needs some more explanation.
Quick all-clear, though, I’m not abandoning it. Really.

Now, to elaborate: I’m not an expert on OpenGL or 3D engine stuff. In fact, I’m very much not an expert at all. The current 3D code in xoreos is basically something I hacked together after reading a few examples on the web. It works, kinda, barely, but it’s neither feature-complete, nor well-written performance-wise, nor what you’d expect from a proper 3D engine.

This leads me to the one big thing xoreos desperately needs: other developers interested in working with me on this project. I did have some contributions, and I’m really grateful for them, but reactions have been lower than I expected. This is probably my own damn fault; I’m not a people’s person and I’m not good at self-promotion. But, the fact remains, I’m not able to finish xoreos on my own.

Most pressing is someone with experience in OpenGL and willingness to completely rip my graphics code apart. It needs to be rewritten, probably from the ground up, making it more like something clean to work with and fast to run. Ideally, it should be flexible to also work within the constraints of OpenGL ES, so that xoreos could also work on Android and iOS, but I admit I have no clue whether this is in any way easy or even possible.

Also really great would be if people came forward to work on the reimplementation of the actual games. Most of them aren’t doing anything at all yet; many are missing basic file formats that need to be reverse engineered or fuzzed. This is probably the most interesting and fun work, at least from my perspective, but can also be quite hard and frustrating.

Furthermore, the [project website and logo](http://xoreos.org). I suck at design and this shows. In short, the website and logo look horrible, but I can’t do a better job. It would be super if someone actually capable could redesign it, properly. Like always, I can’t grant any compensation except proper credits in the AUTHORS file and the website. Yeah, sucks, I know. If we ever meet face-to-face, you’ll get cake or ~~death~~beer. I don’t expect people to fall over backwards to gift me their time, but if someone out there would like to surprise me, I’d be very grateful indeed.

**UPDATE**: The website and logo design has changed already. :)

Of course, I’m always open for constructive criticism. Be it ideas on how to change the codebase for the better, be it ways to improve xoreos in general, be it anything at all, I’m all ears.
My vision for xoreos is the following: I want it to prosper and grow into a portable FLOSS reimplementation of the Aurora engine, comparable to what [ScummVM](http://scummvm.org) is for adventure games and [GemRB](http://gemrb.org) is for Infinity engine games. Should you share my vision and want xoreos to succeed, please carry this post far and wide so that it might attract kindred spirits.

So, please, if anything above looks like something you’d be interested in doing or if you have comments, questions, suggestions, feel free to contact me using the [project mailing list](https://xoreos.org/mailman/listinfo/xoreos-devel); or drop me a line over my [private email address](drmccoy@drmccoy.de); or comment directly [here](http://drmccoy.de/gobsmacked/?p=530); or [catch me on IRC](irc://irc.freenode.net/xoreos). Do you know potentially interested people? Then tell them about xoreos.

And yes, you can also write me to tell me I’m foolish to waste my time here if you really feel that way. ;)

If you want to look at the code, [the project is hosted here on github](https://github.com/DrMcCoy/xoreos). I love pull requests and will gladly accept them if they fit. If you need pointers on what to do, [here’s a long rambly (non-exhaustive) TODO list](https://github.com/DrMcCoy/xoreos/wiki/TODO).

And if you ever visit [Braunschweig, Germany](https://en.wikipedia.org/wiki/Braunschweig), I will buy you a beer, or have you over for coffee, tea and [self-made cake](http://drmccoy.de/cakesmacked/). Deal? :)
