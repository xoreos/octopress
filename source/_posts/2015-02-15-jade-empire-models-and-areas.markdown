---
layout: post
title: "Jade Empire models and areas"
date: 2015-02-15 16:25:51 +0100
comments: true
categories: [news]
author: DrMcCoy
---

Continuing with my quest to make the engines display areas (as I did [with *Neverwinter Nights 2*](/blog/2015/02/01/neverwinter-nights-2-areas/)), I turned to *Jade Empire* the last two weeks. There was just one tiny issue: xoreos didn't yet support the model format. While I could make use of other's people reverse-engineering work for the model formats of other engines ([*Neverwinter Nights* (Torlack)](https://cdn.rawgit.com/xoreos/xoreos-docs/master/specs/torlack/binmdl.html), [*Neverwinter Nights 2* (Tazpn)](http://nwn2.wikia.com/wiki/MDB_Format) and [*Knights of the Old Republic* (cchargin)](https://home.comcast.net/~cchargin/kotor/mdl_info.html)), apparently barely anybody bothered to look into *Jade Empire*. [A person called Maian tried to figure out a few thing with just a hexeditor](http://www.lucasforums.com/showpost.php?p=2318655&postcount=51), and while that was a great start (and confirmed my suspicions that the format is similar to *Knights of the Old Republic*'s), it wasn't enough for full support in xoreos.

So, with no other place to look, I buckled down and opened the *Jade Empire* binary in a disassembler.

### Models ###

The loader function was quickly found, and in combination with Maian's findings, the header was a cakewalk. The model nodes, the structures containing the mesh data, however, proved to be more tricky: the engine simply read the whole shebang into memory, to be used later.

Trying to find a shortcut, I remembered that *Neverwinter Nights* was able to load ASCII representations of its models. I searched for some common keywords like "verts" and "faces". I had luck: there still is a ASCII model loader in *Jade Empire*, and not just a remnant of older code; it was updated to load ASCII representations of *Jade Empire* models. Moreover, for the most part, it actually parsed the model values into the same struct it reads the binary data into. Meaning: I could directly map data from the model file to their ASCII name, getting their meaning handed on a platter.

-> [{% imgcap /images/blog/20150215_ModelParseHeader_t.png 256 205 Parsing the Binary Model Header %}](/images/blog/20150215_ModelParseHeader.png) [{% imgcap /images/blog/20150215_ModelParseNodeType_t.png 256 205 Parsing the Node Type %}](/images/blog/20150215_ModelParseNodeType.png) [{% imgcap /images/blog/20150215_ModelParseTriMesh_t.png 256 205 Parsing an ASCII TriMesh Node %}](/images/blog/20150215_ModelParseTriMesh.png) <-

### Untextured Geometry ###

This basically gave me the entirety of the general node header, and a good part of the TriMesh node (that contain model geometry in form of a triangle mesh) header. What it did not help with was the format of the vertex data and face indices; those were parsed into a different structure.

Chasing down the place where the binary data was put into that structure wasn't too difficult, and soon I had enough information to render basic, untextured geometry:

-> [{% imgcap /images/blog/20150215_Untextured_t.png 256 192 Untextured Geometry %}](/images/blog/20150215_Untextured.png) <-

### Materials and Textures ###

While there was a texture field in the TriMesh node, I found it was more often then not empty. Instead, there was a numerical material field, and a matching .mab file in the resource. A material definition in binary format. I also found several .mat files in the resources, ASCII material definitions. Trying my luck again for finding a loader of these in the binary, I searched for the string in the disassembly, and yes: there is a loader for the ASCII material files, parsing them into exactly the layout of the binary .mab files.

With that, and some fiddling with the offset into the vertex structure for the texture coordinates, I managed to render textured geometry:

-> [{% imgcap /images/blog/20150215_Textured_t.png 256 192 Textured Geometry %}](/images/blog/20150215_Textured.png) <-

### Triangle lists, strips and fans, oh my! ###

People familiar with *Jade Empire* might recognize that model: that's [Silk Fox](http://jadeempire.wikia.com/wiki/Silk_Fox) (SPOILER WARNING on that link!). And for some reason, she usually wears a veil in front of face. So, where's that veil?

Turns out, while meshes in *Knights of the Old Republic*'s models are always triangle lists (simple, unconnected triangles), *Jade Empire* models also contain other mesh types: [triangle strips](https://en.wikipedia.org/wiki/Triangle_strip) and [triangle fans](https://en.wikipedia.org/wiki/Triangle_fan). For the sake of simplicity, I decided to unroll them into triangle lists for now, and that made the veil visible:

-> [{% imgcap /images/blog/20150215_Veil_t.png 256 192 Veil'd %}](/images/blog/20150215_Veil.png) <-

### Now, about that vertex structure... ###

I said above that I fiddled a bit to find the texture coordinates inside the vertex structure. Well, in fact, what I did was a big, fat hack: I hard-coded the offset based on the size of the structure. Obviously, that's wrong. And it did fail for a lot of models, most prominently the models used for the area geometry.

Wasting quite some time trying to find how the vertex structure is interpreted in the disassembly (and even trying to trace it with [WineDbg](https://www.winehq.org/site/docs/winedev-guide/dbg-commands)), I eventually found the answer where I should have looked way earlier: in the *Knights of the Old Republic* model loader. Since the two model formats are similar, I could just apply what the one did to find the offset in the other. With that, the area geometry renders more correctly:

-> [{% imgcap /images/blog/20150215_AreaModel_t.png 256 192 Area Model %}](/images/blog/20150215_AreaModel.png) <-

Please note a few things. Yes, not all fields in the material definition are used yet (in fact, only the 4 base textures are used). As such, the rendering looks a bit off, especially where environment mapping should happen. That's why the roof is semi-transparent, for example.

Also, while I did find the offsets for the textures, I'm not yet sure about the other pieces of data. Specifically, the normals and data found after the texture offsets. For example, take a look at this hexdump of the vertex array for Silk Fox's head (click for a bigger view):

-> [{% imgcap /images/blog/20150215_VertexData_t.png 256 192 Vertex Data for Silk Fox's Head %}](/images/blog/20150215_VertexData.png) <-

Each colored section is a new vertex. The red box, i.e. the first twelve bytes of each vertex, is the vertex position, stored as 3 [IEEE floats](https://en.wikipedia.org/wiki/IEEE_floating_point) in [little endian](https://en.wikipedia.org/wiki/Endianness) byte order. The green box, i.e. 8 bytes at offset 0x14 within each vertex, is the first set of texture coordinates, stored as 2 IEEE floats.

Now, the field that in *Knights of the Old Republic* models denote the offset to the normals, points to 0xC. Unfortunately, there's only space for 2 floats here, while the normal usually needs 3 floats. I have frankly no idea what's going in there. In the case of the first vertex, the data could intentionally overlap, since the 0.0f would fit, but that breaks down not much later.

The data after the texture coordinates looks pretty un-floaty, more like several uint16 values. Again, no idea what that could be yet.

I am, of course, always open to suggestions if *you* should know what this could mean. :)

In either case, this brings *Jade Empire* model support close to the other model formats. I found that enough for now; I did spent about 50 hours staring at disassembly to get this far, after all.

### Areas ###

Like a lot of things, areas in *Jade Empire* are structurally similar to areas in *Knights of the Old Republic*. A .lyt file specifies the layout: the positions of several models (called "rooms") that make up the area geometry. And a .vis file specifies which rooms is visible from where, so that, in-game, rooms that are not visible from the current location can be culled from the render queue.

Unlike *Knights of the Old Republic* (and also unlike *Neverwinter Nights*), the *Jade Empire* areas don't have .are and .git files to describe static and dynamic elements of the area, like the name, the music playing in the background, and objects and creatures found within. Instead, there's another array in the .lyt file for simple, state-machine driven objects like doors, and an .art file gives some general information for each room (mostly wind, fog, camera perspective). Everything else seems to be placed or started by the game scripts.

A script system is not something I want to bind to the *Jade Empire* engine just yet, but loading the layout file and placing the room models, that I can do:

-> [{% imgcap /images/blog/20150215_TwoRivers_t.png 256 160 Two Rivers School %}](/images/blog/20150215_TwoRivers.png) [{% imgcap /images/blog/20150215_TeaHouse_t.png 256 160 Tien's Landing Tea House %}](/images/blog/20150215_TeaHouse.png) <-

Again, the same caveats as above apply: no proper material support yet. And due to these issues of missing environment mapping and wrong blending, those two screenshots are actually less ugly than others. See for yourselves:

-> [{% imgcap /images/blog/20150215_TiensLanding_t.png 256 160 Broken Transparency Masking %}](/images/blog/20150215_TiensLanding.png) [{% imgcap /images/blog/20150215_Heaven_t.png 256 160 Drawing Order vs Translucent Mesh %}](/images/blog/20150215_Heaven.png) [{% imgcap /images/blog/20150215_Mind_t.png 256 160 Bug in a Texture Loader? %}](/images/blog/20150215_Mind.png) <-

Still, apart from the missing NPCs and objects, *Jade Empire* are now in a similar state to areas in *Knights of the Old Republic*. That counts for something, no? :)
