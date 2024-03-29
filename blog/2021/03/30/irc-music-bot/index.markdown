---
status: published
title: IRC Music Bot
tags:
  - perl
  - music
  - software
---

Sometimes I hang out in an IRC channel with fellow musicians.  So I wrote a handy bot that does a couple musical things...

tl;dr: [irc-bot](https://github.com/ology/Music/blob/master/irc-bot)

---

### Ingredients:

* [Mojo::IRC](https://metacpan.org/pod/Mojo::IRC) - To drive the whole thing!
* [YAML::XS](https://metacpan.org/pod/distribution/YAML-LibYAML/lib/YAML/XS.pod) - To import the configuration
* [Music::Note](https://metacpan.org/pod/Music::Note) - To convert between note formats
* [Music::Note::Frequency](https://metacpan.org/pod/Music::Note::Frequency) - To get note frequencies
* [App::MusicTools](https://metacpan.org/pod/App::MusicTools) - For the `vov` program
* [Music::Scales](https://metacpan.org/pod/Music::Scales) - Used to display and select scale notes
* [Music::Chord::Note](https://metacpan.org/pod/Music::Chord::Note) - Print out a note list given a chord name
* [Music::Chord::Namer](https://metacpan.org/pod/Music::Chord::Namer) - Print out a chord name of the given notes
* [Music::Duration::Partition](https://metacpan.org/pod/Music::Duration::Partition) and [Data::Dumper::Compact](https://metacpan.org/pod/Data::Dumper::Compact) - Generate a randomized phrase of `pitch.duration` elements
* [Music::Intervals](https://metacpan.org/pod/Music::Intervals) - For computing the intervals between pitches
* [Music::ModalFunction](https://metacpan.org/pod/Music::ModalFunction) - For comparing modal scale chords
* [Mojo::UserAgent](https://metacpan.org/pod/Mojo::UserAgent) and [Mojo::DOM](https://metacpan.org/pod/Mojo::DOM) - For fetching web data
* [Syntax::Keyword::Try](https://metacpan.org/pod/Syntax::Keyword::Try) and [MIDI::Util](https://metacpan.org/pod/MIDI::Util) and [MP3::Tag](https://metacpan.org/pod/MP3::Tag) - Generate an MP3 file based on a given phrase
* A server to host MP3 files and run the fretboard diagram app
* [MIDI::Drummer::Tiny](https://metacpan.org/pod/MIDI::Drummer::Tiny) - Produce a drum track
* [MIDI::Chord::Guitar](https://metacpan.org/pod/MIDI::Chord::Guitar) - Prints out guitar chord neck position fingerings

### Commands:

#### *leave*

Causes the bot to /quit the network entirely

#### *help*

Prints out the URL to this page!

#### *source*

Prints the github URL of the code for this bot

 ---

#### *convert* name or number

Converts between **midinum** and **ISO** note formats

#### *freq* note number

Prints out the number of overtone frequencies above the given note

 ---

#### *chord* C C# D D# ... B

Prints a chord name given the notes

#### *notes* C [C7|CM7|...]

Prints the notes of a given named chord

#### *vov* Roman numeral phrase

Prints chords in the key of `C`, representing the given Roman numeral phrase

For example: `vov I ii V/V`

 ---

#### *interval* C C# D [D# ...]

#### *interval* a/b c/d e/f, where a-f are integers

Prints the intervals between the given two or three named pitches or ratios

For example: `interval 1/1 5/4 3/2`

#### *ratio* C [G, F, pm3, pM3 ...]

#### *ratio* 1/1 [3/2, 4/3, 32/27, 81/64 ...]

Prints the description and numeric ratio for the given named pitch **or** the pitch name for a given numeric ratio

Please see the long list of named intervals and ratios [here](https://metacpan.org/release/Music-Intervals/source/lib/Music/Intervals/Ratios.pm#L11)

 ---

#### *key* 1b [1#|2b|2#|...]

Prints the named key given the number of accidentals

#### *key* F [A|Gb|D#|...]

Prints the number of accidentals given a named key

#### *scale* note scale

Prints the notes of the given scale

Please see the list of scales [here](https://metacpan.org/pod/Music::Scales#SCALES)

#### *common* mode1 mode2

Lists the chords shared by modal scales.

For example: `common c_ionian f_ionian` or `c_ionian a_aeolian` etc.

 ---

#### *fingering* D3 m

Show the fingerings for the note and chord

Please see the known chords [here](https://metacpan.org/source/GENE/MIDI-Chord-Guitar-0.0604/share%2Fmidi-guitar-chord-voicings.csv)

#### *fret* x02220 1

Prints the URL to a guitar fretboard diagram given the fingering and neck position arguments

 ---

#### *hit* yyyymmdd

Finds the Billboard #1 hit song for that date

#### *bwv* number (or an appendix name like "Anh.208")

Prints the information on the Bach composition

Please see the [list of Bach works](https://imslp.org/wiki/List_of_works_by_Johann_Sebastian_Bach) for more information.

#### *bwv url* number (or an appendix like "Anh_208")

Prints the URL for the Bach composition

Note that The "em dash" must be used if needing a hyphen in the argument e.g. Anh.133–150.

 ---

#### *motif* number [duration pool]

Prints a randomized phrase of the number of beats with notes in the key of `C` given the pool of durations

#### *play* [number [number]] phrase

Creates an MP3 file given the arguments: BPM, repeats, and a note phrase with embedded patch, volume and panning changes

A note is represented by a letter and optional accidental (`#` or `b`), the octave number, and then a period followed by a duration (e.g. wn, hn, dqn, ten, d96, etc.).

The `d96` duration is the "raw tick" value of the handy abbreviations.  These may be used for tied notes.  96 ticks are equal to one quarter note.  `d336` would be a tie of 3.5 notes.

Volume changes are indicated with a `~` symbol.  Patch changes are indicated with `^`.  Panning is `!`.  Each can be from `0` to `127`.

For example: `play 70 2 ^0 ~100 C4.en C4.en G4.en G4.en ^70 ~127 A4.en A4.en G4.qn`

The BPM and repeats arguments are optional.  If left off they will default to 100 and 2, respectively.

If there are no patch changes, a piano will be used.

Also, named chords are supported, and are indicated with a `=` symbol.  Octaves are given by a period followed by the number of the octave. The duration is further specified with another period followed by a duration.  If not given, they default to octave `4` and duration `wn`.

For example: `play 100 2 ^24 =C =F =G =G =F =C`

Another example: `play =C7.5.qn =Dm7.5.qn =G.5.qn =G7.5.qn =F7.5.qn =C.5.qn`

Please see the list of chord names [here](https://metacpan.org/release/Music-Chord-Note/source/lib/Music/Chord/Note.pm#L12)

#### *perc* [number [number]] phrase

Creates an MP3 file given the arguments: BPM, repeats, and percussion phrase

Volume changes are indicated with a `~` symbol.

For example: `perc 120 4 kick.qn snare.qn kick.en kick.en snare.qn`

Two simultaneous strikes can be achieved in a `()` group:

`perc (kick closed_hh).qn (snare closed_hh).qn (kick closed_hh).en kick.en (snare closed_hh).qn`

Please see the percussion instrument names [here](https://metacpan.org/pod/MIDI::Drummer::Tiny#KIT) (and ignore the rest of that document)

Conveniently, these abbreviations may be used when making a phrase:

    oh => open_hh
    ch => closed_hh
    ph => pedal_hh
    c1 => crash1
    c2 => crash2
    cn => china
    sp => splash
    r1 => ride1
    r2 => ride2
    rb => ride_bell
    sn => snare
    es => electric_snare
    ht => hi_tom
    mt => hi_mid_tom
    ft => hi_floor_tom
    bd => kick
    eb => electric_bass

 ---

#### *patch* number (or partial name)

Prints out the name of a MIDI musical instrument for a patch number or

Prints out the MIDI instrument name and patch number for an instrument name fragment or class of instruments

The classes are:

    bass
    brass
    effect
    idiophone
    keyboard
    lamellaphone
    membranophone
    string
    synth
    voice
    wind

#### *range* instrument

Prints the note-octave range for the given instrument

Instruments: violin, viola, cello, bass, trumpet, trombone, french_horn, tuba, piccolo, flute, oboe, clarinet, alto_sax, tenor_sax, baritone_sax, bassoon, harp, harpsichord, piano, xylophone, glockenspiel, vibraphone, timpani, marimba, guitar

[![instrument-ranges](instrument-ranges.jpg)](instrument-ranges.jpg)

