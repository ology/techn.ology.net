---                                                                                                                                                                          
status: published
title: If Mozart Were a Programmer
tags:
  - perl
  - generative
  - music
  - software
---

How do you implement the [musical dice game](https://en.wikipedia.org/wiki/Musikalisches_W%C3%BCrfelspiel)?

tl;dr: [dice-game](https://github.com/ology/Music/blob/master/dice-game)

---

After searching a bit, I found the [transcription of possible phrases](https://musescore.com/user/30029219/scores/5943501) that were allegedly used by Mozart.  These are simple, single measures of treble and bass motifs in 3/8 time.  And there are about 100 of them.  So far, I only have 32 bars covered.

So I had my work cut out for me: 1) implement the selection and playing of these motifs.  And 2) tediously turn the measures into MIDI-Perl (the ~100 bars).

This took some head scratching:  How to get lists of the subroutines that represent each motif? How to keep the choices consistent for both treble and bass?  How to keep the treble and bass measures in sync?

For the first, I use this excellent syntax that perl affords:

    my $total_bars = 32;
    my @barst = map { my $sub = 'bart' . $_; \&$sub } 1 .. $total_bars;
    my @barsb = map { my $sub = 'barb' . $_; \&$sub } 1 .. $total_bars;

For the second, I do:

    my @choices = map { int rand @barst } 1 .. $max;

Technically, this should be the sum of two dice...  But that is the same thing as choosing at random.

For the third, I just loop over the choices executing each selected subroutine:

    my $tproc = sub {
        set_chan_patch($score, 0, $tpatch);
        $barst[$_]->() for @choices;
    };
    my $bproc = sub {
        set_chan_patch($score, 1, $bpatch);
        $barsb[$_]->()for @choices;
    };

Finally I play the two simultaneously with:

    $score->synch($tproc, $bproc);
    ...
    $score->write_score("$0.mid");

And what does a run of this sound like?

[dice-game.mp3](dice-game.mp3)