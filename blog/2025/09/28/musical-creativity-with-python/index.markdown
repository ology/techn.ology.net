---                                                                                                                                                                          
status: published
title: Musical Creativity with Python
tags:
  - Python
  - Music
  - MIDI
---

Recently, I found that there were gaps in the musical creativity packages on [pypi](https://pypi.org/). There are packages for music analysis and utilities for doing MIDI things, but nothing I could find for actual creativity. I decided to rectify this and port my [music and MIDI Perl code](https://metacpan.org/author/GENE) to Python.

---

First up was my [rhythmic phrase generator](https://metacpan.org/dist/Music-Duration-Partition) that is essential for doing things other than steady, even beats. That ended up as [https://pypi.org/project/random-rhythms/](https://pypi.org/project/random-rhythms/).

Second was my [handy MIDI drummer](https://metacpan.org/dist/MIDI-Drummer-Tiny). This makes it a no-brainer to add beats to a piece. This ended up as [https://pypi.org/project/music-drummer/](https://pypi.org/project/music-drummer/).

Third was my [Creating Rhythms](https://metacpan.org/dist/Music-CreatingRhythms) module, based on the [excellent book](https://abrazol.com/books/rhythm1/) by Hollos and Hollos. This allows for the creation of combinatorical patterns that can be used for note rhythms or beats (e.g.`euclid(m, n)` for instance). This became [https://pypi.org/project/music-creatingrhythms/](https://pypi.org/project/music-creatingrhythms/).

After porting my rhythmic modules over, I turned to tonal things.

So fourth was the fabulous module [https://metacpan.org/pod/Music::VoiceGen](https://metacpan.org/pod/Music::VoiceGen) by Jeremy Mates which I heavily depend upon for my stuff. That ended up as [https://pypi.org/project/music-voicegen/](https://pypi.org/project/music-voicegen/).

Fifth was then my [bassline generator code](https://metacpan.org/dist/Music-Bassline-Generator). What would music be without a low-end? Haha! That ended up as [https://pypi.org/project/music-bassline-generator/](https://pypi.org/project/music-bassline-generator/).

Sixth was probably the most nerdy of all chord changes - [https://metacpan.org/dist/Music-Chord-Progression-Transform](https://metacpan.org/dist/Music-Chord-Progression-Transform) - my module for doing neo-Riemannian chord progressions. This code also depends on another module that I ported by Jeremy Mates: [https://metacpan.org/pod/Music::NeoRiemannianTonnetz](https://metacpan.org/pod/Music::NeoRiemannianTonnetz). This ended up as [https://pypi.org/project/music-tonnetztransform/](https://pypi.org/project/music-tonnetztransform/).

Seventh were my [modules](https://metacpan.org/search?size=500&q=melodic+device) for converting notes and phrases with traditional types of chromatic and melodic transformations, like inversion, ornaments, and arpeggiation, etc. They became [https://pypi.org/project/music-melodicdevice/](https://pypi.org/project/music-melodicdevice/).

Eighth was my [module](https://metacpan.org/dist/Music-Chord-Progression) for creating randomized chord progressions based on weighted network transitions (from one chord to the next). This ended up as [https://pypi.org/project/chord-progression-network/](https://pypi.org/project/chord-progression-network/).

For each, I made simple musical examples and added them to the readme files for each package.

For my musical curiosities, I made a few threading MIDI players, one of which is: [https://github.com/ology/Music/blob/master/midi-thread-2.py](https://github.com/ology/Music/blob/master/midi-thread-2.py) that exercises the arpeggiation device.

This is musically realized (and is extremely long) at [https://www.youtube.com/watch?v=nbCCPr_KPdU](https://www.youtube.com/watch?v=nbCCPr_KPdU)

This open-source code can be copied and modified with any of the above packages for your own player.

Enjoy! :D
