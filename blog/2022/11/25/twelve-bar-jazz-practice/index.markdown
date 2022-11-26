---                                                                                                                                                                          
status: published
title: Twelve-bar Jazz Practice
tags:
  - perl
  - MIDI
  - music
  - software
---

I stumbled upon this chart of 17 blues-jazz (jazz-blues?) chord progressions. Naturally, being a programmer, I made a program with which to practice. (tl:dr: [blues-progressions](https://github.com/ology/Music/blob/master/blues-progressions) & audio below)

---

This is an account of the program code itself.  For an example of a couple runs, see the MP3s below.

As usual, I generally do **not** use the raw midi file.  Instead, I import the file into [my DAW](https://www.apple.com/logic-pro/) and render it with superior instrumentation.

The traditional Perl preamble:

    #!/usr/bin/env perl
    use strict;
    use warnings;

The libraries and their functionality, that we will use:

    use Data::Dumper::Compact qw(ddc);              # verbose output
    use Getopt::Long qw(GetOptions);                # commandline options
    use MIDI::Drummer::Tiny ();                     # MIDI score operations
    use MIDI::Util qw(set_chan_patch midi_format);  # "
    use Music::Cadence ();                          # ending musical cadence
    use Music::Chord::Note ();                      # notes of a chord
    use Music::MelodicDevice::Transposition ();     # transpose a note

First up, we define and the grab the values for the command-line given, program options:

    my %opts = (
        tonic   => 'C',     # note to transpose things to
        octave  => 4,       # octave of chord notes
        patch   => 5,       # 0=piano, etc general midi
        bpm     => 90,      # beats per minute
        bars    => 12,      # number of 4/4 bars
        repeat  => 1,       # number of times to repeat
        percent => 25,      # maximum half-note percentage
        drums   => 0,       # to drum, or not to drum?
        metrono => 'pedal', # hihat: pedal, closed, open
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
        'drums',
        'metrono=s',
        'verbose',
    );

Next we find our drummer (joke-omitted):

    my $d = MIDI::Drummer::Tiny->new(
        file   => "$0.mid",
        bars   => $opts{bars},
        bpm    => $opts{bpm},
        reverb => 15,
    );

This includes everything we will need to compose a MIDI score.

But we need to synchronize the two patterns, so that they are played simultaneously:

    $d->sync(
        \&drums,
        \&chords,
    );

You can alter the drums in the following ways: Have a cheesey drumline or have a steady, quarter-note hi-hat pulse. More on that later.

Finally, write the MIDI out to a file called "blues-progressions.mid":

    $d->write;

Here are the drums:

    sub drums {
        if ($opts{drums}) {
            $d->metronome44swing($d->bars * $opts{repeat});
            $d->note($d->whole, $d->kick, $d->ride1);
        }
        else {
            my $metronome = $opts{metrono} . '_hh';
            $d->count_in({
                bars  => $d->bars * $opts{repeat},
                patch => $d->$metronome(),
            });
        }
    }

This says either play the `metronome44swing()` method, followed by a kick + ride whole-note, OR play a steady hi-hat (pedal, closed, or open).

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

Now we may wish to transpose things from the default key of C. This is done by indicating the tonic in the command-line invocation.

Here, C is equal to zero for the `scale()` method, meaning that we do not want to transpose. Anything else goes to 11. That is, C=0 .. B=11.

        my $transpose = $cn->scale($opts{tonic});

Ok the bar lists and network transitions are static.  I took them from

[![](Blues-Progressions.jpg)](Blues-Progressions.jpg)

which is freely available in the [Jazz Handbook](https://www.jazzbooks.com/jazz/fqbk).

        my @bars = bars();
        my %net  = net();

We will be collecting MIDI note specifications (duration + pitch + octave) with this variable:

        my @specs;

So for each bar defined...

        for my $n (0 .. $d->bars - 1) {

Collect the chords of a bar (and there are 12 of them known, given by the `bars()` function). Then get a random chord from that list, possibly transpose it, and finally get the notes that define the chord:

            my @pool = $bars[ $n % @bars ]->@*;
            my $chord = $pool[ int rand @pool ];
            my $new_chord = transposition($transpose, $chord, $md);
            my @notes = $cn->chord_with_octave($new_chord, $opts{octave});

Keep track of the chord name(s) for verbose mode:

            my $names = $new_chord;

This is an individual MIDI note specification, for temporary use inside the loop:

            my @spec;

Next, we want to add either a whole or two half notes.  Whether to add a half is determined by the percent command option:

            if ($opts{percent} >= int(rand 100) + 1) {

Accumulate the compued chord notes, and re-collect for the next half-note:

                push @spec, [ $d->half, @notes ];

                @pool = $net{$chord}->@*;
                $chord = $pool[ int rand @pool ];
                my $new_chord = transposition($transpose, $chord, $md);
                @notes = $cn->chord_with_octave($new_chord, $opts{octave});

                $names .= "-$new_chord";

                push @spec, [ $d->half, @notes ];
            }

If we have not decided to divide into half-notes, just add a whole-note to the score:

            else {
                push @spec, [ $d->whole, @notes ];
            }

Tell us what we've won, Bob!

            printf '%*d. %13s: %s', length($opts{bars}), $n + 1, $names, ddc(\@spec) if $opts{verbose};

Accumulate the note specifications:

            push @specs, @spec;
        }

Ok we made it! All chords accounted for!  Next up is to actually add them to the score.  This is done in a `for` loop for the number of repeats we (may or may not) have requested:

        for (1 .. $opts{repeat}) {
            $d->note(midi_format(@$_)) for @specs;
        }

Finally, the first chord of an imperfect cadence is added to the end:

        my $cadence = $mc->cadence(type => 'imperfect');
        $d->note($d->whole, $cadence->[0]->@*);
    }

For reference, here is the overly-complicated transposition subroutine:

    sub transposition {
        my ($transpose, $chord, $md) = @_;
        if ($transpose && $chord =~ /^([A-G][#b]?)(.*)$/) {
            my $note = $1; # the named note itself
            my $flav = $2; # the chord "flavor"
            my $transposed = $md->transpose($transpose, [$note]);
            (my $new_note = $transposed->[0]) =~ s/^([A-G][#b]?).*$/$1/;
            my $new_chord = $new_note . $flav;
            return $new_chord;
        }
        return $chord;
    }

And here are the actual chords for the seventh-chord, 12-bar blues:

    sub bars {
        no warnings qw(qw);
        return (
            [qw( C7 CM7 C#m7 )],
            [qw( C7 F7 Bm7 FM7 C#m7 )],
            [qw( C7 Am7 Em7 BM7 )],
            [qw( C7 Gm7 Dbm7 AbM7 )],
            [qw( F7 FM7 )],
            [qw( F7 Bb7 Gbm7 Gbdim7 Fm7 )],
            [qw( C7 Em7 EbM7 EM7 )],
            [qw( C7 A7 Bb7 Ebm7 Em7 )],
            [qw( G7 D7 Dm7 Ab7 DbM7 DM7 )],
            [qw( G7 F7 Abm7 Db7 Dm7 DbM7 )],
            [qw( C7 Em7 FM7 )],
            [qw( C7 G7 Dm7 Ab7 Abm7 DM7 )],
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
