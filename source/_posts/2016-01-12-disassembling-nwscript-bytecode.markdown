---
layout: post
title: "Disassembling NWScript Bytecode"
date: 2016-01-12 14:00:00 +0100
comments: true
comments: true
categories: [news, progress]
author: DrMcCoy
---

As I already said in last year's [retrospective](/blog/2015/11/27/not-thanksgiving-2015/), I want to write a bit about NWScript and its bytecode.

First of all, what is NWScript? NWScript is the scripting language and system BioWare introduced with *Neverwinter Nights* and used, with improvements and changes, throughout the Aurora-based games. Specifically, you can find NWScript driving the high-level game logic of *Neverwinter Nights*, *Neverwinter Nights 2*, *Knights of the Old Republic*, *Knights of the Old Republic II*, *Jade Empire*, *The Witcher* (in combination with [Lua](http://www.lua.org/)), *Dragon Age: Origins* and *Dragon Age II*. This is nearly every single game xoreos targets. The only exception is the Nintendo DS game, *Sonic Chronicles: The Dark Brotherhood*, which doesn't seem to use any scripts at all.

NWScript is written in a [C](https://en.wikipedia.org/wiki/C_%28programming_language%29)-like language and saved with the .nss extension. A [compiler](https://en.wikipedia.org/wiki/Compiler) then translates it into a [stack](https://en.wikipedia.org/wiki/Stack_%28abstract_data_type%29)-based [bytecode](https://en.wikipedia.org/wiki/Bytecode) with the .ncs extension, which is what the game executes. That is similar to how ActionScript in Flash videos works, and how Java, Lua and other scripting languages can operate.

Like C, NWScript is a strongly typed language: each variable has one definite type. Among the available types are "int" (32-bit signed integer), "float" (32-bit IEEE floating point), "string" (a textual ASCII string) and "object" (an object in the game world, like an NPC or a chest). Moreover, there are several engine types, like "event" and "effect", though which of these are available depends on the game. There are also [structs](https://en.wikipedia.org/wiki/Record_%28computer_science%29), but in the compiled bytecode, they vanish and are replaced by a collection of loose variables. Likewise, the "vector" type is treated as three single float variables. A special type is the "action" type, a script state (or [functor](https://en.wikipedia.org/wiki/Functor)) that's stored separately.

Additionally, *Dragon Age: Origins* adds a "resource" type (which, in the bytecode, can be used interchangeably with the "string" type) and dynamic arrays. *Dragon Age II* in turn adds the concept of a reference to a variable to help performance in several use-cases. For these new features, these two games each add two new bytecode opcodes, something not done for any of the other post-*Neverwinter Nights* games.

To get and modify the state of the game world, like searching for objects and moving them, and for complex mathematical operations like trigonometry functions, the NWScript bytecode can call so-called engine functions. These are functions that are provided by the game itself; about 850 per game, with some overlap. They're declared in the nwscript.nss file (nwscriptdefn.nss for *The Witcher* and script.ldf for the *Dragon Age* games) of each game.

The original *Neverwinter Nights* toolset came with a compiler, but a part of the modding community, the OpenKnights Consortium, created their own, free software compiler, nwnnsscomp. Unfortunately, it has a few disadvantages. For example, it always needs the nwscript.nss file and it also only handles Neverwinter Nights. And while there has been several variations that have been extended to handle newer games, many of these are only available as Windows binaries. As far as I'm aware, there never has been a variation that handles *Dragon Age: Origins* or *Dragon Age II*. Also, since the code hasn't been touched for 10 years, it's difficult to compile now, and it doesn't work when compiled for 64-bit. For what it's worth, I mirrored the old OpenKnights NWNTools, with a few changes, to [GitHub here](https://github.com/DrMcCoy/NWNTools).

This nwnnsscomp also has a disassembly mode, which can convert the compiled bytecode into somewhat human-readable assembly. This is pretty useful! I wanted my own disassembler in [xoreos-tools](https://github.com/xoreos/xoreos-tools).

The steps to disassemble NWScript bytecode are the following:

**1) Read instructions**

Read the .ncs file, instruction for instruction. An instruction consists of an opcode (like `ADD` for addition), the argument types (which are taken from or pushed onto the stack) and any direct arguments. For example, an addition that operates on two integers would be known as `ADDII`. The instructions are stored in a list, one after the other.

**2) Link instructions**

Each instruction may have a follower, the instruction that follows naturally. For most instructions, this is the instruction next in the list. But certain branching instruction, jumps and subroutine calls, also have jump destinations that may be taken.

**3) Create blocks**

Group the instructions into [blocks](https://en.wikipedia.org/wiki/Basic_block). A block is a sequence of instructions that follow each other, with two constraints: a jump into a block can only land at the beginning of a block and a jump out of a block can only happen at the end of the block.

**4) Create subroutines**

Group the blocks into [subroutines](https://en.wikipedia.org/wiki/Subroutine). A subroutine is a sequence of blocks that gets jumped to by a special opcode, `JSR`, and returns to the place from where it has been called with `RETN`. (In many programming languages, for example C, these are also called functions, but we're calling them subroutines so that they're not being confused with engine functions. Subroutine is also often the usual term in assembly dialects.)

**5) Link subroutines**

Record where a subroutine calls another and link the caller and callee, so that a call graph could be created easily. Likewise, the instructions that start and end the subroutine are also separately recorded.

**6) Identify "special" subroutines**

There's three special subroutine that we can identify:

- \_start(), the very first subroutine that starts execution of the script. It's the subroutine that contains the very first instruction in the .ncs file.
- \_global(), which, if it exists, sets up the global variables. This is the subroutine that contains an instruction with a `SAVEBP` opcode.
- main(), which is the `main` or `StartingConditional` function visible in the script source. If a \_global() subroutine exists, this is the last subroutine called by \_global(). Otherwise, it's the last (and only) subroutine called by \_start().

**7) Analyze the stack**

This step goes through the whole script and evaluates each instruction for how it manipulates the stack. Since stack elements are explicitly typed, and instructions that create new stack elements know which type they create (either explicitly, or implicitly by copying an already typed element), both the size of the stack and the type of all elements can be figured out. At the end, each instruction will know how the stack looks before its execution. And for each subroutine, we then know its signature: how many parameters it takes, what their types are and what the subroutine returns.

However, this step only works if we know which game this script is from, because we need to know the signatures of the engine functions. And, unfortunately, this step fails when the script subroutines call each other recursively. The stack of a recursing script can't be analyzed like this.

**8) Analyze the control flow**

So far, the script disassembly consists of blocks that jump to each other, with no further meaning attached. To extract this deeper meaning, we analyze the control flow for higher-level control structures: [do-while loops](https://en.wikipedia.org/wiki/Do_while_loop), [while loops](https://en.wikipedia.org/wiki/While_loop), [if and if-else blocks](https://en.wikipedia.org/wiki/Conditional_%28computer_programming%29), together with [break](https://en.wikipedia.org/wiki/Control_flow#Early_exit_from_loops) and [continue](https://en.wikipedia.org/wiki/Control_flow#Continuation_with_next_iteration) statements and early subroutine returns. Each block gets a list of designators that show if and how it contributes to such a control structure.

**9) Create output**

Finally, we create an output. This can be one of three:

- A full listing, including offset, raw bytes and disassembly. This is similar to the output created by the disassembly mode of the OpenKnights nwnnsscomp.
- Only the disassembly. This output might be used to reassemble the script some time later, should someone want to write an assembler.
- A [DOT](https://en.wikipedia.org/wiki/DOT_%28graph_description_language%29) file. A DOT file is a textual description of a graph, which can be plotted into a graph with the [Graphviz](http://www.graphviz.org/) tool. The result is a clear representation of the control flow in graph form.

As an example, here's a script from *Neverwinter Nights 2*: [this is the original source](/text/2443_tr_portal_cl.nss.txt), and [this is the full listing output](/text/2443_tr_portal_cl.lst.txt), [the assembly-only output](/text/2443_tr_portal_cl.asm.txt) and [the control flow graph](/images/blog/20151127_2443_tr_portal_cl.png).

During this work, I have found a few interesting little bugs in the original BioWare NWScript compiler. For example, this little script, hf\_c\_skill\_value.nss in *Neverwinter Nights 2* and its disassembly:

```
int StartingConditional(int nSkill, int nValue)
{
  object oPC = GetPCSpeaker();
  int nSkill = GetSkillRank(nSkill, oPC);
  return (nSkill >= nValue);
}
```
```
  00000017 02 06                      RSADDO
  00000019 05 00 00EE 00              ACTION GetPCSpeaker 0
  0000001E 01 01 FFFFFFF8 0004        CPDOWNSP -8 4
  00000026 1B 00 FFFFFFFC             MOVSP -4
  0000002C 02 03                      RSADDI
  0000002E 04 03 00000000             CONSTI 0
  00000034 03 01 FFFFFFF4 0004        CPTOPSP -12 4
  0000003C 03 01 FFFFFFF4 0004        CPTOPSP -12 4
  00000044 05 00 013B 03              ACTION GetSkillRank 3
```

Specifically, the `int nSkill = GetSkillRank(nSkill, oPC);` line is compiled wrong. First, an instruction with the opcode `RSADDI` is generated, which creates a new integer variable on the stack, for `nSkill`. Then, the arguments for `GetSkillRank` are pushed onto the stack, and `GetSkillRank` is called using the ACTION instruction.

Unfortunately, as soon as the compiler creates the stack space for the local variable `nSkill`, it associates `nSkill` with this local variable. So when it's time to push the parameter `nSkill` for `GetSkillRank` on the stack, the parameter to the outer `StartingConditional` subroutine has already been overruled, and the `CPTOPSP` points to the new local variable.

This renders the `nSkill` parameter unused and useless, and `GetSkillRank` is potentially called with an uninitialized value.

For another example, have a look at this script from *Neverwinter Nights*:

```
int StartingConditional()
{
  int iResult;
  object oPC = GetPCSpeaker();

  iResult = GetClassByPosition(1,oPC) == CLASS_TYPE_DRUID ||
            GetClassByPosition(2,oPC) == CLASS_TYPE_DRUID ||
            GetClassByPosition(3,oPC) == CLASS_TYPE_DRUID;
  return iResult;
}
```

It's meant to check whether the player character is a druid. Since you can multi-class in *Neverwinter Nights*, it checks whether the character is a druid for the first class, for the second class and then the third class. If any of these return true, `iResult` will be set to true. To achieve this, a [boolean disjunction ("or" operation)](https://en.wikipedia.org/wiki/Boolean_algebra#Operations) is used. As is customary in C-like languages, the boolean disjunction in NWScript is supposed to support short-circuiting: if the first part is already true, the second (and third) checks aren't even called.

Let's see how the disassembly graph looks like:

-> [{% imgcap /images/blog/20160112_orbioware.png 491 816 BioWare Disassembly %}](/images/blog/20160112_orbioware.png) <-

The first `EQII` is the first comparison, and then the block in loc\_00000057 is supposed to do the short-circuiting. It duplicates the top-most stack element with a `CPTOPSP -4 4` before bypassing the second comparison and jumping to the `LOGORII` that does the boolean disjunction. Unfortunately, instead of directly jumping to loc\_00000080 with a `JMP`, a `JZ` was generated instead. And since the top-most stack element was already duplicated and checked with the previous `JZ`, we know that the true-edge is never taken. It is a dead edge.

This has an interesting consequence. The short-circuiting for the boolean disjunction is broken: all parts are always evaluated before the results are or'ed together. In practice, this doesn't matter much. It makes the code a bit slower, and any side effects will always happen.

Additionally, if the true edge were ever taken, the stack would be in a broken state. Unlike `JMP`, `JZ` consumes a stack element, and so the `LOGORII` would be missing one of its arguments. Because this is not possible, it doesn't matter for execution, but my stack analysis dies there. To combat this problem, I added an extra disassembly step after the block generation, the detection of these dead edges. To keep it simple, I only do some simple pattern matching, which is enough for most scripts. There are a few cases where it fails, though.

This bug is present in the original scripts coming with *Neverwinter Nights*, *Knights of the Old Republic* and *Knights of the Old Republic II*, but has already been fixed by the release of *Neverwinter Nights 2*.

This bug is also not present in the OpenKnights compiler:

-> [{% imgcap /images/blog/20160112_oropenknights.png 596 699 OpenKnights Disassembly %}](/images/blog/20160112_oropenknights.png) <-

As you can see, the branch instruction in loc\_00000057 is a `JMP`, as it should be.

So, to recap, xoreos-tools now has a tool that can disassemble NWScript bytecode, similar to the disassemble mode of the OpenKnights nwnnsscomp, with these added features:

- Easier to compile.
- Works compiled as 64-bit.
- Out-of-the-box support for the NWScript found in all Aurora-based games.
- No need for a separate nwscript.nss.
- Support for new array and reference opcodes.
- Deeper analysis of the stack, to figure out the subroutine signatures.
- Deeper analysis of the control flow, to detect higher-level control structures.
- Can create control flow graphs in DOT format.

If you're interested, the source is available [here](https://github.com/xoreos/xoreos-tools/tree/master/src/nwscript). Binaries will come with the next release of xoreos and xoreos-tools.

There is, however, still a lot left to do there:

- Create a decompiler: use the detected control structures as a base to generate C-like NWScript source code.
- Detect chained instructions: something like "int a = b * c" compiles to a lot of instructions that create temporary stack variables.
- Detect structs and vectors.

Unlike nwnnsscomp, xoreos-tools is still missing a compiler as well. This is something that would be very nice to have indeed. An assembler, which can take the disassembly output and create a working .ncs file out of it would probably be a useful first step in that direction.

If *you* would like to help and take up any of these tasks, or any other task from our [TODO list](https://wiki.xoreos.org/index.php?title=TODO), please [contact us](https://wiki.xoreos.org/index.php?title=Contact_us)! :)
