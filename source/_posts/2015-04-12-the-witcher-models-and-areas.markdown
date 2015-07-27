---
layout: post
title: "The Witcher Models and Areas"
date: 2015-04-12 17:32:18 +0200
comments: true
categories: [news, progress]
author: DrMcCoy
---

Further continuing on the path to make all the engines display areas (see my posts on [*Jade Empire*](/blog/2015/02/15/jade-empire-models-and-areas/) and [*Neverwinter Nights 2*](/blog/2015/02/01/neverwinter-nights-2-areas/)), I looked at *The Witcher* next.

As some people might know, CD Projekt RED licensed BioWares Aurora engine for the first *The Witcher* game (and only the first; the later parts use their own REDengine). And in many aspects, it's very obvious that they spawn off directly from the *Neverwinter Nights* codebase, not from later BioWare titles. There have been quite some changes, though, to accommodate for *The Witcher*'s requirements.

### Models ###

Due to their similarity to *Neverwinter Nights*' MDL model files (and with light help from [Michael_DarkAngel's twMax code](http://www.tbotr.net/modules.php?mod=Downloads&op=download&sid=3&ssid=3&dlid=19)), I had already a partially working loader for *The Witcher*'s MDB files. Or so I thought. Turns out, my quick & dirty hack was just about enough to get simple object and character models to show, but it totally failed on area geometry models. Those turned up completely invisible.

### Textures and lightmaps ###

Closely looking at what my code does made me realize that the geometry itself loaded, but the textures failed to load. In fact, the textures it tried to load didn't exist. However, there were similarly named ones in the resources. In fact, for the requested texture "foo", there were texture resources "foo!d", "foo!n" and several others.

Well, these are, it seems, lightmaps, and several different ones depending on the time of day (named after their Polish words). There's:

- !d, for dzień (day)
- !r, for rano (morning)
- !p, for południe (noon)
- !w, for wieczór (evening)
- !n, for noc (night)

Since not all of them might exist for a given texture, I settled on just loading the first one available. And yes, that gave me textured area geometry. With just the lightmap applied, it still looked a bit low-res, however. No wonder, there needs to be a base texture as well. Unlike *Neverwinter Nights*, which just straight up names the textures and has simple TXI files for some texture properties, *The Witcher* has full-fledged material definitions integrated into the model. And they're shader-based. For the object models, it was enough to just take the texture names and run with it, but for the area geometry models, I had to extend this a bit. Granted, this is still a hack (we *still* don't support shaders), and fails occasionally, only less so than before.

The result was this:

-> [{% imgcap /images/blog/20150412_WitcherArea1_t.png 256 160 Kaer Morhen exterior %}](/images/blog/20150412_WitcherArea1.png) [{% imgcap /images/blog/20150412_WitcherArea2_t.png 256 160 Kaer Morhen exterior %}](/images/blog/20150412_WitcherArea2.png) [{% imgcap /images/blog/20150412_WitcherArea3_t.png 256 160 Kaer Morhen interior %}](/images/blog/20150412_WitcherArea3.png) <-

There's bits missing, I hear you say? Correct. Unfortunately.

### TexturePaint nodes ###

More debug printouts on the model loader clued me in: there's a new kind model node! The twMax author also noticed this; he calls them "TexturePaint". No support for them in twMax, though. My Google-fu didn't uncover anything else helpful either.

With no existing tools to help me, I had to do the dirty work myself. I pulled out my trusty friend the disassembler. Luckily, CD Projekt RED kept the tradition of supporting ASCII representation of model files, and so I was able to map out the loader code relatively quickly, for the most part.

First, I filled out my loader to stub and comment more MDB fields I previously just ignored. Then, I started implementing the TexturePaint nodes. Thanks to a brief email conversation with someone who's also playing around with *The Witcher* models, I already knew what these nodes probably represented: geometry textured by blending several distinct textures together, to create more realistic terrain. I.e. similar to what I found *Neverwinter Nights 2* does for its terrain geometry.

This turned out to be exactly the case, only with in-node weightmaps instead of the color channel approach in *Neverwinter Nights 2*. Additionally, these nodes too have a lightmap applied. Without shaders, this mixing is awfully slow and memory-consuming to do, therefore I instead just apply the lightmap for now. The result looks like this:

-> [{% imgcap /images/blog/20150412_WitcherArea4_t.png 256 160 TexturePaint node with lightmap %}](/images/blog/20150412_WitcherArea4.png) <-

It's not exactly pretty, but it at least shows something.

### Level of Detail (LOD) ###

After having implemented the TexturePaint nodes, I found a curious issue: certain nodes appeared twice, overlapping each other:

-> [{% imgcap /images/blog/20150412_WitcherArea5_t.png 256 160 Overlapping model nodes %}](/images/blog/20150412_WitcherArea5.png) <-

This is the result of the LOD information in the node headers. Some nodes are supposed to be displayed when you're near, some when you're far. Simpler textured geometry nodes are displayed instead of the more complex TexturePaint nodes when far enough away to not notice the texture blending anyway. As a workaround, I rigged it to only display the highest LOD for now.

### Areas ###

With the area models correctly loading, I went on to actually load the area. Owing to its origin, it's again very similar to *Neverwinter Nights*, with one difference: no tiles and tilesets. Instead, the "tileset" value specifies the singular area geometry model to display.

I quickly implemented loading said area geometry model and simple area objects. And was baffled. The area geometry's position didn't match up with the objects' positions. The area was so far in the distance, you couldn't even see it. I looked and searched for a "tile" position in the area description files...nothing. As an experiments, I bound moving the area model to keyboard keys, and played around with it until it fit. The correct position, for some reason, is {1500.0, 1500.0, 0.0}. Don't ask me *why*, but this works for all areas in the game. ¯\\\_(ツ)\_/¯

-> [{% imgcap /images/blog/20150412_WitcherArea6_t.png 256 160 Kaer Morhen exterior %}](/images/blog/20150412_WitcherArea6.png) [{% imgcap /images/blog/20150412_WitcherArea7_t.png 256 160 Outskirts of Vizima %}](/images/blog/20150412_WitcherArea7.png) [{% imgcap /images/blog/20150412_WitcherArea8_t.png 256 160 Country Inn %}](/images/blog/20150412_WitcherArea8.png) <-

### Object orientation ###

There was another thing I noticed, though: the orientation of the area objects is wrong. Unlike *Neverwinter Nights*, which only specifies one angle, the "bearing", for each object, *The Witcher* lets you rotate all objects in all three axes. The orientation is described as a [quaternion](https://en.wikipedia.org/wiki/Quaternion). Now, *Neverwinter Nights 2* does the same and because we need the object orientation in [Euler angles](https://en.wikipedia.org/wiki/Euler_angles) instead, we convert them. Unfortunately, that code doesn't seem to work correctly in *The Witcher*. I assume it's connected to the fact that *The Witcher* actually fully rotates the objects (while *Neverwinter Nights 2* only, in effect, rotates around two axes), combined with how xoreos changes the axes around for world objects and additionally needs to translate the coordinate system from Direct3D orientation to OpenGL's.

Try as I might, I couldn't get the correct orientation. After way too much banging my head against the wall, I caved and put that onto the TODO pile. That's something I have to revisit another day.

### Creatures ###

"Only objects? Where are the creatures, the NPCs, the people?", I hear you ask, imaginary reader. Well, *The Witcher* doesn't directly describe creatures in the area files. Instead, there are spawn points, and I think the rest is handled by the game scripts. Not something I can do now. No NPCs for now, I'm afraid.

### Miscellaneous ###

A few bits and pieces I found out or did during this endeavour:

- I renamed the engine and namespace in xoreos from "thewitcher"/"TheWitcher" to "witcher"/"Witcher"
- I noticed that *The Witcher*, unlike other Aurora games, encodes all strings in UTF-8. The language IDs are also wildly different. To get these together under one big tent, I changed how xoreos handles languages and encodings
- *The Witcher* uses Lua scripts. I already knew that previously. But what I didn't know: it also, additionally, uses the traditional NWScript. That'll be a lot of "fun" to reimplement...
- I found references to the [LuaCOM library](http://luaforge.net/projects/luacom/) in the *The Witcher* disassembly, which provides Lua bindings for ActiveX components. I *really*, *really*, *really* hope that's unused

In conclusion, area loading in *The Witcher* is now in a similar state to area loading in *Neverwinter Nights*, *Neverwinter Nights 2*, *Knights of the Old Republic*, *Knights of the Old Republic II* and *Jade Empire*. It's not flawless, and there's still a lot of things missing, but it's a start. :)

What's next? There's three games left without area support: *Dragon Age: Origins*, *Dragon Age 2* and *Sonic Chronicles: The Dark Brotherhood*. The latter is a Nintendo DS game, and is missing basic support for a lot of DS-specific file formats. In fact, I'm still not 100% sure this game even belongs in xoreos... The two *Dragon Age* games are somewhat further along: resource loading works and the texture format is known. They are, however, completely missing model support, as well as support for the new GFF version. Since that is at least something to go by, it's possible I'll tackle *Dragon Age: Origins* next. It could take a while until I have something worthwhile to report, though.
