---
status: published
title: IRC Music Bot
tags:
  - perl
  - music
  - software
---

Sometimes I hang out in an IRC channel with fellow musicians.  So I wrote a handy bot that does a couple musical things...

tl;dr: [irc-bot](https://github.com/ology/Miscellaneous/blob/master/irc-bot)

---

### Ingredients:

* [Mojo::IRC](https://metacpan.org/pod/Mojo::IRC)

To drive the whole thing!

* [YAML::XS](https://metacpan.org/pod/distribution/YAML-LibYAML/lib/YAML/XS.pod)

To import the configuration variables

* [Music::Note](https://metacpan.org/pod/Music::Note)

To convert between note formats

* [Music::Note::Frequency](https://metacpan.org/pod/Music::Note::Frequency)

The get note frequencies

* [App::MusicTools](https://metacpan.org/pod/App::MusicTools)

For the `vov` program

* [Music::Scales](https://metacpan.org/pod/Music::Scales#SCALES)

Used to display and select scale notes

* [Music::Chord::Note](https://metacpan.org/pod/Music::Chord::Note)

Print out a note list given a chord name

* [Music::Chord::Namer](https://metacpan.org/pod/Music::Chord::Namer)

Print out a chord name of the given notes

* [Music::Duration::Partition](https://metacpan.org/pod/Music::Duration::Partition) and

* [Data::Dumper::Compact](https://metacpan.org/pod/Data::Dumper::Compact)

Generate a randomized phrase of `pitch.duration` elements for the number of given quarter-notes

* [Music::Intervals](https://metacpan.org/pod/Music::Intervals)

For computing the intervals between pitches

* [Mojo::UserAgent](https://metacpan.org/pod/Mojo::UserAgent) and

* [Mojo::DOM](https://metacpan.org/pod/Mojo::DOM)

For fetching web data

* [Syntax::Keyword::Try](https://metacpan.org/pod/Syntax::Keyword::Try) and

* [MIDI::Util](https://metacpan.org/pod/MIDI::Util)

Generate an MP3 file based on a given phrase

### Commands:

#### *leave*

Causes the bot to /quit the network entirely

#### *help*

Prints a brief command string with examples

#### *source*

Prints the github URL of the code for this bot

#### *convert* name or number

Converts between **midinum** and **ISO** note formats

#### *patch* number (or partial name)

Prints out the name of a MIDI musical instrument for a patch number or

Prints out the MIDI instrument name and patch number for a name fragment

#### *freq* note number

Prints out the number of overtone frequencies above the given note

#### *motif* number [duration pool]

Prints a randomized phrase with notes in the key of `C` with durations

#### *vov* Roman numeral phrase

Prints chords in the key of `C`, representing the given Roman numeral phrase

For example: `vov I ii V/V`

#### *chord* C C# D D# ... B

Prints a chord name given the notes

#### *notes* C [C7|CM7|...]

Prints the notes of a given named chord

#### *interval* C C# D [D# ... B] **or** a/b c/d e/f, where a to f are integers

Prints the ratio and named intervals between the given pitches (or ratios) of a 3 note triad

Please see the long list of named intervals [here](https://metacpan.org/source/GENE/Music-Intervals-0.0602/lib%2FMusic%2FIntervals%2FRatios.pm#L11)

For example: `interval 1/1 5/4 3/2`

#### *key* 1b [1#|2b|2#|...]

Prints the named key given the number of accidentals

#### *key* F [A|Gb|D#|...]

Prints the number of accidentals given a named key

#### *scale* note scale

Prints the notes of the given scale

#### *hit* yyyymmdd

Finds the Billboard #1 hit song for that date

#### *bwv* number (or an appendix name like "Anh.208")

Prints the information on the Bach composition

Please see the [list of Bach works](https://imslp.org/wiki/List_of_works_by_Johann_Sebastian_Bach) for more information.

#### *bwv url* number (or an appendix like "Anh_208")

Prints the URL for the Bach composition

Note that The "em dash" must be used if needing a hyphen in the argument e.g. Anh.133–150.

#### *play* number number number phrase

Creates an MP3 file given the arguments: BPM, MIDI patch, repeats, and note phrase

For example: `play 70 4 2 C4.en C4.en G4.en G4.en A4.en A4.en G4.qn`

#### *range* instrument

Prints the note-octave range for the given instrument

Instruments: violin, viola, cello, bass, trumpet, trombone, french_horn, tuba, piccolo, flute, oboe, clarinet, alto_sax, tenor_sax, baritone_sax, bassoon, harp, harpsichord, piano, xylophone, glockenspiel, vibraphone, timpani, marimba, guitar

[![instrument-ranges](instrument-ranges.jpg)](instrument-ranges.jpg)

