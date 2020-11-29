---
title: Generating Musical Phrases - Round II
tags:
    - music
    - software
    - perl
    - MIDI
    - generative
---

It seems I am always fiddling with algorithmic musical composition.  Most recently it is with the program, polygenic, which is a descendant of the program in the previous post on this subject.

~

For this program, first up is to declare our standard Perl preamble.  Then version 5.20 is required (in order to allow ["post-deref" syntax](https://perldoc.perl.org/perlref#Postfix-Dereference-Syntax)), and some of my favorite music modules - well many!

Anyway, next the program either gets or sets defaults for its parameters.  (The "getting" is done via the command-line as arguments given to the program.)  For instance, the default generated composition will be in the key of A minor at 105 beats per minute.

A [drummer](https://metacpan.org/release/MIDI-Drummer-Tiny) is created.  This includes a handy score object.  The beat count is initialized at zero, the 3 parts are synchronized (i.e. played simultaneously), and the score is written to a MIDI file, which is set by the drummer and named after the program.

Pretty simple, eh?  Haha!  (Well yes, to me, the author, it is.)

The meat of this program lies in the two parts called "top()" and "bottom()" - Brilliant names, yes?  They are both extremely similar, but each have entirely different repeated phrases, and are in different octaves.

Please see the source code if you are interested in the workings.  But here are a couple audio examples.  Both are in 5/4 (drums and bass), but the top parts are in 4/4.  Why 5/4?  Because I am fascinated with odd meters and polyrhythms.

In the first, the top part is made with combinations of half, quarter and eighth notes.  The second adds triplet eighth notes to the mix.  I call this "solo mode."  Haha.

[polygenic-10-Solo-mode.mp3](https://www.ology.net/tech/wp-content/uploads/polygenic-10-Solo-mode.mp3)

[polygenic-10-Solo-mode-1.mp3](https://www.ology.net/tech/wp-content/uploads/polygenic-10-Solo-mode-1.mp3)

Ok. One more.  This has phrases with "charming grace-notes", because the phrase generator produced one without proper triplets:

[polygenic-9-Charming-grace-notes.mp3](https://www.ology.net/tech/wp-content/uploads/polygenic-9-Charming-grace-notes.mp3)

**UPDATE:**

The [descendant program](https://github.com/ology/Music/blob/master/chordal) that adds, what sound like chords:

[chordal-03.mp3](https://www.ology.net/tech/wp-content/uploads/chordal-03.mp3)

Here is the same descendant program, but playing every other bar a whole note on top instead of the solo notes:

[chordal-04.mp3](https://www.ology.net/tech/wp-content/uploads/chordal-04.mp3)
