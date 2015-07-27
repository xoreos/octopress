---
layout: post
title: "Neverwinter Nights 2 Areas"
date: 2015-02-01 16:10
comments: true
categories: [news]
author: DrMcCoy
---

During the last 2 weeks, I implemented basic support for *Neverwinter Nights 2* areas and campaigns/modules. In particular:

- Reading the list of modules and the starting module in a campaign
- Reading module areas and starting conditions
- Loading general area information like music
- Loading area geometry and objects
  - Tiles
  - Terrain
  - Doors
  - Placeables
  - Environmental objects
  - Creatures
- Flying through the areas in a "spectator mode"
- Highlighting potentially useable objects
- Hooking up a debug console
  - listcampaign/loadcampaign commands
  - listmodules/loadmodule commands
  - listareas/gotoarea commands

As a result, areas in *Neverwinter Nights 2* are now in a similarly supported state as areas in the two *Knights of the Old Republic* games.

-> [{% imgcap /images/blog/20150201_IndoorOverview_t.png 256 160 Indoor Area %}](/images/blog/20150201_IndoorOverview.png) [{% imgcap /images/blog/20150201_OutdoorOverview_t.png 256 160 Outdoor Area %}](/images/blog/20150201_OutdoorOverview.png) <-

So, here's a few interesting things and/or issues with them.

### Tiles and Metatiles ###

Like the first *Neverwinter Nights game*, areas in *Neverwinter Nights 2* are (or can be, more about that later) made up of tiles. Meaning, a grid of models define the general structure: piece of indoors floor with walls, corners, windows and/or doors. Unlike the first game, though, there's also metatitles, which are bigger models spanning the space of several regular tiles. This is used, for example, for the piece of the cave where you wake up in the *Mask of the Betrayer* expansion.

xoreos correctly loads and displays both tiles and metatiles.

-> [{% imgcap /images/blog/20150201_MetaTiles_t.png 256 160 Metatile in MotB %}](/images/blog/20150201_MetaTiles.png) <-

### Terrain ###

Also unlike the first game, areas in the second game can also use terrain instead (or maybe even additionally to) tiles. The terrain is floor geometry unique to the area, and consists of patches of land and water, together with walk mesh definitions. Terrain is used very often in outdoor areas, to give those areas a more unique and less flat feeling.

xoreos correctly loads and displays the land and water patches, in a very rudimentary and stubby way.

-> [{% imgcap /images/blog/20150201_Terrain_t.png 256 160 Terrain Geometry %}](/images/blog/20150201_Terrain.png) <-

### Environmental Object ###

*Neverwinter Nights 2* adds a new area object type: environmental objects. These seem to be quite similar to regular placeables, only that they are static and can't ever be moved. Apparently, their geometry is also baked into the area walk meshes.

As an extra weird bit, environmental objects store their position and orientation differently than all the other objects.

xoreos correctly loads and displays environmental objects in areas.

### Trees ###

*Neverwinter Nights 2* also adds new, non-static trees, courtesy of the [SpeedTree middleware](https://en.wikipedia.org/wiki/SpeedTree). Tree definitions seem to consist of just a few parameters and a random seed, the rest is done by the SpeedTree library.

xoreos does **not** load or display those trees yet. In fact, that will be a major task in the future. Luckily, trees aren't essential; them missing is not a showstopper.

### Creature Models and Animations ###

xoreos also partially loads and displays the various creatures (animals, NPCs, monsters, ...) defined in the area files. There's one caveat, though: the different model parts (head, hair, gloves, boots) aren't actually attached to the body yet. They're loaded as separate models and those are already placed correctly for default character dimensions. Of course, this would fail with scaled models (which we do not yet support).

The underlying problem is this: where the character models in *Neverwinter Nights* and *Knights of the Old Republic* contain special nodes telling the engine where to place the different body parts, *Neverwinter Nights 2* has no such thing. Instead, each skin geometry vertex has a "bone index" attribute that, I assume, are indices into the [Granny 3D](https://en.wikipedia.org/wiki/RAD_Game_Tools) animation files.

Which means: to properly attach the body parts, and to animate the models, we first need to figure those files out.

-> [{% imgcap /images/blog/20150201_CreatureModels_t.png 256 160 Bounding Boxes of the Model Parts %}](/images/blog/20150201_CreatureModels.png) <-

### Tile and Object Tinting ###

A lot of objects in *Neverwinter Nights 2* areas use [tint maps](http://www.rwscreations.com/RWSForum/viewtopic.php?f=18&t=727). These are special textures with intensity values in their color channels. When an object is loaded from the area definition, those also contain 3 color values, and those color values are combined with the intensity values in the tint map to create a unique tinting of the object. This gives you the ability to create blue-ish caskets with yellow-ish metal rings, purple carpets, green vases and the like, without having to manually create textures for each color combination.

Moreover, tiles also use this tinting.

Currently, xoreos can evaluate and use those tinting, but entirely in software. For each object, an uncompressed RGBA texture is created, and the color values are mixed on loading. Of course, this has certain drawbacks:

First of all, it's slow. But more damning, it takes up a lot of extra memory, both on the GPU and in the system's RAM. As a ballpark, a common large-ish area creates 1GB of extra textures; even more when there's a lot of objects around.

This is, of course, unacceptable. In the future, this tinting should most probably be done with shaders on the GPU.

-> [{% imgcap /images/blog/20150201_TintWithout1_t.png 256 160 Without Tinting %}](/images/blog/20150201_TintWithout1.png) [{% imgcap /images/blog/20150201_TintWith1_t.png 256 160 With Tinting %}](/images/blog/20150201_TintWith1.png) <-

-> [{% imgcap /images/blog/20150201_TintWithout2_t.png 256 160 Without Tinting %}](/images/blog/20150201_TintWithout2.png) [{% imgcap /images/blog/20150201_TintWith2_t.png 256 160 With Tinting %}](/images/blog/20150201_TintWith2.png) <-

### Terrain Tinting ###

There is another tinting mechanism: terrain geometry uses a similar approach, only more extended. Instead of just 3 mix channels, there's 6 (using 2 mixing textures) and instead of just mixing colors, textures are mixing. I.e.: a terrain patch can specify up to 6 texture that will be mixed according to the color values in 2 mix textures. The result is a layered texture that removes all visible texture tiling effects.

Additionally, each patch also has a color value to modify the texture, increasing the flexibility again.

At the moment, xoreos does none of this, for obvious reasons. Instead, the singular color value is applied to each patch, creating a more flat look.

### Doors and Chests ###

Currently, xoreos does not display most doors and chests entirely correctly: doors are missing their, well, door part (only the door frame and knob are visible) and chests are missing their lid. I have no idea if that's connected to the animation system, tinting, or what.

-> [{% imgcap /images/blog/20150201_DoorsChests_t.png 256 160 Broken Door and Chest %}](/images/blog/20150201_DoorsChests.png) <-

All in all, I'm pretty happy with the progress so far. :)
