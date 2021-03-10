---
status: published
title: Hearing the Primes
tags:
  - perl
  - software
  - mathematics
  - prime numbers
---

There are many interpretations of what the prime numbers "sound like."  Mine plays them at two speeds and in bass and treble octaves.

---

Also the program, called [primes-layered](https://github.com/ology/Music/blob/master/primes-layered), allows you to specify a few parameters to achieve a couple different effects.

Basically the program does this:

  - The prime numbers up to a given `limit` are gathered in an array.

  - A musical score is created.

  - Then the top and bottom phrases are computed and played simultaneously.

  - Finally a MIDI file is created and named after the program.

"So how are these top and bottom phrases computed?" you ask!

Well, first an appropriate patch is assigned.  The defaults are a synth for the bottom and an electric piano up top.

Then a scale in `C` is created according to the top **octave** (and one above it), and the name of the **scale**.  By default the octave is `4` and the scale is `major`.

The next thing to do is loop over the primes starting with 2, 3, 5, 7, 11, ...  And for each prime we modulo with the number of notes in the scale, and then get that note!

For the "top" part (in `C major`) the first 10 look like:

  P: 2, Mod: 2, Note: 64
  P: 3, Mod: 3, Note: 65
  P: 5, Mod: 5, Note: 69
  P: 7, Mod: 7, Note: 72
  P: 11, Mod: 11, Note: 79
  P: 13, Mod: 13, Note: 83
  P: 17, Mod: 3, Note: 65
  P: 19, Mod: 5, Note: 69
  P: 23, Mod: 9, Note: 76
  P: 29, Mod: 1, Note: 62
  ...

Where `P` is the prime number, `Mod` is the prime mapped to the number of scale notes, and `Note` is the MIDI pitch number.

The "top" part plays two octaves (14 notes).  Consequently prime number 17 modulo maps to the number three, as above.

The "top" and "bottom" parts do exactly the same thing - loop over the primes, but at different speeds and in different octaves.  The "top" plays eighth notes in the 4th and 5th octaves.  The "bottom" part plays the primes as whole notes in the 3rd octave.  So there are eight notes per bottom note.

Here is a version with the defaults:

[primes-layered-01.mp3](primes-layered-01.mp3)

And here is a version at 300 BPM with piano on top and flute on the bottom:

[primes-layered-02.mp3](primes-layered-02.mp3)
