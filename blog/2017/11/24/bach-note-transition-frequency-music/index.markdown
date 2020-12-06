---
status: published
title: Bach Note Transition Frequency "Music"
tags:
    - perl
    - software
    - MIDI
    - analysis
---

What are the note frequencies of music by Bach?  That is, "How often does an F follow a C?" etc.  What does it sound like if you "reconstruct" playable music from these frequencies?

Let's see!

---

First, we find some Bach MIDI.  I chose to use [Jesu Joy of Mans Desiring](bach_jesu_joy_with_piano.mid).

Next, we feed that to my [note-transition](https://github.com/ology/Music/blob/master/note-transition) program:

    > perl note-transition /Users/gene/Downloads/bach_jesu_joy_with_piano.mid

This produces a file called "note-transition.dat" that is a collection of the MIDI note numbers and their proportional frequencies of one track.  Here is part of Jesu:

    67 => {
        69 => 0.4,
        71 => 0.6
    },
    69 => {
        67 => 0.230769230769231,
        69 => 0.153846153846154,
        72 => 0.0769230769230769,
        71 => 0.538461538461538
    },
    71 => {
        69 => 0.476190476190476,
        72 => 0.523809523809524
    },
    72 => {
        71 => 0.444444444444444,
        74 => 0.444444444444444,
        72 => 0.111111111111111
    },
    74 => {
        72 => 0.307692307692308,
        74 => 0.230769230769231,
        71 => 0.307692307692308,
        76 => 0.153846153846154
    },
    76 => {
        77 => 0.333333333333333,
        76 => 0.333333333333333,
        74 => 0.333333333333333
    },
    77 => {
        74 => 1
    }

This says, for instance, that MIDI pitch number 67 transitions to pitch 69 40% of the time, and pitch 71 60% of the time.

Next we feed that result file to my [stat-walk](https://github.com/ology/Music/blob/master/stat-walk) program, asking for 128 notes:

    > perl stat-walk note-transition.dat 128

This program is very simple.  Each note gets a quarter note value and there are no dynamics like velocity changes.  Anyway, the above command produces a MIDI file called "stat-walk.mid" which you can hear with a handy program like [timidity](http://timidity.sourceforge.net/):

    > timidity stat-walk.mid

But I took the liberty of enhancing it a bit with my DAW and came up with this:

[note-transition-stat-walk.mp3](note-transition-stat-walk.mp3)
 
**Update:** I made copies of the programs that honor multiple tracks.  The output is spartan - a simultaneous quarter note for each track of notes. YMMV: [note-transition-sync](https://github.com/ology/Music/blob/master/note-transition-sync) and [stat-walk-sync](https://github.com/ology/Music/blob/master/stat-walk-sync).  Here is our Bach:

[stat-walk-sync-jesu.mp3](stat-walk-sync-jesu.mp3)
 
And here is a very different Beethoven Moonlight Sonata:

[stat-walk-sync-moonlight.mp3](stat-walk-sync-moonlight.mp3)
 
