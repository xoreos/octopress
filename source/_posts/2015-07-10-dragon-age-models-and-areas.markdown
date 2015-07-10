---
layout: post
title: "Dragon Age models and areas"
date: 2015-07-10 04:04:09 +0200
comments: true
categories: [news]
author: DrMcCoy
---

Yet further down the path of getting all targeted games to show areas, it seems like I reached the end with *Dragon Age: Origins* and *Dragon Age II*. Similar to my posts about my progress with *Sonic Chronicles: The Dark Brotherhood* ([Part 1](/blog/2015/06/05/the-odd-one-out-sonic-chronicles-1-slash-3/), [Part 2](/blog/2015/06/06/the-odd-one-out-sonic-chronicles-2-slash-3/), [Part 3](/blog/2015/06/07/the-odd-one-out-sonic-chronicles-3-slash-3/)), [*The Witcher*](/blog/2015/04/12/the-witcher-models-and-areas/), [*Jade Empire*](/blog/2015/02/15/jade-empire-models-and-areas/) and [*Neverwinter Nights 2*](/blog/2015/02/01/neverwinter-nights-2-areas/), this will be a short description of what I did. This time: *Dragon Age: Origins* and *Dragon Age II*.

### Models ###

Lucky for me, the *Dragon Age* model format is reasonably well documented in the [*Dragon Age* toolset wiki](http://social.bioware.com/wiki/datoolset/index.php/Model). tazpn even created standalone model viewers for [*Dragon Age: Origins*](http://social.bioware.com/project/218/) and [*Dragon Age II*](http://social.bioware.com/project/4253/), and released them with sources under the terms of the 3-clause BSD license. :)

And since the model format is based on GFF4, missing pieces of information are relatively easy to decipher too. So I quickly had a loader capable of reading the skeleton whipped up for both *Dragon Age: Origins* and *Dragon Age II* (since they are nearly identical in format).

-> [{% imgcap /images/blog/20150710_skeletonragedemon_t.png 256 170 Rage demon skeleton %}](/images/blog/20150710_skeletonragedemon.png) [{% imgcap /images/blog/20150710_skeletondragon_t.png 256 170 Dragon skeleton %}](/images/blog/20150710_skeletondragon.png) <-

With a bit of fiddling, the meshes were there too. There's two types of meshes within the models: static meshes, directly hanging at one specific bone, and dynamic meshes that include weights for several bones for each vertex. Similar to [models in *Sonic Chronicles*](/blog/2015/06/06/the-odd-one-out-sonic-chronicles-2-slash-3/), this would deform the mesh according to those weights when the bones are animated. Unlike *Sonic Chronicles*, the default vertex positions of those meshes create a valid, unanimated pose. This means I could just completely ignore the bone weights for now, and load the meshes as if they were static. In the future, a vertex shader would combine those weights with the bone position to create the fully animatable model meshes.

-> [{% imgcap /images/blog/20150710_meshragedemon_t.png 256 170 Rage demon mesh %}](/images/blog/20150710_meshragedemon.png) [{% imgcap /images/blog/20150710_meshdragon_t.png 256 170 Dragon mesh %}](/images/blog/20150710_meshdragon.png) [{% imgcap /images/blog/20150710_meshstatue_t.png 256 170 Statue mesh %}](/images/blog/20150710_meshstatue.png) <-

Only thing missing now were the textures. For that, I needed to read the MAO (material object) files, which contains the material file (MAT), various textures (diffuse, lightmap, etc.) and a number of optional parameters. The material file in turn contains several different "semantics", which is basically the name of a shader and how to map the MAO values onto the shader input. The original game takes all these, looks for the most fitting semantic in the material file (depending on number of parameters, graphics card capability and user settings), and then tells the graphics card which shader to use to render the mesh.

Now, since we don't actually support any shaders yet (and we can't use the game's Direct3D shaders directly anyway), we simple read the MAO (which can be either in GFF4 or XML format), take the diffuse texture, and apply it to the mesh directly.

-> [{% imgcap /images/blog/20150710_textureragedemon_t.png 256 170 Textured rage demon %}](/images/blog/20150710_textureragedemon.png) [{% imgcap /images/blog/20150710_texturedragon_t.png 256 170 Textured dragon %}](/images/blog/20150710_texturedragon.png) [{% imgcap /images/blog/20150710_texturestatue_t.png 256 170 Textured statue %}](/images/blog/20150710_texturestatue.png) <-

### Campaigns ###

With the models done, I turned to reading the *Dragon Age: Origins* campaign files. A campaign, that is either the default single player campaign (which is defined in a CIF file), or a DLC package (with both a CIF file and a manifest.xml) that doesn't extend another campaign (those would be add-ons).

There's several caveats involved here:

First of all, most of the DLC packages are encrypted. The original game queries a BioWare server for the decryption key, asking whether its a legitimate copy. While the encryption method is known (Blowfish in ECB mode), xoreos does not include any of the keys. So the only campaigns apart from the main one loadable right now are the unencrypted ones, namely *Dragon Age: Awakening*, and any custom ones you might have downloaded (including the PC Gamer promo DLC [A Tale of Orzammar](http://dragonage.wikia.com/wiki/A_Tale_of_Orzammar)).

Then, we don't load any add-ons. So no Shale or Feastday Gifts, even if they weren't encrypted (which they are). It's not like xoreos could do anything with them yet anyway.

Finally, we have no way to install .dazip packages yet, so those need to be installed using the original game for now, or manually extracted and put in the right places. In the future, something that install them would be nice. Or maybe we could support loading of packed .dazip files, but that could be slow.

In either case, I implemented the loading of standalone campaign files.

### Areas and rooms ###

Next up were areas (ARE) and environment layouts (ARL) with room definitions (RML). The ARE contains dynamic room information, like what music to play, and the placeables and creatures (more of those later). The ARL defines what rooms are in the area (as well as pathing information, weather, fog, etc.), each of them being a RML file with models. They are all, again, GFF4 files, making them nice and easy to understand.

-> [{% imgcap /images/blog/20150710_arena_t.png 256 170 Arena %}](/images/blog/20150710_arena.png) [{% imgcap /images/blog/20150710_castle_t.png 256 170 Castle %}](/images/blog/20150710_castle.png) [{% imgcap /images/blog/20150710_ostagar1_t.png 256 170 Ostagar %}](/images/blog/20150710_ostagar1.png) <-

There was one problem, though. The orientations of the models were given in [quaternions](https://en.wikipedia.org/wiki/Quaternion), and as I said in the [blog post about my *The Witcher* progress](/blog/2015/04/12/the-witcher-models-and-areas/), a combination the automatic world rotation xoreos does, and our Model class wanting [Euler angles](https://en.wikipedia.org/wiki/Euler_angles) instead leads to them not being correctly evaluated for whole models.

I was getting sick of that not being correct. I bit the bullet and removed the world rotation (which meant I had to rejigger the placement code in all engines, as well as the camera system, which was especially painful in *Sonic Chronicles*). And then I changed the Model class to take [axis-angle](https://en.wikipedia.org/wiki/Axis%E2%80%93angle_representation) rotations instead; those can be more easily calculated from quaternions, and can still be directly fed into OpenGL.

As a result, the area room models in *Dragon Age: Origins* were correctly oriented. And the placeable models in *The Witcher* as well.

-> [{% imgcap /images/blog/20150710_elvenalienage_t.png 256 170 Elven alienage %}](/images/blog/20150710_elvenalienage.png) [{% imgcap /images/blog/20150710_ostagar2_t.png 256 170 Ostagar %}](/images/blog/20150710_ostagar2.png) <-

You might notice that the ground mesh in outdoor areas looks very blurry and low-res. That's because the original game doesn't specify a single texture for those, but instead combines several textures together in a shader. We don't support that yet, so instead we apply the replacement texture of the lowest LOD which is normally used for meshes that are far away.

### Placeables ###

On to the placeables, the objects within areas. They are defined within a list in the ARE file (giving position, orientation, name, etc.), each with a template. The template is a UTP file, a GFF3, that contains common properties for all instances of this placeable. This includes an appearance, which is an index into a GDA (a GFF'd 2DA, a two-dimensional table), which specifies, among other things, the model to use.

So far, so usual for BioWare games.

One difference, though. In the *Dragon Age* games, the GDA files do not stand alone. Instead, each is a combination of potentially several GDA files with the same prefix (defined in m2da.gda). This is used for DLCs, which then can simply add rows to a GDA, instead of overwriting the whole file. Consequentially, the appearance index is not a direct row number, but corresponds to a value in the "ID" column.

A bit fiddly, but still relatively easy to implement.

-> [{% imgcap /images/blog/20150710_placeable1_t.png 256 170 Placeable %}](/images/blog/20150710_placeable1.png) [{% imgcap /images/blog/20150710_placeable2_t.png 256 170 Placeable %}](/images/blog/20150710_placeable2.png) <-

### Creatures ###

The creatures were more difficult. There's several types of creatures: type S (simple) are just a single model; type H (head) are split into a body model and several models for the head (base, eyes, hair, beard); type W (welded) are similar to H, but already include weapons in the body model; and "P" (player-type) creatures are segmented into head (with base, eyes, hair, beard), chest, hands (gloves) and feet (boots).

-> [{% imgcap /images/blog/20150710_creatureh1_t.png 256 170 Hurlock %}](/images/blog/20150710_creatureh1.png) [{% imgcap /images/blog/20150710_creatureh2_t.png 256 170 Headless Duncan %}](/images/blog/20150710_creatureh2.png) [{% imgcap /images/blog/20150710_creatureh3_t.png 256 170 Headless kitchen boy %}](/images/blog/20150710_creatureh3.png) <-


Moreover, creatures of type P also switch model parts depending on the equipped items. So armor changes the chest model, gloves and boots change the hands/feet models and a helmet replaces the hair. Which models to use depends on several factors, and includes look-ups in several different GDA files, as well as UTC (creature template) and UTI (items) files.

Another problem is the tinting. The original game uses a shader to tint hair, skin and armor parts custom, user-selectable colors. To do that, their textures just contain intensity values in two color channels, while the two other channels are used as a bump map and something else (which I'm not sure yet). If we just apply the texture to those body parts, they are suddenly mostly transparent. To work around that for now, we manually modify each of those textures to remove the transparency. That leaves the weird coloring, but you can at least see all the body parts then.

-> [{% imgcap /images/blog/20150710_creatureh4_t.png 256 170 Duncan without hair %}](/images/blog/20150710_creatureh4.png) [{% imgcap /images/blog/20150710_creatureh5_t.png 256 170 Kitchen boy %}](/images/blog/20150710_creatureh5.png) [{% imgcap /images/blog/20150710_creatureh6_t.png 256 170 Cook %}](/images/blog/20150710_creatureh6.png) <-

-> [{% imgcap /images/blog/20150710_meetingofheads_t.png 256 170 Meating of the heads %}](/images/blog/20150710_meetingofheads.png) [{% imgcap /images/blog/20150710_bodiedheads_t.png 256 170 Bodies %}](/images/blog/20150710_bodiedheads.png) [{% imgcap /images/blog/20150710_helmets_t.png 256 170 Helmets %}](/images/blog/20150710_helmets.png) <-

### Dragon Age II ###

I then applied all this to Dragon Age II. Just a few minor changes to the resource loading was necessary, and nearly everything worked out of the box.

-> [{% imgcap /images/blog/20150710_hawkeestate_t.png 256 170 Hawke Estate %}](/images/blog/20150710_hawkeestate.png) [{% imgcap /images/blog/20150710_viscountskeep_t.png 256 170 Viscount's Keep %}](/images/blog/20150710_viscountskeep.png) <-

Only the P-type creatures needed a bit more work, since how the body part models are constructed changed.

-> [{% imgcap /images/blog/20150710_aveline_t.png 256 170 Companions %}](/images/blog/20150710_aveline.png) <-

Similar to *Sonic Chronicles*, *Dragon Age II* is also missing many of the GDA headers; they're only stored as CRC hashes. With a dictionary attack, I did manage to crack about half of them, but that still leaves about 450 unknown. Something to watch out for in the future.

### Music ###

I also investigated how music works in the two games. *Dragon Age: Origins* uses [FMOD](https://en.wikipedia.org/wiki/FMOD), and *Dragon Age II* uses [Wwise](https://en.wikipedia.org/wiki/Audiokinetic_Wwise). Both work similarily: the area specifies an event group, and the scripts then tell the library to play a specific event list from that group at certain times. The library does the rest, evaluating the events in the event list (which range from "play sound X", over "set volume to Y", to "add Z% reverb"). And while I do have adequately licensed code to read the sounds from both libraries' soundbanks, figuring out the events is a massive undertaking. And we don't have a script system for the *Dragon Age* games in place anyway, so this is nothing that can be done right now.

### What's next ###

So... All games xoreos cares about now show areas. What's next, then?

Well, first of all, I'd like to do some cleanup of the engines code. Sync them up, make them more similar to each other. Right now, many things are done slightly different in each engine, because the games changes something around and the old concept suddenly didn't fit anymore. If possible, I'd like to unify the concepts again.

There's also a few potential portability issues I want to investigate. For example, I read that using fopen() on Windows with filenames containing non-ASCII characters won't work at all. Instead, I'll probably have to change xoreos' File stream class to use Boost's fstreams, and convert our UTF-8 strings to UTF-16 on file open. I hope that's something I can test with Wine, otherwise I'll have to bug somebody with access to a real Windows.

After those things have been cleared, I'd like to prepare for our very first release. I plan to include both xoreos and xoreos-tools, with sources (of course) and pre-compiled binaries for GNU/Linux, Mac OS X (>= 10.5) and Windows, each for both x86 and x86_64. I have cross-compilers for those, and they all *should* work. Yes, xoreos is still not really useful for end-users, but a release can't hurt, and might give us some publicity and/or get people interested. Who knows.

I could use some testers for those binaries, though, to make sure I get the library dependencies correctly. And that the GNU/Linux binaries work on other systems than just mine.

I'm also open for other platforms. Would it make sense to have xoreos pre-compiled for Free/Net/OpenBSD? Other architectures than just x86/x86_64? Anybody with insights there, and capable of compiling those binaries (or pointers to cross-compilers), please, [contact us](https://wiki.xoreos.org/index.php?title=Contact_us). :)

As for how to continue the actual xoreos development, I think it would be useful to transfer the script system that's currently hooked up to *Neverwinter Nights* onto the other engines. It would need to be rewritten, though. When I first wrote it, I wanted to have engine functions with signatures that mirrored the signatures of what the scripts call. I couldn't get it to work, though, and settled on a context that contained an array of parameters. For some reason, I still used boost::bind for all the functions, which, at that point, was not necessary. boost::bind compiles really, really slow, and so now the files containing the *Neverwinter Nights* engines functions take ages to compile. This needs to go.

There, that's the current short-term roadmap for me: cleanup, release, script system.
