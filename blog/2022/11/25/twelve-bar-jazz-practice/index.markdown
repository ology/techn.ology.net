---                                                                                                                                                                          
status: published
title: Twelve-bar Jazz Practice
tags:
  - perl
  - MIDI
  - music
  - software
---

I stumbled upon [this chart](Blues-Progressions.jpg) of 17 blues-jazz (jazz-blues?) chord progressions by [Dan Haerle](http://www.danhaerle.com/). Naturally, being a programmer-musician, I made a program with which to practice improv skills. (tl;dr: [blues-progressions](https://github.com/ology/Music/blob/master/blues-progressions) & audio below)

---

**UPDATE:** I made a phone-friendly, Mojolicious [web UI](https://github.com/ology/Jazz-Tool) of this engine. Woo!

**UPDATE #2:** I made a powerful cousin to this practice aid, [Rock::Tool](https://github.com/ology/Rock-Tool) - Dig it!

This is an account of the program code itself.  For examples of a couple runs, see the MP3s below.

Here is the traditional Perl preamble:

    #!/usr/bin/env perl
    use strict;
    use warnings;

Followed by the libraries and their functionality, that we will use:

    use Data::Dumper::Compact qw(ddc);              # verbose output
    use Getopt::Long qw(GetOptions);                # commandline options
    use MIDI::Drummer::Tiny ();                     # MIDI score operations
    use MIDI::Util qw(set_chan_patch midi_format);  # "
    use Music::Cadence ();                          # ending musical cadence
    use Music::Chord::Note ();                      # notes of a chord
    use Music::MelodicDevice::Transposition ();     # transpose a note
    use Music::Note ();                             # enharmonic notes

With those things declared, we define defaults, and then grab their argument values from the command-line:

    my %opts = (
        tonic   => 'C',     # note to transpose things to
        octave  => 4,       # octave of chord notes
        patch   => 5,       # 0=piano, etc general midi
        bpm     => 90,      # beats per minute
        bars    => 12,      # number of 4/4 bars
        repeat  => 1,       # number of times to repeat
        percent => 25,      # maximum half-note percentage
        hihat   => 'pedal', # pedal, closed, open
        drums   => 0,       # to drum, or not to drum?
        bass    => 0,       # to have a parallel bass or not
        simple  => 0,       # don't randomly choose a transition
        verbose => 0,
    );
    GetOptions( \%opts, 
        'tonic=s',
        'octave=i',
        'patch=i',
        'bpm=i',
        'bars=i',
        'repeat=i',
        'percent=i',
        'hihat=s',
        'drums',
        'bass',
        'simple',
        'verbose',
    );

Next we find our drummer (joke-omitted):

    my $d = MIDI::Drummer::Tiny->new(
        file   => "$0.mid",
        bars   => $opts{bars},
        bpm    => $opts{bpm},
        reverb => 15,
    );

    my @bass_notes; # global accumulator for the optional bass

This includes everything we will need to compose a MIDI score.

But we need to synchronize the patterns so that they are played simultaneously:

    $d->sync(
        \&drums,
        \&chords,
        \&bass,
    );

You can alter the drums in the following ways: Have a cheesy drumline or have a steady, quarter-note hi-hat pulse. More on that later.

Finally, write the MIDI out to a file called "blues-progressions.mid":

    $d->write;

Here are the drums:

    sub drums {
        if ($opts{drums}) {
            $d->metronome44swing($d->bars * $opts{repeat});
            $d->note($d->whole, $d->kick, $d->ride1);
        }
        else {
            my $metronome = $opts{hihat} . '_hh';
            $d->count_in({
                bars  => $d->bars * $opts{repeat},
                patch => $d->$metronome(),
            });
        }
    }

This says either play the `metronome44swing()` method, followed by a kick + ride whole-note, OR play a steady hi-hat (pedal, closed, or open).

And here is the bass subroutine:

    sub bass {
        if ($opts{bass}) {
            set_chan_patch($d->score, 1, 35);

            for (1 .. $opts{repeat}) {
                for my $n (@bass_notes) {
                    $n =~ s/^([A-G][#b]?)\d$/$1 . 3/e;
                    $d->note($d->whole, midi_format($n));
                } 
            }
        }
    }

For this, we play notes in the 3rd octave with the fretless bass patch (35).

Ok. So much for the easy bits... Next up is the meat of what we actually want to practice: Soloing over (or playing a bass-line to) the generated chords.

    sub chords {
        set_chan_patch($d->score, 0, $opts{patch});

This sets the MIDI channel and the patch we want to use.

Next are instantiations of various music programming objects. One for transposition, one for finding the notes of chords, and one for ending the progression on a cadence chord:

        my $md = Music::MelodicDevice::Transposition->new;
        my $cn = Music::Chord::Note->new;
        my $mc = Music::Cadence->new(
            key    => $opts{tonic},
            octave => $opts{octave},
            format => 'midi',
        );

Now we may wish to transpose things from the default key of C. This is done by indicating the `tonic` on the command-line invocation.

Here, C is equal to zero for the `scale()` method, meaning that we do not want to transpose. Everything else goes to 11. That is, C=0 .. B=11.

        my $transpose = $cn->scale($opts{tonic});

Next, we need the actual lists of chords to use:

        my @bars = bars();
        my %net  = net();

The bar lists and network transitions are static.  I took them from:

[![](Blues-Progressions.jpg)](Blues-Progressions.jpg)

This is freely available in the [Jazz Handbook](https://www.jazzbooks.com/jazz/fqbk).

We will be collecting MIDI note specifications (duration + pitch + octave) with this variable:

        my @specs;

So for each bar defined...

        for my $n (0 .. $d->bars - 1) {

We collect the chords of a bar (and there are 12 bars, given by the `bars()` function).

            my @pool = $bars[ $n % @bars ]->@*;

If we are running with the `simple` command-line option, use the first defined chord in each bar pool.  This results in the standard progression:

    C7 C7 C7 C7 / F7 F7 C7 C7 / G7 G7 C7 C7

If we are **not** being `simple`, then get a random chord from that list, possibly transpose it, and finally get the notes that define the chord.

            my $chord = $opts{simple} ? $pool[0] : $pool[ int rand @pool ];
            my $new_chord = transposition($transpose, $chord, $md);
            my @notes = $cn->chord_with_octave($new_chord, $opts{octave});

Keep track of the chord name(s) for verbose mode:

            my $names = $new_chord;

We use an individual MIDI note specification temporarily inside the loop:

            my @spec;

Next, we want to add either a whole or two half notes.  Whether to add a half is determined by the `simple` and `percent` command-line options:

            if (!$opts{simple} && $opts{percent} >= int(rand 100) + 1) {

The "percent" is really a "possible maximum."  The default is 25%. This means that a half-note will be chosen a **maximum** of 25% of the time. Could be less!

Anyway, if we are **not** `simple` and the `percent` is right, accumulate the computed chord notes, and re-collect for the next half-note:

                push @spec, [ $d->half, @notes ];

                @pool = $net{$chord}->@*;
                $chord = $pool[ int rand @pool ];
                my $new_chord = transposition($transpose, $chord, $md);
                @notes = $cn->chord_with_octave($new_chord, $opts{octave});

                $names .= "-$new_chord";

                push @spec, [ $d->half, @notes ];
            }

Notice that the `@pool` is defined by the `net` of the chord, rather than the nth bar. This expands the possiblities enormously.

Ok, if we have **not** decided to divide into half-notes, just add a whole-note to the score:

            else {
                push @spec, [ $d->whole, @notes ];
            }

Tell us what we've won, Bob!

            printf '%*d. %13s: %s', length($opts{bars}), $n + 1, $names, ddc(\@spec)
                if $opts{verbose};

An example of the verbose output is shown below.

Now we accumulate the note specification (either 2 halves or 1 whole):

            push @specs, @spec;
        }

Ok we made it! All chords accounted for!  Next up is to actually add them to the score.  This is done in a `for` loop for the number of repeats we (may or may not) have requested:

        for (1 .. $opts{repeat}) {
            $d->note(midi_format(@$_)) for @specs;
        }

(Note that the `midi_format()` function is used to make sure all the sharps and flats are reconizable to MIDI-Perl.)

Finally, the **first** chord of an imperfect cadence is added to the end:

        my $cadence = $mc->cadence(type => 'imperfect');  # 2 chords, but...
        $d->note($d->whole, $cadence->[0]->@*);           # only use the 1st
    }

For reference, here is the chord transposition subroutine:

    sub transposition {
        my ($transpose, $chord, $md) = @_;
        if ($transpose && $chord =~ /^([A-G][#b]?)(.*)$/) { 
            my $note = $1;
            my $flav = $2;
            my $transposed = $md->transpose($transpose, [$note]);
            (my $new_note = $transposed->[0]) =~ s/^([A-G][#b]?).*$/$1/;
            $new_note = accidental($new_note); # convert sharp to flat
            $chord = $new_note;
            $chord .= $flav if $flav;
        }
        return $chord;
    }

And here is the note/chord "flattener" subroutine:

    sub accidental {
        my ($string) = @_; # note or chord name
        if ($string =~ /^([A-G]#)(.*)?$/) { # is the note sharp?
            my $note = $1;
            my $flav = $2;
            my $mn = Music::Note->new($note, 'isobase');
            $mn->en_eq('b'); # convert to flat
            $string = $mn->format('isobase');
            $string .= $flav if $flav;
        } 
        return $string;
    }

And here are the possible chords (taken from the chart above) for the seventh-chord, 12-bar blues:

    sub bars {
        no warnings qw(qw);
        return (                                  # bar
            [qw( C7 CM7 C#m7                  )], #  1
            [qw( C7 F7  Bm7  FM7    C#m7      )], #  2
            [qw( C7 Am7 Em7  BM7              )], #  3
            [qw( C7 Gm7 Dbm7 AbM7             )], #  4
            [qw( F7 FM7                       )], #  5
            [qw( F7 Bb7 Gbm7 Gbdim7 Fm7       )], #  6
            [qw( C7 Em7 EbM7 EM7              )], #  7
            [qw( C7 A7  Bb7  Ebm7   Em7       )], #  8
            [qw( G7 D7  Dm7  Ab7    DbM7 DM7  )], #  9
            [qw( G7 F7  Abm7 Db7    Dm7  DbM7 )], # 10
            [qw( C7 Em7 FM7                   )], # 11
            [qw( C7 G7  Dm7  Ab7    Abm7 DM7  )], # 12
        );
    }

And here is the transition network for each chord to a list of connected chords:

    sub net {
        no warnings qw(qw);
        return (
            'A7'     => [qw( Ebm7 D7 Dm7 Ab7 DM7 Abm7 )],
            'Ab7'    => [qw( DbM7 Dm7 G7 )],
            ...
            'Gbdim7' => [qw( Em7 )],
            'Gm7'    => [qw( C7 Gb7 )],
        );
    }

Yes, every one is not used (yet)...

Ok now for the audio!

Sometimes I use a raw midi file, played by timidity, to practice with.  But sometimes after curating a few generated runs, I import those files into [my DAW](https://www.apple.com/logic-pro/), possibly reorganize things, and render with superior instrumentation (and possibly drums, too).

Below are various timidity renderings with their command-line options.

Btw, in [vim](https://www.vim.org/) I do this type of thing:

    :!rm -f %.mid ; perl % --verbose --simple --bass ; timidity %.mid

But anyway:

    $ perl blues-progressions --verbose --percent=20 --hihat=closed --repeat=2
    $ timidity blues-progressions.mid

[blues-progressions-01.mp3](blues-progressions-01.mp3)

This can be abbreviated, by the way:

    $ perl blues-progressions --ver --per=20 --hih=closed --rep=2

And `--verbose` **tells** you what chords (and even notes) are generated.  So that's really the way to practice - be verbose.

For me, I'll practice scales and arpeggios over `--simple` for a few `--repeat`ed phrases. Then expand harmonically:

    $ perl blues-progressions --verbose --percent=0 --tonic=Bb

Which looks and sounds like this:

    1.  BbM7: [ [ 'wn', 'Bb4', 'D5', 'F5', 'A5' ] ]
    2.   Am7: [ [ 'wn', 'A4', 'C5', 'E5', 'G5' ] ]
    3.   Bb7: [ [ 'wn', 'Bb4', 'D5', 'F5', 'Ab5' ] ]
    4.   Fm7: [ [ 'wn', 'F4', 'Ab4', 'C5', 'Eb5' ] ]
    5.   Eb7: [ [ 'wn', 'Eb4', 'G4', 'Bb4', 'Db5' ] ]
    6.   Eb7: [ [ 'wn', 'Eb4', 'G4', 'Bb4', 'Db5' ] ]
    7.   Bb7: [ [ 'wn', 'Bb4', 'D5', 'F5', 'Ab5' ] ]
    8.   Bb7: [ [ 'wn', 'Bb4', 'D5', 'F5', 'Ab5' ] ]
    9.   Cm7: [ [ 'wn', 'C4', 'Eb4', 'G4', 'Bb4' ] ]
    10.   F7: [ [ 'wn', 'F4', 'A4', 'C5', 'Eb5' ] ]
    11.  Dm7: [ [ 'wn', 'D4', 'F4', 'A4', 'C5' ] ]
    12.  Cm7: [ [ 'wn', 'C4', 'Eb4', 'G4', 'Bb4' ] ]

[blues-progressions-02.mp3](blues-progressions-02.mp3)

For the ambitious practitioner, we can speed up the tempo and make the progression "vertical" - i.e. chords seemingly stacked on top of each other.

    $ perl blues-progressions --percent=100 --patch=0 --bpm=120

[blues-progressions-03.mp3](blues-progressions-03.mp3)

If you really want, there can be a cheesy drum pattern, too:

    $ perl blues-progressions --drums

[blues-progressions-04.mp3](blues-progressions-04.mp3)

Some [Steely Dan](https://en.wikipedia.org/wiki/Steely_Dan) changes, man... But some **really** lame drums! :D

Anyway, like I say, I repeat 8 or even 12 times or more, import into my DAW for better patches, **then** I practice! :)
