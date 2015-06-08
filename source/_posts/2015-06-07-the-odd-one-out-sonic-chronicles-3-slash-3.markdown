---
layout: post
title: "The odd one out: Sonic Chronicles (3/3)"
date: 2015-06-07 02:24:12 +0200
comments: true
categories: [news]
author: DrMcCoy
---

(This is part 3 of 3 of my report about the progress on *Sonic Chronicles*. If you haven't already, please also read [part 1](/blog/2015/06/05/the-odd-one-out-sonic-chronicles-1-slash-3/) and [part 2](/blog/2015/06/06/the-odd-one-out-sonic-chronicles-2-slash-3/).)

Now that I had (nearly) everything graphical together, it was time to weave it all together into something approaching fake *Sonic Chronicles* gameplay.

### Windows size ###

Being a Nintendo DS game, *Sonic Chronicles* run on two screens of 256x192 each, arranged on top of each other. To make this easy on me, I decided to, for now, force xoreos' window size to a static 256x384, and draw into it as if it was the two Nintendo DS screen. For the future, we'll have to think about how to handle scaling.

There's at least two ways to handle this:

- Render into two textures, one for the each screen, then scale these
- Scale and position the pieces separately

The former is the easy way out, but the latter might provide higher quality. There might be a third, a middle way: draw all 2D elements combined with scaling, and render the 3D objects in higher resolution.

### Intro panels ###

To make the game feel a bit more real, I rigged up few static panels showing the various splash screens, and the "Start your adventure" GUI. Note that the button isn't actually working: it's really just an image that waits for a mouse click. 

-> [{% imgcap /images/blog/20150607_intro1.png 256 384 Touch to Start %}](/images/blog/20150607_intro1.png) [{% imgcap /images/blog/20150607_intro2.png 256 384 Start your Adventure %}](/images/blog/20150607_intro2.png) [{% imgcap /images/blog/20150607_intro3.png 256 384 Chapter 1 %}](/images/blog/20150607_intro3.png) <-

### Area background ###

After the intro panels, *Sonic Chronicles* in xoreos then dumps you right into the first area. Using a static panel again, it displays the mini map on the top screen, and the area background on the bottom screen. With the arrow keys, you can move the camera along the X and Y axes, and the area background panel follows the camera to draw the section.

### Area placeables ###

That was easy enough. I then wasted the better part of a day trying to trace and guess at how the game loads the "placeable" objects, the usable 3D objects in the area. The area description within the ARE file lists all placeables, each with an integer with the "name" of 40023 that seems to be a running ID and an integer called 40018 that's unique for each type. I.e. collectable rings have a 40018 value of 0, the item chest 6, and the pile of wood in the first area has a value of 15. The model names are listed in appearances.gda. So far, so familiar. However, the model for the wood pile is on row 101, and I failed to find a consistent way to connect those two numbers, 15 and 101, either mathematical or with the help of other data files, that would have worked for other placeables as well.

With nowhere else to turn, I looked at the disassembly. And I wept. There *is* no clean way to connect those numbers, because the placeable instantiation is hardcoded: there's a big old switch with all possible values (43 of them, 0-42) for the integer 40018, with object instantiation for each of them.

To keep it simple for now, I added a little array mapping that type ID onto a row in the appearances.gda. Not all cells are filled yet, but enough that the first area makes sense.

But, to get the models to display correctly, there was still something missing. You see, xoreos sets up a proper [perspective projection](https://en.wikipedia.org/wiki/3D_projection#Perspective_projection) matrix, where objects in the distance are smaller and all this jazz. *Sonic Chronicles*, however, uses an [orthogonal projection](https://en.wikipedia.org/wiki/Orthographic_projection) at an angle of 45°. So, I added a method in our GraphicsManager to let the game code select an orthogonal projection instead.

And after some other minor fixes related to this, like scaling the rate of camera movement to fit the 45° angle (so that 3D objects stay at the same point on the background image when you move), and adding the changed orthogonal viewport to our unproject() function (so that detecting that you've moused over an object works correctly), the placeables now display and behave correctly within the areas.

-> [{% imgcap /images/blog/20150607_area1.png 256 384 Green Hill Zone %}](/images/blog/20150607_area1.png) [{% imgcap /images/blog/20150607_area2.png 256 384 Blue Ridge Zone %}](/images/blog/20150607_area2.png) [{% imgcap /images/blog/20150607_area3.png 256 384 Voxai Beta Interior %}](/images/blog/20150607_area3.png) <-

### That all? ###

So, what's missing? Quite a lot, actually:

Model animations. Those can be both geometry- and texture-based. In geometry-based animations, the bones move around and rotate, leading to different vertex positions. With texture-based animations, the textures move, rotate or scale, or even get replaced by different textures.

Most of the placeable types aren't yet recognized. Nor do the placeables do anything yet. Nor do we create creatures, triggers and squads. Nor do we have a player character that can move around.

There are also no conversations of any kind implemented yet, and there's no proper GUI and menu support.

We're also lacking sound and music. There's partial documentation for them, though, so it should be relatively easy to manage. Videos, which we still miss too, will be more difficult: we need to reverse-engineer the ActImagine VX video codec, since no one has done that yet.

This all is stuff for the TODO pile, though. Nothing I want to work on at the moment. Of course, we would welcome *your* contribution, so please, don't hesitate to [contact us](https://wiki.xoreos.org/index.php?title=Contact_us) if you want to tackle any of these features, or anything else for that matter!

### What's next, then? ###

If I want to continue on the path of getting all games to show areas, *Dragon Age: Origins* would be next. We'll see how well I'll do there, I guess! :)
