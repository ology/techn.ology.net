---                                                                                                                                                                          
status: published
title: The Black Page (in Perl)
tags:
  - perl
  - MIDI
  - music
  - software
---

[![The-Black-Page-Original-sm.jpg](The-Black-Page-Original-sm.jpg)](The-Black-Page-Original.jpg)
I have a library of drummer tools, and Frank Zappa wrote [The Black Page](https://en.wikipedia.org/wiki/The_Black_Page) drum solo.  So... (tl;dr: [black-page](https://github.com/ology/MIDI-Drummer-Tiny/blob/master/eg/black-page) & mp3 at the bottom)

---
 **UPDATE:** I was informed that I was not using the original sheet music by FZ.  So I have modified the code, and have added it to this write-up. (Thanks [Scott](https://www.reddit.com/user/geoscott/)!)

~

I determined that I would code this up.

Here is [the transcription](Zappa-The-Black-Page-Terry-Bozzio.pdf) (PDF) by Phillip Albright, as played by Terry Bozzio that I coded first. And here are the first 9 bars:

![black-page-ex.png](black-page-ex.png)

This piece is not easy to play... The audio for that Bozzio revision is below.

But here are first six bars of the sheet music for [the "official" transcription](black-page-official-sheet-music.pdf):

![black-page-8-bars.png](black-page-8-bars.png)

...which includes this gem:

![holy-crap.png](holy-crap.png)

For the coding, a [MIDI::Drummer::Tiny](https://metacpan.org/pod/MIDI::Drummer::Tiny) object is created with a couple handfuls of custom musical durations via [Music::Duration](https://metacpan.org/pod/Music::Duration). These are added to the [MIDI-Perl](https://metacpan.org/dist/MIDI-Perl) known lengths list, and used to add notes and rests to the score.

By the way, I did **not** code any of the transcribed repeats. Also, these kit pieces are required: kick & snare, closed hi-hat, hi & low bongos, castanets (rendered as the closed hi-hat for my purposes), hi, mid, & low toms, plus the hi floor tom.

Ok the program begins thusly:

    #!/usr/bin/env perl
    use strict;
    use warnings;

...which is the traditional Perl preamble.

Next, we import the libraries and their functionality, that we will use:

    use MIDI::Drummer::Tiny ();
    use Music::Duration ();
    use MIDI::Util qw(dura_size);

For a `flam()`, define a volume accent value to use for the grace-note:

    use constant ACCENT => 70;

Alrighty then.  Time to instantiate a drummer object:

    my $d = MIDI::Drummer::Tiny->new(
        file   => "$0.mid",
        bpm    => 60,
        bars   => 30,
        reverb => 15,
    );

Now that we have that, we must create the custom note durations that Frank imagined:

    Music::Duration::tuplet($d->half,    'A', 5);  # Ahn
    Music::Duration::tuplet($d->eighth,  'B', 5);  # Ben
    Music::Duration::tuplet($d->quarter, 'C', 5);  # Cqn
    Music::Duration::tuplet($d->quarter, 'D', 7);  # Dqn
    Music::Duration::tuplet($d->quarter, 'E', 11); # Eqn
    Music::Duration::tuplet($d->quarter, 'F', 12); # Fqn

    my $ten = dura_size($d->triplet_eighth);
    Music::Duration::add_duration(Gten => $ten * 2); # Gten

    # for bar 5
    Music::Duration::tuplet($d->triplet_quarter, 'P', 5); # Ptqn
    Music::Duration::tuplet($d->triplet_quarter, 'Q', 6); # Qtqn

    # for bar 15
    my $thn = dura_size($d->triplet_half);
    Music::Duration::add_duration(Tthn => $thn / 2);      # Tthn
    Music::Duration::add_duration(Uthn => $thn / 7);      # Uthn
    my $half_thn = dura_size('Tthn');
    Music::Duration::add_duration(Vthn => $half_thn / 5); # Vthn
    Music::Duration::add_duration(Xthn => $half_thn / 4); # Xthn
    my $half_7thn = dura_size('Uthn');
    Music::Duration::add_duration(Wthn => $half_7thn / 2); # Wthn

Next, synchronize the patterns that add notes and rests to the score, so that they are played simultaneously:

    $d->sync(
        \&pulse, # not in the original but handy for debugging
        \&beat,
    );

The `pulse()` is the steady, quarter-note pedal hi-hat.  The `beat()` is everything else.

Finally, write the MIDI out to a file called "black-page.mid":

    $d->write;

Here is the `pulse()` subroutine:

    sub pulse {
        for my $i (1 .. $d->beats * $d->bars) {
            $d->note($d->quarter, $d->pedal_hh);
        }
    }

This (and `beat()` below) uses `$d` as a global variable. If this is too ugly for you, the drummer object can be passed into the subroutines, for the same effect, but with cleaner code.  For proper variable passing, please see [this simple example](https://github.com/ology/MIDI-Perl-HOWTO/blob/main/ex-02-02.pl).

Anyway, here is the beginning of the `beat()` subroutine:

    sub beat {
        # 1st measure:
        $d->note($d->quarter, $d->snare);

        $d->note($d->thirtysecond, $d->snare);
        $d->note($d->thirtysecond, $d->snare);
        $d->note($d->thirtysecond, $d->kick);
        $d->note($d->thirtysecond, $d->kick);
        $d->note($d->eighth, $d->snare);

        ...

This just adds notes, clusters of notes, and rests to the score.

To actually hear it, you have to use [timidity](https://timidity.sourceforge.net/) on the command-line or [VLC](https://www.videolan.org/vlc/).  Either of these programs can render to MP3 too.  Here's the timidity output of the Terry Bozzio version with exciting General MIDI patches:

[black-page.mp3](black-page.mp3)

The floor-tom rolls leave **much** to be desired.  So here is the same MIDI file, but imported into [my DAW](https://www.apple.com/logic-pro/) and given a better drum kit:

[The-Black-Page.mp3](The-Black-Page.mp3)

Nice.

For your pleasure, and critical comparison, here is Terry with Dweezil and crew:

[ZPZ](https://www.youtube.com/watch?v=aDQE82ElyJg)

**UPDATE** But I have found and re-coded the "official" version.  Here is the audio as rendered by timidity:

[black-page-ORIG.mp3](black-page-ORIG.mp3)

Personally, I like the Terry Bozzio version.
