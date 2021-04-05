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

* [App::MusicTools](https://metacpan.org/pod/App::MusicTools)

For the `vov` program

* [Music::Scales](https://metacpan.org/pod/Music::Scales)

Used to display scale notes and

Used to select random scale notes for the *motif* command

* [Music::Chord::Note](https://metacpan.org/pod/Music::Chord::Note)

Print out a note list given a chord name for the *chord* command

* [Music::Chord::Namer](https://metacpan.org/pod/Music::Chord::Namer)

Print out a chord name of the given notes for the *notes* command

* [Music::Duration::Partition](https://metacpan.org/pod/Music::Duration::Partition) and

* [Data::Dumper::Compact](https://metacpan.org/pod/Data::Dumper::Compact)

Generate a randomized phrase of `pitch.duration` elements for the number of given quarter-notes

* [Music::Intervals](https://metacpan.org/pod/Music::Intervals)

For computing the intervals between pitches

* [Mojo::UserAgent](https://metacpan.org/pod/Mojo::UserAgent) and

* [Mojo::DOM](https://metacpan.org/pod/Mojo::DOM)

For finding out Billboard #1 hit songs

### Commands:

* *leave*

Causes the bot to /quit the network entirely

* *help*

Prints a brief command string with examples

* *source*

Prints the github URL of the code for this bot

* *motif* number [duration pool]

Prints a randomized phrase with notes in the key of `C` with durations

* *vov* Roman numeral phrase

Prints chords in the key of `C`, representing the given Roman numeral phrase

* *notes* C C# D D# ... B

Prints a chord name given the notes

* *chord* C [C7|CM7|...]

Prints the notes of a given named chord

* *interval* C C# D D# ... B

Prints the ratio and named intervals between the given pitches

* *key* 1b [1#|2b|2#|...]

Prints the named key given the number of accidentals

* *key* F [A|Gb|D#|...]

Prints the number of accidentals given a named key

* *scale* D minor

Prints the notes of the given scale

* *hit* 19700101

Finds the Billboard #1 hit song for that date

